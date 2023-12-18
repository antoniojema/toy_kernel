[extern isr_handler]
[extern irq_handler]

isr_common_stub:
    ; 1. Save CPU state
	pusha ; Pushes edi,esi,ebp,esp,ebx,edx,ecx,eax
	mov ax, ds ; Lower 16-bits of eax = ds.
	push eax ; save the data segment descriptor
	mov ax, 0x10  ; kernel data segment descriptor
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
    ; 2. Call C handler
	call isr_handler
	
    ; 3. Restore state
	pop eax 
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	popa
	add esp, 8 ; Cleans up the pushed error code and pushed ISR number
	sti
	iret ; pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP

irq_common_stub:
    pusha 
    mov ax, ds
    push eax
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    call irq_handler
    pop ebx
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    popa
    add esp, 8
    sti
    iret 


global call_interrupt

global isr0
global isr1
global isr2
global isr3
global isr4
global isr5
global isr6
global isr7
global isr8
global isr9
global isr10
global isr11
global isr12
global isr13
global isr14
global isr15
global isr16
global isr17
global isr18
global isr19
global isr20
global isr21
global isr22
global isr23
global isr24
global isr25
global isr26
global isr27
global isr28
global isr29
global isr30
global isr31

global irq0
global irq1
global irq2
global irq3
global irq4
global irq5
global irq6
global irq7
global irq8
global irq9
global irq10
global irq11
global irq12
global irq13
global irq14
global irq15

call_interrupt:
    mov eax, [esp+4]
    call [call_int_table + eax * 4]
    ret

; 0: Divide By Zero Exception
isr0:
    cli
    push byte 0
    push byte 0
    jmp isr_common_stub

; 1: Debug Exception
isr1:
    cli
    push byte 0
    push byte 1
    jmp isr_common_stub

; 2: Non Maskable Interrupt Exception
isr2:
    cli
    push byte 0
    push byte 2
    jmp isr_common_stub

; 3: Int 3 Exception
isr3:
    cli
    push byte 0
    push byte 3
    jmp isr_common_stub

; 4: INTO Exception
isr4:
    cli
    push byte 0
    push byte 4
    jmp isr_common_stub

; 5: Out of Bounds Exception
isr5:
    cli
    push byte 0
    push byte 5
    jmp isr_common_stub

; 6: Invalid Opcode Exception
isr6:
    cli
    push byte 0
    push byte 6
    jmp isr_common_stub

; 7: Coprocessor Not Available Exception
isr7:
    cli
    push byte 0
    push byte 7
    jmp isr_common_stub

; 8: Double Fault Exception (With Error Code!)
isr8:
    cli
    push byte 8
    jmp isr_common_stub

; 9: Coprocessor Segment Overrun Exception
isr9:
    cli
    push byte 0
    push byte 9
    jmp isr_common_stub

; 10: Bad TSS Exception (With Error Code!)
isr10:
    cli
    push byte 10
    jmp isr_common_stub

; 11: Segment Not Present Exception (With Error Code!)
isr11:
    cli
    push byte 11
    jmp isr_common_stub

; 12: Stack Fault Exception (With Error Code!)
isr12:
    cli
    push byte 12
    jmp isr_common_stub

; 13: General Protection Fault Exception (With Error Code!)
isr13:
    cli
    push byte 13
    jmp isr_common_stub

; 14: Page Fault Exception (With Error Code!)
isr14:
    cli
    push byte 14
    jmp isr_common_stub

; 15: Reserved Exception
isr15:
    cli
    push byte 0
    push byte 15
    jmp isr_common_stub

; 16: Floating Point Exception
isr16:
    cli
    push byte 0
    push byte 16
    jmp isr_common_stub

; 17: Alignment Check Exception
isr17:
    cli
    push byte 0
    push byte 17
    jmp isr_common_stub

; 18: Machine Check Exception
isr18:
    cli
    push byte 0
    push byte 18
    jmp isr_common_stub

; 19: Reserved
isr19:
    cli
    push byte 0
    push byte 19
    jmp isr_common_stub

; 20: Reserved
isr20:
    cli
    push byte 0
    push byte 20
    jmp isr_common_stub

; 21: Reserved
isr21:
    cli
    push byte 0
    push byte 21
    jmp isr_common_stub

; 22: Reserved
isr22:
    cli
    push byte 0
    push byte 22
    jmp isr_common_stub

; 23: Reserved
isr23:
    cli
    push byte 0
    push byte 23
    jmp isr_common_stub

; 24: Reserved
isr24:
    cli
    push byte 0
    push byte 24
    jmp isr_common_stub

; 25: Reserved
isr25:
    cli
    push byte 0
    push byte 25
    jmp isr_common_stub

; 26: Reserved
isr26:
    cli
    push byte 0
    push byte 26
    jmp isr_common_stub

; 27: Reserved
isr27:
    cli
    push byte 0
    push byte 27
    jmp isr_common_stub

; 28: Reserved
isr28:
    cli
    push byte 0
    push byte 28
    jmp isr_common_stub

; 29: Reserved
isr29:
    cli
    push byte 0
    push byte 29
    jmp isr_common_stub

; 30: Reserved
isr30:
    cli
    push byte 0
    push byte 30
    jmp isr_common_stub

; 31: Reserved
isr31:
    cli
    push byte 0
    push byte 31
    jmp isr_common_stub

irq0:
    cli
    push byte 0
    push byte 0
    jmp irq_common_stub

irq1:
    cli
    push byte 0
    push byte 1
    jmp irq_common_stub

irq2:
    cli
    push byte 0
    push byte 2
    jmp irq_common_stub

irq3:
    cli
    push byte 0
    push byte 3
    jmp irq_common_stub

irq4:
    cli
    push byte 0
    push byte 4
    jmp irq_common_stub

irq5:
    cli
    push byte 0
    push byte 5
    jmp irq_common_stub

irq6:
    cli
    push byte 0
    push byte 6
    jmp irq_common_stub

irq7:
    cli
    push byte 0
    push byte 7
    jmp irq_common_stub

irq8:
    cli
    push byte 0
    push byte 8
    jmp irq_common_stub

irq9:
    cli
    push byte 0
    push byte 0
    push byte 9
    jmp irq_common_stub

irq10:
    cli
    push byte 0
    push byte 10
    jmp irq_common_stub

irq11:
    cli
    push byte 0
    push byte 11
    jmp irq_common_stub

irq12:
    cli
    push byte 0
    push byte 12
    jmp irq_common_stub

irq13:
    cli
    push byte 0
    push byte 13
    jmp irq_common_stub

irq14:
    cli
    push byte 0
    push byte 14
    jmp irq_common_stub

irq15:
    cli
    push byte 0
    push byte 15
    jmp irq_common_stub

call_int_0:
    int 0
    ret
call_int_1:
    int 1
    ret
call_int_2:
    int 2
    ret
call_int_3:
    int 3
    ret
call_int_4:
    int 4
    ret
call_int_5:
    int 5
    ret
call_int_6:
    int 6
    ret
call_int_7:
    int 7
    ret
call_int_8:
    int 8
    ret
call_int_9:
    int 9
    ret
call_int_10:
    int 10
    ret
call_int_11:
    int 11
    ret
call_int_12:
    int 12
    ret
call_int_13:
    int 13
    ret
call_int_14:
    int 14
    ret
call_int_15:
    int 15
    ret
call_int_16:
    int 16
    ret
call_int_17:
    int 17
    ret
call_int_18:
    int 18
    ret
call_int_19:
    int 19
    ret
call_int_20:
    int 20
    ret
call_int_21:
    int 21
    ret
call_int_22:
    int 22
    ret
call_int_23:
    int 23
    ret
call_int_24:
    int 24
    ret
call_int_25:
    int 25
    ret
call_int_26:
    int 26
    ret
call_int_27:
    int 27
    ret
call_int_28:
    int 28
    ret
call_int_29:
    int 29
    ret
call_int_30:
    int 30
    ret
call_int_31:
    int 31
    ret
call_int_32:
    int 32
    ret
call_int_33:
    int 33
    ret
call_int_34:
    int 34
    ret
call_int_35:
    int 35
    ret
call_int_36:
    int 36
    ret
call_int_37:
    int 37
    ret
call_int_38:
    int 38
    ret
call_int_39:
    int 39
    ret
call_int_40:
    int 40
    ret
call_int_41:
    int 41
    ret
call_int_42:
    int 42
    ret
call_int_43:
    int 43
    ret
call_int_44:
    int 44
    ret
call_int_45:
    int 45
    ret
call_int_46:
    int 46
    ret
call_int_47:
    int 47
    ret
call_int_48:
    int 48
    ret
call_int_49:
    int 49
    ret
call_int_50:
    int 50
    ret
call_int_51:
    int 51
    ret
call_int_52:
    int 52
    ret
call_int_53:
    int 53
    ret
call_int_54:
    int 54
    ret
call_int_55:
    int 55
    ret
call_int_56:
    int 56
    ret
call_int_57:
    int 57
    ret
call_int_58:
    int 58
    ret
call_int_59:
    int 59
    ret
call_int_60:
    int 60
    ret
call_int_61:
    int 61
    ret
call_int_62:
    int 62
    ret
call_int_63:
    int 63
    ret
call_int_64:
    int 64
    ret
call_int_65:
    int 65
    ret
call_int_66:
    int 66
    ret
call_int_67:
    int 67
    ret
call_int_68:
    int 68
    ret
call_int_69:
    int 69
    ret
call_int_70:
    int 70
    ret
call_int_71:
    int 71
    ret
call_int_72:
    int 72
    ret
call_int_73:
    int 73
    ret
call_int_74:
    int 74
    ret
call_int_75:
    int 75
    ret
call_int_76:
    int 76
    ret
call_int_77:
    int 77
    ret
call_int_78:
    int 78
    ret
call_int_79:
    int 79
    ret
call_int_80:
    int 80
    ret
call_int_81:
    int 81
    ret
call_int_82:
    int 82
    ret
call_int_83:
    int 83
    ret
call_int_84:
    int 84
    ret
call_int_85:
    int 85
    ret
call_int_86:
    int 86
    ret
call_int_87:
    int 87
    ret
call_int_88:
    int 88
    ret
call_int_89:
    int 89
    ret
call_int_90:
    int 90
    ret
call_int_91:
    int 91
    ret
call_int_92:
    int 92
    ret
call_int_93:
    int 93
    ret
call_int_94:
    int 94
    ret
call_int_95:
    int 95
    ret
call_int_96:
    int 96
    ret
call_int_97:
    int 97
    ret
call_int_98:
    int 98
    ret
call_int_99:
    int 99
    ret
call_int_100:
    int 100
    ret
call_int_101:
    int 101
    ret
call_int_102:
    int 102
    ret
call_int_103:
    int 103
    ret
call_int_104:
    int 104
    ret
call_int_105:
    int 105
    ret
call_int_106:
    int 106
    ret
call_int_107:
    int 107
    ret
call_int_108:
    int 108
    ret
call_int_109:
    int 109
    ret
call_int_110:
    int 110
    ret
call_int_111:
    int 111
    ret
call_int_112:
    int 112
    ret
call_int_113:
    int 113
    ret
call_int_114:
    int 114
    ret
call_int_115:
    int 115
    ret
call_int_116:
    int 116
    ret
call_int_117:
    int 117
    ret
call_int_118:
    int 118
    ret
call_int_119:
    int 119
    ret
call_int_120:
    int 120
    ret
call_int_121:
    int 121
    ret
call_int_122:
    int 122
    ret
call_int_123:
    int 123
    ret
call_int_124:
    int 124
    ret
call_int_125:
    int 125
    ret
call_int_126:
    int 126
    ret
call_int_127:
    int 127
    ret
call_int_128:
    int 128
    ret
call_int_129:
    int 129
    ret
call_int_130:
    int 130
    ret
call_int_131:
    int 131
    ret
call_int_132:
    int 132
    ret
call_int_133:
    int 133
    ret
call_int_134:
    int 134
    ret
call_int_135:
    int 135
    ret
call_int_136:
    int 136
    ret
call_int_137:
    int 137
    ret
call_int_138:
    int 138
    ret
call_int_139:
    int 139
    ret
call_int_140:
    int 140
    ret
call_int_141:
    int 141
    ret
call_int_142:
    int 142
    ret
call_int_143:
    int 143
    ret
call_int_144:
    int 144
    ret
call_int_145:
    int 145
    ret
call_int_146:
    int 146
    ret
call_int_147:
    int 147
    ret
call_int_148:
    int 148
    ret
call_int_149:
    int 149
    ret
call_int_150:
    int 150
    ret
call_int_151:
    int 151
    ret
call_int_152:
    int 152
    ret
call_int_153:
    int 153
    ret
call_int_154:
    int 154
    ret
call_int_155:
    int 155
    ret
call_int_156:
    int 156
    ret
call_int_157:
    int 157
    ret
call_int_158:
    int 158
    ret
call_int_159:
    int 159
    ret
call_int_160:
    int 160
    ret
call_int_161:
    int 161
    ret
call_int_162:
    int 162
    ret
call_int_163:
    int 163
    ret
call_int_164:
    int 164
    ret
call_int_165:
    int 165
    ret
call_int_166:
    int 166
    ret
call_int_167:
    int 167
    ret
call_int_168:
    int 168
    ret
call_int_169:
    int 169
    ret
call_int_170:
    int 170
    ret
call_int_171:
    int 171
    ret
call_int_172:
    int 172
    ret
call_int_173:
    int 173
    ret
call_int_174:
    int 174
    ret
call_int_175:
    int 175
    ret
call_int_176:
    int 176
    ret
call_int_177:
    int 177
    ret
call_int_178:
    int 178
    ret
call_int_179:
    int 179
    ret
call_int_180:
    int 180
    ret
call_int_181:
    int 181
    ret
call_int_182:
    int 182
    ret
call_int_183:
    int 183
    ret
call_int_184:
    int 184
    ret
call_int_185:
    int 185
    ret
call_int_186:
    int 186
    ret
call_int_187:
    int 187
    ret
call_int_188:
    int 188
    ret
call_int_189:
    int 189
    ret
call_int_190:
    int 190
    ret
call_int_191:
    int 191
    ret
call_int_192:
    int 192
    ret
call_int_193:
    int 193
    ret
call_int_194:
    int 194
    ret
call_int_195:
    int 195
    ret
call_int_196:
    int 196
    ret
call_int_197:
    int 197
    ret
call_int_198:
    int 198
    ret
call_int_199:
    int 199
    ret
call_int_200:
    int 200
    ret
call_int_201:
    int 201
    ret
call_int_202:
    int 202
    ret
call_int_203:
    int 203
    ret
call_int_204:
    int 204
    ret
call_int_205:
    int 205
    ret
call_int_206:
    int 206
    ret
call_int_207:
    int 207
    ret
call_int_208:
    int 208
    ret
call_int_209:
    int 209
    ret
call_int_210:
    int 210
    ret
call_int_211:
    int 211
    ret
call_int_212:
    int 212
    ret
call_int_213:
    int 213
    ret
call_int_214:
    int 214
    ret
call_int_215:
    int 215
    ret
call_int_216:
    int 216
    ret
call_int_217:
    int 217
    ret
call_int_218:
    int 218
    ret
call_int_219:
    int 219
    ret
call_int_220:
    int 220
    ret
call_int_221:
    int 221
    ret
call_int_222:
    int 222
    ret
call_int_223:
    int 223
    ret
call_int_224:
    int 224
    ret
call_int_225:
    int 225
    ret
call_int_226:
    int 226
    ret
call_int_227:
    int 227
    ret
call_int_228:
    int 228
    ret
call_int_229:
    int 229
    ret
call_int_230:
    int 230
    ret
call_int_231:
    int 231
    ret
call_int_232:
    int 232
    ret
call_int_233:
    int 233
    ret
call_int_234:
    int 234
    ret
call_int_235:
    int 235
    ret
call_int_236:
    int 236
    ret
call_int_237:
    int 237
    ret
call_int_238:
    int 238
    ret
call_int_239:
    int 239
    ret
call_int_240:
    int 240
    ret
call_int_241:
    int 241
    ret
call_int_242:
    int 242
    ret
call_int_243:
    int 243
    ret
call_int_244:
    int 244
    ret
call_int_245:
    int 245
    ret
call_int_246:
    int 246
    ret
call_int_247:
    int 247
    ret
call_int_248:
    int 248
    ret
call_int_249:
    int 249
    ret
call_int_250:
    int 250
    ret
call_int_251:
    int 251
    ret
call_int_252:
    int 252
    ret
call_int_253:
    int 253
    ret
call_int_254:
    int 254
    ret
call_int_255:
    int 255
    ret


call_int_table:
    dd call_int_0
    dd call_int_1
    dd call_int_2
    dd call_int_3
    dd call_int_4
    dd call_int_5
    dd call_int_6
    dd call_int_7
    dd call_int_8
    dd call_int_9
    dd call_int_10
    dd call_int_11
    dd call_int_12
    dd call_int_13
    dd call_int_14
    dd call_int_15
    dd call_int_16
    dd call_int_17
    dd call_int_18
    dd call_int_19
    dd call_int_20
    dd call_int_21
    dd call_int_22
    dd call_int_23
    dd call_int_24
    dd call_int_25
    dd call_int_26
    dd call_int_27
    dd call_int_28
    dd call_int_29
    dd call_int_30
    dd call_int_31
    dd call_int_32
    dd call_int_33
    dd call_int_34
    dd call_int_35
    dd call_int_36
    dd call_int_37
    dd call_int_38
    dd call_int_39
    dd call_int_40
    dd call_int_41
    dd call_int_42
    dd call_int_43
    dd call_int_44
    dd call_int_45
    dd call_int_46
    dd call_int_47
    dd call_int_48
    dd call_int_49
    dd call_int_50
    dd call_int_51
    dd call_int_52
    dd call_int_53
    dd call_int_54
    dd call_int_55
    dd call_int_56
    dd call_int_57
    dd call_int_58
    dd call_int_59
    dd call_int_60
    dd call_int_61
    dd call_int_62
    dd call_int_63
    dd call_int_64
    dd call_int_65
    dd call_int_66
    dd call_int_67
    dd call_int_68
    dd call_int_69
    dd call_int_70
    dd call_int_71
    dd call_int_72
    dd call_int_73
    dd call_int_74
    dd call_int_75
    dd call_int_76
    dd call_int_77
    dd call_int_78
    dd call_int_79
    dd call_int_80
    dd call_int_81
    dd call_int_82
    dd call_int_83
    dd call_int_84
    dd call_int_85
    dd call_int_86
    dd call_int_87
    dd call_int_88
    dd call_int_89
    dd call_int_90
    dd call_int_91
    dd call_int_92
    dd call_int_93
    dd call_int_94
    dd call_int_95
    dd call_int_96
    dd call_int_97
    dd call_int_98
    dd call_int_99
    dd call_int_100
    dd call_int_101
    dd call_int_102
    dd call_int_103
    dd call_int_104
    dd call_int_105
    dd call_int_106
    dd call_int_107
    dd call_int_108
    dd call_int_109
    dd call_int_110
    dd call_int_111
    dd call_int_112
    dd call_int_113
    dd call_int_114
    dd call_int_115
    dd call_int_116
    dd call_int_117
    dd call_int_118
    dd call_int_119
    dd call_int_120
    dd call_int_121
    dd call_int_122
    dd call_int_123
    dd call_int_124
    dd call_int_125
    dd call_int_126
    dd call_int_127
    dd call_int_128
    dd call_int_129
    dd call_int_130
    dd call_int_131
    dd call_int_132
    dd call_int_133
    dd call_int_134
    dd call_int_135
    dd call_int_136
    dd call_int_137
    dd call_int_138
    dd call_int_139
    dd call_int_140
    dd call_int_141
    dd call_int_142
    dd call_int_143
    dd call_int_144
    dd call_int_145
    dd call_int_146
    dd call_int_147
    dd call_int_148
    dd call_int_149
    dd call_int_150
    dd call_int_151
    dd call_int_152
    dd call_int_153
    dd call_int_154
    dd call_int_155
    dd call_int_156
    dd call_int_157
    dd call_int_158
    dd call_int_159
    dd call_int_160
    dd call_int_161
    dd call_int_162
    dd call_int_163
    dd call_int_164
    dd call_int_165
    dd call_int_166
    dd call_int_167
    dd call_int_168
    dd call_int_169
    dd call_int_170
    dd call_int_171
    dd call_int_172
    dd call_int_173
    dd call_int_174
    dd call_int_175
    dd call_int_176
    dd call_int_177
    dd call_int_178
    dd call_int_179
    dd call_int_180
    dd call_int_181
    dd call_int_182
    dd call_int_183
    dd call_int_184
    dd call_int_185
    dd call_int_186
    dd call_int_187
    dd call_int_188
    dd call_int_189
    dd call_int_190
    dd call_int_191
    dd call_int_192
    dd call_int_193
    dd call_int_194
    dd call_int_195
    dd call_int_196
    dd call_int_197
    dd call_int_198
    dd call_int_199
    dd call_int_200
    dd call_int_201
    dd call_int_202
    dd call_int_203
    dd call_int_204
    dd call_int_205
    dd call_int_206
    dd call_int_207
    dd call_int_208
    dd call_int_209
    dd call_int_210
    dd call_int_211
    dd call_int_212
    dd call_int_213
    dd call_int_214
    dd call_int_215
    dd call_int_216
    dd call_int_217
    dd call_int_218
    dd call_int_219
    dd call_int_220
    dd call_int_221
    dd call_int_222
    dd call_int_223
    dd call_int_224
    dd call_int_225
    dd call_int_226
    dd call_int_227
    dd call_int_228
    dd call_int_229
    dd call_int_230
    dd call_int_231
    dd call_int_232
    dd call_int_233
    dd call_int_234
    dd call_int_235
    dd call_int_236
    dd call_int_237
    dd call_int_238
    dd call_int_239
    dd call_int_240
    dd call_int_241
    dd call_int_242
    dd call_int_243
    dd call_int_244
    dd call_int_245
    dd call_int_246
    dd call_int_247
    dd call_int_248
    dd call_int_249
    dd call_int_250
    dd call_int_251
    dd call_int_252
    dd call_int_253
    dd call_int_254
    dd call_int_255
