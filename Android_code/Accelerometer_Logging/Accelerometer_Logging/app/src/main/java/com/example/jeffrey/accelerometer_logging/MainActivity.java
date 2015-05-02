package com.example.jeffrey.accelerometer_logging;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;


public class MainActivity extends ActionBarActivity implements SensorEventListener {

    private SensorManager mSensorManager;
    private Sensor mAccelerometer;

    float xVal = 0;
    float yVal = 0;
    float zVal = 0;

    TextView AccelerometerValTextView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        AccelerometerValTextView = (TextView) findViewById(R.id.AccelerometerValTextView);

        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onPause() {
        super.onPause();
        mSensorManager.unregisterListener(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_NORMAL);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        xVal = event.values[0];
        yVal = event.values[1];
        zVal = event.values[2];
        writeToScreen();
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {
        //nothing to do here
    }

    /**
     * Method created to write the x, y and z values to
     * the text views
     */
    private void writeToScreen() {
        String xValue = Float.toString(xVal);
        String yValue = Float.toString(yVal);
        String zValue = Float.toString(zVal);
        String string = "X:" + xValue + ' ' + "Y:" + yValue + ' ' + "Z:" + zValue;
        AccelerometerValTextView.setText(string);

    }
}
