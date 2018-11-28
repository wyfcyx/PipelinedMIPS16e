// ViewDataDLG.cpp : 实现文件
//

#include "stdafx.h"
#include "FlashAndRam.h"
#include "ViewDataDLG.h"
#include "afxdialogex.h"
#include "FlashAndRamDlg.h"


// ViewDataDLG 对话框

IMPLEMENT_DYNAMIC(ViewDataDLG, CDialog)

ViewDataDLG::ViewDataDLG(CDialog *_fa, CWnd* pParent /*=NULL*/)
	: CDialog(ViewDataDLG::IDD, pParent)
	, fa(_fa)
{
	
}

ViewDataDLG::~ViewDataDLG()
{
}

void ViewDataDLG::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST1, list);
}


BEGIN_MESSAGE_MAP(ViewDataDLG, CDialog)
	ON_BN_CLICKED(IDOK, &ViewDataDLG::OnBnClickedOk)
	ON_BN_CLICKED(IDC_FLASH, &ViewDataDLG::OnBnClickedFlash)
	ON_BN_CLICKED(IDC_RAM1, &ViewDataDLG::OnBnClickedRam1)
	ON_BN_CLICKED(IDC_RAM2, &ViewDataDLG::OnBnClickedRam2)
	ON_LBN_SELCHANGE(IDC_LIST1, &ViewDataDLG::OnLbnSelchangeList1)
END_MESSAGE_MAP()


// ViewDataDLG 消息处理程序


void ViewDataDLG::OnBnClickedOk()
{
	// TODO: 在此添加控件通知处理程序代码
	CDialog::OnOK();
}

void ViewDataDLG::UpdataList(int id)
{
	FlashAndRamDlg *dlg = (FlashAndRamDlg*)fa;
	list.ResetContent();
	for (int i = 0; i < dlg->length(id); ++i)
		if (dlg->exist[id][i]) {
			CString str;
			str.Format("%06X = %04X", i, dlg->data[id][i]);
			//dlg->fout << "insert " << str.GetBuffer() << std::endl;
			list.AddString(str);
			
		}
}

INT_PTR ViewDataDLG::DoModal(int curID)
{
	// TODO: 在此添加专用代码和/或调用基类
	this->curID = curID;

	return CDialog::DoModal();
}


BOOL ViewDataDLG::OnInitDialog()
{
	CDialog::OnInitDialog();

	// TODO:  在此添加额外的初始化
	
	switch (curID) {
	case 0:
		((CButton *)GetDlgItem(IDC_FLASH))->SetCheck(TRUE);
		break;
	case 1:
		((CButton *)GetDlgItem(IDC_RAM1))->SetCheck(TRUE);
		break;
	case 2:
		((CButton *)GetDlgItem(IDC_RAM2))->SetCheck(TRUE);
		break;
	}
	UpdataList(curID);
	return TRUE;  // return TRUE unless you set the focus to a control
	// 异常: OCX 属性页应返回 FALSE
}


void ViewDataDLG::OnBnClickedFlash()
{
	// TODO: 在此添加控件通知处理程序代码
	UpdataList(0);
}


void ViewDataDLG::OnBnClickedRam1()
{
	// TODO: 在此添加控件通知处理程序代码
	UpdataList(1);
}


void ViewDataDLG::OnBnClickedRam2()
{
	// TODO: 在此添加控件通知处理程序代码
	UpdataList(2);
}


void ViewDataDLG::OnLbnSelchangeList1()
{
	// TODO: 在此添加控件通知处理程序代码
}
