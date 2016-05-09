public class colorObject {
  float colorLow, colorHigh, colorSt;
  int leftX, rightX;
  int centerX, centerY;
  int highY, lowY;
  public Tree pixelList;


  public colorObject(float a, float bb, float s, float b, int x, int y) {
    colorLow = a;
    colorHigh = bb;
    colorSt = (a+bb)/2.0;
    pixelList = new Tree(x, y, colorSt, s, b);
  }


  public void addToPixels(int x, int y, float h, float s, float b, int px, int py) {
    pixelList.add(x, y, h, s, b, px, py);
    rightX = this.rX();
    leftX = this.lX();
    highY = this.hY();
    lowY = this.lY();
    centerX = int((rightX+leftX)/2);
    centerY = int((highY+lowY)/2);
  }

  public void outPut() {
    this.pixelList.traverseDF(this.pixelList._root, 1, 0, 0, false);
  }

  public int rX() {
    rightNodeX = 0;
    this.pixelList.traverseDF(this.pixelList._root, 2, 0, 0, false);
    return rightNodeX;
  }

  public int lX() {
    leftNodeX = Cwidth+10;
    this.pixelList.traverseDF(this.pixelList._root, 3, 0, 0, false);
    return leftNodeX;
  }

  public int hY() {
    largestNodeY = 0;
    this.pixelList.traverseDF(this.pixelList._root, 4, 0, 0, false);
    return largestNodeY;
  }

  public int lY() {
    smallestNodeY = Cheight+10;
    this.pixelList.traverseDF(this.pixelList._root, 5, 0, 0, false);
    return smallestNodeY;
  }
}