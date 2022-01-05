package com.streambow;

import android.util.Log;

import com.streambow.xperience.xperience.TestCallback;
import com.streambow.xperience.xperience.TestProgress;
import com.streambow.xperience.xperience.TestStatus;
import com.streambow.xperience.xperience.Xperience;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;

public class Streambow extends CordovaPlugin implements TestCallback {
    private static final String TAG = "StreambowPlugin";
    //Context context = IS_AT ? cordova.getActivity().getWindow().getContext() : cordova.getActivity().getApplicationContext();
//    Context context = this.cordova.getActivity().getApplicationContext();
//    Context context = this.cordova.getContext().getApplicationContext();
//    private Xperience xperience = Xperience.getInstance(context);
    private Xperience xperience;
    private CallbackContext callbackContext;

    private TestCallback testCallback = new TestCallback() {

        @Override
        public void progressUpdate(TestProgress testProgress, TestStatus testStatus) {
            switch (testStatus) {
                case TEST_FINISHED:
                    Log.i(TAG, "\n>>>Test done <<<\n");
                    callbackContext.success("TEST DONE!");
                case TEST_CANCELLED:
                    Log.i(TAG, "\n>>>Test cancelled <<<\n");
                    callbackContext.error("ERROR!");
            }
        }
    };

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    this.callbackContext = callbackContext;
    if (action.equals("performTest")) {
            String testID = args.getString(0);
            Log.i(TAG, "\n>>> testID: " + testID + " <<<\n");
            this.performTest(testID, callbackContext);
            return true;
        }
        return false;
    }

    private void performTest(String testID, CallbackContext callbackContext) {
//        if (Build.VERSION.SDK_INT >= 23) {
//            final int READ_PHONE_STATE = ActivityCompat.checkSelfPermission(cordova.getContext(), Manifest.permission.READ_PHONE_STATE);
//
//            if (READ_PHONE_STATE != PackageManager.PERMISSION_GRANTED) {
//                Log.i(TAG, "\n>>> Permission not Granted <<<\n");
//                ActivityCompat.requestPermissions(cordova.getActivity(), new String[]{Manifest.permission.READ_PHONE_STATE}, 1);
//
//            } else {
//                Log.i(TAG, "\n>>> Permission Granted <<<\n");
//            }
//        }

        //this.xperience = Xperience.getInstance(this.cordova.getContext());
        this.xperience = Xperience.getInstance(this.cordova.getContext());
        //this.xperience.startTest(testCallback, testID);
        //if (this.xperience.startTest(this.testCallback, testID)){
        if (this.xperience.startTest(this, testID)){
            Log.i(TAG, "\n>>> Service Requested <<<\n");
        } else {
            Log.i(TAG, "\n>>> Couldn't start service <<<\n");
        }
    }

    @Override
    public void progressUpdate(TestProgress testProgress, TestStatus testStatus) {
        Log.i(TAG, "\n>>> Progress Update <<<\n");
    }
}
