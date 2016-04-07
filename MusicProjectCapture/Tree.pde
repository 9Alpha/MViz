public class Tree {
  
  Node _root;
  
  public Tree(int x, int y) {
    Node node = new Node(x, y);
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

  public void traverseDF() {
    currentNode = this._root;
      for (var i = 0; i < currentNode.children.length; i++) {
        search(currentNode);
        traverseDF(currentNode.children[i]);
      }
    }
  }

  /*Tree.prototype.contains = function(callback, traversal) {
    traversal.call(this, callback);
  };

  Tree.prototype.add = function(A, B, id, dir, check, toData, traversal) {
    var child = new Node(A, B, id, dir, check), 
      parent = null, 
      callback = function(node) {
      if (node.data.id === toData) {
        parent = node;
      }
    };

    this.contains(callback, traversal);

    if (parent) {
      parent.children.push(child);
      child.parent = parent;
    } else {
      console.log('Cannot add node to a non-existent parent.  Parent--> '+toData);
    }
  };

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