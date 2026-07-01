class FlowFieldCelluarAutomata{
  int resolution;  
  float [][]PerlinNoise;

  int timer=0;
  int oldTimer=200;
  int rows, cols;
  int [][]field;
  int [][]fieldCopy;
  float [][]fieldVoronoi;
  PVector []positions;
  int num;
  int minNumOfNeigbours, maxNumOfNeigbours;
  int riverStart, riverEnd;
    FlowFieldCelluarAutomata(int r, int start, int end, float [][] nosie) {
    this.resolution = r;
    this.cols = width / this.resolution;
    this.rows = height / this.resolution;
        this.PerlinNoise=new float[cols][rows];
    arrayCopy(nosie,PerlinNoise);
    this.field = new int[cols][rows];
    this.fieldCopy = new int[cols][rows];
    this.fieldVoronoi = new float[cols ][rows ];
    this.positions=new PVector [cols*rows];
  
    }
    void init(int num){
      this.num=num;
       for(int i=0; i<=num;i++){
         int x=int(random(0,cols));
         int  y=int(random(0,this.rows));
         this.field[x][y]=1;
       }
       arrayCopy(this.field,this.fieldCopy);
    }
  void update(){
             int number=0;
            int count =0;
            for (int i = 0; i < this.positions.length; i++) {
            this.positions[i] = new PVector(1000, 1000);
            }
           for (int x = 0; x < cols; x++) {
              for (int y = 0; y < rows; y++) {
                 count = 0;
                 if (field[x][y]==1){
                    this.positions[number].x=x;
                    this.positions[number].y=y;
                    field[x][y]=0;  
                }
              else{
                  this.positions[number].x=100000;
                  this.positions[number].y=100000;
    }
    number++;} }
    for(int i=0; i<=num;i++){
         int x=int(random(0,this.cols));
         int  y=int(random(0,this.rows));
         this.field[x][y]=1;
       }
       arrayCopy(this.field,this.fieldCopy);
              arrayCopy( this.field,this.fieldCopy);
              this.fieldVoronoi = new float[cols ][rows ];
      
      for(int x=0; x<cols ;x++){
            for (int y = 0; y < rows ; y++) {
                float min=10000;
                for (int l=0;l<cols*rows;l++){
                  float ac =pow(pow(abs(positions[l].x-x),2)+pow(abs(positions[l].y-y),2),0.5);
                 ac+=1.0;
                  if (ac<min){
                    this.fieldVoronoi[x][y]=this.PerlinNoise[int(x)][int(y)]*2/ac; //<>// //<>//
                    min=ac; //<>//
                  }
                }
            }
      }  
  }
    int lookup(PVector position) {
    int column = constrain(floor(position.x / this.resolution), 0, this.cols - 1);
    int row = constrain(floor(position.y / this.resolution), 0, this.rows - 1);
   return this.fieldCopy[column][row];
  }
  void show(int riverStart,int riverEnd) {
      if(this.timer>0){
    this.timer--;
    }  else{
    this.update();
    this.timer=this.oldTimer;  
}
    for (int i = 0; i < this.cols ; i++) {
      for (int j = 0; j < this.rows ; j++) {
        float w = width / (this.cols );
        float h = height /( this.rows );
        int v = this.field[int(i)][int(j)];
        float x = i * w;
        int g;
        float  y = j * h;
        //if (v==1){
         g= int(map(this.fieldVoronoi[i][j],0,3,100,255));
        strokeWeight(0);
               int  r= int(map(1-this.fieldVoronoi[i][j],0,4,100,255));

         fill(r, g,50);
        square(x,y,w);

      }
    }

  }
}
