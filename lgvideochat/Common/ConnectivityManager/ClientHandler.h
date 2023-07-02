#pragma once
#include <string>
using namespace std;
class ClientHandler
{  
public:
	ClientHandler(SOCKET socket, string ip);



	bool StartClientHandlingThread();

	bool StopClientHandling();

	bool SendDataToClient(string msg);
	
private:

	static DWORD WINAPI ThreadTcpClientHandlingLoop(LPVOID ivalue);

	void SetClientExitEvent(void);
	void AcceptClientCleanup(void);


public:
	SOCKET  clientSocket;
	string clientIP;

private:

	DWORD ThreadTcpAcceptedClientID;
	HANDLE hThreaTcpAcceptedClient;

	HANDLE hAcceptEvent = INVALID_HANDLE_VALUE;
	int NumEvents;
	HANDLE hEndTcpClientEvent = INVALID_HANDLE_VALUE;

	HANDLE hTimer = INVALID_HANDLE_VALUE;

	
};

