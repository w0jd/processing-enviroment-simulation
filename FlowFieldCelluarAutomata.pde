class FlowFieldCelluarAutomata{
  int resolution;  
  float [][]PerlinNoise;

  int timer=200;
  int oldTimer=this.timer;
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
    //{!2} Determine the number of columns and rows.
    this.cols = width / this.resolution;
    this.rows = height / this.resolution;
        this.PerlinNoise=new float[cols][rows];
    arrayCopy(nosie,PerlinNoise);
    //print(this.PerlinNoise[20][20]);
    //this.riverStart = start;
    //this.riverEnd=end;
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
      
      for(int x=0; x<cols ;x++){
            for (int y = 0; y < rows ; y++) {
                float min=10000;
                for (int l=0;l<cols*rows;l++){
                  float ac =pow(pow(positions[l].x-x,2)+pow(positions[l].y-y,2),0.5);

                  if (ac<min){ //<>// //<>//
                 ac+=1.0;
                    this.fieldVoronoi[x][y]=this.PerlinNoise[int(x)][int(y)]*3/ac;
                 //if (ac==1)this.fieldVoronoi[x][y]=1;
                               //<>//
                    min=ac;
                  }
                }
            }
      }  
  }
    int lookup(PVector position) {
    int column = constrain(floor(position.x / this.resolution), 0, this.cols - 1);
    int row = constrain(floor(position.y / this.resolution), 0, this.rows - 1);
    //print(this.fieldCopy[column][row]);
   return this.fieldCopy[column][row];
    //return this.field[column][row];
  }
  void show(int riverStart,int riverEnd) {
    //this.riverStart=riverStart;
    //this.riverEnd=riverEnd;
      if(this.timer>0){
    this.timer--;
    //print(timer);
    //print("\n");
    }  else{
    this.update();
    this.timer=this.oldTimer;  
}
    //print("1");
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
               int  r= int(map(1-this.fieldVoronoi[i][j],0,3,100,255));

         fill(r, g,50);
        square(x,y,w);
        //}else{
        //strokeWeight(0);
                 //g= int(map(this.fieldVoronoi[i][j],0,3,100,255));
               //int  r= int(map(1-this.fieldVoronoi[i][j],0,3,100,255));

         //fill(r, g,50);

        //square(x,y,w);
      //}
        //}else{
              
        //}
      }
    }
  }
}
