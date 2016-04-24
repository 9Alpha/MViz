import processing.video.*;
import java.awt.*;
import java.util.*;

Capture cam;
int res = 1;
int count = 0;
float[] hsbVals = new float[3];

void setup() {

  size(800, 448);
  noStroke();
  colorMode(HSB, 1);
  String[] cameras = Capture.list();
  for (int i = 0; i < cameras.length; i++) {
    println("["+i+"]: "+cameras[i]);
  }

  cam = new Capture(this, cameras[7]);
  cam.start();
}


void draw() {
  if (cam.available() == true) {
    cam.read();

    cam.loadPixels();



    for (int i = 0; i < cam.pixels.length; i+=res) {
      if (hue(cam.pixels[i]) > .8 && saturation(cam.pixels[i]) > .5) {
         cam.pixels[i] = color(0, 0, 0);
      }
    }
    
    
    cam.updatePixels();
    set(0, 0, cam);
  }
}