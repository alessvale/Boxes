
class Box {
  float rad;
  float omega_x, omega_y;
  color c;
  PVector pos;
  PVector vel;
  boolean locked = true;

  Box(float _omega_x, float _omega_y, color _c) {
    rad = 0;
    pos = new PVector(width * 0.5, height * 0.5, 0);
    vel = new PVector(0, 0, 0);
    omega_x = _omega_x;
    omega_y = _omega_y;
    c = _c;
  }

  void applyAcc(float ax, float ay) {
    omega_x -= ax * 0.01;
    omega_y -= ay * 0.01;
  }
  void update() {
    if (rad < 190) {
      rad += 4;
    }
    if (!locked) {
      vel.y += 0.8;
      rad *= 0.999;
    }
    pos.add(vel);
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(omega_x);
    rotateY(omega_y);
    noStroke();
    fill(c, 60);
    box(rad * displayDensity);
    popMatrix();
  }

  void explode() {
    locked = false;
    vel.x = random(-10, 10);
    vel.y = random(-10, 0);
  }

  boolean isDead() {
    if (pos.mag() > 5400) {
      return true;
    } else {
      return false;
    }
  }
}