    BIS.B #BIT0, &P1DIR   ; Set P1.0 as output for Red LED
    BIC.B #BIT0, &P1OUT   ; Ensure Red LED is off initially
    BIC.B #BIT3, &P1DIR   ; Set P1.3 as input for Button 1
    BIS.B #BIT3, &P1REN   ; Enable pull-up/down resistor for P1.3
    BIS.B #BIT3, &P1OUT   ; Configure pull-up resistor for P1.3
    ; Configure P2.1 for Green LED and P2.3 for Button 2
    BIS.B #BIT1, &P2DIR   ; Set P2.1 as output for Green LED
    BIC.B #BIT1, &P2OUT   ; Ensure Green LED is off initially
    BIC.B #BIT3, &P2DIR   ; Set P2.3 as input for Button 2
    BIS.B #BIT3, &P2REN   ; Enable pull-up/down resistor for P2.3
    BIS.B #BIT3, &P2OUT   ; Configure pull-up resistor for P2.3
    ; Configure P1 and P2 pins as digital I/O
    bic.b #10111110b, &P1SEL ; Set P1.1, 2, 3, 4, 5, and 7 as digital I/O
    bic.b #10111110b, &P1SEL2 ; Set P1.1, 2, 3, 4, 5, and 7 as digital I/O
    bic.b #00000101b, &P2SEL ; Set P2.0 and P2.2 as digital I/O
    bic.b #00000101b, &P2SEL2 ; Set P2.0 and P2.2 as digital I/O
    ; Configure outputs and inputs for LEDs and buttons
    bis.b #10110110b, &P1DIR ; Set P1.1, 2, 4, 5, and 7 as output
    bis.b #00000101b, &P2DIR ; Set P2.0 and P2.2 as output
    bic.b #BIT3, &P1DIR ; Set P1.3 as input
    bis.b #BIT3, &P1REN ; Enable pull-up resistor for P1.3
    bis.b #BIT3, &P1OUT ; Enable pull-up resistor for P1.3
    bis.b #10110110b, &P1OUT ; Turn off all segments
    bis.b #00000101b, &P2OUT ; Turn off all segments
setup:
    ; Initialize LEDs to OFF state
    BIC.B #BIT0, &P1OUT   ; Ensure Red LED is off initially
    BIC.B #BIT1, &P2OUT   ; Ensure Green LED is off initially
    bis.b #10110110b, &P1OUT ; Turn off all segments
    bis.b #00000101b, &P2OUT ; Turn off all segments
    call #segment_3
segment_3:
    ; Display number 3 on the 7-segment display
    bic.b #BIT1, &P1OUT ; Activate segment a
    bic.b #BIT2, &P1OUT ; Activate segment b
    bic.b #BIT4, &P1OUT ; Activate segment c
    bic.b #BIT5, &P1OUT ; Activate segment d
    bic.b #BIT2, &P2OUT ; Activate segment g
    call #delay_timer
    bis.b #10110110b, &P1OUT ; Turn off all segments
    bis.b #00000101b, &P2OUT ; Turn off all segments
    jmp segment_2
segment_2:
    ; Display number 2 on the 7-segment display
    bic.b #BIT1, &P1OUT ; Activate segment a
    bic.b #BIT2, &P1OUT ; Activate segment b
    bic.b #BIT5, &P1OUT ; Activate segment d
    bic.b #BIT7, &P1OUT ; Activate segment e
    bic.b #BIT2, &P2OUT ; Activate segment g
    call #delay_timer
    bis.b #10110110b, &P1OUT ; Turn off all segments
    bis.b #00000101b, &P2OUT  ; Turn off all segments
    jmp segment_1
segment_1:
    ; Display number 1 on the 7-segment display
    bic.b #BIT2, &P1OUT ; Activate segment b
    bic.b #BIT4, &P1OUT ; Activate segment c
    call #delay_timer
    bis.b #10110110b, &P1OUT ; Turn off all segments
    bis.b #00000101b, &P2OUT  ; Turn off all segments
    jmp segment_0
segment_0:
    ; Display number 0 on the 7-segment display
    bic.b #BIT1, &P1OUT ; Activate segment a
    bic.b #BIT2, &P1OUT ; Activate segment b
    bic.b #BIT4, &P1OUT ; Activate segment c
    bic.b #BIT5, &P1OUT ; Activate segment d
    bic.b #BIT7, &P1OUT ; Activate segment e
    bic.b #BIT0, &P2OUT ; Activate segment f
    call #delay_timer
    bis.b #10110110b, &P1OUT ; Turn off all segments
    bis.b #00000101b, &P2OUT ; Turn off all segments
    jmp segment_g
segment_g:
    ; Display dash on display
    bic.b #BIT2, &P2OUT ; Activate segment g
    jmp main_process
main_process:
    ; Main loop to show button states
    BIT.B #BIT3, &P2IN   ; Check state of Button 2 (P2.3)
    JZ button2_event
    BIT.B #BIT3, &P1IN   ; Check state of Button 1 (P1.3)
    JZ button1_event
    JMP main_process
button1_event:
    ; Handle Button 1 press
    BIS.B #BIT0, &P1OUT  ; Turn on Red LED (P1.0)
    JMP reset_system
button2_event:
    ; Handle Button 2 press
    BIS.B #BIT1, &P2OUT ; Turn on Green LED (P2.1)
    JMP reset_system
rule_checker:
    ; Check button pressed or not
    BIT.B #BIT3, &P2IN   ; Check Button 2 (P2.3)
    JZ rule_button2_handler
    BIT.B #BIT3, &P1IN   ; Check Button 1 (P1.3)
    JZ rule_button1_handler
    ret
rule_button2_handler:
    ; Button 2 handling
    bis.b #10110110b, &P1OUT ; Turn off all segments
    bis.b #00000101b, &P2OUT ; Turn off all segments
    bic.b #BIT2, &P2OUT ; Activate dash on display
    BIS.B #BIT0, &P1OUT  ; Turn on Red LED (P1.0)
    JMP reset_system
rule_button1_handler:
    ; Button 1 handling
    bis.b #10110110b, &P1OUT ; Turn off all segments
    bis.b #00000101b, &P2OUT ; Turn off all segments
    bic.b #BIT2, &P2OUT ; Activate dash on display
    BIS.B #BIT1, &P2OUT ; Turn on Green LED (P2.1)
    JMP reset_system
delay_long:
    ; Secondary delay loop
    mov.w #955,r5
loop_outer_long:
    mov.w #750,r6
loop_inner_long:
    dec.w r6
    jnz loop_inner_long
    dec.w r5
    jnz loop_outer_long
    ret
delay_timer:
    ; Main delay loop with rule checking
    mov.w #520,r5
loop_outer:
    mov.w #100,r6
loop_inner:
    call #rule_checker
    dec.w r6
    jnz loop_inner
    dec.w r5
    jnz loop_outer
    ret

reset_system:
    ; System reset 
    call #delay_long
    jmp setup

end_program:
    nop
