%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_lt, assert_le, assert_nn, assert_not_equal, assert_nn_le, assert_not_zero, sqrt, abs_value)
from starkware.cairo.common.math_cmp import (is_le, is_nn_le, is_not_zero)
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import (get_block_number, get_caller_address)

from src.contracts.design.constants import (
    MAX_X,
    MAX_Y,
    PLAYERS_PER_GAME,
    MAX_HEALTH,
    MAX_MOVEMENT_PER_TURN,
    MAX_ACTION_PER_TURN,
    MAX_RANGE_X_BOW,
    MAX_RANGE_Y_BOW,
    DAMAGE_BOW,
    ACTION_BOW,
    MAX_RANGE_X_PUNCH,
    MAX_RANGE_Y_PUNCH,
    DAMAGE_PUNCH,
    ACTION_PUNCH,
    MAX_GAME_DURATION,
    BUFFER,
)


//TODO: In the game functions, try to hardcode the opponents address and not leave it as a guess to the player
// even though it is handled through the front-end, you never know
// Can be handled by introducing the game_idx as validation arg.

//TODO: Forfeit player who submits a round after more than some blocks -> using Yagi

// In the same light, if the game ends and the final round lasted more than x blocks
// Could be solved with automation

// Game Structure
@storage_var
func lobby_address () -> (address: felt) {
}

@storage_var
func game_idx_counter() -> (game_idx: felt) {
}

@storage_var
func game_idx_to_status(game_idx: felt) -> (game_status: felt) {
}

@storage_var
func block_height_at_game_activation(game_idx: felt) -> (block_height: felt) {
}

@storage_var
func block_height_at_game_end(game_idx: felt) -> (block_height: felt) {
}

@storage_var
func player_address_to_game_idx(player_address: felt) -> (game_idx: felt) {
}




// Game Specific storage vars
@storage_var
func health_per_player(player_address: felt) -> (health_value: felt) {
}

@storage_var
func movement_per_player(player_address: felt) -> (movement_value: felt) {
}

@storage_var
func action_per_player(player_address: felt) -> (action_value: felt) {
}

@storage_var
func player_turn(game_idx: felt) -> (player_address: felt) {
}

@storage_var
func x_position_per_player(game_idx: felt, player_address: felt) -> (x: felt) {
}

@storage_var
func y_position_per_player(game_idx: felt, player_address: felt) -> (y: felt) {
}

@storage_var
func player_address_per_coordinates(x: felt, y: felt) -> (player_address: felt) {
}



// Temporary, for demo purposes
// TODO: Replace by permanent and more elegant solution
@storage_var
func game_idx_to_first_player(game_idx: felt) -> (first_player_address: felt) {
}
@storage_var
func game_idx_to_second_player(game_idx: felt) -> (second_player_address: felt) {
}







// Events 

// Will be picked up by the indexer
@event
func InitGameOccured(game_idx_counter: felt){
}

@event
func ActivateGameOccured(game_idx_counter: felt, block_height_at_game_activation: felt, arr_player_addresses_len: felt, arr_player_addresses: felt*, player_turn: felt) {
}

@event
func InitialPositionSetOccured(game_idx: felt, player_address: felt, x: felt, y: felt) {
}

@event
func InitPlayerOccured(game_idx: felt, player_address: felt) {
}

// Need to add regen attribute for regen actions 
// Possibly record initial move and destination move for attacks shifting players (TBC)
@event
func ActionOccured(game_idx: felt, caller: felt, player_address: felt, action: felt, damage: felt, block_height: felt, action_points_remaining: felt, caller_position_x: felt, caller_position_y: felt, player_position_x: felt, player_position_y: felt) {
}

@event
func MoveOccured(game_idx: felt, caller: felt, block_height: felt, move_points_remaining: felt, caller_initial_x: felt, caller_initial_y: felt, caller_destination_x: felt, caller_destination_y: felt ) {
}

@event
func EndRoundOccured(game_idx: felt, current_turn: felt, next_turn: felt, block_height: felt, opponent_health: felt, game_duration: felt ) {
}

@event
func EndGameOccured(game_idx: felt, winner: felt, loser: felt, end_type: felt, block_height_at_game_activation: felt, block_height_at_game_end_read: felt) {
}


// TODO: Cartridge Event emission -> Felt conversion for metadataURI
//TODO: Add image_uri to quests
@event
func quest_progress(
id: felt,
player: felt,
metadataURI_len: felt,
metadataURI: felt*
) -> () {
}



// Getters
@view
func lobby_address_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (address: felt) {

    let (lobby_addr) = lobby_address.read();

    return (lobby_addr,);
}

@view
func game_idx_counter_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
) -> (game_idx: felt) {
    let (idx) = game_idx_counter.read();

    return(idx,);
}

@view
func block_height_at_game_activation_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt) -> (block_height: felt) {

    let block_height = block_height_at_game_activation.read(game_idx);
    return(block_height);
}

@view
func block_height_at_game_end_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt) -> (block_height: felt) {

    let block_height = block_height_at_game_end.read(game_idx);
    return(block_height);
}


@view
func game_idx_to_status_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt) -> (game_status: felt) {

    let(game_status) = game_idx_to_status.read(game_idx);
    return (game_status,);   
}

@view
func player_address_to_game_idx_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    player_address: felt) -> (game_idx: felt) {
    let game_idx = player_address_to_game_idx.read(player_address);
    return(game_idx);
}

@view
func game_idx_to_first_player_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt) -> (first_player_address: felt) {
    let first_player_address = game_idx_to_first_player.read(game_idx);
    return(first_player_address);
}

@view
func game_idx_to_second_player_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt) -> (second_player_address: felt) {
    let second_player_address = game_idx_to_second_player.read(game_idx);
    return(second_player_address);
}




@view
func health_per_player_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    player_address: felt) -> (health_value: felt) {
    let health_value = health_per_player.read(player_address);
    return(health_value);
}

@view
func movement_per_player_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    player_address: felt) -> (movement_value: felt) {
    let movement_value = movement_per_player.read(player_address);
    return(movement_value);
}

@view
func action_per_player_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    player_address: felt) -> (action_value: felt) {
    let action_value = action_per_player.read(player_address);
    return(action_value);
}

@view
func player_turn_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
game_idx: felt) -> (player_address: felt) {
    let (player_address) = player_turn.read(game_idx);

    return(player_address,);
}

@view
func x_position_per_player_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt, player_address: felt) -> (x: felt) {

    let (x) = x_position_per_player.read(game_idx, player_address);
    return(x,);
}

@view
func y_position_per_player_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
   game_idx: felt, player_address: felt) -> (y: felt) {

    let  (y) = y_position_per_player.read(game_idx, player_address);
    return(y,);
}

@view
func player_address_per_coordinates_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
   x: felt, y:felt) -> (player_address: felt) {

    let  (player_address) = player_address_per_coordinates.read(x,y);
    return(player_address,);
}




// Setters
func lobby_address_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt) -> () {
    
    lobby_address.write(address);

    return ();
}

func  block_height_at_game_activation_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt, block_height: felt) -> () {

    block_height_at_game_activation.write(game_idx, block_height);
    return();
}

func  block_height_at_game_end_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt, block_height: felt) -> () {

    block_height_at_game_end.write(game_idx, block_height);
    return();
}


// TODO: for prod, remove those external tags
@external
func game_idx_to_status_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, game_status: felt) -> () {
    
    game_idx_to_status.write(game_idx, game_status);
    return ();
    }



@external
func player_address_to_game_idx_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, game_idx: felt) -> () {
    
    health_per_player.write(player_address, game_idx);
    return ();
    }

@external
func game_idx_to_first_player_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, first_player_address: felt) -> () {
    
    health_per_player.write(game_idx, first_player_address);
    return ();
    }

@external
func game_idx_to_second_player_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, second_player_address: felt) -> () {
    
    health_per_player.write(game_idx, second_player_address);
    return ();
    }





@external
func health_per_player_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, health_value: felt) -> () {
    
    health_per_player.write(player_address, health_value);
    return ();
    }

@external
func movement_per_player_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, movement_value: felt) -> () {
    
    movement_per_player.write(player_address, movement_value);
    return ();
    }

@external
func action_per_player_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, action_value: felt) -> () {
    
    action_per_player.write(player_address, action_value);
    return ();
    }

@external
func player_turn_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, player_address: felt) -> () {
    
    player_turn.write(game_idx, player_address);
    return ();
    }

@external
func x_position_per_player_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, player_address: felt, x: felt) -> () {
    
    x_position_per_player.write(game_idx, player_address, x);
    return ();
    }

@external
func y_position_per_player_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, player_address: felt, y: felt) -> () {
    
    y_position_per_player.write(game_idx, player_address, y);
    return ();
    }

@external
func player_address_per_coordinates_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    x: felt, y: felt, player_address: felt) -> () {
    
    player_address_per_coordinates.write(x, y, player_address);
    return ();
    }



// Yagi automation
// TODO: Implement
// @view
// func probe_can_end_game{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
// ) -> (bool: felt) {

//     let (block_height) = get_block_number();
//     let game_init = 
//     let game_duration =
//     if (is_le(block_height

// let bool = 1;
// return(bool,);    

// }

@view
func probe_can_init_game{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    arguments
) -> (bool: felt) {
    alloc_locals;

    let (max_idx) = game_idx_counter_read();
    let buffer_idx = max_idx - BUFFER;  
    let (buffer_status) = game_idx_to_status_read(buffer_idx);

    // if game is idle
    if (buffer_status == 1768189029) {
        return(0,);
    }

    return(1,);
}



// Functions
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) {
    
    return ();
}



@external
func set_lobby_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address) -> () {
    
    let (curr_lobby_address) = lobby_address_read();
    with_attr error_message ("Lobby Address already set") {
        assert curr_lobby_address = 0;
    }

    lobby_address_write(address);

    return();
}


func assert_caller_is_lobby{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> () {
    
    let (caller) = get_caller_address();
    let (lobby_address) = lobby_address_read();
    with_attr error_message ("Caller is not the lobby contract"){
        assert caller = lobby_address;
    }

    return();
}

// Increment game id and set game status to idle. 
// This function should be automated using yagi so that there are at least x idle games available.
// x depending on the number of games played in the last few blocks or the number of players who have joined the queue. 
@external
func init_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> () {

    // Read current game index
    let (game_idx) = game_idx_counter_read();

    // Increment counter
    game_idx_counter.write(game_idx + 1);

    // Set game status to idle (to felt: 1768189029)
    game_idx_to_status_write(game_idx + 1, 1768189029);

    // fires a new event
    InitGameOccured.emit(game_idx + 1);

    let new_game_idx = game_idx + 1;

    return();
}

@external
func set_initial_player_position{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, x: felt, y: felt
) {
    let (caller) = get_caller_address();

    with_attr error_message ("Initial position is out of bounds. Please remain in the Arena") {
    assert_le(x, MAX_X);
    assert_le(y, MAX_Y);

    assert_lt(0, x);
    assert_lt(0, y);
    }

    with_attr error_message ("Initial position has already been set") {
    let (x_position) = x_position_per_player_read(game_idx, caller);
    let (y_position) = y_position_per_player_read(game_idx, caller);
    assert x_position = 0;
    assert y_position = 0;
    }

    x_position_per_player_write(game_idx, caller, x); 
    y_position_per_player_write(game_idx, caller, y);

    InitialPositionSetOccured.emit(game_idx, caller, x, y);
    
    return();
}


@external
func init_player{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, player_address: felt) ->() {
    
    health_per_player_write(player_address, MAX_HEALTH);
    movement_per_player_write(player_address, MAX_MOVEMENT_PER_TURN);
    action_per_player_write(player_address, MAX_ACTION_PER_TURN);
    
    let (x_position) = x_position_per_player_read(game_idx, player_address);
    let (y_position) = y_position_per_player_read(game_idx, player_address);
    player_address_per_coordinates_write(player_address, x_position, y_position);

    player_address_to_game_idx_write(player_address, game_idx);

    InitPlayerOccured.emit(game_idx, player_address);
    return();
}

// TODO: Manage concurrent positionning, revert if it is the case
// Implement at a later stage - not needed for demo purposes
@external
func activate_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
     game_idx: felt ,arr_player_addresses_len: felt, arr_player_addresses: felt*) -> () {
    alloc_locals;
    
    // Assert that lobby is calling the function
    // assert_caller_is_lobby();

    // Assert that 2 players are dispatched to the game
    assert arr_player_addresses_len = PLAYERS_PER_GAME;
    
    // Assert that both players have chosen their starting position
    with_attr error_message("Game activation failed, all players must set their inital position") {
    let (a_initial) = x_position_per_player_read(game_idx, arr_player_addresses[0]);
    let (b_initial) = y_position_per_player_read(game_idx, arr_player_addresses[1]);
 
    assert_not_zero(a_initial);
    assert_not_zero(b_initial);
    }

    //Assert that the players initial positions are different - Not needed for demo 


    init_player(arr_player_addresses[0], game_idx);
    init_player(arr_player_addresses[1], game_idx);


    // set turn to player at idx 0
    let player_turn = arr_player_addresses[0];
    player_turn_write(game_idx, arr_player_addresses[0]);
    

    // Record L2 block at activation
    let (block) = get_block_number();
    block_height_at_game_activation_write(game_idx, block);


    // Event emission
    ActivateGameOccured.emit(game_idx, block, arr_player_addresses_len, arr_player_addresses, player_turn);

    return();

}



// TODO: Add Yagi automation to end the turn automatically after a certain block height
// Make it another function, this one should remain to end the turn manually
@external
func end_turn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, opponent_address: felt) {
    alloc_locals;

    let (caller) = get_caller_address();
    let (block_height) = get_block_number();

    let (game_init) = block_height_at_game_activation_read(game_idx);
    let game_duration = block_height - game_init;

    // Assert it's the caller's turn
    with_attr error_message ("This is not your turn") {
        let (player_turn) = player_turn_read(game_idx);
        assert caller = player_turn;
    }

    // Game termination checks
    // Check if the opponent has remaining health
    // "ko" to felt: 27503
    let (opponent_health) = health_per_player_read(opponent_address);
    if(is_le(opponent_health, 0) == 1) {
        EndRoundOccured.emit(game_idx, caller, opponent_address, block_height, opponent_health, game_duration);
        end_game(game_idx, caller, opponent_address, 27503);
        return();
    }

    // Check if game duration is elapsed
    // "timeout" to felt: 32767015872591220


    if(is_le(MAX_GAME_DURATION, game_duration) == 1) {
        EndRoundOccured.emit(game_idx, caller, opponent_address, block_height, opponent_health, game_duration);
        end_game(game_idx, caller, opponent_address, 32767015872591220);
        return();
    }

    // Reset Action and Movement points
    action_per_player_write(caller, MAX_ACTION_PER_TURN);
    movement_per_player_write(caller, MAX_MOVEMENT_PER_TURN);

    // Hand the round to the other player
    player_turn_write(game_idx, opponent_address);

    EndRoundOccured.emit(game_idx, caller, opponent_address, block_height, opponent_health, game_duration);

    return();
}

// TODO: Add function so that the player who has the most health point is the winner
// Right now it is the one calling the function. One could stay idle and win by timeout
// Not needed for the demo -- To implement along Yagi automation
func end_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, caller: felt, opponent_address: felt, end_type: felt) -> () {
    alloc_locals;

    let (block_height) = get_block_number();

    // Reset player variables
    x_position_per_player_write(game_idx, caller, 0);
    y_position_per_player_write(game_idx, caller, 0);

    x_position_per_player_write(game_idx, opponent_address, 0);
    y_position_per_player_write(game_idx, opponent_address, 0);

    player_address_to_game_idx_write(caller, 0);
    player_address_to_game_idx_write(opponent_address, 0);

    block_height_at_game_end_write(game_idx, block_height);

    // Set game status to "over" -> felt 1870030194
    game_idx_to_status_write(game_idx, 1870030194);

    let (game_activation) = block_height_at_game_activation_read(game_idx);

    // Event Emission
    EndGameOccured.emit(game_idx, caller, opponent_address, end_type, game_activation, block_height);
    

    // Cartridge
    // #1
    let (arr_quest_1) = alloc();
    assert arr_quest_1[0] = 'data:application/json,{"name":';
    assert arr_quest_1[1] = '"Apprentice","description":"Co';
    assert arr_quest_1[2] = 'mplete a round in the Arena"}';

    quest_progress.emit(1, caller, 3, arr_quest_1);
    quest_progress.emit(1, opponent_address, 3, arr_quest_1);

    // #2
    let (arr_quest_2) = alloc();
    assert arr_quest_2[0] = 'data:application/json,{"name":';
    assert arr_quest_2[1] = '"Winner","description":"Win a ';
    assert arr_quest_2[2] = 'round in the Arena"}';

    quest_progress.emit(2, caller, 3, arr_quest_2);

    // #3
    let (arr_quest_3) = alloc();
    assert arr_quest_3[0] = 'data:application/json,{"name":';
    assert arr_quest_3[1] = '"Defeated","description":"Lose';
    assert arr_quest_3[2] = ' a round in the Arena"}';

    quest_progress.emit(3, opponent_address, 3, arr_quest_3);

    // #4
    let (arr_quest_4) = alloc();
    assert arr_quest_4[0] = 'data:application/json,{"name":';
    assert arr_quest_4[1] = '"Practice makes perfect","desc';
    assert arr_quest_4[2] = 'ription":"Complete 10 rounds in';
    assert arr_quest_4[3] = ' the Arena", "completion": {"al';
    assert arr_quest_4[4] = 'l":[{"id":1,"count":10}]}}';

    quest_progress.emit(4, caller, 5, arr_quest_4);
    quest_progress.emit(4, opponent_address, 5, arr_quest_4);

    // #5
    let (arr_quest_5) = alloc();
    assert arr_quest_5[0] = 'data:application/json,{"name":';
    assert arr_quest_5[1] = '"Getting good","desc';
    assert arr_quest_5[2] = 'ription":"Win 10 rounds in';
    assert arr_quest_5[3] = ' the Arena", "completion": {"al';
    assert arr_quest_5[4] = 'l":[{"id":2,"count":10}]}}';

    quest_progress.emit(5, caller, 5, arr_quest_5);

    // #6
    let (arr_quest_6) = alloc();
    assert arr_quest_6[0] = 'data:application/json,{"name":';
    assert arr_quest_6[1] = '"Fall 7, Rise 8","desc';
    assert arr_quest_6[2] = 'ription":"Lose 7 rounds in';
    assert arr_quest_6[3] = ' the Arena", "completion": {"al';
    assert arr_quest_6[4] = 'l":[{"id":3,"count":7}]}}';

    quest_progress.emit(6, opponent_address, 5, arr_quest_6);

    return(); 
}


func forfeit{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt, opponent_address: felt) -> () { 
    alloc_locals;

    // Assert player is in the game
    let (caller) = get_caller_address();
    let (caller_in_game) = player_address_to_game_idx_read(caller);

    with_attr error_message ("You must be in the game to exit") {
    assert caller_in_game = game_idx;
    }

    // Call end game
    // forfeit as a felt: 28832984759363956
    end_game(game_idx, caller, opponent_address, 28832984759363956);

    return();
}


// Attacks
// TODO: Refactor separate functions into individual units, and create interface to the attack contract where they will be stored
// TODO: Add VRF from Empiric Network for random health point decrease
@external
func bow{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, opponent_address: felt, x_dest: felt, y_dest: felt) -> (
) {

    // Converted Attack Name to felt -> 6451063
    let action = 6451063;

    let (block_height) = get_block_number();

    let (caller) = get_caller_address();
    let (player_turn) = player_turn_read(game_idx);

    let (caller_position_x) = x_position_per_player_read(game_idx, caller);   
    let (caller_position_y) = y_position_per_player_read(game_idx, caller);
    
    let (opponent_position_x) = x_position_per_player_read(game_idx, opponent_address);
    let (opponent_position_y) = y_position_per_player_read(game_idx, opponent_address);


    with_attr error_message ("Wait for your turn to play") {
        assert caller = player_turn;
    }

    with_attr error_message ("Come on, don't hit yourself") {
        assert_not_equal(opponent_address, caller);
    }

    with_attr error_message ("Attack failed, try aiming at a player") {
        assert x_dest = opponent_position_x;
        assert y_dest = opponent_position_y;
    }

    with_attr error_message ("No action points left, you can either move or end the turn") {
        let (caller_action_points) = action_per_player_read(caller);
        assert_lt(0, caller_action_points);
    }

    // Assert absolute distance between player is within the range of the attack
    with_attr error_message ("Attack failed, try to get in range") {
        let x_dist = abs_value(opponent_position_x - caller_position_x);
        let y_dist = abs_value(opponent_position_y - caller_position_y);

        assert_le(x_dist, MAX_RANGE_X_BOW);
        assert_le(y_dist, MAX_RANGE_Y_BOW);
    }

    let (curr_health) = health_per_player_read(opponent_address);
    // Add ref to VRF function here
    let attack_damage = DAMAGE_BOW;
    let new_health = curr_health - attack_damage;

    health_per_player_write(opponent_address, new_health);


    let new_action_points = caller_action_points - ACTION_BOW;
    action_per_player_write(caller, new_action_points);

    
    ActionOccured.emit(game_idx, caller, opponent_address, action, attack_damage, block_height, new_action_points, caller_position_x, caller_position_y, opponent_position_x, opponent_position_y);

    return();
}

@external
func punch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, opponent_address: felt, x_dest: felt, y_dest: felt
) {

    // Converted Attack Name to felt -> 483006505832
    let action = 483006505832;

    let (block_height) = get_block_number();

    let (caller) = get_caller_address();
    let (player_turn) = player_turn_read(game_idx);

    let (caller_position_x) = x_position_per_player_read(game_idx, caller);   
    let (caller_position_y) = y_position_per_player_read(game_idx, caller);
    
    let (opponent_position_x) = x_position_per_player_read(game_idx, opponent_address);
    let (opponent_position_y) = y_position_per_player_read(game_idx, opponent_address);


    with_attr error_message ("Come on, don't hit yourself") {
        assert_not_equal(opponent_address, caller);
    }

    with_attr error_message ("Wait for your turn to play") {
        assert caller = player_turn;
    }

    with_attr error_message ("Attack failed, try aiming at an opponent") {
        assert x_dest = opponent_position_x;
        assert y_dest = opponent_position_y;
    }

    with_attr error_message ("No action points left, you can either move or end the turn") {
        let (caller_action_points) = action_per_player_read(caller);
        assert_lt(0, caller_action_points);
    }

    // Assert absolute distance between playersis within the range of the attack
    with_attr error_message ("Attack failed, try to get in range") {
        let x_dist = abs_value(opponent_position_x - caller_position_x);
        let y_dist = abs_value(opponent_position_y - caller_position_y);

        assert_le(x_dist, MAX_RANGE_X_PUNCH);
        assert_le(y_dist, MAX_RANGE_Y_PUNCH);
    }

    let (curr_health) = health_per_player_read(opponent_address);
    // Add ref to VRF function here
    let attack_damage = DAMAGE_PUNCH;
    let new_health = curr_health - attack_damage;

    health_per_player_write(opponent_address, new_health);


    let new_action_points = caller_action_points - ACTION_PUNCH;
    action_per_player_write(caller, new_action_points);

    
    ActionOccured.emit(game_idx, caller, opponent_address, action, attack_damage, block_height, new_action_points, caller_position_x, caller_position_y, opponent_position_x, opponent_position_y);


    return();
}


@external
func move{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, opponent_address: felt, x_dest: felt, y_dest: felt
) {
    let (caller) = get_caller_address();
    let (block_height) = get_block_number();

    let (caller_position_x) = x_position_per_player_read(game_idx, caller);   
    let (caller_position_y) = y_position_per_player_read(game_idx, caller);

    let (opponent_position_x) = x_position_per_player_read(game_idx, opponent_address);
    let (opponent_position_y) = y_position_per_player_read(game_idx, opponent_address);

    let move_x = abs_value(caller_position_x - x_dest);
    let move_y = abs_value(caller_position_y - y_dest);
    let move_dist = move_x + move_y;

    let opponent_dist_x = abs_value(opponent_position_x - x_dest);
    let opponent_dist_y = abs_value(opponent_position_y - y_dest);
    let opponent_dist = opponent_dist_x + opponent_dist_y;

    let (move_remaining) = movement_per_player_read(caller);

    with_attr error_message ("Wait for your turn to play") {
        let (player_turn) = player_turn_read(game_idx);
        assert caller = player_turn;
    }

    with_attr error_message ("Well tried, you cannot declare yourself as the opponent") {
        assert_not_equal(opponent_address, caller);
    }

    // Check destination is within bounds
    with_attr error_message("Destination is outside of bounds, please stay in the Arena") {
        assert_le(x_dest, MAX_X);
        assert_le(y_dest, MAX_Y);

        assert_lt(0, x_dest);
        assert_lt(0, y_dest);
    }

    // Check destination is different from origin
    with_attr error_message ("Destination is same as origin, please try another move") {
        assert_not_zero(move_dist);
    }

    // Check if destination is not opponent's position
    with_attr error_message("Destination is the opponent's position, please try another move") {
        assert_not_zero(opponent_dist);
    }

    // Check if caller still has movement points to complete the move
    with_attr error_message ("You don't have enough movement points to complete the move, please try another move") {
        assert_le(move_dist, move_remaining);
    }

    x_position_per_player_write(game_idx, caller, x_dest);
    y_position_per_player_write(game_idx, caller, y_dest);

    player_address_per_coordinates_write(x_dest, y_dest, caller);

    let points_remaining_after_move = move_remaining - move_dist;
    movement_per_player_write(caller, points_remaining_after_move);

    MoveOccured.emit(game_idx, caller, block_height, points_remaining_after_move, caller_position_x, caller_position_y, x_dest, y_dest);

    return();
}

