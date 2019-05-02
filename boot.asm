;首先设置段寄存器，然后将kernel加载到指定位置，设置GDT然后切换到保护模式，在保护模式中最后跳转到kernel。
;
; 引导扇区, 在32位受保护的 modez 中引导 c 内核
[org  0x7c00]
[bits 16]
KERNEL_OFFSET    equ    0x9000        ; 加载内核到电脑的地址
 
    mov    ax, cs
    mov    ds, ax
    mov    ss, ax
    mov    es, ax
    mov    fs, ax
    mov    gs, ax
    
    mov    [BOOT_DRIVE], dl        ;  BIOS 将我们的引导驱动程序存储在 dl 中
                                ; 
 
    mov    bp, 0x9000                ; 设置栈
    mov    sp, bp
    
    mov    si, MSG_REAL_MODE        ;开始
    call print_string            ; 从16位实模式启动
    
    ;call vga_start                ; 启动VGA模型
 
    call load_kernel            ; 加载内核
    
    call switch_to_pm            ;不能从此处返回
    
    jmp $
    
; 包括一些有用的文件
%include "ptstring.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "pt_string_pm.asm"
%include "switch_to_pm.asm"
%include "vga_start.asm"
 
[bits 16]
; load kernel
load_kernel:
    mov    si, MSG_LOAD_KERNEL        ; 打印一条消息, 说我们正在加载内核
    call print_string
    
    mov    bx, KERNEL_OFFSET        ; 为磁盘加载例程设置参数,
    mov    dh, 56                    ; 我们从引导磁盘加载第一个 n 扇区 (不包括引导扇区)
    mov    dl, [BOOT_DRIVE]        ;  (即我们的内核代码) 
    call disk_load                ; 来解决 KERNEL _ OFFSET 问题
    ret
[bits 32]
; 这是我们切换到并初始化保护模式后到达的地方。
BEGIN_PM:
    mov    ebx, MSG_PROTECT_MODE
    call print_string_pm        ; 使用32位打印例程。
    
    call KERNEL_OFFSET            ;现在跳转到我们加载的地址
                                ; 内核代码
    
    jmp $                        ; Hang.
    
; global variables
BOOT_DRIVE            db    0
MSG_LOAD_KERNEL        db    "Loading kernel into memory", 0   ; 加载内核时，要打印的消息
MSG_REAL_MODE        db    "Started in 16-bit Real Mode", 0     ;16位实模式
MSG_PROTECT_MODE    db    "Successfully landed in 32-bit Protected Mode", 0 ;成功加在32位保护模式
 
; bootsector padding
times    510 - ( $ - $$)    db    0       ;目的是将512字节补齐
dw    0xaa55