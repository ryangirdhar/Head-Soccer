/*********************************************** //<>//
 *                Ryan Girdhar                 *
 ***********************************************/

int ballRadius = 10;
PVector PositionBall = new PVector(600, 100);
PVector VelocityBall = new PVector(0, 0);
PVector GravityBall = new PVector(0, 1);
float fluidResistance = 0.02; 
float elasticity = 0.7; 
int changeScreen = 0;
PImage [] Players = new PImage [2];
PVector GravityPlayer1 = new PVector(0, 1);
PVector GravityPlayer2 = new PVector(0, 1);
PVector PositionPlayer1 = new PVector(100, 650);
PVector PositionPlayer2 = new PVector(1050, 650);
PVector VelocityPlayer1 = new PVector(0, 0);
PVector VelocityPlayer2 = new PVector(0, 0);
boolean move1Left = false;
boolean move1Right = false;
boolean move2Left = false;
boolean move2Right = false;
boolean move1Up = false;
boolean move2Up = false;
int player1Score = 0;
int player2Score = 0;
int leftBarrier = 0;
int rightBarrier = 1200;
int colourP1 = (#ff0000);
int colourP2 = (#ff0000);
int xGoal = 5;
int yGoal = 400;
int time = 0;
PImage goal;
int xGoalAnimation = 1200;
int yGoalAnimation = 200;
boolean scored = false;
int black = #000000;
int white = #ffffff;
int numberOfRectangles = 800 ;
float red = 0, green = 0, blue = 0;
PImage menuBackground, stadium, ball;

void setup() {
  size(1200, 800);
  Players[0] = loadImage("Player1.png");
  Players[1] = loadImage("Player2.png");
  goal = loadImage("Goal.png");
  menuBackground = loadImage("menuBackground.png");
  stadium = loadImage("stadium.png");
  ball = loadImage("ball.png");
  Players[0].resize(100, 100);
  Players[1].resize(100, 100);
  goal.resize(400, 400);
  menuBackground.resize(1200, 800);
  stadium.resize(1200, 800);
  ball.resize(40, 40);
}

void draw() {
  background(#000000);
  
  if (changeScreen == 0) {
    startingScreen();
  } else if (changeScreen == 1) {
    colourScreen();
  } else if (changeScreen == 2) {
    ruleScreen();
  } else if (changeScreen == 4) {
    endScreen();
  } else if (changeScreen == 3) {
    image(stadium, 0, 0);
    fill(#FFE5B4);
    rect(0, height-50, 1200, 50);
    
    moveBall();
    checkBallHitEdges();
    rectP1();
    rectP2();
    drawPlayers();
    movePlayers();
    drawBall();
    p1Colour();
    p2Colour();
    goalLeft();
    goalRight();
    detectGoal();
    
    textSize(30);
    fill(white);
    text(player1Score, 35, 50);
    text(player2Score, 1150, 50);
    determineWinner();
  }
}

void checkBallHitEdges() {
  // Only bounce off sides if above the goal area
  if (PositionBall.y < 400) {
    if (PositionBall.x + 40 > width || PositionBall.x < 0) {
      VelocityBall.x *= -1;
    }
  }
  
  // Floor
  if (PositionBall.y + 40 > height - 50) {
    VelocityBall.y *= -elasticity;
    PositionBall.y = height - 90;
  }
  
  // Ceiling
  if (PositionBall.y < 0) {
    VelocityBall.y *= -1;
    PositionBall.y = 0;
  }

  // Player 1 Collision
  if (PositionBall.x + 40 > PositionPlayer1.x && PositionBall.x < PositionPlayer1.x + 100 && 
      PositionBall.y + 40 > PositionPlayer1.y && PositionBall.y < PositionPlayer1.y + 100) {
     VelocityBall.y = -18;
     VelocityBall.x = (PositionBall.x - PositionPlayer1.x - 50) * 0.4;
  }
  
  // Player 2 Collision
  if (PositionBall.x + 40 > PositionPlayer2.x && PositionBall.x < PositionPlayer2.x + 100 && 
      PositionBall.y + 40 > PositionPlayer2.y && PositionBall.y < PositionPlayer2.y + 100) {
     VelocityBall.y = -18;
     VelocityBall.x = (PositionBall.x - PositionPlayer2.x - 50) * 0.4;
  }
}

void moveBall() {
  if (!scored) {
    VelocityBall.add(GravityBall);
    VelocityBall.mult(1 - fluidResistance);
    PositionBall.add(VelocityBall);
  }
}

void drawBall() {
  image(ball, PositionBall.x, PositionBall.y);
}

void drawPlayers() {
  image(Players[0], PositionPlayer1.x, PositionPlayer1.y);
  image(Players[1], PositionPlayer2.x, PositionPlayer2.y);
}

void movePlayers() {
  PositionPlayer1.add(VelocityPlayer1);
  PositionPlayer2.add(VelocityPlayer2);

  if (move1Left) VelocityPlayer1.x = -8;
  else if (move1Right) VelocityPlayer1.x = 8;
  else VelocityPlayer1.x = 0;

  if (move2Left) VelocityPlayer2.x = -8;
  else if (move2Right) VelocityPlayer2.x = 8;
  else VelocityPlayer2.x = 0;

  VelocityPlayer1.y += 1; 
  if (PositionPlayer1.y >= 650) {
    PositionPlayer1.y = 650;
    VelocityPlayer1.y = 0;
    move1Up = false; 
  }

  VelocityPlayer2.y += 1; 
  if (PositionPlayer2.y >= 650) {
    PositionPlayer2.y = 650;
    VelocityPlayer2.y = 0;
    move2Up = false;
  }
  
  PositionPlayer1.x = constrain(PositionPlayer1.x, 0, 1100);
  PositionPlayer2.x = constrain(PositionPlayer2.x, 0, 1100);
}

void keyPressed() {
  if (changeScreen == 0 && keyCode == 32) changeScreen = 3;

  if (changeScreen == 1) {
    if (key == 'r' || key == 'R') colourP1 = #ff0000;
    if (key == 'g' || key == 'G') colourP1 = #00ff00;
    if (key == 'b' || key == 'B') colourP1 = #0000ff;
    if (key == '1') colourP2 = #ff0000;
    if (key == '2') colourP2 = #00ff00;
    if (key == '3') colourP2 = #0000ff;
  }
  
  if (changeScreen == 3) {
    if (keyCode == 65) move1Left = true;
    if (keyCode == 68) move1Right = true;
    if (keyCode == 87 && !move1Up) { move1Up = true; VelocityPlayer1.y = -22; }
    if (keyCode == 37) move2Left = true;
    if (keyCode == 39) move2Right = true;
    if (keyCode == 38 && !move2Up) { move2Up = true; VelocityPlayer2.y = -22; }
  }
  
  if (changeScreen == 4 && keyCode == 32) {
    resetGameState();
    changeScreen = 3;
  }
}

void keyReleased() {
  if (keyCode == 65) move1Left = false;
  if (keyCode == 68) move1Right = false;
  if (keyCode == 37) move2Left = false;
  if (keyCode == 39) move2Right = false;
}

void rectP1() { fill(black); rect(PositionPlayer1.x+30, PositionPlayer1.y+10, 40, 80); }
void rectP2() { fill(black); rect(PositionPlayer2.x+30, PositionPlayer2.y+10, 40, 80); }
void p1Colour() { fill(colourP1); rect(PositionPlayer1.x+30, PositionPlayer1.y+35, 30, 30); }
void p2Colour() { fill(colourP2); rect(PositionPlayer2.x+30, PositionPlayer2.y+35, 30, 30); }
void goalLeft() { fill(colourP1); rect(0, 400, xGoal, yGoal); }
void goalRight() { fill(colourP2); rect(1195, 400, xGoal, yGoal); }

void detectGoal() {
  if (!scored) {
    if (PositionBall.x > 1170 && PositionBall.y >= 400) {
      player1Score++; scored = true; time = millis(); VelocityBall.set(0,0);
    } else if (PositionBall.x < 10 && PositionBall.y >= 400) {
      player2Score++; scored = true; time = millis(); VelocityBall.set(0,0);
    }
  }
  displayScoredAnimation();
}

void displayScoredAnimation() {
  if (scored) {
    image(goal, xGoalAnimation, yGoalAnimation);
    xGoalAnimation -= 20;
    if (xGoalAnimation < -400) {
        scored = false;
        xGoalAnimation = 1200;
        PositionBall.set(600, 100);
        VelocityBall.set(0,0);
    }
  }
}

void determineWinner() {
  if (player1Score >= 10 || player2Score >= 10) changeScreen = 4;
}

void startingScreen() {
  image(menuBackground, 0, 0);
  fill(white); rect(440, 585, 370, 50);
  fill(black); textSize(30); text("Press Space To Start", 475, 620);
  fill(white); rect(230, 678, 200, 30);
  fill(black); textSize(20); text("Pick Player Colours", 240, 700);
  fill(white); rect(810, 678, 200, 30);
  fill(black); text("Rules Of The Game", 825, 700);
  if (mousePressed) {
    if (mouseX >= 230 && mouseX <= 430 && mouseY > 678 && mouseY < 708) changeScreen = 1;
    if (mouseX >= 810 && mouseX <= 1010 && mouseY > 678 && mouseY < 708) changeScreen = 2;
  }
}

void colourScreen() {
  gradientBackground1();
  fill(white); rect(300, 100, 600, 400);
  fill(black); textSize(40); text("SELECT COLOURS", 420, 160);
  textSize(25);
  fill(#ff0000); text("R / 1 = Red", 530, 250);
  fill(#00ff00); text("G / 2 = Green", 530, 300);
  fill(#0000ff); text("B / 3 = Blue", 530, 350);
  menuButton();
}

void ruleScreen() {
  gradientBackground2();
  fill(white); rect(300, 100, 600, 500);
  fill(black); textSize(40); text("RULES", 540, 160);
  textSize(22);
  text("1. First to 10 points wins.", 350, 250);
  text("2. P1: WASD | P2: Arrow Keys", 350, 300);
  menuButton();
}

void endScreen() {
  gradientBackground3();
  fill(black); textSize(60); text("GAME OVER", 440, 300);
  textSize(40); text(player1Score >= 10 ? "Left Player Won!" : "Right Player Won!", 420, 400);
  text("Press Space to Restart", 420, 500);
  menuButton();
}

void menuButton() {
  fill(white); rect(10, 740, 120, 40);
  fill(black); textSize(25); text("Menu", 35, 770);
  if (mousePressed && mouseX > 10 && mouseX < 130 && mouseY > 740 && mouseY < 780) {
    changeScreen = 0; resetGameState();
  }
}

void resetGameState() {
  player1Score = 0; player2Score = 0;
  PositionBall.set(600, 100); VelocityBall.set(0, 0);
  PositionPlayer1.set(100, 650); PositionPlayer2.set(1050, 650);
  scored = false; xGoalAnimation = 1200;
}

void gradientBackground1() { for (int i = 0; i < height; i+=5) { fill(255, i/4, 100); noStroke(); rect(0, i, width, 5); } }
void gradientBackground2() { for (int i = 0; i < height; i+=5) { fill(100, 255, i/4); noStroke(); rect(0, i, width, 5); } }
void gradientBackground3() { for (int i = 0; i < height; i+=5) { fill(i/4, 100, 255); noStroke(); rect(0, i, width, 5); } }
