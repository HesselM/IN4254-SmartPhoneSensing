package com.tudelft.teamawesome.foodcourt;

import android.app.Activity;
import android.app.Application;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteDatabase;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.util.Date;

/**
 * Created by Electroozz on 04/05/15.
 */
public class dbAPI {
    private dbHelper helper;
    private SQLiteDatabase db;
    private Context context;


    //init database
    public dbAPI(Context context) {
        this.context = context;
        //create helper
        helper = new dbHelper(context);
        //open database
        db = helper.getWritableDatabase();
    }

    //close database
    public void close(){
        db.close();
    }

    //reset database
    public void reset() {
        helper.reset(db);
    }





    //retrieve highest run-value in database
    public int getMaxRun() {
        int run = 0;
        Cursor c = db.rawQuery("SELECT MAX(" + dbContract.AccelTable.COLUMN_NAME_RUN + ") as maxrun FROM " + dbContract.AccelTable.TABLE_NAME, null);
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
        Cursor c = db.rawQuery("SELECT COUNT(*) as count FROM " + dbContract.AccelTable.TABLE_NAME, null);
        if (c.getCount() > 0) {
            c.moveToFirst();
            count = c.getInt(c.getColumnIndexOrThrow("count"));
        }
        c.close();
        return count;

    }

    // Insert the new row, returning the primary key value of the new row
    public long insert(String tablename, ContentValues values){
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
        Cursor c = db.rawQuery("SELECT * FROM " + dbContract.AccelTable.TABLE_NAME, null);

        //iterate over data
        appendLog("motiontype:Walking(3),Queueing(2),Idle(1)");
        appendLog("timestamp,run,accuracy,motiontype,x,y,z");
        for (c.moveToFirst(); !c.isAfterLast(); c.moveToNext()) {
            String text = "";
            text = text + c.getLong(c.getColumnIndexOrThrow(dbContract.AccelTable.COLUMN_NAME_TIMESTAMP));
            text = text + ",";
            text = text + c.getInt(c.getColumnIndexOrThrow(dbContract.AccelTable.COLUMN_NAME_RUN));
            text = text + ",";
            text = text + c.getInt(c.getColumnIndexOrThrow(dbContract.AccelTable.COLUMN_NAME_ACCURACY));
            text = text + ",";
            text = text + c.getInt(c.getColumnIndexOrThrow(dbContract.AccelTable.COLUMN_NAME_MOTIONTYPE));
            text = text + ",";
            text = text + c.getFloat(c.getColumnIndexOrThrow(dbContract.AccelTable.COLUMN_NAME_X));
            text = text + ",";
            text = text + c.getFloat(c.getColumnIndexOrThrow(dbContract.AccelTable.COLUMN_NAME_Y));
            text = text + ",";
            text = text + c.getFloat(c.getColumnIndexOrThrow(dbContract.AccelTable.COLUMN_NAME_Z));
            appendLog(text);
            Log.v("export", text + "\n");
        }
        c.close();
    }

    public void appendLog(String text)
    {
        File logFile = new File("sdcard/log" + currentDateTimeString + ".txt");

        if (!logFile.exists())
        {
            try
            {
                Toast toast = Toast.makeText(this.context, "created new log", Toast.LENGTH_SHORT);
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
