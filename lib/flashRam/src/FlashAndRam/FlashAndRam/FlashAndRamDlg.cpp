
// FlashAndRamDlg.cpp : 实现文件
//

#include "stdafx.h"
#include "FlashAndRam.h"
#include "FlashAndRamDlg.h"
#include "afxdialogex.h"
#include "SerialChooser.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// 对话框数据
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// FlashAndRamDlg 对话框


const int FlashAndRamDlg::LENGTH[3] = {1 << 22, 1 << 16, 1 << 16};

FlashAndRamDlg::FlashAndRamDlg(CWnd* pParent /*=NULL*/)
	: CDialog(FlashAndRamDlg::IDD, pParent)
	, fileAddr(_T("000000"))
	, viewdata(this)
	, msg(_T(""))
	, stAddr(_T(""))
	, edAddr(_T(""))
	, timertype(0)
	//, userbit(_T(""))
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);

	//fout.open("debug.txt", std::ios_base::out);

	for (int i = 0; i < 3; ++i) {
		data[i] = new unsigned short[LENGTH[i]];
		exist[i] = new bool[LENGTH[i]];
		memset(exist[i], 0, LENGTH[i]);
	}
	char buf[3000];
	GetPrivateProfileString("BitFile", "user", "", buf, sizeof(buf), ".\\config.ini");
	userbit = buf;
	//MessageBox(buf);
}

void FlashAndRamDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT1, fileAddr);
	DDV_MaxChars(pDX, fileAddr, 10);
	DDX_Text(pDX, IDC_MSG, msg);
	DDX_Text(pDX, IDC_STARTADDR, stAddr);
	DDX_Text(pDX, IDC_ENDADDR, edAddr);
}

BEGIN_MESSAGE_MAP(FlashAndRamDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDOK, &FlashAndRamDlg::OnBnClickedOk)
	ON_BN_CLICKED(IDCANCEL, &FlashAndRamDlg::OnBnClickedCancel)
	ON_BN_CLICKED(IDC_PROGRAM, &FlashAndRamDlg::OnBnClickedProgram)
	ON_BN_CLICKED(IDC_IMPORT, &FlashAndRamDlg::OnBnClickedImport)
	ON_BN_CLICKED(IDC_EXPORT, &FlashAndRamDlg::OnBnClickedExport)
	ON_BN_CLICKED(IDC_CLEAR, &FlashAndRamDlg::OnBnClickedClear)
	ON_BN_CLICKED(IDC_VIEW, &FlashAndRamDlg::OnBnClickedView)
	ON_BN_CLICKED(IDC_FILE_FLASH, &FlashAndRamDlg::OnBnClickedFileFlash)
	ON_BN_CLICKED(IDC_ERASE, &FlashAndRamDlg::OnBnClickedErase)
	ON_BN_CLICKED(IDC_READ_FLASH, &FlashAndRamDlg::OnBnClickedReadFlash)
//	ON_BN_CLICKED(IDC_BUTTON8, &FlashAndRamDlg::OnBnClickedButton8)
	ON_BN_CLICKED(IDC_WRITE_FLASH, &FlashAndRamDlg::OnBnClickedWriteFlash)
	ON_BN_CLICKED(IDC_FILE_RAM1, &FlashAndRamDlg::OnBnClickedFileRam1)
	ON_BN_CLICKED(IDC_FILE_RAM2, &FlashAndRamDlg::OnBnClickedFileRam2)
	ON_BN_CLICKED(IDC_BUTTON5, &FlashAndRamDlg::OnBnClickedButton5)
	ON_BN_CLICKED(IDC_BUTTON6, &FlashAndRamDlg::OnBnClickedButton6)
	ON_BN_CLICKED(IDC_READ_RAM1, &FlashAndRamDlg::OnBnClickedReadRam1)
	ON_BN_CLICKED(IDC_READ_RAM2, &FlashAndRamDlg::OnBnClickedReadRam2)
	ON_BN_CLICKED(IDC_WRITE_RAM1, &FlashAndRamDlg::OnBnClickedWriteRam1)
	ON_BN_CLICKED(IDC_WRITE_RAM2, &FlashAndRamDlg::OnBnClickedWriteRam2)
	ON_BN_CLICKED(IDC_FLASH, &FlashAndRamDlg::OnBnClickedFlash)
	ON_BN_CLICKED(IDC_RAM1, &FlashAndRamDlg::OnBnClickedRam1)
	ON_BN_CLICKED(IDC_RAM2, &FlashAndRamDlg::OnBnClickedRam2)
	ON_WM_TIMER()
END_MESSAGE_MAP()


// FlashAndRamDlg 消息处理程序

BOOL FlashAndRamDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码

	bool flag = false;
	while (true) {
		SerialChooser sc;
		if (sc.DoModal() != IDOK) break;

		CString comname = sc.ret;
		//MessageBox(comname);
		com = CreateFile(comname.GetBuffer(0), GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, 0);//同步
		if (com == INVALID_HANDLE_VALUE) {
			CString t;
			t.Format("端口%s不可用!", comname.GetBuffer(0));
			MessageBox(t);
			continue;
		}
		SetupComm(com, 140000, 140000);
		double c = 1;
		COMMTIMEOUTS timeouts;
		timeouts.ReadIntervalTimeout = 1000 * c;
		timeouts.ReadTotalTimeoutMultiplier = 500 * c;
		timeouts.ReadTotalTimeoutConstant = 5000 * c;
		timeouts.WriteTotalTimeoutMultiplier = 500 * c;
		timeouts.WriteTotalTimeoutConstant = 2000 * c;
		SetCommTimeouts(com, &timeouts);

		DCB dcb;
		GetCommState(com, &dcb);
		dcb.BaudRate = 9600;
		dcb.ByteSize = 8;
		//dcb.Parity = ODDPARITY;//Odd
		dcb.Parity = EVENPARITY;//Even
		dcb.StopBits = ONESTOPBIT;//1
		SetCommState(com, &dcb);
		flag = true;
		break;
	}
	if (!flag) {
		//exit(0);
	}
	((CButton *)GetDlgItem(IDC_FLASH))->SetCheck(TRUE);
	setActive(0);

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void FlashAndRamDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void FlashAndRamDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR FlashAndRamDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}



void FlashAndRamDlg::OnBnClickedOk()
{
	// TODO: 在此添加控件通知处理程序代码
	//CDialog::OnOK();
}


void FlashAndRamDlg::OnBnClickedCancel()
{
	// TODO: 在此添加控件通知处理程序代码
	CDialog::OnCancel();
}


void FlashAndRamDlg::OnBnClickedProgram()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	FILE *fout = fopen("program.cmd", "w");
	fprintf(fout, "setMode -bscan\n");
	fprintf(fout, "setCable -p auto\n");
	fprintf(fout, "addDevice -position 1 -file flashram.bit\n");
	//fprintf(fout, "addDevice -position 1 -file E:\\Xilinx\\flashram\\flashram.bit\n");
	fprintf(fout, "ReadIdcode -p 1\n");
	fprintf(fout, "program -p 1\n");
	fprintf(fout, "quit\n");
	fclose(fout);
	system("impact -batch program.cmd");
}

void FlashAndRamDlg::LoadData(int id, char *filename)
{
	std::ifstream fin(filename);
	if (!fin) return;
	char line[256] = {0};
	while (fin) {
		fin.getline(line, 255);
		bool a = false, b = false, c = false;
		int len = strlen(line);
		for (int i = 0; i < len; ++i) {
			if (line[i] == '#') a = true;
			else if (line[i] == '-') b = true;
			else if (line[i] == '=') c = true;
			if (a) line[i] = '\0';
		}
		int st, ed, value;
		if (b) {
			if (sscanf(line, "%x-%x=%x", &st, &ed, &value) == 3) {
				for (int i = st; i <= ed && i >= 0 && i < LENGTH[id]; ++i) {
					data[id][i] = (unsigned short)value;
					exist[id][i] = true;
				}
			}
		} else {
			if (sscanf(line, "%x=%x", &st, &value) == 2) {
				if (st >= 0 && st < LENGTH[id]) {
					data[id][st] = (unsigned short)value;
					exist[id][st] = true;
				}
			}
		}
	}
	fin.close();
}

void FlashAndRamDlg::SaveData(int id, char *filename)
{
	FILE *f = fopen(filename, "w");
	int st = -1;
	for (int i = 0; i < LENGTH[id]; ++i)
		if (exist[id][i]) {
			st = i;
			while (i + 1 < LENGTH[id] && exist[id][i + 1] && data[id][i + 1] == data[id][st]) ++i;
			if (st == i) {
				fprintf(f, "%06X=%04X\n", st, data[id][i]);
			} else {
				fprintf(f, "%06X-%06X=%04X\n", st, i, data[id][i]);
			}
		}
	fclose(f);
}

void FlashAndRamDlg::OnBnClickedImport()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	//导入flash数据
	memset(exist[0], 0, LENGTH[0]);
	memset(exist[1], 0, LENGTH[1]);
	memset(exist[2], 0, LENGTH[2]);

	LoadData(0, "flash.data");
	LoadData(1, "ram1.data");
	LoadData(2, "ram2.data");
	msg.Format("导入完毕");
	UpdateData(0);
}


void FlashAndRamDlg::OnBnClickedExport()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	SaveData(0, "flash.data");
	SaveData(1, "ram1.data");
	SaveData(2, "ram2.data");
	msg.Format("导出完毕");
	UpdateData(0);
}


void FlashAndRamDlg::OnBnClickedClear()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	memset(exist[curID], 0, LENGTH[curID]);
	//memset(exist[1], 0, LENGTH[1]);
	//memset(exist[2], 0, LENGTH[2]);
}


void FlashAndRamDlg::OnBnClickedView()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	viewdata.DoModal(curID);
}


void FlashAndRamDlg::OnBnClickedFileFlash()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	LoadFile(curID);
}

void FlashAndRamDlg::LoadFile(int id)
{
	UpdateData(1);

	//fout << fileAddr << std::endl;
	int st;
	if (sscanf(fileAddr.GetBuffer(0), "%x", &st) != 1 || st < 0 || st >= LENGTH[id]) {
		MessageBox("起始地址不合法！");
		return;
	}

	CFileDialog dlg(TRUE, _T("*"), _T(""), OFN_HIDEREADONLY, _T("File|*.*||"));
	if (dlg.DoModal() == IDOK)
	{
		CString pn = dlg.GetPathName();
		FILE *fin = fopen(pn.GetBuffer(0), "rb");
		unsigned char *buf = new unsigned char[LENGTH[id] + 1];
		int tot = fread(buf, 1, LENGTH[id], fin);
		buf[tot] = 0xFF;
		tot = (tot + 1) / 2;
		//CString msg;
		if (st + tot > LENGTH[id]) {
			msg.Format("文件共%d字，其中后%d字由于超出范围被舍去", tot, st + tot - LENGTH[id]);
			tot = LENGTH[id] - st;
		} else {
			msg.Format("成功读入%d字", tot);
		}
		for (int i = 0; i < tot; ++i) {
			data[id][st + i] = (buf[i * 2 + 1] << 8) | buf[i * 2];
			exist[id][st + i] = true;
		}
		//MessageBox(msg);
	}
	UpdateData(0);
}

void FlashAndRamDlg::clearCommError() {
	COMSTAT ComStat;
	DWORD dwErrorFlags;
	ClearCommError(com, &dwErrorFlags, &ComStat);
}

bool FlashAndRamDlg::SendByte(unsigned char byte)
{
	unsigned char buf[10];
	buf[0] = byte;
	DWORD dwBytesWrite = 1;
	clearCommError();
	BOOL bWriteStat = WriteFile(com, buf, dwBytesWrite, &dwBytesWrite, NULL);
	if (!bWriteStat) {
		MessageBox("写串口失败!");
		return false;
	} else {
		//MessageBox("写串口成功!");
	}
	PurgeComm(com, PURGE_TXABORT|PURGE_RXABORT|PURGE_TXCLEAR|PURGE_RXCLEAR);
	return true;
}

void FlashAndRamDlg::SendWord(unsigned short word)
{
	SendByte(word & 0xFF);
	SendByte(word >> 8);
}
unsigned short FlashAndRamDlg::RecvWord()
{
	return RecvByte() | (RecvByte() << 8);
}

unsigned char FlashAndRamDlg::RecvByte()
{
	unsigned char buf[10];
	DWORD wCount = 1;
	BOOL bReadStat = ReadFile(com, buf, wCount, &wCount, NULL);
	if (!bReadStat) {
		MessageBox("读串口失败！");
	}
	return buf[0];
}

bool FlashAndRamDlg::Erase(int addr)
{
	addr >>= 16;
	
	msg.Format("擦除Block#0x%02X中...", addr);
	UpdateData(0);
	
	if (erased[addr]) return true;
	erased[addr] = true;
	if (!SendByte((addr << 2) | 3)) {
		CString t;
		t.Format("擦除Block#0x%02X时写串口错误，结束擦除", addr);
		MessageBox(t);
		return false;
	}
	if (RecvByte() != 0x23) {
		CString t;
		t.Format("擦除Block#0x%02X时读串口错误，结束擦除", addr);
		MessageBox(t);
		return false;
	}
	return true;
}

void FlashAndRamDlg::OnBnClickedErase()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	InitErase();
	for (int addr = 0; addr < (1 << 6); ++addr) {	
		if (!Erase(addr << 16)) break;
	}
	msg.Format("擦除完毕!");
	UpdateData(0);
}


void FlashAndRamDlg::OnBnClickedReadFlash()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	ReadData(curID);
}

void FlashAndRamDlg::ReadData(int id)
{
	UpdateData(1);

	int st, ed;

	if (sscanf(stAddr.GetBuffer(0), "%X", &st) != 1 || sscanf(edAddr.GetBuffer(0), "%X", &ed) != 1) {
		MessageBox("地址错误");
		return;
	}
	if (st < 0 || st >= LENGTH[id] || ed < 0 || ed >= LENGTH[id] || st > ed) {
		MessageBox("地址非法");
		return;
	}
	msg = "发送指令";
	UpdateData(0);

	int cmd;
	switch (id) {
	case 0:
		cmd = 0;
		break;
	case 1:
		cmd = 1;
		break;
	case 2:
		cmd = 2;
		break;
	default:
		;
	}
	unsigned char buf[7] = {
		cmd,//命令
		st >> 16,
		(st >> 8) & 0xFF,
		st & 0xFF,
		ed >> 16,
		(ed >> 8) & 0xFF,
		ed & 0xFF
	};
	for (int i = 0; i < 7; ++i) {
		SendByte(buf[i]);
		if (RecvByte() != 0x23 + i) {
			MessageBox("读取时FPGA响应错误");
			return;
		}
	}

	start = clock();
	ist = st;

	timertype = 1;
	timerid = id;
	timerst = st;
	timered = ed;
	SetTimer(1, 20, NULL);
}

void FlashAndRamDlg::ReadDataTimer(int id, int st, int ed)
{
	int cnt = 0;
	for (int i = st; i <= ed; ++i) {
		if (cnt > 500) {
			timertype = 1;
			timerid = id;
			timerst = i;
			timered = ed;
			SetTimer(1, 20, NULL);
			return;
		}
		data[id][i] = RecvWord();
		exist[id][i] = true;
		msg.Format("已读取%d/%d个字", i + 1 - ist, ed - ist + 1);
		UpdateData(0);
		++cnt;
	}

	msg.Format("读取完毕 共耗时%dms", clock() - start);
	UpdateData(0);
	KillTimer(1);
}

void FlashAndRamDlg::WriteData(int id)
{
	msg.Empty();
	if (id == 0) {
		InitErase();
		for (int i = 0; i < LENGTH[id]; ++i) if (exist[id][i]) {
			Erase(i);
		}
	}
	int start = clock();

	this->st.clear();
	this->ed.clear();

	for (int i = 0; i < LENGTH[id]; ++i) if (exist[id][i]) {
		int st = i;
		while (i + 1 < LENGTH[id] && exist[id][i + 1]) ++i;
		//WriteData(id, st, i);
		this->st.push_back(st);
		this->ed.push_back(i);
	}
	//CString t;
	//t.Format(" 共耗时%dms", clock() - start);
	//msg.Append(t);
	//UpdateData(0);

	if (this->st.size() > 0) {
		timerid = id;
		timertype = 3;
		SetTimer(1, 20, NULL);
	}
}

void FlashAndRamDlg::WriteData(int id, int st, int ed)
{
	//CString t;
	//t.Format("WriteData %d %d %d", id, st, ed);
	//MessageBox(t);

	msg = "发送指令";
	UpdateData(0);

	int cmd;
	switch (id) {
	case 0:
		cmd = 4;
		break;
	case 1:
		cmd = 5;
		break;
	case 2:
		cmd = 6;
		break;
	default:
		;
	}
	unsigned char buf[7] = {
		cmd,//命令
		st >> 16,
		(st >> 8) & 0xFF,
		st & 0xFF,
		ed >> 16,
		(ed >> 8) & 0xFF,
		ed & 0xFF
	};
	for (int i = 0; i < 7; ++i) {
		//fout << "sendbyte " << std::hex << (int)buf[i] << std::endl;
		if (!SendByte(buf[i])) {
			MessageBox("写入时串口发送失败");
			return;
		}
		if (RecvByte() != 0x23 + i) {
			MessageBox("写入时FPGA响应错误");
			return;
		}
	}

	ist = st;
	
	timertype = 2;
	timerid = id;
	timerst = st;
	timered = ed;
	SetTimer(1, 20, NULL);


}

void FlashAndRamDlg::WriteDataTimer(int id, int st, int ed)
{
	int cnt = 0;
	for (int i = st; i <= ed; ++i) {
		if (cnt > 500) {
			timertype = 2;
			timerid = id;
			timerst = i;
			timered = ed;
			SetTimer(1, 20, NULL);
			return;
		}
		SendWord(data[id][i]);
		msg.Format("已写入%d/%d个字", i + 1 - ist, ed - ist + 1);
		UpdateData(0);
		//sleep(1);
		cnt++;
	}

	msg = "写入完毕";
	UpdateData(0);
	KillTimer(1);

	if (this->st.size() > 0) {
		timertype = 3;
		SetTimer(1, 20, NULL);
	}
}



void FlashAndRamDlg::OnBnClickedWriteFlash()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	WriteData(curID);
}


void FlashAndRamDlg::OnBnClickedFileRam1()
{
	// TODO: 在此添加控件通知处理程序代码
	LoadFile(1);
}


void FlashAndRamDlg::OnBnClickedFileRam2()
{
	// TODO: 在此添加控件通知处理程序代码
	LoadFile(2);
}


void FlashAndRamDlg::OnBnClickedButton5()//选择用户程序
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	CFileDialog dlg(TRUE, _T("bit"), _T(""), OFN_HIDEREADONLY, _T("Bit文件|*.bit||"));
	if (dlg.DoModal() == IDOK)
	{
		CString pn = dlg.GetPathName();
		userbit = pn;
		WritePrivateProfileString("BitFile", "user", userbit, ".\\config.ini");
	}
}


void FlashAndRamDlg::OnBnClickedButton6()//下载用户程序
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	CFileStatus fs;
	if(!CFile::GetStatus(userbit.GetBuffer(0), fs)) {
		MessageBox("请选择用户程序");
		return;
	}

	FILE *fout = fopen("program.cmd", "w");
	fprintf(fout, "setMode -bscan\n");
	fprintf(fout, "setCable -p auto\n");
	//fprintf(fout, "addDevice -position 1 -file flashram.bit\n");
	fprintf(fout, "addDevice -position 1 -file %s\n", userbit.GetBuffer(0));
	fprintf(fout, "ReadIdcode -p 1\n");
	fprintf(fout, "program -p 1\n");
	fprintf(fout, "quit\n");
	fclose(fout);
	system("impact -batch program.cmd");
}


void FlashAndRamDlg::OnBnClickedReadRam1()//读ram1
{
	// TODO: 在此添加控件通知处理程序代码
	ReadData(1);
}


void FlashAndRamDlg::OnBnClickedReadRam2()//读ram2
{
	// TODO: 在此添加控件通知处理程序代码
	ReadData(2);
}


void FlashAndRamDlg::OnBnClickedWriteRam1()//写ram1
{
	// TODO: 在此添加控件通知处理程序代码
	WriteData(1);
}


void FlashAndRamDlg::OnBnClickedWriteRam2()//写ram2
{
	// TODO: 在此添加控件通知处理程序代码
	WriteData(2);
}


void FlashAndRamDlg::OnBnClickedFlash()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	setActive(0);
}


void FlashAndRamDlg::OnBnClickedRam1()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	setActive(1);
}


void FlashAndRamDlg::OnBnClickedRam2()
{
	// TODO: 在此添加控件通知处理程序代码
	if (timertype != 0) return;
	setActive(2);
}

void FlashAndRamDlg::setActive(int id)
{
	curID = id;
	char label[10] = {0};
	switch (id) {
	case 0:
		sprintf(label, "Flash");
		break;
	case 1:
		sprintf(label, "Ram1");
		break;
	case 2:
		sprintf(label, "Ram2");
	}
	CString buf;
	buf.Format("读取%s", label);
	((CButton *)GetDlgItem(IDC_READ_FLASH))->SetWindowTextA(buf);
	buf.Format("写入%s", label);
	((CButton *)GetDlgItem(IDC_WRITE_FLASH))->SetWindowTextA(buf);
	((CButton *)GetDlgItem(IDC_ERASE))->ShowWindow(id == 0);
	buf.Format("载入到%s", label);
	((CButton *)GetDlgItem(IDC_FILE_FLASH))->SetWindowTextA(buf);
	buf.Format("清空%s数据", label);
	((CButton *)GetDlgItem(IDC_CLEAR))->SetWindowTextA(buf);

	
}

void FlashAndRamDlg::OnTimer(UINT_PTR nIDEvent)
{
	// TODO: 在此添加消息处理程序代码和/或调用默认值
	int a, b;

	switch (timertype) {
	case 1://read
		timertype = 0;
		ReadDataTimer(timerid, timerst, timered);
		break;
	case 2://write
		timertype = 0;
		WriteDataTimer(timerid, timerst, timered);
		break;
	case 3://write!!!
		timertype = 0;
		a = this->st[this->st.size() - 1];
		b = this->ed[this->ed.size() - 1];
		this->st.pop_back();
		this->ed.pop_back();
		WriteData(timerid, a, b);
		break;
	default:
		;
	}

	CDialog::OnTimer(nIDEvent);
}
