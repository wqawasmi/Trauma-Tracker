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

// Lists to record events
ArrayList<Float> recEgg;
ArrayList<Float> recAcc;

// Constants
int MAX_SIZE = 600; // Max data points stored at a given time
int EGG = 0;
int ACC = 1;
int YELLOW_THRESH = 1000;
int RED_THRESH = 1500;

// Value prevents repetitive texts
boolean SMS_SENT = false;
String status = "Normal Levels";
DataManager mngr = new DataManager();

// Recording control variables
int numRecEgg;
int numRecAcc;
boolean recording = false;
int lastEvent = 0;
int eventNum = 0;

// Pulled events from MongoDB
ArrayList<ArrayList<Float>> events;

// Individual plots for EEG and Accelerometer data
public GPlot eegPlot, accPlot, recPlot;

void setup() {
  size(1300, 1000);
  frameRate(60);
  
  /* start oscP5, listening for incoming messages at recvPort */
  oscP5 = new OscP5(this, "localhost", recvPort);
  background(255);
  
  // Initialize lists
  eggList = new ArrayList<Float>();
  accList = new ArrayList<Float>();
  events = new ArrayList<ArrayList<Float>>();
  
  // setup plots
  eegPlot = new GPlot(this);
  eegPlot.setPos(0, 150);
  eegPlot.setDim(1200, 250);
  eegPlot.getTitle().setText("EEG Readings");
  eegPlot.getXAxis().getAxisLabel().setText("Time");
  eegPlot.getYAxis().getAxisLabel().setText("EEG");
  
  accPlot = new GPlot(this);
  accPlot.setPos(0, 450);
  accPlot.setDim(1200, 250);
  accPlot.getTitle().setText("Accelerometer Readings");
  accPlot.getXAxis().getAxisLabel().setText("Time");
  accPlot.getYAxis().getAxisLabel().setText("Accelerometer");
  
  recPlot = new GPlot(this);
  recPlot.setPos(0, 150);
  recPlot.setDim(1200, 250);
  recPlot.getTitle().setText("Accelerometer Readings");
  recPlot.getXAxis().getAxisLabel().setText("Time");
  recPlot.getYAxis().getAxisLabel().setText("Accelerometer");
  
  // Populate events
  pullData();
}

void draw() {
  background(255);

  // Draw title
  textSize(20);
  fill(0);
  //text("From the creators of Tremor Tracker", width/2 - 160, 50);
  textSize(90);
  fill(255, 180, 30);
  text("Trauma", width/2 - 290, 100);
  textSize(90);
  fill(0, 102, 153);
  text("Tracker", width/2 + 40, 100);
  
  // Draw the event list
  // Event 1
  if(eventNum >= 1) {
    stroke(0);
    fill(255, 180, 30);
    rect(width/2 - 600, height - 175, 400, 30);
    fill(0);
    textSize(20);
    text("Event " + eventNum + " on 04/23/2017", width/2 - 515, height - 152);
  }
  
  // Event 2
  if(eventNum >= 2) {
    fill(255, 180, 30);
    rect(width/2 - 600, height - 125, 400, 30);
    fill(0);
    textSize(20);
    text("Event " + (eventNum - 1) + " on 04/23/2017", width/2 - 515, height - 102);
  }
  
  // Event 3
  if(eventNum >= 3) {
    fill(255, 180, 30);
    rect(width/2 - 600, height - 75, 400, 30);
    fill(0);
    textSize(20);
    text("Event " + (eventNum - 2) + " on 04/23/2017", width/2 - 515, height - 52);
  }
    
  // Draw the status
  textSize(90);
  if( frameCount > 200 ) {
    switch(status) {
      case "Normal Levels":
        fill(0, 255, 100);
        text("Normal Levels", width/2 - 100, height - 80);
        break;
      case "Yellow Levels":
        fill(255, 204, 0);
        text("Yellow Levels", width/2 - 100, height - 80);
        break;
      case "Red Levels":
        fill(255, 0, 0);
        text("Red Levels", width/2 - 10, height - 80);
        textSize(45);
        fill(0);
        text("SMS notification has been sent out!", width/2 - 150, height - 25);
        lastEvent = frameCount;
        break;
    }
  } else {
    fill(0);
    textSize(35);
    text("Calibrating...", width/2 + 100, height - 80);
  }
      
  
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

// Retrieve number of events from MongoDB
void pullData() {
    runProcess("python C:\\Users\\Waleed\\Documents\\Processing\\concuss\\getNumOfEvents.py numEvents.txt");
    eventNum = (int)mngr.readData("numEvents.txt")[0];
    System.out.println("Found " + eventNum + " events!");
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

void startRecord() {
  System.out.println("BEGAN RECORDING...");
  // Init lists
  recEgg = new ArrayList<Float>();
  recAcc = new ArrayList<Float>();
  
  // Copy over current list contents
  for(float x : eggList) {
    recEgg.add(x);
  }
  
  for(float x : accList) {
    recAcc.add(x);
  }
  
  numRecEgg = 200;
  numRecAcc = 200;
  recording = true;
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

// Runs the passed command and reports its output
void runProcess(String proc) {
  try {
    Process p = Runtime.getRuntime().exec(proc);
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
    System.out.println("Exception in runProcess(): " + e.toString());
  }
}

// Event handler for OSC, all data comes through here
void oscEvent(OscMessage msg) {
  // Check if message was EEG data or Accelerometer data
  if (msg.checkAddrPattern("/muse/eeg")==true) {
    float val = msg.get(0).floatValue();
    if( numRecEgg > 0 ) {
      recEgg.add(val);
      numRecEgg--;
    }
      
    addPoint(EGG, val);
  }
  else if(msg.checkAddrPattern("/muse/acc")==true) {
    float val = msg.get(0).floatValue();
    if( recording && numRecAcc > 0 ) {
      recAcc.add(val);
      numRecAcc--;
      if(numRecAcc == 0) {
        mngr.saveData(recAcc, "recData.txt");
        runProcess("python C:\\Users\\Waleed\\Documents\\Processing\\concuss\\send2Mongo.py recData.txt");
        numRecAcc = 0;
        numRecEgg = 0;
        System.out.println("Finished recording!");
        numRecAcc = 0;
        recording = false;
        pullData();
      }
    }
    addPoint(ACC, val);
    // Check if accelerometer picked up a significant spike
    float levels = mngr.isEvent(val, accList, ACC);
    if( levels >  RED_THRESH ) {
      // Send SMS using Twilio to alert the user/parent
      if( SMS_SENT == false ) {
        status = "Red Levels";
        SMS_SENT = true;
        System.out.println("GOT EVENT, SENDING SMS");
        runProcess("python C:\\Users\\Waleed\\Documents\\Processing\\concuss\\send_sms.py \"Yellow Event Detected!\" 9732199841");
        startRecord();
        pullData();
      }
     
    }
    if( levels > YELLOW_THRESH && SMS_SENT == false) {
      status = "Yellow Levels";
      System.out.println("Got yellow levels!");
    }
  }
}

// Returns true if the mouse is hovering over the given rectangle
boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

// Check if event buttons were pressed
void mousePressed() {
  // Check for event 1
  if( overRect(width/2 - 600, height - 175, 400, 30) && eventNum >= 1) {
    System.out.println("Event 1 clicked!");
    runProcess("python C:\\Users\\Waleed\\Documents\\Processing\\concuss\\getMongoData.py recData.txt " + eventNum);
    runProcess("python C:\\Users\\Waleed\\Documents\\Processing\\concuss\\plotData.py");
  }
  else if( overRect(width/2 - 600, height - 125, 400, 30) && eventNum >= 2) {
    System.out.println("Event 2 clicked!");
    runProcess("python C:\\Users\\Waleed\\Documents\\Processing\\concuss\\getMongoData.py recData.txt " + (eventNum - 1));
    runProcess("python C:\\Users\\Waleed\\Documents\\Processing\\concuss\\plotData.py");
  }
  else if( overRect(width/2 - 600, height - 75, 400, 30) && eventNum >= 3) {
    System.out.println("Event 3 clicked!");
    runProcess("python C:\\Users\\Waleed\\Documents\\Processing\\concuss\\getMongoData.py recData.txt "  + (eventNum - 2));
    runProcess("python C:\\Users\\Waleed\\Documents\\Processing\\concuss\\plotData.py");
  }
}
 