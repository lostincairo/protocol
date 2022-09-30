%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_equal, assert_not_zero
from starkware.cairo.common.math_cmp import is_le, is_not_zero
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import (get_block_number, get_caller_address)

@storage_var
func lobby_address () -> (address : felt){
}

@view
func lobby_address_read {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (
    ) -> (address : felt){

    let (address) = lobby_address.read ();

    return (address);
}


func assert_caller_is_lobby {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} () {

    let (caller) = get_caller_address ();
    let (lobby_address) = lobby_address_read ();
    with_attr error_message ("Caller is not the lobby contract"){
        assert caller = lobby_address;
    }

    return();
}