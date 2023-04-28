/*
 * MIT License
 *
 * Copyright (c) 2021 Trần Mạnh Cường <maytinhdibo>
 *               2023 Forked & modified by lahaina
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package jp.project2by2.AODHelperService;

import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.provider.Settings;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.IBinder;
import android.util.Log;
import java.util.Timer;
import java.util.TimerTask;

public class DozeCustomService extends Service {
    private static final String TAG = "AODHelperService";
    private static final boolean DEBUG = true;
    
    private static final long dozeInterval = 4000;

    private boolean isSensorRunning = false;
    private boolean isTimerRunning = false;

    SensorManager sensorManager;
    Sensor proximitySensor;
    Timer timer;
    Context mContext;

    @Override
    public void onCreate() {
        if (DEBUG) Log.d(TAG, "Creating service");
        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        proximitySensor = sensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY);

        mContext = this;

        IntentFilter screenStateFilter = new IntentFilter();
        screenStateFilter.addAction(Intent.ACTION_SCREEN_ON);
        screenStateFilter.addAction(Intent.ACTION_SCREEN_OFF);
        screenStateFilter.addAction(Intent.ACTION_USER_PRESENT);
        registerReceiver(mScreenStateReceiver, screenStateFilter);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (DEBUG) Log.d(TAG, "Starting service");
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        if (DEBUG) Log.d(TAG, "Destroying service");
        this.unregisterReceiver(mScreenStateReceiver);
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void disableSensor() {
        if (!isSensorRunning) return;
        if (DEBUG) Log.d(TAG, "Disable proximity sensor");
        sensorManager.unregisterListener(proximitySensorEventListener, proximitySensor);
        isSensorRunning = false;
    }

    private void enableSensor() {
        if (isSensorRunning) return;
        if (DEBUG) Log.d(TAG, "Enable proximity sensor");
        sensorManager.registerListener(proximitySensorEventListener,
                proximitySensor,
                SensorManager.SENSOR_DELAY_NORMAL);
        isSensorRunning = true;
    }
    
    private boolean getAodFlag() {
        return Settings.Secure.getInt(mContext.getContentResolver(), Settings.Secure.DOZE_ALWAYS_ON, 0) != 0;
    }
    
    private void setAodFlag(boolean enable) {
        int value = enable ? 1 : 0;
        // Set AOD settings.
        Settings.Secure.putInt(mContext.getContentResolver(), Settings.Secure.DOZE_ALWAYS_ON, value);
    }
    
    private void startRepeatDozing() {
        if (isTimerRunning) return;
        
        if (DEBUG) Log.d(TAG, "Started timer.");
        timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            public void run() {
                if (getAodFlag()) pulseDoze();
            }
        }, 0, dozeInterval);
        isTimerRunning = true;
    }
    
    private void stopRepeatDozing() {
        if (!isTimerRunning) return;
        
        if (DEBUG) Log.d(TAG, "Stopped timer.");
        timer.cancel();
        isTimerRunning = false;
    }
    
    private void pulseDoze() {
        // Pulse it the doze.
        Intent intent = new Intent("com.android.systemui.doze.pulse");
        intent.setPackage("com.android.systemui");
        mContext.sendBroadcast(intent);
    }
    
    private BroadcastReceiver mScreenStateReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(Intent.ACTION_SCREEN_ON) || intent.getAction().equals(Intent.ACTION_USER_PRESENT)) {
                stopRepeatDozing();
                disableSensor();
            } else if (intent.getAction().equals(Intent.ACTION_SCREEN_OFF)) {
                if (getAodFlag()) {
                    enableSensor();
                    startRepeatDozing();
                }
            }
        }
    };

    SensorEventListener proximitySensorEventListener = new SensorEventListener() {
        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {
            // Method to check accuracy changed in sensor.
        }
        
        @Override
        public void onSensorChanged(SensorEvent event) {
            // Check if the sensor type is proximity sensor.
            if (event.sensor.getType() == Sensor.TYPE_PROXIMITY) {
                float distance = event.values[0];
                
                // Is proximity sensor detecting?
                if (distance >= proximitySensor.getMaximumRange()) {
                    Log.d(TAG, "Proximity sensor is FAR. Performing doze pulse.");
                    pulseDoze();
                }
            }
        }
    };
}
