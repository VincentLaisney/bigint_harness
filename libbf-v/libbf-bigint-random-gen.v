import rand
import libbf.big.integer as big
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

fn bigint_str_to_arr(str_arr []string) []big.Bigint  {
	mut res := []big.Bigint{}
	for i:=0; i<str_arr.len; i++ {
		stri:=str_arr[i]
		z := big.from_str_base(stri, 10)
		res << z
	}
	return res
}

fn do_calculation(a big.Bigint, b big.Bigint, op byte) big.Bigint {
	mut result := big.new()
	match op {
	`+`
		{ result = a + b }
	`-`
		{ result = a - b }
	`*`
		{ result = a * b }
	`/`
		{ if big.cmp(b, big.from_i64(0)) != 0 {
			result = a / b
		} }
	`%`
		{ result = a % b }
	else {}
	}
	return result
}

fn do_calc_and_print(a big.Bigint, b big.Bigint, op byte) big.Bigint {
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
		for elt in rnd_args {
			a := elt[0]
			op := elt[1]
			b := elt[2]
			a_bi := big.from_str(a)
			b_bi := big.from_str(b)
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