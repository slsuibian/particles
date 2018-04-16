/**
 * 
 * PixelFlow | Copyright (C) 2017 Thomas Diewald - www.thomasdiewald.com
 * 
 * https://github.com/diwi/PixelFlow.git
 * 
 * A Processing/Java library for high performance GPU-Computing.
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */


// What do I do:
// More than one user the particle size will change and the color will continously change
// 1 user the colour will change every 2 minutes
// The closer the user is to the camera, the more collisions there will be
// The further away the more control, particles will map more to the optical flow of the body
// If no one is in frame it will go to a resting state 

import java.util.Locale;
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.flowfieldparticles.DwFlowFieldParticles;
import com.thomasdiewald.pixelflow.java.imageprocessing.DwOpticalFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;
import processing.core.*;
import processing.opengl.PGraphics2D;
import processing.video.Capture;
import gab.opencv.*;
import java.awt.*; 
import com.thomasdiewald.pixelflow.java.utils.*;
OpenCV opencv;

float scale = 0.5;

PImage output;
Rectangle[] faces;
int cam_w = 640;
int cam_h = 480;

Capture cam;
PGraphics2D pg_canvas;
PGraphics2D pg_obstacles;
PGraphics2D pg_cam; 

DwPixelFlow context;
DwOpticalFlow opticalflow;
DwFlowFieldParticles particles;

DwFlowFieldParticles.SpawnRect spawn = new DwFlowFieldParticles.SpawnRect();

int flag = 0;
boolean debug = false;


// Specific colors of crayola 
float[][] colors = {
  {237, 10, 53}, {195, 33, 72}, {253, 14, 53}, 
  {198, 45, 66}, {204, 71, 75}, {204, 51, 54}, 
  {225, 44, 44}, {217, 33, 33}, {185, 78, 72}, 
  {255, 63, 52}, {254, 76, 64}, {254, 111, 94}, 
  {179, 59, 36}, {204, 85, 61}, {230, 115, 92}, 
  {255, 153, 128}, {229, 144, 115}, {255, 112, 52}, 
  {255, 104, 31}, {255, 136, 199}, {255, 185, 123}, 
  {236, 177, 118}, {231, 114, 0}, {255, 174, 66}, 
  {242, 186, 73}, {251, 231, 178}, {242, 198, 73}, 
  {248, 213, 104}, {252, 214, 103}, {254, 216, 93}, 
  {252, 232, 131}, {241, 231, 136}, {255, 235, 0}, 
  {181, 179, 92}, {236, 235, 189}, {250, 250, 55}, 
  {255, 255, 153}, {255, 255, 159}, {217, 230, 80}, 
  {172, 191, 96}, {175, 227, 19}, {190, 230, 75}, 
  {197, 225, 122}, {94, 140, 49}, {123, 160, 91}, 
  {157, 224, 147}, {99, 183, 108}, {77, 140, 87}, 
  {58, 166, 85}, {108, 166, 124}, {95, 167, 119}, 
  {147, 223, 184}, {51, 204, 153}, {26, 179, 133}, 
  {41, 171, 135}, {0, 204, 153}, {0, 117, 94}, 
  {141, 217, 204}, {1, 120, 11}, {48, 191, 191}, 
  {0, 204, 204}, {0, 128, 129}, {143, 216, 216}, 
  {149, 224, 232}, {108, 218, 231}, {45, 56, 58}, 
  {118, 215, 234}, {126, 212, 230}, {0, 149, 183}, 
  {0, 157, 196}, {2, 164, 211}, {71, 171, 204}, 
  {46, 180, 230}, {51, 154, 204}, {147, 204, 234}, 
  {40, 135, 200}, {0, 70, 140}, {0, 102, 204}, 
  {21, 96, 189}, {0, 102, 255}, {169, 178, 195}, 
  {195, 205, 230}, {69, 112, 230}, {60, 105, 231}, 
  {122, 137, 184}, {79, 105, 198}, {141, 144, 161}, 
  {140, 144, 200}, {112, 112, 204}, {172, 172, 230}, 
  {118, 110, 200}, {100, 86, 183}, {63, 38, 191}, 
  {139, 114, 190}, {101, 45, 193}, {107, 63, 160}, 
  {131, 89, 163}, {143, 71, 179}, {201, 160, 220}, 
  {191, 143, 204}, {128, 55, 144}, {115, 51, 128}, 
  {215, 174, 221}, {193, 84, 193}, {252, 116, 253}, 
  {115, 46, 108}, {230, 103, 206}, {226, 156, 210}, 
  {142, 49, 121}, {217, 108, 190}, {235, 176, 215}, 
  {200, 80, 155}, {187, 51, 133}, {217, 130, 181}, 
  {166, 58, 121}, {165, 11, 94}, {97, 64, 81}, 
  {246, 83, 166}, {218, 50, 135}, {255, 51, 153}, 
  {251, 174, 210}, {255, 183, 213}, {255, 166, 201}, 
  {247, 70, 138}, {227, 11, 92}, {253, 215, 228}, 
  {230, 46, 107}, {219, 80, 121}, {252, 128, 165}, 
  {240, 145, 169}, {255, 145, 164}, {165, 83, 83}, 
  {202, 52, 53}, {254, 186, 173}, {247, 163, 142}, 
  {233, 116, 81}, {175, 89, 62}, {158, 91, 64}, 
  {135, 66, 31}, {146, 111, 91}, {222, 166, 129}, 
  {210, 125, 70}, {102, 66, 40}, {217, 154, 108}, 
  {231, 201, 175}, {255, 203, 164}, {128, 85, 51}, 
  {253, 213, 177}, {238, 217, 196}, {102, 82, 51}, 
  {131, 112, 80}, {230, 188, 92}, {217, 214, 207}, 
  {146, 146, 110}, {230, 190, 138}, {201, 192, 187}, 
  {218, 138, 103}, {200, 138, 101}, {0, 0, 0}, 
  {115, 106, 98}, {139, 134, 128}, {200, 200, 205}, 
  {255, 255, 255}
};



void setup() {
  size(1280, 800, P2D);
  surface.setLocation(-2, 0);
  cam = new Capture(this, cam_w, cam_h, 30);
  cam.start();

  pg_cam = (PGraphics2D) createGraphics(cam_w, cam_h, P2D);
  pg_cam.smooth(0);
  pg_cam.beginDraw();
  pg_cam.background(0);
  pg_cam.endDraw();

  pg_canvas = (PGraphics2D) createGraphics(width, height, P2D);
  pg_canvas.smooth(0);

  int border = 1;
  pg_obstacles = (PGraphics2D) createGraphics(width, height, P2D);
  pg_obstacles.smooth(0);
  pg_obstacles.beginDraw();
  pg_obstacles.clear();
  pg_obstacles.noStroke();
  pg_obstacles.blendMode(REPLACE);
  pg_obstacles.rectMode(CORNER);
  pg_obstacles.fill(0, 255);
  pg_obstacles.rect(0, 0, width, height);
  pg_obstacles.fill(0, 0);
  pg_obstacles.rect(border/2, border/2, width-border, height-border);
  pg_obstacles.endDraw();

  context = new DwPixelFlow(this);

  opticalflow = new DwOpticalFlow(context, cam_w, cam_h);
  float dimx = width  - border;
  float dimy = height - border;

  int particle_size = 6;
  int numx = (int) (dimx / (0.9f*particle_size));
  int numy = (int) (dimy / (0.9f*particle_size));

  // particle spawn-def, rectangular shape
  spawn.num(numx, numy);
  spawn.dim(dimx, dimy);
  spawn.pos(width/2-dimx/2, height/2-dimy/2);
  spawn.vel(0, 0);

  // partcle simulation - initial setup 
  particles = new DwFlowFieldParticles(context, numx * numy);
  updateColor(1);
  particles.param.shader_type = 1;
  particles.param.shader_collision_mult = 0.4f;
  particles.param.steps = 1;
  particles.param.velocity_damping  = 0.999f;
  particles.param.size_display   = ceil(particle_size * 1.5f);
  particles.param.size_collision = particle_size;
  particles.param.size_cohesion  = particle_size;
  particles.param.mul_coh = 0.20f;
  particles.param.mul_col = 1.00f;
  particles.param.mul_obs = 2.00f;
  particles.param.mul_acc = 0.10f; // optical flow multiplier
  particles.param.wh_scale_obs = 0;
  particles.param.wh_scale_coh = 5;
  particles.param.wh_scale_col = 0;

  // init stuff that doesn't change
  particles.resizeWorld(width, height); 
  particles.spawn(width, height, spawn); // respawns the particles 
  particles.createObstacleFlowField(pg_obstacles, new int[]{0, 0, 0, 255}, false);

  frameRate(1000);

  opencv = new OpenCV(this, cam.width, cam.height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  output = new PImage(cam.width, cam.height);
}


void draw() {

  // capture camera frame + optical flow
  if (cam.available()) {
    cam.read();

    pg_cam.beginDraw();
    pg_cam.image(cam, 0, 0);
    pg_cam.endDraw();

    // compute Optical Flow
    opticalflow.update(pg_cam);
    opencv.loadImage(cam);

    faces = opencv.detect();

    // switch to RGB mode before we grab the image to display
    opencv.useColor(RGB);
    output = opencv.getSnapshot();
  }
  
  if (faces != null) {

    // Reset if we have no faces
    if (faces.length == 0)
      particles.spawn(width, height, spawn);
      
    particles.param.timestep = 1f/frameRate;

    // update particles, using the opticalflow for acceleration
    particles.update(opticalflow.frameCurr.velocity);

    // render obstacles + particles
    pg_canvas.beginDraw(); 
    pg_canvas.image(pg_obstacles, 0, 0);
    pg_canvas.endDraw();
    particles.displayParticles(pg_canvas);

    int m = minute();
    
    if (m % 2 == 0)
    {
      flag = 1;
      party();
    }

    if (m%3 == 0)
      flag = 0;

    if (faces.length > 1)
    {
      particles.param.size_display   = ceil(faces.length * 7.5f);
      updateColor(0);
    }
    else
    {
      particles.param.size_display = ceil(6 * 1.5f);
    }

    // display result
    image(pg_canvas, 0, 0);


    for (int i = 0; i < faces.length; i++) {

      // scale the tracked faces to canvas size
      float s = 1 / scale;
      int x = int(faces[i].x * s);
      int y = int(faces[i].y * s);
      int w = int(faces[i].width * s);
      int h = int(faces[i].height * s);

      if (w > 290) {
        particles.param.mul_acc = 100;
      } else if (w > 190 && w < 290)
      {
        particles.param.mul_acc = 50;
      } else
      {
        particles.param.mul_acc = 25;
      }

      if (debug)
      {
      stroke(255, 255, 0);
      noFill();     
      rect(x, y, w, h);
      fill(255, 255, 0);
      text(i, x, y - 20);
      }
    }
  }
}

// Change the color of the particles
void updateColor(int col) {
  float mix = sin(frameCount*0.001f) * 0.5f + 0.5f;
  float s1 = 1f/255f;
  float s2 = s1 * 0.25f;
  if (col == 1)
  {
    float[] rgb1 = {139, 134, 128};
    particles.param.col_A = new float[]{rgb1[0] * s1, rgb1[1] * s1, rgb1[2] * s1, 1.0f};
    particles.param.col_B = new float[]{rgb1[0] * s2, rgb1[1] * s2, rgb1[2] * s2, 0.0f};
  }
  else
  {
    float[] rgb1 = DwUtils.getColor(colors, mix, null);
    particles.param.col_A = new float[]{rgb1[0] * s1, rgb1[1] * s1, rgb1[2] * s1, 1.0f};
    particles.param.col_B = new float[]{rgb1[0] * s2, rgb1[1] * s2, rgb1[2] * s2, 0.0f};
  }
}


void party()
{
  updateColor(0);
  particles.spawn(width, height, spawn);
}