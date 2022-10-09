%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2


func assert_correct_passkey {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (
        passkey: felt
    ) -> () {
    alloc_locals;

    
    let (hash) = hash2 {hash_ptr = pedersen_ptr} (passkey, 12345678);

    with_attr error_message ("Wrong passkey") {
        assert hash = 2020492979995559427982700335965372571036326934873461860922312397390409677210;
    }

    return ();
}