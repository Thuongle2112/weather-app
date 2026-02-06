import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../../../core/services/map_location_service.dart';
import '../../../data/model/location/selected_location.dart';
import '../../providers/theme_provider.dart';

class MapLocationPickerScreen extends StatefulWidget {
  const MapLocationPickerScreen({super.key});

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  MapLibreMapController? _mapController;
  LatLng _selectedPosition = const LatLng(21.0285, 105.8542);
  String _displayName = 'select_location_on_map'.tr();
  bool _isLoading = true;
  bool _isLoadingName = false;
  Symbol? _marker;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _isRelocating = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    final position = await MapLocationService.getCurrentLocation();

    if (position != null && mounted) {
      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
      });
      _updateLocationInfo(_selectedPosition);
    } else {
      _updateLocationInfo(_selectedPosition);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
    _addMarker(_selectedPosition);
  }

  Future<void> _addMarker(LatLng position) async {
    if (_mapController == null) return;

    if (_marker != null) {
      await _mapController!.removeSymbol(_marker!);
    }

    _marker = await _mapController!.addSymbol(
      SymbolOptions(
        geometry: position,
        iconImage: 'marker-15',
        iconSize: 2.0,
        draggable: true,
      ),
    );
  }

  Future<void> _updateLocationInfo(LatLng position) async {
    setState(() {
      _isLoadingName = true;
      _selectedPosition = position;
    });

    await _addMarker(position);

    _mapController?.animateCamera(CameraUpdate.newLatLng(position));

    final name = await MapLocationService.getPlaceNameFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (mounted) {
      setState(() {
        _displayName = name;
        _isLoadingName = false;
      });
    }
  }

  void _onMapTap(Point<double> point, LatLng position) {
    _updateLocationInfo(position);
  }

  void _onConfirm() {
    final location = SelectedLocation(
      latitude: _selectedPosition.latitude,
      longitude: _selectedPosition.longitude,
      displayName: _displayName,
    );
    Navigator.pop(context, location);
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_mapController != null) {
      _mapController = null;
    }
    super.dispose();
  }

  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final results = await MapLocationService.searchLocations(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  void _selectSearchResult(dynamic result) {
    final position = LatLng(result.latitude, result.longitude);
    _updateLocationInfo(position);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 14));
    setState(() {
      _searchResults = [];
      _searchController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _relocateToCurrentPosition() async {
    setState(() {
      _isRelocating = true;
    });

    final position = await MapLocationService.getCurrentLocation();

    if (position != null && mounted) {
      final newPosition = LatLng(position.latitude, position.longitude);
      _updateLocationInfo(newPosition);
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14));
    }

    if (mounted) {
      setState(() {
        _isRelocating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[100],
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            MapLibreMap(
              styleString:
                  'https://tiles.locationiq.com/v3/streets/vector.json?key=${dotenv.env['LOCATIONIQ_API_KEY'] ?? ''}',
              initialCameraPosition: CameraPosition(
                target: _selectedPosition,
                zoom: 14,
              ),
              onMapCreated: _onMapCreated,
              onMapClick: _onMapTap,
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.none,
            ),

          Positioned(
            top: 50.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              children: [
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(30.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'search_location'.tr(),
                              hintStyle: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color:
                                    isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h,
                              ),
                            ),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              fontSize: 16.sp,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            onChanged: (value) {
                              if (value.length > 2) {
                                _searchLocation(value);
                              } else {
                                setState(() {
                                  _searchResults = [];
                                });
                              }
                            },
                          ),
                        ),
                        if (_isSearching)
                          SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.blue,
                            ),
                          )
                        else if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 20.sp,
                              color:
                                  isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchResults = [];
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                  ),
                ),
                if (_searchResults.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 8.h),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            isDarkMode ? 0.3 : 0.15,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(maxHeight: 250.h),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: _searchResults.length,
                      separatorBuilder:
                          (context, index) => Divider(
                            height: 1,
                            color:
                                isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                            indent: 16.w,
                            endIndent: 16.w,
                          ),
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(
                                isDarkMode ? 0.2 : 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 20.sp,
                            ),
                          ),
                          title: Text(
                            result.displayName,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => _selectSearchResult(result),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Relocate to current position button
          Positioned(
            bottom: 200.h,
            right: 16.w,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(30.r),
              child: InkWell(
                onTap: _isRelocating ? null : _relocateToCurrentPosition,
                borderRadius: BorderRadius.circular(30.r),
                child: Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: _isRelocating
                      ? Padding(
                          padding: EdgeInsets.all(16.w),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.blue,
                          ),
                        )
                      : Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 28.sp,
                        ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 24.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   'selected_location'.tr(),
                              //   style: Theme.of(context).textTheme.bodyMedium,
                              // ),
                              // SizedBox(height: 4.h),
                              _isLoadingName
                                  ? SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          isDarkMode
                                              ? Colors.white
                                              : Colors.blue,
                                    ),
                                  )
                                  : Text(
                                    _displayName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 8.h),
                    // Text(
                    //   '${_selectedPosition.latitude.toStringAsFixed(4)}, ${_selectedPosition.longitude.toStringAsFixed(4)}',
                    //   style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    //     fontSize: 12.sp,
                    //     color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    //   ),
                    // ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: _isLoadingName ? null : _onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDarkMode
                                  ? const Color(0xFF1976D2)
                                  : Colors.blue,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'confirm_location'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
