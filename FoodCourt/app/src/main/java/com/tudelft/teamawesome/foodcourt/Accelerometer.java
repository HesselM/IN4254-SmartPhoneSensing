package com.tudelft.teamawesome.foodcourt;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.widget.Toast;

/**
 *
 */
public class Accelerometer implements SensorEventListener {

    //sampling speed
    private final int  samplingPeriodUs = 20000;   // microseconds, 20.000us = 50Hz

    //sample collection maintainence for calibration
    // samples between lower- and upper- bound are used for bias estimation.
    // With 50Hz, the linear-filter needs roughly 1000 samples to reach a steady state.
    private final int collectedSamples_lowerBound = 1000;
    private final int collectedSamples_upperBound = 1500;
    private int collectedSamples = 0;       // number of collected samples in a run

    //flags to determine operation of accelerometer
    private boolean listening = false;
    private boolean calibrate = false;
    private boolean logdata   = false;

    //globals
    protected SensorManager sm;
    protected Sensor sensor;
    protected int run;
    protected MotionType motion;
    protected DatabaseAPI dbAPI;
    protected Context appContext;
    protected float[] accelBias = {0.0f, 0.0f, 0.0f};

    public Accelerometer(SensorManager sm, Context appContext){
        this.appContext = appContext;
        this.sm = sm;
        sensor = sm.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);
        run = 0;
    }

    //set database acces
    public void setDatabaseAPI(DatabaseAPI dbAPI) {
        this.dbAPI = dbAPI;
        // update run
        run = dbAPI.getMaxRun();
        //get bias
        accelBias = dbAPI.getAccelBias();
    }

    //update motion on change
    public void onMotionTypeChange(MotionType motion){
        this.motion = motion;
    }

    //get/set run-number
    public int getRun(){ return run; }
    public void setRun(int run){ this.run = run; }

    //calibrate accelerometer
    public void doCalibration() {
        //clear database
        dbAPI.resetAccelBias();

        //set flags: data needs to be logged and system is doing calibration
        this.startAccel(true, true);

        //message user calibration has started
        Toast toast = Toast.makeText(this.appContext, "Calibration has started", Toast.LENGTH_SHORT);
        toast.show();
    }

    //start accelerometer for retrieving data for classification
    public void start() {
        //new run
        run = run + 1;

        //set flags: data needs to be logged and system is not doing calibration
        this.startAccel(true, false);
    }

    //start accelerometer
    private void startAccel(boolean logdata, boolean calibrate) {
        this.logdata = logdata;
        this.calibrate = calibrate;

        //new run to collect samples
        this.collectedSamples = 0;

        //start listening
        if (sm.registerListener(this, sensor, samplingPeriodUs)){
            listening = true; // we are listening to accelerometer!
        }
    }


    //stop accelerometer
    public void stop() {
        if (listening) {
            sm.unregisterListener(this);

            //reset flags
            listening = false;
            logdata   = false;

            //check if we where calibrating
            if (calibrate) {
                //calculate bias..
                dbAPI.calculateAccelBias(collectedSamples_lowerBound);

                //calibration is done
                calibrate = false;

                //message user we are done
                //Toast toast = Toast.makeText(this.appContext, "Calibration is done", Toast.LENGTH_SHORT);
                //toast.show();
            }

        }


    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy){

    }

    @Override
    public void onSensorChanged(SensorEvent event){
        if (logdata) {
            //new sample collected
            this.collectedSamples++;

            if (calibrate) {
                // Create struct for accel readings.
                RecordAccelBias record = new RecordAccelBias(0, event.timestamp, event.accuracy,
                        event.values[0], event.values[1], event.values[2]);

                //insert data
                dbAPI.insertAccelBias(record);

                //check if we reached our upperbound
                if (this.collectedSamples >= collectedSamples_upperBound){
                    this.stop();
                }

            } else {

                // Create struct for accel readings.
                RecordAccelAct record = new RecordAccelAct(
                        this.run, event.timestamp, event.accuracy, this.motion.getValue(),
                        event.values[0] - accelBias[0], //bias correction
                        event.values[1] - accelBias[1],
                        event.values[2] - accelBias[2]);

                //insert data
                dbAPI.insertAccelAct(record);
            }
        }
    }


}
