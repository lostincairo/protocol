%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_lt, assert_le, assert_nn, assert_not_equal, assert_nn_le, sqrt)
from starkware.cairo.common.math_cmp import (is_le, is_nn_le, is_not_zero)
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import (get_block_number, get_caller_address)

from contracts.design.constants import (
    MAX_X,
    MAX_Y,
    MAX_DIST_PER_TICK,
)


@storage_var
func grid_x_coordinate_for_address(address: felt) -> (x: felt) {
}

@storage_var
func grid_y_coordinate_for_address(address: felt) -> (y: felt) {
}

@storage_var
func grid_address_for_coordinates(x: felt, y: felt) -> (address: felt) {
}


// Getters
//
@view
func grid_x_coordinate_for_address_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt) -> (x: felt) {
    let (x) = grid_x_coordinate_for_address.read(address);

    return (x,);
}

@view
func grid_y_coordinate_for_address_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt) -> (y: felt) {
    let (y) = grid_y_coordinate_for_address.read(address);

    return (y,);
}

@view
func grid_address_for_coordinates_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    x: felt, y: felt) -> (address: felt) {

    let (address) = grid_address_for_coordinates.read(x,y);

    return (address,);
}


// Setters
//
// TODO: Test those functions. Not really sure here.
func grid_x_coordinate_for_address_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    x: felt) -> () {
    let (caller) = get_caller_address();
    grid_x_coordinate_for_address.write(x, caller);

    return ();
}


func grid_y_coordinate_for_address_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    y: felt) -> () {
    let (caller) = get_caller_address();
    grid_y_coordinate_for_address.write(y, caller);

    return ();
}


func grid_address_for_coordinates_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    x: felt, y: felt) -> () {

    let (caller) = get_caller_address();
    grid_address_for_coordinates.write(x, y, caller);

    return ();
}



// Constructor (WIP) - Must pop
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    arguments
) {

    return();
}


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