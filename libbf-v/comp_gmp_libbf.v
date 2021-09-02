import gmp
import libbf.big.integer as big
import os
import strconv
import rand
import time

fn init_params() (int, int, rune) {
	mut iter := 200
	mut len := 100
	mut op := `-`
	if os.args.len > 1 {
		iter = strconv.atoi(os.args[1]) or {panic('atoi(iter)')}
	}
	if os.args.len > 2 {
		len = strconv.atoi(os.args[2]) or {panic('atoi(len)')}
	}
	if os.args.len > 3 {
		op = os.args[3][0]
	}
	return iter, len, op
}

fn generate_random_nb(mut st gmp.Randstate, bit_ct u64) (string, string) {
	unix_time := time.now().unix_time_milli()
	rand.seed([u32(unix_time >> 32), u32(unix_time & ((1 << 32) - 1))])
	sign := rand.int_in_range(0, 4)
	mut a := gmp.new()
	gmp.rrandomb(mut a, mut st, bit_ct)
	if sign < 2 {
		a = gmp.neg(a)
	}
	x := a.str()
	mut b := gmp.new()
	gmp.rrandomb(mut b, mut st, bit_ct)
	if sign % 2 == 0 {
		b = gmp.neg(b)
	}
	y := b.str()
	return x, y
}

fn gmp_op(x string, y string, op rune) string {
	c := gmp.from_str(x)
	d := gmp.from_str(y)
	mut r := gmp.new()
	match op {
		`+` { r = c + d }
		`-` { r = c - d }
		`*` { r = c * d }
		`/` { r = c / d }
		else { panic('${op}: operation not allowed')}
	}
	u := r.str()
	return u
}

fn libbf_op(x string, y string, op rune) string {
	c := big.from_str(x)
	d := big.from_str(y)
	mut r := big.new()
	match op {
		`+` { r = c + d }
		`-` { r = c - d }
		`*` { r = c * d }
		`/` { r = c / d }
		else { panic('${op}: operation not allowed')}
	}
	u := r.str()
	return u
}

fn main () {
	iter, len, op := init_params()
	mut st := gmp.Randstate{}
	gmp.randinit_default(mut st)
	bit_count := u64(len)
	for i in 0..iter {
		x, y := generate_random_nb(mut st, bit_count)
		r_gmp := gmp_op(x, y, op)
		r_libbf := libbf_op(x, y, op)
		if r_gmp != r_libbf {
			println ("$i:\tgmp: $x - $y = $r_gmp \
			\tlibbf: $x -$y = $r_libbf")
		}
	}
}
