#ifndef PCH_H
#define PCH_H

#include "framework.h"

void BuffRemoveInit();

BOOL Hook(void* pAddr, void* pNAddr, int len = 5);
#endif 
