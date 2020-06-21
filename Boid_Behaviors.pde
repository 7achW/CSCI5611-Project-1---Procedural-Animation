/*TO DO:
-introduce aversion to wall
-modify clustering and wandering behaviors
-land on surfaces occasionally ( pos[i].z = surface.z, vel[i] = 0)
-make vacuum interaction
-Boid spawner
-predator boid? (red, bigger, others run from it. Despawns others?)

*/

//location of whatever supporting fucntions I can dump here

//check for collsion
public boolean collide( Vec3 a, Vec3 b, float l){
  return  ( (a.x <= (b.x + l)) & (a.x >= (b.x - l)) 
          & (a.y <= (b.y + l)) & (a.y >= (b.y - l)) 
          & (a.z <= (b.z + l)) & (a.z >= (b.z - l)) );
}

public class Cubes{
  public float x, y, z, r;
  
  public Cubes(float x, float y, float z, float r){
    this.x = x;
    this.y = y;
    this.z = z;
    this.r = r;
  }
  
  //
}

public void laser(Cubes cube, float x){  //x == 1 blue atract laser, else red repel
  if(x == 1) stroke(0,0,255);
  else stroke(255,0,0);
  line(width/2,height-400, 400, cube.x,cube.y,cube.z);
  stroke(255, 255, 255);  //return color to white
}
                  
//}
