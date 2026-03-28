/// Aaroha — App Constants
class AarohaConstants {
  AarohaConstants._();

  // ── App Identity ─────────────────────────────────────────
  static const String appName = 'Aaroha';
  static const String appTagline = 'Rise, one day at a time';

  // ── Spacing scale (8pt grid) ─────────────────────────────
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space6 = 6;
  static const double space8 = 8;
  static const double space10 = 10;
  static const double space12 = 12;
  static const double space14 = 14;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space56 = 56;
  static const double space64 = 64;
  static const double space80 = 80;   // hero bottom margin

  // ── Border radii ─────────────────────────────────────────
  static const double radiusSm = 8;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 32;  // xl = 1.5rem→24pt but design uses 2rem
  static const double radiusHero = 40;
  static const double radiusFull = 9999;

  // ── Elevation (Ambient Bloom spec) ───────────────────────
  // Blur: 24px | Opacity: 6% | Color: onSurface
  static const double ambientShadowBlur = 24;
  static const double ambientShadowOpacity = 0.06;

  // ── Crisis Helplines ─────────────────────────────────────
  static const List<Map<String, String>> helplines = [
    {'name': 'iCall',              'number': 'tel:9152987821',   'label': '9152987821'},
    {'name': 'NIMHANS',            'number': 'tel:08046110007',  'label': '080-46110007'},
    {'name': 'Vandrevala Foundation','number': 'tel:18005990019', 'label': '1800-599-0019', 'note': '24/7 Free'},
    {'name': 'NADA Helpline',      'number': 'tel:14446',        'label': '14446'},
  ];

  // ── Hive box names ────────────────────────────────────────
  static const String boxStreak    = 'aaroha_streak';
  static const String boxGoals     = 'aaroha_goals';
  static const String boxJournal   = 'aaroha_journal';
  static const String boxMoodLog   = 'aaroha_mood';
  static const String boxSettings  = 'aaroha_settings';

  // ── Hive type IDs ─────────────────────────────────────────
  static const int typeIdStreak    = 0;
  static const int typeIdGoal      = 1;
  static const int typeIdJournal   = 2;
  static const int typeIdMoodEntry = 3;
}
