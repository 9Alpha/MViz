
import processing.sound.*;
Amplitude Amp;
AudioIn in;

int[] array = new int[5000];
int index = 0;
int speed = 4;
double amp = 1;
float freq = speed;

void setup() {
  size(500,100);
  background(255);
  textSize(32);
  fill(0);

  Amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  Amp.input(in);

  /*
  for(int i = 0; i < array.length; i++) {
     array[i] = (int)(25*Math.sin(i/20.0*speed));
  }
  */
}

int[] buffer = new int[500];
int start = 0;
int end = 500 - speed;
void draw() {
  //println(speed);

  //buffer[start] = (int)(amp*(int)(25*Math.sin(index/20.0*freq)));
  buffer[start] = (int)(Amp.analyze()*500);

  if(start >= buffer.length - speed) {
    start = 0;
    end +=speed;
  }
  else if(end >= buffer.length - speed) {
    start+=speed;
    end = 0;
  }
  else {
    start+=speed;
    end+=speed;
  }
  if(index == array.length - 1) 
    index = 0;
  else
    index++;
  
  //if(start%50 == 0) 

  printWave(buffer,start,end);
  //printBars(buffer, start, end);

  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && amp < 10) {
      amp+= .1;
    } else if (keyCode == DOWN && amp > .01) {
      amp-=.1;
    }
    else if (keyCode == LEFT && freq > 1) {
      freq-=.1;
    }
    else if (keyCode == RIGHT && freq < 15) {
      freq+=.1;
    }
    
  }
}

void printWave(int[] wave, int s, int e) {
  background(255);
  int x = 500;

  while(s != e) {
    //point(x,50-wave[s]);
    
    
    if(s >= wave.length - speed) {
      line(x,(int)(50-wave[s]),x-speed,(int)(50-wave[0]));
      s = 0;
    }
    else {
      line(x,(int)(50-wave[s]),x-speed,(int)(50-wave[s+speed]));
      s+=speed;
    }
    
    x-=speed;
      
  }
  
}

void printBars(int[] wave, int s, int e) {
  background(255);
 
 int count = 9;
 
 while(count >= 0) {
  fill(20*count, 255-50*count,0);
  rect(50*count,90 ,50,-40+1.5*wave[s]);
  if(s >= wave.length - speed) {
    s = 0;
  }
  else {
    s+=speed;
  }
  count--;
 }

}

void printArray(int[] a) {
  background(255);
  for(int x = 0; x < a.length; x+=2) {
    text(String.valueOf(a[x]), index, 50);
  }

}