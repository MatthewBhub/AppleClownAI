//mats bakker hoorcollege 6

//variable declarations:
int score=1;
float twothird = 0;
//images
PImage BGimg;
PImage headimg;
PImage leg1img;
PImage leg2img;
PImage bodyimg;
PImage head2img;
PImage appleimg1;
PImage appleimg2;
PImage appleimg3;
PImage curheadimg;
//PImage arm1img;
//PImage arm2img;

boolean wavenext = false;
boolean cycle = false;
float oldmousex= 0;
float oldjumpoffset=0;
float animgo = 0;
float curpos =0;
float curposprev=0;

int time=0;
int nextappletime=200;
int oopsresettime=0;
int jumptime=0;
float jumpoffset=0.0;
int oopscount = 0;
boolean oopsdir = false;
int activecount;


apple[] apples = new apple[10];
class apple
{
  float xpos,ypos,xspeed,yspeed,localtime;
  boolean active;
  int health = 3;
  apple(float x,float y, float xs, float ys, float lt, boolean act, int hp)
  {
    xpos = x;
    ypos = y;
    xspeed = xs;
    yspeed = ys;
    localtime = lt;
    active = act;
    health = hp;
  }
}

void setup()
{
  //setup
 size(1280,720);
 textSize(128);
 twothird= height /3*2.5;
 InitializeApples();
 //load images
 //i made them in paint because my photoshop lisence expired :^)
 headimg = loadImage("head.png");
 bodyimg = loadImage("body.png");
 leg1img = loadImage("legR.png");
 leg2img = loadImage("legL.png");
 head2img = loadImage("head2.png");
 appleimg1 = loadImage("apple1.png");
 appleimg2 = loadImage("apple2.png");
 appleimg3 = loadImage("apple3.png");
 BGimg = loadImage("BG.png");
 
 curheadimg = headimg;
 //arm1img = loadImage("armR.png");
 //arm2img = loadImage("armL.png");
 
}

void draw()
{
  //clear the screen
  background(255/2);
  image(BGimg,0,0);
 
  text(str(score), 48, 140, 0); 
  time +=1;
  //draw the character
  
    if (time>oopsresettime)
  {
    curheadimg = headimg;
  }
    else
   {
    float shakeintensity=(oopsresettime-time);
    float shakex=sin(time+50*0.86)*shakeintensity;
    float shakey=sin(time)*shakeintensity;
    translate(shakex,shakey); 
  }
  interpolate();
  if (oopscount >= 5)
    {
      jump();
    }
  jumping();
  makecharacter();
  //apples
  AppleMaker();
  JustAppleStuff();

}

void mousePressed() 
{
  jump();
}
void jump()
{
      if (jumptime < time)
  {
      int jumplen = 30;
      jumptime = time + jumplen;
  }
}
void jumping()
{
  float jumplen = 30;
  float aa = (time-jumptime)/jumplen;
  if (jumptime > time)
  {
    jumpoffset = sin(aa*3.0)*300+30;
  }
  else
  {
    jumpoffset =0;
  }
}

//deze code regelt het character
void makecharacter()
{
  
  //declaring variables :)
    float animspeed = abs(curposprev-curpos)+abs(jumpoffset-oldjumpoffset);
    oldjumpoffset=jumpoffset;
    jumpoffset -= 20;
    animgo += animspeed;
    float translx = 0;
    float transly = 0;
    float rot = sin(animgo*0.05)*0.5;
    float xpos = curpos-40;
    
    //animtion!!
    //leg2
    translx = xpos+75;
    transly =twothird+60+jumpoffset;
    
    translate(translx, transly);
    rotate(rot*-1);
    image(leg2img, -10,0);
    
    //reset transform
    rotate(rot);
    translate(translx*-1,transly*-1);
    
    translx = xpos+25;
    transly =twothird+60 + jumpoffset;
    //leg1
    translate(translx,transly);
    rotate(rot);
    image(leg1img, -10,0);
    //reset transform
    rotate(rot*-1);
    translate(translx*-1,transly*-1);
    // body and head
    
    translate( (xpos+40),twothird-25+rot*5+ jumpoffset);
    image(bodyimg, -20, 0);
    translate( (xpos+40) *-1,(twothird-25+rot*5+ jumpoffset) *-1);
    
    image(curheadimg, xpos, twothird-110+(sin(animgo*0.05 +25)*5+ jumpoffset)+(mouseY*0.03));
    
    
    oldmousex = lowestAppleX();
    curposprev = curpos;

    
    
    

    
    
    //did you know:
    //this is how the animations work in minecraft too!
}

void interpolate()
{
  float ratio = 0.1;
  curpos = ((lowestAppleX()*ratio)+(curposprev*(1-ratio)));
}
void InitializeApples()
{
  for (int i = 0; i < apples.length; i++) 
  {
    apples[i]= new apple(0,0,0,10,random(0,1000),false, 3);
  }
}

void JustAppleStuff()
{
  for (int i = 0; i < apples.length; i++) 
  {
    if (apples[i].active)
    {
    if ((apples[i].xpos > width)||(apples[i].xpos < 0))
    {
      apples[i].xspeed *= -1;
    }
      apples[i].xpos += apples[i].xspeed;
      apples[i].ypos += apples[i].yspeed;
      apples[i].yspeed += 9.8/60;
      //ellipse(apples[i].xpos,apples[i].ypos,100,100);
    
      apples[i].localtime+= apples[i].yspeed *0.01;
      
      translate(apples[i].xpos,apples[i].ypos);
      rotate(apples[i].localtime);
      if (apples[i].health == 1){image(appleimg1,-50,-50);}
      else if (apples[i].health == 2) {image(appleimg2,-50,-50);}
      else {image(appleimg3,-50,-50);}
      //text(apples[i].health,-50,50);
      
      rotate(apples[i].localtime*-1);
      translate(apples[i].xpos *-1,apples[i].ypos *-1);
      
      if(apples[i].ypos > height+50)
      {
        apples[i].active = false;
        Oops();
      }
      if ((dist(curpos+10,twothird-50+jumpoffset,apples[i].xpos,apples[i].ypos)<100)&&(apples[i].yspeed >0))
      {
        println("apple caught");
        //apples[i].active = false;
        score+=1;
        apples[i].yspeed = -10;
        apples[i].xspeed = random(-5,5);
        apples[i].health -= 1;
        if (apples[i].health <= 0)
      {
      apples[i].active=false;
      }
        oopscount = 0;
      }
    }
  }
}

void AppleMaker()
{
  if((score % 50 == 0 ))
  {
     wavenext = true;
     
  }
  if (time>nextappletime)
  {
    if(wavenext == true)
    {
     diagonalAppleFall();
    }
    else if (score % 7 == 0)
    {  
     dropApple(2);
    }
    else if(score % 12 == 0)
    {
      dropApple(5);
    }
    else
    {
      dropApple(1);
    } 
    nextappletime = time+int(random(20,200));
  }
}

void diagonalAppleFall()
{
 activecount=0;
 for (int i2 = 0; i2 < apples.length; i2++) 
 {
    if (apples[i2].active == false)
    {
      activecount ++;
    }
 }
     if (activecount == apples.length)
  {
        wavenext = false;
        for (int i2 = 0; i2 < apples.length; i2++) 
        {
          if (apples[i2].active == false)
          {
            apples[i2].active = true;
            apples[i2].xpos = width/ apples.length *i2;
            if (oopsdir == true)
            { apples[i2].ypos = -100 -(i2*100);}
            else
            {apples[i2].ypos = -apples.length*100 + (i2*100);}
            apples[i2].yspeed = 0.1;
            apples[i2].xspeed = 0;
            apples[i2].health = 3;
          }
        }
      if (oopsdir == true)
      {oopsdir = false;}
      else
      {oopsdir = true;}
    }
}
void dropApple(int ammount)
{
  int counter = 0;
  for (int i = 0; i < apples.length; i++) 
  {
      if (apples[i].active != true)
      {
        apples[i].active = true;
        apples[i].xpos = random(0,width);
        apples[i].ypos = -100 - counter *300;
        apples[i].yspeed = 20;
        apples[i].xspeed = 0;
        apples[i].health = 3;
        counter ++;
        if (counter == ammount)
      {
        break;
      }
    }
  }
}
void Oops()
{
  oopscount+=1;
  oopsresettime = time+50;
  curheadimg= head2img;
  score -=1;
}

float lowestAppleX()
{
  float appleY = 0;
  int lowestapple = 0;
    for (int i = 0; i < apples.length; i++) 
    {
      if ((apples[i].active == true)&&(apples[i].ypos < twothird-50+jumpoffset)&&(apples[i].yspeed >0))
      {
        if (apples[i].ypos > appleY)
        {
          appleY = apples[i].ypos;
          lowestapple = i;
        }
      }
    }
  if ((apples[lowestapple].ypos < twothird -300)&&(apples[lowestapple].ypos > 0)&&(apples[lowestapple].yspeed>0))
  {
    jump();
  }
  return apples[lowestapple].xpos;
}
