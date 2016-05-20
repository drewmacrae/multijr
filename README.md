# multijr
Automatically exported from code.google.com/p/multijr

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
