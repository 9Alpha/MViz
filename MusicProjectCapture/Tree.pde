public class Tree {

  public Node _root;

  public Tree(int x, int y, float h, float s, float b) {
    Node node = new Node(x, y, h, s, b);
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

  public Node traverseDF(Node currentNode, int mode, int px, int py, boolean useX) {
    if (mode == 0) {
      if (currentNode.nodeX == px && currentNode.nodeY == py) {
        return currentNode;
      }
    } else if (mode == 1) {
      export(currentNode);
    } else if (mode == 2) {
      count(currentNode, useX);
    }
    Iterator<Node> iterator = currentNode.children.iterator(); //WIP
    while (iterator.hasNext()) {
      Node child = iterator.next();
      if (mode == 1) {
        export(child);
      } else if (mode == 2) {
        count(currentNode, useX);
      }
      if (!iterator.hasNext()) {
        if (mode == 0) {
          if (child.nodeX == px && child.nodeY == py) {
            return child;
          }
        }
        iterator = child.children.iterator();
        //this.traverseDF(child, add, px, py);
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

  public void add(int x, int y, float h, float s, float b, int px, int py) {
    Node child = new Node(x, y, h, s, b);
    Node parent = null;

    parent = this.traverseDF(this._root, 0, px, py, false);

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