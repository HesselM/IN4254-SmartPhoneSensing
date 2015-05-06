package com.tudelft.teamawesome.foodcourt;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

/**
 *
 */
public class Accelerometer implements SensorEventListener {
    private int samplingPeriodUs = 20000; // microseconds, 20.000us = 50Hz


    protected SensorManager sm;
    protected Sensor sensor;
    protected int run;
    protected MotionType motion;
    protected DatabaseAPI dbAPI;

    public Accelerometer(SensorManager sm){
        this.sm = sm;
        sensor = sm.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);
        run = 0;
    }

    //set database acces
    public void setDatabaseAPI(DatabaseAPI dbAPI) {
        this.dbAPI = dbAPI;
        // update run
        run = dbAPI.getMaxRun();
    }

    //update motion on change
    public void onMotionTypeChange(MotionType motion){
        this.motion = motion;
    }

    //get/set run-number
    public int getRun(){ return run; }
    public void setRun(int run){ this.run = run; }

    //start accelerometer
    public void start() {
        //new run
        run = run + 1;
        //start listening
        sm.registerListener(this, sensor, samplingPeriodUs);
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

        // Create struct for accel readings.
        RecordAccelAct record = new RecordAccelAct(this.run, event.timestamp, event.accuracy,
                    this.motion.getValue(), event.values[0], event.values[1], event.values[2]);

        //insert data
        dbAPI.insertAccelAct(record);
    }


}
