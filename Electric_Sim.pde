//click to create a particle. If the choose vector option is on, click again to create vector
//press "n" to make the next particle you create have a negative charge,   "p" for positive
//k to toggle between choosing amount of charge and amount of mass
//1-6 to change size and amount charge or mass of charge.   
//r to clear screen of charges
//q to pause
//b to toggle whether the screen is boxed off or not
//f to toggle whether the field is displayed
//s to toggle the actual field and reverse field(shows where negative charges will go)
// "[" decreases animation speed    "]" increases speed
//"," decreases the force exerted on each particle.  "." increases it
//u to show velocity and acceleration
//v to toggle whether or not the next particle made is still or if you can choose velocity vector
//m to toggle whether the next particle you make can move or not
//i to cycle through which particle's info to display
//a to toggle information sidebar
//d to toggle drag
//h to toggle highlight
//t to toggle trail behind particle
int newcharge=1;
int newmass=1;
int boxmode=1;
boolean trailOn=true;
int info=0;
ArrayList<Float> xtrail=new ArrayList<Float>();
ArrayList<Float> ytrail=new ArrayList<Float>();
boolean fieldon=true;
boolean canmove=true;
boolean paused=false;
boolean choosemass=false;
boolean showVelocity=true;
boolean highlightOn=true;
boolean display=true;
float newx,newy;
int controlVelocity=1;
void setup(){
  size(950,700);
  background(250);
  frameRate(60);
  Vector.dragon=false;
  //field generation
  for (int i=10;i<=Dimensions.width-10;i+=20){
     for (int j=10;j<=Dimensions.height-10;j+=20){
          new Field(float(i),float(j));
     }
  }
  //precession
  new Particle(186.7,347.1,-4,true,new Vector(4.72,7.42),3);
  new Particle(392,372,4,false,3);
  //new Particle(350,350,-1,true,new Vector(0,12),1);
  //new Particle(400,350,1,false,1);
  surface.setResizable(true);
  //set trail to be normal
  for (int i=0;i<130;i++){
    xtrail.add(Particle.allParticles.get(info).xpos); ytrail.add(Particle.allParticles.get(info).ypos);
  }
}
void draw(){
  background(255,255,255);
  //background(0,0,0);
  //show box around screen
     if (boxmode==1){
          strokeWeight(4);
          line(1,1,Dimensions.width-1,1);
          line(1,1,1,Dimensions.height-1);
          line(Dimensions.width-1,1,Dimensions.width-1,Dimensions.height-1);
          line(1,Dimensions.height-1,Dimensions.width-1,Dimensions.height-1);}
          

  strokeWeight(1);
  
  //show new particle creation
  if (controlVelocity==2){
       if (newcharge>0){
       fill(#ff0000);}
       else{fill(#0000ff);}
      ellipse(newx,newy,6*newmass,6*newmass);
      if (newcharge>0){
          stroke(#ff0000);}
          else{stroke(#0000ff);}
      line(newx,newy,mouseX,mouseY);
      float angle=(float)Vector.findAngle(newx,newy,mouseX,mouseY);
      line(mouseX,mouseY,mouseX+5*cos(angle-(5*PI/6)),mouseY+5*sin(angle-(5*PI/6)));
      line(mouseX,mouseY,mouseX+5*cos(angle+(5*PI/6)),mouseY+5*sin(angle+(5*PI/6)));
  }
  
  
  //regular unpaused run 
  if (!paused){
    //running calculations
    particleCalc();}
    //drawing field
    if(fieldon){
    drawField();}
    //highlighting selecteded particle
    if(Particle.allParticles.size()>info && highlightOn){
      noStroke();
     fill(#cc00ff);
     ellipse(Particle.allParticles.get(info).xpos,Particle.allParticles.get(info).ypos,(Particle.allParticles.get(info).mass+1)*6,(Particle.allParticles.get(info).mass+1)*6);
     }
    drawParticle();
    
    
  fill(0,0,0);
  //pause menu
  if(paused){//fill(0, 102, 153);
      textSize(20);
      //textAlign(CENTER,CENTER);
      text("Paused", Dimensions.width+10, 50);}
  
  //side info
            textSize(11);
            text("controlVelocity(v)="+controlVelocity, Dimensions.width+10, 230);
            text("sample Particle:",Dimensions.width+10, 260);
            text("Paused(q)="+paused, Dimensions.width+10, 400);
            text("Drag is: "+Vector.dragon,Dimensions.width+10,420);
            text("can move(m)="+canmove, Dimensions.width+10, 210);
            text("controlmass(k)="+choosemass, Dimensions.width+10, 120);
            text("new mass(1-6)= "+newmass,Dimensions.width+10,150);
            text("new charge(1-6)= "+newcharge,Dimensions.width+10,180);
            text("frame rate([ ]) ="+(int)frameRate,Dimensions.width+10,380);
            text("Electrical Force(, .) ="+String.format("%.2f", 2*Vector.forceDegree),Dimensions.width+10,90);
            if(boxmode==1){
               text("Box mode",Dimensions.width+10,360);
            }
            else if (boxmode==2){text("Wrap mode",Dimensions.width+10,360);} else{text("Free Mode",Dimensions.width+10,360);}
            
            //list selected particle info
            if (Particle.allParticles.size()>info){
              text("Particle Info:",Dimensions.width+10,470);
              text("Particle #"+(info+1),Dimensions.width+10,490);
              text("Charge = "+Particle.allParticles.get(info).charge,Dimensions.width+10,510);
              text("Mass = "+Particle.allParticles.get(info).mass,Dimensions.width+10,530);
              text("Velocity Vector:",Dimensions.width+10,550);
              text(String.format("%.2f",Particle.allParticles.get(info).velocity.xpos)+"i + "+ String.format("%.2f",-1*Particle.allParticles.get(info).velocity.ypos)+"j",Dimensions.width+10,570);
              text("Acceleration Vector:",Dimensions.width+10,590);
              text(String.format("%.2f",20*Particle.allParticles.get(info).accel.xpos)+"i + "+ String.format("%.2f",-20*Particle.allParticles.get(info).accel.ypos)+"j",Dimensions.width+10,610);
              //draw the selected particle
              text("Velocity Angle= "+String.format("%.2f",(180/PI)*Vector.findAngle(Particle.allParticles.get(info).velocity.xpos,-1*Particle.allParticles.get(info).velocity.ypos)),810,630);
              text("Accel Angle= "+String.format("%.2f",(180/PI)*Vector.findAngle(Particle.allParticles.get(info).accel.xpos,-1*Particle.allParticles.get(info).accel.ypos)),810,650);
              text("Position: ("+String.format("%.1f",Particle.allParticles.get(info).xpos)+","+String.format("%.1f",Dimensions.height-Particle.allParticles.get(info).ypos)+")",810,670);
              
              //draw info about the particle
              if (Particle.allParticles.get(info).charge>0){
                 fill(#ff0000);}
                 else{fill(#0000ff);}
                 ellipse(910,470,6*Particle.allParticles.get(info).mass,6*Particle.allParticles.get(info).mass);
            }
            //draw sample particle
            if (newcharge>0){
                 fill(#ff0000);}
                 else{fill(#0000ff);}
            ellipse(850,290,6*newmass,6*newmass);
            
            //draw trail  behind selected particle
            if (Particle.allParticles.size()>0 && info<Particle.allParticles.size() && trailOn){
                if(!paused){
                xtrail.add(0,Particle.allParticles.get(info).xpos);
                ytrail.add(0,Particle.allParticles.get(info).ypos);
                xtrail.remove(xtrail.size()-1);
                ytrail.remove(ytrail.size()-1);
                }
                for (int i=0;i<xtrail.size()-1;i++){
                  line(xtrail.get(i),ytrail.get(i),xtrail.get(i+1),ytrail.get(i+1));
                }
            }          
}
//end draw

public void resetTrail(){
    if (info<Particle.allParticles.size()){
      for (int i=0;i<xtrail.size();i++){
         xtrail.set(i,Particle.allParticles.get(info).xpos);
         ytrail.set(i,Particle.allParticles.get(info).ypos);
      }
    }
}

public void particleCalc(){
   for (Particle p:Particle.allParticles){
      p.update();
   }
   for (Particle p:Particle.removeList){
       Particle.allParticles.remove(p);
   }
   for (Particle p:Particle.allParticles){
      p.velocityUpdate();
   }
   for (Particle p:Particle.allParticles){
      p.posUpdate();
   }
   for (int j=0;j<Particle.allParticles.size();j++){
      Particle.allParticles.get(j).collisionUpdate(j);
   }
}



public void drawField(){
    strokeWeight(1);
    if (!Field.current){
    stroke(#147efb);}
    else{stroke(#ff0000);}
    Field.update();
    if (Field.active){
      for (Field f:Field.wholeField){
          float angle=(float)Vector.findAngle(f);
          float x2=(15*cos(  angle  )  )+f.xpos;
          float y2=(15*sin(  angle  )  )+f.ypos;
          line(f.xpos,f.ypos, x2,  y2  );
          line(x2,y2,x2+5*cos(angle-(5*PI/6)),y2+5*sin(angle-(5*PI/6)));
          line(x2,y2,x2+5*cos(angle+(5*PI/6)),y2+5*sin(angle+(5*PI/6)));
          
      }
    }
}



public void drawParticle(){
   stroke(#000000);
   for (Particle p:Particle.allParticles){
       if (p.charge>0){
       fill(#ff0000);}
       else{fill(#0000ff);}
       if(showVelocity&&p.moveable){
            //draw velocity vector
           strokeWeight(2);
           float x2=(3*p.velocity.xpos)+p.xpos;  float y2=(3*p.velocity.ypos)+p.ypos;  float angle=(float)Vector.findAngle(p.velocity.xpos,p.velocity.ypos);
           line(p.xpos,p.ypos,x2,y2);
           line(x2,y2,x2+5*cos(angle-(5*PI/6)),y2+5*sin(angle-(5*PI/6)));
           line(x2,y2,x2+5*cos(angle+(5*PI/6)),y2+5*sin(angle+(5*PI/6)));

           //draw acceleration vector
           if(p.accel.xpos!=0 && p.accel.ypos!=0){
           stroke(#008000);
           float speed=pow((pow(p.accel.xpos,2)+pow(p.accel.ypos,2)),0.5);
           float adjustedspeed=log(1+speed);
           //float adjustedspeed= 1/(1+pow((float) Math.E,-1*(speed-2)));
           float accelangle=(float)Vector.findAngle(p.accel.xpos,p.accel.ypos);
           //println(accelangle);
           x2=(400*p.accel.xpos/speed*adjustedspeed)+p.xpos;   y2=(400*p.accel.ypos/speed*adjustedspeed)+p.ypos;   //angle=(float)Vector.findAngle(p.accel.xpos,p.accel.ypos);
           if (p.accel.speed()>0.5){
               //x2=(20*p.accel.xpos)+p.xpos;;y2=(20*p.accel.ypos)+p.ypos;
               stroke(#800080);
           }
           line(p.xpos,p.ypos,x2,y2);
           line(x2,y2,x2+5*cos(accelangle-(5*PI/6)),y2+5*sin(accelangle-(5*PI/6)));
           line(x2,y2,x2+5*cos(accelangle+(5*PI/6)),y2+5*sin(accelangle+(5*PI/6)));           
           stroke(#000000);}
           strokeWeight(1);
       }
       ellipse(p.xpos,p.ypos,6*p.mass,6*p.mass);
   }
  
}
void keyPressed(){
   if (key=='p'||key=='P'){
       newcharge=abs(newcharge);
   }
   if (key=='n'||key=='N'){
       newcharge=-1*abs(newcharge);
   }
   if (key=='1'){
      if(choosemass){newmass=1;}  else{newcharge=1* (newcharge/(abs(newcharge)));}
   }
   if (key=='2'){
      if(choosemass){newmass=2;}  else{newcharge=2* (newcharge/(abs(newcharge)));}
   }
   if (key=='3'){
      if(choosemass){newmass=3;}  else{newcharge=3* (newcharge/(abs(newcharge)));}
   }
   if (key=='4'){
      if(choosemass){newmass=4;}  else{newcharge=4* (newcharge/(abs(newcharge)));}
   }
   if (key=='5'){
      if(choosemass){newmass=5;}  else{newcharge=5* (newcharge/(abs(newcharge)));}
   }
   if (key=='6'){
      if(choosemass){newmass=6;}  else{newcharge=6* (newcharge/(abs(newcharge)));}
   }
   if (key=='r'){
      Particle.allParticles.clear();
      info=0;
   }
   if (key=='q'){
     if(paused){paused=false;}
     else{paused=true;}
   }
   if (key=='s'){
       if(Field.current){Field.current=false;}
     else{Field.current=true;}
   }
   if (key=='u'){
        if(showVelocity){showVelocity=false;}
     else{showVelocity=true;}
   }
   if (key=='['){
        frameRate(frameRate-5);
        //println(frameRate);
   }
   if (key==']'){
        frameRate(frameRate+5);
        //println(frameRate);
   }
   if (key=='m'){
     if(canmove){canmove=false;controlVelocity=0;}
     else{canmove=true;controlVelocity=1;}
   }
   if (key=='i'){
     if(info>=Particle.allParticles.size()-1){info=0;}
     else{info++;}
     resetTrail();
   }
   if (key=='v'){
       if(controlVelocity!=0){controlVelocity=0;}
     else{controlVelocity=1;}
     //print(controlVelocity);
   }
   if (key=='b'){
     if(boxmode==2){boxmode=0;}
     else{boxmode++;}     Particle.box=boxmode;
   }
   if(key=='.'){
     Vector.forceDegree+=0.1;
     //println(Vector.forceDegree);
   }
   if(key==','){
     Vector.forceDegree-=0.1;
     //println(Vector.forceDegree);
   }
   if (key=='f'){
     if(fieldon){fieldon=false;}
     else{fieldon=true;}
   }
   if (key=='k'){
     if(choosemass){choosemass=false;}
     else{choosemass=true;}
   }
   if(key=='a'){
     if(display){display=false;surface.setSize(Dimensions.width,Dimensions.height);}
     else{display=true;surface.setSize(Dimensions.infowidth,Dimensions.height);}
   }
   if(key=='d'){
      if(Vector.dragon){Vector.dragon=false;}  else{Vector.dragon=true;}
   }
   if(key=='h'){
     if(highlightOn){highlightOn=false;}  else{highlightOn=true;}
   }
   if(key=='t'){
      if(trailOn){trailOn=false; resetTrail();}  else{trailOn=true;}
   }
   if (keyCode==UP){
       for (Particle p:Particle.allParticles){
           p.ypos-=30;
           if (p.ypos<0){
             p.ypos+=height;
           }
       }
   }
   if (keyCode==DOWN){
       for (Particle p:Particle.allParticles){
           p.ypos+=30;
           if (p.ypos>height){
             p.ypos-=height;
           }
       }
   }
   if (keyCode==RIGHT){
       for (Particle p:Particle.allParticles){
           p.xpos+=30;
           if (p.xpos>Dimensions.width){
             p.xpos-=Dimensions.width;
           }
       }
   }
   if (keyCode==LEFT){
       for (Particle p:Particle.allParticles){
           p.xpos-=30;
           if (p.xpos<0){
             p.xpos+=Dimensions.width;
           }
       }
   }
   
   if (keyCode==BACKSPACE){
     if(controlVelocity==2){
         controlVelocity=1;
     }
     else{
       if (info<Particle.allParticles.size()){
           Particle.allParticles.remove(info);
           if(info==Particle.allParticles.size()){info--;}
       }
     }
     if(info<0){info=0;}
     resetTrail();
   }
   
}
void mouseClicked()
  {
     if (controlVelocity==1){
        newx=mouseX;newy=mouseY; controlVelocity++;
        controlVelocity=2;
     }
     else if (controlVelocity==2){
         new Particle(newx,newy,newcharge,canmove,new Vector((mouseX-newx)/7,(mouseY-newy)/7),newmass);
         controlVelocity=1;
         info=Particle.allParticles.size()-1;
         resetTrail();
     }
     if (controlVelocity==0){
         new Particle(mouseX,mouseY,newcharge,canmove,newmass);
         info=Particle.allParticles.size()-1;
         resetTrail();
     }
  }
  