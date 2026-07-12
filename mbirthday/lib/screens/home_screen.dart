import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/balloon_widget.dart';
import '../widgets/pulsing_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _unlocked = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  static const _portraitUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAL2YL1BjSQoQxHZyNEaj4Cnq0dWDDiBTWw2m_dVauabTlmxROiihz-qOeFjdyVNAFk1w-7_9XNwOmx-3g_2gu_KX4L9M2Y58nUheHq2PL9Ek2WSI7okN-UfWxcJl0owXfUk8mbkRLIeb44fAt3LXSJdydiL83cQ_nb98jJtHR-130Y8fUevXq4UfwI_vSSl_7WAjpYwUzY4eNlk2ejmprbTqGNQ2c_Fawk2uv0_2lqYJyDOWTkyqdv5O20D4L0xHoCjdrM26Y9Q-Nn';

  static const _birthdaySongUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  static const _messageText =
      "I don't feel like I am in the right person to wish you happy "
      "birthday because you are most beautiful and awesome women I have "
      "never met. You are still in that part of my heart since the day we "
      "met and I still think I am not worthy of you and I also care about "
      "you even if I am not there. But I am really happy knowing that you "
      "are happy. Happy birthday MATSHINGA";

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    setState(() => _unlocked = true);
    try {
      await _audioPlayer.play(UrlSource(_birthdaySongUrl));
    } catch (_) {
      // Autoplay can be blocked by the platform; ignore silently like the
      // original web version does.
    }
  }

  Future<void> _openWhatsApp(String message) async {
    final uri = Uri.parse(
      'https://wa.me/243977853370?text=${Uri.encodeComponent(message)}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(isMobile),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: _unlocked ? _buildSurprise() : _buildHero(isMobile),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Balloon celebration overlay
          Positioned.fill(child: BalloonOverlay(active: _unlocked)),
        ],
      ),
      bottomNavigationBar: isMobile ? _buildBottomNav() : null,
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.celebration, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'Curated Celebration',
            style: AppTextStyles.headlineMd().copyWith(
              fontStyle: FontStyle.italic,
              fontSize: 22,
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            Text('Surprise',
                style: AppTextStyles.bodyMd(color: AppColors.primary)
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(width: 32),
            Text('Memory', style: AppTextStyles.bodyMd(color: AppColors.onSurfaceVariant)),
            const SizedBox(width: 32),
            Text('Message', style: AppTextStyles.bodyMd(color: AppColors.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }

  Widget _buildHero(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Silver-bordered framed portrait ("The Medallion" styling)
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryContainer,
                  AppColors.primaryFixed,
                  Color(0xFFBFC8CE),
                  AppColors.primary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              color: AppColors.surface,
              child: ClipRRect(
                child: Image.network(
                  _portraitUrl,
                  width: isMobile ? 256 : 320,
                  height: isMobile ? 320 : 384,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: isMobile ? 256 : 320,
                    height: isMobile ? 320 : 384,
                    color: AppColors.surfaceContainer,
                    child: const Icon(Icons.person, size: 80, color: AppColors.outline),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'MATSHINGA BOPE Merdi',
            textAlign: TextAlign.center,
            style: isMobile ? AppTextStyles.displayLgMobile() : AppTextStyles.displayLg(),
          ),
          const SizedBox(height: 8),
          Text(
            'THE ESSENCE OF ELEGANCE',
            style: AppTextStyles.labelCaps().copyWith(letterSpacing: 3),
          ),
          const SizedBox(height: 40),
          PulsingUnlockButton(onTap: _unlock),
        ],
      ),
    );
  }

  Widget _buildSurprise() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          children: [
            // Message card (glass panel)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withOpacity(0.1),
                    blurRadius: 50,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.format_quote,
                      size: 48, color: AppColors.primaryContainer.withOpacity(0.2)),
                  Text(
                    _messageText,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineMd(color: AppColors.onSurfaceVariant)
                        .copyWith(fontStyle: FontStyle.italic, fontSize: 20, height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    height: 1,
                    width: 96,
                    color: AppColors.primaryContainer.withOpacity(0.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Action buttons
            Wrap(
              spacing: 24,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      _openWhatsApp('I am satisfied with your beautiful surprise'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.sentiment_very_satisfied),
                  label: const Text('I am satisfied'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _openWhatsApp(
                      'It is not enough to make me happy or forget what you did to me'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.sentiment_dissatisfied),
                  label: const Text('It is not enough...'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.card_giftcard, label: 'Surprise', selected: true),
          const _NavItem(icon: Icons.auto_awesome, label: 'Memory', selected: false),
          const _NavItem(icon: Icons.chat_bubble, label: 'Message', selected: false),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected});

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.onPrimaryFixed : AppColors.onSurfaceVariant;
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelCaps(color: color).copyWith(fontSize: 10)),
      ],
    );

    if (!selected) return child;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed,
        borderRadius: BorderRadius.circular(999),
      ),
      child: child,
    );
  }
}
