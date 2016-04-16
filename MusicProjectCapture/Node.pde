public class Node {
  
  public int nodeX, nodeY;
  public float col;
  public Node parent;
  public LinkedList<Node> children = new LinkedList<Node>();
  
   public Node(int x, int y, float c) {
    this.col = c;
    this.nodeX = x;
    this.nodeY = y;
    this.parent = null;
  }
}