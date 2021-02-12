#pragma once
#include <sdkddkver.h>
#include <windows.h>

void func();
BOOL Hook(LPVOID lpAddress, LPVOID lpfn, SIZE_T dwSize);
