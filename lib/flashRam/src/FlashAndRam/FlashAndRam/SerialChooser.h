#pragma once
#include "afxwin.h"


// SerialChooser �Ի���

class SerialChooser : public CDialog
{
	DECLARE_DYNAMIC(SerialChooser)

public:
	SerialChooser(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~SerialChooser();

	CString ret;

// �Ի�������
	enum { IDD = IDD_DIALOG1 };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

	DECLARE_MESSAGE_MAP()
public:
	CComboBox box;
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedOk();
};
