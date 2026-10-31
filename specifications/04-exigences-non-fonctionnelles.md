# 04 — Exigences non fonctionnelles

| ID | Exigence |
|---|---|
| **ENF-01** Confidentialité | Données stockées uniquement sur l'appareil. L'APK release ne déclare **pas** la permission `INTERNET` (seuls les builds debug Flutter l'ont, pour le hot reload). Aucun SDK tiers de télémétrie, publicité ou analytics. |
| **ENF-02** Sauvegarde cloud système | Sauvegarde automatique Android désactivée (`allowBackup=false`) : les données ne quittent l'appareil que par un export manuel volontaire (voir Q-04). |
| **ENF-03** Hors ligne | 100 % des fonctionnalités disponibles sans réseau. |
| **ENF-04** Performance | Démarrage à froid < 1,5 s sur le S22 ; affichage du tableau de bord < 300 ms avec 500 prêts. |
| **ENF-05** Fiabilité des calculs | Montants en entiers (unités mineures) : aucune erreur d'arrondi. Calculs couverts par des tests unitaires. |
| **ENF-06** Intégrité | Les opérations multi-tables (suppression en cascade, import) sont transactionnelles : tout ou rien. |
| **ENF-07** Évolutivité du schéma | Les évolutions de la base passent par des migrations de base de données testées ; aucune perte de données lors d'une mise à jour de l'APK. |
| **ENF-08** Ergonomie | Material 3, mode clair/sombre, couleurs dynamiques (Material You via `dynamic_color`), tailles de police système respectées, zones tactiles ≥ 48 dp. |
| **ENF-09** Langue | Interface en français. |
| **ENF-10** Appareil | Optimisé pour Samsung Galaxy S22 (écran 6,1", Android 14+), utilisable en portrait. minSdk 26 pour garder une marge. |
| **ENF-11** Distribution | APK release signé avec une clé personnelle, installable en mise à jour sur la version précédente (même clé de signature obligatoire). |
| **ENF-12** Coût | Aucun coût : outils et bibliothèques gratuits et open source, pas de compte développeur Play Store. |
