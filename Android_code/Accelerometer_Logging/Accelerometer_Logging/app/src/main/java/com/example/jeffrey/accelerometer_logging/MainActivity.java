package com.example.jeffrey.accelerometer_logging;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.util.Date;


public class MainActivity extends ActionBarActivity implements SensorEventListener {

    private RadioGroup statusButtonGroup;
    private RadioButton StatusButton;

    private SensorManager mSensorManager;
    private Sensor mAccelerometer;

    String currentDateTimeString;

    /*Values used for the xyz directions of the accelerometer*/
    float xVal = 0;
    float yVal = 0;
    float zVal = 0;

    /** variable used to indicated Walking, Rest or Queuing movement
     * it's an integer so we can plot in the graph later.
     * 1 = Rest
     * 2 = Queing
     * 3 = Walking
     */
    int sampleNumber = 0;
    int statusVal = 1;

    TextView AccelerometerValTextView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        statusButtonGroup = (RadioGroup) findViewById(R.id.statusButtonGroup);


        /*View and buttons declarations*/
        AccelerometerValTextView = (TextView) findViewById(R.id.AccelerometerValTextView);


        /*Create instances needed for measuring */
        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);

        /*write lines to idintify log file*/
        currentDateTimeString = DateFormat.getDateTimeInstance().format(new Date());
        String firstLogRow = "statvalue 1:rest, 2:Queuing, 3:walking.";
        appendLog(firstLogRow);
        String secondLogRow = "SampleNum " + "statValue" + "X " + "Y " + "Z ";
        appendLog(secondLogRow);
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
        String logString = createLogString();
        writeToScreen(logString);
        appendLog(logString);
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {
        //nothing to do here
    }

    public void onRadioButtonClicked(View view) {
        // Is the button now checked?
        boolean checked = ((RadioButton) view).isChecked();

        // Check which radio button was clicked
        switch(view.getId()) {
            case R.id.Resting:
                if (checked) {
                    statusVal = 1;
                }
                break;
            case R.id.Queuing:
                if (checked) {
                    statusVal = 2;
                }
                    break;
            case R.id.Walking:
                if (checked) {
                  statusVal = 3;
                }
                break;
         }
    }

    /**
     * method created to write the logstring in such a way that it's easy to plot
     * a graph of the data in libre office 'calculator'
     * @return string for writing in the logfile.
     */
    private String createLogString() {
        sampleNumber += 1;
        String sampleNum = Integer.toString(sampleNumber);
        String statValue = Integer.toString(statusVal);
        String xValue = Float.toString(xVal);
        String yValue = Float.toString(yVal);
        String zValue = Float.toString(zVal);
        String string = sampleNum + ' ' + statValue +' ' + xValue + ' ' + yValue + ' ' + zValue;
        return string;
    }

    /**
     * Method created to write the x, y and z values to
     * the text views
     */
    private void writeToScreen(String string) {

        AccelerometerValTextView.setText(string);
    }

    public void appendLog(String text)
    {
        File logFile = new File("sdcard/log" + currentDateTimeString + ".txt");

        if (!logFile.exists())
        {
            try
            {
                logFile.createNewFile();
            }
            catch (IOException e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        try
        {
            //BufferedWriter for performance, true to set append to file flag
            BufferedWriter buf = new BufferedWriter(new FileWriter(logFile, true));
            buf.append(text);
            buf.newLine();
            buf.close();
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

}
