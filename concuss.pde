import oscP5.*;
import grafica.*;
import java.io.*;

// OSC PARAMETERS & PORTS
int recvPort = 5000;
OscP5 oscP5;

// DISPLAY PARAMETERS
int WIDTH = 100;
int HEIGHT = 100;

// Data Lists
ArrayList<Float> eggList;
ArrayList<Float> accList;
ArrayList<Float> accFilter;

// Constants
int MAX_SIZE = 600; // Max data points stored at a given time
int EGG = 0;
int ACC = 1;

// Value prevents repetitive texts
boolean SMS_SENT = false;

DataManager mngr = new DataManager();

// Individual plots for EEG and Accelerometer data
public GPlot eegPlot, accPlot;

void setup() {
  size(1200, 900);
  frameRate(60);
  
  /* start oscP5, listening for incoming messages at recvPort */
  oscP5 = new OscP5(this, "localhost", recvPort);
  background(0);
  
  // Initialize lists
  eggList = new ArrayList<Float>();
  accList = new ArrayList<Float>();
  
  // setup plots
  eegPlot = new GPlot(this);
  eegPlot.setPos(0, 0);
  eegPlot.setDim(1200, 250);
  eegPlot.getTitle().setText("EGG Readings");
  eegPlot.getXAxis().getAxisLabel().setText("Time");
  eegPlot.getYAxis().getAxisLabel().setText("EEG");
  
  accPlot = new GPlot(this);
  accPlot.setPos(0, 300);
  accPlot.setDim(1200, 250);
  accPlot.getTitle().setText("Accelerometer Readings");
  accPlot.getXAxis().getAxisLabel().setText("Time");
  accPlot.getYAxis().getAxisLabel().setText("Accelerometer");
}

void draw() {
  background(49);

  // Draw the plots
  fill(0, 0, 255);
  eegPlot.beginDraw();
  eegPlot.setPoints(toGArray(eggList));
  eegPlot.setLineWidth(2);
  eegPlot.drawBackground();
  eegPlot.drawBox();
  eegPlot.drawXAxis();
  eegPlot.drawYAxis();
  eegPlot.drawTitle();
  eegPlot.drawGridLines(GPlot.BOTH);
  eegPlot.drawLines();
  //eegPlot.drawPoints();
  eegPlot.endDraw();
  
  accPlot.beginDraw();
  accPlot.setLineWidth(2);
  accPlot.setPoints(toGArray(accList));
  accPlot.drawBackground();
  accPlot.drawBox();
  accPlot.drawXAxis();
  accPlot.drawYAxis();
  accPlot.drawTitle();
  accPlot.drawGridLines(GPlot.BOTH);
  accPlot.drawLines();
  //accPlot.drawPoints();
  accPlot.endDraw();
}

// Convert an array list to GPointsArray for use with GPlot
GPointsArray toGArray(ArrayList<Float> arr) {
  GPointsArray ret = new GPointsArray();
  
  for(int i = 0; i < arr.size(); i++) {
    ret.add(i, arr.get(i));
  }
  
  return ret;
}

// Conver ArrayList<Float> into a primitive float[] array
float[] toPrimArray(ArrayList<Float> arr) {
  float[] floatArray = new float[arr.size()];
  int i = 0;
  for (Float f : arr) {
      floatArray[i++] = (f != null ? f : Float.NaN);
  }
  
  return floatArray;
}

// Add point to appropriate data sent and remove the oldest point if necessary
void addPoint(int type, float val) {
  if( type == EGG ) {
    
    if( eggList.size() >= MAX_SIZE )
      eggList.remove(0);
      
    eggList.add( val );
//System.out.println("eeg: " + val);
  } else if( type == ACC ) {
    if( accList.size() >= MAX_SIZE )
      accList.remove(0);
    accList.add(val);

  }
}

// Event handler for OSC, all data comes through here
void oscEvent(OscMessage msg) {
  // Check if message was EEG data or Accelerometer data
  if (msg.checkAddrPattern("/muse/eeg")==true) {
    float val = msg.get(0).floatValue();
    addPoint(EGG, val);
  }
  else if(msg.checkAddrPattern("/muse/acc")==true) {
    float val = msg.get(0).floatValue();
    addPoint(ACC, val);
    // Check if accelerometer picked up a significant spike
    if( mngr.isEvent(val, accList, ACC) >  0 ) {
      // Send SMS using Twilio to alert the user/parent
      if( SMS_SENT == false ) {
        SMS_SENT = true;
        try {
          System.out.println("GOT EVENT, SENDING SMS");
          Process p = Runtime.getRuntime().exec("python C:\\Users\\Waleed\\Documents\\Processing\\concuss\\send_sms.py \"Yellow Event Detected!\" 9732199841");
          // read the output from the command
          BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
          BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));
          String s;
          while ((s = stdInput.readLine()) != null) {
              System.out.println(s);
          }
          while ((s = stdError.readLine()) != null) {
              System.out.println(s);
          }
        }
        catch(IOException e) {
          System.out.println("Something went wrong: " + e.toString());
        }
      }
    }
  }
  
}