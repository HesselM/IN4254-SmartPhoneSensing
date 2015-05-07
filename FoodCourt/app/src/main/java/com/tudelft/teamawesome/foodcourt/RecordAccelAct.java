package com.tudelft.teamawesome.foodcourt;

import android.content.ContentValues;

/**
 * Created by Electroozz on 05/05/15.
 *
 * struct for fetching/inserting rawAccelerometer data from/to the database via the DatabaseAPI
 * Data should follow model, define in 'DatabaseModel'
 * Structure is used to keep database-specific column names/types in API and not outside.
 *
 */
public class RecordAccelAct {
    /*
        // Table structure:
        public static final String TAB_NAME              = "accelActivity";
        public static final String COL_NAME_RUN          = "run";           // incremental runID
        public static final String COL_NAME_TIMESTAMP    = "timestamp";     // in nanoseconds
        public static final String COL_NAME_ACCURACY     = "accuracy";
        public static final String COL_NAME_MOTIONTYPE   = "motiontype";    // see MotionType-enum
        public static final String COL_NAME_X            = "x";             // x-acceleration
        public static final String COL_NAME_Y            = "y";             // y-acceleration
        public static final String COL_NAME_Z            = "z";             // z-acceleration

        //Column types
        public static final String COL_TYPE_RUN          = "INTEGER";   //int
        public static final String COL_TYPE_TIMESTAMP    = "INTEGER";   //long
        public static final String COL_TYPE_ACCURACY     = "INTEGER";   //int
        public static final String COL_TYPE_MOTIONTYPE   = "INTEGER";   //int
        public static final String COL_TYPE_X            = "REAL";      //float
        public static final String COL_TYPE_Y            = "REAL";      //float
        public static final String COL_TYPE_Z            = "REAL";      //float
    */
    
    private int run;
    private long timestamp;
    private int accuracy;
    private int motiontype;
    private float x;
    private float y;
    private float z;

    //empty constructor
    public RecordAccelAct() {}
    
    //constructor with all data
    public RecordAccelAct(int run, long timestamp, int accuracy, int motiontype, float x, float y, float z){
        this.run = run;
        this.timestamp = timestamp;
        this.accuracy = accuracy;
        this.motiontype = motiontype;
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public ContentValues toContentValues(){
        ContentValues values = new ContentValues();
        values.put(DatabaseModel.TableAccelAct.COL_NAME_RUN        , this.run);
        values.put(DatabaseModel.TableAccelAct.COL_NAME_TIMESTAMP  , this.timestamp);
        values.put(DatabaseModel.TableAccelAct.COL_NAME_ACCURACY   , this.accuracy);
        values.put(DatabaseModel.TableAccelAct.COL_NAME_MOTIONTYPE , this.motiontype);
        values.put(DatabaseModel.TableAccelAct.COL_NAME_X          , this.x);
        values.put(DatabaseModel.TableAccelAct.COL_NAME_Y          , this.y);
        values.put(DatabaseModel.TableAccelAct.COL_NAME_Z          , this.z);
        return  values;
    }

}
