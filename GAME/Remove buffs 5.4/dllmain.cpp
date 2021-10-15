#include "pch.h"

BOOL APIENTRY DllMain(HMODULE hModule, DWORD dwReason, LPVOID lpReserved) {
	switch (dwReason) {
	case DLL_PROCESS_ATTACH:
		DisableThreadLibraryCalls(hModule);
		BuffRemoveInit();
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}