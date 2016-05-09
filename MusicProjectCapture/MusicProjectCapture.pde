import processing.video.*;
import java.awt.*;
import java.util.*;

int PixelTotal = 0;
int CountTotal = 0;
int Cwidth = 80;
int Cheight = 45;

int largestNodeY = 0; 
int smallestNodeY = Cheight+10;
int leftNodeX = Cwidth+10; 
int rightNodeX = 0;

float colorRes = .1;
colorObject base;
boolean hasBase = false;

Capture cam;
int res = 1;
int count = 0;
float[] hsbVals = new float[3];

//Tree tree = new Tree(0, 0);

String searchReturn = "";

void setup() {
  size(640, 180);
  noStroke();
  colorMode(HSB, 1);
  String[] cameras = Capture.list();
  for (int i = 0; i < cameras.length; i++) {
    println("["+i+"]: "+cameras[i]);
  }

  cam = new Capture(this, cameras[12]);
  cam.start();
}

public boolean[] updateGood(int top, boolean[] grid) {
  for (int i = 0; i < top; i++) {
    for (int j = 0; j < res; j++) {
      if (i % Cwidth == j || i % Cwidth == Cwidth-j-1) {
        grid[i] = false;
      }
    }
    if (i < Cwidth*res || i > top-1-(Cwidth*res)) {
      grid[i] = false;
    }
  }
  return grid;
}

void draw() {
  if (cam.available() == true) {
    background(.7);
    cam.read();

    //set(0, 0, cam);
    image(cam, 0, 0, 80, 45);

    cam.loadPixels();
    hasBase = false;

    boolean[] goodPix = new boolean[cam.pixels.length];
    for (int i = 0; i < cam.pixels.length; i++) {
      goodPix[i] = true;
    }
    goodPix = updateGood(cam.pixels.length, goodPix);
    LinkedList<colorObject> seenObjects = new LinkedList<colorObject>();



    for (int i = 0; i < cam.pixels.length; i+=res) {
      if (goodPix[i] && hue(cam.pixels[i]) < .389 && hue(cam.pixels[i]) > .222 && saturation(cam.pixels[i]) > .3) {
        goodPix[i] = false;
        colorObject shape = new colorObject(hue(cam.pixels[i])-colorRes, hue(cam.pixels[i])+colorRes, saturation(cam.pixels[i]), brightness(cam.pixels[i]), i%Cwidth, (int)(i/Cwidth));
        seenObjects.add(flood(shape, i, hue(cam.pixels[i])-colorRes, hue(cam.pixels[i])+colorRes, goodPix));
      } else  if (goodPix[i] && hue(cam.pixels[i]) < .694 && hue(cam.pixels[i]) > .4 && saturation(cam.pixels[i]) > .2) {
        hasBase = true;
        colorObject shape2 = new colorObject(hue(cam.pixels[i])-colorRes, hue(cam.pixels[i])+colorRes, saturation(cam.pixels[i]), brightness(cam.pixels[i]), i%Cwidth, (int)(i/Cwidth));
        base = flood(shape2, i, hue(cam.pixels[i])-colorRes, hue(cam.pixels[i])+colorRes, goodPix);
      }
    }

    for (int i = 0; i < seenObjects.size(); i++) {
      //println(i);
      seenObjects.get(i).outPut();
      fill(1);
      stroke(1);
      strokeWeight(1);
      textSize(10);
      if (hasBase) {
        base.outPut();
        rectMode(CORNERS);
        fill(0);
        rect(base.leftX + 200, base.lowY, base.rightX + 200, base.highY);
        for (float j = 0; j < 6; j++) {
          line(base.rightX + 200, base.lowY + int(float(base.highY-base.lowY)*(j/5.0)), base.rightX + 100, base.lowY + int(float(base.highY-base.lowY)*(j/5.0)));
        }
        fill(1);
        rectMode(CORNER);
        line(seenObjects.get(i).centerX, seenObjects.get(i).centerY, base.centerX, base.centerY);
        //text(seenObjects.get(i).avgX()+", "+seenObjects.get(i).avgY(), seenObjects.get(i).avgX()*4, seenObjects.get(i).avgY()*16);
      }
      rectMode(CORNERS);
      fill(0);
      rect(seenObjects.get(i).leftX + 200, seenObjects.get(i).lowY, seenObjects.get(i).rightX + 200, seenObjects.get(i).highY);
      fill(1);
      rectMode(CORNER);
      noStroke();
    }

    //println("("+map(point2[0], 0, 1, 0, 360)+", "+map(point2[1], 0, 1, 0, 100)+", "+map(point2[2], 0, 1, 0, 100)+")");
    cam.updatePixels();
    seenObjects.clear();
  }


  //image(cam, 0, 0, width, height);
}

public void export(Node node) {
  if (node.parent != null) {
    //fill(color(node.hue, node.sat, node.bri));
    fill(1, 1, 1);
    rect(node.nodeX, node.nodeY, res, res);
    //println("Node: ("+node.nodeX+", "+node.nodeY+")  Parent: "+"("+node.parent.nodeX+", "+node.parent.nodeY+")");
  } else {
    //println("Node: ("+node.nodeX+", "+node.nodeY+")  Parent: _root");
  }
}



public colorObject flood(colorObject shape, int start, float low, float high, boolean[] goodPix) {


  if (goodPix[start+res] && hue(cam.pixels[start+res]) > low && hue(cam.pixels[start+res]) < high) {
    shape.addToPixels((start+res)%Cwidth, (int)((start+res)/Cwidth), (low+high)/2.0, saturation(cam.pixels[start+res]), brightness(cam.pixels[start+res]), (start)%Cwidth, (int)((start)/Cwidth));
    goodPix[start+res] = false;
    flood(shape, start+res, low, high, goodPix);
  } else if (goodPix[start+Cwidth] && hue(cam.pixels[start+Cwidth]) > low && hue(cam.pixels[start+Cwidth]) < high) {
    shape.addToPixels((start+(Cwidth*res))%Cwidth, (int)((start+(Cwidth*res))/Cwidth), (low+high)/2.0, saturation(cam.pixels[start+(Cwidth*res)]), brightness(cam.pixels[start+(Cwidth*res)]), (start)%Cwidth, (int)((start)/Cwidth));
    goodPix[start+(Cwidth*res)] = false;
    flood(shape, start+(Cwidth*res), low, high, goodPix);
  } else if (goodPix[start-1] && hue(cam.pixels[start-1]) > low && hue(cam.pixels[start-1]) < high) {
    shape.addToPixels((start-res)%Cwidth, (int)((start-res)/Cwidth), (low+high)/2.0, saturation(cam.pixels[start-res]), brightness(cam.pixels[start-res]), (start)%Cwidth, (int)((start)/Cwidth));
    goodPix[start-res] = false;
    flood(shape, start-res, low, high, goodPix);
  } else if (goodPix[start-Cwidth] && hue(cam.pixels[start-Cwidth]) > low && hue(cam.pixels[start-Cwidth]) < high) {
    shape.addToPixels((start-(Cwidth*res))%Cwidth, (int)((start-(Cwidth*res))/Cwidth), (low+high)/2.0, saturation(cam.pixels[start-(Cwidth*res)]), brightness(cam.pixels[start-(Cwidth*res)]), (start)%Cwidth, (int)((start)/Cwidth));
    goodPix[start-(Cwidth*res)] = false;
    flood(shape, start-(Cwidth*res), low, high, goodPix);
  } else {
    Node node = shape.pixelList.traverseDF(shape.pixelList._root, 0, start%Cwidth, (int)(start/Cwidth), false);
    if (node != null && node.parent != null) {
      start = (node.parent.nodeY)*Cwidth + node.parent.nodeX;
      flood(shape, start, low, high, goodPix);
    }
  }



  return shape;
}