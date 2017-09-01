// stores the food to be eaten by snake
public class Food {
  int posX;
  int posY;
  int microBlockSize = 6;

  // set the coordinates of the food somewhere on screen
  void place() {
    int randX = (int) random(1, (width - 2)/gridBlockSize - 1); // generate a random number that sits within the rectangle border
    int randY = (int) random(1, (height - 2)/gridBlockSize - 1); // generate a random number that sits within the rectangle border

    posX = gridBlockSize * randX + 1; // translate random number to pixels
    posY = gridBlockSize * randY + 1; // translate random number to pixels

    // call place() recursively to ensure that the food is never placed on top of the snake
    for (int i = 0; i < snake.length; i++) {
      if (posX == snake[i].posX && posY == snake[i].posY) {
        place();
      }
    }
  }

  // draw food to the screen
  void drawFood() {
    fill(darkGreen);
    rect(posX + 7, posY, microBlockSize, microBlockSize); // tm
    rect(posX, posY + 7, microBlockSize, microBlockSize); // ml
    rect(posX + gridBlockSize - microBlockSize, posY + 7, microBlockSize, microBlockSize); // mr
    rect(posX + 7, posY + gridBlockSize - microBlockSize, microBlockSize, microBlockSize); // bm
  }

  // checks to see if food has been eaten by the snake
  boolean checkEaten() {
    // if eaten
    if (posX == snake[0].posX && posY == snake[0].posY) {
      increaseScore();
      beep.play();
      place();
      return true;
    }
    return false; // not eaten
  }

}
