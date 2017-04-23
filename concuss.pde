 import oscP5.*;
  
  // OSC PARAMETERS & PORTS
  int recvPort = 5000;
  OscP5 oscP5;
  
  // DISPLAY PARAMETERS
  int WIDTH = 100;
  int HEIGHT = 100;
  
  void setup() {
    size(600, 600);
    frameRate(60);
    
    /* start oscP5, listening for incoming messages at recvPort */
    oscP5 = new OscP5(this, "localhost", recvPort);
    background(0);
  }

  void draw() {
    background(0);
  }
  
  void oscEvent(OscMessage msg) {
  System.out.println("### got a message " + msg);
  if (msg.checkAddrPattern("/muse/eeg")==true) {  
    for(int i = 0; i < 4; i++) {
      System.out.print("EEG on channel " + i + ": " + msg.get(i).floatValue() + "\n"); 
    }
  } 
  }