%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_block_number, get_caller_address


@external
func bow{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, x: felt, y: felt) -> (
) {
    return();
}

@external
func punch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    player_address: felt, x: felt, y: felt
) {
    return();
}