//CSCi 5611: Project 1
//6/20/2020
//Zachary Wieczorek (wiecz045)

//Recommended max for numBoids is around 2000, ideal performance at 1000
static int numBoids = 1000;
//REcommended max for numCubes is 50
static int numCubes = 10;

//Positions, velocities, and accelerations of Boids
Vec3 pos[] = new Vec3[numBoids];
Vec3 vel[] = new Vec3[numBoids];
Vec3 acc[] = new Vec3[numBoids];

//Coordinates of cubes
Cubes cube[] = new Cubes[numCubes];
Vec3 cubeVec[] = new Vec3[numCubes];

//if boid is perching (stationary for a random time) don't update movement
boolean perching[]  = new boolean[numBoids];
float perchingTime[] = new float[numBoids];

float maxSpeed = 30;  //base 20
float targetSpeed = 15;  //base 10
float maxForce = 15;  //base 10
float radius = 1;  //initial = 6

//canned for directional purposes
Vec3      up = new Vec3(       0,  maxSpeed,       0);
Vec3   right = new Vec3(maxSpeed,         0,       0);
Vec3 forward = new Vec3(       0,         0,maxSpeed);
Vec3 deCollide = new Vec3(0, -1, 0);
Vec3 home = new Vec3(600, 500, 400);

//laser tracker
float colorTracker = 0;  //counter incremented by dt-sized intervals
float blue = 0;          //tracks which cube is "blue" i.e: attractive
float flag = 1;

Camera camera;

float z = 800;
float z_edge = z;
Vec3 ceiling = new Vec3(width/2,0,z_edge/2);

void setup(){
  
  size(1200,800, P3D);
  //float z = 800;
  //float z_edge = z;
  surface.setTitle("3D Boids Test");
  
  camera = new Camera();
  
  //Initial boid positions and velocities and boolean values
  for (int i = 0; i < numBoids; i++){
    pos[i] = new Vec3((width/2)+random(25),(height-300)+random(25), 400+random(25));
    //pos[i] = new Vec3((width/2),(height/2), 400);
    vel[i] = new Vec3(-1+random(2), 0, -1+random(2)); 
    vel[i].normalize();
    vel[i].mul(maxSpeed);
    perching[i] = false;
    perchingTime[i] = 0;
    
  }
  //optional: gen cube locations
  for(int i = 0; i < numCubes; i++){
    cube[i] = new Cubes(random(width),random((height-150)), 
                      random(z_edge),50);
    float cx = cube[i].x;
    float cy= cube[i].y;
    float cz = cube[i].z;
    cubeVec[i] = new Vec3(cx,cy,cz);                                      
  }
  
  //manipulate whihc laser points where
  
  strokeWeight(2); //Draw thicker lines 
}

void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}
//void mousePressed(){
  
//}
//void mouseReleased(){
  
//}

void draw(){
  //background(255); //Grey background
  background(0);  //black background
  
  //print mouse data
  //println(mouseX + " : " + mouseY);
  
  stroke(255, 255, 255);
  //fill(255);
  //for (int i = 0; i < numBoids; i++){
  //  circle(pos[i].x, pos[i].y,40*2); //Question: Why is it radius*2 ?
  //}
  fill(10,120,10);
  
  //drawing the world
  line(      0,       0,    0,  width,       0,  0);
  line(  width,       0,    0,  width,  height,  0);
  line(      0,  height,    0,  width,  height,  0);
  line(      0,       0,    0,      0,  height,  0);
  
  line(      0,       0,  z_edge,  width,       0,  z_edge);
  line(  width,       0,  z_edge,  width,  height,  z_edge);
  line(      0,  height,  z_edge,  width,  height,  z_edge);
  line(      0,       0,  z_edge,      0,  height,  z_edge);
  
  line(      0,       0,        0,      0,       0,  z_edge);
  line(  width,       0,        0,  width,       0,  z_edge);
  line(      0,  height,        0,      0,  height,  z_edge);
  line(  width,  height,    0,  width,  height,  z_edge);
  
  stroke(255, 255, 255);
  
  //drawing the cage
  noFill();
  pushMatrix();
  translate( width/2, height-300, 400);
  box( 50 );
  popMatrix();
  
  //pyramid
  float unit = 150;
  //point ccordinates: width/2, height-200, 400
  fill(0,0,0);
  pushMatrix();
  translate( width/2, height-150, 400 );
  rotateX(PI/2);
  beginShape();
  vertex(-unit, -unit, -unit);
  vertex( unit, -unit, -unit);
  vertex(   0,    0,  2*unit);
  vertex( unit, -unit, -unit);
  vertex( unit,  unit, -unit);
  vertex(   0,    0,  2*unit);
  vertex( unit, unit, -unit);
  vertex(-unit, unit, -unit);
  vertex(   0,   0,  2*unit);
  vertex(-unit,  unit, -unit);
  vertex(-unit, -unit, -unit);
  vertex(   0,    0,  2*unit);
  endShape();
  popMatrix();
  
  line((width/2)+unit, height, (z_edge/2)+unit, (width/2)+25, (height-300)+25, 425); 
  line((width/2)-unit, height, (z_edge/2)-unit, (width/2)-25, (height-300)+25, 375);
  line((width/2)-unit, height, (z_edge/2)+unit, (width/2)-25, (height-300)+25, 425);
  line((width/2)+unit, height, (z_edge/2)-unit, (width/2)+25, (height-300)+25, 375);

  //pyramid laser 
  //stroke(0,0,255);
  //line(width/2,height-200, 400, 500,500,500);
  //stroke(255, 255, 255);
  
  for(int i=0; i<numCubes; i++){
      float cx = cube[i].x;
      float cy= cube[i].y;
      float cz = cube[i].z;
      float cr =cube[i].r;
      if(i != blue){
        noFill();
        pushMatrix();
        translate( cx, cy, cz);
        box( cr );
        popMatrix();
      }
      else if(i == blue & i != 2){
        fill(0,0,255);
        pushMatrix();
        translate( cx, cy, cz);
        box( cr );
        popMatrix();
        flag = 1;
      }
      else{
        fill(255,0,0);
        pushMatrix();
        translate( cx, cy, cz);
        box( cr );
        popMatrix();
        flag = -1;
      }
  }
  
  if(blue > numCubes) blue -= blue;
  laser(cube[(int)blue],flag);
   
  for (int i = 0; i < numBoids; i++){
    //circle(pos[i].x, pos[i].y,radius*2); //use billboarding for circles?
    
    point(pos[i].x, pos[i].y, pos[i].z);
    stroke(255, 255, 255);
    
    //pushMatrix();
    //translate(pos[i].x, pos[i].y, pos[i].z);
    //sphere(radius*2);
    //popMatrix();
  }
  
  float dt = .1;
  //println("dt is :"  + colorTracker);
  
  //TODO: We loop through our neighbors 3 times, can you do it just once? -> Yes
  for (int i = 0; i < numBoids; i++){
    
    acc[i] = new Vec3(0,0,0);
    Vec3 avgPos = new Vec3(0,0,0);
    int count1 = 0;
    Vec3 avgVel = new Vec3(0,0,0);
    int count2 = 0;
    
    for  (int j = 0; j < numBoids; j++){ //Go through neighbors
      float dist = pos[i].minus(pos[j]).length();
      
      //Seperation force 
      if (dist < .01 || dist > 50) continue;
      Vec3 seperationForce =  pos[i].minus(pos[j]).normalized();
      seperationForce.setToLength(200.0/pow(dist,2));
      acc[i] = acc[i].plus(seperationForce);
      
      //Atttraction force
      //increment count1 
      if (dist < 50 && dist > 0){
        avgPos.add(pos[j]);
        count1 += 1;
      }
      
      //Alignment force
      //incr count2
      if (dist < 40 && dist > 0){
        avgVel.add(vel[j]);
        count2 += 1;
      }
    }
    
    avgPos.mul(1.0/count1);
    if (count1 >= 1){
      Vec3 attractionForce = avgPos.minus(pos[i]);
      attractionForce.normalize();
      attractionForce.times(4);
      attractionForce.clampToLength(maxForce);
      acc[i] = acc[i].plus(attractionForce);
    }
       
    avgVel.mul(1.0/count2);
    if (count2 >= 1){
      Vec3 towards = avgVel.minus(vel[i]);
      towards.normalize();
      acc[i] = acc[i].plus(towards.times(2));
    }
    
    for(int k = 0; k < numCubes; k++){
      float cubeDist = pos[i].minus(cubeVec[k]).length();
      if(cubeDist < 70){
          Vec3 seperationForce =  pos[i].minus(cubeVec[k]).normalized();
          seperationForce.setToLength(200.0/pow(cubeDist,2));
          acc[i] = acc[i].plus(seperationForce);
      }
    }
    
    //attraction to "sexy " cube
    if(flag >0){
      Vec3 toSexyCube = cubeVec[(int)blue].minus(pos[i]);
      toSexyCube.normalize();
      toSexyCube.times(4);
      toSexyCube.clampToLength(maxForce);
      acc[i] = acc[i].plus(toSexyCube);
    }
    //NOTE: push factors tend to intend odd clustering, scrapped
    else{
    //aersion to "scary" cube
      Vec3 fromScaryCube = cubeVec[(int)blue].minus(pos[i]);
      fromScaryCube.normalize();
      fromScaryCube.times(4);
      fromScaryCube.clampToLength(maxForce*-0.5);
      acc[i] = acc[i].plus(fromScaryCube);
    }
    //aversion to walls/floor/ceiling -> No, too buggy somehow

    if(pos[i].y > (height-10) ){
      acc[i].plus(up.times(-1));
    }
    if( pos[i].y < 50){
      acc[i].plus(up.times(1));
    }
    
    //Vec3 mousePos = new Vec3(mouseX, mouseY, );
    
    //cursor-follow (on clicking)
    //if(mousePressed == true){
    //  if(0 < mouseX & mouseX < width & 0 < mouseY & mouseY < height){
    //    acc[i] = acc[i].plus()
    //  }
    //}
    
    //width/2, height-300, 400
    
    if(keyPressed == true){
      if(key == 'h'){
        Vec3 toHome = home.minus(pos[i]);
        toHome.normalize();
        toHome.times(4);
        toHome.clampToLength(maxForce*10);
        //pos[i] = home;
        vel[i] = vel[i].plus(toHome);
        acc[i] = acc[i].plus(toHome);
        acc[i] = acc[i].times(1.5);
        //println("HOME");

        stroke(0,255,0);
        line(width/2,height-400, 400, width/2, height-300, 400);
        
        noFill();
        pushMatrix();
        translate( width/2, height-300, 400);
        box( 50 );
        popMatrix();
        stroke(255, 255, 255);
        
     }
     if(key == 'g'){
       pos[i]= home;
     }
     if(key == 'j'){
       blue += 1;
       break;
     }
      
    }
    
    
    //Goal Speed
    Vec3 targetVel = vel[i];
    targetVel.setToLength(targetSpeed);
    Vec3 goalSpeedForce = targetVel.minus(vel[i]);
    goalSpeedForce.times(1);
    goalSpeedForce.clampToLength(maxForce);
    acc[i] = acc[i].plus(goalSpeedForce);    
    
    //Wander force
    Vec3 randVec = new Vec3(1-random(2),1-random(2), 0);
    acc[i] = acc[i].plus(randVec.times(10.0)); 
  }
  
  for (int i = 0; i < numBoids; i++){
      
    if (perching[i]){
      if(perchingTime[i] > 0) perchingTime[i] -= dt;
      else{  
        float distCeiling = pos[i].minus(ceiling).length();
        pos[i] = pos[i].plus(deCollide.times(1));
        Vec3 seperationForce =  pos[i].minus(ceiling).normalized();
        seperationForce.setToLength(200.0/pow(distCeiling,2));
        acc[i] = acc[i].plus(seperationForce);
        acc[i].times(-1);
        //acc[i] = acc[i].plus(up);
        //vel[i] = vel[i].plus(up.times(10));
        //vel[i] = vel[i].plus(acc[i].times(dt));
        //pos[i] = pos[i].plus(vel[i].times(dt));
        perching[i] = false;
      }
    }
    else{
        pos[i] = pos[i].plus(vel[i].times(dt));
        vel[i] = vel[i].plus(acc[i].times(dt));
    }
    
    //Update Position & Velocity
    //pos[i] = pos[i].plus(vel[i].times(dt));
    //vel[i] = vel[i].plus(acc[i].times(dt));
    //println(vel[i].x,vel[i].y);
    
    //Max speed
    if (vel[i].length() > maxSpeed){
      vel[i] = vel[i].normalized().times(maxSpeed);
    }
    
    if(blue == numCubes) blue -= blue;
    if(collide(pos[i], cubeVec[(int)blue], 50)){
      vel[i].x *= -0.01;
      vel[i].y *= -0.01;
      vel[i].z *= -0.01;
    }
    
    //for automatic laser
    colorTracker += dt;
    //println("blue is: " + blue);
    if(colorTracker > 100000){
      if (blue == numCubes){
        blue -= blue;
      }
      else blue +=1;
      colorTracker -= 100000;
    }
    
    //Loop betweene edges
    if (pos[i].x < 0) pos[i].x += width;
    if (pos[i].x > width) pos[i].x -= width;
    //retool y-axis rules: perch on floor, drift back from ceiling
    //if (pos[i].y < 0) pos[i].y += height;
    //if (pos[i].y > height) pos[i].y -= height;
    if (pos[i].y > height){
      pos[i].y = height;
      vel[i].minus(vel[i]);
      acc[i].minus(acc[i]);
      float time = 10*random(10)*dt;
      //float time = 5*dt;
      perchingTime[i] = time;
      perching[i] = true;  
    }
    if (pos[i].y <0) acc[i].plus(up);
    if (pos[i].z < 0) pos[i].z += z_edge;
    if (pos[i].z > z_edge) pos[i].z -= z_edge;
    
    //collisions with cubes
    
    //if(collide(pos[i], cubeVec[(int)red],50)){
    //  vel[i].x *= -2;
    //  vel[i].y *= -2;
    //  vel[i].z *= -2;
    //}
      
  }
  
  
  
  camera.Update(1.0/frameRate);

}
