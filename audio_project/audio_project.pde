import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.signals.*;
import ddf.minim.ugens.*;
import controlP5.*;
import java.util.*;

Minim minim;
ControlP5 cp5;
Textfield tf;

InputTest inputTest;
OutputTest outputTest;

void setup() {
  size(800, 600);
  background(0);
  
  minim = new Minim(this);
  inputTest = new InputTest();
  //outputTest = new OutputTest();
  
  // Setup GUI
  cp5 = new ControlP5(this);
  tf = cp5.addTextfield("textInput")
        .setPosition(20, 200)
        .setSize(500, 100)
        .setAutoClear(false)
        .setText("C3,E3 - G2,F3 F#3 C3,G3 - G2,F3 E3 D3 - A2,D3 A2 D2 - A2");
  cp5.addBang("Play")
    .setPosition(20, 300)
    .setSize(50, 20);
}

void Play() {
  outputTest.PlaySequence(tf.getText());
}

void draw() {
  inputTest.Update();
  //outputTest.Update();
}

void keyPressed() {
  outputTest.OnKeyPressed(key); 
}

void keyReleased() {
   
}

void stop() {
  minim.stop();
  super.stop();
}
