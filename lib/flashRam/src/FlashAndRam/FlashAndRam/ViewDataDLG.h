#pragma once
#include "afxwin.h"

// ViewDataDLG �Ի���

class ViewDataDLG : public CDialog
{
	DECLARE_DYNAMIC(ViewDataDLG)

public:
	ViewDataDLG(CDialog *fa, CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~ViewDataDLG();

// �Ի�������
	enum { IDD = IDD_VIEWDATA };

	CDialog *fa;

	void UpdataList(int id);

	int curID;

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	CListBox list;
	virtual INT_PTR DoModal(int curID);
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedFlash();
	afx_msg void OnBnClickedRam1();
	afx_msg void OnBnClickedRam2();
	afx_msg void OnLbnSelchangeList1();
};
