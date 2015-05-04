package com.tudelft.teamawesome.foodcourt;

import android.provider.BaseColumns;

/**
 * Created by Electroozz on 04/05/15.
 */
public class dbContract {

    //empty constructor
    public dbContract() {}

    /* Inner class that defines the table contents */
    public static abstract class AccelTable implements BaseColumns {
        // BaseColumns additions:
        // String	_COUNT	The count of rows in a directory.
        // String	_ID	The unique ID for a row.

        // Table structure:
        public static final String TABLE_NAME               = "rawAccelerometer";
        public static final String COLUMN_NAME_RUN          = "run";
        public static final String COLUMN_NAME_TIMESTAMP    = "timestamp";
        public static final String COLUMN_NAME_ACCURACY     = "accuracy";
        public static final String COLUMN_NAME_MOTIONTYPE   = "motiontype";
        public static final String COLUMN_NAME_X            = "x";
        public static final String COLUMN_NAME_Y            = "y";
        public static final String COLUMN_NAME_Z            = "z";
    }



}
