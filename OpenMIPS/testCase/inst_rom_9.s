.org 0x0
	.set noat
	.set noreorder
	.set nomacro
	.global _start
_start:
	ori $3, $0, 0x8000
	sll $3, 16				#设置$3=0x80000000
	ori $1, $0, 0x0001		#(1)$1 = 0x0001
	b s1 					#转移到s1处
	ori $1, $0, 0x0002		#(2)$1 = 0x2,这是延迟槽指令
1:
	ori $1, $0, 0x1111
	ori $1, $0, 0x1100

	.org 0x20
s1:
	ori $1, $0, 0x0003 		#(3)$1 = 0x3
	bal s2 					#转移到s2处，同时设置#31 = 0x2c
	nop						#(4) $1 = 0x3

	ori $1, $0, 0x1100
	ori $1, $0, 0x1111
	bne $1, $0, s3
	nop
	ori $1, $0, 0x1100
	ori $1, $0, 0x1111

	.org 0x50
s2:
	ori $1, $0, 0x0004 		#(5) $1 = 0x4
	beq $3, $3, s3			#$3 = $3，所以会发生转移，目的地址是s3
	or $1, $31, $0 			#(6)$1 = 0x2c,这是延迟槽指令
	ori $1, $0, 0x1111
	ori $1, $0, 0x1100
2:
	ori $1, $0, 0x0007 		#(9)$1 = 0x7
	ori $1, $0, 0x0008 		#(10)$1 = 0x8
	bgtz $1, s4 			#此时$1=0x8，大于0，所以转移至标号s4处
	ori $1, $0, 0x0009 		#(11)$1 = 0x9，这是延迟槽指令
	ori $1, $0, 0x1111
	ori $1, $0, 0x1100

	.org 0x80
s3:
	ori $1, $0, 0x0005 		#(7)$1 = 0x5
	bgez $1, 2b 			#此时$1=0x5，大于0，所以转移至标号2处
	ori $1, $0, 0x0006 		#(8)$1 = 0x6,这是延迟槽指令
	ori $1, $0, 0x1111
	ori $1, $0, 0x1100

	.org 0x100
s4:
	ori $1, $0, 0x000a		#(12)$1 = 0xa
	bgezal $3, s3 			#此时$3为0x80000000，小于0，所以不发生转移
	or $1, $0, $31 			#(13)$1 = 0x10c
	ori $1, $0, 0x000b 		#(14)$1 = 0xb
	ori $1, $0, 0x000c 		#(15)$1 = 0xc
	ori $1, $0, 0x000d 		#(16)$1 = 0xd
	ori $1, $0, 0x000e 		#(17)$1 = 0xe
	bltz $3, s5 			#此时$3为0x80000000，小于0，所以发生转移，转移至s5处
	ori $1, $0, 0x000f 		#(18)$1 = 0xf,这是延迟槽指令
	ori $1, $0, 0x1100

	.org 0x130
s5:
	ori $1, $0, 0x0010 		#(19)$1 = 0x10
	blez $1, 2b 			#此时$1为0x10，大于0，所以不发生转移
	ori $1, $0, 0x0011 		#(20)$1 = 0x11
	ori $1, $0, 0x0012 		#(21)$1 = 0x12
	ori $1, $0, 0x0013 		#(22)$1 = 0x13
	bltzal $3, s6 			#此时$3为0x80000000,小于0，所以发生转移，转移到s6处
	or $1, $0, $31 			#(23)$1 = 0x14c,这是延迟槽指令
	ori $1, $0, 0x1100

	.org 0x160
s6:
	ori $1, $0, 0x0014 		#(24)$1 = 0x14
	nop

_loop:
	j _loop
	nop
