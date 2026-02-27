package icanteen.samcejko.eu;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import androidx.core.app.NotificationCompat;

public class NotificationReceiver extends BroadcastReceiver {
    private static final String CHANNEL_ID = "icanteen_channel";

    @Override
    public void onReceive(Context context, Intent intent) {
        String mealText = intent.getStringExtra("mealText");
        if (mealText == null) mealText = "Neznámé jídlo";

        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        // Create channel for Android 8.0+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    CHANNEL_ID,
                    "Denní upozornění na oběd",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            channel.setDescription("Upozornění na dnešní oběd v 11:20");
            channel.enableLights(true);
            channel.setLightColor(Color.GREEN);
            channel.enableVibration(true);
            if (notificationManager != null) {
                notificationManager.createNotificationChannel(channel);
            }
        }

        // Tap action: open app
        Intent tapIntent = new Intent(context, MainActivity.class);
        tapIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(
                context, 
                0, 
                tapIntent, 
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_dialog_info) // Will need a better icon later, this is a fallback
                .setContentTitle("Dnešní oběd")
                .setContentText(mealText)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(mealText))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true);

        // unique ID for notification
        int notificationId = (int) System.currentTimeMillis();
        if (notificationManager != null) {
            notificationManager.notify(notificationId, builder.build());
        }
    }
}
