
// FlashAndRam.h : PROJECT_NAME Ӧ�ó������ͷ�ļ�
//

#pragma once

#ifndef __AFXWIN_H__
	#error "�ڰ������ļ�֮ǰ������stdafx.h�������� PCH �ļ�"
#endif

#include "resource.h"		// ������


// FlashAndRamApp:
// �йش����ʵ�֣������ FlashAndRam.cpp
//

class FlashAndRamApp : public CWinApp
{
public:
	FlashAndRamApp();

// ��д
public:
	virtual BOOL InitInstance();

// ʵ��

	DECLARE_MESSAGE_MAP()
};

extern FlashAndRamApp theApp;