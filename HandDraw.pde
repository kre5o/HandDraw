import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv, opencv3;

Rectangle[] fists, fistsL, palm;

PGraphics background;
float oldX, oldY;
float pointerX, pointerY;
color pointerC;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv3 = new OpenCV(this, 640/2, 480/2);

  opencv.loadCascade("fist.xml");
  opencv3.loadCascade("palm.xml");

  background = createGraphics(640/2, 480/2);
  video.start();
  oldX = -1;
  oldY = -1;
  pointerX = 0;
  pointerY = 0;
  pointerC = color(0);
}

void draw() {
  scale(2);
  fill(0);
  background(255, 255, 255);
  //image(video, 0, 0 );
  opencv.loadImage(video);

  //desna šaka
  fists = opencv.detect();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  for (int i = 0; i < fists.length; i++) {
    //rect(fists[i].x, fists[i].y, fists[i].width, fists[i].height);
  }

  //mirror    
  PImage img = createImage(640/2, 480/2, ARGB);
  img.copy(video, 0, 0, video.width, video.height, 0, 0, img.width, img.height);
  img.loadPixels();
  for (int i = 0; i < img.width/2; i++) {
    for (int j = 0; j < img.height; j++) {  
      color tmp = img.pixels[j*img.width+i];
      img.pixels[j*img.width+i] = img.pixels[(img.width - i - 1) + j*img.width];
      img.pixels[(img.width - i - 1) + j*img.width] = tmp;
    }
  }
  img.updatePixels();
  //lijeva šaka
  opencv.loadImage(img);
  fistsL=opencv.detect();
  stroke(225, 0, 0);
  for (int i = 0; i < fistsL.length; i++) {
    //if (fistsL[i].x<320/2) rect(320/2+abs(fistsL[i].x-320/2)-fistsL[i].width, fistsL[i].y, fistsL[i].width, fistsL[i].height);
    //else rect(320/2-abs(fistsL[i].x-320/2)-fistsL[i].width, fistsL[i].y, fistsL[i].width, fistsL[i].height);
  }

  //dlan
  if (fists.length == 0) {
    opencv3.loadImage(video);
    palm=opencv3.detect();
    stroke(0, 0, 255);
    for (int i = 0; i < palm.length; i++) {
      //rect(palm[i].x, palm[i].y, palm[i].width, palm[i].height);
    }

    //reset line
    oldX = -1;
    oldY = -1;

    if (palm.length>0) {
      pointerX = palm[0].x+palm[0].width/2;
      pointerY = palm[0].y+palm[0].height/2;
      pointerC = color(0);
    }
  } else {
    //crtaj
    float drawX = fists[0].x+fists[0].width/2;
    float drawY = fists[0].y+fists[0].height/2;

    pointerX = drawX;
    pointerY = drawY;
    pointerC = color(255, 0, 0);

    if (oldX == -1) {
      oldX = drawX;
      oldY = drawY;
    }

    background.stroke(255, 0, 0);
    background.beginDraw();
    background.line(drawX, drawY, oldX, oldY);
    background.endDraw();
    oldX = drawX;
    oldY = drawY;
  }
  image(background, 0, 0);
  drawCross(pointerX, pointerY);
}

void captureEvent(Capture c) {
  c.read();
}

void drawCross(float X, float Y) {
  stroke(pointerC);
  line(X+5, Y, X-5, Y);
  line(X, Y+5, X, Y-5);
}