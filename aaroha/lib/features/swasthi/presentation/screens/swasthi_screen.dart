import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../models/chat_message.dart';
import '../services/groq_service.dart';
import '../../../../features/profile/data/profile_providers.dart';

class SwasthiScreen extends ConsumerStatefulWidget {
  const SwasthiScreen({super.key});

  @override
  ConsumerState<SwasthiScreen> createState() => _SwasthiScreenState();
}

class _SwasthiScreenState extends ConsumerState<SwasthiScreen> {
  final _textController  = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode       = FocusNode();
  final _groq            = GroqService();
  final List<ChatMessage> _messages = [];

  bool _isTyping    = false;
  int  _selectedMood = -1;

  static const int _streakDays = 12;

  static const _moods = [
    ('😰', 'Anxious'), ('😞', 'Low'), ('😐', 'Okay'), ('🙂', 'Good'), ('😊', 'Great'),
  ];

  static const _chips = [
    'Try grounding', 'Talk more', 'Breathwork', 'Craving help', 'I need hope',
  ];

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      "Namaste 🙏 I'm Swasthi, your Aaroha companion. "
      "This is a safe, private space — no judgement, just support. "
      "What's on your mind today?",
      time: DateTime.now().subtract(const Duration(minutes: 3)),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addBotMessage(String text, {DateTime? time}) {
    _messages.add(ChatMessage(text: text, isUser: false, time: time));
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isTyping) return;

    HapticFeedback.lightImpact();
    _textController.clear();
    _focusNode.unfocus();

    setState(() {
      _messages.add(ChatMessage(text: trimmed, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    // ── Stat: message sent ─────────────────────────────────
    await ref.read(statsProvider.notifier).chatMessageSent();

    final reply = await _groq.sendMessage(trimmed, streakDays: _streakDays);

    if (!mounted) return;
    setState(() {
      _addBotMessage(reply);
      _isTyping = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 340),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _onMoodTap(int index) {
    if (_selectedMood == index) return;
    setState(() => _selectedMood = index);
    HapticFeedback.selectionClick();
    // ── Stat: mood checkin ─────────────────────────────────
    ref.read(statsProvider.notifier).moodCheckin();
    _send("I'm feeling ${_moods[index].$2} today.");
  }

  void _resetConversation() {
    HapticFeedback.mediumImpact();
    _groq.clearHistory();
    setState(() {
      _messages.clear();
      _selectedMood = -1;
      _addBotMessage("Starting fresh 🌱 I'm here whenever you're ready.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      appBar: _SwasthiAppBar(onReset: _resetConversation),
      body: Column(
        children: [
          const _PrivacyBadge(),
          Expanded(child: _buildMessageList()),
          _SuggestionRow(chips: _chips, onTap: _send, enabled: !_isTyping),
          _MoodStrip(moods: _moods, selectedIndex: _selectedMood, onTap: _onMoodTap),
          _InputBar(
            controller: _textController,
            focusNode: _focusNode,
            isTyping: _isTyping,
            onSend: () => _send(_textController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final itemCount = _messages.length + (_isTyping ? 1 : 0);
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        if (i == _messages.length) return const _TypingBubble();
        return _ChatBubble(message: _messages[i])
            .animate()
            .fadeIn(duration: 240.ms)
            .slideY(begin: 0.06, curve: Curves.easeOutCubic);
      },
    );
  }
}

// ── AppBar ─────────────────────────────────────────────────────
class _SwasthiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onReset;
  const _SwasthiAppBar({required this.onReset});
  @override Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AarohaColors.background,
      elevation: 0,
      titleSpacing: 0,
      title: Row(children: [
        Container(width: 38, height: 38,
          decoration: BoxDecoration(color: AarohaColors.primaryContainer, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.self_improvement_rounded, color: AarohaColors.onPrimary, size: 20)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Swasthi', style: AarohaTextStyles.titleMd),
          Text('Your companion · Always here', style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.onSurfaceVariant, fontSize: 11)),
        ]),
      ]),
      actions: [
        IconButton(icon: const Icon(Icons.refresh_rounded, color: AarohaColors.onSurfaceVariant), onPressed: onReset),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _PrivacyBadge extends StatelessWidget {
  const _PrivacyBadge();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(color: AarohaColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AarohaConstants.radiusFull)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.lock_outline_rounded, size: 12, color: AarohaColors.outline),
          const SizedBox(width: 6),
          Text('Anonymous · Private · No data stored', style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline, fontSize: 11)),
        ]),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatBubble({required this.message});
  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) _Avatar(isUser: false),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AarohaColors.primary : AarohaColors.surfaceContainerLow,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18), topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(message.text, style: AarohaTextStyles.bodyMd.copyWith(
                  color: isUser ? AarohaColors.onPrimary : AarohaColors.onSurface, height: 1.5)),
                const SizedBox(height: 4),
                Text(message.formattedTime, style: AarohaTextStyles.bodySm.copyWith(
                  color: isUser ? AarohaColors.onPrimary.withOpacity(0.6) : AarohaColors.outline, fontSize: 10)),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _Avatar(isUser: true),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final bool isUser;
  const _Avatar({required this.isUser});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32, height: 32,
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: isUser ? AarohaColors.surfaceContainerHigh : AarohaColors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isUser ? Icons.person_rounded : Icons.self_improvement_rounded,
        color: isUser ? AarohaColors.onSurfaceVariant : AarohaColors.onPrimary,
        size: 17,
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        _Avatar(isUser: false),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: const BoxDecoration(
            color: AarohaColors.surfaceContainerLow,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18),
              bottomRight: Radius.circular(18), bottomLeft: Radius.circular(4)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) => Container(
              width: 7, height: 7,
              margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
              decoration: BoxDecoration(color: AarohaColors.primary.withOpacity(0.55), shape: BoxShape.circle),
            )
                .animate(onPlay: (c) => c.repeat())
                .scaleXY(begin: 0.6, end: 1.0, delay: Duration(milliseconds: i * 160), duration: 400.ms, curve: Curves.easeInOut)
                .then().scaleXY(end: 0.6, duration: 400.ms)),
          ),
        ),
      ]),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  final List<String> chips;
  final void Function(String) onTap;
  final bool enabled;
  const _SuggestionRow({required this.chips, required this.onTap, required this.enabled});
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => GestureDetector(
          onTap: enabled ? () { HapticFeedback.selectionClick(); onTap(chips[i]); } : null,
          child: AnimatedOpacity(
            opacity: enabled ? 1.0 : 0.45,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AarohaColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AarohaConstants.radiusFull),
                border: Border.all(color: AarohaColors.outlineVariant, width: 1),
              ),
              child: Text(chips[i], style: AarohaTextStyles.labelMd.copyWith(color: AarohaColors.onSurfaceVariant)),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodStrip extends StatelessWidget {
  final List<(String, String)> moods;
  final int selectedIndex;
  final void Function(int) onTap;
  const _MoodStrip({required this.moods, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(color: AarohaColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AarohaConstants.radiusMd)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('HOW ARE YOU FEELING?', style: AarohaTextStyles.overline.copyWith(color: AarohaColors.onSurfaceVariant, letterSpacing: 1.1)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: moods.asMap().entries.map((e) {
            final selected = e.key == selectedIndex;
            return GestureDetector(
              onTap: () => onTap(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200), curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: selected ? AarohaColors.primary.withOpacity(0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(fontSize: selected ? 28 : 22),
                    child: Text(e.value.$1)),
                  const SizedBox(height: 2),
                  Text(e.value.$2, style: AarohaTextStyles.bodySm.copyWith(
                    color: selected ? AarohaColors.primary : AarohaColors.outline,
                    fontSize: 10, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                ]),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isTyping;
  final VoidCallback onSend;
  const _InputBar({required this.controller, required this.focusNode, required this.isTyping, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, bottom + 10),
      color: AarohaColors.background,
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
          child: TextField(
            controller: controller, focusNode: focusNode, enabled: !isTyping,
            maxLines: 4, minLines: 1, textInputAction: TextInputAction.send,
            onSubmitted: (_) => onSend(),
            style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurface),
            decoration: InputDecoration(
              hintText: 'Share what\'s on your mind...',
              hintStyle: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.outline),
              filled: true, fillColor: AarohaColors.surfaceContainerLow,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AarohaConstants.radiusFull), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AarohaConstants.radiusFull), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AarohaConstants.radiusFull),
                borderSide: BorderSide(color: AarohaColors.primary.withOpacity(0.4), width: 1.5)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: isTyping ? null : onSend,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: isTyping ? AarohaColors.outline : AarohaColors.primary, shape: BoxShape.circle),
            child: Icon(isTyping ? Icons.hourglass_top_rounded : Icons.send_rounded, color: AarohaColors.onPrimary, size: 20),
          ),
        ),
      ]),
    );
  }
}
