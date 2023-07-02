
// ConnectivityManagerClientDlg.h : header file
//

#pragma once


// CConnectivityManagerClientDlg dialog
class CConnectivityManagerClientDlg : public CDialogEx
{
// Construction
public:
	CConnectivityManagerClientDlg(CWnd* pParent = nullptr);	// standard constructor

// Dialog Data
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_CONNECTIVITYMANAGERCLIENT_DIALOG };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedBtnStartServer();
	
	afx_msg void OnBnClickedBtnStopServer();
	
	afx_msg void OnBnClickedBtnStopConnect();
	afx_msg void OnBnClickedBtnStartConnect();
	afx_msg void OnBnClickedBtnClientSendTest();
	afx_msg void OnBnClickedBtnServerSend();
	afx_msg void OnBnClickedBtnConnect2();
	afx_msg void OnBnClickedBtnDisconnect2();
	CEdit mToClientMsgInput;
	CEdit mToClientIPInput;
	CEdit mClientSendToServerMsg;
};
