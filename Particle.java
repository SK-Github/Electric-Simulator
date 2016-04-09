import java.util.*;
public class Particle{
    float xpos,ypos,charge;
    float mass;
    boolean moveable=true;
    static int box=1;
    int num;
    Vector accel=new Vector(0,0);
    Vector velocity=new Vector(0,0);
    static ArrayList<Particle> allParticles=new ArrayList<Particle>();
    static ArrayList<Particle> removeList=new ArrayList<Particle>();
    static ArrayList<Particle> saveList=new ArrayList<Particle>();
    Particle(float x,float y,float c,boolean b,float m){
        xpos=x;ypos=y;charge=c;mass=m;
        allParticles.add(this);
        num=allParticles.indexOf(this);
        moveable=b;
    }
    Particle(float x,float y,float c,boolean b, Vector v,float m){
        velocity=v;  moveable=b; mass=m;
        xpos=x;ypos=y;charge=c;
        allParticles.add(this);
    }
    public void collision(Particle p){
       //System.out.println(Vector.distance(this,p));
       if (Vector.distance(this,p)<30){
           // if opposite charges
           if(charge/p.charge <0){
             //add charges and mass and velocities. remove the colliding particle. remove this particle if its new charge is 0.
               this.charge=this.charge+p.charge;
               this.mass=this.mass+p.mass;
               if (!this.moveable || !p.moveable){
                   this.moveable=false;
               }
               this.velocity=Vector.merge(this,p);
               removeList.add(p);
               if(this.charge==0){
                  removeList.add(this);
               }
           }
           else{  this.velocity.reset();
           p.velocity.reset();
           }
       }
    }
    public void velocityUpdate(){
    if (moveable){
       accel.reset();
       velocity.drag((float)1.002);
       num=allParticles.indexOf(this);
       for (int i=0;i<allParticles.size();i++){
           if(i!=num){
                Vector.particleInfluence(this,allParticles.get(i));
           }
       }
    }
    }
    public void posUpdate(){
      if(moveable){
             this.xpos+=velocity.xpos;
             this.ypos+=velocity.ypos;}
      //box effect
      if(box==1){
           if(xpos>Dimensions.width){
             xpos=Dimensions.width; velocity.xpos=-velocity.xpos;
           }
           if(xpos<0){
             xpos=0; velocity.xpos=-velocity.xpos;
           }
           if(ypos>Dimensions.height){
             ypos=Dimensions.height; velocity.ypos=-velocity.ypos;
           }
           if(ypos<0){
             ypos=0; velocity.ypos=-velocity.ypos;
           }               
      }
      //wraping effect
      if(box==2){
           if(xpos>Dimensions.width){
             xpos=0;
           }
           if(xpos<0){
             xpos=Dimensions.width;
           }
           if(ypos>Dimensions.height){
             ypos=0;
           }
           if(ypos<0){
             ypos=Dimensions.height;
           }         
      }
    }
    public void collisionUpdate(int j){
      for (int i=j;i<allParticles.size();i++){
           if(i!=num)
            {collision(allParticles.get(i));}    
      }
    }
    public void update(){
       if (this.xpos>Dimensions.width||this.xpos<0||this.ypos>Dimensions.height||this.ypos<0){
           removeList.add(this);
       }
    }
}