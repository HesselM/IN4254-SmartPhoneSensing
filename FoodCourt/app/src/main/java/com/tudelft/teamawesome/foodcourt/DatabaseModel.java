package com.tudelft.teamawesome.foodcourt;

import android.provider.BaseColumns;

/**
 * Created by Electroozz on 04/05/15.
 *
 * Model for the database. Each table should be defined here.
 *   The DatabaseHelper will create/maintain the database.
 */
public class DatabaseModel {

    //empty constructor
    public DatabaseModel() {}

    /* Inner class that defines the table contents */
    public static abstract class TableAccel implements BaseColumns {
        // BaseColumns additions:
        // String	_COUNT	The count of rows in a directory.
        // String	_ID	The unique ID for a row.

        // Table structure:
        public static final String TAB_NAME              = "rawAccelerometer";
        public static final String COL_NAME_RUN          = "run";
        public static final String COL_NAME_TIMESTAMP    = "timestamp";
        public static final String COL_NAME_ACCURACY     = "accuracy";
        public static final String COL_NAME_MOTIONTYPE   = "motiontype";
        public static final String COL_NAME_X            = "x";
        public static final String COL_NAME_Y            = "y";
        public static final String COL_NAME_Z            = "z";

        //Column types
        public static final String COL_TYPE_RUN          = "INTEGER";   //int
        public static final String COL_TYPE_TIMESTAMP    = "INTEGER";   //long
        public static final String COL_TYPE_ACCURACY     = "INTEGER";   //int
        public static final String COL_TYPE_MOTIONTYPE   = "INTEGER";   //int
        public static final String COL_TYPE_X            = "REAL";      //float
        public static final String COL_TYPE_Y            = "REAL";      //float
        public static final String COL_TYPE_Z            = "REAL";      //float
    }

}
