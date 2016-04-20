public class colorObject {
  float colorLow, colorHigh, colorSt;
  int centerX, centerY;
  public Tree pixelList;
  
  
  public colorObject(float a, float bb, float s, float b, int x, int y) {
    colorLow = a;
    colorHigh = bb;
    colorSt = (a+bb)/2.0;
    centerX = x;
    centerY = y;
    pixelList = new Tree(x, y, colorSt, s, b);
  }
  
  
  public void addToPixels(int x, int y, float h, float s, float b, int px, int py) {
    pixelList.add(x, y, h, s, b, px, py);
  }
  
  public void outPut() {
     this.pixelList.traverseDF(this.pixelList._root, false, 0, 0); 
  }
  
  public void display() {
      
  }
  
}