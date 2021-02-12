#include "pch.h"

BOOL Hook(LPVOID lpAddress, LPVOID lpfn, SIZE_T dwSize) {
	if (dwSize < 5) {
		return FALSE;
	}

	DWORD lpflOldProtect;
	if (!VirtualProtect(lpAddress, dwSize, PAGE_EXECUTE_READWRITE, &lpflOldProtect)) {
		return FALSE;
	};

	memset(lpAddress, 0x90, dwSize);
	DWORD dwAddress = ((DWORD)lpfn - (DWORD)lpAddress) - 5;
	*(PBYTE)lpAddress = 0xE9;
	*(PDWORD)((DWORD)lpAddress + 1) = dwAddress;

	DWORD flNewProtect = lpflOldProtect;
	VirtualProtect(lpAddress, dwSize, flNewProtect, &lpflOldProtect);
	return TRUE;
}
