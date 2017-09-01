// store button objects for selecting difficulty
public class Button {
  int topLeftX;
  int topLeftY;
  int w;
  int h;
  String label;

  Button(int tlX, int tlY, String txt) {
    topLeftX = tlX;
    topLeftY = tlY;
    w = 180;
    h = 80;
    label = txt;
  }

  // draw the button to screen
  void drawButton() {
    strokeWeight(5);
    stroke(darkGreen);
    if (mouseX > topLeftX && mouseX < topLeftX + w && mouseY > topLeftY && mouseY < topLeftY + h) {
      fill(darkGreen);
      rect(topLeftX, topLeftY, w, h);
      fill(lightGreen);
    }
    else {
      fill(lightGreen);
      rect(topLeftX, topLeftY, w, h);
      fill(darkGreen);
    }
    textAlign(CENTER, CENTER);
    textSize(36);
    text(label, topLeftX + w/2 + 4, topLeftY + h/2);
  }

  // initiates game play when clicked (used in conjunction with mouseClicked() function)
  boolean clicked() {
    if (mouseX > topLeftX && mouseX < topLeftX + w && mouseY > topLeftY && mouseY < topLeftY + h) {
      state = 0;
      click.play();
      return true;
    }
    return false;
  }
}