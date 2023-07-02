#pragma once
#include <string>
#include "ClientsMgr.h"
using namespace std;
class TCPServer
{

public:
	TCPServer(string remotehost, unsigned short remoteport);
	bool StartTcpServer();
	bool StopTcpServer(void);
	bool IsTcpServerRunning(void);
	static DWORD WINAPI ThreadTcpServerLoop(LPVOID ivalue);
	void StartCliendHandlerThread(SOCKET socket, string clientIP);

	string GetRemoteHostIP();
	unsigned short GetRemotePort();

	bool SendMessageToClient(string msg, string clientIP);

	

private:

	

	void SetServerExitEvent();
	void CloseAllClients();
	void ServerCleanup(void);

private:


	ClientsMgr * mClientMgr;

	string mRemoteHost;
	unsigned short mRemotePort;

	HANDLE hEndTcpServerEvent = INVALID_HANDLE_VALUE;
	int NumEvents;
	HANDLE hListenEvent = INVALID_HANDLE_VALUE;
	SOCKET Listen = INVALID_SOCKET;

	DWORD ThreadTcpServerID;
	HANDLE hThreadServerHandle = INVALID_HANDLE_VALUE;
	HANDLE hTestTcpServerEvent = INVALID_HANDLE_VALUE;

};

