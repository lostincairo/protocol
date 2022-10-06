%lang starknet

// Admin
const YOANN = 0x06E7060BE8b0633bb974C682984e646e1f0c634325E91f59d9830858fb4C3180;

// Grid and movement

const MAX_X = 16;
const MAX_Y = 16;

const MAX_DIST_PER_TICK = 3;

// Game

const PLAYERS_PER_GAME = 2; 
const MAX_CONCURRENT_GAMES = 50;
const MAX_MOVEMENT_PER_TURN = 5;
const MAX_ACTION_PER_TURN = 2;
const MAX_HEALTH = 100;
const MAX_GAME_DURATION = 20;


// Attacks

// Bow
const MAX_RANGE_X_BOW = 5;
const MAX_RANGE_Y_BOW = 5;
const DAMAGE_BOW = 12;
const ACTION_BOW = 1;

// Punch
const MAX_RANGE_X_PUNCH = 2;
const MAX_RANGE_Y_PUNCH = 2;
const DAMAGE_PUNCH = 36;
const ACTION_PUNCH = 1;
