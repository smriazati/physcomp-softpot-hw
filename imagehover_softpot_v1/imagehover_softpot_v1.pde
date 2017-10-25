import netP5.*;
import oscP5.*;

OscP5 oscP5;
//NetAddress myRemoteLocation;

int counter = 20; // number of images, would be cooler if it could count the folder
PImage[] imgs = new PImage[counter]; // declary the array, create 20 spots

int windowWidth = 800;

String softPotValue;
String softPotValueTrim;
String spNull = "null";
int softPotIntValue;
float softPotMappedValue = 200;

void setup() {
  size(800,600); // can't use variables here
  background(0);
  
  oscP5 = new OscP5(this,1234);

  // load an array of images named photo*.jpg
  for (int i = 1; i < counter; i++) {
    imgs[i] = loadImage("photo" + i + ".jpg");
  }
}

void draw() { 
  image(imgs[counter/2], 0, 0); // draw the default image

  // debugging
  println("SP value from photon: "+softPotValueTrim);

  // would be best to put this in a condition, only happens if softPotValueTrim != null
  softPotIntValue = int(softPotValueTrim); // turn this line off if not working
  softPotMappedValue = map(softPotIntValue,200,4000,0,windowWidth);
  
  int bandWidth = windowWidth / imgs.length+1; // divide the window width by the number of items in range + 1
  int k = 0; // declare a variable to hold previous value of i

  for (int i=1; i < counter; i++ ) {
      // if softPotMappedValue is under 0, show default
       if (softPotMappedValue < 0) {
      image(imgs[counter/2], 0, 0); 
  }
    // if softPotMappedValue is between 0 & windowWidth, do the thing
    if (softPotMappedValue > k*bandWidth && softPotMappedValue <= i*bandWidth) { 
      image(imgs[i], 0, 0); 
      k = i; 
      println("showing image: photo"+i+".jpg");
    }
  }
  println("Mapped SP val: "+softPotMappedValue);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/photon")==true){
    softPotValue = theOscMessage.get(0).stringValue();
    softPotValueTrim = softPotValue.trim();
    return;
  }
}