
// ConnectivityManagerClientDlg.cpp : implementation file
//

#include "pch.h"
#include "framework.h"
#include "ConnectivityManagerClient.h"
#include "ConnectivityManagerClientDlg.h"
#include "afxdialogex.h"

#include <string>
#include <iostream>
using namespace std;

#include "IConnectivity.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAboutDlg dialog used for App About

static void SetStdOutToNewConsole(void);

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// Dialog Data
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_ABOUTBOX };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(IDD_ABOUTBOX)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CConnectivityManagerClientDlg dialog



CConnectivityManagerClientDlg::CConnectivityManagerClientDlg(CWnd* pParent /*=nullptr*/)
	: CDialogEx(IDD_CONNECTIVITYMANAGERCLIENT_DIALOG, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CConnectivityManagerClientDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT2, mToClientMsgInput);
	DDX_Control(pDX, IDC_EDIT3, mToClientIPInput);
	DDX_Control(pDX, IDC_EDIT1, mClientSendToServerMsg);
}

BEGIN_MESSAGE_MAP(CConnectivityManagerClientDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(ID_BTN_START_SERVER, &CConnectivityManagerClientDlg::OnBnClickedBtnStartServer)	
	ON_BN_CLICKED(ID_BTN_STOP_SERVER, &CConnectivityManagerClientDlg::OnBnClickedBtnStopServer)
	ON_BN_CLICKED(IDC_BTN_STOP_CONNECT, &CConnectivityManagerClientDlg::OnBnClickedBtnStopConnect)
	ON_BN_CLICKED(IDC_BTN_START_CONNECT, &CConnectivityManagerClientDlg::OnBnClickedBtnStartConnect)
	ON_BN_CLICKED(IDC_BTN_CLIENT_SEND_TEST, &CConnectivityManagerClientDlg::OnBnClickedBtnClientSendTest)
	ON_BN_CLICKED(IDC_BTN_SERVER_SEND, &CConnectivityManagerClientDlg::OnBnClickedBtnServerSend)
	ON_BN_CLICKED(IDC_BTN_CONNECT2, &CConnectivityManagerClientDlg::OnBnClickedBtnConnect2)
	ON_BN_CLICKED(IDC_BTN_DISCONNECT2, &CConnectivityManagerClientDlg::OnBnClickedBtnDisconnect2)
END_MESSAGE_MAP()


// CConnectivityManagerClientDlg message handlers

BOOL CConnectivityManagerClientDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != nullptr)
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

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here

	SetStdOutToNewConsole();

	return TRUE;  // return TRUE  unless you set the focus to a control
}

static FILE* pCout = NULL;

static void SetStdOutToNewConsole(void)
{
	// Allocate a console for this app
	AllocConsole();
	//AttachConsole(ATTACH_PARENT_PROCESS);
	freopen_s(&pCout, "CONOUT$", "w", stdout);
}

void CConnectivityManagerClientDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CConnectivityManagerClientDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CConnectivityManagerClientDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}



void CConnectivityManagerClientDlg::OnBnClickedBtnStartServer()
{
	IConnectivity* instance = GetInstance();
	instance->StartTcpServer("127.0.0.1", 10000);
	
}




void CConnectivityManagerClientDlg::OnBnClickedBtnStopServer()
{

	IConnectivity* instance = GetInstance();
	instance->StopTcpServer();
}




void CConnectivityManagerClientDlg::OnBnClickedBtnStopConnect()
{
	IConnectivity* instance = GetInstance();
	instance->StopTcpClient("127.0.0.1", 10000);
}


void CConnectivityManagerClientDlg::OnBnClickedBtnStartConnect()
{
	IConnectivity* instance = GetInstance();
	instance->ConnectTcpSocket("127.0.0.1", 10000);

}


void CConnectivityManagerClientDlg::OnBnClickedBtnClientSendTest()
{

	CString toServerMsg = _T("");
	mClientSendToServerMsg.GetWindowTextW(toServerMsg);
	

	std::string msg(CW2A(toServerMsg.GetString()));


	std::cout << "OnBnClickedBtnClientSendTest send data to server msg  " << msg << std::endl;

	if (msg.empty()) {
		std::cout << "OnBnClickedBtnClientSendTest Cannot send because invalid data " << std::endl;

		return;
	}
	IConnectivity* instance = GetInstance();
	instance->SendMessageToServer(msg, "127.0.0.1", 10000);
}


void CConnectivityManagerClientDlg::OnBnClickedBtnServerSend()
{

	CString toClientMsg = _T("");
	CString toCLientIP = _T("");
	mToClientMsgInput.GetWindowTextW(toClientMsg);
	mToClientIPInput.GetWindowTextW(toCLientIP);

	std::string msg(CW2A(toClientMsg.GetString()));
	std::string clientIP(CW2A(toCLientIP.GetString()));

	std::cout << "OnBnClickedBtnServerSend send data to client msg  " << msg << " client IP :  " << clientIP << std::endl;

	if (msg.empty() || clientIP.empty()) {
		std::cout << "OnBnClickedBtnServerSend Cannot send because invalid data "<<std::endl;

		return;
	}


	IConnectivity* instance = GetInstance();

	instance->SendMessageToClient(msg, clientIP);
}


void CConnectivityManagerClientDlg::OnBnClickedBtnConnect2()
{
	IConnectivity* instance = GetInstance();
	instance->ConnectTcpSocket("127.0.0.1", 10000);
}


void CConnectivityManagerClientDlg::OnBnClickedBtnDisconnect2()
{

	IConnectivity* instance = GetInstance();

	instance->StopTcpClient("127.0.0.1", 10000);
}
