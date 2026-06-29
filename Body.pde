class Body {
  PVector position, velocity, acceleration,angle, angleVelocity, amplitude,spearateForce,sum;
  float mass, r, maxspeed, maxforce,maxspeedF,maxSpeedN;
  //Body[] huntersParticles = new Body[10];
  int maxLifetime=20000;
  int lifeTime=maxLifetime;
  
  Body(float x, float y, float m) {
           //this.sum = new PVector();

    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.mass=m;
        this.angle = new PVector();
      this.angleVelocity = new PVector(random(-0.03, 0.03), random(-0.03, 0.03));
    this.amplitude = new PVector(
     random(0.1,mass*0.08),random(0.15,mass*0.09));
      //random(20, height / 2)
    this.maxspeed=0.8;
     this.maxforce= 0.007;
    this.maxSpeedN=this.maxspeed;
    this.maxspeedF=this.maxspeed*0.4;
    
    //println( this.angleVelocity);
    this.r = sqrt(this.mass) * 3;
  }
    void bounce(){
        this.velocity.add(this.acceleration);
        //PVector x,y;
        //PVector vecx= new PVector(1,0);
        //PVector vecy= new PVector(0,1);
        ////float pos_x=vecx.cross(1,0);
        //print("dupa");

        if (position.x < 0) {
          position.x = 0;
          velocity.x *= -0.5;
        } else if (position.x > width) {
           position.x = width;
            velocity.x *= -0.5;
        }

  // Odbicie od góry/dołu
         if (position.y < 0) {
            position.y = 0;
            velocity.y *= -0.5;
          } else if (position.y > height) {
              position.y = height;
            velocity.y *= -0.5;
          }
        //float pos_y=vecx.cross(0,1);
    //this.velocity.rotate(PI*3);    


    this.position.add(this.velocity);
    
    this.acceleration.set(0, 0);
  
  }
  void attract(Prey body) {
  
    PVector force = PVector.sub(this.position, body.position);
    float d = constrain(force.mag(), 5, 25);
    float G = 0.09;
    float strength = -(G * (this.mass * body.mass)) / (d * d);
    force.setMag(strength);
    body.applyForce(force);
  }
 void findNearestPrey(Prey[] preys){
   float minDist=100;
   int currentLowest=0;
   //print(preys.length);
   for(int i=0;i<preys.length;i++){
       float dst=PVector.dist(preys[i].position,this.position);
       if(dst < minDist){
           currentLowest =i;
       }
       
   }
   this.trace(preys[currentLowest].position);
   
 }
  void applyForce(PVector force) {
    PVector f = PVector.div(force, this.mass);
    this.acceleration.limit(maxspeed);

    //f.limit(maxforce);
    this.acceleration.add(f);
    this.acceleration.limit(maxspeed);
  }

  void trace(PVector target){
    PVector desired = PVector.sub(target, this.position); // A vector pointing from the location to the target
    float d = desired.mag();
    if (d < 100) {
      float m = map(d, 0.2, 100, 0.2, this.maxspeed);
      desired.setMag(m);
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
    //int ground=
    // Scale it up by maxspeed
    //desired.add(this.velocity);
    desired.mult(this.maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, this.velocity);
    steer.limit(this.maxforce); // Limit to maximum steering force
    this.applyForce(steer);
  }
  void update(FlowField flow,FlowFieldCelluarAutomata automata) {
         this.angle.add(this.angleVelocity);
    
    float x = sin(this.angle.x) * this.amplitude.x;
    float y = sin(this.angle.y) * this.amplitude.y;
    PVector oscilation;
    if(automata.lookup(this.position)==1){
      this.maxspeed=this.maxspeedF;
    }else if(automata.lookup(this.position)==0) {
      this.maxspeed=this.maxSpeedN;
    }else{
      this.maxspeed=this.maxspeedF*10;
    
    }
    oscilation = new PVector (x,y);
    boundaries(20);
    flow(flow);
    //lifeTime--;
    this.velocity.add(this.acceleration);
    this.velocity.limit(this.maxspeed);
    this.position.add(this.velocity);
    //this.position.add(oscilation);
    this.acceleration.set(0, 0);
  }
   void boundaries(int offset) {
   PVector desired = null;
       if (this.position.x < offset) {
      desired = new PVector(this.maxspeed, this.velocity.y);
    } else if (this.position.x > width - offset) {
      desired = new PVector(-this.maxspeed, this.velocity.y);
    }

    if (this.position.y < offset) {
      desired = new PVector(this.velocity.x, this.maxspeed);
    } else if (this.position.y > height - offset) {
      desired = new PVector(this.velocity.x, -this.maxspeed);
    }

    if (desired != null) {
      desired.normalize();
      desired.mult(this.maxspeed);
      PVector steer = PVector.sub(desired, this.velocity);
      steer.limit(this.maxforce);
      this.applyForce(steer);
    }
   }
   void separate(Body hunter){
     float desiredSeparation = this.r * 4;
       this.sum = new PVector();
    int count = 0;
     float d = PVector.dist(this.position, hunter.position);
     //print(d);
     if(d < desiredSeparation){
       //print("dupa");
        PVector diff = PVector.sub(this.position, hunter.position);
        diff.setMag(2/d);
        
        this.sum.add(diff);
         this.sum.setMag(this.maxspeed);
          this.sum.sub(this.velocity);
                this.sum.limit(this.maxforce);
      PVector separateForce = this.sum;
          separateForce.mult(15.5);
      this.applyForce(separateForce);
     }
          //print(separateForce);

    
   }
  void show() {

    fill(227, 100,100);
     float angle = this.velocity.heading();
       fill(227, 100,100, lifeTime/200);
    stroke(1);
    strokeWeight(2);
    push();
    translate(this.position.x, this.position.y);
    rotate(angle);
    beginShape();
    vertex(this.r * 2, 0);
    vertex(-this.r * 2, -this.r);
    vertex(-this.r * 2, this.r);
    endShape(CLOSE);
    pop();
  }
}
