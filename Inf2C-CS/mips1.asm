
		.data
		
numbers:   .word   7,12,14
		.text

		.main
		

li $t1,3
li $t2,5
add $s1,$t1,$t2
li $v0,1
add $a0,$zero,$s1
syscall

.end:
li $v0,10
syscall

