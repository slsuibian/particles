boolean fullScreen;
float fullScreenScale;
int maxParticles = 10; 
ArrayList <Particle> particles = new ArrayList <Particle> (); 

// Color array corresponds to all the standard crayola colours
color [] colarray = {  color(237, 10, 53), color(195, 33, 72), color(253, 14, 53), 
  color(198, 45, 66), color(204, 71, 75), color(204, 51, 54), 
  color(225, 44, 44), color(217, 33, 33), color(185, 78, 72), 
  color(255, 63, 52), color(254, 76, 64), color(254, 111, 94), 
  color(179, 59, 36), color(204, 85, 61), color(230, 115, 92), 
  color(255, 153, 128), color(229, 144, 115), color(255, 112, 52), 
  color(255, 104, 31), color(255, 136, 199), color(255, 185, 123), 
  color(236, 177, 118), color(231, 114, 0), color(255, 174, 66), 
  color(242, 186, 73), color(251, 231, 178), color(242, 198, 73), 
  color(248, 213, 104), color(252, 214, 103), color(254, 216, 93), 
  color(252, 232, 131), color(241, 231, 136), color(255, 235, 0), 
  color(181, 179, 92), color(236, 235, 189), color(250, 250, 55), 
  color(255, 255, 153), color(255, 255, 159), color(217, 230, 80), 
  color(172, 191, 96), color(175, 227, 19), color(190, 230, 75), 
  color(197, 225, 122), color(94, 140, 49), color(123, 160, 91), 
  color(157, 224, 147), color(99, 183, 108), color(77, 140, 87), 
  color(58, 166, 85), color(108, 166, 124), color(95, 167, 119), 
  color(147, 223, 184), color(51, 204, 153), color(26, 179, 133), 
  color(41, 171, 135), color(0, 204, 153), color(0, 117, 94), 
  color(141, 217, 204), color(1, 120, 11), color(48, 191, 191), 
  color(0, 204, 204), color(0, 128, 129), color(143, 216, 216), 
  color(149, 224, 232), color(108, 218, 231), color(45, 56, 58), 
  color(118, 215, 234), color(126, 212, 230), color(0, 149, 183), 
  color(0, 157, 196), color(2, 164, 211), color(71, 171, 204), 
  color(46, 180, 230), color(51, 154, 204), color(147, 204, 234), 
  color(40, 135, 200), color(0, 70, 140), color(0, 102, 204), 
  color(21, 96, 189), color(0, 102, 255), color(169, 178, 195), 
  color(195, 205, 230), color(69, 112, 230), color(60, 105, 231), 
  color(122, 137, 184), color(79, 105, 198), color(141, 144, 161), 
  color(140, 144, 200), color(112, 112, 204), color(172, 172, 230), 
  color(118, 110, 200), color(100, 86, 183), color(63, 38, 191), 
  color(139, 114, 190), color(101, 45, 193), color(107, 63, 160), 
  color(131, 89, 163), color(143, 71, 179), color(201, 160, 220), 
  color(191, 143, 204), color(128, 55, 144), color(115, 51, 128), 
  color(215, 174, 221), color(193, 84, 193), color(252, 116, 253), 
  color(115, 46, 108), color(230, 103, 206), color(226, 156, 210), 
  color(142, 49, 121), color(217, 108, 190), color(235, 176, 215), 
  color(200, 80, 155), color(187, 51, 133), color(217, 130, 181), 
  color(166, 58, 121), color(165, 11, 94), color(97, 64, 81), 
  color(246, 83, 166), color(218, 50, 135), color(255, 51, 153), 
  color(251, 174, 210), color(255, 183, 213), color(255, 166, 201), 
  color(247, 70, 138), color(227, 11, 92), color(253, 215, 228), 
  color(230, 46, 107), color(219, 80, 121), color(252, 128, 165), 
  color(240, 145, 169), color(255, 145, 164), color(165, 83, 83), 
  color(202, 52, 53), color(254, 186, 173), color(247, 163, 142), 
  color(233, 116, 81), color(175, 89, 62), color(158, 91, 64), 
  color(135, 66, 31), color(146, 111, 91), color(222, 166, 129), 
  color(210, 125, 70), color(102, 66, 40), color(217, 154, 108), 
  color(231, 201, 175), color(255, 203, 164), color(128, 85, 51), 
  color(253, 213, 177), color(238, 217, 196), color(102, 82, 51), 
  color(131, 112, 80), color(230, 188, 92), color(217, 214, 207), 
  color(146, 146, 110), color(230, 190, 138), color(201, 192, 187), 
  color(218, 138, 103), color(200, 138, 101), color(0, 0, 0), 
  color(115, 106, 98), color(139, 134, 128), color(200, 200, 205), 
  color(255, 255, 255)
}; 


void setup() {
  fullScreen(); 
  fullScreen = true;
  fullScreenScale = width / float(640);
  background(0);
}

void draw() {
  pushMatrix();
  if (fullScreen) { 
    scale(fullScreenScale, fullScreenScale);
  } 
  popMatrix();
  addRemoveParticles();
  for (Particle p : particles) {
    p.update();
    p.display();
  }
  maxParticles += 1;
}

void addRemoveParticles() {
  for (int i=particles.size()-1; i>=0; i--) {
    Particle p = particles.get(i);
    if (p.life <= 0) {
      particles.remove(i);
    }
  }
  while (particles.size () < maxParticles) {
    particles.add(new Particle());
  }
}