#pragma once
#include <string>
using namespace std;
class TCPClient
{
public:
	TCPClient(string remotehost,unsigned short remoteport);

private:
	bool IsRunning;

	string remotehost;
	unsigned short remoteport;
	SOCKET mClient;

	
	 

	 DWORD ThreadTcpClientID;
	 HANDLE hThreaTcpClient ;


	 HANDLE hTimer = INVALID_HANDLE_VALUE;

	 HANDLE hClientEvent = INVALID_HANDLE_VALUE;
	 HANDLE hEndTcpClientEvent = INVALID_HANDLE_VALUE;

	 int NumEvents;


public:
	bool StartTcpClientThread();
	bool StopTcpClient();

	bool IsTcpClientRunning();

	void SendMessageToServer(string message);

	string GetRemoteHost() {
		return remotehost;
	};
	unsigned short GetRemotePort() {
		return remoteport;
	};



private:

	bool ConnectToSever();
    static DWORD WINAPI ThreadTcpClientLoop(LPVOID ivalue);
	void SendHeartBeatToServer();
	void TcpClientCleanup(void);
	void TcpClientSetExitEvent(void);

	 
};

