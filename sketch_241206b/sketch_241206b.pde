import controlP5.*;
import processing.serial.*;

Serial myPort;         
ControlP5 cp5;         // ControlP5 
Knob meter1, meter2, meter3; //  three meters
ControlFont font; // 
boolean showResetButton = false;
int buttonX, buttonY, buttonWidth, buttonHeight;
int refreshButtonX, refreshButtonY, refreshButtonWidth, refreshButtonHeight;



float voltage1, voltage2, voltage3;



void setup() {
  size(1200, 800);      // Size of the window

  // *********************Initialize serial connection********************
  myPort = new Serial(this, "COM4", 9600);  
  myPort.bufferUntil('\n'); 

  // ********************Initialize ControlP5 and the meters**************
  cp5 = new ControlP5(this);
  PFont pfont = createFont("Arial", 20, true); 
  font = new ControlFont(pfont, 20); 
  
  //********************buzzer  button************************************
  buttonX = width*3 /4;
  buttonY = 250;
  buttonWidth = 200;
  buttonHeight = 40;
  myPort.write('A');
  
  //*******************refresh button***************************************
  refreshButtonX = width*3/4-150 ;
  refreshButtonY = 250;
  refreshButtonWidth = 150;
  refreshButtonHeight = 40;
  
  
  //****************meter1******************
  
meter1 = cp5.addKnob("Potentiometer 1")
            .setRange(0, 100)
            .setValue(voltage2)
            .setPosition(150, height/2 - 50)  
            .setRadius(150)
            .setDragDirection(Knob.VERTICAL)
            .setColorForeground(color(0, 255, 0)) 
            .setColorBackground(color(50))      
            .setColorActive(color(255, 0, 0));   

//*******************meter2 *********************
meter2 = cp5.addKnob("Potentiometer 2")
            .setRange(0, 100)
            .setValue(voltage1)
            .setPosition(400, height/2 - 50) 
            .setRadius(150)
            .setDragDirection(Knob.VERTICAL)
            .setColorForeground(color(0, 0, 255)) 
            .setColorBackground(color(50))      
            .setColorActive(color(255, 255, 0)); 
            
 //****************meter 3*****************************

meter3 = cp5.addKnob("Potentiometer 3")
            .setRange(0, 100)
            .setValue(voltage3)
            .setPosition(650, height/2 - 50)  
            .setRadius(150)
            .setDragDirection(Knob.VERTICAL)
            .setColorForeground(color(255, 0, 255))
            .setColorBackground(color(50))          
            .setColorActive(color(0, 255, 255));   
            
            
            //************cation of meters*******************
meter1.getCaptionLabel()
      .setFont(font)
      .setColor(color(0,0,0))       
      .setText("Laptop Heat %");  
meter2.getCaptionLabel()
      .setFont(font)                       
      .setColor(color(0, 0,0))       
      .setText("Room temperature%");  
meter3.getCaptionLabel()
      .setFont(font)                        
      .setColor(color(0, 0,0))
      .setText("Room light %");  
          
}
void draw() {
  background(255);

  //******************************* Update knob values for meters**************************
  meter1.setValue((voltage2/5)*100);
  meter2.setValue((voltage1/5)*100);
  meter3.setValue((voltage3/5)*100);
  
  
  
  
  
  //*********************************title*********************************
  textFont(createFont("Arial", 68)); 
  fill(100); 
  text("Smart Study Table", width / 2 - 150, 50);

  textFont(createFont("Arial", 32));

 //**********************show three values**********************************
  fill(0, 0, 255); //   blue
  text("Room Temperature = " +nf((5*voltage1+10),1,2) + " C - "+nf(convertFran((5*voltage1+10)),1,2)+" F", width/3, 120);

//*************************************************
  fill(0, 100, 0); // Dark green 
  text("Laptop Heat = " + nf((2*voltage2+25),1,2)+ " C - "+ nf(convertFran((2*voltage2+25)),1,2)+" F",width/3, 160);

//******************************************************
  fill(128, 0, 128); // Purple color
  text("Room Light = " + nf((voltage3/5)*100, 1,2) + "%", width/3, 200);
  

  // ******************************************Change text color based on conditions********************************************
  if (voltage2 > 1.5) {
     fill(3, 148, 252); 
     text("Laptop Fan on", width*3/4, 120);
  } else {
     fill(255, 0, 0); 
     text("Laptop Fan off", width*3/4, 120);
  }
  
  if (voltage1 > 3.6) {
     fill(3, 148, 252); 
     text("Table Fan on", width*3/4, 160);
  } else {
     fill(255, 0, 0); 
     text("Table Fan off", width*3/4, 160);
  }
  
  if (voltage3 > 2.5) {
     fill(3,148,252); 
     text("Table Light on", width*3/4, 200);
  } else {
     fill(255, 0, 0); // Red text for "Fan off"
     text("Table Light OFF", width*3/4, 200);
  }
  
  
    // ******************************************* bar graph****************************
  int barWidth = width - 100;
  int barHeight = height / 4;
  int barX = 50;
  int barY = height/2 - barHeight / 2;
  
  int barWidth2 = width - 100;
  int barHeight2 = height / 4;
  int barX2 = 50;
  int barY2 = height*3/4 - barHeight / 2;
  
   int barWidth3 = width - 100;
  int barHeight3 = height / 8;
  int barX3 = 50;
  int barY3 = 800- barHeight / 2;

  fill(0, 255, 0); //Green
  rect(barX, barY, map(voltage2, 0, 5, 0, barWidth), barHeight); // Draw the bar
  
  fill(3, 148, 252);// LIght blue
  rect(barX2, barY2, map(voltage1, 0, 5, 0, barWidth2), barHeight2); // Draw the bar
  
  fill(230,230,250);// Lavender
  rect(barX3, barY3, map(voltage3, 0, 5, 0, barWidth3), barHeight3); // Draw the bar


    //********************************************** Read serial data from Arduino****************************
  if (myPort.available() > 0) {
    String inString = myPort.readStringUntil('\n');
    if (inString != null) {
      inString = trim(inString);
      String[] values = split(inString, ',');
      if (values.length >= 1) {
        voltage1 = float(values[0]);
      }
    }
  }
    // *********************************************show button********************
  if (voltage2 > 4) {
    showResetButton = true;
  }
  
 
  if (showResetButton) {
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      fill(200, 0, 0);  
    } else {
      fill(255, 0, 0);  
    }
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Reset Buzzer", buttonX + buttonWidth / 2, buttonY + buttonHeight / 2);
  }
  
  
  //************************************refresh button ****************************************
  if (mouseX > refreshButtonX && mouseX < refreshButtonX + refreshButtonWidth && mouseY > refreshButtonY && mouseY < refreshButtonY + refreshButtonHeight) {
    fill(0, 150, 0);  // Hovered button color (darker green)
  } else {
    fill(0, 255, 0);  // Normal button color (green)
  }
  rect(refreshButtonX, refreshButtonY, refreshButtonWidth, refreshButtonHeight);
  fill(255);
  textAlign(CENTER, CENTER);
  text("Refresh", refreshButtonX + refreshButtonWidth / 2, refreshButtonY + refreshButtonHeight / 2);
}


// ************************************************Read data from Arduino************************************************************
void serialEvent(Serial myPort) {
  String input = myPort.readStringUntil('\n'); 
  if (input != null) {
    input = trim(input); 
    
    String[] values = split(input, ','); 
    if (values.length == 3) {
      voltage1 = float(values[0]);
      voltage2 = float(values[1]);
      voltage3 = float(values[2]);
    }
  }
}
//*********************************button clicked function********************************************************
void mousePressed() {
 
  if (showResetButton && mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
    myPort.write('R');  
    showResetButton = false;  
  }
    if (mouseX > refreshButtonX && mouseX < refreshButtonX + refreshButtonWidth && mouseY > refreshButtonY && mouseY < refreshButtonY + refreshButtonHeight) {
    myPort.write('F');  
    showResetButton = false;  
    voltage1 = 0; 
  }

}
//********************************************convert to faran *********************************************************
float convertFran(float vol){
      float faran= vol;
      faran=faran*9;
      faran=(faran/5)+32;
      
      return faran;

}
