#pragma once
#include <string>
using namespace std;

class IConnectivity
{
public:

	
	virtual bool ConnectTcpSocket(string remotehost, unsigned short port) = 0;
	virtual bool StartTcpServer(string remotehost, unsigned short port) =0;
	virtual bool StopTcpServer()=0;
	virtual bool StopTcpClient(string remotehost, unsigned short port)=0;
	virtual bool SendMessageToServer(string msg, string remotehost, unsigned short port) = 0;
	virtual bool SendMessageToClient(string msg, string clientIP) = 0;

	
};

IConnectivity* GetInstance();