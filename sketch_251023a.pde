Body[] hunters = new Body[10];
Prey[] preys = new Prey[10];
//Food[] foods = new Food[10];
FlowField flowfield;
FlowFieldCelluarAutomata cellAutoF;
float G = 1;
void setup() {
  size(1240, 660);
  flowfield = new FlowField(20);
  cellAutoF = new FlowFieldCelluarAutomata(20,flowfield.riverStart,flowfield.riverEnd,flowfield.PerlinNoise);
  cellAutoF.init(300);
  for (int i = 0; i < 10; i++) {
    hunters[i] = new Body(random(width), random(height), random(2, 3));
      preys[i] = new Prey(random(width), random(height), random(1.5, 2.5));
        //foods[i] = new Food(random(width), random(height), random(1.1, 2.0));
      }
}
void draw() {
  background(255);
  cellAutoF.show(flowfield.riverStart,flowfield.riverEnd);
  flowfield.show();
  for (int i = 0; i <10; i++) {
    for (int j = 0; j < 10; j++) {
    hunters[i].findNearestPrey(preys);
    hunters[i].attract(preys[i]);
        preys[i].attract(hunters[i]);
        //foods[i].attract(preys[i]);
         //PVector desired = PVector.sub(foods[i].position, preys[j].position);
         //float d = desired.mag();
    //if(d<10)
    //{
      
      //foods[i]=null;
      //foods[i]= new Food(random(width), random(height), random(1.1, 2.0));
      //preys[j].lifeTime=preys[j].maxLifetime;  
  //}
    PVector desiredPrey = PVector.sub(hunters[j].position, preys[i].position);
    float dP = desiredPrey.mag();
    if(dP<10)
    {
      preys[i]=null;
            preys[i] = new Prey(random(width), random(height), random(1.5, 2.5));
            //hunters[j].lifeTime=hunters[j].maxLifetime;

    }
    if(hunters[j].lifeTime==0){
      //print("zero");
      //hunters[j]=null;
      //   hunters[j] = new Body(random(width), random(height), random(2, 3));
    }
        if(preys[j].lifeTime==0){
      //preys[j]=null;
      //   preys[j] = new Prey(random(width), random(height), random(2, 3));
    }
    if(j!=i){
      hunters[i].separate(hunters[j]);
    }
    hunters[i].update(flowfield,cellAutoF);
    hunters[i].show();
    preys[i].update(flowfield,cellAutoF);
    preys[i].show();
    //foods[i].show();
      if (preys[i].position.x<0){
        preys[i]=null;
        preys[i] = new Prey(random(width), random(height), random(1.5, 2.5));
  }
   if (preys[i].position.x>width+10){
    preys[i]=null;
        preys[i] = new Prey(random(width), random(height), random(1.5, 2.5));
  }
  if (preys[i].position.y<0){
   preys[i]=null;
        preys[i] = new Prey(random(width), random(height), random(1.5, 2.5));
  }
   if (preys[i].position.y>height+10){
       preys[i]=null;
        preys[i] = new Prey(random(width), random(height), random(1.5, 2.5));
    }
      if((hunters[i].position.y >height+10) || (hunters[i].position.y <-10) ||(hunters[i].position.x>width+10)||(hunters[i].position.x<-10)){
      hunters[i].bounce();
  }
  }
}
}  
