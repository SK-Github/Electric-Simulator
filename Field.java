import java.util.*;
public class Field{
    float xpos,ypos;
    static boolean current=true;
    static boolean active=true;
    Vector myvector=new Vector(0,0);
    static ArrayList<Field> wholeField=new ArrayList<Field>();
    Field(float x,float y){
        xpos=x;ypos=y;
        wholeField.add(this);
    }
    
    public static void update(){
        if (Particle.allParticles.size()<=0){
            active=false;
        }
        else{active=true;}
        for (Field f:Field.wholeField){
            f.myvector.reset();
            for (Particle p:Particle.allParticles){
                  Vector.particleInfluence(p,f);
            }
        }
        
    }
  
}