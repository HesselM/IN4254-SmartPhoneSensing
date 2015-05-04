package com.tudelft.teamawesome.foodcourt;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

/**
 * Created by Electroozz on 04/05/15.
 */
public class Accelerometer implements SensorEventListener {

    protected SensorManager sm;
    protected Sensor sensor;
    protected int run;
    protected MotionType motion;

    public Accelerometer(SensorManager sm){
        this.sm = sm;
        this.sensor = sm.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);

        //TODO auto-init. Determine run from DB
        run = 0;
    }

    //update motion on change
    public void onMotionTypeChange(MotionType motion){
        this.motion = motion;
    }

    //return run number
    public int getRun(){
        return run;
    }

    //start accelerometer
    public void start() {
        sm.registerListener(this, this.sensor, SensorManager.SENSOR_DELAY_GAME);
    }

    //stop accelerometer
    public void stop() {
        sm.unregisterListener(this);

    }

    @Override
    public void onAccuracyChanged(Sensor sensor,int accuracy){

    }

    @Override
    public void onSensorChanged(SensorEvent event){

    }


}
