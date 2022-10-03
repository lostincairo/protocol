%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (get_block_number, get_caller_address)

from src.contracts.game.game import (
    lobby_address_read
)


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

@view
func event_counter_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    val: felt
) {
    let (val) = event_counter.read();

    return (val,);
}


@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() {

    let (event_counter) = event_counter_read();
    event_counter_increment ();

    return();
}


@external
func event_counter_increment{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> () {

    // Check that caller is an authorized contract address
    // TODO: Change lobby to include all authorized contract addresses
    let (caller) = get_caller_address();
    let (lobby) = get_caller_address();
    assert caller = lobby;

    let (val) = event_counter.read();
    event_counter.write(val + 1);

    return ();
}




func event_counter_reset{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    ) {
    event_counter.write(0);

    return ();
}