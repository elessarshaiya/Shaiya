// Relocate used buffs on the screen to anywhere you want (whit using shift) from ep5

#include "pch.h"

int BuffLocationValueX = 0;
int BuffLoactionValueY = 0;

int BuffLocationValueXdw = 485;
int BuffLoactionValueYdw = 60;

DWORD BuffLoaction1Return = 0x4C0463;

__declspec(naked) void BuffLocation1()
{
	_asm
	{
		push ebx
		mov ebx, 0x71C2A4
		mov ebx, [ebx]
		mov[BuffLocationValueX], ebx
		mov ebx, 0x71C2A8
		mov ebx, [ebx]
		mov[BuffLoactionValueY], ebx
		pop ebx
		sar edi, 0x01
		mov edi, [BuffLocationValueXdw]
		cmp eax,ecx
		mov ebx, [BuffLoactionValueYdw]
		jmp BuffLoaction1Return

	}
}

__declspec(naked) void BuffLocation2()
{
	_asm
	{
		push esi
		mov esi, GetAsyncKeyState
		push edi
		mov edi, 0x008000
		lea eax, [ecx + 0x00]
		BuffLocation2Jump:
		push 0x10 
			call esi
			test di, ax
			je BuffLocation2Jump
			push 0x02
			call esi
			test di, ax
			je BuffLocation2Jump
			mov eax, [BuffLocationValueX]
			mov[BuffLocationValueXdw], eax
			mov eax, [BuffLoactionValueY]
			mov[BuffLoactionValueYdw], eax
			jmp BuffLocation2Jump
	}
}


DWORD BuffLocation3Return = 0x4C058E;

__declspec(naked) void BuffLocation3()
{
	_asm
	{
		mov edi, [BuffLocationValueXdw]
		jmp BuffLocation3Return
	}
}

DWORD BuffLocation4Return = 0x4C0576;

__declspec(naked) void BuffLocation4()
{
	_asm
	{
		add edi, 0x20 // buff between space
		cmp eax, 0x0A // 1 line buff limit
		jmp BuffLocation4Return

	}
}


void func()
{
	Hook((void*)0x4C0456, BuffLocation1, 5);
	CreateThread(NULL, NULL, LPTHREAD_START_ROUTINE(BuffLocation2), NULL, 0, 0);
	Hook((void*)0x4C0588, BuffLocation3, 5);
	Hook((void*)0x4C0570, BuffLocation4, 5);
}
