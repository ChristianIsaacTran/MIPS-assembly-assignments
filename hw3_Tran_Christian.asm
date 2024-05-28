# Homework 3, Chrsitian Tran
.data

#Array a[13] of same elements to compare
#Note to self: you have to space the elements out in order to declare the array correctly
array1:	.word 5, 2, 15, 3, 7, 15, 8, 9, 5, 2, 15, 3, 7 #Creates an array of the a[13] with all the elements from the C program, note that they are (words)

newline:	.asciiz "\n"
space:	.asciiz " "
msg_01: .asciiz "THIS IS A TEST MESSAGE I AM IN COMPARE" #Jump check test message
msg_02: .asciiz "START OF LOOP 1" #Jump check test message
msg_03: .asciiz "START OF LOOP 2" #Jump check test message
msg_04: .asciiz "bigger.." #output bigger message
msg_05: .asciiz "same.." #output same message
msg_06: .asciiz "smaller.." #output smaller message  
msg_07: .asciiz "\nCOUNT + 1"  #Test message to check for counting 

#Output messages through syscall
largestNumMsg: .asciiz "\nThe largest number is " 
includedNumMsg: .asciiz "The largest number is included "
period: .asciiz "."
timesMsg: .asciiz " times."

.text
.globl main #Note: .globl main is used to denote to the compiler where the code actually starts


main: 
	#Count variables for the for loops from C code
	#Variables i ($t1) is 1 because the loop in C goes to 0 to < num which is 0 to 12, so we want to start at 1 to loop until it gets to 13
	li $t0, 1	#represents int i = 0
	li $t1, 1	#represents int j = 0 #represents the SWITCH CASE variable
	li $t2, 0 	#represents int count = 0

	#Variable that contains the length of the list 13
	li $t3, 13	#represents int num = 13
	
	#Variable that contains the current largest number
	li $t4, 0	#represents int largest = 0
	
	#Set a temp register as the actual list's address
	la $t5, array1
	
forloop1:
	#First for loop prints out the entire list of integers
	
	#Load the word from the array address to a temp variable to stick into arugment register to print and increment the list address by 4 because 4 bytes each word
	lw $t6, 0($t5)	#Gets the element at address offset
	addi $t5, $t5, 4 #Increments the  index of the array. $t5 (array1 address) = $t5 + 4 bytes
	
	#Display the current array1 element from register $t6
	li $v0, 1 #Sets syscall argument to 1 to tell syscall to print out an integer given in argument $a0
	move $a0, $t6 #Copies the value from $t6 to the argument register of $a0
	syscall 
	
	#add a space in between iterations for nicer print 
	li $v0, 4 
	la $a0, space
	syscall
	
	#Branch check
	beq $t0, $t3, reset1  #Branch (or goto) reset1 if #t0 (i) is equal to $t3 (num, which is 13) 
	
	#if the counter i ($t0) doesn't equal the length of the list, then:
	#iterate the counter i ($t0jump back to the start of loop to loop 
	addi $t0, 1 #increases counter i by 1 on each iteration
	j forloop1


reset1: 
	#Used to reset the counter of i back to 1 for the next for loop
	li $t0, 1
	#Set a temp register as the actual list's address
	la $t5, array1
	j forloop2



forloop2:
	#Prints out a newline for every operation
	la $a0, newline
	li $v0, 4
	syscall
	
	#Load the word from the array address to a temp variable to stick into arugment register to print and increment the list address by 4 because 4 bytes each word
	lw $t6, 0($t5)	#Gets the element at address offset
	addi $t5, $t5, 4 #Increments the  index of the array. $t5 (array1 address) = $t5 + 4 bytes
	
	#put argument values to pass to the compare function in the $a registers before calling jal to pass them
	move $a1, $t4	#passing the largest variable
	move $a2, $t6	#pass the current value of this iteration a[i]
	jal subtractFunc #jump to sub (had to rename sub is reserved) function
	jal compare #jump and link to the given function, in this case the compare function
	
	li $v1, 0 #reset the return value for the next loop
	
	#Branch check
	beq $t0, $t3, exit	#Branch (or goto) exit if $t0 (i) is equal to $t3 (num, which is 13) 
	
	
	#if the counter i ($t0) doesn't equal the length of the list, then:
	#iterate the counter i $t0jump back to the start of loop to loop 
	addi $t0, 1 #increases counter i by 1 on each iteration
	j forloop2
	
	


compare:
	move $t7, $ra #save return address so that the bigger, same, and smaller functions can return to the loop address correctly
	
	bgt $v1, $zero, smaller #if the difference is greater than zero, go to smaller
	
	beq $v1, $zero, same #if the difference is equal to zero, go to same
	
	blt $v1, $zero, bigger #if the difference is smaller to zero, go to bigger
	
	

bigger:
	#prints out the bigger.. message
	la $a0, msg_04
	li $v0, 4
	syscall

	move $t4, $t6	#if bigger, make the largest number variable = a[i] ($t6)
	
	li $t2, 1		#if bigger, SET count to 1 (count = 1;)
	
	jr $t7 #go back to the forloop2 return address
    

same:
	#prints out the same.. message
	la $a0, msg_05
	li $v0, 4
	syscall

	addi $t2, 1		#if same, add 1 to the counter (count++;)
	
	jr $t7 #go back to the forloop2 return address

smaller:
	#prints out the smaller.. message
	la $a0, msg_06
	li $v0, 4
	syscall

	jr $t7 #go back to the forloop2 return address



subtractFunc: 
	sub $v1, $a1, $a2 #subtract the largest ($a1) and the current a[i] ($a2) to return register $v1
	
	jr $ra #return to the previous jal call from the return address $ra



exit:
	#prints out the largest number message
	la $a0, largestNumMsg
	li $v0, 4
	syscall
	move $a0, $t4
	li $v0, 1
	syscall
	la $a0, period
	li $v0, 4
	syscall
	
	#Prints out a newline
	la $a0, newline
	li $v0, 4
	syscall
	
	#prints out the largest number included message
	la $a0, includedNumMsg
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, timesMsg
	li $v0, 4
	syscall
	
	#Prints out a newline
	la $a0, newline
	li $v0, 4
	syscall
	
	#Syscall to exit the entire program by setting the argument #v0 to 10
	li $v0, 10
	syscall