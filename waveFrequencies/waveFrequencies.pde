import processing.sound.*;
//Amplitude Amp;
AudioIn in;
FFT fft;
int bands = 16;//512
float[] spectrum = new float[bands];

//int[] array = new int[5000];
int index = 0;
int speed = 4;
double amp = 1;
float freq = speed;

int frequencies = 5;

int[] buffer = new int[500*frequencies];

int[] start = new int[frequencies];
int[] end = new int[frequencies];


void setup() {
  size(500,500);
  background(255);
  textSize(32);
  fill(0);
  
  fft = new FFT(this, bands);
  //Amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  
  //Amp.input(in);
  fft.input(in);
  
  for(int i = 0; i < frequencies; i++) {
    start[i] = i*500;
    end[i] = 500*(i+1)-speed;
  }


}

//ArrayList<Integer> buffers = new ArrayList<Integer>();




//int start = 0;
//int end = 500 - speed;
void draw() {
  fft.analyze(spectrum);
  for(int i = 0; i < frequencies; i++) {
    buffer[start[i]] = (int)(spectrum[i*2]*100);
    if(start[i] >= (i+1)*500 - speed) {
      start[i] = i*500;
      end[i] +=speed;
    }
    else if(end[i] >= (i+1)*500 - speed) {
      start[i]+=speed;
      end[i] = i*500;
    }
    else {
      start[i]+=speed;
      end[i]+=speed;
    }
    //println("start: "+start[i]);
    //println("end: "+end[i]);
  }
  printWave(buffer,start,end);
  
  
}

void printWave(int[] wave, int[] s, int[] e) {
  background(255);
  //println(s[0]+", "+e[0]);
  
  for(int f = 0; f < frequencies; f++) {//frequencies
    int x = 500;
    int st = s[f];
    while(st != e[f]) {
      if(st >= (f+1)*500 - speed) {
        //println("true1");
        line(x,(int)(100*f+50-wave[st]),x-speed,(int)(100*f+50-wave[500*f]));
        st = 500*f;
      }
      else {
        //println("true2");
        line(x,(int)(100*f+50-wave[st]),x-speed,(int)(100*f+50-wave[st+speed]));
        st+=speed;
      }
    
      x-=speed;
      
    }
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