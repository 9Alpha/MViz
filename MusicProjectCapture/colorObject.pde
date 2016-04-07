public class colorObject {
  float colorLow, colorHigh;
  int centerX, centerY;
  ArrayList<Integer> pixelList = new ArrayList<Integer>();
  
  
  public colorObject(float a, float b, int x, int y) {
    colorLow = a;
    colorHigh = b;
    centerX = x;
    centerY = y;
  }
  
  
  public void addToPixels(int a) {
    pixelList.add(a);
  }
  
}