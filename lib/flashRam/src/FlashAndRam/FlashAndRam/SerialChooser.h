#pragma once
#include "afxwin.h"


// SerialChooser 对话框

class SerialChooser : public CDialog
{
	DECLARE_DYNAMIC(SerialChooser)

public:
	SerialChooser(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~SerialChooser();

	CString ret;

// 对话框数据
	enum { IDD = IDD_DIALOG1 };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
	CComboBox box;
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedOk();
};
