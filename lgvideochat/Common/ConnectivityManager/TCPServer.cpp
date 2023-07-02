#include "pch.h"
#include "TCPServer.h"
#include "ClientHandler.h"
#include <iostream>
#include <ws2tcpip.h>



TCPServer::TCPServer(string remotehost, unsigned short remoteport) {
	mRemoteHost = remotehost;
	mRemotePort = remoteport;
	mClientMgr = new ClientsMgr();

	hEndTcpServerEvent = INVALID_HANDLE_VALUE;
	int NumEvents = 0;
	hListenEvent = INVALID_HANDLE_VALUE;
	SOCKET Listen = INVALID_SOCKET;

	ThreadTcpServerID = -1;
	hThreadServerHandle = INVALID_HANDLE_VALUE;
	
	

}


bool TCPServer::StartTcpServer() {
	hThreadServerHandle = CreateThread(NULL, 0, &TCPServer::ThreadTcpServerLoop, this, 0, &ThreadTcpServerID);
	return true;

}
bool TCPServer::StopTcpServer(void) {

	SetServerExitEvent();
	if (hThreadServerHandle != INVALID_HANDLE_VALUE)
	{
		WaitForSingleObject(hThreadServerHandle, INFINITE);
		hThreadServerHandle = INVALID_HANDLE_VALUE;
	}
	ServerCleanup();
	return true;

}
bool TCPServer::IsTcpServerRunning(void) {
	if (hThreadServerHandle = INVALID_HANDLE_VALUE) return false;
	else return true;

}

void TCPServer::ServerCleanup(void)
{

	std::cout << " TCPServer::ServerCleanup (+)" << std::endl;
	if (hListenEvent != INVALID_HANDLE_VALUE)
	{
		CloseHandle(hListenEvent);
		hListenEvent = INVALID_HANDLE_VALUE;
	}
	
	if (hEndTcpServerEvent != INVALID_HANDLE_VALUE)
	{
		CloseHandle(hEndTcpServerEvent);
		hEndTcpServerEvent = INVALID_HANDLE_VALUE;
	}
	

	if (Listen != INVALID_SOCKET)
	{
		closesocket(Listen);
		Listen = INVALID_SOCKET;
	}
	CloseAllClients();
	
}

void TCPServer::CloseAllClients() {
	std::cout << " TCPServer::CloseAllClients (+)" << std::endl;

	mClientMgr->CloseAllConnectedClients();
}

string TCPServer::GetRemoteHostIP() {
	return mRemoteHost;
}

void TCPServer::SetServerExitEvent() {
	if (hEndTcpServerEvent != INVALID_HANDLE_VALUE)
		SetEvent(hEndTcpServerEvent);
}



void TCPServer::StartCliendHandlerThread(SOCKET socket, string clientIP ) {
	// new Client Handler
	// Add to list
	// Start Client Handler Thread

	std::cout << " TCPServer::StartCliendHandlerThread (+)" << std::endl;

	ClientHandler* clientHandler = new ClientHandler(socket, clientIP);
	mClientMgr->AddToListClients(clientHandler);
	clientHandler->StartClientHandlingThread();
}


unsigned short TCPServer::GetRemotePort() {
	return mRemotePort;

}

bool TCPServer::SendMessageToClient(string msg, string clientIP) {
	if (mClientMgr != NULL) {

		mClientMgr->SendDataToClient(msg, clientIP);
	}
	

	return true;

}

DWORD WINAPI TCPServer::ThreadTcpServerLoop(LPVOID ivalue) {

	std::cout << "ThreadTcpServerLoop(+)" << endl;

	HANDLE ghEvents[3];
	DWORD dwEvent;
	SOCKADDR_IN InternetAddr;

	TCPServer* target = (TCPServer*)ivalue;
	if (target == NULL) {
		std::cout << " TCPServer::ThreadTcpServerLoop - error target is null " << std::endl;
		return 2;
	}

	target->hEndTcpServerEvent = CreateEvent(NULL, FALSE, FALSE, NULL);

	target->hTestTcpServerEvent = CreateEvent(NULL, FALSE, FALSE, NULL);

	if ((target->Listen = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET)
	{
		std::cout << "socket() failed with error " << WSAGetLastError() << std::endl;
		return 1;
	}

	u_long iMode = 1;
	int  iResult = ioctlsocket(target->Listen, FIONBIO, &iMode);

	target->hListenEvent = WSACreateEvent();

	if (WSAEventSelect(target->Listen, target->hListenEvent, FD_ACCEPT | FD_CLOSE) == SOCKET_ERROR)
	{
		std::cout << "WSAEventSelect() failed with error " << WSAGetLastError() << std::endl;
		return 1;
	}

	InternetAddr.sin_family = AF_INET;
	InternetAddr.sin_addr.s_addr = htonl(INADDR_ANY);
	InternetAddr.sin_port = htons(target->GetRemotePort());


	if (bind(target->Listen, (PSOCKADDR)&InternetAddr, sizeof(InternetAddr)) == SOCKET_ERROR)

	{
		std::cout << "bind() failed with error " << WSAGetLastError() << std::endl;
		return 1;
	}

	if (listen(target->Listen, 5))

	{
		std::cout << "listen() failed with error " << WSAGetLastError() << std::endl;
		return 1;
	}

	ghEvents[0] = target->hEndTcpServerEvent;
	ghEvents[1] = target->hListenEvent;
	target->NumEvents = 2;


	std::cout << "TCP sever -  bind socket sucessfully , start thread for listenning " << std::endl;
	std::cout << "TCP server WaitForMultipleObjects (+)" << std::endl;

	while (1) {

		
		dwEvent = WaitForMultipleObjects(
			target->NumEvents,        // number of objects in array
			ghEvents,       // array of objects
			FALSE,           // wait for any object
			INFINITE);  // INFINITE) wait

		if (dwEvent == WAIT_OBJECT_0) {
			// Stop the thread
			std::cout << "TCp server - event to stop listenning thread" << std::endl;
			break;

		}
		else if (dwEvent == WAIT_OBJECT_0 + 1) {// accept. after accept from server side can read , write via accepted socket in client handler

			WSANETWORKEVENTS NetworkEvents;
            if (SOCKET_ERROR == WSAEnumNetworkEvents(target->Listen, target->hListenEvent, &NetworkEvents))
            {
                std::cout << "WSAEnumNetworkEvent: " << WSAGetLastError() << " dwEvent  " << dwEvent << " lNetworkEvent " << std::hex << NetworkEvents.lNetworkEvents << std::endl;
                NetworkEvents.lNetworkEvents = 0;
            }
            else
            {
                if (NetworkEvents.lNetworkEvents & FD_ACCEPT)

                {
                    if (NetworkEvents.iErrorCode[FD_ACCEPT_BIT] != 0)
                    {
                        std::cout << "FD_ACCEPT failed with error " << NetworkEvents.iErrorCode[FD_ACCEPT_BIT] << std::endl;
                    }
                    else
                    {
						struct sockaddr_storage sa;
						socklen_t sa_len = sizeof(sa);
						char ClientIp[INET6_ADDRSTRLEN];
						// Accept a new connection, and add it to the socket and event lists
						SOCKET Accept = accept(target->Listen, (struct sockaddr*)&sa, &sa_len);

						int err = getnameinfo((struct sockaddr*)&sa, sa_len, ClientIp, sizeof(ClientIp), 0, 0, NI_NUMERICHOST);
						if (err != 0) {
							snprintf(ClientIp, sizeof(ClientIp), "invalid address");
						}
						else
						{
							std::cout << "Accepted Connection client IP " << ClientIp << std::endl;

							/// start ClientHandler Here
							target->StartCliendHandlerThread(Accept, ClientIp);
							

						}
  
                      
                    }

                }
                else if (NetworkEvents.lNetworkEvents & FD_CLOSE)
                {
                    if (NetworkEvents.iErrorCode[FD_CLOSE_BIT] != 0)

                    {
                        std::cout << "FD_CLOSE failed with error on Listen Socket" << NetworkEvents.iErrorCode[FD_CLOSE_BIT] << std::endl;
						//TODO - have check to break or not
                    }
					else {
						std::cout << "FD_CLOSE" << std::endl;
						break;
					}

                    
                }
            }





		}// end  WAIT_OBJECT_0 + 1 event
		

	}// end while
	
	

	
	
	std::cout << " TCPServer::ThreadTcpServerLoop(-) Server Stopped" << std::endl;
	target->ServerCleanup();
	return 0;


}

