
// FlashAndRamDlg.h : 头文件
//

#pragma once

#include <fstream>
#include <WinBase.h>
#include "ViewDataDLG.h"
#include <vector>

// FlashAndRamDlg 对话框
class FlashAndRamDlg : public CDialog
{
// 构造
public:
	FlashAndRamDlg(CWnd* pParent = NULL);	// 标准构造函数

// 对话框数据
	enum { IDD = IDD_FLASHANDRAM_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持

public:
	//typedef enum {FLASH, RAM1, RAM2} DATATYPE;

	static const int LENGTH[3];//0:flash,1:ram1,2:ram2

	int length(int id) { return LENGTH[id];}

	unsigned short *data[3];//数据
	bool *exist[3];//对应的数据是否存在

	//std::ofstream fout;

	void LoadData(int id, char *filename);//读取数据
	void SaveData(int id, char *filename);//保存数据

	ViewDataDLG viewdata;

	void LoadFile(int id);//以二进制读取文件

	int timertype, timerid, timerst, timered;
	int ist;

	std::vector<int> st, ed;

	int start;

	void FlashAndRamDlg::ReadDataTimer(int id, int st, int ed);
	void FlashAndRamDlg::WriteDataTimer(int id, int st, int ed);

	HANDLE com;
	void clearCommError();

	bool SendByte(unsigned char);//发送一个字节
	unsigned char RecvByte();//接收一个字节
	void SendWord(unsigned short);//发送一个字
	unsigned short RecvWord();//接收一个字


	bool erased[1 << 6];
	void InitErase() {memset(erased, 0, sizeof(erased));}
	bool Erase(int addr);//根据实际flash地址，进行擦除

	//void UpdateMsg(CString msg) {this->msg.Format("%s", msg.GetBuffer(0)); UpdateData(0);}

	void ReadData(int id);//从板上读数据
	void WriteData(int id);//向板上写数据
	void WriteData(int id, int st, int ed);

	CString userbit;//用户bit文件

	void setActive(int id);//激活flash/ram1/ram2
private:
	int curID;//当前是flash/ram1/ram2

// 实现
protected:
	HICON m_hIcon;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	afx_msg void OnBnClickedCancel();
	afx_msg void OnBnClickedProgram();
	afx_msg void OnBnClickedImport();
	afx_msg void OnBnClickedExport();
	afx_msg void OnBnClickedClear();
	CString fileAddr;
	afx_msg void OnBnClickedView();
	afx_msg void OnBnClickedFileFlash();
	afx_msg void OnBnClickedErase();
	CString msg;
	afx_msg void OnBnClickedReadFlash();
	CString stAddr;
	CString edAddr;
	afx_msg void OnBnClickedButton8();
	afx_msg void OnBnClickedWriteFlash();
	afx_msg void OnBnClickedFileRam1();
	afx_msg void OnBnClickedFileRam2();
	afx_msg void OnBnClickedButton5();
	afx_msg void OnBnClickedButton6();
	afx_msg void OnBnClickedReadRam1();
	afx_msg void OnBnClickedReadRam2();
	afx_msg void OnBnClickedWriteRam1();
	afx_msg void OnBnClickedWriteRam2();
	afx_msg void OnBnClickedFlash();
	afx_msg void OnBnClickedRam1();
	afx_msg void OnBnClickedRam2();
	afx_msg void OnTimer(UINT_PTR nIDEvent);
};
