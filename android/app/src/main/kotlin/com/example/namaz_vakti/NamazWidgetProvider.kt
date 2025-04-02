package com.example.namaz_vakti

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import com.example.namaz_vakti.R

class NamazWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

            val views = RemoteViews(context.packageName, R.layout.namaz_widget)

            views.setTextViewText(R.id.time_fajr, "İmsak: ${prefs.getString("fajr", "--:--")}")
            views.setTextViewText(R.id.time_dhuhr, "Öğle: ${prefs.getString("dhuhr", "--:--")}")
            views.setTextViewText(R.id.time_asr, "İkindi: ${prefs.getString("asr", "--:--")}")
            views.setTextViewText(R.id.time_maghrib, "Akşam: ${prefs.getString("maghrib", "--:--")}")
            views.setTextViewText(R.id.time_isha, "Yatsı: ${prefs.getString("isha", "--:--")}")

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
