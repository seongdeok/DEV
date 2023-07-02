#pragma once
#include "IConnectivity.h"
#include <string>
#include <vector>
#include "TCPClient.h"
#include "TCPServer.h"

using namespace std;



class ConnectivityMgr : public IConnectivity
{
private:
	ConnectivityMgr();
	static ConnectivityMgr* Instance;
	string  Name;

	vector<TCPClient*> ClientList;

	TCPServer* mTcpServer;



public:

	// deleting copy constructor
	ConnectivityMgr(const ConnectivityMgr& obj) = delete;
	static ConnectivityMgr* GetInstance();


	bool ConnectTcpSocket(string remotehost, unsigned short port);
	bool StartTcpServer(string remotehost, unsigned short port) ;
	bool StopTcpServer();
	bool StopTcpClient(string remotehost, unsigned short port);
	bool SendMessageToServer(string msg, string remotehost, unsigned short port);
	bool SendMessageToClient(string msg, string clientIP);

private:
	void InitWinsockFunction();
	int FindSocketClientIndex(string remotehost, unsigned short port);



};

