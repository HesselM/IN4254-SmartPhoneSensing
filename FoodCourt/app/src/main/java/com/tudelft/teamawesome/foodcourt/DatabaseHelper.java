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
    /****** SQL COMMANDS ******/
    private static final String COMMA = ",";
    private static final String SPACE = " ";

    // basic SQL-statements

    //ACTIVITY
    private static final String SQL_CREATE_TABLE_ACCELACT=
            "CREATE TABLE " + DatabaseModel.TableAccelAct.TAB_NAME +
                    " (" +
                        DatabaseModel.TableAccelAct._ID                     + SPACE +
                            "INTEGER PRIMARY KEY"                           + COMMA + SPACE +
                        DatabaseModel.TableAccelAct.COL_NAME_RUN            + SPACE +
                            DatabaseModel.TableAccelAct.COL_TYPE_RUN        + COMMA + SPACE +
                        DatabaseModel.TableAccelAct.COL_NAME_TIMESTAMP      + SPACE +
                            DatabaseModel.TableAccelAct.COL_TYPE_TIMESTAMP  + COMMA + SPACE +
                        DatabaseModel.TableAccelAct.COL_NAME_ACCURACY       + SPACE +
                            DatabaseModel.TableAccelAct.COL_TYPE_ACCURACY   + COMMA + SPACE +
                        DatabaseModel.TableAccelAct.COL_NAME_MOTIONTYPE     + SPACE +
                            DatabaseModel.TableAccelAct.COL_TYPE_MOTIONTYPE + COMMA + SPACE +
                        DatabaseModel.TableAccelAct.COL_NAME_X              + SPACE +
                            DatabaseModel.TableAccelAct.COL_TYPE_X          + COMMA + SPACE +
                        DatabaseModel.TableAccelAct.COL_NAME_Y              + SPACE +
                            DatabaseModel.TableAccelAct.COL_TYPE_Y          + COMMA + SPACE +
                        DatabaseModel.TableAccelAct.COL_NAME_Z              + SPACE +
                            DatabaseModel.TableAccelAct.COL_TYPE_Z          +
                     " )";

    private static final String SQL_DELETE_TABLE_ACCELACT =
            "DROP TABLE IF EXISTS " + DatabaseModel.TableAccelAct.TAB_NAME;

    //BIAS
    private static final String SQL_CREATE_TABLE_ACCELBIAS =
            "CREATE TABLE " + DatabaseModel.TableAccelBias.TAB_NAME +
                    " (" +
                        DatabaseModel.TableAccelBias._ID                    + SPACE +
                            "INTEGER PRIMARY KEY"                           + COMMA + SPACE +
                        DatabaseModel.TableAccelBias.COL_NAME_BIAS          + SPACE +
                            DatabaseModel.TableAccelBias.COL_TYPE_BIAS      + COMMA + SPACE +
                        DatabaseModel.TableAccelBias.COL_NAME_X             + SPACE +
                            DatabaseModel.TableAccelBias.COL_TYPE_X         + COMMA + SPACE +
                        DatabaseModel.TableAccelBias.COL_NAME_Y             + SPACE +
                            DatabaseModel.TableAccelBias.COL_TYPE_Y         + COMMA + SPACE +
                        DatabaseModel.TableAccelBias.COL_NAME_Z             + SPACE +
                            DatabaseModel.TableAccelBias.COL_TYPE_Z         +
                    " )";

    private static final String SQL_DELETE_TABLE_ACCELBIAS =
            "DROP TABLE IF EXISTS " + DatabaseModel.TableAccelBias.TAB_NAME;

    /****** FUNCTIONS ******/

    //Constructor
    public DatabaseHelper(Context context) {
        super(context, DatabaseModel.DATABASE_NAME, null, DatabaseModel.DATABASE_VERSION);
    }

    // onCreate / onUpgrade
    // implicit called when constructor is called.
    // If name is new, onCreate is called
    // When version is increased, onUpgrade is called
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(SQL_CREATE_TABLE_ACCELACT);
        db.execSQL(SQL_CREATE_TABLE_ACCELBIAS);
    }

    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

        //v1
        // AccelAct-table
        //v2
        // upgrade of AccelAct-table
        // --> recreate accelact table
        //v3
        // added AccelBias-table
        // --> create accelbias table

        switch(oldVersion) {
            case 1: //upgrade logic from version 1 to 2
                db.execSQL(SQL_DELETE_TABLE_ACCELACT);
                db.execSQL(SQL_CREATE_TABLE_ACCELACT);
            case 2: //upgrade logic from version 2 to 3
                db.execSQL(SQL_CREATE_TABLE_ACCELBIAS);
            case 3://upgrade logic from version 3 to 4
            case 4://upgrade logic from version 4 to 5
            case 5://upgrade logic from version 5 to 6
                break;
            default:
                throw new IllegalStateException(
                "onUpgrade() with unknown newVersion" + newVersion);
        }

    }

    //reset database
    public void reset(SQLiteDatabase db){
        db.execSQL(SQL_DELETE_TABLE_ACCELACT);
        db.execSQL(SQL_DELETE_TABLE_ACCELBIAS);
        onCreate(db);
    }
}


