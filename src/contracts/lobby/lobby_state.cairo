%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_block_number, get_caller_address


// Storage Vars 
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
func game_addresses(idx: felt) -> (address: felt) {
}

@storage_var
func game_address_to_index(address: felt) -> (idx: felt) {
}

@storage_var
func game_contract_address() -> (address: felt) {
}


@storage_var
func event_counter () -> (val : felt) {
}


namespace lobby_state_functions {

    // Getters

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
    func queue_index_to_address_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (
        idx: felt) -> (address: felt) {

        let (address) = queue_index_to_address.read(idx);
        return (address,);
    }

    @view
    func game_addresses_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        idx: felt) -> (address: felt) {
        
        let (address) = game_addresses.read(idx);
        return (address,);
    }

        @view
    func game_contract_address_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (address: felt) {
        
        let (address) = game_contract_address.read();
        return (address,);
    }

    @view
    func game_address_to_index_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address: felt) -> (idx: felt) {
        
        let (idx) = game_addresses_read(address);
        return (idx,);
    }

    @view
    func event_counter_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        val: felt) {
        let (val) = event_counter.read();

        return (val,);
    }


    // Setters

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

    func game_contract_address_write{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(address: felt) -> () {
        game_contract_address.write(address);

        return ();
    }

    func queue_index_to_address_write{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (
        idx: felt, address: felt) -> () {
        
        queue_index_to_address.write(idx, address);

        return ();
    }

    func event_counter_increment{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> () {

    // Check that caller is an authorized contract address
    // TODO: Change lobby to include all authorized contract addresses
    // let (caller) = get_caller_address();
    // let (lobby) = get_caller_address();
    // assert caller = lobby;

    let (val) = event_counter.read();
    event_counter.write(val + 1);

    return ();
    }

    func event_counter_reset{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    ) {
    event_counter.write(0);

    return ();
    }
}