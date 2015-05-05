package com.tudelft.teamawesome.foodcourt;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;
import android.widget.Toast;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.util.Date;

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

    //retrieve highest run-value in database
    public int getMaxRun() {
        int run = 0;
        Cursor c = db.rawQuery("SELECT MAX(" + DatabaseModel.TableAccel.COL_NAME_RUN + ") as maxrun FROM " + DatabaseModel.TableAccel.TAB_NAME, null);
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
        Cursor c = db.rawQuery("SELECT COUNT(*) as count FROM " + DatabaseModel.TableAccel.TAB_NAME, null);
        if (c.getCount() > 0) {
            c.moveToFirst();
            count = c.getInt(c.getColumnIndexOrThrow("count"));
        }
        c.close();
        return count;

    }

    //insert record of accelerometer readings.
    public long insertAccel(RecordRawAccel record){
        return this.insert(DatabaseModel.TableAccel.TAB_NAME, record.toContentValues());
    }

    // Insert the new row, returning the primary key value of the new row
    private long insert(String tablename, ContentValues values){
        return db.insert(tablename, null, values);
    }


/**********************************************/
    private String currentDateTimeString;

    //export database
    public void export() {
        //create filename
        currentDateTimeString = DateFormat.getDateTimeInstance().format(new Date());
        Log.v("export", currentDateTimeString + "\n");

        //retrieve data
        Cursor c = db.rawQuery("SELECT * FROM " + DatabaseModel.TableAccel.TAB_NAME, null);

        //iterate over data
        appendLog("motiontype:Walking(3),Queueing(2),Idle(1)");
        appendLog("timestamp,run,accuracy,motiontype,x,y,z");
        for (c.moveToFirst(); !c.isAfterLast(); c.moveToNext()) {
            String text = "";
            text = text + c.getLong(c.getColumnIndexOrThrow(DatabaseModel.TableAccel.COL_NAME_TIMESTAMP));
            text = text + ",";
            text = text + c.getInt(c.getColumnIndexOrThrow(DatabaseModel.TableAccel.COL_NAME_RUN));
            text = text + ",";
            text = text + c.getInt(c.getColumnIndexOrThrow(DatabaseModel.TableAccel.COL_NAME_ACCURACY));
            text = text + ",";
            text = text + c.getInt(c.getColumnIndexOrThrow(DatabaseModel.TableAccel.COL_NAME_MOTIONTYPE));
            text = text + ",";
            text = text + c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccel.COL_NAME_X));
            text = text + ",";
            text = text + c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccel.COL_NAME_Y));
            text = text + ",";
            text = text + c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccel.COL_NAME_Z));
            appendLog(text);
            //Log.v("export", text + "\n");
        }
        c.close();
    }

    public void appendLog(String text)
    {
        File logFile = new File("sdcard/log " + currentDateTimeString + ".txt");

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
