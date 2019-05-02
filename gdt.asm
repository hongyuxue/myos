; gdt.asm
; xue
;
[bits 16]
; 全局描述符表
gdt_start:
gdt_null:            ; 强制的空描述符 
    dd    0x0            ; 'dd'意思是双字符 (i.e. 4 bytes)
    dd    0x0
    
gdt_code:            ; 代码描述段
    ; 基址 0x0, 极限 0xfffff
    ;第一个标志：（存在）1（pricilege）00（描述符类型）1->1001B

    ;类型标志：（code）1（confroming）0（readable）1（accessed）0->1010B

    ;第二个标志：（粒度）1（32位默认值）1（64位SEG）0（AVL）0->1100B           
    dw    0xffff        ; 极限 (bits 0 - 15)
    dw    0x0            ; 基址 (bits 0 - 15)
    db    0x0            ; 基址 (bits 16 - 23)
    db    10011010b    ; 1st 标志, 类型标志
    db    11001111b    ; 2nd 标志, limit (bits 16 - 19)
    db    0x0            ; 基址 (bits 24 - 31)
    
gdt_data:            ; 数据描述段
    ; 与代码段相同，但类型标志除外
    ; 类型标志：（代码）0（向下展开）0（可写）1（访问）0->0010B
    dw    0xffff        ; 限制位 (位 0 - 15)
    dw    0x0            ; 基址(bits 0 - 15)
    db    0x0            ; 基址 (bits 16 - 23)
    db    10010010b    ; 1st flags, type flags
    db    11001111b    ; 2nd flags, limit (bits 16 - 19)
    db    0x0            ; base (bits 24 - 31)
    
gdt_end:            ; 将标签放在gdt末尾的原因是
                    ;这样我们可以让汇编程序为gdt描述符计算gdt的大小（如下所示）。
                    
; GDT descriptor
gdt_descriptor:
    dw    gdt_end - gdt_start - 1        ; GDT的大小，总是少一个
    dd    gdt_start                    ; GDT起始地址

;为gdt段描述符偏移量设计一些方便的常量，这是段寄存器在保护模式下必须包含的内容。
;例如，当我们在pm中设置ds=0x10时，CPU知道我们的意思是使用在out gdt中偏移量0x10（即16字节）处描述的段，
;在我们的例子中是数据段（0x0->null；0x08->code；0x10->data）。 

CODE_SEG    equ    gdt_code - gdt_start
DATA_SEG    equ    gdt_data - gdt_start