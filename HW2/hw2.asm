	.data
fail:
	.asciiz "Not Possible!"
success:
	.asciiz "Possible!"
array:
	.space 400	#1000 elements of an integer array should be sufficient
maxSize:
	.word 100	#MAX_SIZE of the array
	
	.text
	.globl main
main:
	li $v0, 5
	syscall
	move $a3, $v0		#$a3 -> arraySize
	
	li $v0, 5
	syscall
	move $a1, $v0		#$a1 -> num

	la $a2, array		#$a2 -> address of array
	li $t0, 0		# i = 0
load_array:
	slt $t3, $t0, $a3	#if (i < arraySize)
	bne $t3, 1, exit_load_array
	
	li $v0, 5
	syscall
	move $t1, $v0		#The value that is read stored in $t1
	
	sll $t2, $t0, 2		# Multiply by 4
	add $t2, $t2, $a2
	sw $t1, 0($t2)		# cin >> arr[i]
	
	addi $t0, $t0, 1
	j load_array
exit_load_array:
	jal first
	j print_fail

first:
	addi $sp, $sp, -12	#save the arguments at stack
	sw $ra, 0($sp)		#0(sp) => return address
	sw $a1, 4($sp)		#$4(sp) => target number
	sw $a3, 8($sp)		#$8(sp) => array size
	j checkSumPossibility
	
	
checkSumPossibility:
	addi $s0, $s0, 1
	lw $ra, 0($sp)		#Load Return Adress
	lw $a1, 4($sp)		#Load Target Number
	lw $a3, 8($sp)		#Load arraySize
	
	beq $a1, $zero, print_success	#if target is zero program is successful
	
	addi $t0, $a3, -1	# i = arraySize - 1
	move $t1, $zero		#total = 0
if_not_possible:
	slt $t3, $t0, $zero 	#if i < 0
	bne $t3, 0, exit_if_not_possible	# break
	sll $t3, $t0, 2		# $t3 = 4 * i
	add $t3, $t3, $a2	# 4i + arr*
	lw $t4, 0($t3)		# $t4 = arr[i]
	add $t1, $t1, $t4	# total += arr[i]
	addi $t0, $t0, -1	# i--
	j if_not_possible
	
exit_if_not_possible:
	bgt $a1, $t1, return 
	beq $a3, $zero, return		#if arraySize is zero try again
	
	addi $t0, $a3, -1	#arraySize - 1
	sll $t1, $t0, 2		# x4
	add $t1, $t1, $a2	# *arr + [arraySize - 1] * 4
	lw $t2, 0($t1)		#arr[arraySize - 1]
	
	blt $a1, $t2, save1
	jal save2
	
	lw $ra, 0($sp)		#Load Return Adress
	lw $a1, 4($sp)		#Load Target Number
	lw $a3, 8($sp)	
	jal save1
	j return
	
save2:				#CheckSumPosibility(num - array[arraySize - 1], array, arraySize - 1)
	addi $t0, $a3, -1	#$t0 = arraySize  - 1
	sll $t1, $t0, 2		#$t1 = 4 * [arraySize - 1]
	add $t1, $t1, $a2	# * arr + $t1
	lw $t2, 0($t1)		#$t2 = array[arraySize - 1]
	sub $t3, $a1, $t2	#$t3 = num - array[arraySize - 1]
	addi $sp, $sp, -12	#push stack to save arguments
	sw $ra, 0($sp)
	sw $t3, 4($sp)
	sw $t0, 8($sp)
	j checkSumPossibility

save1:				#CheckSumPossibility)(num, array, arraySize - 1)
	addi $sp, $sp, -12	#push stack to save arguments
	sw $ra, 0($sp)		#return address
	sw $a1, 4($sp)		#target num
	addi $t0, $a3, -1	#arraySize - 1
	sw $t0, 8($sp)
	j checkSumPossibility
	
return:
	lw $ra, 0($sp)		#load adress from stack
	addi $sp, $sp, 12	#go back to retrieve the arguments 
	jr $ra			#jump to its adress
	
	
print_success:			#if program is succesfull
	li $v0, 4
	la $a0, success
	syscall
	j terminate

print_fail:			#if program fails
	li $v0, 4
	la $a0, fail
	syscall
	j terminate
	
terminate:			#end the program
	li $v0, 10
	syscall
	
	



