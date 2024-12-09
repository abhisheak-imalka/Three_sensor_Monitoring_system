const int pot1Pin = A0;  // Potentiometer 1 wiper connected to A0
const int pot2Pin = A1;  // Potentiometer 2 wiper connected to A1
const int pot3Pin = A2;  // Potentiometer 3 wiper connected to A2
const int buzzerPin = 10;  // Buzzer connected to pin 10

float voltage1, voltage2, voltage3;
bool buzzerReset = false;  // Flag to check reset status
bool allowBuzzer = true;   // Flag to allow buzzer

void setup() {
  Serial.begin(9600);  // Start Serial Monitor
  
  pinMode(13, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(buzzerPin, OUTPUT);
}

void loop() {
  // Read potentiometer values
  int pot1Value = analogRead(pot1Pin);
  int pot2Value = analogRead(pot2Pin);
  int pot3Value = analogRead(pot3Pin);
  
  // Convert readings to voltage
  voltage1 = pot1Value * (5.0 / 1023.0);
  voltage2 = pot2Value * (5.0 / 1023.0);
  voltage3 = pot3Value * (5.0 / 700);
  
  // Check if reset is enabled
  if (!buzzerReset && allowBuzzer) {
    // Check if voltage1 is greater than 4V and control the buzzer
    if (voltage2 > 4) {
      digitalWrite(buzzerPin, HIGH);
    } else {
      digitalWrite(buzzerPin, LOW);
    }
  } else {
    digitalWrite(buzzerPin, LOW);  // Ensure the buzzer is off
  }
  
  // Control LEDs based on voltage thresholds
  digitalWrite(13, voltage2 > 1.5 ? HIGH : LOW);
  digitalWrite(12, voltage1 > 3.6 ? HIGH : LOW);
  digitalWrite(11, voltage3 > 2.5 ? HIGH : LOW);

  // Check for commands from Processing
  if (Serial.available() > 0) {
    char command = Serial.read();
    if (command == 'R') {
      buzzerReset = true;  // Set the reset flag
      allowBuzzer = false; // Disable buzzer
    } else if (command == 'A') {
      allowBuzzer = true;  // Enable buzzer
    } else if (command == 'F') {
      buzzerReset = false;  // Clear the reset flag
      allowBuzzer = true;   // Enable buzzer
    }
  }

  // Send the voltage values as a comma-separated string
  Serial.print(voltage1);
  Serial.print(",");
  Serial.print(voltage2);
  Serial.print(",");
  Serial.println(voltage3);  // Use println to send new line
  
  delay(200);  // Short delay
}
