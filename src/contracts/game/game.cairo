%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_lt, assert_le, assert_nn, assert_not_equal, assert_nn_le, sqrt)
from starkware.cairo.common.math_cmp import (is_le, is_nn_le, is_not_zero)
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import (get_block_number, get_caller_address)

from src.contracts.game.grid import (
    grid_x_coordinate_for_address_read,
    grid_y_coordinate_for_address_read,
    grid_address_for_coordinates_read,
    grid_address_for_coordinates_write
)

@storage_var
func game_idx_counter() -> (game_idx: felt) {
}


// Each game id is mapped to a status (idle, ongoing, over)
@storage_var
func game_idx_to_status(game_idx: felt) -> (game_status: felt) {
}

// Will be picked up by the indexer
@event
func init_game_occured(
    game_idx_counter: felt
){
}


// Getters
@view
func game_idx_to_status_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    game_idx: felt) -> (game_status: felt) {

    let(game_status) = game_idx_to_status.read(game_idx);
    return (game_status);   
}

// Setters
func game_idx_to_status_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, game_status: felt) -> () {
    
    game_idx_to_status.write(game_idx, game_status);
    return ();
    }



@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    arguments
) {
    
    return ();
}


// Increment game id and set game status to idle. 
// This function should be automated using yagi so that there are at least x idle games available.
// x depending on the number of games played in the last few blocks or the number of players who have joined the queue. 
@external
func init_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player1: felt, player2: felt) -> (game_idx: felt, ) {

    // Read current game index
    let (game_idx) = game_idx_counter.read() + 1;
    // Increment counter
    game_idx_counter.write(game_idx);

    // Set game status to idle (to felt: 1768189029)
    game_idx_to_status_write(game_idx, 1768189029);

    // fires a new event
    init_game_occured.emit(game_idx);

    return ();
}