// Remove used buffs on the screen (whit using shift) from ep5

#include "pch.h"

DWORD dwRetn1 = 0x4C06B9;
DWORD dwJump1 = 0x4C06FB;

__declspec(naked) void RemoveBuff1()
{
	_asm
	{
		cmp ax, 0x58
		je JePart
		cmp ax, 0x51
		je JePart
		cmp ax, 0x52
		je JePart
		cmp ax, 0x54
		je JePart
		jmp dwJump1

		JePart:
		Jmp dwRetn1
	}
}

DWORD dwRetn2 = 0x4C06FB;
DWORD dwCall2 = 0x598C60;
DWORD dwCall3 = 0x598C60;


__declspec(naked) void RemoveBuff2()
{
	_asm
	{
		call CallTable
		test eax, eax
		je JePart
		mov eax, [esi]
		push eax
		push 0x0000FF
		call dwCall3
		add esp, 0x08
		jmp JePart
		push eax
		call CallTable
		test eax, eax
		pop eax
		je JePart
		mov edx, [esi]
		push edx
		push 0x0000FF
		call dwCall2
		add esp, 0x08
		jmp JePart

		JePart:
		Jmp dwRetn2

			CallTable :
			push ecx
			push edx
			push 0x10
			call GetAsyncKeyState
			test ah, ah
			pop edx
			pop ecx
			jl JLTable
			xor eax, eax
			ret
			JLTable :
		mov eax, 0x01
			ret
	}
}


void BuffRemoveInit()
{
	Hook((void*)(0x4C06B3), RemoveBuff1, 6);
	Hook((void*)(0x4C06EB), RemoveBuff2, 16);
}
