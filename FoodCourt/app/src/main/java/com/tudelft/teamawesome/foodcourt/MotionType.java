package com.tudelft.teamawesome.foodcourt;

/**
 * Created by Electroozz on 04/05/15.
 *
 * enum for motion type
 *  Enables a more clear approach in calling/storing/setting motiontypes throughout the app
 */
public enum MotionType {
    QUEUESTEP(4), WALKING(3), QUEUEING(2), IDLE(1);
    private int value;

    private MotionType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
