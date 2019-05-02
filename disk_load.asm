; disk_load.asm
; xue
;
[bits 16]
; 从驱动器 dl 负载 dh 扇区到 ES: BX 
disk_load:
    push dx                ; 存储 dx 堆栈上, 以便以后可以使用
                        ; 有多少部门, 我们要求被阅读, 即使它被改变在这期间（how many sectors we request to be read, even if it is altered in the meantime）
                        
    mov    ah, 0x02        ;BIOS 读取扇区功能
    mov    al, dh            ;读取 dh 扇区
    mov    ch, 0x00        ; 选择0 select cylinder 0
    mov    dh, 0x00        ; 选则head为0
    mov    cl, 0x02        ; 从第二扇区开始读取 (i.e.引导扇区)
                        ; 
    int    0x13            ; BIOS 中断
    
    jc disk_error        ; 如果出现错误, 则跳转 (即携带标志集)
    
    pop dx                ; 从堆栈中读取 dx
    cmp    dh, al            ; if al (sectors read) != dh (扇区正确到达)
    jne    disk_error        ; 显示错误消息
    
    ret
    
disk_error:
    mov    bx, DISK_ERROR_MSG
    call print_string
    jmp $
    
; variables
DISK_ERROR_MSG: 
    db    "Disk read error!", 0  ;打印错误信息