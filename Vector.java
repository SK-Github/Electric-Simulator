import java.lang.Math;
public class Vector{
  float xpos,ypos,angle;
  static boolean dragon=false;
  static double forceDegree=0.5;
  Vector(float x,float y){
     xpos=x;ypos=y;
  }
  public void add(Vector v){
      this.xpos+=v.xpos;
      this.ypos+=v.ypos;
  }
  static public Vector merge(Particle p1, Particle p2){
      return(new Vector((   (   (p1.velocity.xpos*p1.mass)+(p2.velocity.xpos*p2.mass)  )/(p1.mass+p2.mass) ),(   (   (p1.velocity.ypos*p1.mass)+(p2.velocity.ypos*p2.mass)  )/(p1.mass+p2.mass) )));
  }
  static public void particleInfluence(Particle p1, Particle p2){
       double angle=Vector.findAngle(p2.xpos-p1.xpos,p2.ypos-p1.ypos);
       double magnitude=Vector.calculateMagnitude(p1,p2);
       if (magnitude>10){
          magnitude=10;
       }
       p1.accel.add(new Vector((float)(magnitude*Math.cos(angle)),(float)(magnitude*Math.sin(angle))));
       p1.velocity.add(new Vector((float)(magnitude*Math.cos(angle)),(float)(magnitude*Math.sin(angle))));
  }
  static public void particleInfluence(Particle p,Field f){
       double angle=Vector.findAngle(p.xpos-f.xpos,p.ypos-f.ypos);
       double magnitude=Vector.calculateMagnitude(p,f);
       if (Field.current){
       f.myvector.add(new Vector((float)(-1*magnitude*Math.cos(angle)),(float)(-1*magnitude*Math.sin(angle)))); }
       else{f.myvector.add(new Vector((float)(magnitude*Math.cos(angle)),(float)(magnitude*Math.sin(angle))));}
  }
  public void slow(float i){
      this.xpos=this.xpos*i/this.speed();
      this.ypos=this.ypos*i/this.speed();
  }
  public void drag(float i){
      if(dragon){
      this.xpos=this.xpos/i;
      this.ypos=this.ypos/i;}
      /*if(this.speed()<0.33){
         this.reset();
      }*/
  }
  public float speed(){
    return((float)Math.pow((this.xpos*this.xpos)+(this.ypos+this.ypos),0.5));
  }
  static public double findAngle(float x,float y){
     return (Math.atan2(y,x));
  }
  static public double findAngle(Field f){
      return(Vector.findAngle(f.myvector.xpos,f.myvector.ypos));
  }
  static public double findAngle(float x1,float y1,float x2,float y2){
      return(Math.atan2(y2-y1,x2-x1));
  }
  static public double distance(Particle p,Field f){
      return(Math.pow((float)((p.xpos-f.xpos)*(p.xpos-f.xpos))+(float)((p.ypos-f.ypos)*(p.ypos-f.ypos)),2));
  }
  static public double distance(Particle p1,Particle p2){
      return(Math.pow((float)(1*(p2.xpos-p1.xpos)*(p2.xpos-p1.xpos))+(float)((p2.ypos-p1.ypos)*(p2.ypos-p1.ypos)),0.5));
  }
  static public double calculateMagnitude(Particle p, Field f){
      return(p.charge/(Math.pow(Vector.distance(p,f),2)));
  }
  static public double calculateMagnitude(Particle p1, Particle p2){
      //System.out.println((-2*p1.charge*p2.charge*Math.pow(10,18))/(Math.pow(Vector.distance(p1,p2),2)));
      return((-forceDegree*p1.charge*p2.charge*Math.pow(10,4))/(Math.abs(p1.mass)*Math.pow(Vector.distance(p1,p2),2)));
  }
  public String toString(){
      return("x: "+this.xpos+"   y: "+this.ypos);
  }
  public void reset(){
    this.xpos=0;this.ypos=0;
  }
}