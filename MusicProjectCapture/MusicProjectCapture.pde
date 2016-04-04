import processing.video.*;
import java.awt.*;

Capture cam;
int count = 0;
float[] hsbVals = new float[3];

void setup() {
  size(640, 480);
  colorMode(HSB);
  String[] cameras = Capture.list();
  for (int i = 0; i < cameras.length; i++) {
    println("["+i+"]: "+cameras[i]);
  }

  cam = new Capture(this, cameras[14]);
  cam.start();
}

void draw() {
  if (cam.available() == true) {
    cam.read();


    cam.loadPixels();
    for (int i = 0; i < cam.pixels.length; i++) {
      if (hue(cam.pixels[i]) > 100 && hue(cam.pixels[i]) < 140) {
        cam.pixels[i] = color(0, 0, 0);
      }
    }
    loadPixels();
    color point = color(get(mouseX, mouseY));
    
    int r = (point)&0xFF;
    int g = (point>>8)&0xFF;
    int b = (point>>16)&0xFF;
    int a = (point>>24)&0xFF;
    
    float[] point2 = Color.RGBtoHSB(r, g, b, hsbVals);
    
    println("("+map(point2[0], 0, 1, 0, 360)+", "+map(point2[1], 0, 1, 0, 100)+", "+map(point2[2], 0, 1, 0, 100)+")");
    cam.updatePixels();
  }

  image(cam, 0, 0, width, height); //set(0, 0, cam);
}