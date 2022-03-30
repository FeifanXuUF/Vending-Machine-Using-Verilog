#!/bin/bash

iverilog -o test.out ../RTL/money.v ../TB/tb_money.v
vvp test.out
gtkwave mywave.vcd
