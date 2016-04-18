import processing.video.*;
import java.awt.*;
import java.util.*;

Capture cam;
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
  size(960, 540);
  colorMode(HSB, 1);
  String[] cameras = Capture.list();
  for (int i = 0; i < cameras.length; i++) {
    println("["+i+"]: "+cameras[i]);
  }

  cam = new Capture(this, cameras[3]);
  cam.start();
}

public boolean[] updateGood(int top, boolean[] grid) {
  for (int i = 0; i < top; i++) {
    if (i % width == 0 || i % width == width-1 || i < width || i > top-1-width) {
      grid[i] = false;
    }
  }
  return grid;
}

void draw() {
  if (cam.available() == true) {
    cam.read();

    boolean[] goodPix = new boolean[cam.pixels.length];
    for (int i = 0; i < cam.pixels.length; i++) {
      goodPix[i] = true;
    }
    goodPix = updateGood(cam.pixels.length, goodPix);
    LinkedList<colorObject> seenObjects = new LinkedList<colorObject>();


    cam.loadPixels();
    for (int i = 0; i < cam.pixels.length; i++) {
      if (goodPix[i]) {
        goodPix[i] = false;
        colorObject shape = new colorObject(hue(cam.pixels[i])-5, hue(cam.pixels[i])+5, i%width, (int)(i/width));
        seenObjects.add(flood(shape, i, hue(cam.pixels[i])-5, hue(cam.pixels[i])+5, goodPix));
      }
    }
    loadPixels();
    color point = color(get(mouseX, mouseY));

    int r = (point)&0xFF;
    int g = (point>>8)&0xFF;
    int b = (point>>16)&0xFF;
    int a = (point>>24)&0xFF;

    float[] point2 = Color.RGBtoHSB(r, g, b, hsbVals);

    //println("("+map(point2[0], 0, 1, 0, 360)+", "+map(point2[1], 0, 1, 0, 100)+", "+map(point2[2], 0, 1, 0, 100)+")");
    cam.updatePixels();
  }

  image(cam, 0, 0, width, height); //set(0, 0, cam);
}

public void search(Node node) {
  if (node.parent != null) {
    //fill(color(node.col, .7, .7));
    //point(node.nodeX, node.nodeY);
    println("Node: ("+node.nodeX+", "+node.nodeY+")  Parent: "+"("+node.parent.nodeX+", "+node.parent.nodeY+")");
  }
}


public colorObject flood(colorObject shape, int start, float low, float high, boolean[] goodPix) {

  if (goodPix[start+1] && hue(cam.pixels[start+1]) > low && hue(cam.pixels[start+1]) < high) {
    shape.addToPixels((start+1)%width + 1, (int)((start+1)/width), (low+high)/2.0, (start+1)%width, (int)((start+1)/width));
    goodPix[start+1] = false;
    flood(shape, start+1, low, high, goodPix);
  } else if (goodPix[start+width] && hue(cam.pixels[start+width]) > low && hue(cam.pixels[start+width]) < high) {
    shape.addToPixels((start+width)%width + 1, (int)((start+width)/width), (low+high)/2.0, (start+width)%width, (int)((start+width)/width));
    goodPix[start+width] = false;
    flood(shape, start+width, low, high, goodPix);
  } else if (goodPix[start-1] && hue(cam.pixels[start-1]) > low && hue(cam.pixels[start-1]) < high) {
    shape.addToPixels((start-1)%width + 1, (int)((start-1)/width), (low+high)/2.0, (start-1)%width, (int)((start-1)/width));
    goodPix[start-1] = false;
    flood(shape, start-1, low, high, goodPix);
  } else if (goodPix[start-width] && hue(cam.pixels[start-width]) > low && hue(cam.pixels[start-width]) < high) {
    shape.addToPixels((start-width)%width + 1, (int)((start-width)/width), (low+high)/2.0, (start-width)%width, (int)((start-width)/width));
    goodPix[start-width] = false;
    flood(shape, start-width, low, high, goodPix);
  }


  return shape;
}