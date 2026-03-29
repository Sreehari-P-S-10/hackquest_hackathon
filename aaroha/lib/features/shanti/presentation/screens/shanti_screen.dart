import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../profile/data/profile_providers.dart';

enum BreathMode { breathing478, box }

class ShantiScreen extends ConsumerStatefulWidget {
  const ShantiScreen({super.key});
  @override
  ConsumerState<ShantiScreen> createState() => _ShantiScreenState();
}

class _ShantiScreenState extends ConsumerState<ShantiScreen> with TickerProviderStateMixin {
  bool _isBreathing = false;
  String _breatheLabel = 'Breathe In…';
  BreathMode _breathMode = BreathMode.breathing478;
  late AnimationController _breathCtrl;
  late Animation<double> _breathScale;
  Timer? _breathTimer;
  int _breathPhase = 0;

  final FlutterTts _tts = FlutterTts();
  bool _voiceEnabled = true;

  final List<AudioPlayer> _soundPlayers = List.generate(4, (_) => AudioPlayer());
  final Set<int> _activeSounds = {};

  static const _soundAssets = [
    'assets/audio/rain.mp3', 'assets/audio/forest.mp3',
    'assets/audio/ocean.mp3', 'assets/audio/night.mp3',
  ];

  static const _soundscapes = [
    ('Rain', Icons.water_drop_rounded), ('Forest', Icons.forest_rounded),
    ('Ocean', Icons.waves_rounded),     ('Night', Icons.nights_stay_rounded),
  ];

  final _journalCtrl = TextEditingController();

  static const _phases478 = [
    (4, 'Breathe In…', 'Breathe in'), (7, 'Hold…', 'Hold'),
    (8, 'Breathe Out…', 'Breathe out'), (2, 'Hold…', 'Hold'),
  ];
  static const _phasesBox = [
    (4, 'Breathe In…', 'Breathe in'), (4, 'Hold…', 'Hold'),
    (4, 'Breathe Out…', 'Breathe out'), (4, 'Hold…', 'Hold'),
  ];

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _breathScale = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _breathCtrl, curve: Curves.easeInOut));
    _initTts();
    _initAudioPlayers();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-IN');
    await _tts.setSpeechRate(0.42);
    await _tts.setVolume(1.0);
    await _tts.setPitch(0.95);
  }

  Future<void> _initAudioPlayers() async {
    for (final player in _soundPlayers) {
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(0.6);
    }
  }

  @override
  void dispose() {
    _breathCtrl.dispose();
    _breathTimer?.cancel();
    _journalCtrl.dispose();
    _tts.stop();
    for (final p in _soundPlayers) p.dispose();
    super.dispose();
  }

  Future<void> _toggleSound(int index) async {
    HapticFeedback.selectionClick();
    final player = _soundPlayers[index];
    if (_activeSounds.contains(index)) {
      await player.stop();
      setState(() => _activeSounds.remove(index));
    } else {
      try {
        await player.play(AssetSource(_soundAssets[index].replaceFirst('assets/', '')));
        setState(() => _activeSounds.add(index));
        // ── Stat: soundscape played ──────────────────────
        await ref.read(statsProvider.notifier).soundscapePlayed();
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${_soundscapes[index].$1} audio not found. Drop "${_soundAssets[index]}" into assets/audio/.'),
            duration: const Duration(seconds: 4),
          ));
        }
      }
    }
  }

  void _toggleBreath() {
    HapticFeedback.mediumImpact();
    setState(() => _isBreathing = !_isBreathing);
    if (_isBreathing) {
      // ── Stat: breathwork session started ──────────────
      ref.read(statsProvider.notifier).breathworkStarted();
      _runBreathCycle();
    } else {
      _breathCtrl.stop();
      _breathTimer?.cancel();
      _tts.stop();
      setState(() => _breatheLabel = 'Breathe In…');
    }
  }

  void _runBreathCycle() {
    _breathPhase = 0;
    final phases = _breathMode == BreathMode.breathing478 ? _phases478 : _phasesBox;
    _nextPhase(phases);
  }

  void _nextPhase(List<(int, String, String)> phases) {
    if (!_isBreathing) return;
    final phaseIndex = _breathPhase % phases.length;
    final (secs, uiLabel, ttsText) = phases[phaseIndex];
    setState(() => _breatheLabel = uiLabel);
    if (phaseIndex == 0) _breathCtrl.forward(from: 0);
    else if (phaseIndex == 2) _breathCtrl.reverse(from: 1);
    if (_voiceEnabled) {
      _tts.stop().then((_) {
        final duration = secs == 1 ? '1 second' : '$secs seconds';
        _tts.speak('$ttsText… for $duration');
      });
    }
    _breathTimer = Timer(Duration(seconds: secs), () {
      _breathPhase++;
      if (_isBreathing) _nextPhase(phases);
    });
  }

  void _switchBreathMode(BreathMode mode) {
    if (_isBreathing) {
      _breathCtrl.stop();
      _breathTimer?.cancel();
      _tts.stop();
      setState(() { _isBreathing = false; _breatheLabel = 'Breathe In…'; });
    }
    setState(() => _breathMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Text('Shanti Space', style: AarohaTextStyles.headlineMd).animate().fadeIn(),
          Text('Your sanctuary for calm and clarity.',
            style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurfaceVariant))
            .animate(delay: 50.ms).fadeIn(),

          const SizedBox(height: 16),

          _BreathModeToggle(selected: _breathMode, onSelect: _switchBreathMode)
              .animate(delay: 80.ms).fadeIn(),

          const SizedBox(height: 20),

          _BreathworkOrb(
            scale: _breathScale, label: _breatheLabel, isActive: _isBreathing,
            mode: _breathMode, voiceEnabled: _voiceEnabled,
            onToggle: _toggleBreath,
            onVoiceToggle: () {
              setState(() => _voiceEnabled = !_voiceEnabled);
              if (!_voiceEnabled) _tts.stop();
            },
          ).animate(delay: 100.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),

          const SizedBox(height: 32),
          const SectionHeader(title: 'Calm Tools'),
          const SizedBox(height: 12),
          const _CalmToolsGrid().animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 24),
          _SoundscapeCard(soundscapes: _soundscapes, active: _activeSounds, onToggle: _toggleSound)
              .animate(delay: 280.ms).fadeIn(),

          const SizedBox(height: 24),
          _CravingJournal(
            controller: _journalCtrl,
            // ── Stat: craving journal entry saved ────────
            onRelease: () async {
              if (_journalCtrl.text.trim().isNotEmpty) {
                await ref.read(statsProvider.notifier).cravingJournalSaved();
              }
              _journalCtrl.clear();
              HapticFeedback.mediumImpact();
            },
          ).animate(delay: 340.ms).fadeIn(),

          const SizedBox(height: 20),
          // const GradientButton(
          //   label: 'Start Body Scan Guide',
          //   icon: Icons.accessibility_new_rounded,
          // ).animate(delay: 400.ms).fadeIn(),
        ],
      ),
    );
  }
}

// ── Breath mode toggle ────────────────────────────────────────
class _BreathModeToggle extends StatelessWidget {
  final BreathMode selected;
  final ValueChanged<BreathMode> onSelect;
  const _BreathModeToggle({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AarohaColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusFull),
      ),
      child: Row(children: [
        _ModeChip(label: '4-7-8 Breathing', isSelected: selected == BreathMode.breathing478, onTap: () => onSelect(BreathMode.breathing478)),
        _ModeChip(label: 'Box Breathing',   isSelected: selected == BreathMode.box,           onTap: () => onSelect(BreathMode.box)),
      ]),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label; final bool isSelected; final VoidCallback onTap;
  const _ModeChip({required this.label, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AarohaColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AarohaConstants.radiusFull)),
        child: Text(label, textAlign: TextAlign.center,
          style: AarohaTextStyles.labelMd.copyWith(color: isSelected ? AarohaColors.onPrimary : AarohaColors.onSurfaceVariant)),
      ),
    ));
  }
}

// ── Breathwork Orb ────────────────────────────────────────────
class _BreathworkOrb extends StatelessWidget {
  final Animation<double> scale;
  final String label;
  final bool isActive;
  final BreathMode mode;
  final bool voiceEnabled;
  final VoidCallback onToggle;
  final VoidCallback onVoiceToggle;
  const _BreathworkOrb({required this.scale, required this.label, required this.isActive, required this.mode, required this.voiceEnabled, required this.onToggle, required this.onVoiceToggle});

  String get _modeDescription => mode == BreathMode.breathing478 ? '4-7-8 technique' : 'Box breathing • 4-4-4-4';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(width: 220, height: 220,
        child: Stack(alignment: Alignment.center, children: [
          ...List.generate(3, (i) => AnimatedBuilder(animation: scale,
            builder: (_, __) => Container(
              width: 140.0 + (i * 28) + (scale.value - 0.85) * 60,
              height: 140.0 + (i * 28) + (scale.value - 0.85) * 60,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: AarohaColors.primaryContainer.withOpacity(0.08 - i * 0.02))))).reversed,
          AnimatedBuilder(animation: scale,
            builder: (_, child) => Transform.scale(scale: scale.value, child: child),
            child: Container(width: 108, height: 108,
              decoration: BoxDecoration(gradient: AarohaColors.heroGradientAngled, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AarohaColors.primary.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))]),
              child: const Icon(Icons.air_rounded, color: AarohaColors.onPrimary, size: 44))),
        ])),
      const SizedBox(height: 12),
      Text(label, style: AarohaTextStyles.titleMd.copyWith(color: AarohaColors.onSurface)),
      Text(_modeDescription, style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              gradient: isActive ? null : AarohaColors.heroGradientAngled,
              color: isActive ? AarohaColors.surfaceContainerHigh : null,
              borderRadius: BorderRadius.circular(AarohaConstants.radiusFull),
              boxShadow: isActive ? null : [BoxShadow(color: AarohaColors.primary.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))]),
            child: Text(isActive ? 'Stop' : 'Start Breathing',
              style: AarohaTextStyles.labelLg.copyWith(color: isActive ? AarohaColors.onSurface : AarohaColors.onPrimary)),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onVoiceToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200), width: 44, height: 44,
            decoration: BoxDecoration(
              color: voiceEnabled ? AarohaColors.primary.withOpacity(0.12) : AarohaColors.surfaceContainerHigh,
              shape: BoxShape.circle),
            child: Icon(
              voiceEnabled ? Icons.record_voice_over_rounded : Icons.voice_over_off_rounded,
              color: voiceEnabled ? AarohaColors.primary : AarohaColors.outline, size: 20),
          ),
        ),
      ]),
      if (isActive) ...[
        const SizedBox(height: 10),
        Text(voiceEnabled ? 'Voice guidance on' : 'Voice guidance off',
          style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
      ],
    ]);
  }
}

// ── Calm Tools Grid ───────────────────────────────────────────
class _CalmToolsGrid extends StatelessWidget {
  const _CalmToolsGrid();
  @override
  Widget build(BuildContext context) {
    final tools = [
      ('Box Breathing', '4-4-4-4 cycle', Icons.crop_square_rounded, AarohaColors.mintSurface, AarohaColors.primaryContainer),
];
    return Row(children: tools.map((t) => Expanded(
      child: Container(
        margin: EdgeInsets.only(right: t == tools.last ? 0 : 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: t.$4, borderRadius: BorderRadius.circular(AarohaConstants.radiusXl)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(t.$3, color: t.$5, size: 28),
          const SizedBox(height: 12),
          Text(t.$1, style: AarohaTextStyles.labelLg.copyWith(color: t.$5)),
          Text(t.$2, style: AarohaTextStyles.bodySm.copyWith(color: t.$5.withOpacity(0.7))),
        ]),
      ),
    )).toList());
  }
}

// ── Soundscape Card ───────────────────────────────────────────
class _SoundscapeCard extends StatelessWidget {
  final List<(String, IconData)> soundscapes;
  final Set<int> active;
  final void Function(int) onToggle;
  const _SoundscapeCard({required this.soundscapes, required this.active, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AarohaColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AarohaConstants.radiusXl)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.music_note_rounded, color: AarohaColors.primary, size: 22),
          const SizedBox(width: 10),
          Text('Soothing Soundscapes', style: AarohaTextStyles.titleMd.copyWith(color: AarohaColors.onSurface)),
        ]),
        const SizedBox(height: 6),
        Text('Add .mp3 files to assets/audio/ to enable.', style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline, fontStyle: FontStyle.italic)),
        const SizedBox(height: 14),
        Wrap(spacing: 8, runSpacing: 8,
          children: soundscapes.asMap().entries.map((entry) {
            final i = entry.key; final s = entry.value;
            final isActive = active.contains(i);
            return GestureDetector(
              onTap: () => onToggle(i),
              child: AnimatedContainer(duration: 200.ms,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AarohaColors.primary : AarohaColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AarohaConstants.radiusFull)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(s.$2, size: 16, color: isActive ? AarohaColors.onPrimary : AarohaColors.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(s.$1, style: AarohaTextStyles.labelMd.copyWith(color: isActive ? AarohaColors.onPrimary : AarohaColors.onSurfaceVariant)),
                ]),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}

// ── Craving Journal ───────────────────────────────────────────
// Now accepts an onRelease callback so the screen can track stats.
class _CravingJournal extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onRelease;
  const _CravingJournal({required this.controller, required this.onRelease});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AarohaColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AarohaConstants.radiusXl)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.edit_note_rounded, color: AarohaColors.primary, size: 22),
          const SizedBox(width: 10),
          Text('Craving Journal', style: AarohaTextStyles.titleMd.copyWith(color: AarohaColors.onSurface)),
        ]),
        const SizedBox(height: 12),
        TextField(
          controller: controller, maxLines: 4,
          style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurface, height: 1.6),
          decoration: InputDecoration(
            hintText: 'What triggered this craving? Writing it down helps release its grip…',
            hintStyle: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.outline),
            filled: true, fillColor: AarohaColors.surfaceContainer,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Anonymous · not saved', style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
          GestureDetector(
            onTap: onRelease,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AarohaColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AarohaConstants.radiusFull)),
              child: Text('Release it', style: AarohaTextStyles.labelMd.copyWith(color: AarohaColors.primary)),
            ),
          ),
        ]),
      ]),
    );
  }
}
