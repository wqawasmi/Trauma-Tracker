import oscP5.*;
import grafica.*;

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

int MAX_SIZE = 600;
int EGG = 0;
int ACC = 1;

DataManager mngr = new DataManager();

public GPlot eegPlot, accPlot;

void setup() {
  size(1200, 700);
  frameRate(60);
  
  /* start oscP5, listening for incoming messages at recvPort */
  oscP5 = new OscP5(this, "localhost", recvPort);
  background(0);
  
  // Initialize lists
  eggList = new ArrayList<Float>();
  accList = new ArrayList<Float>();
  
  // Setup for the second plot 
  eegPlot = new GPlot(this);
  eegPlot.setPos(0, 0);
  eegPlot.setDim(1200, 250);
  eegPlot.getTitle().setText("EGG Readings");
  eegPlot.getXAxis().getAxisLabel().setText("Time");
  eegPlot.getYAxis().getAxisLabel().setText("EGG");
  
  accPlot = new GPlot(this);
  accPlot.setPos(0, 300);
  accPlot.setDim(1200, 250);
  accPlot.getTitle().setText("Accelerometer Readings");
  accPlot.getXAxis().getAxisLabel().setText("Time");
  accPlot.getYAxis().getAxisLabel().setText("Accelerometer");
}

void draw() {
  background(49);
  // Draw the second plot  


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

GPointsArray toGArray(ArrayList<Float> arr) {
  GPointsArray ret = new GPointsArray();
  
  for(int i = 0; i < arr.size(); i++) {
    ret.add(i, arr.get(i));
  }
  
  return ret;
}

float[] toPrimArray(ArrayList<Float> arr) {
  float[] floatArray = new float[arr.size()];
  int i = 0;
  for (Float f : arr) {
      floatArray[i++] = (f != null ? f : Float.NaN);
  }
  
  return floatArray;
}

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

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/muse/eeg")==true) {
    float val = msg.get(0).floatValue();
    addPoint(EGG, val);
  }
  else if(msg.checkAddrPattern("/muse/acc")==true) {
    float val = msg.get(0).floatValue();
    addPoint(ACC, val);
    if( mngr.isEvent(val, accList, ACC) >  0 ) {
      System.out.println("GOT EVENT");
    }
  }
  
}