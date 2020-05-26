.data
	tb1:.asciiz  "\n========\n|/    |\n|\n|\n|\n|\n|"
	tb2:.asciiz  "\n========\n|/    |\n|     O\n|\n|\n|\n|"
	tb3:.asciiz  "\n========\n|/    |\n|     O\n|     | \n|\n|\n|"
	tb4:.asciiz  "\n========\n|/    |\n|     O\n|    /| \n|\n|\n|"
	tb5:.asciiz  "\n========\n|/    |\n|     O\n|    /|\\\n|\n|\n|"
	tb6:.asciiz  "\n========\n|/    |\n|     O\n|    /|\\\n|    /\n|\n|"
	tb7:.asciiz "\n========\n|/    |\n|     O\n|    /|\\\n|    / \\\n|\n|"
	tb8:.asciiz "\nVi tri xuat hien la: "
	tb9:.asciiz "\n Nhap vao ky tu ban nghi la co: "
	line:.asciiz "==========\n"
	remind:.asciiz "\n Chua chinh xac. Can than hon nhe!"
	printmark:.asciiz "\n| Diem cua ban la: "
	gameover:.asciiz "\n================\n|   THUA CUOC   |\n================\n"
	wingame:.asciiz "\n================\n|  CHIEN THANG  |\n================\n"
	endgame:.asciiz "\n1.Choi lai\n2. Dung lai.\n"
	menu1:.asciiz "\n=================\n| Tiep tuc doan |\n=================\n| 1. Mot ky tu. |\n| 2. Ca tu.     |\n| 0. Exit.      |\n=================\nChon: "
	fin: .asciiz "D:\[19-20]_HK2\KTMT&HN\Code\dethi.txt"
	n:.word 0
	check:.word 0
	doansai:.word 0
	str:.space 50
	str_compare:.space 50
	markarr :.space 10
	guess_arr:.space 2
	score:.word 0
	
.text
	
	
Begin:
	#gan diem toi da la 1000 diem
	li $a0,1000
	sw $a0,score

	# Doc file --> random --> cat chuoi --> ra de
	
	#Nhap vao chuoi str
	li $v0,8
	la $a0,str
	li $a1,50
	syscall

	la $a0,str
	la $a1,n
	jal _S.length
	
MainLoop:

	li $v0,4
	la $a0,line
	syscall
	#XUat chuoi co *
	la $a0,str
	la $a1,markarr
	jal _printStr
	li $v0,4
	la $a0,line
	syscall

	#Kiem tra xem da doan het ky tu chua
	la $a0,markarr 
	lw $a1,n
	la $a2,check
	jal _CheckWin
	lb $a2,check
	bne $a2,0,Wingame
	lw $a2,doansai 
	bge $a2,7,LoseGame
	j Continue
LoseGame:
	li $v0,4
	la $a0,gameover
	syscall
	j PrintResult
Wingame:
	li $v0,4
	la $a0,wingame
	syscall

	j PrintResult
Continue:
	#Xuat thong bao lua chon
	li $v0,4
	la $a0,menu1
	syscall 
	
	li $v0,5
	syscall 
	move $s0,$v0
	beq $s0,1, AChar
	beq $s0,2,WholeWord
	beq $s0,0, End

	#lay random tu 0 - 10
	#li $v0,42
	#li $a1,10
	#syscall 
	#addi $a0,$a0,1
PrintResult:
	
	#Tinh toan diem cua nguoi choi
	lw $t0,score
	lw $t1,doansai
	li $t4,100
	mul $t2,$t1,$t4
	sub $t0,$t0,$t2
	li $t3 2
	ble $t1,$t3,BonusMark
	j PrintResult.Continue
	BonusMark:
		li $t4,2
		mul $t0,$t0,$t4
	PrintResult.Continue:
	#in ra diem cua nguoi choi
	li $v0,4
	la $a0,printmark
	syscall 
	li $v0,1
	move $a0,$t0
	syscall 
	sw $t0,score
	# in ra danh sach 10 nguoi choi cos diem cao nhat	
	

	j EndGame #ket thuc game ... dua nguoi choi toi phan chon choi tiep hay ngung choi
End:
	
	#Ket thuc chuong trinh
	li $v0,10
	syscall
AChar:
	
	#Xuat htong ba nhap ky tu
	li $v0,4
	la $a0,tb9
	syscall 
	

	#Nhap vao mot ky tu
	li $v0, 12
	syscall 
	move $a1,$v0

	#Xuong dong
	li $v0,11
	la $a0,'\n'
	syscall
	
	lw $t3,doansai
	la $a0,str
	
	la $a2,markarr
	la $a3,doansai  
	jal _CheckExistChar
	lw $t4,doansai
	sub $t3,$t4,$t3
	bgt $t3,0, PrintNotifError 
	j MainLoop
	PrintNotifError:
		move $a0,$t4
		jal _Thongbao
		j MainLoop
WholeWord:
	#Nhap vao chuoi str_compare
	li $v0,8
	la $a0,str_compare
	li $a1,50
	syscall
		
	#truyen tham so 
	la $a0,str
	la $a1,str_compare
	jal _StringCompare
	j PrintResult #in diem va ca danh sach ky luc (top 10)
EndGame:
	li $v0,4
	la $a0,endgame
	syscall
	li $v0,5
	syscall
	beq $v0,1,Begin
	beq $v0,2,End
Error1:
	#Xuat thong bao sai 1 luot
	li $v0,4
	la $a0,tb1
	syscall 
	j _Thongbao.end
Error2:
	#Xuat thong bao sai 2 luot
	li $v0,4
	la $a0,tb2
	syscall
	j _Thongbao.end
Error3:
	#Xuat thong bao sai 3 luot
	li $v0,4
	la $a0,tb3
	syscall
	j _Thongbao.end
Error4:
	#Xuat thong bao sai 4 luot
	li $v0,4
	la $a0,tb4
	syscall
	j _Thongbao.end
Error5:
	#Xuat thong bao sai 5 luot
	li $v0,4
	la $a0,tb5
	syscall
		j _Thongbao.end
Error6:
	#Xuat thong bao sai 6 luot
	li $v0,4
	la $a0,tb6
	syscall
		j _Thongbao.end
Error7:
	#Xuat thong bao sai 7 luot
	li $v0,4
	la $a0,tb7
	syscall
	j _Thongbao.end
	
#============== KIEM TRA MANG DANH DAU ===============
_CheckWin:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $t0, 20($sp)
	
	#Luu tham so vao thanh ghi
	move $s0,$a0#markarr
	move $s1,$a1#n
	move $s2,$a2 #check
	
#than thu tuc
	#Khoi tao bien check = 1
	
	#Khoi toa vong lap voi bien dem $t0
	li $t0,1
	_CheckWin.Loop:
		lb $s3,4($s0)
		beq $s3,0,NotWin
	_CheckWin.Inc:
		addi $s0,$s0,1
		addi $t0,$t0,1
		ble $t0,$s1,_CheckWin.Loop
		j _CheckWin.EndLoop
	NotWin:
		li $t0,0
	_CheckWin.EndLoop:
	sb $t0,($s2)
#cuoi thu tuc
	#restore
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $t0, 20($sp)
	#Xoa stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
#============== XUAT CHUOI - DE THI CO DAU * ==========
_printStr:
#doi so truyen vao la chuoi dethi va mang danh dau vi tri da doan trung
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)

	#Luu tham so vao thanh ghi
	move $s0,$a0#str
	move $s1,$a1#markarr

#than thu tuc

	_printStr.Loop:
		lb $s2,($s0)
		lb $s3,4($s1)
		beq $s3,1,_printChar
		j _printStar
	_printChar.Continue:
		addi $s0,$s0,1
		addi $s1,$s1,1
		lb $s2,($s0)
		bne $s2,'\n',_printStr.Loop
		j printChar.EndLoop
		_printChar:
			li $v0,11
			move $a0,$s2
			syscall 
			j _printChar.Continue
		_printStar:	
			li $v0,11
			la $a0,'*'
			syscall 
			j _printChar.Continue
	printChar.EndLoop:
		li $v0,11
		la $a0,'\n'
		syscall 
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	#Xia stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
	
#============= TINH CHIEU DAI CHUOI ===================
#Doi so truyen vao la chuoi can tinh do dai va so n
_S.length:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $t0, 20($sp)
	#Luu tham so vao thanh ghi
	move $s0, $a0 #str
	move $s1, $a1#n	
	#Khoi tao vong lap
	li $t0,0
#than thu tuc:
	_S.length.Loop:
		lb $s2,($s0)
		addi $t0,$t0,1
		addi $s0,$s0,1
		bne $s2,'\n',_S.length.Loop

	addi $t0,$t0,-1
	sw $t0,($s1)	
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $t0, 20($sp)
	#Xia stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
#============ XUAT THONG BAO VOI SO LOI TUONG UNG ================
_Thongbao:
#dau thu tuc
	#Khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	#lay tham so ghi vao thanh ghi
	move $s0,$a0

	

#than thu tuc
	li $v0,4
	la $a0,remind
	syscall

	beq $s0,1,Error1
	beq $s0,2,Error2
	beq $s0,3,Error3
	beq $s0,4,Error4
	beq $s0,5,Error5
	beq $s0,6,Error6
	beq $s0,7,Error7
_Thongbao.end:
	li $v0,11
	la $a0,'\n'
	syscall
#cuoi thu tuc

	#restore
	lw $ra,($sp)
	lw $s0,4($sp)
	#Xoa stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
#=============== HAM SO SANH HAI CHUOI ======================
_StringCompare:
#dau thu tuc
	#khoi tao stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	
	#Luu tham so vao thanh ghi
	move $s0,$a0
	move $s1,$a1
#than thu tuc
_StringCompare.Loop:
	lb $s2,($s0)
	lb $s3,($s1)
	bne $s2,$s3,_StringNotSame
_StringCompare.Increase:
	addi $s1,$s1,1
	addi $s0,$s0,1
	beq $s2,'\n',_ProcessRestString2
	
	j _StringCompare.Loop
_ProcessRestString2:
	beq $s3,'\n',_StringSame
	j _StringCompare.EndLoop
#_ProcessRestString1
_StringNotSame:
	#Xuat thong bao chuoi khong giong nhau va? thua cuoc
	li $v0,4
	la $a0,gameover
	syscall 
	j _StringCompare.EndLoop
_StringSame:
	li $v0,4
	la $a0,wingame
	syscall 
	j _StringCompare.EndLoop
_StringCompare.EndLoop:
	
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	#Xia stack
	addi $sp,$sp,32
	#tra ve
	jr $ra
#=========== HAM KIEM TRA TON TAI KY TU TRONG CHUOI ===============
#tham so truyen vao la 1 chuoi ( de thi) , 1 ky tu can kiem tra
#va 1 mang danh dau vi tri da doan duoc luu vi tri xuat hien cua ky tu trong chuoi ky tu
_CheckExistChar:
#dau thu tuc
	addi, $sp,$sp,-40
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $t0,12($sp)
	sw $t1,16($sp)
	sw $t2,20($sp)
	sw $t3,24($sp)
	sw $t4,28($sp)
	sw $s2,32($sp)
	sw $s3,36($sp)
	
	
	#Luu tham so vao thanh ghi
	move $s0,$a0 #Chuoi ky tu
	move $s1,$a1 #ky tu can kiem tra
	move $s2,$a2 #mang danh dau vi tri xuat hien cua ky tu trong chuoi ky tu
	move $s3,$a3 #so lan doan sai
	
	#Khoi tao bien dem cho vong lap
	li $t0,0
	li $t2,1
	li $t3,0
#than thu tuc
	#Vong lap so sanh tung ky tu
	_CheckExistChar.Loop:
		lb $t1,($s0)
		beq $s1,$t1,_CheckExistChar.Exist

	_CheckExistChar.Loop.Continue:
		addi $t0,$t0,1
		addi $s0,$s0,1
		bne $t1,'\n',_CheckExistChar.Loop
		j _CheckExistChar.EndLoop
	_CheckExistChar.Exist:
		addi $t3,$t3,1
		add $s2,$s2,$t0
		sb $t2,4($s2) 
		sub $s2,$s2,$t0
		j _CheckExistChar.Loop.Continue
	_CheckExistChar.EndLoop:
		beq $t3,0,NotExist
		j _CheckExistChar.EndFunc
		NotExist:
			lw $t2,($s3)
			addi $t3,$t2,1
			sw $t3,($s3)			
_CheckExistChar.EndFunc:
#cuoi thu tuc
	#restore 
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $t0,12($sp)
	lw $t1,16($sp)
	lw $t2,20($sp)
	lw $t3,24($sp)
	lw $t4,28($sp)
	lw $s2,32($sp)
	lw $s3,36($sp)
	#xoa stack
	addi $sp,$sp,40
	#tra ve
	jr $ra
#===================== XUAT MANG ====================
#Than thu tuc
_XuatMang:
	#khai bao kt stack
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp)#n
	sw $s1,8($sp)#arr
	sw $t0,12($sp)
	sw $t1,16($sp)
	sw $t3,20($sp)
	
	#Lay tham so luu vao thanh ghi
	move $s0,$a0
	move $s1,$a1
	
	#KHoi tao vong lap
	li $t0,1
_XuatMang.Lap:
	#Luu a[i] v0
	lb $t3,4($s1)
	li $v0,1
	move $a0,$t3
	syscall#Xuat a[i]

	#Xuat khaong trang
	li $v0,11
	la $a0,' '
	syscall
	#Tang dia chi
	addi  $s1,$s1,1
	#tang dem
	addi $t0,$t0,1
	#Kiem tra dien kien dung
	slt $t1,$s0,$t0
	beq $t1,$0,_XuatMang.Lap
	
	#Cuoi thu tuc
	#restore
	lw $ra,($sp)
	lw $s0,4($sp)#n
	lw $s1,8($sp)#arr
	lw $t0,12($sp)
	lw $t1,16($sp)
	lw $t2,20($sp)
	lw $t3,24($sp)
	addi $sp,$sp,32
	#tra ve
	jr $ra
