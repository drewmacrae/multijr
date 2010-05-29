/*
 multiGame.pde 
 
 Version 0.1  5-22-2010
 Andrew Macrae  drewmacrae@gmail.com
 Special thanks to the producers of the included games.
 
 This is a sketch that allows you to play multiple games on your MeggyJr. The games are provided
 for the most part without modification. Some changes were made to shrink the games to fit on 
 the Atmega328. This sketch uses too much ROM and too much RAM to run on the 168, though the 
 sketch's RAM usage could certianly be improved.

 I reccomend placing a soldertail socket if you choose to upgrade your controller. If you do, 
 you will need to cut a slot into the handles to make it fit together with the added height.
 
 The five games available are:
 
 1. FroggyJr
 2. Revenge of the Cherry Tomatoes
 3. MeggyBrite
 4. MeggySays
 5. Fireman
 
 Game Buttons:
 Button A - Starts a game after initializing values
 Button B - Starts a game without initializing values
 Up Button or Down Button - Cycles through game options
 Up, Down, Button A and Button B - Hold all four buttons to exit a game
 
 Aux LEDs - Display high score for the selected game in binary. Use the EEPROM clear sketch
 to reset high scores.
 
 This library is free software: you can redistribute it and/or modify
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

#include <avr/pgmspace.h>   //we use program memory to store sounds
#include <avr/sleep.h>

#include <MeggyJrSimple.h>
#include <EEPROM.h>         //we use the EEPROM to save high scores
#include "revenge.h"        
#include "froggyjr.h"
#include "meggybrite.h"
#include "meggysays.h"
#include "fireman.h"

#define FROGGYJR   0 //menu options
#define REVENGE    1
#define MEGGYBRITE 2
#define MEGGYSAYS  3
#define FIREMAN    4

#define GAMECOUNT  5

#define NONE       0xFF

#define IDLECOUNT   5000  //cycles to advance through the menu
#define TIMEOUT    50000//cycles to timeout

byte gameType = NONE; //initialize the gametype so no game is in progress

byte select;

byte pButton_A; //peek at the button's state
byte pButton_B;
byte pButton_Up;
byte pButton_Down;
byte pButton_Left;
byte pButton_Right;

unsigned int idle;

void setup()
{
  // Setup buttons
  MeggyJrSimpleSetup();
  idle = 0;
}

void Demo()
{
  //display menu selection and the high score
  ClearSlate();
  
  SetAuxLEDs(EEPROM.read(select));
  switch (select)
  {
  case FROGGYJR:
    froggyjr::splash();
    break;

  case REVENGE:
    revenge::splash();
    break;
    
  case MEGGYBRITE:
    meggybrite::splash();
    break;
    
  case MEGGYSAYS:
    meggysays::splash();
    break;
   
  case FIREMAN:
    fireman::splash();
    break;
  }
  
  DisplaySlate();
}

void loop()
{
  
  //maintain the menus or run the games
  PeekButtonsDown();

  if(pButton_A&&pButton_B&&pButton_Up&&pButton_Down)
  {
    gameType = NONE;
    CheckButtonsDown();
  }

  switch (gameType)
  {
  case FROGGYJR:
    froggyjr::sub_loop();
    break;

  case REVENGE:
    revenge::sub_loop();
    break;
    
  case MEGGYBRITE:
    meggybrite::sub_loop();
    break;
    
  case MEGGYSAYS:
    meggysays::sub_loop();
    break;
    
  case FIREMAN:
    fireman::sub_loop();
    break;
  
  case NONE:
    display_intro();
    break;
  }
}

void setup_game()
{
  //initialize the games
  gameType = select;
  randomSeed(millis()); // Gives a pretty good random value
  
  splashscreen();
  
  switch (gameType)
  {
  case FROGGYJR:
    froggyjr::sub_setup();
    break;
  case REVENGE:
    revenge::sub_setup();
    break;
  case MEGGYBRITE:
    meggybrite::sub_setup();
    break;
  case MEGGYSAYS:
    meggysays::sub_setup();
    break;
  case FIREMAN:
    fireman::sub_setup();
    break;
  }
}

void display_intro()
{
  idle++;
  
  //menu
  CheckButtonsPress();//figure out which button has been pressed?

  //SetAuxLEDs(select);//indicate selected game.
  
  Demo();//display icon.  
  
  if(idle%IDLECOUNT == 0)
  {
    select=(select+1)%GAMECOUNT;//select next item
  }
  
  if(idle>=TIMEOUT)
  {
    ClearSlate();//turn off the screen
    DisplaySlate();
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);//power off the arduino
    sleep_enable();
    sleep_mode();
  }
  
  if (Button_Up) {
    select=(select+1)%GAMECOUNT;//select next item
    Tone_Start(ToneC3,20);
    idle = 0;
  }

  else if (Button_Down) 
  {
    select=(select+(GAMECOUNT-1))%GAMECOUNT;//select previous item
    Tone_Start(ToneE3,20);
    idle = 0;
  }
  
  //sound disabled by holding down a button on startup

  else if (Button_A) {
    setup_game();//start properly
    idle = 0;
  }
  
  else if (Button_B) {
    gameType = select;//start without init
    idle = 0;
  }
}

void PeekButtonsDown()//look at the buttons without updating previous values
{ 
  byte i = Meg.GetButtons(); 

  pButton_B  = (i & 1);      
  pButton_A = (i & 2);     
  pButton_Up = (i & 4);
  pButton_Down = (i & 8);
  pButton_Left = (i & 16);
  pButton_Right = (i & 32); 
}

void splashscreen(void){
    /* Show-off splash screen:  Not required, and no effect on game play.
     
     Note: this function uses the SetPxClr routine to display arbitray colors; this is
     part of the MeggyJr Arduino library, but is not one of the simple routines.  Everything
     else in this program uses the simple library.
     
     */
    uint8_t i, j,k, phase;
    uint8_t rgb[3];

    byte TurtleColor;

    unsigned long ms = millis();

    phase = 0;
    k = 0;
    while (k < 4)
    {
      i = 0;
      while (i < 8)
      {
        j = 0;
        while (j < 8)
        { 

          if (phase)
          {
            rgb[0] =2*j;
            rgb[1] =2*i;
            rgb[2] =0;

          }
          else
          {
            rgb[0] =2*i;
            rgb[1] =0;
            rgb[2] =j;
          }

          while (( millis() - ms) < 7) 
            Meg.SetPxClr(i,j,rgb);
          ms = millis() ;

          j++;
        }
        i++;
      }


      if (phase == 0)
        phase = 1;
      else
        phase = 0;
      k++;
    }
  }
