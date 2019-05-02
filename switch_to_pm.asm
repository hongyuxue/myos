; switch_to_pm.asm
;xue

[bits 16]
; switch to protected mode
switch_to_pm:
    cli                     ;我们必须关闭中断，直到
							;设置保护模式中断向量

							;否则中断将引发暴乱
                    
    lgdt [gdt_descriptor]    ;加载全局描述符表，该表定义

                             ;保护模式段（例如用于代码和数据）
                            
    mov    eax, cr0            ; 要切换到保护模式，我们设置
    or    eax, 0x1            ; CR0的第一位，控制寄存器
    mov    cr0, eax
    
    jmp    CODE_SEG:init_pm    ; 在32位上进行一次远跳转（即到一个新的段）

								;代码。这还强制CPU刷新其缓存

								;预取和实模式解码指令
                            
[bits 32]
; initialise registers and the stack once in PM.
init_pm:
    mov    ax, DATA_SEG        
    mov    ds, ax                ; 因此，我们将段寄存器指向我们在
    mov    ss, ax                ; GDT中定义的数据选择器
    mov    es, ax
    mov    fs, ax
    mov    gs, ax
    
    mov    ebp, 0x090000        ;更新堆栈位置，使其正确
    mov    esp, ebp            ; 放在栈顶部的空白空间
    
    call BEGIN_PM            ; 最后，打上标签