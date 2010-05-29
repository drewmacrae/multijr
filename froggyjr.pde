/*
 froggyjr
  
 Version 1.32 5-23-2010
 Andrew Macrae, drewmacrae@gmail.com
 Thanks to Chris Brookfield for version 1.31
 
 Froggy Jr: a game for Meggy Jr RGB
 Version 1.31 - 1/11/2009      http://www.evilmadscientist.com/
 Copyright (c) 2009 Chris Brookfield.  All right reserved.
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this library.  If not, see <http://www.gnu.org/licenses/>.
 	 
 */

namespace froggyjr
{
  byte lives;
  byte die; 
  byte getBad;
  byte k;
  unsigned int moveLogOne;
  unsigned int moveLogTwo;
  unsigned int moveTurtles;
  unsigned int moveTrucks;
  unsigned int moveCars;
  byte xpos;
  byte ypos;
  unsigned long lasttime; 
  byte pause;
  byte cars;
  byte trucks;
  byte logOne;
  byte logTwo;
  byte turtles;
  byte winSpots;
  byte holdWinSpots;
  byte submerge;
  byte blink;
  byte permBlink;
  unsigned int blinkCt;
  unsigned int submergeCt;
  byte speed;
  byte m;
  byte score;

  void  hopnoise(void){
    Tone_Start( ToneA6, 20);
  }



  void HappyFrog(void)
  {
    SetAuxLEDs(score);
    
      
    if(score+1>EEPROM.read(FROGGYJR)+1)
      EEPROM.write(FROGGYJR,score);
    
    byte i = 0;  
    unsigned int freqs[5] = { 
      7648,0,5730, 0,4048        };

    while (i < 5)
    {
      Tone_Start(freqs[i], 50); 
      while (MakingSound)   {
      }     
      i++;
    }
    
    SetAuxLEDs((255 >> k) << k);
  }



  void DieNoise(void)
  {

    Tone_Start(ToneB4, 100); 
    while (MakingSound)
    {
    }//Tone_Update(); 

    Tone_Start(0, 100); 
    while (MakingSound)
    {
    }//Tone_Update(); 

    Tone_Start(ToneB2, 300); 
    while (MakingSound)
    {
    }//Tone_Update(); 

  }


  void DieScreen(void)   // Wait in the dark
  {

    unsigned long TempTime;
    byte i = 0;

    while (i < 8)
    {

      TempTime = millis();
      ClearSlate();
      DrawPx(xpos ,ypos, Green);    // draw player
      DisplaySlate();
      while (millis() - TempTime < 100)
      {
        ;
        ;
      }

      TempTime = millis();
      ClearSlate();
      DrawPx(xpos ,ypos, Red);    // draw player
      DisplaySlate();
      while (millis() - TempTime < 100)
      { 
      }

      i++;
    }


    TempTime = millis();
    ClearSlate();
    DrawPx(xpos ,ypos, DimRed);    // draw player
    DisplaySlate();
    while (millis() - TempTime < 500)
    { 
    }

    TempTime = millis();
    ClearSlate(); 
    DisplaySlate();
    while (millis() - TempTime < 500)
    { 
    }

  }



  void sub_setup()                    // run once, when the sketch starts
  {

    // MeggyJrSimpleSetup();      // Required code, line 2 of 2.

    //  Tone_Update(); 



    score = 0;
    k = 0;
    moveTurtles = 0;
    moveTrucks = 0;
    moveCars = 0;
    xpos = 0;
    ypos = 0;
    lasttime = millis(); 
    cars = 0;
    trucks = 0;
    turtles = 0;
    logOne = 0;
    logTwo = 0;
    getBad = Dark;
    die = 0;  
    pause = 0;
    winSpots = 0; 
    holdWinSpots = 0;
    submerge = 0;
    blink = 0;
    permBlink = 0;
    blinkCt = 0;
    submergeCt = 0;
    speed = 0;
    m = 0;


    //splashscreen();

    HappyFrog();

    lives = 2;
    SetAuxLEDs(192);




  }  // End setup()





  void sub_loop()                     // run over and over again
  {   

    unsigned long TempTime;

    unsigned int temp1,temp2;
    byte i;
    byte j;
    int delayTemp;

    //  Tone_Update(); 
    CheckButtonsPress();

    if (Button_B)
      if (die == 1)
      {
        die = 0;
        xpos = 0;
        ypos = 0;

        lives = 2;
        SetAuxLEDs(192);

      }

    if (Button_A)
      if (die == 1)
      {
        die = 0;
        lives = 2;
        SetAuxLEDs(192);

        xpos = 0;
        ypos = 0;
      }


    if (Button_Up)      // up button
      if (ypos < 7)
      {
        ypos++;
        hopnoise();
      }

    if (Button_Down)  // down button
        if (ypos > 0)
      {
        ypos--; 
        hopnoise();
      }

    if (Button_Left)  // left button
      if (xpos > 0)
      { 
        xpos--;
        hopnoise();
      }
    if (Button_Right)  // right button
      if (xpos < 7)
      { 
        xpos++;
        hopnoise();
      }

    TempTime = millis();

    delayTemp = 125;//250;


    if (die == 0)
    {
      if  ((TempTime - lasttime) > 75) //redraw screen every 75 ms
      {

        ClearSlate();

        DrawPx(7 ,7, DimBlue);    
        DrawPx(5 ,7, DimBlue);    
        DrawPx(3 ,7, DimBlue);    
        DrawPx(1 ,7, DimBlue);    


        k = 0;
        while (k < 8)
        {
          DrawPx(k,4,Orange);
          DrawPx(k,5,CustomColor0);     // Turtles   IMPORTANT: CHANGE TO CUSTOM COLOR!!!!
          DrawPx(k,6,Orange);
          k++;
        }




        //CARS

        if (cars < 2)
        {
          DrawPx(0+cars,1,Red);
          DrawPx(3+cars,1,Red);
          DrawPx(6+cars,1,Red);
        }
        if (cars == 2)
        {
          DrawPx(0+cars,1,Red);
          DrawPx(3+cars,1,Red);
        }
        if (cars == 3)
          cars = 0;


        //TRUCKS

        if (trucks < 3)
        {
          DrawPx(2-trucks,2,Violet);
          DrawPx(3-trucks,2,Violet);
          DrawPx(6-trucks,2,Violet);
          DrawPx(7-trucks,2,Violet);
        }
        if (trucks == 3)
        {
          DrawPx(3-trucks,2,Violet);
          DrawPx(6-trucks,2,Violet);
          DrawPx(7-trucks,2,Violet);
          DrawPx(7,2,Violet);
        }

        if (trucks == 4)

          trucks = 0;


        // TURTLES

        if (turtles < 3)
        {
          DrawPx(2-turtles,5,DimBlue);
          DrawPx(3-turtles,5,DimBlue);
          DrawPx(6-turtles,5,DimBlue);
          DrawPx(7-turtles,5,DimBlue);
        }
        if (turtles == 3)
        {
          DrawPx(3-turtles,5,DimBlue);
          DrawPx(6-turtles,5,DimBlue);
          DrawPx(7-turtles,5,DimBlue);
          DrawPx(7,5,DimBlue);
        }

        if (turtles == 4)

          turtles = 0;

        // LOG ONE
        if (logOne < 3)
        {

          DrawPx(2+logOne,4,DimBlue);
          DrawPx(3+logOne,4,DimBlue);
          DrawPx(4+logOne,4,DimBlue);
          DrawPx(5+logOne,4,DimBlue);

        }
        if (logOne == 3)
        {
          DrawPx(2+logOne,4,DimBlue);
          DrawPx(3+logOne,4,DimBlue);
          DrawPx(4+logOne,4,DimBlue);
          DrawPx(0,4,DimBlue);
        }

        if (logOne == 4)
        {
          DrawPx(2+logOne,4,DimBlue);
          DrawPx(3+logOne,4,DimBlue);
          DrawPx(1,4,DimBlue);
          DrawPx(0,4,DimBlue);
        }

        if (logOne == 5)
        {
          DrawPx(2+logOne,4,DimBlue);
          DrawPx(2,4,DimBlue);
          DrawPx(1,4,DimBlue);
          DrawPx(0,4,DimBlue);
        }

        if (logOne == 6)
        {

          DrawPx(3,4,DimBlue);
          DrawPx(2,4,DimBlue);
          DrawPx(1,4,DimBlue);
          DrawPx(0,4,DimBlue);
        }

        if (logOne == 7)
        {
          DrawPx(4,4,DimBlue);
          DrawPx(3,4,DimBlue);
          DrawPx(2,4,DimBlue);
          DrawPx(1,4,DimBlue);

        }

        if (logOne == 8)
        {
          logOne = 0;
        }

        // LOG TWO
        if (logTwo < 2)
        {

          DrawPx(2+logTwo,6,DimBlue);
          DrawPx(3+logTwo,6,DimBlue);
          DrawPx(4+logTwo,6,DimBlue);
          DrawPx(5+logTwo,6,DimBlue);
          DrawPx(6+logTwo,6,DimBlue);
        }
        if (logTwo == 2)
        {
          DrawPx(2+logTwo,6,DimBlue);
          DrawPx(3+logTwo,6,DimBlue);
          DrawPx(4+logTwo,6,DimBlue);
          DrawPx(5+logTwo,6,DimBlue);
          DrawPx(0,6,DimBlue);
        }

        if (logTwo == 3)
        {
          DrawPx(2+logTwo,6,DimBlue);
          DrawPx(3+logTwo,6,DimBlue);
          DrawPx(4+logTwo,6,DimBlue);
          DrawPx(1,6,DimBlue);
          DrawPx(0,6,DimBlue);
        }

        if (logTwo == 4)
        {
          DrawPx(2+logTwo,6,DimBlue);
          DrawPx(3+logTwo,6,DimBlue);
          DrawPx(2,6,DimBlue);
          DrawPx(1,6,DimBlue);
          DrawPx(0,6,DimBlue);
        }

        if (logTwo == 5)
        {
          DrawPx(2+logTwo,6,DimBlue);
          DrawPx(3,6,DimBlue);
          DrawPx(2,6,DimBlue);
          DrawPx(1,6,DimBlue);
          DrawPx(0,6,DimBlue);
        }

        if (logTwo == 6)
        {
          DrawPx(4,6,DimBlue);
          DrawPx(3,6,DimBlue);
          DrawPx(2,6,DimBlue);
          DrawPx(1,6,DimBlue);
          DrawPx(0,6,DimBlue);
        }

        if (logTwo == 7)
        {
          DrawPx(4,6,DimBlue);
          DrawPx(3,6,DimBlue);
          DrawPx(2,6,DimBlue);
          DrawPx(1,6,DimBlue);
          DrawPx(5,6,DimBlue);
        }

        if (logTwo == 8)
        {
          logTwo = 0;
        }



        if (ypos == 7)
        {

          if (xpos == 0)
            if ((winSpots & 1) == 0) 
            { 
              winSpots += 1;
            }


          if (xpos == 2)
            if ((winSpots & 2) == 0) 
            { 
              winSpots += 2;
            }

          if (xpos == 4)
            if ((winSpots & 4) == 0) 
            { 
              winSpots += 4;
            }

          if (xpos == 6)
            if ((winSpots & 8) == 0) 
            {
              winSpots += 8;
            }


        }


        if ((holdWinSpots & 1) == 0)
          if (winSpots & 1)
          {
            DrawPx(0,7,DimRed);
            xpos = 0;
            ypos = 0;
            winSpots -= 1;
            holdWinSpots += 1;
            score++;
            HappyFrog();
          }

        if ((holdWinSpots & 2) == 0)
          if (winSpots & 2)
          {
            DrawPx(2,7,DimRed);
            xpos = 0;
            ypos = 0;
            winSpots -= 2;
            holdWinSpots += 2;
            score++;
            HappyFrog();
          }

        if ((holdWinSpots & 4) == 0)
          if (winSpots & 4)
          {
            DrawPx(4,7,DimRed);
            xpos = 0;
            ypos = 0;
            winSpots -= 4;
            holdWinSpots += 4;
            score++;
            HappyFrog();
          }

        if ((holdWinSpots & 8) == 0)
          if (winSpots & 8)
          {
            DrawPx(6,7,DimRed);
            xpos = 0;
            ypos = 0;
            winSpots -= 8;
            holdWinSpots += 8;
            score++;
            HappyFrog();
          }

        if (holdWinSpots & 1)
          DrawPx(0,7,Green);

        if (holdWinSpots & 2)
          DrawPx(2,7,Green);

        if (holdWinSpots & 4)
          DrawPx(4,7,Green);

        if (holdWinSpots & 8)
          DrawPx(6,7,Green);

        if (holdWinSpots == 15)    // Levelup!
        {
          holdWinSpots = 0;
          speed++;
          HappyFrog();
          HappyFrog();
          HappyFrog();


          if (lives < 8)
          {
            lives++;
            k = 8 - lives;
            SetAuxLEDs((255 >> k) << k);
          }

        }


        if (permBlink == 1)
        {  
          k = 0;
          while (k < 8)
          {
            DrawPx(k,5,DimBlue);      //Turtles
            k++;

          }
        }


        getBad = ReadPx(xpos,ypos);

        if (getBad == Red)
          die = 1;

        if (getBad == Violet)
          die = 1;

        if (getBad == DimBlue)
          die = 1;

        if (getBad == DimRed)
          die = 1;

        if (getBad == Green)
          die = 1;


        if (die == 1)
        {

          ClearSlate();



          if (lives > 0)
          {

            DieNoise();
            DieScreen();

            lives--;      
            die = 0;
            xpos = 0;
            ypos = 0;

            k = 8 - lives;
            SetAuxLEDs((255 >> k) << k);

          }  
          else
          {
            holdWinSpots = 0;
            SetAuxLEDs(0);
            speed = 0;
            DieNoise();
            DieNoise();
            DieNoise(); 
            DieScreen();
          }


        }



        if (blink == 1)
        {

          EditColor(CustomColor0,3,5,0);  
        }

        if (blink == 3)
          EditColor(CustomColor0,1,1,0);

        if (blink == 2)
          EditColor(CustomColor0,2,2,0);

        if (blink == 0)
          if (permBlink == 0)
            EditColor(CustomColor0,7,10,0);
        //EditColor(CustomColor0,0,0,0);


        /*
      if (blink == 1)
         if (blinkCt == 1)
         {  
         k = 0;
         while (k < 8)
         {
         DrawPx(k,5,DimBlue);    // Turtles
         k++;
         
         }
         }
         */
        for(int i = 0;i<=7;i++)
        {
          DrawPx(i ,0, DimGreen);    // draw sidewalk
          DrawPx(i ,3, DimGreen);    // draw sidewalk  
        }
        
        DrawPx(xpos ,ypos, Green);    // draw player

        DisplaySlate();
        moveLogOne++;
        moveLogTwo++;
        moveCars++;
        moveTurtles++;
        moveTrucks++;
        submergeCt++;



        if (submerge == 0)
        {
          blink = 0;
          permBlink = 0;
        }

        if (submerge == 1)
          blink = 1;      

        if (submerge == 2)
          blink = 2;

        if (submerge == 3)
          blink = 3;

        if (submerge == 4)
          permBlink = 1;

        if (submerge == 5)
        {
          permBlink = 0;
          blink = 1;
        }

      }
    }
    else  // end display loop
    {
      ClearSlate();
      DrawPx(xpos,ypos,DimRed);


      if (ypos == 0)
      {
        die = 0;
        lives = 2;
        SetAuxLEDs(192); 
      }

      DisplaySlate();

    }




    if (speed < 5)
      temp1 = 800*(5 - speed);
    else
      temp1 = 400;



    if (moveCars >= temp1)
    {
      cars++;
      moveCars = 0;

      if (submerge < 6)
        submerge++;
      else
        submerge = 0;
    }


    if (speed < 5)
      temp1 = 1420*(5 - speed);
    else
      temp1 = 710;



    if (moveTrucks >= temp1)
    {
      trucks++;
      moveTrucks = 0;
    }

    if (speed < 5)
      temp1 = 1600*(5 - speed);
    else
      temp1 = 800;




    if (moveTurtles >= temp1)
    {
      if (ypos == 5)
        if (xpos > 0)
          xpos--;  

      turtles++;
      moveTurtles = 0;
    }

    if (speed < 5)
      temp1 = 1842*(5 - speed);
    else
      temp1 = 921;



    if (moveLogOne >= temp1)
    {
      if (ypos == 4)
        if (xpos < 7)
          xpos++;  

      logOne++;
      moveLogOne = 0;
    }

    if (speed < 5)
      temp1 = 948*(5 - speed);
    else
      temp1 = 474;


    if (moveLogTwo >= temp1)
    {

      if (ypos == 6)
        if (xpos < 7)
          xpos++;  


      logTwo++;
      moveLogTwo = 0;
    }
  }
  
  void splash()
  {
    for(int s=0;s<=7;s++)//draw solid rows
    {
      DrawPx(s,6,DimBlue);//water
      DrawPx(s,5,DimBlue);//water
      DrawPx(s,4,DimBlue);//water
      DrawPx(s,3,DimGreen);//shoulder
      DrawPx(s,0,DimGreen);//shoulder
    }
    
    for(int s=0;s<=7;s+=2)//draw the targets
    {
      SafeDrawPx(s,7,DimBlue);
    }
    
    for(int s=0;s<=7;s+=4)//draw the targets
    {
      SafeDrawPx(s,2,Violet);
      SafeDrawPx(s+1,2,Violet);
    }
    
    for(int s=0;s<=7;s+=3)//draw the targets
    {
      SafeDrawPx(s,1,Red);
    }
    
    for(int s=0;s<=3;s++)//draw logs
    {
      DrawPx(s,6,Orange);
      DrawPx((s+6)%8,4,Orange);
    }
    
    DrawPx(2,5,Yellow);
    DrawPx(3,5,Yellow);
    DrawPx(7,5,Yellow);
    
    DrawPx(4,0,Green);//draw frog
  }
}

