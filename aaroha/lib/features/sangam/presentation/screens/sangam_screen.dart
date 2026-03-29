import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../domain/resource_model.dart';

class SangamScreen extends StatefulWidget {
  const SangamScreen({super.key});

  @override
  State<SangamScreen> createState() => _SangamScreenState();
}

class _SangamScreenState extends State<SangamScreen> {
  int _filterIndex = 0;
  final _filters = ['All', 'Hospitals', 'NGOs', 'Events', 'Rehab'];

  // Map controller
  final MapController _mapController = MapController();

  // Location state
  Position? _userPosition;
  bool _locationLoading = true;
  String? _locationError;

  // Default centre — Thrissur, Kerala
  static const _defaultCenter = LatLng(10.5276, 76.2144);

  List<RecoveryCenter> get _centres => ResourceRepository.keralaCenters;
  List<RecoveryEvent> get _events => ResourceRepository.upcomingEvents;

  List<RecoveryCenter> get _filteredCentres {
    if (_filterIndex == 0) return _centres;
    final typeMap = {1: 'hospital', 2: 'ngo', 4: 'rehab'};
    final type = typeMap[_filterIndex];
    if (type == null) return _centres;
    return _centres.where((c) => c.type == type).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _locationLoading = true;
      _locationError = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services disabled.';
          _locationLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Location permission denied. Tap Retry.';
          _locationLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (!mounted) return;
      setState(() {
        _userPosition = position;
        _locationLoading = false;
      });

      // Fly map camera to user
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        13,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _locationError = 'Could not get location. Tap Retry.';
        _locationLoading = false;
      });
    }
  }

  Future<void> _call(String tel) async {
    final uri = Uri.parse(tel);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openDirections(RecoveryCenter centre) async {
    if (centre.lat == null || centre.lng == null) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${centre.lat},${centre.lng}',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          // ── Header ────────────────────────────────────────
          Text('Sangam + Sahara', style: AarohaTextStyles.headlineMd)
              .animate().fadeIn(),
          Text(
            'Deaddiction centres & events near you.',
            style: AarohaTextStyles.bodyMd.copyWith(
              color: AarohaColors.onSurfaceVariant,
            ),
          ).animate(delay: 50.ms).fadeIn(),

          const SizedBox(height: 14),

          // ── Filter chips ──────────────────────────────────
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => AarohaFilterChip(
                label: _filters[i],
                isSelected: _filterIndex == i,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _filterIndex = i);
                },
              ),
            ),
          ).animate(delay: 80.ms).fadeIn(),

          const SizedBox(height: 20),

          // ── OpenStreetMap ─────────────────────────────────
          _OSMMapCard(
            mapController: _mapController,
            centres: _centres,
            userPosition: _userPosition,
            locationLoading: _locationLoading,
            locationError: _locationError,
            defaultCenter: _defaultCenter,
            onRetry: _fetchLocation,
            onMyLocation: () {
              if (_userPosition != null) {
                _mapController.move(
                  LatLng(_userPosition!.latitude, _userPosition!.longitude),
                  14,
                );
              } else {
                _fetchLocation();
              }
            },
          ).animate(delay: 120.ms).fadeIn(),

          const SizedBox(height: 24),

          // ── Nearby Centres ────────────────────────────────
          SectionHeader(
            title: 'Centres near you',
            actionLabel: 'View all',
          ).animate(delay: 180.ms).fadeIn(),
          const SizedBox(height: 12),

          ..._filteredCentres.asMap().entries.map((entry) {
            final i = entry.key;
            final c = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CentreCard(
                centre: c,
                onCall: () => _call(c.phone),
                onDirections: () => _openDirections(c),
              )
                  .animate(delay: Duration(milliseconds: 200 + i * 60))
                  .fadeIn()
                  .slideX(begin: 0.03),
            );
          }),

          const SizedBox(height: 24),

          // ── Upcoming Events ───────────────────────────────
          const SectionHeader(title: 'Upcoming Events')
              .animate(delay: 380.ms).fadeIn(),
          const SizedBox(height: 12),

          ..._events.asMap().entries.map((entry) {
            final i = entry.key;
            final e = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _EventTile(event: e)
                  .animate(delay: Duration(milliseconds: 400 + i * 60))
                  .fadeIn(),
            );
          }),

          const SizedBox(height: 24),

          // ── Helpline Banner ───────────────────────────────
          _HelplineBanner(onCall: _call).animate(delay: 500.ms).fadeIn(),
        ],
      ),
    );
  }
}

// ── OSM Map Card ──────────────────────────────────────────────
class _OSMMapCard extends StatelessWidget {
  final MapController mapController;
  final List<RecoveryCenter> centres;
  final Position? userPosition;
  final bool locationLoading;
  final String? locationError;
  final LatLng defaultCenter;
  final VoidCallback onRetry;
  final VoidCallback onMyLocation;

  const _OSMMapCard({
    required this.mapController,
    required this.centres,
    required this.userPosition,
    required this.locationLoading,
    required this.locationError,
    required this.defaultCenter,
    required this.onRetry,
    required this.onMyLocation,
  });

  // Colour per type
  Color _markerColor(String type) {
    switch (type) {
      case 'hospital': return Colors.green;
      case 'ngo':      return Colors.orange;
      case 'rehab':    return Colors.red;
      default:         return Colors.grey;
    }
  }

  IconData _markerIcon(String type) {
    switch (type) {
      case 'hospital': return Icons.local_hospital_rounded;
      case 'ngo':      return Icons.volunteer_activism_rounded;
      case 'rehab':    return Icons.healing_rounded;
      default:         return Icons.location_on_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AarohaConstants.radiusXl),
      child: SizedBox(
        height: 240,
        child: Stack(
          children: [
            // ── flutter_map with OpenStreetMap tiles ─────────
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: userPosition != null
                    ? LatLng(userPosition!.latitude, userPosition!.longitude)
                    : defaultCenter,
                initialZoom: 11,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom |
                         InteractiveFlag.drag,
                ),
              ),
              children: [
                // OSM tile layer — completely free
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.aaroha.app',
                ),

                // Centre markers
                MarkerLayer(
                  markers: [
                    // User location dot
                    if (userPosition != null)
                      Marker(
                        point: LatLng(
                          userPosition!.latitude,
                          userPosition!.longitude,
                        ),
                        width: 32,
                        height: 32,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Recovery centre markers
                    ...centres
                        .where((c) => c.lat != null && c.lng != null)
                        .map((c) => Marker(
                              point: LatLng(c.lat!, c.lng!),
                              width: 40,
                              height: 48,
                              child: Tooltip(
                                message: '${c.name}\n${c.statusLabel}',
                                child: Column(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: _markerColor(c.type),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _markerColor(c.type)
                                                .withValues(alpha: 0.4),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        _markerIcon(c.type),
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    // Pin tail
                                    Container(
                                      width: 2,
                                      height: 8,
                                      color: _markerColor(c.type),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                  ],
                ),
              ],
            ),

            // ── Loading indicator ─────────────────────────────
            if (locationLoading)
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AarohaColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Finding your location…',
                          style: AarohaTextStyles.bodySm.copyWith(
                            color: AarohaColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Error banner ──────────────────────────────────
            if (locationError != null && !locationLoading)
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AarohaColors.tertiary.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_off_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          locationError!,
                          style: AarohaTextStyles.bodySm.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onRetry,
                        child: Text(
                          'Retry',
                          style: AarohaTextStyles.labelMd.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── My Location button ────────────────────────────
            Positioned(
              bottom: 12,
              right: 12,
              child: GestureDetector(
                onTap: onMyLocation,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.my_location_rounded,
                    color: AarohaColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),

            // ── Legend ────────────────────────────────────────
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LegendDot(color: Colors.green,  label: 'Hospital'),
                    const SizedBox(width: 8),
                    _LegendDot(color: Colors.orange, label: 'NGO'),
                    const SizedBox(width: 8),
                    _LegendDot(color: Colors.red,    label: 'Rehab'),
                    const SizedBox(width: 8),
                    _LegendDot(color: Colors.blue,   label: 'You'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AarohaTextStyles.bodySm.copyWith(
            fontSize: 10,
            color: AarohaColors.onSurface,
          ),
        ),
      ],
    );
  }
}

// ── Centre Card ───────────────────────────────────────────────
class _CentreCard extends StatelessWidget {
  final RecoveryCenter centre;
  final VoidCallback onCall;
  final VoidCallback onDirections;
  const _CentreCard({
    required this.centre,
    required this.onCall,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AarohaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: centre.isOpen
                  ? AarohaColors.mintSurface
                  : AarohaColors.tertiaryFixed.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              centre.isOpen
                  ? Icons.local_hospital_rounded
                  : Icons.healing_rounded,
              color: centre.isOpen
                  ? AarohaColors.primaryContainer
                  : AarohaColors.tertiary,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        centre.name,
                        style: AarohaTextStyles.labelLg.copyWith(
                          color: AarohaColors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: centre.isOpen
                            ? AarohaColors.primaryContainer
                                .withValues(alpha: 0.12)
                            : AarohaColors.tertiary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        centre.statusLabel.toUpperCase(),
                        style: AarohaTextStyles.overline.copyWith(
                          color: centre.isOpen
                              ? AarohaColors.primaryContainer
                              : AarohaColors.tertiary,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: AarohaColors.outline, size: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        centre.address,
                        style: AarohaTextStyles.bodySm.copyWith(
                          color: AarohaColors.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onCall,
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: AarohaColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.call_rounded,
                                  color: AarohaColors.onPrimary, size: 16),
                              const SizedBox(width: 4),
                              Text('Call',
                                  style: AarohaTextStyles.labelMd.copyWith(
                                    color: AarohaColors.onPrimary,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onDirections,
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: AarohaColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.directions_rounded,
                            color: AarohaColors.primary, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Event Tile ────────────────────────────────────────────────
class _EventTile extends StatelessWidget {
  final RecoveryEvent event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AarohaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 52,
            decoration: BoxDecoration(
              gradient: AarohaColors.heroGradientAngled,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  event.formattedDay,
                  style: AarohaTextStyles.headlineSm.copyWith(
                    color: AarohaColors.onPrimary,
                    fontSize: 20,
                  ),
                ),
                Text(
                  event.formattedMonth.toUpperCase(),
                  style: AarohaTextStyles.overline.copyWith(
                    color: AarohaColors.onPrimary.withValues(alpha: 0.8),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: AarohaTextStyles.labelLg.copyWith(
                      color: AarohaColors.onSurface,
                    )),
                const SizedBox(height: 2),
                Text(
                  '${event.formattedTime} · ${event.modeLabel}',
                  style: AarohaTextStyles.bodySm.copyWith(
                    color: AarohaColors.outline,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AarohaColors.primary.withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(AarohaConstants.radiusFull),
            ),
            child: Text('Join',
                style: AarohaTextStyles.labelMd.copyWith(
                  color: AarohaColors.primary,
                )),
          ),
        ],
      ),
    );
  }
}

// ── Helpline Banner ───────────────────────────────────────────
class _HelplineBanner extends StatelessWidget {
  final Future<void> Function(String) onCall;
  const _HelplineBanner({required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AarohaColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.support_agent_rounded,
                  color: AarohaColors.tertiary, size: 22),
              const SizedBox(width: 10),
              Text('Helpline — One Tap',
                  style: AarohaTextStyles.titleMd.copyWith(
                    color: AarohaColors.onSurface,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => onCall('tel:18005990019'),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AarohaColors.surfaceContainerLowest,
                borderRadius:
                    BorderRadius.circular(AarohaConstants.radiusMd),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VANDREVALA FOUNDATION',
                            style: AarohaTextStyles.overline.copyWith(
                              color: AarohaColors.tertiary,
                            )),
                        Text('1800-599-0019',
                            style: AarohaTextStyles.labelLg.copyWith(
                              color: AarohaColors.onSurface,
                              fontWeight: FontWeight.w700,
                            )),
                        Text('24/7 · Free',
                            style: AarohaTextStyles.bodySm.copyWith(
                              color: AarohaColors.outline,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AarohaColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.call_rounded,
                        color: AarohaColors.primary, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}