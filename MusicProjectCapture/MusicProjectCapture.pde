import processing.video.*;
import java.awt.*;
import java.util.*;

int PixelTotal = 0;
int CountTotal = 0;
int Cwidth = 80;
int Cheight = 45;

float fretToNeck = .6875;

int[] tuning = {16, 21, 26, 31, 35, 40};
String[] noteNames = {"C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B"};
int[] altTuning = new int[6];

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
  colorMode(HSB, 1, 1, 1);
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
    count++;
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
    LinkedList<colorObject> bases = new LinkedList<colorObject>();


    if (count > 15) {
      for (int i = 0; i < cam.pixels.length; i+=res) {
        //if (goodPix[i] && hue(cam.pixels[i]) > .7 && saturation(cam.pixels[i]) > .3) { //reds
        if (goodPix[i] && hue(cam.pixels[i]) < .5 && hue(cam.pixels[i]) > .4 && saturation(cam.pixels[i]) < .6 && saturation(cam.pixels[i]) > .4) {  //greens
          goodPix[i] = false;
          colorObject shape = new colorObject(hue(cam.pixels[i])-colorRes, hue(cam.pixels[i])+colorRes, 
            saturation(cam.pixels[i]), brightness(cam.pixels[i]), i%Cwidth, (int)(i/Cwidth));
          seenObjects.add(flood(shape, i, hue(cam.pixels[i])-colorRes, hue(cam.pixels[i])+colorRes, saturation(cam.pixels[i])-colorRes, saturation(cam.pixels[i])+colorRes, goodPix));
        } else if (goodPix[i] && hue(cam.pixels[i]) > .6 && hue(cam.pixels[i]) < .7 && saturation(cam.pixels[i]) > .3) { //blue? 
        //if (goodPix[i] && hue(cam.pixels[i]) < .7 && hue(cam.pixels[i]) > .65 && saturation(cam.pixels[i]) > .8) { //blues
          hasBase = true;
          colorObject shape2 = new colorObject(hue(cam.pixels[i])-colorRes, hue(cam.pixels[i])+colorRes, 
            saturation(cam.pixels[i]), brightness(cam.pixels[i]), i%Cwidth, (int)(i/Cwidth));
          bases.add(flood(shape2, i, hue(cam.pixels[i])-colorRes, hue(cam.pixels[i])+colorRes, saturation(cam.pixels[i])-colorRes, saturation(cam.pixels[i])+colorRes, goodPix));
        }
      }
    }



    if (hasBase) {
      int baseNum = 0;
      int maxBase = 0;
      for (int i = 0; i < bases.size(); i++) {
        if (bases.get(i).count() > maxBase) {
          maxBase = bases.get(i).count();
          baseNum = i;
        }
      }

      base = bases.get(baseNum);

      fill(1);
      stroke(1);
      base.outPut();
      rectMode(CORNERS);
      fill(0);
      rect(base.leftX + 200, base.lowY, base.rightX + 200, base.bigY);
      for (float j = 0; j < 6; j++) {
        line(base.rightX + 200, base.lowY + int(float(base.bigY-base.lowY)*(j/5.0)), 
          base.rightX + 100, base.lowY + int(float(base.bigY-base.lowY)*(j/5.0)));
        altTuning[(int)j] = tuning[(int)j];
      }
      noStroke();
      fill(1, 1, 1);
      for (int i = 0; i < seenObjects.size(); i++) {
        rectMode(CORNERS);
        rect(seenObjects.get(i).leftX + 200, seenObjects.get(i).bigOtherY, seenObjects.get(i).rightX + 200, seenObjects.get(i).bigY);
        rectMode(CORNER);
        seenObjects.get(i).outPut();
        for (float j = 0; j < 6; j++) {
          if (base.lowY + int(float(base.highY-base.lowY)*(j/5.0)) < seenObjects.get(i).lowY 
            && base.highY + int(float(base.highY-base.lowY)*(j/5.0)) > seenObjects.get(i).lowY) {
            altTuning[(int)j] += ((seenObjects.get(i).rightX + seenObjects.get(i).leftX)/2.0) % ((base.highY-base.lowY)*fretToNeck) + 1;
          }
        }
      }
      for (float j = 0; j < 6; j++) {
        textSize(int(float(base.bigY-base.lowY)*(1/5.0))/2);
        text(noteNames[altTuning[(int)j]%12], base.rightX + 250, base.lowY + int(float(base.bigY-base.lowY)*(j/5.0)));
      }
      rectMode(CORNER);
    }
    cam.updatePixels();
    seenObjects.clear();
  }


  //image(cam, 0, 0, width, height);
}

public void export(Node node) {
  rect(node.nodeX, node.nodeY, res, res);
}



public colorObject flood(colorObject shape, int start, float lowH, float highH, float lowS, float highS, boolean[] goodPix) {


  if (goodPix[start+res] && hue(cam.pixels[start+res]) > lowH && hue(cam.pixels[start+res]) < highH 
    && saturation(cam.pixels[start+res]) > lowS && saturation(cam.pixels[start+res]) < highS) {
    shape.addToPixels((start+res)%Cwidth, (int)((start+res)/Cwidth), (lowH+highH)/2.0, saturation(cam.pixels[start+res]), brightness(cam.pixels[start+res]), (start)%Cwidth, (int)((start)/Cwidth));
    goodPix[start+res] = false;
    flood(shape, start+res, lowH, highH, lowS, highS, goodPix);
  } else if (goodPix[start+Cwidth] && hue(cam.pixels[start+Cwidth]) > lowH && hue(cam.pixels[start+Cwidth]) < highH
    && saturation(cam.pixels[start+res]) > lowS && saturation(cam.pixels[start+res]) < highS) {
    shape.addToPixels((start+(Cwidth*res))%Cwidth, (int)((start+(Cwidth*res))/Cwidth), (lowH+highH)/2.0, saturation(cam.pixels[start+(Cwidth*res)]), brightness(cam.pixels[start+(Cwidth*res)]), (start)%Cwidth, (int)((start)/Cwidth));
    goodPix[start+(Cwidth*res)] = false;
    flood(shape, start+(Cwidth*res), lowH, highH, lowS, highS, goodPix);
  } else if (goodPix[start-1] && hue(cam.pixels[start-1]) > lowH && hue(cam.pixels[start-1]) < highH
    && saturation(cam.pixels[start+res]) > lowS && saturation(cam.pixels[start+res]) < highS) {
    shape.addToPixels((start-res)%Cwidth, (int)((start-res)/Cwidth), (lowH+highH)/2.0, saturation(cam.pixels[start-res]), brightness(cam.pixels[start-res]), (start)%Cwidth, (int)((start)/Cwidth));
    goodPix[start-res] = false;
    flood(shape, start-res, lowH, highH, lowS, highS, goodPix);
  } else if (goodPix[start-Cwidth] && hue(cam.pixels[start-Cwidth]) > lowH && hue(cam.pixels[start-Cwidth]) < highH 
    && saturation(cam.pixels[start+res]) > lowS && saturation(cam.pixels[start+res]) < highS) {
    shape.addToPixels((start-(Cwidth*res))%Cwidth, (int)((start-(Cwidth*res))/Cwidth), (lowH+highH)/2.0, saturation(cam.pixels[start-(Cwidth*res)]), brightness(cam.pixels[start-(Cwidth*res)]), (start)%Cwidth, (int)((start)/Cwidth));
    goodPix[start-(Cwidth*res)] = false;
    flood(shape, start-(Cwidth*res), lowH, highH, lowS, highS, goodPix);
  } else {
    Node node = shape.pixelList.traverseDF(shape.pixelList._root, 0, start%Cwidth, (int)(start/Cwidth), false);
    if (node != null && node.parent != null) {
      start = (node.parent.nodeY)*Cwidth + node.parent.nodeX;
      flood(shape, start, lowH, highH, lowS, highS, goodPix);
    }
  }



  return shape;
}