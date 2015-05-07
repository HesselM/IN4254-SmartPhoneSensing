package com.tudelft.teamawesome.foodcourt;

import android.content.ContentValues;

/**
 * Created by Electroozz on 06/05/15.
 */
public class RecordAccelBias {
    /*
        // Table structure:
        public static final String TAB_NAME              = "accelBias";
        public static final String COL_NAME_BIAS         = "bias";      //true/false if record is bias
        public static final String COL_NAME_TIMESTAMP    = "timestamp";     // in nanoseconds
        public static final String COL_NAME_ACCURACY     = "accuracy";
        public static final String COL_NAME_X            = "x";         //x-measurement/bias
        public static final String COL_NAME_Y            = "y";         //y-measurement/bias
        public static final String COL_NAME_Z            = "z";         //z-measurement/bias

        //Column types
        public static final String COL_TYPE_BIAS         = "INTEGER";   //boolean: 1 or 0
        public static final String COL_TYPE_TIMESTAMP    = "INTEGER";   //long
        public static final String COL_TYPE_ACCURACY     = "INTEGER";   //int
        public static final String COL_TYPE_X            = "REAL";      //float
        public static final String COL_TYPE_Y            = "REAL";      //float
        public static final String COL_TYPE_Z            = "REAL";      //float
    */

    private int bias;
    private long timestamp;
    private int accuracy;
    private float x;
    private float y;
    private float z;

    //empty constructor
    public RecordAccelBias() {}

    //constructor with all data
    public RecordAccelBias(int bias, long timestamp, int accuracy, float x, float y, float z){
        this.bias = bias;
        this.timestamp = timestamp;
        this.accuracy = accuracy;
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public ContentValues toContentValues(){
        ContentValues values = new ContentValues();
        values.put(DatabaseModel.TableAccelBias.COL_NAME_BIAS       , this.bias);
        values.put(DatabaseModel.TableAccelBias.COL_NAME_TIMESTAMP  , this.timestamp);
        values.put(DatabaseModel.TableAccelBias.COL_NAME_ACCURACY   , this.accuracy);
        values.put(DatabaseModel.TableAccelBias.COL_NAME_X          , this.x);
        values.put(DatabaseModel.TableAccelBias.COL_NAME_Y          , this.y);
        values.put(DatabaseModel.TableAccelBias.COL_NAME_Z          , this.z);
        return  values;
    }

}
