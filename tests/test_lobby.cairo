%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_block_number, get_caller_address


from src.contracts.lobby.lobby import anyone_ask_to_queue

const YOANN = 0x06E7060BE8b0633bb974C682984e646e1f0c634325E91f59d9830858fb4C3180;
const CALLER = 0x00Bed5456bfF4DF658E5EC00EDb2CE66E0194dF12f1Cfe3f99f9B279a7230cc6;

@external
func __setup__() {
    %{context.address = deploy_contract("./src/contracts/lobby/lobby.cairo").contract_address %}

    return ();
}

@external
func test_anyone_ask_to_queue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    
    %{ stop_prank = start_prank(ids.CALLER) %}
    
    anyone_ask_to_queue();

    %{ expect_events({"name": "ask_to_queue_occurred", "data": [0, 1]}) %}

    %{ stop_prank() %}

    %{ stop_prank = start_prank(ids.YOANN) %}
    
    anyone_ask_to_queue();

    %{ expect_events({"name": "ask_to_queue_occurred", "data": [1, 2]}) %}

    %{ stop_prank() %}
    
    return ();
}