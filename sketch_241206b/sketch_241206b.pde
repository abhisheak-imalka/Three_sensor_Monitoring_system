import controlP5.*;
import processing.serial.*;

Serial myPort;         // Serial port object
ControlP5 cp5;         // ControlP5 instance
Knob meter1, meter2, meter3; // Knobs for three meters
ControlFont font; // Knobs for three meters
boolean showResetButton = false;
int buttonX, buttonY, buttonWidth, buttonHeight;



float voltage1, voltage2, voltage3;

void setup() {
  size(1200, 800);      // Size of the window

  // Initialize serial connection
  myPort = new Serial(this, "COM4", 9600);  // Update with your correct COM port
  myPort.bufferUntil('\n'); // Read data until newline character

  // Initialize ControlP5 and the meters
  cp5 = new ControlP5(this);
  PFont pfont = createFont("Arial", 20, true); // Use a Processing PFont 
  font = new ControlFont(pfont, 20); // Set font size
  
  buttonX = width*3 /4;
  buttonY = 250;
  buttonWidth = 200;
  buttonHeight = 40;
  myPort.write('A');
  
meter1 = cp5.addKnob("Potentiometer 1")
            .setRange(0, 5)
            .setValue(voltage1*100/5)
            .setPosition(150, height/2 - 50)  // Changed position
            .setRadius(150)
            .setDragDirection(Knob.VERTICAL)
            .setColorForeground(color(0, 255, 0)) // Green foreground
            .setColorBackground(color(50))       // Dark gray background
            .setColorActive(color(255, 0, 0));   // Red when active

meter2 = cp5.addKnob("Potentiometer 2")
            .setRange(0, 5)
            .setValue(voltage2)
            .setPosition(400, height/2 - 50)  // Changed position
            .setRadius(150)
            .setDragDirection(Knob.VERTICAL)
            .setColorForeground(color(0, 0, 255)) // Blue foreground
            .setColorBackground(color(50))       // Dark gray background
            .setColorActive(color(255, 255, 0)); // Yellow when active

meter3 = cp5.addKnob("Potentiometer 3")
            .setRange(0, 5)
            .setValue(voltage3)
            .setPosition(650, height/2 - 50)  // Changed position
            .setRadius(150)
            .setDragDirection(Knob.VERTICAL)
            .setColorForeground(color(255, 0, 255)) // Magenta foreground
            .setColorBackground(color(50))          // Dark gray background
            .setColorActive(color(0, 255, 255));   // Cyan when active
            
meter1.getCaptionLabel()
      .setFont(font)                        // Apply custom font if needed
      .setColor(color(255, 255, 255))       // Set text color to white
      .setText("Port 1");  
meter2.getCaptionLabel()
      .setFont(font)                        // Apply custom font if needed
      .setColor(color(255, 255, 255))       // Set text color to white
      .setText("Port 2");  
meter3.getCaptionLabel()
      .setFont(font)                        // Apply custom font if needed
      .setColor(color(255, 255, 255))       // Set text color to white
      .setText("Port 3");  
          
}
void draw() {
  background(220);

  // Update knob values dynamically
  meter1.setValue(voltage1);
  meter2.setValue(voltage2);
  meter3.setValue(voltage3);
  
  textFont(createFont("Arial", 48)); 
  fill(0); // Set the color to black for the title
  text("Potentiometer Values", width / 2 - 150, 50); // Title text

  textFont(createFont("Arial", 32));

  // Change text color and draw the labels
  fill(255, 0, 0); // Set the color to red
  text("Pot 1 = " + voltage1 + "%", width/3, 120);

  fill(0, 255, 0); // Set the color to green
  text("Pot 2 = " + voltage2, width/3, 160);

  fill(0, 0, 255); // Set the color to blue
  text("Pot 3 = " + voltage3, width/3, 200);

  // Change text color based on conditions
  if (voltage1 > 2.5) {
     fill(0, 255, 0); // Green text for "Laptop Fan on"
     text("Laptop Fan on", width*3/4, 120);
  } else {
     fill(255, 0, 0); // Red text for "Fan off"
     text("Fan off", width*3/4, 120);
  }
  
  if (voltage2 > 2.5) {
     fill(0, 255, 0); // Green text for "Laptop Fan on"
     text("Laptop Fan on", width*3/4, 160);
  } else {
     fill(255, 0, 0); // Red text for "Fan off"
     text("Fan off", width*3/4, 160);
  }
  
  if (voltage3 > 2.5) {
     fill(0, 255, 0); // Green text for "Laptop Fan on"
     text("Laptop Fan on", width*3/4, 200);
  } else {
     fill(255, 0, 0); // Red text for "Fan off"
     text("Fan off", width*3/4, 200);
  }
    // Draw the bar graph
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

  fill(0, 255, 0); // Set the fill color to green
  rect(barX, barY, map(voltage1, 0, 5, 0, barWidth), barHeight); // Draw the bar
  
  fill(0, 0, 255); // Set the fill color to green
  rect(barX2, barY2, map(voltage2, 0, 5, 0, barWidth2), barHeight2); // Draw the bar
  
  fill(0, 255, 255); // Set the fill color to green
  rect(barX3, barY3, map(voltage3, 0, 5, 0, barWidth3), barHeight3); // Draw the bar

  // Draw the text
  fill(0); // Set the text color to black
  textSize(32);
  textAlign(CENTER, CENTER);
  text("LDR Value: " + voltage1, width / 2, height / 2-100 + barHeight); // Display the LDR value
  
  
    // Read serial data from Arduino
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
  
  // Check if voltage1 is greater than 4 to show the reset button
  if (voltage1 > 4) {
    showResetButton = true;
  }
  
  // Draw the button if visible
  if (showResetButton) {
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      fill(200, 0, 0);  // Hovered button color (darker red)
    } else {
      fill(255, 0, 0);  // Normal button color (red)
    }
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Reset Buzzer", buttonX + buttonWidth / 2, buttonY + buttonHeight / 2);
  }
}


void serialEvent(Serial myPort) {
  String input = myPort.readStringUntil('\n'); // Read data from Arduino
  if (input != null) {
    input = trim(input);  // Remove whitespace
    
    String[] values = split(input, ','); // Expecting comma-separated values
    if (values.length == 3) {
      voltage1 = float(values[0]);
      voltage2 = float(values[1]);
      voltage3 = float(values[2]);
    }
  }
}

void mousePressed() {
  // Check if the button is clicked
  if (showResetButton && mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
    myPort.write('R');  // Send reset signal to Arduino
    showResetButton = false;  // Hide the button after resetting
  }
}
