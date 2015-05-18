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
    private boolean listening  = false;  //indicates if we are already listening to the accel
    private boolean calibrate  = false;  //indicates if we are collecting data for calibration
    private boolean logdata    = false;  //indicates if we need to log/store the accel-data
    private boolean filterDone = false;  //indicates if the accel-filter has reached a steady state

    //track run-number and accelBias
    protected int run = 0;
    protected float[] accelBias = {0.0f, 0.0f, 0.0f};

    //misc globals
    protected SensorManager sm;
    protected Sensor sensor;
    protected MotionType motion;
    protected DatabaseAPI dbAPI;
    protected Context appContext;

    public Accelerometer(SensorManager sm, Context appContext){
        this.appContext = appContext;
        this.sm = sm;

        //init accelerometer
        sensor = sm.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);

        //start running accelerometer.
        // Due too some filtering in TYPE_LINEAR_ACCELERATION it takes
        //   roughly 1000 samples to reach a steady state, hence we start it on initialization.
        this.startAccel(false, false);
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
        //only start if accel-filter has reached a steady state
        if (filterDone) {
            //new run
            run = run + 1;

            //set flags: data needs to be logged and system is not doing calibration
            this.startAccel(true, false);
        } else {
            //message user has to wait for filter to reach steady state
            Toast toast = Toast.makeText(this.appContext, "Accel still booting up", Toast.LENGTH_SHORT);
            toast.show();
            // accel is not yet booted
            if (collectedSamples == 0) {
                startAccel(false, false);
            }
        }
    }

    //start accelerometer
    private void startAccel(boolean logdata, boolean calibrate) {
        this.logdata = logdata;
        this.calibrate = calibrate;

        //new run to collect samples
        this.collectedSamples = 0;

        //start listening
        if (!listening) {
            if (sm.registerListener(this, sensor, samplingPeriodUs)) {
                listening = true; // we are listening to accelerometer!
            }
        }
    }


    //paus logging of data
    public void pause(){
        logdata    = false;
    }

    //stop accelerometer
    public void stop() {
        //if (listening) {
            sm.unregisterListener(this);

            //reset flags
            listening  = false;
            logdata    = false;
            filterDone = false;
            collectedSamples = 0;
        //}
    }

    public String getStatus() {
        String status = "";
        status += "Lis:" + ((listening) ? 1 : 0);
        status += " Log:" + ((logdata) ? 1 : 0);
        status += " Cal:" + ((calibrate) ? 1 : 0);
        status += " Fil:" + ((filterDone) ? 1 : 0);
        status += " Col:" + collectedSamples;
        return status;
    }



    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy){

    }

    @Override
    public void onSensorChanged(SensorEvent event){
        //new sample collected
        this.collectedSamples++;

        //check if we have collected enough so the filter has reached a steady state
        if (this.collectedSamples > this.collectedSamples_lowerBound) {
            filterDone = true;
        }

        //Check if data logging is enabled.
        if (logdata) {
            if (calibrate) {
                // Create struct for accel readings.
                RecordAccelBias record = new RecordAccelBias(0, event.timestamp, event.accuracy,
                        event.values[0], event.values[1], event.values[2]);

                //insert data
                dbAPI.insertAccelBias(record);

                //check if we reached our upperbound
                // if, stop and do calibration
                if (this.collectedSamples >= collectedSamples_upperBound){
                    //pause accelerometer
                    this.pause();
                    //calculate bias..
                    accelBias = dbAPI.calculateAccelBias(collectedSamples_lowerBound);
                    //signal that calibration is done
                    calibrate = false;
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
