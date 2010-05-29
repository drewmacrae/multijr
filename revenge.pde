/*
 revenge
 
 "REVENGE OF THE CHERRY TOMATOES"   
 
 Example file using the The meggy jr Simplified Library (mjSL)  v 1.4
 from the meggy jr RGB library for Arduino
 
 Note: This program requires a Meggy Jr RGB with an ATmega328P microcontroller;
 the program is too big to fit in the '168.
 
 
 Version 1.01 5-23-2010
 Andrew Macrae, drewmacrae@gmail.com
 Thanks to Chris Brookfield for version 1.0
 
 Copyright (c) 2010 Chris W. Brookfield.  All right reserved.
 http://www.evilmadscientist.com/
 
 This library is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 mERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this library.  If not, see <http://www.gnu.org/licenses/>.
 
 
 /////////////////////////////////////////////////////////////////////////
 
 
 So you squished all of the baddies in Attack of the Cherry Tomatoes.
 Well now they're back, and they've brought friends.
 Revenge of the Cherry Tomatoes features improved graphics,
 moving walls, and a few tougher tomatoes, as well as a couple of new weapons.
 
 //// CONTROLS ////
 
 Move up and down with the Up and Down buttons. Hold either button to zoom in that direction.
 Press the right button to advance quickly.
 
 WEAPONS
 Blueberry Bullets: Your basic bullet. Fire with the 'A' button. Hold it button to fire 
 automatically. (This is slower than repeated button presses, but your thumb won't be quite 
 as sore.)  You have an unlimited supply of these; use them freely.  
 
 SuperBomb: This bullet moves to the center of the screen, where it detonates, destroying 
 all tomatoes on the screen.  These use up one full ammo unit. 
 Your remaining ammuniton is displayed with the auxLEDs above the RGB matrix. 
 Use bombs wisely. Fire with the left button.
 
 MiniBomb: When this bullet is adjacent to a tomato, its proximity trigger goes off and
 it explodes, taking out everything in the 8 squares adjacent to the bullet.   
 These cost 1/4 of an ammo unit.  Fire with the B button.
 
 
 TripleShot: When you collect a powerup while your ammo meter is full, your standard 
 blueberry bullets are upgraded, now firing three bullets, one in the usual location, 
 and one on either side above and below the player. This powerup lasts for only ten 
 seconds after you obtain it, so use it while you can.
 
 Shield: This 'weapon' isn't all that helpful when you consider the cost. When you run into 
 a tomato (either head on or sideways), it will be destroyed, at the cost of one full ammo unit.
 If you run out of ammo, the shield will no longer work; instead, you will die. 
 (It can save you if you don't have time to fire off a superbomb.)
 
 
 //THE GAME FIELD//
 
 Red Tomatoes: The standard bad guy. Shoot 'em before they get past you. If you don't, 
 game over.
 
 Orange Tomatoes: Just like the red ones, only they take two hits to eliminate them. Bombs 
 eliminate them along with all other tomatoes in the blast radius.
 
 Yellow Tomatoes: They take three hits. Same deal.  Fewer of these.
 
 Walls: The boundary of the game field. These move in and out from time to time, changing 
 the width of the game field.
 When they move inward, make sure you don't crash into one head on, if you do, you die. :(
 When they move back out, there isn't anything to run into, but they can act as a sort of 
 shield for the tomatoes, as the only way to hit them when they are behind a wall 
 is with a mini or super bomb.
 
 Powerups: These flash green and blue. Run into one to gain one ammo unit. Once your ammo 
 meter is full, running into one activates the tripleshot powerup for 10 seconds.
 
 Level Up: Once you have eliminated a certain number of tomatoes in a level, you advance to 
 the next level. This is shown by a purple wave moving across the screen.
 After the wave, the walls will be eliminated, you will have a brief break from the squishy 
 onslaught,
 and your ammo will increase by one (note that this will not actvate a powerup). Soon after, 
 the walls will move onto the screen, and a new level will begin.
 The next level will be faster, and you will need to eliminate more tomatoes than the previous 
 level.
 
 Game Over: When a tomato moves past you off the screen, the screen will flash brightly, and 
 Taps will play, signifying your death. The last level you reached will be displayed in 
 binary with the auxLEDs, with the leftmost LED being the ones place.
 Press the 'A' button to start a new game.	  
 
 */

///////////////  END OF STORYTELLING, BEGIN PROGRAM BELOW //////////////////

namespace revenge
{

  // Create global variables & constants:
  struct bulletstruct // Bullet structure
  {
    byte x; // bullet x position
    byte y; // bullet y position
    byte a;  // Activation state
    byte Type; //bullet type
    byte animate; // explosion animation variable
    //  byte ammo;
    //  unsigned long timer;
    byte stage; // explosion animation stage
  };

  struct badguystruct // badguy structure
  {
    byte bgx;  // badguy x
    byte bgy; // badguy y
    byte state; //badguy active state
    byte type; // badguy type; how many hits are needed to eliminate badguy
  };

  struct powerstruct // powerup structure
  {
    byte px; // powerup x
    byte py; // powerup y
    byte c; // powerup color
    byte pa; // powerup active?
    byte pt; // powerup type; not actually used
  };

  byte SoundSequence;      // Which sound we're playing
  byte SoundSequencePosition;  // What position we're at in that sound

  //  Number of Elements in each structure, name of array:
  struct bulletstruct shot[11];
  struct badguystruct bga[20];
  struct badguystruct badshot[5];
  struct powerstruct pUp[2];

  byte xc,yc;             // Define two 8-bit unsigned variables for player position ('xc' and 'yc').  
  byte zoomup;            // activation for whether or not the player is zooming up
  byte zoomdown;          // activation for whether or not the player is zooming down
  byte upperwall[8];      // position of the upper wall; 8 units
  byte lowerwall[8];      // position of the lower wall; 8 units
  byte autoshot;          // activation for automatic fire
  byte bomba;             // debouncer
  byte bombb;             // debouncer
  byte bomby;             // y position for center of big explosion
  byte bombx;             // x position for center of big explosion
  byte j;                 // counter
  byte h;                 // counter
  byte i;                 // counter
  byte wc;                // counter for determining when to move walls
  byte nooka;             // useless
  byte action;            // is there an action happening? variable for when to display the game slate
  byte bRight;            // debouncer
  byte sparsity;         // records how many tomatoes have been placed in a given column
  byte level;             // level #
  byte points;            // counts number of tomatoes eliminated
  byte mbombx;            // x position for center of mini explosion            
  byte mbomby;            // x position for center of mini explosion  
  byte ammo;              // ammunition variable
  byte luc;               // counts number of forward movements made in the level
  byte randomizer;        // variable for randomizing level arrangement
  byte bgstop;            // stops tomatoes from being generated after level completion requirement is met
  byte powtime;           // timer for counting powerup duration
  byte theme;             // stores where in background theme we're at
  byte phase;

  unsigned long LastTime;          // long variable for millisecond counter storage
  unsigned long LastShot;          // long variable for millisecond counter storage
  unsigned long Shotmove;          // long variable for millisecond counter storage
  unsigned long Bombmove;          // long variable for millisecond counter storage
  unsigned long luptimer;          // long variable for millisecond counter storage          
  unsigned long Gamemove;          // long variable for millisecond counter storage
  unsigned long powerblink;          // long variable for millisecond counter storage
  unsigned long TimeLimit;          // long variable for millisecond counter storage
  unsigned long mbtimer;          // long variable for millisecond counter storage
  unsigned long sbtimer;          // long variable for millisecond counter storage
  unsigned long Current;          // long variable for millisecond counter storage
  unsigned long AmmoBlink;          // long variable for millisecond counter storage

#define AmmoBlinkSpeed 100      // rate of ammo display blinking
#define BlinkSpeed 100      // rate of powerup blinking
#define PreZoom  200        // delay before zooming applies
#define WaveSpeed 50        // rate of zoom, bombs, and some other stuff
#define ShotDelay 250       // delay between shots during automatic fire
#define ShotSpeed 20        // speed of normal shot

  // FOR DETERMINING LEVEL SPEED CHANGES
#define maxtime 2000 //maximum amount of time between steps
#define mintime 350 // minimum amount of time between steps
#define ritardando 1 // rate of change factor

  unsigned int gamespeed; // storage for current step speed

    // adjx and adjy, for adjacent x and y, are for detecting adjacent badguys for minibomb explosion
  char adjx[8] = {
    -1,0,1,1,1,0,-1,-1      };
  char adjy[8] = {
    1,1,1,0,-1,-1,-1,0      };

  byte dj; //death screen y var
  byte dk; //death screen x var
  byte dl; //death screen color change var
  byte dc; //death screen color var
  byte k;  // counter variable

  void gameSetup()
  {

    ClearSlate();              // Erase the screen

    SoundSequence = 1;

    xc = 0;        // Set initial cursor position to 4,4.
    yc = 4;
    //PlayerCol = 0;
    zoomup = 0;
    zoomdown = 0;
    i = 0;
    while (i < 8)
    {
      upperwall[i] = 1;
      lowerwall[i] = 1;
      i++;
    }
    autoshot = 0;
    bomba = 0;
    bombb = 0;
    bomby = yc;
    bombx = 4;
    j = 0;
    h = 0;
    wc = 0;
    nooka = 0;
    action = 1;
    bRight = 0;
    sparsity = 5;
    level = 1;
    points = 0;
    bomby = 0;
    bombx = 0;
    ammo = 12;
    luc = 8;
    randomizer = 0;
    bgstop = 0;
    powtime = 0;
    theme = 0;
    phase = 0;

    powerblink = 0;
    AmmoBlink = 0;

    SetAuxLEDs(255 >> (8 - (ammo >> 2)));    

    gamespeed = maxtime;

    Current = millis();
    Gamemove = Current;


    k = 0;
    while (k < 2)
    {
      pUp[k].px = 0;
      pUp[k].py = 0;
      pUp[k].c = 0;
      pUp[k].pa = 0;
      pUp[k].pt = 0;
      k++;
    }


    k = 0;
    while (k < 20)
    {
      bga[k].bgx = 0;
      bga[k].bgy = 0;
      bga[k].state = 0;
      bga[k].type = 0;
      k++;
    }


    k = 0;
    while (k < 11)
    {
      shot[k].x = 0;
      shot[k].y = 0;
      shot[k].a = 0;
      shot[k].Type = 0;
      shot[k].stage = 0;
      shot[k].animate = 0;    
      k++;
    }


    shot[3].Type = 1;



    shot[4].Type = 2;





  }


  void SoundUpdate( void )  // Sound Update function
  {
    unsigned int toneVal;
    unsigned int duration;

    // Update sounds:
    if (SoundSequence)   // A sound sequence is currently playing
    {

      if (MakingSound == 0)  // Existing sound has finished
      {
        if (SoundSequence == 1)  // PowerUpSound
        {
          toneVal=pgm_read_word_near(PowerUpSound+SoundSequencePosition);
          duration=pgm_read_word_near(PowerUpSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= PowerUpSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }

        if (SoundSequence == 2)  // ShotFiredSound
        {
          toneVal=pgm_read_word_near(ShotFiredSound+SoundSequencePosition);
          duration=pgm_read_word_near(ShotFiredSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= ShotFiredSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }

        if (SoundSequence == 3)  // BombFiredSound
        {
          toneVal=pgm_read_word_near(BombFiredSound+SoundSequencePosition);
          duration=pgm_read_word_near(BombFiredSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= BombFiredSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }


        if (SoundSequence == 4)  // LevelUpSound
        {
          toneVal=pgm_read_word_near(LevelUpSound+SoundSequencePosition);
          duration=pgm_read_word_near(LevelUpSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= LevelUpSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }




        if (SoundSequence == 5)  // ShotHitSound
        {
          toneVal=pgm_read_word_near(ShotHitSound+SoundSequencePosition);
          duration=pgm_read_word_near(ShotHitSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
//          Tone_Start( ShotHitSound[SoundSequencePosition], ShotHitSound[SoundSequencePosition + 1]   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= ShotHitSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        } 
        if (SoundSequence == 6)  // BombHitSound
        {
          toneVal=pgm_read_word_near(BombHitSound+SoundSequencePosition);
          duration=pgm_read_word_near(BombHitSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
//          Tone_Start( BombHitSound[SoundSequencePosition], BombHitSound[SoundSequencePosition + 1]   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= BombHitSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        } 
        if (SoundSequence == 7)  // SuperHitSound   (Superbomb explosion)
        {
          toneVal=pgm_read_word_near(SuperHitSound+SoundSequencePosition);
          duration=pgm_read_word_near(SuperHitSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
//          Tone_Start( SuperHitSound[SoundSequencePosition], SuperHitSound[SoundSequencePosition + 1]   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= SuperHitSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        } 

        if (SoundSequence == 8)  // DeathSound
        {
          toneVal=pgm_read_word_near(DeathSound+SoundSequencePosition);
          duration=pgm_read_word_near(DeathSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
//          Tone_Start( DeathSound[SoundSequencePosition], DeathSound[SoundSequencePosition + 1]   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= DeathSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }

        if (SoundSequence == 9)  // BadSound
        {
          toneVal=pgm_read_word_near(BadThingSound+SoundSequencePosition);
          duration=pgm_read_word_near(BadThingSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
//          Tone_Start( BadThingSound[SoundSequencePosition], BadThingSound[SoundSequencePosition + 1]   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= BadThingSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }

        if (SoundSequence == 10)  // AdvanceSound
        {
          toneVal=pgm_read_word_near(BadguyAdvanceSound+SoundSequencePosition);
          duration=pgm_read_word_near(BadguyAdvanceSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
//          Tone_Start( BadguyAdvanceSound[SoundSequencePosition], BadguyAdvanceSound[SoundSequencePosition + 1]   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= BadguyAdvanceSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }

        if (SoundSequence == 11)  // AdvanceSound2
        {
          toneVal=pgm_read_word_near(BadguyAdvanceSound2+SoundSequencePosition);
          duration=pgm_read_word_near(BadguyAdvanceSound2+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
//          Tone_Start( BadguyAdvanceSound2[SoundSequencePosition], BadguyAdvanceSound2[SoundSequencePosition + 1]   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= BadguyAdvanceSound2Length)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }

        if (SoundSequence == 12)  // AdvanceSound3
        {
          toneVal=pgm_read_word_near(BadguyAdvanceSound3+SoundSequencePosition);
          duration=pgm_read_word_near(BadguyAdvanceSound3+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
//          Tone_Start( BadguyAdvanceSound3[SoundSequencePosition], BadguyAdvanceSound3[SoundSequencePosition + 1]   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= BadguyAdvanceSound3Length)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }

        if (SoundSequence == 13)  // AdvanceSound4
        {
          toneVal=pgm_read_word_near(BadguyAdvanceSound4+SoundSequencePosition);
          duration=pgm_read_word_near(BadguyAdvanceSound4+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
//          Tone_Start( BadguyAdvanceSound4[SoundSequencePosition], BadguyAdvanceSound4[SoundSequencePosition + 1]   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= BadguyAdvanceSound4Length)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }

        if (SoundSequence == 14)  // Out of Ammo!
        {
          toneVal=pgm_read_word_near(NoAmmoSound+SoundSequencePosition);
          duration=pgm_read_word_near(NoAmmoSound+SoundSequencePosition+1);
          Tone_Start( toneVal, duration   );
//          Tone_Start( NoAmmoSound[SoundSequencePosition], NoAmmoSound[SoundSequencePosition + 1]   );
          SoundSequencePosition += 2;

          if  (SoundSequencePosition >= NoAmmoSoundLength)
          {
            SoundSequence = 0;
            SoundSequencePosition = 0;
          }
        }
      }

    }
  }



  void animateDeath()  // death function; includes animation
  { 

    SoundSequence = 8;
    SoundSequencePosition = 0;


    SetAuxLEDs(level);  
    
    i = 0;  
    dj = 0;
    dk = 0;
    dl = 0;
    dc = 0;
    ClearSlate();
    Gamemove = Current;
    while (i < 1)
    {

      SoundUpdate();


      //  Current = millis();
      if (dl > 4)
      {
        CheckButtonsPress();   //Check to see for buttons that have been pressed since last we checked. 
        if (Button_A)
        {
          i = 1;

          gameSetup();
        }
      }
      while (dl < 5)
      {
        if (dl == 0)
          dc = 3;
        if (dl == 1)
          dc = 7;
        if (dl == 2)
          dc = 3;
        if (dl == 3)
          dc = 10;
        if (dl == 4)
          dc = 0;

        dj = 0;
        while (dj < 8)
        {
          dk = 0;
          while (dk < 8)
          {
            SafeDrawPx(dk,dj,dc);
            dk++;
          }
          dj++;
        }
        Current = millis();
        if ((Current - Gamemove) > WaveSpeed)
        {
          Gamemove = Current;
          DisplaySlate();  
          dl++;
        }
      }
    }
  }

  void minibomb()  // mini bomb animation
  {
    action = 1;
    if (shot[3].stage< 4)
    {

      if ((Current - mbtimer) > WaveSpeed)
      {
        i = 0;
        while (i < 8)
        {


          SafeDrawPx(mbombx,mbomby,3 - shot[3].stage);      
          if (((mbombx + adjx[i]) < 8) && ((mbomby + adjy[i]) >= 0) && ((mbomby + adjy[i]) <= 7))     
            SafeDrawPx(mbombx + adjx[i],mbomby + adjy[i],3 - shot[3].stage);

          i++;
        }

        mbtimer = Current;    
        shot[3].stage++;  
      }
      DisplaySlate();
    }
    else
    {    
      shot[3].stage= 0;
      shot[3].animate = 0;
      shot[3].a = 0;
    }

  }

  void animateBomb()  // superbomb animation
  {  


    if (shot[4].stage < 12)
    {
      DisplaySlate();
      if ((Current - sbtimer) > WaveSpeed)
      {
        i = 0;
        while (i < 8)
        {
          h = 0;
          while (h < 4)
          {
            if ((shot[4].stage>= h) && (bombx + (shot[4].stage- h)*adjx[i] >= 0) && (bombx + (shot[4].stage- h)*adjx[i] < 8) && (bomby + (shot[4].stage- h)*adjy[i] >= lowerwall[bombx + (shot[4].stage-h)*adjx[i]]) && (bomby + (shot[4].stage- h)*adjy[i] < 8 - upperwall[bombx + (shot[4].stage-h)*adjx[i]]))          
              SafeDrawPx(bombx + (shot[4].stage- h)*adjx[i],bomby + (shot[4].stage- h)*adjy[i],3 - h);
            h++;  
          }
          i++;
        }

        sbtimer = Current;    
        shot[4].stage++;  
      }

    } 
    else
    {
      shot[4].stage= 0;
      shot[4].a = 0;
    }

  }

  void LevelUp()  // level up function
  {
    SetAuxLEDs(level);
    
      
    if(level+1>EEPROM.read(REVENGE)+1)
      EEPROM.write(REVENGE,level);
    
    luptimer = Current;
    SoundSequence = 4;
    SoundSequencePosition = 0;
    //  theme = 0;

    // powtime = 0;
    if (level < 255)
      level++;

    if (sparsity > 2)
      sparsity--;        // increase density of badguys
    gamespeed = ((((1+ritardando)*(maxtime - mintime))/(level + ritardando)) + mintime); // increase the game speed

    bgstop = 0;
    k = 0;
    while (k < 2)
    {
      pUp[k].pa = 0;
      k++;
    }
    points = 0;
    luc = 0;
    if (ammo < 28)
      ammo += 4;
    else
    {
      ammo = 32;
    }

    shot[0].x = 0;
    k = 0;
    while (k < 5)
    {
      shot[k].a = 0;
      shot[k].animate = 0;
      shot[k].stage = 0;
      shot[k].x = 0;
      k++;
    }
    i = 0;


    { 
      k = 0;
      while (k < 1)
      {  
        Current = millis();
        if ((Current - luptimer) > WaveSpeed)
        {
          h = 0;
          while (h<8)
          {
            if ((shot[0].x < 11) && (shot[0].x > 3))
              SafeDrawPx((shot[k].x - 3),7 - h, Dark);
            h++;
          }

          walls();  // Redraw walls


            h = 0;
          while (h < 8)
          { 


            if (7 - h == 8 - upperwall[0])
              SafeDrawPx(0,7-h,White);     
            else if (7 - h == lowerwall[0] - 1)
              SafeDrawPx(0,7-h,White);     
            else
              SafeDrawPx(0,7 - h, Dark);

            upperwall[shot[0].x] = 0;
            lowerwall[shot[0].x] = 0;     

            if (shot[0].x < 8)
              SafeDrawPx(shot[0].x,7 - h, FullOn);
            if ((shot[0].x < 9) && (shot[0].x > 0))   
              SafeDrawPx(shot[0].x - 1,7 - h, Violet);
            if ((shot[0].x < 10) && (shot[0].x > 1))
              SafeDrawPx((shot[0].x - 2),7 - h, DimViolet);      



            h++;  
          }

          if (shot[0].x < 10)
            shot[0].x++;
          else
          {
            shot[0].x = 0;
            k++;
            i = 0;         
            while (i < 20)
            {
              if ( bga[i].state > 0)
              {
                bga[i].state = 0;
                SafeDrawPx(bga[i].bgx,bga[i].bgy,0);
              }  
              i++;     
            }
          }
          DisplaySlate();
          luptimer = Current; 

        }

      }

    }
    //SetAuxLEDs(255 >> (8 - (ammo/4)));   
  }


  void walls()  // draw walls
  {

    j = 0;
    while (j < 8)
    {
      if (upperwall[j] > 0)
        SafeDrawPx(j,(8 - upperwall[j]),7);
      if (lowerwall[j] > 0)
        SafeDrawPx(j,(lowerwall[j] - 1),7);
      j++;
    }
  }

  void refreshWalls()  // erase walls
  {

    k = 0;
    while (k < 8)
    {
      SafeDrawPx(k,(8 - upperwall[k]),0);
      SafeDrawPx(k,(lowerwall[k] - 1),0);
      k++;
    }
  }

  void sub_setup()                    // run once, when the sketch starts
  {

    //MeggyJrSimpleSetup();      // Required code, line 2 of 2.

    i = 0;
    dj = 0;
    dk = 0;
    dl = 0;
    dc = 0;
    gameSetup();  // Set up gameplay:  Erase screen, initialize variables.

  }  // End setup()





  void IHitABadGuy(byte whichShot, byte whichBadGuy) 
  { 
    action = 1;

    points++;
    shot[whichShot].a = 3;

    if (bga[whichBadGuy].type > 1) 
    { 
      bga[whichBadGuy].type--;  // Turn orange to red, for example

      if ((SoundSequence != 1) && (SoundSequence != 4))  //Do not override level-up sound
      { 
        SoundSequence = 9;  // 
        SoundSequencePosition = 0; 
      }           

    }            
    else      {
      bga[whichBadGuy].state = 0;

      if ((SoundSequence != 1) && (SoundSequence != 4))  //Do not override level-up sound
      { 
        SoundSequence = 5;  // Bad-guy explosion noise
        SoundSequencePosition = 0; 
      }      

    }

    byte j = 0;  // Clear shot from the screen
    while (j < 3)
    {
      if (shot[whichShot].x - j >= 0)
        SafeDrawPx(shot[whichShot].x - j,shot[whichShot].y,0);
      if ((shot[whichShot].x - j == 0) && (shot[whichShot].y == yc))
        SafeDrawPx(shot[whichShot].x - j,shot[whichShot].y,4);        
      j++;

      //  DisplaySlate();
    }

    if (bga[whichBadGuy].state)
      SafeDrawPx(bga[whichBadGuy].bgx,bga[whichBadGuy].bgy,bga[whichBadGuy].type); 


  }




  void sub_loop()                     // run over and over again
  {
    Current = millis();  // update the current time since last update

    SoundUpdate();

    if (randomizer == 0)  // for randomizing tomato arangement
      rand();
    else
      randomizer = 0;


    walls();

    SafeDrawPx(xc,yc,Green);


    if (SoundSequence != 4)  // if we are not playing the level up music, then:
      CheckButtonsDown();   //Check to see for buttons that have been pressed since last we checked.


    if (Button_A)       // FIRE!!
    {  
      randomizer = 1;  

      if (autoshot == 1)
      {
        if ((Current - LastShot) > ShotDelay)
        {
          action = 1;

          if ((SoundSequence != 4) && (SoundSequence != 1))
          {
            SoundSequence = 2;
            SoundSequencePosition = 0;
          }

          shot[0].a = 2;
          shot[0].x = 1;
          shot[0].y = yc;

          if (powtime > 0)
          {
            if (yc-1 > lowerwall[xc] - 1)            
            {
              shot[5].a = 2;
              shot[5].x = 1;
              shot[5].y = yc-1;
            }
            if (yc+1 < 8 - upperwall[xc])
            {
              shot[5+1].a = 2;
              shot[5+1].x = 1;
              shot[5+1].y = yc+1;
            }
          }




          LastShot = Current;   
        }
      }
      else if ((Current - LastShot) > 35) // debounce
      {
        LastShot = Current;   
        autoshot = 1;

        if ((SoundSequence != 4) && (SoundSequence != 1))
        {
          SoundSequence = 2;
          SoundSequencePosition = 0;
        }

        k = 0;

        while (k < 3)
        {
          if (shot[k].a == 0)
          {
            action = 1;
            shot[k].a = 2;
            shot[k].x = 1;
            shot[k].y = yc;
            k = 3;      // Escape from while loop
          }
          //else
          k++;
        }

        if (powtime > 0)  // if we have a powerup, then:
        {
          k = 5;
          while (k < 11)
          {
            if (shot[k].a == 0)  
            {
              if (yc-1 > lowerwall[xc] - 1)  
              {
                shot[k].a = 2;
                shot[k].x = 1;
                shot[k].y = yc-1;
              }
              if (yc+1 < 8 - upperwall[xc])
              {
                shot[k+1].a = 2;
                shot[k+1].x = 1;
                shot[k+1].y = yc+1;
              }
              k = 11;  
            }
            k += 2;
          }

        }
      }
    }
    else
      autoshot = 0;

    if (Button_B)       // MINIBOMB
    {
      randomizer = 1;

      if ((bomba == 0) && (shot[3].animate == 0))
      {
        bomba = 1;
        if (ammo > 0)  
        {
          if (shot[3].a == 0)
          {
            if ((SoundSequence != 1) && (SoundSequence != 4))
            { 
              SoundSequence = 3;
              SoundSequencePosition = 0;
            }
            action = 1;
            shot[3].a = 2;
            shot[3].x = 1;
            shot[3].y = yc;
            ammo--;  


            SetAuxLEDs(255 >> (8 - (ammo/4)));    
          }     

        }
        else
        {
          SoundSequence = 14;
          SoundSequencePosition = 0;
        }  
      }

    }
    else
      bomba = 0;

    if (Button_Up)       // Move Player Up
    {    
      randomizer = 1;


      if (((Current - LastTime) > WaveSpeed) && (zoomup == 2))
      {
        action = 1;
        SafeDrawPx(xc,yc,Green);      // Write "real" color to current pixel in the game buffer.

        if (yc < (7 - upperwall[0]))
        {
          SafeDrawPx(xc,yc,Dark);
          yc++;
        }

        LastTime = Current;       
      }


      if (((Current - LastTime) > PreZoom) && (zoomup == 1))
      {
        zoomup = 2;
        LastTime = Current;
      }
      if (zoomup == 0)
      {
        action = 1;
        SafeDrawPx(xc,yc,Green);      // Write "real" color to current pixel in the game buffer.

        if (yc < (7 - upperwall[0]))
        {
          SafeDrawPx(xc,yc,Dark);
          yc++;
        }

        zoomup = 1;
        LastTime = Current;
      }
      //     Tone_Start(ToneE5, 50);

    }
    else
      zoomup = 0;

    if (Button_Down)       // move Player Up
    {    
      randomizer = 1;
      if (zoomdown == 2)
      {
        action = 1;
        if ((Current - LastTime) > WaveSpeed)
        {
          SafeDrawPx(xc,yc,Green);      // Write "real" color to current pixel in the game buffer.

          if (yc > lowerwall[0])
          {
            SafeDrawPx(xc,yc,Dark);
            yc--;
          }

          LastTime = Current;       
        }
      }
      if (((Current - LastTime) > PreZoom) && (zoomdown == 1))
      {
        zoomdown = 2;
        LastTime = Current;
      }
      if (zoomdown == 0)
      {
        action = 1;
        SafeDrawPx(xc,yc,Green);      // Write "real" color to current pixel in the game buffer.

        if (yc > lowerwall[0])
        {
          SafeDrawPx(xc,yc,Dark);
          yc--;
        }

        zoomdown = 1;
        LastTime = Current;
      }
      //     Tone_Start(ToneE5, 50);

    }
    else
      zoomdown = 0;

    if (Button_Right)       // move Forward!!!
    { 
      randomizer = 1;
      if (bRight == 0)
      {
        Gamemove = (Current - gamespeed);    
        bRight = 1;
      }
    }
    else
      bRight = 0;

    if (Button_Left)       // SUUPAA BOMB!!!
    {   
      randomizer = 1;

      // Can we set of a bomb at this moment?
      if (bombb == 0) //check debounce variable.
      {
        bombb = 1;
        if (ammo > 3)  // Check suffient ammo. 
        {

          // if (shot[3].a == 0)
          if (shot[4].a == 0)
          {
            action = 1;

            if ((SoundSequence != 1) && (SoundSequence != 4))   
            {
              SoundSequence = 3;
              SoundSequencePosition = 0;
            }

            shot[4].a = 2;  // Set off the bomb!
            shot[4].x = 1;
            shot[4].y = yc;
            bomby = yc;
            ammo -= 4;
            SetAuxLEDs(255 >> (8 - (ammo/4)));    
          }     



        }
        else
        {
          SoundSequence = 14;
          SoundSequencePosition = 0;
        }
      }
    }
    else
      bombb = 0;


    if((Current - Shotmove) > ShotSpeed)  // Move shots, check for tomato encounters
    {


      k = 0;
      while (k < 11)
      {       
        if ((shot[k].a == 2) && (shot[k].Type == 0))
        {   
          h = 0;
          while (h < 20)
          {
            if ((shot[k].x == bga[h].bgx) && (shot[k].y == bga[h].bgy) && (bga[h].state == 1))
            {  



              IHitABadGuy(k,h);  

            }
            h++;    
          }
        }
        k++; 
      }


      k = 0;
      while (k < 11)                //move the three bullets
      {
        if ((shot[k].a == 2) && (shot[k].Type == 0))
        {
          action = 1;
          if (shot[k].x < 10)
            shot[k].x++;
          else
          {
            shot[k].a = 0;
          }
        }



        k++;
      }  
      Shotmove = Current;
    }


    k = 0;
    while (k < 11)            // Draw the three bullets
    {
      if ((shot[k].a == 2) && (shot[k].Type == 0))    //a = 2 :: Bullet is active.
      {
        if (shot[k].x < 8)
          SafeDrawPx(shot[k].x, shot[k].y, White);
        if (shot[k].x < 9)
          SafeDrawPx(shot[k].x - 1, shot[k].y, Blue);
        if ((shot[k].x < 10) && (shot[k].x > 1))
          SafeDrawPx((shot[k].x - 2), shot[k].y, DimBlue);
        if ((shot[k].x < 11) && (shot[k].x > 2))
          SafeDrawPx((shot[k].x - 3), shot[k].y, Dark);

        //  DrawPx(0,shot[k].y,Dark);

      }
      k++;
    }

    if ((shot[4].a < 2) && (nooka == 1))
      nooka = 0;

    SafeDrawPx(xc,yc,Green);

    if((Current - Bombmove) > WaveSpeed)  // Manage explosions & bomb movement
    {


      k = 0;
      while (k < 11)
      {

        if (shot[k].a == 4) // Final stage of explosion-- drawing black spots!
        {
          action = 1;
          SafeDrawPx(shot[k].x,shot[k].y,0);
          shot[k].a = 0;  
        }
        // ***

        if (shot[k].a == 3) // initial stage of explosion -- bright spot
        {
          action = 1;
          SafeDrawPx(shot[k].x,shot[k].y,FullOn);
          shot[k].a = 4;  
        }




        k++;  

      }

      // Now, redraw all active bad guys, just in case we've drawn a black spot over one.

      h = 0;
      while (h < 20)
      {  
        if (bga[h].state)
          SafeDrawPx(bga[h].bgx,bga[h].bgy,bga[h].type);  

        h++;    
      }






      k = 3;
      while (k < 5)
      {
        if ((shot[k].a == 2) && (shot[k].Type == 2))
        {
          action = 1;  // Calls for screen to be redrawn
          //if (nooka == 1)
          {
            // nooka = 0;
            if ((shot[k].animate == 0) && (shot[k].x < 4))  // Still moving bomb forward!
              shot[k].x++;
          }


          if ((shot[k].x > 3) || (shot[k].y == 8 - upperwall[shot[k].x]) || (shot[k].y + 1 == lowerwall[shot[k].x]))    
          {  



            bombx = shot[k].x;
            bomby = shot[k].y;

            if (shot[k].stage == 0)
              shot[k].animate = 1;

            if (shot[k].stage == 1)
            {//shot[k].animate = 1;
              i = 0;
              while (i < 20)
              {
                if ( bga[i].state == 1)
                {
                  bga[i].state = 2;
                  //DrawPx(bga[i].bgx,bga[i].bgy,0);
                  points++;
                }
                i++;
              }
            }
            if (shot[k].stage< 2)
            {//shot[k].a = 3;
              i = 0;
              while (i < 4)
              {
                if (shot[k].x - i >= 0)
                  SafeDrawPx(shot[k].x - i,shot[k].y,0);
                if ((shot[k].x - i == 0) && (shot[k].y == yc))
                  SafeDrawPx(shot[k].x - i,shot[k].y,4);
                i++;
              }
            }


            if ((SoundSequence != 1) && (SoundSequence != 4))
            {  
              SoundSequence = 7;   // Bomb Explosion!!!
              SoundSequencePosition = 0;
            }



            animateBomb(); 

            if (shot[k].stage == 11)         
            {


              shot[k].animate = 0;
              i = 0;
              while (i < 20)
              {
                if ( bga[i].state > 0)
                {
                  bga[i].state = 0;
                  SafeDrawPx(bga[i].bgx,bga[i].bgy,0);

                }
                i++;
              }
            }     
          }
        }

        if ((shot[k].Type == 1) && (shot[k].a == 2))
        {
          action = 1;



          {

            if ((shot[k].y == lowerwall[shot[k].x] - 1) || (shot[k].y == 8 - upperwall[shot[k].x]))
            {
              if ((SoundSequence != 1) && (SoundSequence != 4))
              { 
                SoundSequence = 6;
                SoundSequencePosition = 0;
              } 

              i = 0;
              while (i < 4)
              {
                if (shot[k].x - i >= 0)
                  SafeDrawPx(shot[k].x - i,shot[k].y,0);
                if ((shot[k].x -i == 0) && (shot[k].y == yc))
                  SafeDrawPx(shot[k].x - i,shot[k].y,4);     
                i++;
              }   

              shot[k].animate = 1;
              mbombx = shot[k].x;
              mbomby = shot[k].y;
              i = 0;
              while (i < 8)
              {   
                j = 0;
                while (j < 20)
                {

                  if ((bga[j].bgx == mbombx + adjx[i]) && (bga[j].bgy == mbomby + adjy[i]) && (bga[j].state == 1))
                  {

                    bga[j].state = 0;

                    action = 1;
                    SafeDrawPx(bga[j].bgx,bga[j].bgy,0);
                    points++;


                  }
                  j++;
                }
                i++;
              }


              //     minibomb();

              points++;
              shot[k].a = 3;
              bga[h].state = 0;
              h = 0;
              while (h < 4)
              {
                if (shot[k].x - h >= 0)
                  SafeDrawPx(shot[k].x - h,shot[k].y,0);
                if ((shot[k].x - h == 0) && (shot[k].y == yc))
                  SafeDrawPx(shot[k].x - h,shot[k].y,4);
                h++;



              }
            }  



            h = 0;
            while (h < 20)
            {


              if ((shot[k].x <= bga[h].bgx + 1) && (shot[k].x >= bga[h].bgx - 1) && (shot[k].y >= bga[h].bgy - 1) && 
                (shot[k].y <= bga[h].bgy + 1) && (bga[h].state == 1))
              {
                bga[h].state = 0;
                if ((SoundSequence != 1) && (SoundSequence != 4))
                {  
                  SoundSequence = 6;
                  SoundSequencePosition = 0; 
                }
                i = 0;
                while (i < 4)
                {
                  if (shot[k].x - i >= 0)
                    SafeDrawPx(shot[k].x - i,shot[k].y,0);
                  if ((shot[k].x -i == 0) && (shot[k].y == yc))
                    SafeDrawPx(shot[k].x - i,shot[k].y,4);     
                  i++;
                }   

                shot[k].animate = 1;
                mbombx = bga[h].bgx;
                mbomby = shot[k].y;
                i = 0;
                while (i < 8)
                {   
                  j = 0;
                  while (j < 20)
                  {

                    if ((bga[j].bgx == mbombx) && (bga[j].bgy == mbomby) && (bga[j].state))    
                    {
                      bga[j].state = 0;
                      points++;
                    }                 
                    if ((bga[j].bgx == mbombx + adjx[i]) && (bga[j].bgy == mbomby + adjy[i]) && (bga[j].state == 1))    
                    {
                      bga[j].state = 0;
                      points++;
                    }
                    j++;
                  }
                  i++;
                }


                //     minibomb();

                points++;
                shot[k].a = 3;
                bga[h].state = 0;
                h = 0;
                while (h < 4)
                {
                  if (shot[k].x - h >= 0)
                    SafeDrawPx(shot[k].x - h,shot[k].y,0);
                  if ((shot[k].x - h == 0) && (shot[k].y == yc))
                    SafeDrawPx(shot[k].x - h,shot[k].y,4);
                  h++;
                  DisplaySlate();
                }
              }
              h++;    
            }
          }



          if (shot[k].x < 11)
            shot[k].x++;
          else
          {
            shot[k].a = 0;


          }
        } 



        k++;
      }
      Bombmove = Current;
    }
    k = 3;
    while (k < 5)  // Draw bomb projectiles
    {
      if ((shot[k].Type == 1) && (shot[k].a == 2))
      {
        if (shot[k].x < 8)
          SafeDrawPx(shot[k].x,shot[k].y,Yellow);
        if (shot[k].x < 9)
          SafeDrawPx((shot[k].x - 1),shot[k].y,Orange);
        if ((shot[k].x < 10) && (shot[k].x > 1))
          SafeDrawPx((shot[k].x - 2),shot[k].y,Red);
        if ((shot[k].x < 11) && (shot[k].x > 2))        
          SafeDrawPx((shot[k].x - 3),shot[k].y,DimRed);
        if ((shot[k].x < 12) && (shot[k].x > 3))
          SafeDrawPx((shot[k].x - 4),shot[k].y,Dark);

        //   DrawPx(0,shot[3].y,Dark);
        if (shot[4].stage== 0) 
          SafeDrawPx(xc,yc,Green);
      }

      if ((shot[k].Type == 2) && (shot[k].a == 2) && (shot[k].x < 4) && (shot[k].animate == 0))
      {

        SafeDrawPx(shot[k].x,shot[k].y,Yellow);

        SafeDrawPx((shot[k].x - 1),shot[k].y,Orange);

        if (shot[k].x > 1)
          SafeDrawPx((shot[k].x - 2),shot[k].y,Red);

        if (shot[k].x > 2)
          SafeDrawPx((shot[k].x - 3),shot[k].y,Dark);

      }

      if ((shot[k].Type == 1) && (shot[k].animate == 1))
      {     
        minibomb();
        if (shot[k].stage < 4)
        {      
          i = 0;
          while (i < 8)
          {   
            j = 0;
            while (j < 20)
            {


              if ((bga[j].bgx == mbombx + adjx[i]) && (bga[j].bgy == mbomby + adjy[i]) && (bga[j].state == 1))
              {
                bga[j].state = 0;
                points++;
              }
              j++;
            }
            i++;
          }
        }
      }

      k++;
    }

    k = 0;
    while (k < 2) // CHECK TO SEE IF YOU INTERACT WITH A POWERUP 
    {
      if ((pUp[k].px == 0) && (pUp[k].pa == 1) && (pUp[k].py == yc) && (pUp[k].pt == 0)/* && (ammo > 3)*/)
      { 
        SoundSequence = 1;
        SoundSequencePosition = 0;
        points++;
        if (ammo < 28)
          ammo += 4;
        else 
        {
          if (ammo == 32)
          {
            powtime = 1;
            TimeLimit = (Current + (long) 10000);  
          }
          ammo = 32;
        }
        SetAuxLEDs(255 >> (8 - (ammo >> 2)));    
        pUp[k].pa = 2;

      }

      k++;
    }

    k = 0;
    while (k < 20)  // Check to see if: a) you run into a badguy, or: b) you die
    {
      if ((bga[k].bgx == 0) && (bga[k].state == 1) && (bga[k].bgy == yc))
        if (ammo > 3)

        { 
          if ((SoundSequence != 1) && (SoundSequence != 4))
          { 
            SoundSequence = 9;
            SoundSequencePosition = 0;
          }
          points++;
          ammo -= 4;
          powtime = 0;
          bga[k].state = 0;
          SetAuxLEDs(255 >> (8 - (ammo >> 2)));    
        }
        else
          animateDeath();
      k++;
    }


    if ((Current - Gamemove) >= gamespeed)  // If it's time to move forward...
    {


      action = 1;
      if (shot[4].animate == 0)  // if superbomb is not active -- we DO NOT move the player forward during superbomb animation!
      {

        refreshWalls();
        if (luc < 255)    //Counts how many moves forward the player has made since the beginning of the level.
          luc++;



        k = 0;
        while (k < 11) // Check to see if a bad guy has walked into a (regular) bullet!
        {       


          if ((shot[k].a == 2) && (shot[k].Type == 0))
          {   
            h = 0;
            while (h < 20)
            {
              if ((shot[k].x == bga[h].bgx) && (shot[k].y == bga[h].bgy) && (bga[h].state == 1))
              {

                IHitABadGuy(k, h); // and i liked it 


              }
              h++;    
            }
          }
          k++; 
        }



        // MOVE WALLS

        k = 0;
        while (k < 7)
        {
          lowerwall[k] = lowerwall[k+1];
          upperwall[k] = upperwall[k+1];
          k++;
        }


        if (lowerwall[0] == (yc+1))
          animateDeath();
        if (7 - upperwall[0] == (yc-1))
          animateDeath();


        if (luc == 2)  // during 2nd step of game: Allow walls to show up
        {
          upperwall[7] = 1;
          lowerwall[7] = 1;
        }

        if (wc == 7) // Allow walls to move up/down every 7 steps
        { 
          if (luc > 14)  //Allow walls to move up/down only if we're at least 14 steps in.
          {
            lowerwall[7] += ((rand() % 2) - (rand() % 2));
            upperwall[7] += ((rand() % 2) - (rand() % 2));
          } 

          // Limit walls from going farther than 3 steps in, and from disapearing off the edge
          if (upperwall[7] > 3) 
            upperwall[7] = 3;
          if (lowerwall[7] > 3)
            lowerwall[7] = 3;
          if (upperwall[7] < 1)
            upperwall[7] = 1;
          if (lowerwall[7] < 1)
            lowerwall[7] = 1;  

          wc = 0;
        }
        else if (luc > 7)
        {
          if (bgstop == 0)  // If tomatoes are allowed to be added to the screen right now...
          { 
            j = 1;
            while (j < 7) // Loop over possible y positions
            { 
              if ((j > lowerwall[7]) && (j < 8 - upperwall[7]))  // make sure y position is within the constraint of the walls
              {
                if ((rand() % sparsity) == 0)// probability of placing a tomato in this location
                {          
                  k = 0;
                  while (k < 20)
                  {
                    if (bga[k].state == 0)
                    {
                      bga[k].bgx = 8;  // set it's x to 8
                      bga[k].bgy = j;
                      bga[k].state = 1;

                      bga[k].type = 1;

                      h = rand() % 20;

                      if ((h < 4) && (level > 1))
                      {
                        bga[k].type = 2;
                        if ((h == 0) && (level > 3))
                          bga[k].type = 3;
                      }

                      k = 20;
                    }
                    k++;
                  }
                }
              }
              //          sparsity = 0;   // sparsity == How many bad guys are in the column, so far. 


              j++;    
            }  
          }
          else
          {
            k = 0;
            i = 0;
            while (k < 20)
            {
              if (bga[k].state == 0)
                i++;
              k++;
            }
            k = 0;
            while (k < 2)
            {
              if (pUp[k].pa != 1)
                i++;
              k++;
            }

            if (i > 21)
              LevelUp();
          }

        }
        walls(); 



        //Draw Badguys...

        k = 0;
        while (k < 20)
        {

          if (bga[k].state == 1)   // For active bad guys...
          {
            SafeDrawPx(bga[k].bgx,bga[k].bgy,0); // Erase current bad guy positions!


            if (bga[k].bgx > 0)
              bga[k].bgx--;
            else 
              animateDeath();

            SafeDrawPx(bga[k].bgx,bga[k].bgy,bga[k].type); // Draw at new positions


          }
          k++;
        }


        if (luc > 7)
        {
          k = 0;
          while (k < 2)
          {
            if (pUp[k].pa == 0)  // see sparsity of tomatoes above; this is for the powerups
            {
              pUp[k].px = 7;
              pUp[k].py = lowerwall[7] + rand() % (8 - (upperwall[7] + lowerwall[7]));
              pUp[k].c = 4;
              pUp[k].pa = rand() % 40;
              if (pUp[k].pa > 1)
                pUp[k].pa = 0;
              h = 0;
              while (h < 20)
              {
                if ((pUp[k].pa == 1) && (bga[h].state == 1) && (bga[h].bgx == pUp[k].px) && (bga[h].bgy == pUp[k].py))
                  bga[h].state = 0;
                h++;
              }

            }
            else if (pUp[k].pa == 1)
            {
              action = 1;

              if (pUp[k].px > 0)
              {
                SafeDrawPx(pUp[k].px,pUp[k].py,0);
                pUp[k].px--;
              }
              else
                pUp[k].pa = 2;
              //if (pUp[k].px + 1 < 8)
              //DrawPx(pUp[k].px+1,pUp[k].py,0);
              SafeDrawPx(pUp[k].px,pUp[k].py,pUp[k].c);
            }

            if (pUp[k].pa == 2)
              SafeDrawPx(pUp[k].px,pUp[k].py,0);

            k++;
          }
        }
        wc++;
        action = 1;

        if (SoundSequence == 0) // If there's not a sound playing
        {   
          SoundSequence = 10 + theme;
          SoundSequencePosition = 0;

        }
        if (theme < 3)
          theme++;
        else
          theme = 0;

        Gamemove = Current;
      }
    }

    if ((Current - powerblink) > BlinkSpeed)  // Blink powerups, and, if powered up, the player
    {
      action = 1;
      /*
if (ammo - ((ammo >> 2) << 2))
       {
       if (pUp[0].c == 4)
       SetAuxLEDs(255 >> (8 - (ammo >> 2)));   
       else
       SetAuxLEDs(255 >> (7 - (ammo >> 2)));   
       }
       */

      if (powtime == 1)
      {
        //DrawPx(xc,yc,Blue);  
        powtime = 2;
      }
      else if (powtime == 2)
      {
        powtime = 1;
        //DrawPx(xc,yc,Green);
      }

      k = 0;
      while (k < 2)
      {
        if (pUp[k].pa == 1)      
          SafeDrawPx(pUp[k].px,pUp[k].py,pUp[k].c);  
        if (pUp[k].pt == 0)
        {
          if (pUp[k].c == 4)
            pUp[k].c = Blue;
          else
            pUp[k].c = 4;

        }




        k++;
      }


      powerblink = Current;
    }

    if ((Current - AmmoBlink) > AmmoBlinkSpeed)  // Blink powerups, and, if powered up, the player
    {

      if (++phase > 7)
        phase  = 0;

      if(phase & 1)
        SetAuxLEDs(255 >> (8 - (ammo >> 2)));   
      else if (((phase >> 1) + 1) <= (ammo - ((ammo >> 2) << 2)))
        SetAuxLEDs(255 >> (7 - (ammo >> 2)));   

      action = 1;
      AmmoBlink = Current;
    } // *****


    if ((Current > TimeLimit) && (powtime > 0))
      powtime = 0;

    //DrawPx(0,0,0); 

    if (action == 1)
    { 

      j = 0;
      while (j < 20)  // draw badguys
      {
        if ((bga[j].state))  // ***
          SafeDrawPx(bga[j].bgx,bga[j].bgy,bga[j].type);
        j++;
      }

      //   SafeDrawPx(pUp[0].px,pUp[0].py,pUp[0].c);  // draw powerups
      //  SafeDrawPx(pUp[1].px,pUp[1].py,pUp[1].c); 

      if (powtime < 2)  // draw player
        SafeDrawPx(xc,yc,Green);
      else
        SafeDrawPx(xc,yc,Blue);

      walls();

      action = 0;
      DisplaySlate();      // Write the updated game buffer to the screen.
    }

    if (points >= (10*level))
      bgstop = 1;



  }   // End loop()

  void splash()
  {
    for(int s=0;s<8;s++){
      SafeDrawPx(s,0,White);
      SafeDrawPx(s,7,White);
    }
    SafeDrawPx(0,3,Green);
    SafeDrawPx(2,3,DimBlue);
    SafeDrawPx(3,3,Blue);
    SafeDrawPx(4,3,White);
    //SafeDrawPx(5,3,FullOn);
    SafeDrawPx(6,4,Red);
    SafeDrawPx(7,3,Red);
    SafeDrawPx(7,6,Red);
    SafeDrawPx(7,1,Red);
    SafeDrawPx(7,5,Yellow);
    SafeDrawPx(4,1,Orange);
  }

}




