
// FlashAndRamDlg.h : ͷ�ļ�
//

#pragma once

#include <fstream>
#include <WinBase.h>
#include "ViewDataDLG.h"
#include <vector>

// FlashAndRamDlg �Ի���
class FlashAndRamDlg : public CDialog
{
// ����
public:
	FlashAndRamDlg(CWnd* pParent = NULL);	// ��׼���캯��

// �Ի�������
	enum { IDD = IDD_FLASHANDRAM_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV ֧��

public:
	//typedef enum {FLASH, RAM1, RAM2} DATATYPE;

	static const int LENGTH[3];//0:flash,1:ram1,2:ram2

	int length(int id) { return LENGTH[id];}

	unsigned short *data[3];//����
	bool *exist[3];//��Ӧ�������Ƿ����

	//std::ofstream fout;

	void LoadData(int id, char *filename);//��ȡ����
	void SaveData(int id, char *filename);//��������

	ViewDataDLG viewdata;

	void LoadFile(int id);//�Զ����ƶ�ȡ�ļ�

	int timertype, timerid, timerst, timered;
	int ist;

	std::vector<int> st, ed;

	int start;

	void FlashAndRamDlg::ReadDataTimer(int id, int st, int ed);
	void FlashAndRamDlg::WriteDataTimer(int id, int st, int ed);

	HANDLE com;
	void clearCommError();

	bool SendByte(unsigned char);//����һ���ֽ�
	unsigned char RecvByte();//����һ���ֽ�
	void SendWord(unsigned short);//����һ����
	unsigned short RecvWord();//����һ����


	bool erased[1 << 6];
	void InitErase() {memset(erased, 0, sizeof(erased));}
	bool Erase(int addr);//����ʵ��flash��ַ�����в���

	//void UpdateMsg(CString msg) {this->msg.Format("%s", msg.GetBuffer(0)); UpdateData(0);}

	void ReadData(int id);//�Ӱ��϶�����
	void WriteData(int id);//�����д����
	void WriteData(int id, int st, int ed);

	CString userbit;//�û�bit�ļ�

	void setActive(int id);//����flash/ram1/ram2
private:
	int curID;//��ǰ��flash/ram1/ram2

// ʵ��
protected:
	HICON m_hIcon;

	// ���ɵ���Ϣӳ�亯��
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
