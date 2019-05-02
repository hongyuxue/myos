; print_string_pm.asm
; xue
[bits 32]
; define some constants
VIDEO_MEMORY    equ    0xb8000
WHITE_ON_BLACK    equ    0x0f
; prints a null-terminated string pointed to by EDX
print_string_pm:
    pusha
    mov    edx, VIDEO_MEMORY        ; 设置 edx 的开局
print_string_pm_loop:
    mov    al, [ebx]                ; 在al的ebx中存储的字符
    mov    ah, WHITE_ON_BLACK        ; 将属性存储在ah(高位中)
    
    cmp    al, 0                    ; if (al == 0), 跳转到字符串末尾, 否则
    je    print_string_pm_done    ; 跳转到完成
    
    mov    [edx], ax                ;立即存储字符和属性在
                                ; 字符单元格
    add    ebx, 1                    ; 将 EBX 递增到字符串中的下一个字符
    add    edx, 2                    ; 移动到下一个字符单元格中的 vid mem
    
    jmp print_string_pm_loop    ; 循环打印下一个字符
    
print_string_pm_done:               ;完成
    popa
    ret                            ; 从函数返回