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
            try {
                updateAppWidget(context, appWidgetManager, appWidgetId)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to update widget $appWidgetId", e)
            }
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        Log.d(TAG, "Updating widget $appWidgetId")
        
        val views = try {
            RemoteViews(context.packageName, R.layout.weather_widget)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to inflate layout: ${e.message}")
            return
        }

        try {
            // Get data from shared preferences
            val widgetData = HomeWidgetPlugin.getData(context)
            
            val city = widgetData.getString("city", null) ?: "Loading..."
            val temperature = widgetData.getInt("temperature", 0)
            val description = widgetData.getString("description", null) ?: "Tap to update"
            val humidity = widgetData.getInt("humidity", 0)
            val windSpeed = widgetData.getFloat("windSpeed", 0.0f)
            val lastUpdate = widgetData.getLong("lastUpdate", 0)

            Log.d(TAG, "Widget data loaded: city=$city, temp=$temperature, desc=$description")

            // Update UI safely
            try {
                views.setTextViewText(R.id.widget_city, city)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to set city: ${e.message}")
            }

            try {
                views.setTextViewText(R.id.widget_temperature, "${temperature}°")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to set temperature: ${e.message}")
            }

            try {
                views.setTextViewText(R.id.widget_description, description)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to set description: ${e.message}")
            }

            try {
                views.setTextViewText(
                    R.id.widget_details,
                    "💧 ${humidity}% | 💨 ${windSpeed.toInt()} km/h"
                )
            } catch (e: Exception) {
                Log.e(TAG, "Failed to set details: ${e.message}")
            }
            
            // Format last update time
            try {
                val updateText = if (lastUpdate > 0) {
                    val diff = (System.currentTimeMillis() - lastUpdate) / 1000 / 60
                    when {
                        diff < 1 -> "Just now"
                        diff < 60 -> "${diff}m ago"
                        else -> "${diff / 60}h ago"
                    }
                } else {
                    "Tap to update"
                }
                views.setTextViewText(R.id.widget_last_update, updateText)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to set update time: ${e.message}")
            }

            // Set click listener
            try {
                val intent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    putExtra("launched_from", "widget")
                }
                
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    appWidgetId,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                
                views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to set click listener: ${e.message}")
            }

            // Apply update
            appWidgetManager.updateAppWidget(appWidgetId, views)
            Log.d(TAG, "Widget $appWidgetId updated successfully")
            
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widget $appWidgetId: ${e.message}", e)
            e.printStackTrace()
        }
    }

    override fun onEnabled(context: Context) {
        Log.d(TAG, "Widget enabled")
    }

    override fun onDisabled(context: Context) {
        Log.d(TAG, "Widget disabled")
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        Log.d(TAG, "Widget deleted: ${appWidgetIds.joinToString()}")
    }
}