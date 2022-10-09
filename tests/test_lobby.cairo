%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_block_number, get_caller_address
from starkware.cairo.common.hash import hash2


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


@contract_interface
namespace IGameContract {
    func activate_game(arr_player_addresses_len: felt, arr_player_addresses: felt*) -> () {
    }

    func init_game() -> (new_game_idx: felt) {
    }

    func game_idx_to_status_read(game_idx: felt) -> (game_status: felt) {
    }

    func game_idx_to_status_write(game_idx: felt, game_status: felt) -> () {
    }
}





// @external
// func test_dispatch_player_to_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
//     alloc_locals; 

//     local contract_address: felt;
//     %{ ids.contract_address = deploy_contract("./src/contracts/game/game.cairo").contract_address %}


//     let (new_game_idx) = IGameContract.init_game(contract_address = contract_address);
//     // Check if can dipatch player to game

//     assert new_game_idx = 1;

//     let (arr_player_addresses: felt*) = alloc();
//     assert arr_player_addresses [0] = 123;
//     assert arr_player_addresses [1] = 124;

//     IGameContract.game_idx_to_status_write(contract_address, 1, 107079782725221);

//     IGameContract.activate_game(
//     contract_address,
//     arr_player_addresses_len = 2,
//     arr_player_addresses = arr_player_addresses
//     );

//     return();
    
// }


