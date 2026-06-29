class Prey {
  PVector position, velocity, acceleration,angle, angleVelocity, amplitude;
  float mass, r,maxspeed, maxforce,maxSpeedRiver,maxSpeedNorm,maxforceN,maxforceR;
  int i;
    int maxLifetime=2000;
  int lifeTime=0;
    //int maxTail = 10; 
    //ArrayList<PVector> preyTail = new ArrayList<PVector>();
  Prey(float x, float y, float m) {
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.mass = m;
    this.i=-1;
    this.maxspeed=0.4;
     this.maxforce= 0.014;
    this.r = sqrt(this.mass) * 2.5;
    this.angle = new PVector();
      this.angleVelocity = new PVector(random(-0.03, 0.03), random(-0.03, 0.03));
    this.amplitude = new PVector(
     random(0.1,mass*0.2),random(0.15,mass*0.3)  );
    this.maxSpeedNorm=this.maxspeed;
    this.maxforceN=this.maxforce;
    this.maxforceR=this.maxforce*4;
    this.maxSpeedRiver=  this.maxSpeedNorm*2;
    
}
  
  void attract(Body body) {
    PVector force = PVector.sub(this.position, body.position);
    float d = constrain(force.mag(), 5, 25);
    float G = 0.70;
    float strength = (G * (this.mass * body.mass)) / (d * d);
    force.setMag(strength);
    body.applyForce(force);
    //this.i=-1;  
}

  void applyForce(PVector force) {
    PVector f = PVector.div(force, this.mass);
       f.limit(maxspeed);
    this.acceleration.limit(maxspeed);

    this.acceleration.add(f);
    this.acceleration.limit(maxspeed);
     //
  
}
  
  void findRandomFood(Food[] foods){
   float minDist=70;
   int currentLowest=0;

    currentLowest=int(random(0,10));
   this.trace(foods[currentLowest].position,currentLowest);
 }
void trace(PVector target, int currentLowest){
    PVector desired = PVector.sub(target, this.position); // A vector pointing from the location to the target
    float d = desired.mag();
    if (d < 140) {
      float m = map(d, 0.2, 140, 0.2, this.maxspeed);
      desired.setMag(m);
      if(d<5){
        this.i=currentLowest;
      }
    } else {
      desired.setMag(this.maxspeed);
    }
    
  PVector steer = PVector.sub(desired, this.velocity);
   steer.limit(this.maxforce);
   this.applyForce(steer);
  //this.acceleration.add(steer);
  //this.acceleration.limit(maxspeed);
  }
   void flow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(this.position);
    // Scale it up by maxspeed
    //desired.add(this.velocity);
    desired.mult(this.maxspeed*0.5);
    if (this.position.x>=flow.riverStart&&this.position.x<=flow.riverEnd){
      //desired.mult(this.maxspeed*2.5);
      this.maxspeed=maxSpeedRiver*2;
      this.maxforce=maxforceR;
      
    }else{
      this.maxspeed=maxSpeedNorm;
      this.maxforce=maxforceN;
    
    }
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, this.velocity);
    steer.limit(this.maxforce); // Limit to maximum steering force
    this.applyForce(steer);
  }

  void update(FlowField flow,FlowFieldCelluarAutomata automata) {
    if(automata.lookup(this.position)==1){
      this.maxspeed=this.maxSpeedNorm*10;
    }else if(automata.lookup(this.position)==0) {
      this.maxspeed=this.maxSpeedNorm;
    }else{
      this.maxspeed=maxSpeedRiver*0.1;
    
    }
    flow(flow);  
    this.angle.add(this.angleVelocity);
     //lifeTime--;
    float x = sin(this.angle.x) * this.amplitude.x;
    float y = sin(this.angle.y) * this.amplitude.y;
    PVector oscilation;
    oscilation = new PVector (x,y);
    this.velocity.add(this.acceleration);
        this.position.add(oscilation);
    this.position.add(this.velocity);
    this.acceleration.set(0, 0);
    lifeTime++;
    float slowness= (lifeTime/100)+1;
    this.maxSpeedNorm=this.maxSpeedNorm/slowness;
    //preyTail.add(0, position.copy());
     //if (preyTail.size() > maxTail) {
    //preyTail.remove(preyTail.size() - 1); // usuń najstarszy
    boundaries(3,flow);
  //}
    
  }
   void boundaries(int offset,FlowField flow) {
   PVector desired = null;
       if (this.position.x > flow.riverStart-offset) {
      desired = new PVector(this.maxspeed*2, this.velocity.y*2);
    } else if (this.position.x <  flow.riverEnd+offset) {
      desired = new PVector(-this.maxspeed/2, this.velocity.y*2);
    }

//    if (this.position.y < offset) {
//      desired = new PVector(this.velocity.x/2, this.maxspeed/2);
//    } else if (this.position.y > height - offset) {
//      desired = new PVector(this.velocity.x/2, -this.maxspeed/2);
//    }

    if (desired != null) {
      desired.normalize();
      desired.mult(this.maxspeed);
      PVector steer = PVector.sub(desired, this.velocity);
      steer.limit(this.maxforce);
      this.applyForce(steer);
    }
   }
  //void bounce(){
  //      this.velocity.add(this.acceleration);
  //      if (position.x < 0) {
  //  position.x = 0;
  //  velocity.x *= -0.5;
  //} else if (position.x > width) {
  //  position.x = width;
  //  velocity.x *= -0.5;
  //}

  //// Odbicie od góry/dołu
  //if (position.y < 0) {
  //  position.y = 0;
  //  velocity.y *= -0.5;
  //} else if (position.y > height) {
  //  position.y = height;
  //  velocity.y *= -0.5;
  //}
        //float pos_y=vecx.cross(0,1);
    //this.velocity.rotate(PI*3);    


    //this.position.add(this.velocity);
    
    //this.acceleration.set(0, 0);
  
  //}
  void show() {
    stroke(0);
    strokeWeight(2);
    fill(127, 100);
  
    
    circle(this.position.x, this.position.y, this.r * 4);
      
}}
