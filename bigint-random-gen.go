package main

import (
	"fmt"
	"math/big"
	"math/rand"
	"time"
)

func gen_rnd_str(n int, length int) []string {
	numbers := "0123456789"
	num := []string{}
	for k := 0; k < n; k++ {
		stri := ""
		for j := 0; j < length; j++ {
			i := rand.Intn(10)
			nr := numbers[i]
			stri = stri + string(nr) // append(stri, nr)
		}
		num = append(num, stri)
	}
	return num
}

func bigint_str_to_arr(str_arr []string) []big.Int {
	res := []big.Int{}
	for i := 0; i < len(str_arr); i++ {
		stri := str_arr[i]
		// fmt.Println(stri)
		big_nr := new(big.Int)
		z, succ := big_nr.SetString(stri, 10)
		if !succ {
			panic("Error of big.SetString()")
		}
		// fmt.Println(*z)
		res = append(res, *z)
	}
	return res
}

func do_calculation(a big.Int, b big.Int, op string) big.Int {
	result := new(big.Int)
	// fmt.Print(a, op, b)
	switch op {
	case "+":
		result = result.Add(&a, &b)
	case "-":
		result = result.Sub(&a, &b)
	case "*":
		result = result.Mul(&a, &b)
	case "/":
		if b.Cmp(big.NewInt(0)) != 0 {
			result = result.Div(&a, &b)
		}
	case "%":
		result = result.Mod(&a, &b)
	}
	// fmt.Println(" =", *result)
	return *result
}

func do_calc_and_print(a big.Int, b big.Int, op string) big.Int {
	result := do_calculation(a, b, op)
	fmt.Println(a.String(), op, b.String(), "=", result.String())
	return result
}

func main() {
	rand.Seed(time.Now().UnixNano())
	n := 10  // nb of strings
	l := 100 // lenghth of strings

	rnd_str := gen_rnd_str(n, l)
	// fmt.Println(rnd_str)

	rnd_bigint := bigint_str_to_arr(rnd_str)
	// fmt.Println(rnd_bigint)

	op_arr := "+-*/%"
	for i := range rnd_bigint {
		a := rnd_bigint[i]
		for j := range rnd_bigint {
			b := rnd_bigint[j]
			if i != j {
				for k := range op_arr {
					op := string(op_arr[k])
					result := do_calc_and_print(a, b, op)
					if op == "*" {
						do_calc_and_print(result, a, "/")
						do_calc_and_print(result, b, "/")
					}
				}
			}
		}
	}
}
