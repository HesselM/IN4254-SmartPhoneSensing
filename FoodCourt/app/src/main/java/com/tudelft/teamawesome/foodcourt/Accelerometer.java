package com.tudelft.teamawesome.foodcourt;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

/**
 *
 */
public class Accelerometer implements SensorEventListener {

    protected SensorManager sm;
    protected Sensor sensor;
    protected int run;
    protected MotionType motion;
    protected dbAPI dbapi;

    public Accelerometer(SensorManager sm){
        this.sm = sm;
        sensor = sm.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);
        run = 0;
    }

    //set database
    public void setDatabaseAPI(dbAPI dbapi) {
        this.dbapi = dbapi;

        // update run
        run = dbapi.getMaxRun();
    }

    //update motion on change
    public void onMotionTypeChange(MotionType motion){
        this.motion = motion;
    }

    //return run number
    public int getRun(){ return run; }
    public void setRun(int run){ this.run = run; }


    //start accelerometer
    public void start() {
        //new run
        run = run + 1;
        //start listening
        sm.registerListener(this, sensor, SensorManager.SENSOR_DELAY_GAME);

    }

    //stop accelerometer
    public void stop() {
        sm.unregisterListener(this);
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy){

    }

    @Override
    public void onSensorChanged(SensorEvent event){

        // Create a new map of values, where column names are the keys
        ContentValues values = new ContentValues();
        values.put(dbContract.AccelTable.COLUMN_NAME_RUN        , this.run);
        values.put(dbContract.AccelTable.COLUMN_NAME_TIMESTAMP  , event.timestamp);
        values.put(dbContract.AccelTable.COLUMN_NAME_ACCURACY   , event.accuracy);
        values.put(dbContract.AccelTable.COLUMN_NAME_MOTIONTYPE , this.motion.getValue());
        values.put(dbContract.AccelTable.COLUMN_NAME_X          , event.values[0]);
        values.put(dbContract.AccelTable.COLUMN_NAME_Y          , event.values[1]);
        values.put(dbContract.AccelTable.COLUMN_NAME_Z          , event.values[2]);

        //insert data
        dbapi.insert(dbContract.AccelTable.TABLE_NAME, values);
    }


}
