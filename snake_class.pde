// stores individual blocks that make up the snake
public class SnakeBlock {
  int blockSize;
  int posX;
  int posY;
  int dirX;
  int dirY;
  color col;
  
  SnakeBlock(int x, int y) {
    blockSize = 18;
    posX = x;
    posY = y;
    dirX = -1;
    dirY = 0;
    col = color(darkGreen);
  }
  
  // draws the block to the screen
  void drawBlock() {
    fill(col);
    strokeWeight(1);
    rect(posX + 1, posY + 1, blockSize, blockSize);
  }
  
  // moves the block based on direction (only used with snake[0])
  void moveBlock() {
    if (dirX == 1) {
      posX += gridBlockSize;
    }
    else if (dirX == -1) {
      posX -= gridBlockSize;
    }
    
    if (dirY == 1) {
      posY += gridBlockSize;
    }
    else if (dirY == -1) {
      posY -= gridBlockSize;
    }
  }
}
