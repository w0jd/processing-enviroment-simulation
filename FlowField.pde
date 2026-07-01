
class FlowField {
  int resolution;
  int rows, cols;
  PVector [][]field;
  int riverStart;
  int riverEnd;
  int hillStart, hillEnd, hillHeight, hillHeightEnd;
  float [][]PerlinNoise;
  FlowField(int r) {
    this.resolution = r;
    this.cols = width / this.resolution;
    this.rows = height / this.resolution;
    riverStart= int(random(0,int(cols)-5));
    riverEnd=riverStart+10;
    this.PerlinNoise=new float[cols][rows];

    this.field = new PVector[cols][rows];

    this.init();
  }

  void init() {
    noiseSeed((long)(random(10000)));
    float xoff = 0;
    for (int i = 0; i < this.cols; i++) {
      float yoff = 0;
      for (int j = 0; j < this.rows; j++) {
          this.PerlinNoise[i][j]=noise(xoff, yoff);
        float angle = map(this.PerlinNoise[i][j], 0, 1, 0, TWO_PI);
        if(i>=riverStart && i<=riverEnd)
        {
          angle=map(PerlinNoise[i][j], 0, 1, 0, PI);
          
        }
        this.field[i][j] = PVector.fromAngle(angle);

        
        yoff += 0.1;
      }
      xoff += 0.1;
    }
  }



}
