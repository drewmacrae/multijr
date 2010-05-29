//revenge.h
//define the revenge namespace

namespace revenge
{
  void sub_setup(void);
  void sub_loop(void);
  void walls(void);
  void splash(void);

  //// DEFINE GAME SOUNDS ////


  // Shot firing sound
#define ShotFiredSoundLength 8
  PROGMEM prog_uint16_t ShotFiredSound[ShotFiredSoundLength] = { 
    ToneC6, 20, ToneG5, 10, ToneE5, 10, ToneC5, 10            };

  // Bomb firing sound
#define BombFiredSoundLength 8
  PROGMEM prog_uint16_t BombFiredSound[BombFiredSoundLength] = { 
    ToneAs5, 30, ToneF5, 30, ToneD5, 30,  ToneAs4, 30            };

  // levelup sound
#define LevelUpSoundLength 26
  PROGMEM prog_uint16_t LevelUpSound[LevelUpSoundLength] = { 
    ToneD5, 100, ToneFs5, 100, ToneA5, 100, ToneDs5, 100, 
    ToneG5, 100, ToneAs5, 100, ToneF5, 100, ToneGs5, 100, 
    ToneC6, 100, ToneG5, 100, ToneC6, 100, ToneD6, 100, 
    ToneDs6, 100             };

  // Powerup received sound
#define PowerUpSoundLength 10
  PROGMEM prog_uint16_t PowerUpSound[PowerUpSoundLength] = { 
    7648, 50, 0, 50, 5730, 50,  0, 50, 4048, 50            };

  // Sound made when a badguy is hit with a normal shot
#define ShotHitSoundLength 4
  PROGMEM prog_uint16_t ShotHitSound[ShotHitSoundLength] = {
    ToneDs7, 30, ToneAs6, 10            };

  // Sound of superbomb exploding
#define SuperHitSoundLength 200
  PROGMEM prog_uint16_t SuperHitSound[SuperHitSoundLength] = {
    51550, 6,59802, 6,52234, 6,62889, 6,41871, 6,62326, 6,
    50937, 6,44943, 6,49186, 6,52551, 6,58816, 6,63149, 6,
    55719, 6,49081, 6,54673, 6,55276, 6,61133, 6,40706, 6,
    40936, 6,46807, 6,59766, 6,42648, 6,59313, 6,50602, 6,
    61406, 6,40154, 6,43336, 6,62757, 6,40734, 6,41707, 6,
    43157, 6,54850, 6,44879, 6,57176, 6,55076, 6,54550, 6,
    58279, 6,42236, 6,43216, 6,44678, 6,48024, 6,54082, 6,
    58106, 6,45916, 6,48186, 6,47597, 6,60602, 6,43219, 6,
    55526, 6,48157, 6,48782, 6,50398, 6,59294, 6,55048, 6,
    41103, 6,60189, 6,44936, 6,48044, 6,59952, 6,57411, 6,
    54234, 6,62282, 6,48704, 6,50631, 6,46360, 6,50676, 6,
    55784, 6,41026, 6,44891, 6,52166, 6,51030, 6,57451, 6,
    57238, 6,63303, 6,60601, 6,60872, 6,50183, 6,63587, 6,
    43892, 6,62234, 6,53712, 6,54406, 6,41597, 6,51322, 6,
    56106, 6,41216, 6,57396, 6,44486, 6,54739, 6,49094, 6,
    43468, 6,50957, 6,51217, 6,51999, 6,58337, 6,41614, 6,
    48050, 6,44108, 6,45671, 6,59016, 5             };

  // Sound of minibomb exploding
#define BombHitSoundLength 100
  PROGMEM prog_uint16_t BombHitSound[BombHitSoundLength] = {
    28883, 4,31675, 4,34266, 4,33760, 4,32294, 4,31525, 4,
    26865, 4,29084, 4,24309, 4,21629, 4,18485, 4,18430, 4,
    22804, 4,18024, 4,11648, 4,11604, 4,18204, 4,12944, 4,
    16938, 4,13864, 4,6564, 4,7604, 4,7966, 4,10510, 4,13584, 4,
    5628, 4,10650, 4,11535, 4,12508, 4,12750, 4,8244, 4,7880, 4,
    6298, 4,9314, 4,9146, 4,9624, 4,5220, 4,7339, 4,9135, 4,
    6428, 4,4974, 4,3847, 4,2671, 4,2631, 4,4557, 4,4166, 4,
    3026, 4,4344, 4,3930, 4,4594, 4            };

  // Taps. This plays when you die
#define DeathSoundLength 18
  PROGMEM prog_uint16_t DeathSound[DeathSoundLength] = { 
    ToneG4, 1175, 0 , 25, ToneG4, 400, ToneC5, 2250, 
    0, 150, ToneG4, 1175, 0 , 25, ToneC5, 400, 
    ToneE5, 2250             };

  // Sound made when: a) you run into a tomato, b) you hit a tomato that takes multiple hits to kill
#define BadThingSoundLength 8
  PROGMEM prog_uint16_t BadThingSound[BadThingSoundLength] = { 
    ToneA4, 50, ToneFs4, 50, ToneDs4, 50, ToneC4,50            };

  // The sounds of the tomatoes coming closer
#define BadguyAdvanceSoundLength 2
  PROGMEM prog_uint16_t BadguyAdvanceSound[BadguyAdvanceSoundLength] = { 
    ToneB4, 60            };
#define BadguyAdvanceSound2Length 2
  PROGMEM prog_uint16_t BadguyAdvanceSound2[BadguyAdvanceSoundLength] = { 
    ToneDs5, 60            };  
#define BadguyAdvanceSound3Length 2
  PROGMEM prog_uint16_t BadguyAdvanceSound3[BadguyAdvanceSoundLength] = { 
    ToneD5, 60            };
#define BadguyAdvanceSound4Length 2
  PROGMEM prog_uint16_t BadguyAdvanceSound4[BadguyAdvanceSoundLength] = { 
    ToneF5, 60            };

  // sound when you try to fire a bomb while you don't have enough ammo
#define NoAmmoSoundLength 2
  PROGMEM prog_uint16_t NoAmmoSound[NoAmmoSoundLength] = { 
    ToneD4, 125            };


}


