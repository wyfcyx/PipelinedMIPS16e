// SerialChooser.cpp : 实现文件
//

#include "stdafx.h"
#include "FlashAndRam.h"
#include "SerialChooser.h"
#include "afxdialogex.h"


// SerialChooser 对话框

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


// SerialChooser 消息处理程序


BOOL SerialChooser::OnInitDialog()
{
	CDialog::OnInitDialog();

	// TODO:  在此添加额外的初始化
	//box.seth
	box.SetCurSel(2);

	return TRUE;  // return TRUE unless you set the focus to a control
	// 异常: OCX 属性页应返回 FALSE
}


void SerialChooser::OnBnClickedOk()
{
	// TODO: 在此添加控件通知处理程序代码
	box.GetWindowTextA(ret);
	
	CDialog::OnOK();
}
