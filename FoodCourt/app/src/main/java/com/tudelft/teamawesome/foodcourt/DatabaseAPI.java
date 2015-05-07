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

    //reset Accelerometer Activity
    public void resetAccelBias() {
        db.execSQL("DELETE FROM "+ DatabaseModel.TableAccelBias.TAB_NAME);
    }

    //calculate the bias for the accelerometer
    // lowerBoud is the n-th sample from which the bias is stable and can be used
    // This calculation uses the TableAccelBias table
    public void calculateAccelBias(int lowerBound){
        // select all records, which are not indicated as bias an sort on time.
        String query = "";
        query += "SELECT * ";
        query += " FROM " + DatabaseModel.TableAccelBias.TAB_NAME;
        query += " WHERE " + DatabaseModel.TableAccelBias.COL_NAME_BIAS + " = 0 ";
        query += " ORDER BY " + DatabaseModel.TableAccelBias.COL_NAME_TIMESTAMP + " ASC";

        //send query to db and iterate over all values
        Cursor c = db.rawQuery(query, null);

        //check if there are enough records
        if (c.getCount() < lowerBound) {
            Toast toast = Toast.makeText(this.appContext, "lowerbound < #records", Toast.LENGTH_SHORT);
            toast.show();
        } else {
            float x = 0.0f;
            float y = 0.0f;
            float z = 0.0f;

            //iterate over data
            for (c.moveToPosition(lowerBound); !c.isAfterLast(); c.moveToNext()) {
                x += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_X));
                y += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_Y));
                z += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_Z));
            }

            //normalize
            int records = c.getCount() - lowerBound;
            x = x / records;
            y = y / records;
            z = z / records;

            //store data (convert milliseconds to nano to be consistent with data)
            RecordAccelBias record = new RecordAccelBias(1,System.currentTimeMillis()*1000000,-1,x,y,z);
            this.insertAccelBias(record);

            String msg = "AccelBias: ";
            msg += "x:" + x + " ";
            msg += "y:" + y + " ";
            msg += "z:" + z + " ";

            Toast toast = Toast.makeText(this.appContext, msg, Toast.LENGTH_SHORT);
            toast.show();
        }
        c.close();

    }

    public float[] getAccelBias(){
        float[] bias = {0.0f, 0.0f, 0.0f};

        // select all records, which are indicated as bias an sort on time.
        String query = "";
        query += "SELECT * ";
        query += " FROM " + DatabaseModel.TableAccelBias.TAB_NAME;
        query += " WHERE " + DatabaseModel.TableAccelBias.COL_NAME_BIAS + " = 1 ";
        query += " ORDER BY " + DatabaseModel.TableAccelBias.COL_NAME_TIMESTAMP + " ASC";

        //send query to db and iterate over all values
        Cursor c = db.rawQuery(query, null);

        //check if there are enough records
        if (c.getCount() < 1) {
            Toast toast = Toast.makeText(this.appContext, "No bias found! please calibrate accel", Toast.LENGTH_SHORT);
            toast.show();
        } else {
            c.moveToFirst();
            bias[0] = c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_X));
            bias[1] = c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_Y));
            bias[2] = c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_Z));
        }

        return bias;
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
        appendLog("bias,timestamp,accuracy,x,y,z");

        //iterate over data
        for (c.moveToFirst(); !c.isAfterLast(); c.moveToNext()) {
            String text = "";
            text += c.getInt(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_BIAS));
            text += ",";
            text += c.getLong(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_TIMESTAMP));
            text += ",";
            text += c.getInt(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_ACCURACY));
            text += ",";
            text += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_X));
            text += ",";
            text += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_Y));
            text += ",";
            text += c.getFloat(c.getColumnIndexOrThrow(DatabaseModel.TableAccelBias.COL_NAME_Z));
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
