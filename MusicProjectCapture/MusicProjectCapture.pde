import processing.video.*;
import java.awt.*;
import java.util.*;

Capture cam;
int count = 0;
float[] hsbVals = new float[3];

Tree tree = new Tree(0, 0);

String searchReturn = "";

void setup() {
  tree.add(1, 0, 0, 0);
  tree.add(1, 1, 1, 0);
  tree.add(1, 2, 1, 1);
  tree.add(2, 2, 1, 2);
  flood(0, 0, 0);
  size(960, 540);
  colorMode(HSB);
  String[] cameras = Capture.list();
  for (int i = 0; i < cameras.length; i++) {
    println("["+i+"]: "+cameras[i]);
  }

  cam = new Capture(this, cameras[3]);
  cam.start();
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    
    boolean[] goodPix = new boolean[cam.pixels.length];
    for (int i = 0; i < cam.pixels.length; i++) {
      goodPix[i] = true;
    }
    LinkedList<colorObject> seenObjects = new LinkedList<colorObject>();
    

    cam.loadPixels();
    for (int i = 0; i < cam.pixels.length; i++) {
      if (goodPix[i]) {
         goodPix[i] = false;
         seenObjects.add(new colorObject(hue(cam.pixels[i])-5, hue(cam.pixels[i])+5, i%width, (int)(i/width)));
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
  if (node.parent != null)
    println("Node: ("+node.nodeX+", "+node.nodeY+")  Parent: "+"("+node.parent.nodeX+", "+node.parent.nodeY+")");
}


public void flood(int start, float low, float high) {
  tree.traverseDF(tree._root, false, 0, 0);
}