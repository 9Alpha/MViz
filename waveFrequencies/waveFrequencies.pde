import processing.sound.*;

AudioIn in;
FFT fft;
int bands = 8192;//4096
float cFreq = 2.692;
float[] spec = new float[bands];
float[] spectrum = new float[bands];//array of frequency values

float[] pureSpectrum;

int index = 0;//time value
int speed = 1;
double amp = 1;//amplitude
float freq = speed;

float estFreq;
int fundamental = 0;//maximun displayed frequency
int harmonicCount;//number of pure harmonics
boolean pure = false;//if pure is activated
boolean calcFreq = true;//if frequencyCalculation is activated
String estFreqString = "";
//float[] harmonics;

int sf = 10;//starting frequency
int frequencies = 10;//number of frequencies desplayed
int[] selF = new int[frequencies];//array of displayed frequencies


int[] buffer = new int[500*frequencies];//all separated waves
int[] combinedBuffer = new int[500];//combined wave

int[] start = new int[frequencies];//starting points
int[] end = new int[frequencies];//ending points


void setup() {
  size(600,600);
  background(255);
 
 
  textSize(32);
  fill(0);
  
  fft = new FFT(this, bands);
  
  in = new AudioIn(this, 0);
  in.start();
  
  fft.input(in);
  
  for(int i = 0; i < frequencies; i++) {
    start[i] = i*500;
    end[i] = 500*(i+1)-speed;
    selF[i] = sf+i;
  }


}


int cStart = 0;//combined start
int cEnd = 500 - speed;//combined end

void draw() {
  background(255);
  printButtons();
  fft.analyze(spec);
  
  if (pure == true) {
    spectrum = purifyFFT(spec);
  }
  else {
    spectrum = spec;
    if(calcFreq == true) {
      int f = 1;
      for(int i = 100; i < 4000; i++) {
        if(spectrum[i] - spectrum[i-1] > .0001 && spectrum[i] - spectrum[i+1] > .0001 && spectrum[i]*600 >=1) {
          //if(spectrum[i] > spectrum[f])
            f = i;
            break;
        }
      }
      fundamental = f;
      estFreq = (spectrum[f-1]*cFreq*(f-1)+spectrum[f]*cFreq*(f)+spectrum[f+1]*cFreq*(f+1))/(spectrum[f-1]+spectrum[f]+spectrum[f+1]);
      //println(f*21.53);
      estFreqString = nfc(estFreq,2);
    }
  }
  splitFrequencies();
  generateWave();
  
  printCombinedWave(combinedBuffer, cStart, cEnd);
  
  printWave(buffer,start,end);
  index+=1;
}

void splitFrequencies() {
  for(int i = 0; i < frequencies; i++) {
    buffer[start[i]] = (int)((spectrum[selF[i]]*600*amp)*Math.sin(index*Math.PI*.0002*(selF[i])));
    
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
    
  }
}

void generateWave() {
  combinedBuffer[cStart] = 0;
  
  if(pure == false) {
    for(int i = 0; i < spectrum.length; i++) {
      combinedBuffer[cStart]+=(int)((spectrum[i]*600*amp)*Math.sin(index*Math.PI*.0002*(i)));
    }//raw 
  }
  
  else {
    for(int i = 1; i < spectrum.length; i++) {
      
        combinedBuffer[cStart]+=(int)((spectrum[i]*600*amp)*Math.sin(index*Math.PI*.0002*(fundamental * round((float)(i)/(float)(fundamental)))));

    }//pure
    
  }
  
  if(cStart >= 500 - speed) {
     cStart = 0;
     cEnd +=speed;
   }
   else if(cEnd >= 500 - speed) {
     cStart+=speed;
     cEnd = 0;
   }
   else {
     cStart+=speed;
     cEnd+=speed;
   }
  
}

float[] purifyFFT(float [] f) {
  //harmonicCount = 0;
  float[] p = new float [bands];
  boolean first = true;
  for(int i = 1; i < bands - 1; i++) {
    if(f[i] - f[i-1] > .00001 && f[i] - f[i+1] > .00001 && f[i]*600 >=1) {
      p[i] = f[i];
      if (first == true) {
        fundamental = i;
        first = false;
      }
    }
    else
      p[i] = 0.0;
  }
  return p;
}

void printWave(int[] wave, int[] s, int[] e) {
  
  stroke(0);
  //println(s[0]+", "+e[0]);

  for(int f = 0; f <= frequencies; f++) {//frequencies
    if(f == frequencies) {
      
    }
    else {
      int x = 500;
      int st = s[f];
      while(st != e[f]) {
        if(st >= (f+1)*500 - speed) {
          //println("true1");
          line(x,(int)((500/(frequencies+1))*(f+1)-wave[st]),x-speed,(int)((500/(frequencies+1))*(f+1)-wave[500*f]));
          st = 500*f;
        }
        else {
          //println("true2");
          line(x,(int)((500/(frequencies+1))*(f+1)-wave[st]),x-speed,(int)((500/(frequencies+1))*(f+1)-wave[st+speed]));
          st+=speed;
        }
    
        x-=speed;
      
      }
      text(nfc((float)(selF[f]*cFreq),2), 469, (500/(frequencies+1))*(f+1)+10);
    }
    
  }
  
  
}

void printCombinedWave(int wave[], int s, int e) {
    stroke(253,129,237);
    int x = 500;
    
    while(s != e) {
      if(s >= 500 - speed) {
        //println("true1");
        line(x,(int)(500+50-wave[s]),x-speed,(int)(500+50-wave[0]));
        s = 0;
      }
      else {
        //println("true2");
        line(x,(int)(500+50-wave[s]),x-speed,(int)(500+50-wave[s+speed]));
        s+=speed;
      }
    
      x-=speed;
      
    }
}

void printButtons() {
  textSize(10);
  fill(0);
  rect(507,0,100,600);
  fill(255,0,0);//move range down
  rect(508,50,90,30);
  fill(0);
  text("Freq. Range Down",510,70);
  
  fill(0,255,0);
  rect(508,100,90,30);//move range up
  fill(0);
  text("Freq. Range Up",510,120);
  
  fill(255,0,0);
  rect(508,150,60,30);//-freq
  fill(0);
  text("-Freq",510,170);
  
  fill(0,255,0);
  rect(508,190,60,30);//+freq
  fill(0);
  text("+Freq",510,210);
  
  if(pure == false) {
    fill(120,170,210);
    rect(508, 300, 90, 50);
    fill(0);
    text("Estimate Freq.", 510, 320);
    text(estFreqString + " hz", 520,340);
    fill(50,200,200);
    rect(508, 370, 90, 30);
    fill(0);
    text("Go to freq.", 520, 390);
  }
  if(pure == true)
    fill(200,200,200);
  else
    fill(255,255,255);
  rect(508, 480, 90, 30);
  fill(0);
  text("Harmonic Analysis", 509, 500);
  if(pure == true)
    fill(0,100,255);
  else
    fill(255,255,255);
  rect(508,525,90,50);//purify wave
  fill(0);
  text("Purify Wave",520,550);
}

void mouseClicked() {
  if(mouseX > 508 && mouseY > 50 && mouseX <598 && mouseY < 80 && sf > 0) {
    sf--;
    for(int i = 0; i < buffer.length; i++) {
      buffer[i] = 0;
    }
    for(int i = 0; i < frequencies; i++) {
      selF[i] = sf+i;
    }
  }
  else if(mouseX > 508 && mouseY > 100 && mouseX <598 && mouseY < 130) {
    sf++;
    for(int i = 0; i < buffer.length; i++) {
      buffer[i] = 0;
    }
    for(int i = 0; i < frequencies; i++) {
      selF[i] = sf+i;
    }
  }
  else if(mouseX > 508 && mouseY > 150 && mouseX <568 && mouseY < 180 && frequencies > 1) {
    frequencies-=1;

    buffer = new int[500*frequencies];
    

    start = new int[frequencies];
    end = new int[frequencies];
    selF = new int[frequencies];
    
    for(int i = 0; i < frequencies; i++) {
      start[i] = i*500;
      end[i] = 500*(i+1)-speed;
      selF[i] = sf+i;
    }
  }
  else if(mouseX > 508 && mouseY > 190 && mouseX <568 && mouseY < 220) {
    frequencies+=1;

    buffer = new int[500*frequencies];

    start = new int[frequencies];
    end = new int[frequencies];
    selF = new int[frequencies];
    
    for(int i = 0; i < frequencies; i++) {
      start[i] = i*500;
      end[i] = 500*(i+1)-speed;
      selF[i] = sf+i;
    }
  }
  else if(mouseX > 508 && mouseY > 480 && mouseX <598 && mouseY < 510 && pure == true) {
    ArrayList<Integer> harmonics = new ArrayList<Integer>();
    for(int i = 1; i < spectrum.length - 1; i++) {
      if(spectrum[i] !=0) {
        harmonics.add(i);
      } 
    }
    frequencies = harmonics.size();
    selF = new int[frequencies];
    buffer = new int[500*frequencies];

    start = new int[frequencies];
    end = new int[frequencies];
    
    
    for(int i = 0; i < frequencies; i++) {
      start[i] = i*500;
      end[i] = 500*(i+1)-speed;
    }
    for(int i = 0; i < harmonics.size(); i++) {
      selF[i] = harmonics.get(i);;
      if(i == 0)
        sf = harmonics.get(i);
    } 
    
  }
  else if(mouseX > 508 && mouseY > 525 && mouseX <598 && mouseY < 575 ) {
    pure = !pure;
  }
  else if(mouseX > 508 && mouseY > 300 && mouseX <598 && mouseY < 350  && pure == false) {
    calcFreq = !calcFreq;
  }
  else if(mouseX > 508 && mouseY > 370 && mouseX <598 && mouseY < 390  && pure == false) {
    sf = fundamental;
    for(int i = 0; i < buffer.length; i++) {
      buffer[i] = 0;
    }
    for(int i = 0; i < frequencies; i++) {
      selF[i] = sf+i;
    }
  }
  
  
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && amp < 10) {
      amp+= .1;
    } else if (keyCode == DOWN && amp > .01) {
      amp-=.1;
    }
    
  }
}