import processing.video.*;
import java.awt.*;
import java.util.*;

Capture cam;
int res = 121;
int count = 0;
float[] hsbVals = new float[3];

//Tree tree = new Tree(0, 0);

String searchReturn = "";

void setup() {
  /* tree.add(1, 0, 0, 0);
   tree.add(1, 1, 1, 0);
   tree.add(1, 2, 1, 1);
   tree.add(2, 2, 1, 2);
   flood(0, 0, 0);*/
  size(640, 360);
  noStroke();
  colorMode(HSB, 1);
  String[] cameras = Capture.list();
  for (int i = 0; i < cameras.length; i++) {
    println("["+i+"]: "+cameras[i]);
  }

  cam = new Capture(this, cameras[4]);
  cam.start();
}

public boolean[] updateGood(int top, boolean[] grid) {
  for (int i = 0; i < top; i++) {
    for (int j = 0; j < res; j++) {
      if (i % width == j || i % width == width-j-1) {
        grid[i] = false;
      }
    }
    if (i < width*res || i > top-1-(width*res)) {
      grid[i] = false;
    }
  }
  return grid;
}

void draw() {
  if (cam.available() == true) {
    cam.read();

    set(0, 0, cam);

    cam.loadPixels();

    boolean[] goodPix = new boolean[cam.pixels.length];
    for (int i = 0; i < cam.pixels.length; i++) {
      goodPix[i] = true;
    }
    goodPix = updateGood(cam.pixels.length, goodPix);
    LinkedList<colorObject> seenObjects = new LinkedList<colorObject>();



    for (int i = 0; i < cam.pixels.length; i+=res) {
      if (goodPix[i]) {
        goodPix[i] = false;
        colorObject shape = new colorObject(hue(cam.pixels[i])-.01, hue(cam.pixels[i])+.01, saturation(cam.pixels[i]), brightness(cam.pixels[i]), i%width, (int)(i/width));
        seenObjects.add(flood(shape, i, hue(cam.pixels[i])-.01, hue(cam.pixels[i])+.01, goodPix));
      }
    }

    for (int i = 0; i < seenObjects.size(); i++) {
      seenObjects.get(i).pixelList.traverseDF(seenObjects.get(i).pixelList._root, false, 0, 0);
    }

    //println("("+map(point2[0], 0, 1, 0, 360)+", "+map(point2[1], 0, 1, 0, 100)+", "+map(point2[2], 0, 1, 0, 100)+")");
    cam.updatePixels();
  }

  /*
  loadPixels();
   
   boolean[] goodPix = new boolean[pixels.length];
   for (int i = 0; i < pixels.length; i++) {
   goodPix[i] = true;
   }
   goodPix = updateGood(pixels.length, goodPix);
   LinkedList<colorObject> seenObjects = new LinkedList<colorObject>();
   
   
   
   for (int i = 0; i < pixels.length; i++) {
   if (goodPix[i]) {
   goodPix[i] = false;
   colorObject shape = new colorObject(hue(pixels[i])-5, hue(pixels[i])+5, i%width, (int)(i/width));
   seenObjects.add(flood(shape, i, hue(pixels[i])-5, hue(pixels[i])+5, goodPix));
   }
   }
   
   //println("("+map(point2[0], 0, 1, 0, 360)+", "+map(point2[1], 0, 1, 0, 100)+", "+map(point2[2], 0, 1, 0, 100)+")");
   updatePixels();
   
   */

  //image(cam, 0, 0, width, height);
}

public void search(Node node) {
  if (node.parent != null) {
    fill(color(node.hue, node.sat, node.bri));
    rect(node.nodeX, node.nodeY, res, res);
    //println("Node: ("+node.nodeX+", "+node.nodeY+")  Parent: "+"("+node.parent.nodeX+", "+node.parent.nodeY+")");
  } else {
    //println("Node: ("+node.nodeX+", "+node.nodeY+")  Parent: _root");
  }
}


public colorObject flood(colorObject shape, int start, float low, float high, boolean[] goodPix) {

  boolean keepGoing = true;

  while (keepGoing) {
    keepGoing = false;
    if (goodPix[start+res] && hue(cam.pixels[start+res]) > low && hue(cam.pixels[start+res]) < high) {
      shape.addToPixels((start+res)%width, (int)((start+res)/width), (low+high)/2.0, saturation(cam.pixels[start+res]), brightness(cam.pixels[start+res]), (start)%width, (int)((start)/width));
      goodPix[start+res] = false;
      keepGoing = true;
      start = start+res;
      //flood(shape, start+res, low, high, goodPix);
    } else if (goodPix[start+width] && hue(cam.pixels[start+width]) > low && hue(cam.pixels[start+width]) < high) {
      shape.addToPixels((start+(width*res))%width, (int)((start+(width*res))/width), (low+high)/2.0, saturation(cam.pixels[start+(width*res)]), brightness(cam.pixels[start+(width*res)]), (start)%width, (int)((start)/width));
      goodPix[start+(width*res)] = false;
      keepGoing = true;
      start = start+(width*res);
      //flood(shape, start+(width*res), low, high, goodPix);
    } else if (goodPix[start-1] && hue(cam.pixels[start-1]) > low && hue(cam.pixels[start-1]) < high) {
      shape.addToPixels((start-res)%width, (int)((start-res)/width), (low+high)/2.0, saturation(cam.pixels[start-res]), brightness(cam.pixels[start-res]), (start)%width, (int)((start)/width));
      goodPix[start-res] = false;
      keepGoing = true;
      start = start-res;
      //flood(shape, start-res, low, high, goodPix);
    } else if (goodPix[start-width] && hue(cam.pixels[start-width]) > low && hue(cam.pixels[start-width]) < high) {
      shape.addToPixels((start-(width*res))%width, (int)((start-(width*res))/width), (low+high)/2.0, saturation(cam.pixels[start-(width*res)]), brightness(cam.pixels[start-(width*res)]), (start)%width, (int)((start)/width));
      goodPix[start-(width*res)] = false;
      keepGoing = true;
      start = start-(width*res);
      //flood(shape, start-(width*res), low, high, goodPix);
    }
  }

  /* if (goodPix[start+1] && hue(pixels[start+1]) > low && hue(pixels[start+1]) < high) {
   shape.addToPixels((start+1)%width, (int)((start+1)/width), (low+high)/2.0, (start)%width, (int)((start)/width));
   goodPix[start+1] = false;
   flood(shape, start+1, low, high, goodPix);
   } else if (goodPix[start+width] && hue(pixels[start+width]) > low && hue(pixels[start+width]) < high) {
   shape.addToPixels((start+width)%width, (int)((start+width)/width), (low+high)/2.0, (start)%width, (int)((start)/width));
   goodPix[start+width] = false;
   flood(shape, start+width, low, high, goodPix);
   } else if (goodPix[start-1] && hue(pixels[start-1]) > low && hue(pixels[start-1]) < high) {
   shape.addToPixels((start-1)%width, (int)((start-1)/width), (low+high)/2.0, (start)%width, (int)((start)/width));
   goodPix[start-1] = false;
   flood(shape, start-1, low, high, goodPix);
   } else if (goodPix[start-width] && hue(pixels[start-width]) > low && hue(pixels[start-width]) < high) {
   shape.addToPixels((start-width)%width, (int)((start-width)/width), (low+high)/2.0, (start)%width, (int)((start)/width));
   goodPix[start-width] = false;
   flood(shape, start-width, low, high, goodPix);
   }*/


  return shape;
}