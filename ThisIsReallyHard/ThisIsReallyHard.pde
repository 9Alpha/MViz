import processing.video.*;
import java.awt.*;
import java.util.*;

Capture cam;
int count = 0;
float[] hsbVals = new float[3];

void setup() {
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
    

    cam.loadPixels();
    loadPixels();
    color point = color(get(mouseX, mouseY));
    
    int r = (point)&0xFF;
    int g = (point>>8)&0xFF;
    int b = (point>>16)&0xFF;
    int a = (point>>24)&0xFF;
    
    float[] point2 = Color.RGBtoHSB(r, g, b, hsbVals);
    
    println("("+point2[0]+", "+point2[1]+", "+point2[2]+")");
    cam.updatePixels();
  }

  image(cam, 0, 0, width, height); //set(0, 0, cam);
}

public void flood(int start, float low, float high) {
  
}