%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_lt, assert_le, assert_nn, assert_not_equal, assert_nn_le, sqrt)
from starkware.cairo.common.math_cmp import (is_le, is_nn_le, is_not_zero)
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import (get_block_number, get_caller_address)

from src.contracts.design.constants import (
    MAX_DIST_PER_TICK,
    MAX_X,
    MAX_Y,
)

from src.contracts.game.grid import (
    grid_x_coordinate_for_address_read,
    grid_y_coordinate_for_address_read,
    grid_address_for_coordinates_read,
    grid_address_for_coordinates_write
)

// Checker for grid movement
func assert_move_is_valid {syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt, dest_x: felt, dest_y: felt) -> () {
    
    let curr_x =  grid_x_coordinate_for_address_read(address);
    let curr_y =  grid_y_coordinate_for_address_read(address);

    // Assert that destination is within grid limits
    assert_nn_le(dest_x, MAX_X); 
    assert_nn_le(dest_y, MAX_Y); 

    // Assert that movement is within current range
    let dist = sqrt( (dest_x - curr_x) * (dest_x - curr_x) + (dest_y - curr_y) * (dest_y - curr_y) );
    assert_le(dist,  MAX_DIST_PER_TICK);

    // Assert that no other player is located at the destination coordinates
    let player_at_dest_coordinates = grid_address_for_coordinates_read(dest_x, dest_y);
    assert_not_equal(player_at_dest_coordinates, 0);


    // Update state with new coordinates
    grid_address_for_coordinates_write(dest_x, dest_y); 


    return();
}