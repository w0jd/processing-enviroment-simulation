class FlowFieldCelluarAutomata{
  int resolution;  
  float [][]PerlinNoise;

  int timer=200;
  int oldTimer=this.timer;
  int rows, cols;
  int [][]field;
  int [][]fieldCopy;
  int [][]fieldCopy2;
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
    this.riverStart = start;
    this.riverEnd=end;
    this.field = new int[cols][rows];
    this.fieldCopy = new int[cols][rows];
    this.fieldCopy2 = new int[cols][rows];
  
    }
    void init(int num){
       for(int i=0; i<=num;i++){
         int x=int(random(0,cols));
         while(x<=this.riverEnd && x>=this.riverStart){
           //print(x);
             x=int(random(0,this.cols));
         }
         int  y=int(random(0,this.rows));
         this.field[x][y]=1;
       }
       arrayCopy(this.field,this.fieldCopy);
    }
    void update(){
     this.minNumOfNeigbours=int(random(3,4));
     this.maxNumOfNeigbours=int(random(5,7));
  //      print("\n");

  //   print(minNumOfNeigbours);
  //      print("\n");
  //print(maxNumOfNeigbours);
  //      print("\n");
     
          int count =0;
 for (int x = 0; x < cols; x++) {
  for (int y = 0; y < rows; y++) {
     count = 0;
    
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;
        
        int col = (x + i + cols) % cols;
        int row = (y + j + rows) % rows;
        
        if (fieldCopy[col][row] == 1) {
          count++;
        }
      }
    }
             //print(this.field[x][y]);
                if((count>=this.minNumOfNeigbours && count<=this.maxNumOfNeigbours) && (x<this.riverStart || x>this.riverEnd) ){
                 this.field[x][y]=1;
             }else{
                 this.field[x][y]=0;

             }
             if((x>=this.riverStart && x<this.riverEnd)){
               //print("\n");
               //print(riverStart);
               //print("\n");
               //print(x);
               //print("\n");
                this.field[x][y]=2;

           }
      }
          //print("\n");
    }
              //print("\n");
              arrayCopy( this.field,this.fieldCopy);
              //this.fieldCopy2=this.fieldCopy;

    }
    int lookup(PVector position) {
    int column = constrain(floor(position.x / this.resolution), 0, this.cols - 1);
    int row = constrain(floor(position.y / this.resolution), 0, this.rows - 1);
    //print(this.fieldCopy[column][row]);
   return this.fieldCopy[column][row];
    //return this.field[column][row];
  }
    void show(int riverStart,int riverEnd) {
    this.riverStart=riverStart;
    this.riverEnd=riverEnd;
      if(this.timer>0){
    this.timer--;
    //print(timer);
    //print("\n");
    }  else{
    this.update();
    this.timer=this.oldTimer;  
}
    //print("1");
    for (int i = 0; i < this.cols; i++) {
      for (int j = 0; j < this.rows; j++) {
        float w = width / this.cols;
        float h = height / this.rows;
        int v = this.field[i][j];
        float x = i * w;
        int r,g,b;
        float  y = j * h;
        if (v==1){
         g= int(map(this.PerlinNoise[i][j],0,1,90,255));
        //v.setMag(w * 0.5);
        strokeWeight(0);
         fill(50, g,50);
        square(x,y,w);
        }else if(v==0){
        strokeWeight(0);
                 g= int(map(this.PerlinNoise[i][j],0,1,150,255));

         fill(g,g,0);
        square(x,y,w);
        }else{
        strokeWeight(0);
                 b= int(map(this.PerlinNoise[i][j],0,1,130,255));

         fill(25,55,b);
        square(x,y,w);
        
        }
        //line(x, y, x + v.x, y + v.y);
      }
    }
  }
}
