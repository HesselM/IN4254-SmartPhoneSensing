package com.tudelft.teamawesome.foodcourt;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

/**
 * Created by Electroozz on 04/05/15.
 */
public class dbAPI {
    private dbHelper helper;
    private SQLiteDatabase db;

    public dbAPI(Context context) {
        //create helper
        helper = new dbHelper(context);
        //open database
        db = helper.getWritableDatabase();
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

    public void close(){
        db.close();
    }



}
