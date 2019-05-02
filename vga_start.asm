; vga_start.asm
; author stophin
;
[bits 16]
;记住VGA信息
;起始地址将在内核中使用。
VMODE    equ    0x0ff0    ; VGA 模式
SCRNX    equ    0x0ff2    ; screen X
SCRNY    equ    0x0ff4    ; screen Y
VRAM    equ    0x0ff8    ; 内存缓存
; vga start
vga_start:
    mov    al, 0x13     ; VGA卡，320*200*8bit
						; 0x03:16位字符80*25，初始模式
						;0x12:VGA卡，640*480*4位
						;0X6a：扩展VGA卡，800*600*4
    mov    ah, 0x00
    int    0x10
    
    mov    byte [VMODE], 8
    mov    word [SCRNX], 320
    mov    word [SCRNY], 200
    mov    dword [VRAM], 0xa0000
    
    ret