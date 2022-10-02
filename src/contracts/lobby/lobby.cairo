%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_block_number, get_caller_address

from src.contracts.design.constants import (
    YOANN
    PLAYERS_PER_GAME
    )

from src.contracts.game.game import (
    game_idx_to_status,
    game_idx_counter,
    activate_game,
)

// Storage Vars #################################################################

@storage_var
func lobby_address () -> (address: felt) {
}

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
    account : felt,
    queue_idx : felt
){
}

//
// Getters
//
@view
func lobby_address_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (address: felt) {
    let (lobby_address) = lobby_address.read();

    return (lobby_address,);
}


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
func lobby_address_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (address: felt) {
    let (lobby_address) = lobby_address.write();

    return (lobby_address,);
}

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
    ask_to_queue_occurred.emit(event_counter, caller, new_player_idx);

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


@external
func find_idle_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    idx: felt) -> (has_idle_game: felt, idle_game_idx: felt
) {
    let last_game_idx = game_idx_counter.read();
    if (idx == last_game_idx) {
        return (0, 0);
    }
    
    let (game_idx) = idx + 1;
    let (is_idle) = game_idx_to_status(game_idx);
    if (is_idle == 1768189029) {
        return (1, game_idx);
    }

    let (b, i) = find_idle_game(idx + 1);
    return (b, i);

}

@external
func can_dispatch_player_to_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (
        curr_head_idx : felt,
        curr_tail_idx : felt,
        idle_game_idx : felt,
        bool : felt
    ) {
    
    // check if at least 2 players are in the queue
    let (curr_head_idx) = queue_head_index_read();
    let (curr_tail_idx) = queue_tail_index_read();
    let (curr_len) = curr_tail_idx - curr_head_idx;
    let (bool_has_suficient_players_in_queue) = is_le(2, curr_len);

    // check if at least one game is idle
    let (bool_has_idle_game, idle_game_idx) = find_idle_game(0);


    // Combine the 2 above conditions
    let bool = bool_has_idle_game * bool_has_suficient_players_in_queue;

    return (curr_head_idx, curr_tail_idx, idle_game_idx, bool);
}


@external
func dispatch_player_to_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    arguments
) {
    alloc_locals;


    // Retrieve variables
    let (
        curr_head_idx,
        curr_tail_idx,
        idle_game_idx,
        bool
    ) = can_dispatch_player_to_game();
    
    // Fails if cannot dispatch players to the game
    with_attr error_message("Dispatch failed: Not enough players in the queue or no idle game available"){
        assert bool = 1;
    }
    

    // TODO: Check this par to retrieve players addresses array
    let (arr_player_addresses: felt*) = alloc();
    populate_player_adr_update_queue(
        arr_player_addresses,
        curr_head_idx,
        0
    )

    // Update queue head index
    queue_index_to_address_write(curr_head_idx + PLAYERS_PER_GAME);


    // Set game status to active (felt: 107079782725221)
    game_idx_to_status_write(idle_game_idx, 107079782725221)


    // Dispatch to game
    activate_game(idle_game_idx, 

}


func populate_player_adr_update_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    arr_player_addresses: felt*,
    curr_head_idx: felt,
    offset: felt
    ) -> () {
    alloc_locals;

    if offset == PLAYERS_PER_GAME {
        return();
    }

    // populate arr_player_addresses
    let (player_address) = queue_index_to_address_read(curr_head_idx + offset + 1);
    assert arr_player_addresses [offset] = player_adr;

    // Clear queue storage at idx
    address_to_queue_index_write(player_address, 0);
    queue_index_to_address_write(curr_head_idx + offset + 1, 0);

    // Recursion
    populate_player_adr_update_queue(
        arr_player_addresses,
        curr_head_idx,
        offset + 1
    )

    return();
}


@external
func assert_caller_is_lobby{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> () {
    
    let (caller) = get_caller_address();
    let (lobby_address) = lobby_address_read();
    with_attr error_message ("Caller is not the lobby contract"){
        assert caller = lobby_address;
    }

    return();
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



// Not sure if exiting the queue mid-wait for a game to start is a necessary feature for the MVP. 
// To be implemented at a later stage.

// @external
// func anyone_pop_from_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
//     alloc_locals;

//     // Revert if player is not already in the queue, ie. if index-in-queue is not zero.
//     let (caller) = get_caller_address();
//     with_attr error_message("caller is not in the queue") {
//         let (idx) = address_to_queue_index_read(caller);
//         assert_not_zero(idx);
//     }

//     // Pop player from queue.
//     address_to_queue_index_write(caller, 0);

//     return ();
// }
