.org 0x0
.global _start
.set noat
_start:
	#第一段：测试add、addi、addiu、addu、sub、subu指令
	ori $1, $0, 0x8000		# $1 = 0x00008000
	sll $1, $1, 16			# $1 = 0x80000000
	ori $1, $1, 0x0010		# $1 = 0x80000010 给$1赋初值

	ori $2, $0, 0x8000 		# $2 = 0x00008000
	sll $2, $2, 16			# $2 = 0x80000000
	ori $2, $2, 0x0001 		# $2 = 0x80000001 给$2赋初值

	ori $3, $0, 0x0000 		# $3 = 0x00000000
	addu $3, $2, $1 		# $3 = 0x00000011 $1加$2，无符号加法
	ori $3, $0, 0x0000 		# $3 = 0x00000000
	add $3, $2, $1 			# $2加$1，有符号加法，结果溢出，所以$3应保持不变，$3保持为0x00000000

	sub $3, $1, $3 			# $3 = 0x80000010 $1减去$3，有符号减法
	subu $3, $3, $2 		# $3 = 0xF $3减去$2，无符号减法

	addi $3, $3, 2 			# $3 = 0x11 $3加2，有符号加法
	ori $3, $0, 0x0000 		# $3 = 0x00000000
	addiu $3, $3, 0x8000 	# $3 = 0xffff8000 $3加0xffff8000，无符号加法

	#第二段：测试slt、sltu、slti、sltiu指令
	or $1, $0, 0xffff 		# $1 = 0x0000ffff
	sll $1, $1, 16 			# $1 = 0xffff0000 给$1赋初值
	slt $2, $1, $0 			# $2 = 1 比较$1与0x0，有符号比较
	sltu $2, $1, $0 		# $2 = 0 比较$1与0x0，无符号比较
	slti $2, $1, 0x8000 	# $2 = 1 比较$1与0xffff8000，有符号比较
	sltiu $2, $1, 0x8000 	# $2 = 1 比较$1与0xffff8000，无符号比较

	#第三段：测试clo和clz指令
	lui $1, 0x0000 			# $1 = 0x00000000 给$1赋初值
	clo $2, $1 				# $2 = 0x00000000 统计$1中“0”之前的“1”的个数
	clz $2, $1 				# $2 = 0x00000020 统计$1中“1”之前的“0”的个数

	lui $1, 0xffff 			# $1 = 0xffff0000
	ori $1, $1, 0xffff 		# $1 = 0xffffffff 给$1赋初值
	clz $2, $1 				# $2 = 0x00000000 统计$1中“1”之前的“0”的个数
	clo $2, $1 				# $2 = 0x00000020 统计$1中“0”之前的“1”的个数

	lui $1, 0xa100 			# $1 = 0xa1000000 给$1赋初值
	clz $2, $1 				# $2 = 0x00000000 统计$1中“1”之前的“0”的个数
	clo $2, $1 				# $2 = 0x00000001 统计$1中“0”之前的“1”的个数

	lui $1, 0x1100 			# $1 = 0x11000000 给$1赋初值
	clz $2, $1 				# $2 = 0x00000003 统计$1中“1”之前的“0”的个数
	clo $2, $1 				# $2 = 0x00000000 统计$1中“0”之前的“1”的个数

	#第四段：测试mul、mult、multu指令
	ori $1, $0, 0xffff
	sll $1, $1, 16
	ori $1, $1, 0xfffb 		# $1 = -5 给$1赋初值
	ori $2, $0, 6 			# $2 = 6 给$2赋初值
	mul $3, $1, $2 			# $3 = -30 = 0xffffffe2  $1乘以$2，有符号乘法，结果的低32位保存到$3

	mult $1, $2 			# HI = 0Xffffffff, LO = 0xffffffe2，$1乘以$2，有符号乘法，结果保存到HI、LO寄存器
	multu $1, $2 			# HI = 0X5, LO = 0Xffffffe2,$1乘以$2，无符号乘法，结果保存到HI、LO寄存器

	nop
	nop
