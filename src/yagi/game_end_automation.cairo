%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

from src.contracts.design.admin import (assert_correct_passkey)


// TODO: Check with Yagi team if possible to pass arguments to the probe
// Concept would be to check all games with active status and check agains the timeout condition

// Possible implementation: Nested tasks with: 
// 1: probe_active_game
// 2: recurse over active games and check duration condition with another probe.
@contract_interface
namespace IGameAutomation {
    func probe_can_end_game() -> (bool: felt) {
    }

    func dispatch_player_to_game() -> () {
    }
}

@storage_var
func lost_in_cairo_lobby_contract_address() -> (address: felt) {
}

@view
func lost_in_cairo_lobby_contract_address_read{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (address: felt) {
    
    let (address) = lost_in_cairo_lobby_contract_address.read();
    return(address,);
}

@external
func lost_in_cairo_lobby_contract_address_write{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    passkey: felt, address: felt) -> () {
    
    assert_correct_passkey(passkey);
    lost_in_cairo_lobby_contract_address.write(address);
    return();
}

// @view
// func probeTask{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
//     ) -> (bool: felt) {
    
//     let (lobby_address) = lost_in_cairo_lobby_contract_address_read();

//     let (bool) = ILobbyAutomation.probe_can_dispatch_player_to_game(lobby_address);

//     return(bool,);
// }

// @external
// func executeTask{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> () {
    
//     let (lobby_address) = lost_in_cairo_lobby_contract_address_read();

//     ILobbyAutomation.dispatch_player_to_game(lobby_address);

//     return();
// }