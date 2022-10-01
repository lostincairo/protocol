%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_lt, assert_le, assert_nn, assert_not_equal, assert_nn_le, sqrt)
from starkware.cairo.common.math_cmp import (is_le, is_nn_le, is_not_zero)
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import (get_block_number, get_caller_address)