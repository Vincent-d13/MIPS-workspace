.data

seq:
    .asciiz "0123456789ABCDEF"
menu:
    .asciiz "\nEnter 1 to display integer in binary\nEnter 2 to display integer in hexadecimal\nEnter 3 to binary to deciaml\nEnter 4 for binary to hexadecimal\nEnter 5 for hexadeciaml to binary \nEnter 6 for hexadecimal to decimal \nEnter any other key to exit\n"
userInput:   .asciiz  "Please enter your number: "
binaryInput: .asciiz  "Here is the input in binary: "
nl:          .asciiz  "\n"
hexInput:    .asciiz  "Here is the input in hexadecimal: "
binaryOutput:.asciiz  " "
hexOutput:   .asciiz  " "
hexDigit:    .asciiz  "0123456789ABCDEF"
obuf:        .space   100
obufe:
msg1:
    .asciiz "Enter a number in base 2: "
  msg2:
    .asciiz "\nResult: "
  allOnes:
    .asciiz "1111111111111111"
  empty:
    .space 16
  newLine:
    .asciiz "\n"
  sum:
    .space 16 
  sumMsg:
    .asciiz "\nSUM: "
  oneFound:
    .asciiz "\nOne found\n"
  zeroFound:
     .asciiz "\nZero found\n"
    
  message: .asciiz "Please enter a Hex Digit:\n"
     input: .space 8

.text
.globl main
main:
    # display menu
    la      $a0, menu
    li      $v0, 4
    syscall

    # read user choice
    li      $v0, 5
    syscall
    move    $t0, $v0
    
    beq     $t0, 3, binary_ToDecimal
    beq     $t0, 4, binary_ToHexadecimal
    beq     $t0, 5, main2
    beq     $t0, 6, main3     

    # read user input
    la      $a0, userInput
    li      $v0, 4
    syscall
    li      $v0, 5
    syscall
    move    $s0, $v0
    
     

    # check user choice and display accordingly
    beq     $t0, 1, display_binary
    beq     $t0, 2, display_hexadecimal

   
    
    j       main_exit

display_binary:
    # output integer in binary
    la      $a0, binaryInput
    li      $a1, 32
    jal     prtbin

    # output integer in binary
    la      $a0, binaryOutput
    li      $a1, 4
    srl     $s0, $s0, 12
    andi    $s0, $s0, 0x0F
    jal     prtbin

    j       main
    
    prtany:
    li      $t7,1
    sllv    $t7,$t7,$a2             # get mask + 1
    subu    $t7,$t7,1               # get mask for digit

    la      $t6,obufe               # point one past end of buffer
    subu    $t6,$t6,1               # point to last char in buffer
    sb      $zero,0($t6)            # store string EOS

    move    $t5,$s0                 # get number

prtany_loop:
and     $t0,$t5,$t7             # isolate digit

    lb      $t0,hexDigit($t0)       # get ascii digit



    subu    $t6,$t6,1               # move output pointer one left

    sb      $t0,0($t6)              # store into output buffer



    srlv    $t5,$t5,$a2             # slide next number digit into lower bits

    sub     $a1,$a1,$a2             # bump down remaining bit count

    bgtz    $a1,prtany_loop         # more to do? if yes, loop



    # output string

    li      $v0,4

    syscall



    # output the number

    move    $a0,$t6                 # point to ascii digit string start

    syscall



    # output newline

    la      $a0,nl

    syscall



    jr      $ra                     # return



    

    prthex:

    li      $a2,4                   # bit width of number base digit

    j       prtany



display_hexadecimal:

    # output integer in hexadecimal

    la      $a0, hexInput

    li      $a1, 32

    jal     prthex



    # output integer in hexadecimal

    la      $a0, hexOutput

    li      $a1, 4

    srl     $s0, $s0, 12

   andi    $s0, $s0, 0x0F

    jal     prthex



    j       main



display_integer:

    # output integer

    li      $v0, 1

    move    $a0, $s0

    syscall



    # output newline

    la      $a0, nl

    li      $v0, 4

    syscall



    j       main

    

binary_ToDecimal:



getNum:

li $v0,4        # Print string system call

la $a0,msg1         #"Please insert value (A > 0) : "

syscall



la $a0, empty

li $a1, 16              # load 16 as max length to read into $a1

li $v0,8                # 8 is string system call

syscall



la $a0, empty

li $v0, 4               # print string

syscall



li $t4, 0               # initialize sum to 0



startConvert:

  la $t1, empty

  li $t9, 16             # initialize counter to 16

  

  



firstByte:

  lb $a0, ($t1)      # load the first byte

  blt $a0, 48, printSum    # I don't think this line works 

  addi $t1, $t1, 1          # increment offset

  subi $a0, $a0, 48         # subtract 48 to convert to int value

  subi $t9, $t9, 1          # decrement counter

  beq $a0, 0, isZero

  beq $a0, 1, isOne

  j convert     # 



isZero:

   j firstByte



 isOne:                   # do 2^counter 

   li $t8, 1               # load 1

   sllv $t5, $t8, $t9    # shift left by counter = 1 * 2^counter, store in $t5

   add $t4, $t4, $t5         # add sum to previous sum 



   move $a0, $t4        # load sum

   li $v0, 1            # print int

   syscall

   j firstByte



convert:





printSum:

  srlv $t4, $t4, $t9



  la $a0, sumMsg

   li $v0, 4

   syscall



 move $a0, $t4      # load sum

 li $v0, 1      # print int

 syscall

 

 j main

 

 binary_ToHexadecimal:

 

 getNum1:

li $v0,4        # Print string system call

la $a0, msg1       #"Please insert value (A > 0) : "

syscall



la $a0, empty

li $a1, 16              # load 16 as max length to read into $a1

li $v0,8                # 8 is string system call

syscall



la $a0, empty

li $v0, 4               # print string

syscall



li $t4, 0               # initialize sum to 0



startConvert1:

  la $t1, empty

  li $t9, 16             # initialize counter to 16



firstByte1:

  lb $a0, ($t1)      # load the first byte

  blt $a0, 48, printSum1    # I don't think this line works 

  addi $t1, $t1, 1          # increment offset

  subi $a0, $a0, 48         # subtract 48 to convert to int value

  subi $t9, $t9, 1          # decrement counter

  beq $a0, 0, isZero1

  beq $a0, 1, isOne1

  j convert     # 



isZero1:

   j firstByte1



 isOne1:                   # do 2^counter 

   li $t8, 1               # load 1

   sllv $t5, $t8, $t9    # shift left by counter = 1 * 2^counter, store in $t5

   add $t4, $t4, $t5         # add sum to previous sum 



   move $a0, $t4        # load sum

   li $v0, 1             # print int

   syscall

   j firstByte1



convert1:





printSum1:

  srlv $t4, $t4, $t9



  la $a0, sumMsg

   li $v0, 4

   syscall



 move $a0, $t4      # load sum

 li $v0, 34      # print hex

 syscall

 



j main









main2:

    li $v0, 4

    la $a0, message

    syscall



    li $v0, 8

    li $a1, 9

    la $a0, input

    syscall



    li $t0, 0       # Count variable

    li $t2, 0       # Sum variable



j convertHex 





convertHex:

    beq $t0, 8, exit

    lb $t1, input($t0)



    bge $t1, 'a', case2

    bge $t1, 'A', case3

    bge $t1, '0', case1

    j exit



case1:

    sub $t1, $t1 , '0'

    j shift



case2:

    sub $t1, $t1 , 'a'

    addi $t1, $t1, 10

    j shift



case3:

    sub $t1, $t1 , 'A'

    addi $t1, $t1, 10

    j shift



shift:

    sll $t2, $t2, 4

    add $t2, $t2 , $t1

    addi $t0, $t0, 1

    j convertHex



exit:

    li $v0, 1

    move $a0, $t2

    syscall



j main



  main3:

    li $v0, 4

    la $a0, message

    syscall



    li $v0, 8

    li $a1, 9

    la $a0, input

    syscall



    li $t0, 0       # Count variable

    li $t2, 0       # Sum variable



j convertBin 





convertBin:

    beq $t0, 8, exit1

    lb $t1, input($t0)



    bge $t1, 'a', case21

    bge $t1, 'A', case31

    bge $t1, '0', case11

    j exit1



case11:

    sub $t1, $t1 , '0'

    j shift1



case21:

    sub $t1, $t1 , 'a'

    addi $t1, $t1, 10

    j shift1



case31:

    sub $t1, $t1 , 'A'

    addi $t1, $t1, 10

    j shift1



shift1:



    sll $t2, $t2, 4

    add $t2, $t2 , $t1

    addi $t0, $t0, 1

    j convertBin



exit1:



    li $v0, 35

    move $a0, $t2

    syscall

  

    j main



	

	



main_exit:

    # exit the program

    li      $v0, 10

    syscall



# menu -- display menu





# prtbin -- print in binary



prtbin:

    li      $a2, 1                  # bit width of number base digit

    j       prtany





