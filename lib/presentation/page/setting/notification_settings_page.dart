import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/services/push_notification_service.dart';
import '../../providers/notification_settings_provider.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationSettingsProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(title: Text('notification_settings'.tr()), elevation: 0),
      body: ListView(
        children: [
          _buildSectionTitle(context, 'daily_forecasts'.tr()),
          SwitchListTile(
            title: Text('morning_forecast'.tr()),
            subtitle: Text('receive_daily_morning'.tr()),
            value: notificationProvider.morningForecastEnabled,
            onChanged:
                (value) =>
                    notificationProvider.setMorningForecastEnabled(value),
          ),
          ListTile(
            title: Text('morning_time'.tr()),
            trailing: Text(notificationProvider.morningTime),
            onTap:
                () => _selectTime(
                  context,
                  notificationProvider.morningTimeObj,
                  (time) => notificationProvider.setMorningTime(time),
                ),
          ),
          const Divider(),

          _buildSectionTitle(context, 'weather_alerts'.tr()),
          SwitchListTile(
            title: Text('severe_weather'.tr()),
            subtitle: Text('receive_severe_alerts'.tr()),
            value: notificationProvider.severeWeatherAlertsEnabled,
            onChanged:
                (value) =>
                    notificationProvider.setSevereWeatherAlertsEnabled(value),
          ),
          SwitchListTile(
            title: Text('rain_alerts'.tr()),
            subtitle: Text('receive_rain_alerts'.tr()),
            value: notificationProvider.rainAlertsEnabled,
            onChanged:
                (value) => notificationProvider.setRainAlertsEnabled(value),
          ),
          const Divider(),

          _buildSectionTitle(context, 'location_based'.tr()),
          SwitchListTile(
            title: Text('current_location'.tr()),
            subtitle: Text('updates_current_location'.tr()),
            value: notificationProvider.currentLocationEnabled,
            onChanged:
                (value) =>
                    notificationProvider.setCurrentLocationEnabled(value),
          ),

          ..._buildSavedCitiesSection(context, notificationProvider),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Widget> _buildSavedCitiesSection(
    BuildContext context,
    NotificationSettingsProvider provider,
  ) {
    final widgets = <Widget>[_buildSectionTitle(context, 'saved_cities'.tr())];

    for (final city in provider.savedCities) {
      widgets.add(
        SwitchListTile(
          title: Text(city),
          subtitle: Text('updates_for_city'.tr(args: [city])),
          value: provider.isCityEnabled(city),
          onChanged: (value) => provider.setCityEnabled(city, value),
        ),
      );
    }

    if (provider.savedCities.isEmpty) {
      widgets.add(
        ListTile(
          title: Text(
            'no_saved_cities'.tr(),
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }
}
