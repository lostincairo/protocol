%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

from src.contracts.design.admin import (assert_correct_passkey)

@contract_interface
namespace IGameAutomation {
    func probe_can_init_game() -> (bool: felt, instances: felt){
    }
    
    func init_game() -> () {
    }
}

@storage_var
func lost_in_cairo_game_contract_address() -> (address: felt) {
}

@view
func lost_in_cairo_game_contract_address_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (address: felt) {
    
    let (address) = lost_in_cairo_game_contract_address.read();
    return(address,);
}

@external
func lost_in_cairo_game_contract_address_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    passkey: felt, address: felt) -> () {
    
    assert_correct_passkey(passkey);
    lost_in_cairo_game_contract_address.write(address);
    return();
}

@view
func probeTask{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (bool: felt) {
    
    let (game_address) = lost_in_cairo_game_contract_address_read();

    let (bool) = IGameAutomation.probe_can_init_game(game_address);

    return(bool,);
}

@external
func executeTask{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> () {
    
    let (game_address) = lost_in_cairo_game_contract_address_read();

    IGameAutomation.init_game(game_address);

    return();
}