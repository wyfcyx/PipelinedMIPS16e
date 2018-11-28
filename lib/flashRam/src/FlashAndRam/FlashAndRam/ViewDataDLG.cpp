// ViewDataDLG.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "FlashAndRam.h"
#include "ViewDataDLG.h"
#include "afxdialogex.h"
#include "FlashAndRamDlg.h"


// ViewDataDLG �Ի���

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


// ViewDataDLG ��Ϣ�������


void ViewDataDLG::OnBnClickedOk()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
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
	// TODO: �ڴ����ר�ô����/����û���
	this->curID = curID;

	return CDialog::DoModal();
}


BOOL ViewDataDLG::OnInitDialog()
{
	CDialog::OnInitDialog();

	// TODO:  �ڴ���Ӷ���ĳ�ʼ��
	
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
	// �쳣: OCX ����ҳӦ���� FALSE
}


void ViewDataDLG::OnBnClickedFlash()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	UpdataList(0);
}


void ViewDataDLG::OnBnClickedRam1()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	UpdataList(1);
}


void ViewDataDLG::OnBnClickedRam2()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	UpdataList(2);
}


void ViewDataDLG::OnLbnSelchangeList1()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
}
