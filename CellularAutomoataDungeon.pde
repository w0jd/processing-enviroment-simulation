class celluarAutomataDungeon {
  int resolution;  
  float[][] PerlinNoise;
  
  int timer = 0;
  int oldTimer = 200;
  int rows, cols;
  int[][] field;
  int[][] fieldCopy;
  PVector[] positions;
  int num;
  int minNumOfNeighbors;
  int minNumOfNeigboursToSurvive;
  celluarAutomataDungeon(int r) {
    this.resolution = r;
    this.cols = width / this.resolution;
    this.rows = height / this.resolution;
    
    // Klasyczna reguła automatów komórkowych dla lochów: 5 sąsiadów tworzy ścianę
    this.minNumOfNeighbors = 5; 
    this.minNumOfNeigboursToSurvive=4;

    this.PerlinNoise = new float[cols][rows];
    this.field = new int[cols][rows];
    this.fieldCopy = new int[cols][rows];
    this.positions = new PVector[cols * rows];
  }

  void init(int num) {
    this.num = num;
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        // Tworzymy twardą ramę (ściany) na brzegach mapy
        if (x == 0 || x == cols - 1 || y == 0 || y == rows - 1) {
          field[x][y] = 1;
        } else if (int(random(0, 100)) < num) {
          field[x][y] = 1; // Ściana
        } else {
          field[x][y] = 0; // Podłoga
        }
      }
    }
    copyFieldToCopy();
    this.update();
  }

  void update() {
    // 12 iteracji wygładzania jaskiń
    for (int gen = 0; gen < 13; gen++) {
      for (int x = 1; x < cols - 1; x++) {
        for (int y = 1; y < rows - 1; y++) {
          
          int count = 0;
          // Sprawdzanie 8 sąsiadów dookoła
          for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
              if (i == 0 && j == 0) continue;       
              
              // Liczymy jako "ścianę" zarówno typ 1, jak i typ 2
              if (fieldCopy[x + i][y + j] == 1) {
                count++;
              }
            }
          }
                    if (count < this.minNumOfNeigboursToSurvive) {this.field[x][y]=0;}

          // Główna reguła automatu
          if (count >= this.minNumOfNeighbors) {
            this.field[x][y] = 1;
          } else {
            //this.field[x][y] = 0;
          }
          
          // Twój specjalny warunek dla 4. generacji (np. inny rodzaj ściany/wypełnienia)
          if (this.field[x][y] == 1 && gen == 12 && count < 8) {
            this.field[x][y] = 2;
          }
        }
      }
      // Aktualizujemy kopię bezpieczeństwa po KAŻDEJ generacji
      copyFieldToCopy();
    }  
  }  

  // Bezpieczne głębokie kopiowanie tablicy dwuwymiarowej
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
    noStroke(); // Wyłączone obramowania dla lepszego wyglądu i wydajności
    for (int i = 0; i < this.cols; i++) {
      for (int j = 0; j < this.rows; j++) {
        int v = this.field[i][j];
        float x = i * this.resolution;
        float y = j * this.resolution;

        if (v == 1) {
          fill(210, 210, 50); // Kolor ścian podstawowych
          square(x, y, this.resolution);
        } else if (v == 2) {
          fill(210, 210, 100); // Kolor ścian rzadszych (z 4. generacji)
          square(x, y, this.resolution);
        }
        // v == 0 (podłoga) pozostaje narysowana kolorem tła z draw()
      }
    }
  }
}
