// Generates the source images of the launcher icon and the splash screen
// (US-6.1, CR-031) in assets/icon/.
//
// Usage (from the project root):
//   dart run tool/generate_icon_sources.dart
//   dart run flutter_launcher_icons
//   dart run flutter_native_splash:create
//
// Pure Dart (dart:io zlib + a minimal PNG encoder): no extra package needed.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

/// Theme seed color (AppTheme.seedColor), used as the icon background.
const _background = (r: 0x00, g: 0x69, b: 0x5C);
const _white = (r: 0xFF, g: 0xFF, b: 0xFF);

/// Supersampling factor per axis for anti-aliasing.
const _samples = 4;

// Motif geometry, as a fraction of the image side, centered. The outer extent
// (arc radius + arrowhead half-width = 0.28) stays inside the safe zones of
// the adaptive icon (0.305) and of the Android 12 splash icon (0.333).
const _arcRadius = 0.22;
const _arcHalfThickness = 0.0225;
const _arcStart = -50 * math.pi / 180;
const _arcEnd = 230 * math.pi / 180;
const _arrowHalfWidth = 0.06;
const _arrowLength = 22 * math.pi / 180;
const _coinRadius = 0.12;
const _coinRingInner = 0.085;
const _coinRingOuter = 0.10;

void main() {
  final dir = Directory('assets/icon')..createSync(recursive: true);
  _write('${dir.path}/icon.png', _render(1024, opaqueBackground: true));
  _write('${dir.path}/icon_foreground.png', _render(1024));
  _write('${dir.path}/icon_monochrome.png', _render(1024));
  _write('${dir.path}/splash.png', _render(1152));
}

void _write(String path, Uint8List bytes) {
  File(path).writeAsBytesSync(bytes);
  stdout.writeln('Written $path');
}

/// Whether the normalized point ([x], [y]) (center = 0, 0) is in the motif:
/// a coin surrounded by a circular arrow (lent money that comes back).
bool _inMotif(double x, double y) {
  final d = math.sqrt(x * x + y * y);

  // Coin: disc with a cut-out ring.
  if (d <= _coinRadius && !(d >= _coinRingInner && d <= _coinRingOuter)) {
    return true;
  }

  // Arc (y axis points down: increasing angles turn clockwise).
  var angle = math.atan2(y, x);
  if (angle < _arcStart) angle += 2 * math.pi;
  if ((d - _arcRadius).abs() <= _arcHalfThickness &&
      angle >= _arcStart &&
      angle <= _arcEnd) {
    return true;
  }

  // Arrowhead at the end of the arc, pointing clockwise.
  (double, double) polar(double r, double a) =>
      (r * math.cos(a), r * math.sin(a));
  return _inTriangle(
    (x, y),
    polar(_arcRadius - _arrowHalfWidth, _arcEnd),
    polar(_arcRadius + _arrowHalfWidth, _arcEnd),
    polar(_arcRadius, _arcEnd + _arrowLength),
  );
}

bool _inTriangle(
  (double, double) p,
  (double, double) a,
  (double, double) b,
  (double, double) c,
) {
  double side((double, double) p1, (double, double) p2, (double, double) p3) =>
      (p1.$1 - p3.$1) * (p2.$2 - p3.$2) - (p2.$1 - p3.$1) * (p1.$2 - p3.$2);
  final d1 = side(p, a, b);
  final d2 = side(p, b, c);
  final d3 = side(p, c, a);
  final hasNegative = d1 < 0 || d2 < 0 || d3 < 0;
  final hasPositive = d1 > 0 || d2 > 0 || d3 > 0;
  return !(hasNegative && hasPositive);
}

/// Renders the white motif as RGBA, on a transparent background or on the
/// theme color when [opaqueBackground] is true.
Uint8List _render(int size, {bool opaqueBackground = false}) {
  final rgba = Uint8List(size * size * 4);
  for (var py = 0; py < size; py++) {
    for (var px = 0; px < size; px++) {
      var hits = 0;
      for (var sy = 0; sy < _samples; sy++) {
        for (var sx = 0; sx < _samples; sx++) {
          final x = (px + (sx + 0.5) / _samples) / size - 0.5;
          final y = (py + (sy + 0.5) / _samples) / size - 0.5;
          if (_inMotif(x, y)) hits++;
        }
      }
      final coverage = hits / (_samples * _samples);
      final i = (py * size + px) * 4;
      if (opaqueBackground) {
        int mix(int bg, int fg) => (bg + (fg - bg) * coverage).round();
        rgba[i] = mix(_background.r, _white.r);
        rgba[i + 1] = mix(_background.g, _white.g);
        rgba[i + 2] = mix(_background.b, _white.b);
        rgba[i + 3] = 0xFF;
      } else {
        rgba[i] = _white.r;
        rgba[i + 1] = _white.g;
        rgba[i + 2] = _white.b;
        rgba[i + 3] = (coverage * 0xFF).round();
      }
    }
  }
  return _encodePng(size, size, rgba);
}

/// Minimal PNG encoder: 8-bit RGBA, no filtering.
Uint8List _encodePng(int width, int height, Uint8List rgba) {
  final raw = BytesBuilder();
  for (var y = 0; y < height; y++) {
    raw
      ..addByte(0)
      ..add(rgba.sublist(y * width * 4, (y + 1) * width * 4));
  }
  final header = ByteData(13)
    ..setUint32(0, width)
    ..setUint32(4, height)
    ..setUint8(8, 8) // bit depth
    ..setUint8(9, 6) // color type: RGBA
    ..setUint8(10, 0)
    ..setUint8(11, 0)
    ..setUint8(12, 0);
  return (BytesBuilder()
        ..add([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
        ..add(_chunk('IHDR', header.buffer.asUint8List()))
        ..add(_chunk('IDAT', ZLibCodec(level: 9).encode(raw.takeBytes())))
        ..add(_chunk('IEND', const [])))
      .takeBytes();
}

List<int> _chunk(String type, List<int> data) {
  final typeBytes = type.codeUnits;
  final length = ByteData(4)..setUint32(0, data.length);
  final crc = ByteData(4)..setUint32(0, _crc32([...typeBytes, ...data]));
  return [
    ...length.buffer.asUint8List(),
    ...typeBytes,
    ...data,
    ...crc.buffer.asUint8List(),
  ];
}

int _crc32(List<int> bytes) {
  var crc = 0xFFFFFFFF;
  for (final byte in bytes) {
    crc ^= byte;
    for (var k = 0; k < 8; k++) {
      crc = (crc & 1) != 0 ? (crc >> 1) ^ 0xEDB88320 : crc >> 1;
    }
  }
  return crc ^ 0xFFFFFFFF;
}
