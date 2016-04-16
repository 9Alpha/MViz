public class colorObject {
  float colorLow, colorHigh, colorSt;
  int centerX, centerY;
  private Tree pixelList;
  
  
  public colorObject(float a, float b, int x, int y) {
    colorLow = a;
    colorHigh = b;
    colorSt = (a+b)/2.0;
    centerX = x;
    centerY = y;
    pixelList = new Tree(x, y, colorSt);
  }
  
  
  public void addToPixels(int x, int y, float c, int px, int py) {
    pixelList.add(x, y, c, px, py);
  }
  
  public void outPut() {
     this.pixelList.traverseDF(this.pixelList._root, false, 0, 0); 
  }
  
  public void display() {
      
  }
  
}