class Particle {
  PVector loc;
  float maxLife, life, lifeRate;

  Particle() {
    getPosition();
    maxLife = 1.25;
    life = random(0.5 * maxLife, maxLife);
    lifeRate = random(0.01, 0.02);
  }

  void update() {
    life -= lifeRate;
  }

  void display() {
    float pickcolor = random(colarray.length); 
    fill(colarray[(int) pickcolor]); 
    stroke(0); 
    float r = 30 * life/maxLife; 
    ellipse(loc.x, loc.y, r, r);
  }

  void getPosition() {
    while (loc == null) loc = new PVector(random(width), random(height));
  }
}