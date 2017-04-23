import java.util.*;

class DataManager {
  int EGG = 0;
  int ACC = 1;
  int ACC_THRESH = 800;
  
  public DataManager() {
    System.out.println("Initialized Data Manager...");
  }
  
  // Saves array to textfile
  public int saveData(ArrayList<Float> arr, String filename) {
    try {
      PrintWriter out = new PrintWriter(filename);
      for( float x : arr ) {
        out.println(x);
      }
      out.close();
    }
    catch (IOException e) {
      System.out.println("Error writing to file!");
      return 0;
    }
    
    return 1;
  }
  
  public float[] readData(String filename) {
    try {
      Scanner sc = new Scanner(new File(filename));
      List<Float> vals = new ArrayList<Float>();
      while(sc.hasNextLine()) {
        vals.add(float(sc.nextLine()));
      }
      
      sc.close();
      
      Float[] temp = vals.toArray(new Float[0]);
      float[] ret = new float[temp.length];
      for (int i = 0; i < temp.length; i++) {
        ret[i] = temp[i].floatValue();
      }
      
      return ret;
    }
    catch(IOException e){
      System.out.println("Error reading from file!");
      return null;
    }
  }
  
  float getRunningAvg(ArrayList<Float> arr, int num) {
    if( arr.size() == 0 )
      return 0;
      
    float tot = 0;
    for (int i = 0; i < num; i++){
      tot += arr.get( arr.size() - 1 - i );
    }
    
    //System.out.println("avg: " + tot/arr.size());
    return tot/num;
  }
  
  public float isEvent(float val, ArrayList<Float> data, int type) {
    float avg = getRunningAvg(data, data.size() - 1);
    if( type == ACC && abs(val - avg) > ACC_THRESH) {
      System.out.println("Got event: " + val);
      return (val - avg)/ACC_THRESH;
    }
      
    return 0;
  }
}