package com.tudelft.teamawesome.foodcourt;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Created by Electroozz on 04/05/15.
 */
public class dbHelper extends SQLiteOpenHelper {
    //types
    private static final String DATATYPE_FLOAT = " REAL";
    private static final String DATATYPE_INT   = " INTEGER";

    //separator
    private static final String COMMA_SEP = ", ";

    // SQL-statements
    private static final String SQL_CREATE_ENTRIES =
            "CREATE TABLE " + dbContract.AccelTable.TABLE_NAME + " (" +
                    dbContract.AccelTable._ID                    + DATATYPE_INT   + " PRIMARY KEY" + COMMA_SEP +
                    dbContract.AccelTable.COLUMN_NAME_RUN        + DATATYPE_INT   + COMMA_SEP +
                    dbContract.AccelTable.COLUMN_NAME_TIMESTAMP  + DATATYPE_INT   + COMMA_SEP +
                    dbContract.AccelTable.COLUMN_NAME_ACCURACY   + DATATYPE_INT   + COMMA_SEP +
                    dbContract.AccelTable.COLUMN_NAME_MOTIONTYPE + DATATYPE_INT   + COMMA_SEP +
                    dbContract.AccelTable.COLUMN_NAME_X          + DATATYPE_FLOAT + COMMA_SEP +
                    dbContract.AccelTable.COLUMN_NAME_Y          + DATATYPE_FLOAT + COMMA_SEP +
                    dbContract.AccelTable.COLUMN_NAME_Z          + DATATYPE_FLOAT + " )";

    private static final String SQL_DELETE_ENTRIES =
            "DROP TABLE IF EXISTS " + dbContract.AccelTable.TABLE_NAME;

    // DB info
    public static final int DATABASE_VERSION = 1;
    public static final String DATABASE_NAME = "FoodCourt.db";

    // Constructor
    public dbHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    // onCreate / onUpgrade
    // implicit called when constructor is called.
    // If name is new, onCreate is called
    // When version is increased, onUpgrade is called

    public void onCreate(SQLiteDatabase db) {
        db.execSQL(SQL_CREATE_ENTRIES);
    }

    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // This database is only a cache for online data, so its upgrade policy is
        // to simply to discard the data and start over
        db.execSQL(SQL_DELETE_ENTRIES);
        onCreate(db);

        /*
        switch(oldVersion) {
            case 1:
                //upgrade logic from version 1 to 2
            case 2:
                //upgrade logic from version 2 to 3
            case 3:
                //upgrade logic from version 3 to 4
                break;
            default:
                throw new IllegalStateException(
                "onUpgrade() with unknown newVersion" + newVersion);
        }
         */
    }
    public void reset(SQLiteDatabase db){
        db.execSQL(SQL_DELETE_ENTRIES);
        onCreate(db);
    }



}


