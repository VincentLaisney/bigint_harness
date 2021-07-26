import rand
import math.big
import time
import os

fn gen_rnd_str(n int, length int) []string  {
	numbers := "0123456789"
	mut num := []string{}
	for _ in 0..n {
		mut stri := ""
		for _ in 0..length {
			i := rand.intn(10)
			nr := numbers[i]
			stri = stri + nr.ascii_str()
		}
		num << stri
	}
	return num
}

fn bigint_str_to_arr(str_arr []string) []big.Number  {
	mut res := []big.Number{}
	for i:=0; i<str_arr.len; i++ {
		stri:=str_arr[i]
		z := big.from_string(stri)
		res << z
	}
	return res
}

fn do_calculation(a big.Number, b big.Number, op byte) big.Number {
	mut result := big.new()
	match op {
	`+`
		{ result = a + b }
	`-`
		{ result = a - b }
	`*`
		{ result = a * b }
	`/`
		{ if big.cmp(b, big.from_int(0)) != 0 {
			result = a / b
		} }
	`%`
		{ result = a % b }
	else {}
	}
	return result
}

fn do_calc_and_print(a big.Number, b big.Number, op byte) big.Number {
	result := do_calculation(a, b, op)
	println(a.str() + " ${op.ascii_str()} " + b.str() + " = " + result.str())
	return result
}

fn do_read_file(f_name string) [][]string {
	lines := os.read_lines(f_name) or { return [][]string{} }
	mut result := [][]string{}
	for line in lines {
		elts := line.split(" ")
		result << elts
	}
	return result
}

const mask32 = (1 << 32) - 1

fn main()  {
	if os.args.len > 1 {
		// println(os.args[1])
		rnd_args := do_read_file(os.args[1])
		// println(rnd_args)
		for line in rnd_args {
			a := line[0]
			op := line[1]
			b := line[2]
			a_bi := big.from_string(a)
			b_bi := big.from_string(b)
			do_calc_and_print(a_bi, b_bi, op[0])
		}
		exit(0)	
	}

	t := time.now().unix_time_milli()
	ts := [u32(t & mask32), u32(t >> 32)]
	rand.seed(ts)
	n := 10 // nb of strings
	l := 10 // lenghth of strings
	
	rnd_str := gen_rnd_str(n, l)
	
	rnd_bigint := bigint_str_to_arr(rnd_str)

	op_arr := "+-*/%"
	for i, a in rnd_bigint {
		for j, b in rnd_bigint {
			if i != j {
				for _, op in op_arr {
					result := do_calc_and_print(a, b, op)
					if op == `*` {
						do_calc_and_print(result, a, `/`)
						do_calc_and_print(result, b, `/`)
					}
				}
			}
		}
	}
}