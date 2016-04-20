public class Node {
  
  public int nodeX, nodeY;
  public float hue, sat, bri;
  public Node parent;
  public LinkedList<Node> children = new LinkedList<Node>();
  
   public Node(int x, int y, float h, float s, float b) {
    this.hue = h;
    this.sat = s;
    this.bri = b;
    this.nodeX = x;
    this.nodeY = y;
    this.parent = null;
  }
}