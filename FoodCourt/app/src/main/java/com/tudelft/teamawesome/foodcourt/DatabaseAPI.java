package com.tudelft.teamawesome.foodcourt;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.widget.Toast;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/**
 * Created by Electroozz on 04/05/15.
 *
 * API to access database. By using this API the SQL statements and database specific setttings will
 *  be kept inside a specific part (API and Database) of the app, so the rest of the app can focus
 *  on what is important there.
 */
public class DatabaseAPI {
    private DatabaseHelper dbHelper;
    private SQLiteDatabase db;
    private Context appContext;

    //init database
    public DatabaseAPI(Context appContext) {
        this.appContext = appContext;
        //create helper
        dbHelper = new DatabaseHelper(appContext);
        //open database
        db = dbHelper.getWritableDatabase();
    }

    //close database
    public void close(){
        db.close();
    }

    //reset database
    public void reset() {
        dbHelper.reset(db);
    }

    //reset Accelerometer Activity
    public void resetAccelActivity() {
        db.execSQL("DELETE FROM "+ DatabaseModel.TableAccelAct.TAB_NAME);
    }


    //retrieve highest run-value in database
    public int getMaxRun() {
        int run = 0;
        
        //setup query
        String query = "";
        query += "SELECT MAX(" + DatabaseModel.TableAccelAct.COL_NAME_RUN + ") as maxrun";
        query += " FROM " + DatabaseModel.TableAccelAct.TAB_NAME;
        
        //send query to db
        Cursor c = db.rawQuery(query, null);
        if (c.getCount() > 0) {
            c.moveToFirst();
            run = c.getInt(c.getColumnIndexOrThrow("maxrun"));
        }
        c.close();
        return run;
    }

    //retrieve number of records in the database
    public int getRecordCount() {
        int count = 0;

        //setup query
        String query = "";
        query += "SELECT COUNT(*) as count";
        query += " FROM " + DatabaseModel.TableAccelAct.TAB_NAME;

        //send query to db
        Cursor c = db.rawQuery(query, null);
        if (c.getCount() > 0) {
            c.moveToFirst();
            count = c.getInt(c.getColumnIndexOrThrow("count"));
        }
        c.close();
        return count;

    }

    //insert record of accelerometer readings for activity classification
    public long insertAccelAct(RecordAccelAct record){
        String tablename     = DatabaseModel.TableAccelAct.TAB_NAME;
        ContentValues values = record.toContentValues();
        return db.insert(tablename, null, values);
    }

    //insert record of accelerometer readings for bias estimation
    public long insertAccelBias(RecordAccelBias record){
        String tablename     = DatabaseModel.TableAccelBias.TAB_NAME;
        ContentValues values = record.toContentValues();
        return db.insert(tablename, null, values);
    }



    /**********************************************/
    /*              EXPORT FUNCTIONS              */
    /**********************************************/
    private String logname;

    
    public void exportTableAccelBias() {
        //create filename
        logname = "log_accelBias" + System.currentTimeMillis();

        //retrieve data
        Cursor c = db.rawQuery("SELECT * FROM " + DatabaseModel.TableAccelBias.TAB_NAME, null);

        //print column headers (same order as values!!)
        appendLog("x,y,z");

        //iterate over data
        for (c.moveToFirst(); !c.isAfterLast(); c.moveToNext()) {
            String text = "";
            text += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelAct.COL_NAME_X));
            text += ",";
            text += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelAct.COL_NAME_Y));
            text += ",";
            text += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelAct.COL_NAME_Z));
            appendLog(text);
            //Log.v("export", text + "\n");
        }
        c.close();
    }
    
    
    //export accelerometer activity
    public void exportTableAccelAct() {
        //create filename
        logname = "log_accelActivity" + System.currentTimeMillis();

        //retrieve data
        Cursor c = db.rawQuery("SELECT * FROM " + DatabaseModel.TableAccelAct.TAB_NAME, null);

        //print column headers (same order as values!!)
        appendLog("timestamp,run,accuracy,motiontype,x,y,z");

        //iterate over data
        for (c.moveToFirst(); !c.isAfterLast(); c.moveToNext()) {
            String text = "";
            text += c.getLong(c.getColumnIndexOrThrow(DatabaseModel.TableAccelAct.COL_NAME_TIMESTAMP));
            text += ",";
            text += c.getInt(c.getColumnIndexOrThrow(DatabaseModel.TableAccelAct.COL_NAME_RUN));
            text += ",";
            text += c.getInt(c.getColumnIndexOrThrow(DatabaseModel.TableAccelAct.COL_NAME_ACCURACY));
            text += ",";
            text += c.getInt(c.getColumnIndexOrThrow(DatabaseModel.TableAccelAct.COL_NAME_MOTIONTYPE));
            text += ",";
            text += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelAct.COL_NAME_X));
            text += ",";
            text += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelAct.COL_NAME_Y));
            text += ",";
            text += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelAct.COL_NAME_Z));
            appendLog(text);
            //Log.v("export", text + "\n");
        }
        c.close();
    }

    public void appendLog(String text)
    {
        File logFile = new File("sdcard/" + logname + ".txt");

        if (!logFile.exists())
        {
            try
            {
                Toast toast = Toast.makeText(this.appContext, "created new log", Toast.LENGTH_SHORT);
                toast.show();
                logFile.createNewFile();
            }
            catch (IOException e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        try
        {
            //BufferedWriter for performance, true to set append to file flag
            BufferedWriter buf = new BufferedWriter(new FileWriter(logFile, true));
            buf.append(text);
            buf.newLine();
            buf.close();
        }
        catch (IOException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}
