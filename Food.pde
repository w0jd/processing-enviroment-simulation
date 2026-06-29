class Food {
  PVector position, velocity, acceleration;
  float mass, r,maxspeed, maxforce;;
  
  Food(float x, float y, float m) {
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.mass = m;
    this.r = sqrt(this.mass) * 2;
    
  }
  
  void attract(Prey body) {
    PVector force = PVector.sub(this.position, body.position);
    float d = constrain(force.mag(), 5, 25);
    float G = 0.3;
    float strength = (G * (this.mass * body.mass)) / (d * d);
    force.setMag(strength);
    body.applyForce(force);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, this.mass);
    this.acceleration.add(f);
    this.acceleration.limit(maxspeed);

  }




  void show() {
    stroke(0);
    strokeWeight(2);
    fill(25, 200,25);
    circle(this.position.x, this.position.y, this.r * 4);
  }
}
