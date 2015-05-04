package com.tudelft.teamawesome.foodcourt;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.RadioButton;


public class MainActivity extends ActionBarActivity {

    //Activity Enum and assigned value
    public enum Activity {
        WALKING(3), QUEUEING(2), IDLE(1);
        private int value;

        private Activity(int value) {
            this.value = value;
        }
    }

    //global var to track selected activity
    Activity selectedActivity = Activity.IDLE;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }


    //Called when a different activity is selected
    public void activityChanged(View view) {
        // Is the button now checked?
        boolean checked = ((RadioButton) view).isChecked();

        // Check which radio button was clicked
        switch(view.getId()) {
            case R.id.rad_ActStatusIdle:
                if (checked) {
                    selectedActivity = Activity.IDLE;
                }
                break;
            case R.id.rad_ActStatusQueueing:
                if (checked) {
                    selectedActivity = Activity.QUEUEING;
                }
                break;
            case R.id.rad_ActStatusWalking:
                if (checked) {
                    selectedActivity = Activity.WALKING;
                }
                break;
        }
    }

    //Controls to start/stop accelerometer
    public void startAccel(View view) {

    }

    public void stopAccel(View view) {

    }

}
