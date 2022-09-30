%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_block_number, get_caller_address

from src.contracts.design.constants import (
    YOANN
    )

// Storage Vars #################################################################

@storage_var
func queue_head_index () -> (head_idx : felt) {
}

@storage_var
func queue_tail_index () -> (tail_idx : felt) {
}

@storage_var
func address_to_queue_index (address : felt) -> (idx : felt) {
}

@storage_var
func queue_index_to_address (idx : felt) -> (address : felt) {
}

@storage_var
func event_counter () -> (val : felt) {
}

@event
func ask_to_queue_occurred (
    event_counter : felt,
    // account : felt,
    queue_idx : felt
){
}

//
// Getters
//
@view
func queue_head_index_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (head_idx: felt) {
    let (head_idx) = queue_head_index.read();

    return (head_idx,);
}

@view
func queue_tail_index_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (tail_idx: felt) {
    let (tail_idx) = queue_tail_index.read();

    return (tail_idx,);
}

@view
func address_to_queue_index_read{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(address: felt) -> (idx: felt) {
    let (idx) = address_to_queue_index.read(address);

    return (idx,);
}

@view
func queue_index_to_address_read{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(idx: felt) -> (address: felt) {
    let (address) = queue_index_to_address.read(idx);

    return (address,);
}

@view
func event_counter_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    val: felt
) {
    let (val) = event_counter.read();

    return (val,);
}


//
// Setters
//
func queue_head_index_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    head_idx: felt
) -> () {
    queue_head_index.write(head_idx);

    return ();
}

func queue_tail_index_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tail_idx: felt
) -> () {
    queue_tail_index.write(tail_idx);

    return ();
}

func address_to_queue_index_write{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(address: felt, idx: felt) -> () {
    address_to_queue_index.write(address, idx);

    return ();
}

func queue_index_to_address_write{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(idx: felt, address: felt) -> () {
    queue_index_to_address.write(idx, address);

    return ();
}

func event_counter_reset{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    ) {
    event_counter.write(0);

    return ();
}
func event_counter_increment{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> () {
    let (val) = event_counter.read();
    event_counter.write(val + 1);

    return ();
}




@constructor
func constructor {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (){

    //
    // Permission check to be implemented later

    let (event_counter) = event_counter_read ();
    event_counter_increment ();

    return();
}

// From Issac's Lobby.cairo
// Function for player to join queue
// NOTE: queue idx starts from 1; 0 is reserved for uninitialized (not in queue)
//
@external
func anyone_ask_to_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    //
    // Revert is caller is 0x0 address
    //
    let (caller) = get_caller_address();
    with_attr error_message("address 0x0 is not allowed to join queue") {
        assert_not_zero(caller);
    }

    //
    // Revert if caller index-in-queue is not zero, indicating the caller is already in the queue
    //
    let (caller_idx_in_queue) = address_to_queue_index_read(caller);
    with_attr error_message("caller index in queue != 0 => caller already in queue.") {
        assert caller_idx_in_queue = 0;
    }
    //
    // Enqueue
    //
    let (curr_tail_idx) = queue_tail_index_read();
    let new_player_idx = curr_tail_idx + 1;
    queue_tail_index_write(new_player_idx);
    address_to_queue_index_write(caller, new_player_idx);
    queue_index_to_address_write(new_player_idx, caller);

    //
    // Event emission
    //
    let (event_counter) = event_counter_read();
    event_counter_increment();
    ask_to_queue_occurred.emit(event_counter, new_player_idx);
    // ask_to_queue_occurred.emit(event_counter, caller, new_player_idx);

    return ();
}

@external
func anyone_pop_from_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // Revert if player is not already in the queue, ie. if index-in-queue is not zero.
    let (caller) = get_caller_address();
    with_attr error_message("caller is not in the queue") {
        let (idx) = address_to_queue_index_read(caller);
        assert_not_zero(idx);
    }

    // Pop player from queue.
    address_to_queue_index_write(caller, 0);

    return ();
}


// Reset queue, only callable by YOANN
@external
func reset_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (idx: felt) -> () {
    alloc_locals;

    // Permission
    let (caller) = get_caller_address();
    with_attr error_message("Admin Function: Only Admins can reset the queue") {
        assert YOANN = caller;
    }

    let (tail) = queue_tail_index.read();
    if (idx == tail) {
        return();
    }

    // reset the storage vars
    let (player_address) = queue_index_to_address_read(idx);
    queue_index_to_address_write(idx, 0);
    address_to_queue_index_write(player_address, 0);

    // recursion
    reset_queue(idx + 1);
    return ();
}


// @external
// func can_dispatch_to_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     arguments
// ) -> (
// ) {

//     let (universe_idx) = 

//     return (universeID);
// }

// @external
// func dispatch_to_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     arguments
// ) {
    
// }