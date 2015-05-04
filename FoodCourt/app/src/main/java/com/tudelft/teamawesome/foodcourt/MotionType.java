package com.tudelft.teamawesome.foodcourt;

/**
 * Created by Electroozz on 04/05/15.
 */
public enum MotionType {
    WALKING(3), QUEUEING(2), IDLE(1);
    private int value;

    private MotionType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
