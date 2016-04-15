public class Node {
  
  public int nodeX, nodeY;
  public Node parent;
  public LinkedList<Node> children = new LinkedList<Node>();
  
   public Node(int x, int y) {
    this.nodeX = x;
    this.nodeY = y;
    this.parent = null;
  }
}