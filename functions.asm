;extern scanf, pow

section .rodata
    two dq 2.0
    two_div_3_minus dq -0.666666666666
;    f db '%lf', 0
;    e dq 2.71828182845904523536
    
;section .bss
;    n resq 1
    


section .text
global f1
f1:
    push ebp
    mov ebp, esp
    
    finit
    fld qword[ebp + 8]
    fldl2e
    fmulp st1,st0       ;st0 = x*log2(e) = tmp1
    fld1
    fscale              ;st0 = 2^int(tmp1), st1=tmp1
    fxch
    fld1
    fxch                ;st0 = tmp1, st1=1, st2=2^int(tmp1)
    
    fprem               ;st0 = fract(tmp1) = tmp2
    f2xm1               ;st0 = 2^(tmp2) - 1 = tmp3
    faddp st1,st0       ;st0 = tmp3+1, st1 = 2^int(tmp1)
    fmulp st1,st0       ;st0 = 2^int(tmp1) + 2^fract(tmp1) = 2^(x*log2(e))
    fadd qword[two]     ;+ 2
    
    leave 
    ret




global f2
f2:
    push ebp
    mov ebp, esp
    
    finit
    fld qword[ebp + 8] ; x
    fld1               ; 1
    fdiv st0, st1      ; 1 / x
    fchs               ; - 1 / x
    
    leave
    ret
    
    
    
    
global f3
f3:
    push ebp
    mov ebp, esp
    
    finit
    fld qword[ebp + 8] ; x
    fld1
    faddp              ; x + 1
    fld qword[two]
    fmulp              ; 2(x + 1)
    fld qword[two]     ; 2
    fld1               ; 1
    faddp              ; 2 + 1 = 3
    fdivp              ; 2(x + 1) / 3
    fchs               ; - 2(x + 1) / 3
    
    leave
    ret
    



global d1
d1:
    push ebp
    mov ebp, esp
    
    finit
    fld qword[ebp + 8]
    fldl2e
    fmulp st1,st0       ;st0 = x*log2(e) = tmp1
    fld1
    fscale              ;st0 = 2^int(tmp1), st1=tmp1
    fxch
    fld1
    fxch                ;st0 = tmp1, st1=1, st2=2^int(tmp1)
    
    fprem               ;st0 = fract(tmp1) = tmp2
    f2xm1               ;st0 = 2^(tmp2) - 1 = tmp3
    faddp st1,st0       ;st0 = tmp3+1, st1 = 2^int(tmp1)
    fmulp st1,st0       ;st0 = 2^int(tmp1) + 2^fract(tmp1) = 2^(x*log2(e))
    
    leave 
    ret




global d2
d2:
    push ebp
    mov ebp, esp
    
    finit
    fld qword[ebp + 8] ; x
    fmul qword[ebp + 8]; x^2
    fld1               ; 1
    fdiv st0, st1      ; 1 / x^2
    
    leave
    ret
    



global d3
d3:
    push ebp
    mov ebp, esp
    
    finit
    fld qword[two_div_3_minus] ; lol
    
    leave
    ret
    
    
    
;global main
;main:
;    push ebp
;    mov ebp, esp
;    
;    and esp, ~15
;    sub esp, 16
;    sub esp, 8
;    push n
;    push f
;    call scanf
;    
;    push dword[n + 4]
;    push dword[n]
;    call f3
;    
;    xor eax, eax
;    leave
;    ret