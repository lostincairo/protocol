%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_block_number, get_caller_address

from contracts.lobby.lobby_state import ns_lobby_state_functions

@event
func ask_to_queue_occurred (
    event_counter : felt,
    account : felt,
    queue_idx : felt
){
}

@constructor
func constructor {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (){

    //
    // Invitation check to be implemented later
    //
    // ns_ticket_state.account_has_invitation_write (GYOZA, 1);

    let (event_counter) = ns_lobby_state_functions.event_counter_read ();
    ns_lobby_state_functions.event_counter_increment ();
    // give_invitation_occurred.emit (
    //     event_counter,
    //     GYOZA
    // 

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
    // Revert is caller is 0x0 address => universe contract uses 0x0 as indicator of uninitialized
    //
    let (caller) = get_caller_address();
    with_attr error_message("address 0x0 is not allowed to join queue") {
        assert_not_zero(caller);
    }

    //
    // Revert if caller index-in-queue is not zero, indicating the caller is already in the queue
    //
    let (caller_idx_in_queue) = ns_lobby_state_functions.queue_address_to_index_read(caller);
    with_attr error_message("caller index in queue != 0 => caller already in queue.") {
        assert caller_idx_in_queue = 0;
    }

    //
    // Revert if caller is in one of the active universes
    //
    // recurse_assert_caller_not_in_active_universe(0, caller);

    //
    // Revert if caller has no ticket nor invitation to the Isaac reality
    //
    // let (bool_has_ticket_or_invitation) = account_has_ticket_or_invitation(caller);
    // with_attr error_message(
    //         "caller has no invitation to Isaac nor record of having solved a puzzle at s2m2") {
    //     assert bool_has_ticket_or_invitation = 1;
    // }

    //
    // Enqueue
    //
    let (curr_tail_idx) = ns_lobby_state_functions.queue_tail_index_read();
    let new_player_idx = curr_tail_idx + 1;
    ns_lobby_state_functions.queue_tail_index_write(new_player_idx);
    ns_lobby_state_functions.queue_address_to_index_write(caller, new_player_idx);
    ns_lobby_state_functions.queue_index_to_address_write(new_player_idx, caller);

    //
    // Event emission
    //
    let (event_counter) = ns_lobby_state_functions.event_counter_read();
    ns_lobby_state_functions.event_counter_increment();
    ask_to_queue_occurred.emit(event_counter, caller, new_player_idx);

    return ();
}

// func recurse_assert_caller_not_in_active_universe{
//     syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
// }(idx: felt, caller: felt) -> () {
//     alloc_locals;

//     local index = idx;

//     if (index == UNIVERSE_COUNT) {
//         return ();
//     }

//     let universe_idx = index + UNIVERSE_INDEX_OFFSET;
//     let (universe_addr) = ns_lobby_state_functions.universe_addresses_read(universe_idx);
//     let (bool_in_civ) = IContractUniverse.check_address_in_civilization(universe_addr, caller);
//     with_attr error_message("caller already in the active universe {index}") {
//         assert bool_in_civ = 0;
//     }

//     recurse_assert_caller_not_in_active_universe(idx + 1, caller);
//     return ();
// }