package com.zamoon6.weather_today

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import android.app.PendingIntent
import android.util.Log

class WeatherWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "WeatherWidget"
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "onUpdate called for ${appWidgetIds.size} widgets")
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        try {
            val views = RemoteViews(context.packageName, R.layout.weather_widget)

            // Get data from shared preferences with null safety
            val widgetData = HomeWidgetPlugin.getData(context)
            
            val city = widgetData.getString("city", null) ?: "Loading..."
            val temperature = widgetData.getInt("temperature", 25)
            val description = widgetData.getString("description", null) ?: "Tap to update"
            val humidity = widgetData.getInt("humidity", 0)
            val windSpeed = widgetData.getFloat("windSpeed", 0.0f)
            val lastUpdate = widgetData.getLong("lastUpdate", 0)

            Log.d(TAG, "Widget data: $city $temperature° $description")

            // Update UI with null-safe data
            views.setTextViewText(R.id.widget_city, city)
            views.setTextViewText(R.id.widget_temperature, "${temperature}°")
            views.setTextViewText(R.id.widget_description, description)
            views.setTextViewText(
                R.id.widget_details,
                "Humidity: ${humidity}% | Wind: ${windSpeed.toInt()} km/h"
            )
            
            // Format last update time
            val updateText = if (lastUpdate > 0) {
                val diff = (System.currentTimeMillis() - lastUpdate) / 1000 / 60
                when {
                    diff < 1 -> "Just now"
                    diff < 60 -> "Updated: ${diff}m ago"
                    else -> "Updated: ${diff / 60}h ago"
                }
            } else {
                "Tap to update"
            }
            views.setTextViewText(R.id.widget_last_update, updateText)

            // Set click listener to open app
            val intent = Intent(context, MainActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            
            val pendingIntent = PendingIntent.getActivity(
                context,
                appWidgetId, // Use unique request code
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            
            // Make entire widget clickable
            views.setOnClickPendingIntent(R.id.widget_city, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
            Log.d(TAG, "Widget $appWidgetId updated successfully")
            
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widget $appWidgetId", e)
            // Don't crash, just show error state
            showErrorState(context, appWidgetManager, appWidgetId)
        }
    }

    private fun showErrorState(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        try {
            val views = RemoteViews(context.packageName, R.layout.weather_widget)
            views.setTextViewText(R.id.widget_city, "Error")
            views.setTextViewText(R.id.widget_temperature, "--°")
            views.setTextViewText(R.id.widget_description, "Tap to retry")
            views.setTextViewText(R.id.widget_details, "")
            views.setTextViewText(R.id.widget_last_update, "")
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to show error state", e)
        }
    }

    override fun onEnabled(context: Context) {
        Log.d(TAG, "Widget enabled (first widget added)")
    }

    override fun onDisabled(context: Context) {
        Log.d(TAG, "Widget disabled (last widget removed)")
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        Log.d(TAG, "Widget deleted: ${appWidgetIds.joinToString()}")
    }
}