%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_lt, assert_le, assert_nn, assert_not_equal, assert_nn_le, sqrt)
from starkware.cairo.common.math_cmp import (is_le, is_nn_le, is_not_zero)
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import (get_block_number, get_caller_address)

from src.contracts.design.constants import (
    MAX_X,
    MAX_Y,
    MAX_DIST_PER_TICK,
)


@storage_var
func grid_x_coordinate_for_address(game_idx: felt, address: felt) -> (x: felt) {
}

@storage_var
func grid_y_coordinate_for_address(game_idx: felt, address: felt) -> (y: felt) {
}

@storage_var
func grid_address_for_coordinates(game_idx: felt, x: felt, y: felt) -> (address: felt) {
}


// Getters
//
@view
func grid_x_coordinate_for_address_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, address: felt) -> (x: felt) {
    let (x) = grid_x_coordinate_for_address.read(game_idx, address);

    return (x,);
}

@view
func grid_y_coordinate_for_address_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, address: felt) -> (y: felt) {
    let (y) = grid_y_coordinate_for_address.read(game_idx, address);

    return (y,);
}

@view
func grid_address_for_coordinates_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, x: felt, y: felt) -> (address: felt) {

    let (address) = grid_address_for_coordinates.read(game_idx, x, y);

    return (address,);
}


// Setters
//
// TODO: Test those functions. Not really sure here.
func grid_x_coordinate_for_address_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, x: felt) -> () {
    let (caller) = get_caller_address();
    grid_x_coordinate_for_address.write(game_idx, x, caller);

    return ();
}


func grid_y_coordinate_for_address_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, y: felt) -> () {
    let (caller) = get_caller_address();
    grid_y_coordinate_for_address.write(game_idx, y, caller);

    return ();
}


func grid_address_for_coordinates_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    game_idx: felt, x: felt, y: felt) -> () {

    let (caller) = get_caller_address();
    grid_address_for_coordinates.write(game_idx, x, y, caller);

    return ();
}


@external
func initial_position_on_game_start{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    x: felt, y: felt) -> () {



    return();
}

