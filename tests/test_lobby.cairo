%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_block_number, get_caller_address


from src.contracts.lobby.lobby_state import (
    lobby_state_functions,
)

from src.contracts.lobby.lobby import (
    anyone_ask_to_queue,
    reset_queue,
    set_game_contract_address,
    find_idle_game,
    can_dispatch_player_to_game,
    dispatch_player_to_game
)


@external
func test_anyone_ask_to_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals; 

    %{ stop_prank_callable = start_prank(35) %}
    let (caller) = get_caller_address();

    anyone_ask_to_queue();

    let(tail_idx) = lobby_state_functions.queue_tail_index_read();
    assert tail_idx = 1;

    let (event_count) = lobby_state_functions.event_counter_read();
    assert event_count = 1;

    let (player_idx) = lobby_state_functions.queue_index_to_address_read(tail_idx);
    assert player_idx = caller; 

    %{ expect_events({"name": "AskToQueueOccured", "data": [0, 35, 1]}) %}

    %{ stop_prank_callable() %}

    // %{ stop_prank_callable = start_prank(124) %}

    // anyone_ask_to_queue();

    // let(tail_idx) = lobby_state_functions.queue_tail_index_read();
    // assert tail_idx = 2;

    // %{ stop_prank_callable() %}
    
    return ();
}

@external
func test_reset_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    arguments
) {

    %{ stop_prank_callable = start_prank(35) %}
    
    let (caller) = get_caller_address();
    reset_queue();
    
}


