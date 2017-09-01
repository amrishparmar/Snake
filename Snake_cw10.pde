/**
    Snake (Coursework 10)

    An exercise in object-oriented programming

    By Amrish Parmar

**/

// audio library
Maxim maxim;

AudioPlayer beep;
AudioPlayer click;

// stores each block of snake
SnakeBlock[] snake;

// store food item
Food food;

// start screen button objects
Button easy;
Button normal;
Button hard;

// store custom font
PFont font;

// will store the position where the end block will be placed on eating food
int endPlaceX;
int endPlaceY;

int gridBlockSize = 20; // width in pixels of each grid block
int snakeLength; // will store initial length of snake
int state; // -1 is start screen, 0 is gameplay, 1 is game over
int difficulty; // 20 is easy, 10 is normal, 5 is hard

int score; // current score
int highScore = 0; // high score for the session

color darkGreen = color(62, 77, 48); // store colour in a more readable name
color lightGreen = color(170, 204, 153); // store colour in a more readable name

void setup() {
  size(642, 482);

  // set up audio
  maxim = new Maxim(this);
  beep = maxim.loadFile("beep.wav");
  click = maxim.loadFile("click.wav");
  beep.setLooping(false);
  click.setLooping(false);
  
  initConditions();

  // load all buttons
  easy = new Button(width/2 - 285, height/2 - 45, "Easy");
  normal = new Button(width/2 - 90, height/2 - 45, "Normal");
  hard = new Button(width/2 + 105, height/2 - 45, "Hard");
  
  // load custom font
  font = loadFont("NokiaCellphoneFC-Small-72.vlw");
  textFont(font);
}

void draw() {
  drawBG();
  // start screen
  if (state == -1) {
    drawStart();
  }
  // gameplay
  else if (state == 0) {
    drawScore();
    checkBoundaries();
    moveAndDrawSnake();
    checkSelfCollide();
    if (food.checkEaten()) {
      snake = (SnakeBlock[]) append(snake, new SnakeBlock(endPlaceX, endPlaceY)); // add a block to end of snake
    }
    food.drawFood();
  }
  // game over
  else if (state == 1) {
    drawGameOver();
  }
}

// (re)initialise variables
void initConditions() {
  snakeLength = 5; // intitial length of the snake
  
  state = -1; // begin game at start screen
  
  // if reinitialising set the high score if player beat it
  if (score > highScore) {
    highScore = score;
  }
  score = 0; // set the score to 0

  // intantiate a new snake
  snake = new SnakeBlock[snakeLength];
  for (int i = 0; i < snake.length; i++) {
    snake[i] = new SnakeBlock(width/2 - 100 + i * gridBlockSize, height/2);
    if (i == 0) { 
      snake[i].col = 0;
    }
  }

  // create some new food and give it a position
  food = new Food();
  food.place();
}

// draw start menu to screen
void drawStart() {
  textSize(72);
  textAlign(CENTER);
  fill(darkGreen);
  text("SNAKE", width/2, height/2 - 125);
  textSize(28);
  text("Choose your difficulty level:", width/2, height/2 - 70);
  easy.drawButton();
  normal.drawButton();
  hard.drawButton();
  textSize(20);
  fill(darkGreen);
  text("Collect the food to increase your score", width/2, height/2 + 75);
  text("Touch the sides or your tail and you lose", width/2, height/2 + 120);
  textSize(24);
  text("High Score: " + highScore, width/2, height/2 + 170);
}

// draw background to screen
void drawBG() {
  background(lightGreen);
  noFill();
  strokeWeight(gridBlockSize + 1);
  stroke(darkGreen);
  rect(0.5 * gridBlockSize, 0.5 * gridBlockSize, width - gridBlockSize, height - gridBlockSize);
}

void drawScore() {
  textSize(48);
  textAlign(CENTER, CENTER);
  fill(139, 148, 131);
  text(score, width/2, height/2);
}

// draw game over screen
void drawGameOver() {
  textSize(72);
  textAlign(CENTER);
  fill(darkGreen);
  text("GAME OVER", width/2, height/2 - 40);
  textSize(24);
  text("Press 'R' to restart", width/2, height/2 + 10);
  text("Final Score: " + score, width/2, height/2 + 60);
  if (score > highScore) {
    textSize(48);
    text("NEW HIGH SCORE!", width/2, height/2 + 135); 
  }
}

// controls movement and drawing of blocks that form the snake
void moveAndDrawSnake() {
  for (int i = snake.length - 1; i >= 0; i--) {
    if (frameCount % difficulty == 0) { // changes the rate of movement depending on difficulty
      if (i != 0) {
        snake[i].posX = snake[i - 1].posX; 
        snake[i].posY = snake[i - 1].posY;
      }
      else {
        snake[i].moveBlock();
      }    
    }
    snake[i].drawBlock();
  }
}

// checks whether or not the snake has hit an edge
void checkBoundaries() {
  if (!(snake[0].posX > gridBlockSize && snake[0].posX < width - gridBlockSize - 1 && snake[0].posY > gridBlockSize && snake[0].posY < height - gridBlockSize - 1)) {
    click.play();
    state = 1;
  }
}

// checks if the snake has hit itself
void checkSelfCollide() {
  for (int i = 1; i < snake.length; i++) {
    if (snake[0].posX == snake[i].posX && snake[0].posY == snake[i].posY) {
      click.play();
      state = 1;
    }
  }
}

// checks the position of end block relative to penultimate block so that a new block can be added in correct relative position
void checkEndBlock() {
  int sl = snake.length;

  if (snake[sl - 2].posX + 20 == snake[sl - 1].posX) { // end on right
    endPlaceX = snake[sl - 1].posX + gridBlockSize;
    endPlaceY = snake[sl - 1].posY;
  }
  if (snake[sl - 2].posX - 20 == snake[sl - 1].posX) { // end on left
    endPlaceX = snake[sl - 1].posX - gridBlockSize;
    endPlaceY = snake[sl - 1].posY;
  }
  if (snake[sl - 2].posY + 20 == snake[sl - 1].posY) { // end on top
    endPlaceX = snake[sl - 1].posX;
    endPlaceY = snake[sl - 1].posY - gridBlockSize;
  }
  if (snake[sl - 2].posY - 20 == snake[sl - 1].posY) { // end on bottom
    endPlaceX = snake[sl - 1].posX;
    endPlaceY = snake[sl - 1].posY - gridBlockSize;
  }
}

// increases the score differently depending on difficulty
void increaseScore() {
  if (difficulty == 20) {
    score += 3;
  }
  else if (difficulty == 10) {
    score += 6;
  }
  else if (difficulty == 5) {
    score += 9;
  }
}

void keyPressed() {
  // movement controls, changes direction properties of head block based on user input
  if (key == CODED) {
    if (keyCode == UP) {
      if (snake[0].posY != snake[1].posY + gridBlockSize) {
        snake[0].dirY = -1;
        snake[0].dirX = 0;
      }
    }
    if (keyCode == DOWN) {
      if (snake[0].posY != snake[1].posY - gridBlockSize) {
        snake[0].dirY = 1;
        snake[0].dirX = 0;
      }
    }
    if (keyCode == LEFT) {
      if (snake[0].posX != snake[1].posX + gridBlockSize) {
        snake[0].dirY = 0;
        snake[0].dirX = -1;
      }
    }
    if (keyCode == RIGHT) {
      if (snake[0].posX != snake[1].posX - gridBlockSize) {
        snake[0].dirY = 0;
        snake[0].dirX = 1;
      }
    }
  }

  // used to pause game
  if (key == 'p' || key == 'P') {
    if (looping) {
      noLoop();
    }
    else {
      loop();
    }
  }

  // if game over scren is showing then press 'r' to restart game
  if (state == 1) {
    if (key == 'r' || key == 'R') {
      click.play();
      initConditions();
    }
  }
}

void mouseClicked() {
  // check if one of the start screen buttons is clicked and change difficulty accordingly
  if (state == -1) {
    if (easy.clicked()) {
      difficulty = 20;
    }
    else if (normal.clicked()) {
      difficulty = 10;
    }
    else if (hard.clicked()) {
      difficulty = 5;
    }
  }
}
