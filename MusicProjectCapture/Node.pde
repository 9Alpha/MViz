public class Node {
  
  public int nodeX, nodeY;
  public Object parent;
  public LinkedList<Object> children = new LinkedList<Object>();
  
   public void Node(int x, int y) {
    this.nodeX = x;
    this.nodeY = y;
    this.parent = null;
  }
}