// SerialChooser.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "FlashAndRam.h"
#include "SerialChooser.h"
#include "afxdialogex.h"


// SerialChooser �Ի���

IMPLEMENT_DYNAMIC(SerialChooser, CDialog)

SerialChooser::SerialChooser(CWnd* pParent /*=NULL*/)
	: CDialog(SerialChooser::IDD, pParent)
{

}

SerialChooser::~SerialChooser()
{
}

void SerialChooser::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO1, box);
}


BEGIN_MESSAGE_MAP(SerialChooser, CDialog)
	ON_BN_CLICKED(IDOK, &SerialChooser::OnBnClickedOk)
END_MESSAGE_MAP()


// SerialChooser ��Ϣ�������


BOOL SerialChooser::OnInitDialog()
{
	CDialog::OnInitDialog();

	// TODO:  �ڴ���Ӷ���ĳ�ʼ��
	//box.seth
	box.SetCurSel(2);

	return TRUE;  // return TRUE unless you set the focus to a control
	// �쳣: OCX ����ҳӦ���� FALSE
}


void SerialChooser::OnBnClickedOk()
{
	// TODO: �ڴ���ӿؼ�֪ͨ����������
	box.GetWindowTextA(ret);
	
	CDialog::OnOK();
}
