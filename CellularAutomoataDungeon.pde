class celluarAutomataDungeon { //<>//
  int resolution;  
  float[][] PerlinNoise;
  
  int timer = 0;
  int oldTimer = 200;
  int rows, cols;
  int[][] field;
  int[][] fieldCopy;
  int emptyCellsLen;
  // ZMIANA: Używamy ArrayList zamiast sztywnej tablicy []
  ArrayList<PVector> emptyCells; 
  
  int num;
  int minNumOfNeighbors;
  int minNumOfNeigboursToSurvive;

  celluarAutomataDungeon(int r) {
    this.resolution = r;
    this.cols = width / this.resolution;
    this.rows = height / this.resolution;
        this.emptyCellsLen= 0;
    
    this.minNumOfNeighbors = 5; 
    this.minNumOfNeigboursToSurvive = 4;

    this.PerlinNoise = new float[cols][rows];
    this.field = new int[cols][rows];
    this.fieldCopy = new int[cols][rows];
    
    this.emptyCells = new ArrayList<PVector>(); 
  }

  void init(int num) {
    this.num = num;
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        if (x == 0 || x == cols - 1 || y == 0 || y == rows - 1) {
          field[x][y] = 1;
        } else if (int(random(0, 100)) < num) {
          field[x][y] = 1; 
        } else {
          field[x][y] = 0; 
        }
      }
    }
    copyFieldToCopy();
    this.update();
  }

  void update() {
    emptyCells.clear(); 

    for (int gen = 0; gen < 13; gen++) {
      int number=0;
      for (int x = 1; x < cols - 1; x++) {
        for (int y = 1; y < rows - 1; y++) {
          
          int count = 0;
          for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
              if (i == 0 && j == 0) continue;       
              
              if (fieldCopy[x + i][y + j] >= 1) {
                count++;
              }
            }
          }

          if (count < this.minNumOfNeigboursToSurvive) {
            this.field[x][y] = 0;
          }

          if (count >= this.minNumOfNeighbors) {
            this.field[x][y] = 1;
          }
          
          if (gen == 12) {
            if (this.field[x][y] == 1 && count < 8) {
              this.field[x][y] = 2; // Zmiana typu ściany na brzegową
            }
            
            if (this.field[x][y] == 0) {
              // Dodajemy wektor współrzędnych siatki (x, y)
              number++;
              this.emptyCellsLen=number;
              emptyCells.add(new PVector(x, y)); 
            }
          }

        }
      }
      copyFieldToCopy();
    }  
  }  

  void copyFieldToCopy() {
    for (int i = 0; i < cols; i++) {
      arrayCopy(this.field[i], this.fieldCopy[i]);
    }
  }

  int lookup(PVector position) {
    int column = constrain(floor(position.x / this.resolution), 0, this.cols - 1);
    int row = constrain(floor(position.y / this.resolution), 0, this.rows - 1);
    return this.fieldCopy[column][row];
  }

  void show() {
    noStroke(); 
    for (int i = 0; i < this.cols; i++) {
      for (int j = 0; j < this.rows; j++) {
        int v = this.field[i][j];
        float x = i * this.resolution;
        float y = j * this.resolution;
         int colour=int(map(noise(i*0.01,j*0.01,v),0,1,0,255)); 
        if (v == 1) {
          fill(colour, colour, 50); 
          square(x, y, this.resolution);
        } else if (v == 2) {
          fill(colour, colour, 100); 
          square(x, y, this.resolution);
        }
      }
    }
  }
}
