package com.tudelft.teamawesome.foodcourt;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/**
 * Created by Electroozz on 04/05/15.
 *
 * Opens the database and maintains the most important/low-level functions (create/upgrade/reset/etc)
 */
public class DatabaseHelper extends SQLiteOpenHelper {
    /****** DB INFO ******/
    public static final int DATABASE_VERSION = 2;
    public static final String DATABASE_NAME = "FoodCourt.db";

    /****** SQL COMMANDS ******/
    private static final String COMMA = ",";
    private static final String SPACE = " ";

    // basic SQL-statements
    private static final String SQL_CREATE_ENTRIES =
            "CREATE TABLE " + DatabaseModel.TableAccel.TAB_NAME +
                    " (" +
                        DatabaseModel.TableAccel._ID                     + SPACE +
                            "INTEGER PRIMARY KEY"                        + COMMA + SPACE +
                        DatabaseModel.TableAccel.COL_NAME_RUN            + SPACE +
                            DatabaseModel.TableAccel.COL_TYPE_RUN        + COMMA + SPACE +
                        DatabaseModel.TableAccel.COL_NAME_TIMESTAMP      + SPACE +
                            DatabaseModel.TableAccel.COL_TYPE_TIMESTAMP  + COMMA + SPACE +
                        DatabaseModel.TableAccel.COL_NAME_ACCURACY       + SPACE +
                            DatabaseModel.TableAccel.COL_TYPE_ACCURACY   + COMMA + SPACE +
                        DatabaseModel.TableAccel.COL_NAME_MOTIONTYPE     + SPACE +
                            DatabaseModel.TableAccel.COL_TYPE_MOTIONTYPE + COMMA + SPACE +
                        DatabaseModel.TableAccel.COL_NAME_X              + SPACE +
                            DatabaseModel.TableAccel.COL_TYPE_X          + COMMA + SPACE +
                        DatabaseModel.TableAccel.COL_NAME_Y              + SPACE +
                            DatabaseModel.TableAccel.COL_TYPE_Y          + COMMA + SPACE +
                        DatabaseModel.TableAccel.COL_NAME_Z              + SPACE +
                            DatabaseModel.TableAccel.COL_TYPE_Z          +
                     " )";

    private static final String SQL_DELETE_ENTRIES =
            "DROP TABLE IF EXISTS " + DatabaseModel.TableAccel.TAB_NAME;


    /****** FUNCTIONS ******/

    //Constructor
    public DatabaseHelper(Context context) {
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
        //TODO proper database upgrade mechanism
        this.reset(db);

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

    //reset database
    public void reset(SQLiteDatabase db){
        db.execSQL(SQL_DELETE_ENTRIES);
        onCreate(db);
    }
}


