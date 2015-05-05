package com.tudelft.teamawesome.foodcourt;

import android.content.Context;
import android.hardware.SensorManager;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.RadioButton;
import android.widget.TextView;


public class MainActivity extends ActionBarActivity {
    //global var to track selected activity
    private MotionType selectedMotionType;

    // Manager for sensors
    private SensorManager mSensorManager;
    private Accelerometer accelerometer;

    // API for database
    private DatabaseAPI dbAPI;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //open db-API
        dbAPI = new DatabaseAPI(this);

        //setup Accelerometer
        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        accelerometer = new Accelerometer(mSensorManager);
        accelerometer.setDatabaseAPI(dbAPI);

        //setup initial values
        selectedMotionType = MotionType.IDLE;
        accelerometer.onMotionTypeChange(selectedMotionType);

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


    //Called when a different activity is selected
    public void activityChanged(View view) {
        // Is the button now checked?
        boolean checked = ((RadioButton) view).isChecked();

        // Check which radio button was clicked
        switch(view.getId()) {
            case R.id.rad_ActStatusIdle:
                if (checked) {
                    selectedMotionType = MotionType.IDLE;
                }
                break;
            case R.id.rad_ActStatusQueueing:
                if (checked) {
                    selectedMotionType = MotionType.QUEUEING;
                }
                break;
            case R.id.rad_ActStatusWalking:
                if (checked) {
                    selectedMotionType = MotionType.WALKING;
                }
                break;
        }

        //update selected motion in accelerometer
        accelerometer.onMotionTypeChange(selectedMotionType);
    }

    //Controls to start/stop accelerometer
    public void startAccel(View view) {
        accelerometer.start();
        this.showAccelData();
    }

    public void stopAccel(View view) {
        accelerometer.stop();
        this.showAccelData();
    }

    //db-actions from interface
    public void dbReset(View view){
        dbAPI.reset();
        accelerometer.setRun(0);
        this.showAccelData();
    }

    public void dbLastData(View view){
        this.showAccelData();
    }

    public void dbExport(View view){
        dbAPI.exportAccelTable();
    }



    //test function to display data on screen from database
    public void showAccelData(){
        TextView txtAccel = (TextView) findViewById(R.id.txt_Accel);
        CharSequence text;
        text = "max run:" + dbAPI.getMaxRun() + "/" + accelerometer.getRun() + "\n";
        text = text + "records:" + dbAPI.getRecordCount() + "\n";
        text = text + "motionType:" + selectedMotionType.getValue() + "\n";
        txtAccel.setText(text);
    }
}
