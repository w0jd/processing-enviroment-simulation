FlowField flowfield;
FlowFieldCelluarAutomata cellAutoF;
int resolution = 20;
celluarAutomataDungeon dungeon;
float G = 1;

ArrayList<PVector> snake;  
PVector direction;         
PVector food;              
int moveTimer = 0;
int moveDelay = 10;        
boolean gameOver = false;

void setup() {
  size(1240, 660);
  dungeon = new celluarAutomataDungeon(20);
  flowfield = new FlowField(20);
  cellAutoF = new FlowFieldCelluarAutomata(20,flowfield.PerlinNoise);
  
  cellAutoF.init(300);
  dungeon.init(45); // Po inicjalizacji lochu mamy już dungeon.emptyCells
  
  initSnakeGame();
}

void draw() {
  background(255);
  
  // Rysowanie środowiska
  cellAutoF.show();
  //flowfield.show();
  dungeon.show();
  
  if (!gameOver) {
    if (frameCount - moveTimer >= moveDelay) {
      updateSnake();
      moveTimer = frameCount;
    }
    
    // Rysowanie jedzenia
    fill(255, 0, 0); 
    rect(food.x * resolution, food.y * resolution, resolution, resolution);
    
    // Rysowanie węża
    for (int i = 0; i < snake.size(); i++) {
      if (i == 0) {
        fill(120, 150, 120); // Głowa 
      } else {
        fill(0, 255, 0); // Reszta ciała
      }
      PVector segment = snake.get(i);
      rect(segment.x * resolution, segment.y * resolution, resolution, resolution);
    }
  } else {
    // Ekran końca gry
    fill(0, 150);
    rect(0, 0, width, height);
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("'R', aby restartować", width/2, height/2);
  }
}


void initSnakeGame() { //<>//
  snake = new ArrayList<PVector>();
  direction = new PVector(1, 0); // Startowy ruch w prawo
  gameOver = false;
  
  // Losowanie bezpiecznej pozycji startowej dla głowy węża z listy pustych kafelków
  if (dungeon.emptyCells.size() > 0) {
    int index = int(random(dungeon.emptyCells.size()));
    PVector startTile = dungeon.emptyCells.get(index);
    snake.add(new PVector(startTile.x, startTile.y));
  } else {
    snake.add(new PVector(5, 5)); 
  }
  
  spawnFood();
}

void updateSnake() {
  // Oblicz nową pozycję głowy na podstawie kierunku
  PVector head = snake.get(0);
  PVector newHead = new PVector(head.x + direction.x, head.y + direction.y);
  
  // Kolizja z krawędziami ekranu 
  float cols = width / resolution;
  float rows = height / resolution;
  if (newHead.x < 0 || newHead.x >= cols || newHead.y < 0 || newHead.y >= rows) {
    gameOver = true;
    return;
  }
  
  PVector pixelPos = new PVector(newHead.x * resolution, newHead.y * resolution);
  if (dungeon.lookup(pixelPos) > 0) {
    gameOver = true; // Uderzenie w ścianę 
    return;
  }
  
  //Kolizja węża z samym sobą
  for (int i = 0; i < snake.size(); i++) {
    if (newHead.x == snake.get(i).x && newHead.y == snake.get(i).y) {
      gameOver = true;
      return;
    }
  }
  
  snake.add(0, newHead);
  
  // Sprawdzenie czy wąż zjadł jedzenie
  if (newHead.x == food.x && newHead.y == food.y) {
    spawnFood(); 
  } else {
    snake.remove(snake.size() - 1); 
  }
}

void spawnFood() {
  // Losujemy jedzenie tylko w miejscach, które automat oznaczył jako puste 
  if (dungeon.emptyCells.size() > 0) {
    int index = int(random(dungeon.emptyCells.size()));
    PVector foodTile = dungeon.emptyCells.get(index);
    food = new PVector(foodTile.x, foodTile.y);
  } else {
    food = new PVector(int(random(width/resolution)), int(random(height/resolution)));
  }
}

void keyPressed() {
  // Sterowanie strzałkami lub klawiszami WSAD
  if ((key == 'w' || keyCode == UP) && direction.y != 1) {
    direction.set(0, -1);
  } else if ((key == 's' || keyCode == DOWN) && direction.y != -1) {
    direction.set(0, 1);
  } else if ((key == 'a' || keyCode == LEFT) && direction.x != 1) {
    direction.set(-1, 0);
  } else if ((key == 'd' || keyCode == RIGHT) && direction.x != -1) {
    direction.set(1, 0);
  }
  
  // Restart gry po przegranej
  if (gameOver && (key == 'r' || key == 'R')) {
    initSnakeGame();
  }
}
