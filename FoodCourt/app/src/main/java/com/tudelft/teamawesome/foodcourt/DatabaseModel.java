package com.tudelft.teamawesome.foodcourt;

import android.provider.BaseColumns;

/**
 * Created by Electroozz on 04/05/15.
 *
 * Model for the database. Each table should be defined here.
 *   The DatabaseHelper will create/maintain the database.
 */
public class DatabaseModel {
    /****** DB INFO ******/
    public static final int DATABASE_VERSION = 3;
    public static final String DATABASE_NAME = "FoodCourt.db";

    //empty constructor
    public DatabaseModel() {}

    /* TableAccelAct
     *   Table which contains measured data from the accelerometer.
     *   It is used for learning and classifying motionTypes
     */
    public static abstract class TableAccelAct implements BaseColumns {
        // BaseColumns additions:
        // String	_COUNT	The count of rows in a directory.
        // String	_ID	The unique ID for a row.

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
    }


    /* TableAccelBias
     *   Table which contains the bias of the accelerometer.
     *   The LINEAR_ACCELEROMETER has an constant bias (offset), which needs to subtracted of
     *   all measurements. To determine this bias an calibration routine is needed which stores the
     *   calculated bias in this table.
     */
    public static abstract class TableAccelBias implements BaseColumns {
        // BaseColumns additions:
        // String	_COUNT	The count of rows in a directory.
        // String	_ID	The unique ID for a row.

        // Table structure:
        public static final String TAB_NAME              = "accelBias";
        public static final String COL_NAME_BIAS         = "bias";      //true/false if record is bias
        public static final String COL_NAME_X            = "x";         //x-measurement/bias
        public static final String COL_NAME_Y            = "y";         //y-measurement/bias
        public static final String COL_NAME_Z            = "z";         //z-measurement/bias

        //Column types
        public static final String COL_TYPE_BIAS         = "INTEGER";   //boolean: 1 or 0
        public static final String COL_TYPE_X            = "REAL";      //float
        public static final String COL_TYPE_Y            = "REAL";      //float
        public static final String COL_TYPE_Z            = "REAL";      //float
    }

}
