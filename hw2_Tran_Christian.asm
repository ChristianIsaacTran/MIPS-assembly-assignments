# Homework 2, Christian Tran
# The Data Section
.data
limit: .word 100
space: .asciiz " "
newline: .asciiz "\n"
tab_space: .asciiz "\t"
msg_01: .asciiz "A Sample MIPS Code\n"
msg_02: .asciiz "This program counts down from 100 and prints out all the numbers with spaces in between until it reaches the value zero and exits the program. Displays 99 first because it adds -1 first before displaying.\n"
msg_03: .asciiz "\nEnd of program !\n"

# The Text Section
.text
.globl main
main: la $a0, msg_01
li $v0, 4                       #li means "load immediate" It loads the immediate value given into register
syscall							#v0 is what we use to call services through syscall with the given variable
								#In this scenario, we are using system call 4 which means to print a string out
								#In this case, the string we are printing out is the la (load address) of msg_01
								
								#This next syscall prints out msg_02 to the console
la $a0, msg_02
li $v0, 4
syscall

lw $a0, limit					#Then, we lw (load word (32 bits or 4 bytes)) into the argument zero($a0) register of limit which is 100 
la $a1, space					#We then la (load address) the string space which is just a single whitespace into register argument one ($a1)

# The Loop Section
loop: beq $0, $a0, exit			#beq means (branch if equal) It will jump to this and in this case, jump to the exit section of the program if  register $a0 is zero
addi $a0, $a0, -1				#addi means (add immediate value) so we add whatever value is in $a0 which in this case is 100 to start, and add -1 to it
li $v0, 1						#Then we set $v0 which is for syscall to 1. When $v0 is set to 1 and we syscall it, that means we want to print an integer out to the console
syscall							#Since we already added -1 to 100, the only interger it prints out on this first loop is 99
move $t0, $a0					#moves the value of one register to another, so move value in register $a0 to register $t0 (t stands for temporary register value)
move $a0, $a1					#Note: $a0 is for syscall arguments, so we are moving the contents of $a0 out to $t0 so we can print out a whitespace from $a1
li $v0, 4						#when $v0 is 4 that means to print out a given string, and in this case its the whitespace
syscall
move $a0, $t0					#moves the value of $t0 back to the argument register $a0 and restarts the loop on the next line
j loop              			#j stands for "jump" and is used to jump back to the loop: label 

# The Exit Section  			#after the loop beq to the exit section
exit: la $a0, msg_03			#loads the syscall argument with msg_03 string
li $v0, 4						#loads $v0 with 4 to print out a string 
syscall
li $v0, 10						#we then load value 10 into $v0 for syscall which means to exit the program
syscall

								#note: You can reference the different system call services through a website