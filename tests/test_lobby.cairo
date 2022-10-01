%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_block_number, get_caller_address


from src.contracts.lobby.lobby import (
    anyone_ask_to_queue,
    queue_tail_index_read,
    event_counter_read,
    queue_index_to_address_read,
    address_to_queue_index_read,
    // anyone_pop_from_queue
)


@external
func test_anyone_ask_to_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals; 

    %{ stop_prank_callable = start_prank(123) %}
    let (caller) = get_caller_address();

    anyone_ask_to_queue();

    let(tail_idx) = queue_tail_index_read();
    assert tail_idx = 1;

    let (event_count) = event_counter_read();
    assert event_count = 1;

    let (player_idx) = queue_index_to_address_read(tail_idx);
    assert player_idx = caller; 

    %{ expect_events({"name": "ask_to_queue_occurred", "data": [0, 123, 1]}) %}

    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(124) %}

    anyone_ask_to_queue();

    let(tail_idx) = queue_tail_index_read();
    assert tail_idx = 2;

    %{ stop_prank_callable() %}
    
    return ();
}

// Not sure if exiting the queue mid-wait for a game to start is a necessary feature for the MVP. 
// To be implemented at a later stage.

// @external
// func test_fail_anyone_pop_from_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
//     alloc_locals;

//     %{ stop_prank_callable = start_prank(123) %}

//     %{ expect_revert(error_message= "caller is not in the queue") %}
//     anyone_pop_from_queue();
    
//     return ();
// }

// @external
// func test_anyone_pop_from_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
//     alloc_locals;

//     %{ stop_prank_callable = start_prank(123) %}
//     let (caller) = get_caller_address();

//     anyone_ask_to_queue();

//     let (prev_tail_idx) = queue_tail_index_read();

//     anyone_pop_from_queue();

//     let(curr_tail_idx) = queue_tail_index_read();
//     assert curr_tail_idx = prev_tail_idx - 1;

//     let (addr_idx) = address_to_queue_index_read(caller);
//     assert addr_idx = 0;
    
//     return ();
// }