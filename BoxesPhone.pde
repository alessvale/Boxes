//Boxes: a digital spinning toy for Android;
//Alessandro Valentino

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;

Context context;
SensorManager manager;
Sensor sensor;
AccelerometerListener listener;


ArrayList<Box> boxes;


int N = 10;
float t = 0; 
float ax, ay;
float r;
boolean exploding = false; 

void setup() {
  fullScreen(P3D);
  orientation(LANDSCAPE);

  //Setting up the sensor manager
  context = getActivity();
  manager = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);
  sensor = manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  listener = new AccelerometerListener();
  manager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_GAME);


  init();

}

void draw() {
  background(255);
  for (int i = 0; i < boxes.size(); i++) {
    Box b = boxes.get(i);

    if (b.rad > 190 ) {
      b.applyAcc(ax, ay);
    }
  }

  lights();
  drawBoxes();

if(exploding){
  for (int i = boxes.size() - 1; i>=0; i--) {
    Box b = boxes.get(i);
    if (b.isDead()) {
      boxes.remove(i);
    }
  }
}

  if (boxes.size() == 0) {
    init();
  }
}

void init() {
  ax = 0;
  ay = 0;
  boxes = new ArrayList<Box>();

  for (int i = 0; i < N; i++) {
    float omega_x = random(0, 2 * PI);
    float omega_y = random(0, 2 * PI);
    color col = color(random(0, 255), random(0, 255), random(0, 255));
    boxes.add(new Box(omega_x, omega_y, col));
  }
  exploding = false;
}

void drawBoxes() {
  for (int i = 0; i < boxes.size(); i++) {
    Box b = boxes.get(i);
    b.update();
    b.show();
  }
}

void mouseReleased() {
  for (Box b : boxes) {
    if (b.locked) {
      b.explode();
    }
  }
  exploding = true;
}

class AccelerometerListener implements SensorEventListener {
  public void onSensorChanged(SensorEvent event) {
    ax = event.values[0];
    ay = event.values[1];
  }
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
  }
}

public void onResume() {
  super.onResume();
  if (manager != null) {
    manager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_GAME);
  }
}

public void onPause() {
  super.onPause();
  if (manager != null) {
    manager.unregisterListener(listener);
  }
}