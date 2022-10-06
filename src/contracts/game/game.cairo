%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_lt, assert_le, assert_nn, assert_not_equal, assert_nn_le, assert_not_zero, sqrt)
from starkware.cairo.common.math_cmp import (is_le, is_nn_le, is_not_zero)
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import (get_block_number, get_caller_address)

from src.contracts.game.grid import (
    grid_x_coordinate_for_address_read,
    grid_y_coordinate_for_address_read,
    grid_address_for_coordinates_read,
    grid_address_for_coordinates_write
)

from src.contracts.design.constants import (
    PLAYERS_PER_GAME,
    MAX_HEALTH,
    MAX_MOVEMENT_PER_TURN,
    MAX_ACTION_PER_TURN,
)



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
func player_turn() -> (player_address: felt) {
}

@storage_var
func x_position_per_player(player_address: felt) -> (x: felt) {
}

@storage_var
func y_position_per_player(player_address: felt) -> (y: felt) {
}

@storage_var
func player_address_per_coordinates(x: felt, y: felt) -> (player_address: felt) {
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
func InitialPositionSetOccured(player_address: felt, x: felt, y: felt) {
}

@event
func InitPlayerOccured(game_idx: felt, player_address: felt) {
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
func game_idx_to_status_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt) -> (game_status: felt) {

    let(game_status) = game_idx_to_status.read(game_idx);
    return (game_status,);   
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
) -> (player_address: felt) {
    let (player_address) = player_turn.read();

    return(player_address,);
}

@view
func x_position_per_player_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    player_address: felt) -> (x: felt) {

    let (x) = x_position_per_player.read(player_address);
    return(x,);
}

@view
func y_position_per_player_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
   player_address: felt) -> (y: felt) {

    let  (y) = y_position_per_player.read(player_address);
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

@external
func game_idx_to_status_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, game_status: felt) -> () {
    
    game_idx_to_status.write(game_idx, game_status);
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
    player_address: felt) -> () {
    
    player_turn.write(player_address);
    return ();
    }

@external
func x_position_per_player_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, x: felt) -> () {
    
    x_position_per_player.write(player_address, x);
    return ();
    }

@external
func y_position_per_player_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, y: felt) -> () {
    
    y_position_per_player.write(player_address, y);
    return ();
    }

@external
func player_address_per_coordinates_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    x: felt, y: felt, player_address: felt) -> () {
    
    player_address_per_coordinates.write(x, y, player_address);
    return ();
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
func init_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (new_game_idx: felt ) {

    // Read current game index
    let (game_idx) = game_idx_counter_read();

    // Increment counter
    game_idx_counter.write(game_idx + 1);

    // Set game status to idle (to felt: 1768189029)
    game_idx_to_status_write(game_idx + 1, 1768189029);

    // fires a new event
    InitGameOccured.emit(game_idx + 1);

    let new_game_idx = game_idx + 1;

    return (new_game_idx,);
}

// TODO: Manage same positionning, revert if it is the case
@external
func set_initial_player_position{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    x: felt, y: felt
) {
    let (player_address) = get_caller_address();
    let (x_position) = x_position_per_player_read(player_address);
    let (y_position) = y_position_per_player_read(player_address);
    assert_not_zero(x_position);
    assert_not_zero(y_position);

    x_position_per_player_write(player_address, x); 
    y_position_per_player_write(player_address, y);

    InitialPositionSetOccured.emit(player_address, x, y);
    
    return();
}

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
    let (a_initial) = x_position_per_player_read(arr_player_addresses[0]);
    let (b_initial) = y_position_per_player_read(arr_player_addresses[1]);
 
    assert_not_zero(a_initial);
    assert_not_zero(b_initial);
    }

    // TODO: Give players health, movement and attacks
    init_player(arr_player_addresses[0], game_idx);
    init_player(arr_player_addresses[1], game_idx);


    // set turn to player at idx 0
    let player_turn = arr_player_addresses[0];
    player_turn_write(arr_player_addresses[0]);
    

    // Record L2 block at activation
    let (block) = get_block_number();
    block_height_at_game_activation_write(game_idx, block);


    // Event emission
    ActivateGameOccured.emit(game_idx, block, arr_player_addresses_len, arr_player_addresses, player_turn);
    InitPlayerOccured.emit(game_idx, arr_player_addresses[0]);
    InitPlayerOccured.emit(game_idx, arr_player_addresses[1]);

    return();

}


@external
func init_player{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, game_idx: felt) ->() {
    
    health_per_player_write(player_address, MAX_HEALTH);
    movement_per_player_write(player_address, MAX_MOVEMENT_PER_TURN);
    action_per_player_write(player_address, MAX_ACTION_PER_TURN);
    

    InitPlayerOccured.emit(game_idx, player_address);
    return();
}


@external
func end_round{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    arguments
) {

    return();
}




// Attacks
@external
func bow{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, x_dest: felt, y_dest: felt) -> (
) {

    with_attr error_message ("Attack failed, try aiming at a player") {
    
    }
    return();
}

@external
func punch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, x_dest: felt, y_dest: felt
) {
    return();
}