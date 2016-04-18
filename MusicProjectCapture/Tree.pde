public class Tree {

  public Node _root;

  public Tree(int x, int y, float c) {
    Node node = new Node(x, y, c);
    this._root = node;
  }


  /* public void findXY(arr, data) {
   var index;
   
   for (var i = 0; i < arr.length; i++) {
   if (arr[i].data.id === data) {
   index = i;
   }
   }
   
   return index;
   }*/

  public Node traverseDF(Node currentNode, boolean add, int px, int py) {
    if (add) {
      if (currentNode.nodeX == px && currentNode.nodeY == py) {
        return currentNode;
      }
    } else {
      search(currentNode);
    }
    Iterator<Node>iterator = currentNode.children.iterator(); //WIP
    while (iterator.hasNext()) {
      Node child = iterator.next();
      if (!iterator.hasNext()) {
        if (add) {
          if (child.nodeX == px && child.nodeY == py) {
            return child;
          }
        }
      }
      if (!add) {
        search(child);
      }
    }
    
    return null;
  }


  /*for (int i = 0; i < currentNode.children.size(); i++) {
   if (add) {
   if (currentNode.children.get(i).nodeX == px && currentNode.children.get(i).nodeY == py) {
   return currentNode.children.get(i);
   }
   } else {
   search(currentNode.children.get(i));
   }
   return this.traverseDF(currentNode.children.get(i), add, px, py);
   }
   return null;
   }
   */
  /*
  public void contains(callback, traversal) {
   traverseDF(this, callback);
   };
   */

  public void add(int x, int y, float c, int px, int py) {
    Node child = new Node(x, y, c);
    Node parent = null;

    parent = this.traverseDF(this._root, true, px, py);

    if (parent != null) {
      parent.children.add(child);
      child.parent = parent;
    } else {
      println("Cannot add node to a non-existent parent.  Parent--> "+px+", "+py);
    }
  };

  /*
  Tree.prototype.remove = function(id, fromData, traversal) {
   var tree = this, 
   parent = null, 
   childToRemove = null, 
   index;
   
   var callback = function(node) {
   if (node.data.id === fromData) {
   parent = node;
   }
   };
   
   this.contains(callback, traversal);
   
   if (parent) {
   index = findIndex(parent.children, id);
   
   if (index === undefined) {
   console.log('Node to remove does not exist. ID--> '+id);
   } else {
   childToRemove = parent.children.splice(index, 1);
   }
   } else {
   console.log('Parent does not exist. Parent--> '+fromData);
   }
   
   return childToRemove;
   };*/
}