#include "pch.h"
#include "TCPClient.h"
#include <string>
#include <iostream>
#include <ws2tcpip.h> 
#include "TCPDataHelper.h"
using namespace std;

#pragma comment(lib, "ws2_32.lib")




TCPClient::TCPClient(string remotehost, unsigned short remoteport){

	bool IsRunning = false;

	DWORD ThreadTcpClientID = -1;
	HANDLE hThreaTcpClient = INVALID_HANDLE_VALUE;
	this->remotehost = remotehost;
	this->remoteport = remoteport;
	mClient = INVALID_SOCKET;

	hTimer = INVALID_HANDLE_VALUE;

	hClientEvent = INVALID_HANDLE_VALUE;
	hEndTcpClientEvent = INVALID_HANDLE_VALUE;

	NumEvents =0;
	
}




bool TCPClient::StartTcpClientThread() {

	hThreaTcpClient = CreateThread(NULL, 0, &TCPClient::ThreadTcpClientLoop, this, 0, &ThreadTcpClientID);
	
	return true;
}

void TCPClient::SendHeartBeatToServer() {
	DWORD threadID = GetCurrentThreadId();
	std::cout << "Timer to send Heartbeat client id "<< mClient << " Thread ID " << threadID << std::endl;
	SendMessageToServer(" KEEP ALIVE");

}


bool TCPClient::IsTcpClientRunning(void)
{
	if (hThreaTcpClient == INVALID_HANDLE_VALUE)
	{
		return false;
	}
	else return true;
}


bool TCPClient::StopTcpClient(void)
{
	TcpClientSetExitEvent();
	if (hThreaTcpClient != INVALID_HANDLE_VALUE)
	{
		WaitForSingleObject(hThreaTcpClient, INFINITE);
		CloseHandle(hThreaTcpClient);
		hThreaTcpClient = INVALID_HANDLE_VALUE;
	}
	return true;
}



 void TCPClient::TcpClientSetExitEvent(void)
{
	if (hEndTcpClientEvent != INVALID_HANDLE_VALUE)
		SetEvent(hEndTcpClientEvent);
}
 void TCPClient::TcpClientCleanup(void)
{
	std::cout << "TCPClient::TcpClientCleanup (+)" << std::endl;

	if (hClientEvent != INVALID_HANDLE_VALUE)
	{
		CloseHandle(hClientEvent);
		hClientEvent = INVALID_HANDLE_VALUE;
	}
	if (hEndTcpClientEvent != INVALID_HANDLE_VALUE)
	{
		CloseHandle(hEndTcpClientEvent);
		hEndTcpClientEvent = INVALID_HANDLE_VALUE;
	}
	if (hTimer != INVALID_HANDLE_VALUE)
	{
		CloseHandle(hTimer);
		hTimer = INVALID_HANDLE_VALUE;
	}
	if (mClient != INVALID_SOCKET)
	{
		closesocket(mClient);
		mClient = INVALID_SOCKET;
	}
}



bool TCPClient::ConnectToSever()
{
	std::cout << "TCPClient::ConnectToSever(+)" << std::endl;
	int iResult;
	struct addrinfo   hints;
	struct addrinfo* result = NULL;
	char remoteportno[128];

	sprintf_s(remoteportno, sizeof(remoteportno), "%d", remoteport);

	memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_protocol = IPPROTO_TCP;

	iResult = getaddrinfo(remotehost.c_str(), remoteportno, &hints, &result);
	if (iResult != 0)
	{
		std::cout << "getaddrinfo: Failed" << std::endl;
		return false;
	}
	if (result == NULL)
	{
		std::cout << "getaddrinfo: Failed" << std::endl;
		return false;
	}

	if ((mClient = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) == INVALID_SOCKET)

	{
		freeaddrinfo(result);
		std::cout << "video client socket() failed with error " << WSAGetLastError() << std::endl;
		return false;
	}

	//----------------------
	// Connect to server.
	iResult = connect(mClient, result->ai_addr, (int)result->ai_addrlen);
	freeaddrinfo(result);
	if (iResult == SOCKET_ERROR) {
		std::cout << "connect function failed with error : " << WSAGetLastError() << std::endl;
		iResult = closesocket(mClient);
		mClient = INVALID_SOCKET;
		if (iResult == SOCKET_ERROR)
			std::cout << "closesocket function failed with error :" << WSAGetLastError() << std::endl;
		return false;
	}
	else {
		std::cout << "TCPClient::ConnectToSever()- connect server sucessfully  " << std::endl;
	}


	return true;

}



void TCPClient::SendMessageToServer(string message) {

	std::cout << "TCPClient::SendMessageToServer(+)  " << std::endl;

	TCPDataHelper::WriteDataTcp(mClient, (char*)message.c_str(), message.length());
	
}



DWORD WINAPI TCPClient::ThreadTcpClientLoop(LPVOID ivalue) {

	HANDLE ghEvents[4];
	DWORD dwEvent;
	int iResult;

	TCPClient* target = (TCPClient*)ivalue;

	


	if (target == NULL) {
		return 2;
	}

	bool connectSucess = target->ConnectToSever();
	if (connectSucess == false) {
		std::cout << "Connect to Server FAILED - Stop " << std::endl;
		return 2;
	} 

	
	if (target->mClient == INVALID_SOCKET) {

		std::cout << "Socket Client is NULL - Stop " << std::endl;
		return 2;

	}


	u_long iMode = 1;
	iResult = ioctlsocket(target->mClient, FIONBIO, &iMode);

	// End thread event - to stop client 

	target->hEndTcpClientEvent = CreateEvent(NULL, FALSE, FALSE, NULL);

	//Socket event from system

	target->hClientEvent = WSACreateEvent();

	if (WSAEventSelect(target->mClient, target->hClientEvent, FD_READ | FD_WRITE | FD_CLOSE) == SOCKET_ERROR)

	{
		std::cout << "WSAEventSelect() failed with error " << WSAGetLastError() << std::endl;
		iResult = closesocket(target->mClient);
		target->mClient = INVALID_SOCKET;
		if (iResult == SOCKET_ERROR)
			std::cout << "closesocket function failed with error : " << WSAGetLastError() << std::endl;
		return 4;
	}



	
// Timer to send heart beat
	LARGE_INTEGER liDueTime;

	liDueTime.QuadPart = 0LL;

	target->hTimer = CreateWaitableTimer(NULL, FALSE, NULL);

	if (NULL == target->hTimer)
	{
		std::cout << "CreateWaitableTimer failed " << GetLastError() << std::endl;
		return 2;
	}

	if (!SetWaitableTimer(target->hTimer, &liDueTime, 10000, NULL, NULL, 0))
	{
		std::cout << "SetWaitableTimer failed  " << GetLastError() << std::endl;
		return 3;
	}

	
	ghEvents[0] = target->hEndTcpClientEvent;
	ghEvents[1] = target->hClientEvent;
	ghEvents[2] = target->hTimer;
	target->NumEvents = 3;
	std::cout << "TCP client WaitForMultipleObjects (+)" << std::endl;
	char buf[1024];
	while (1) {

		dwEvent = WaitForMultipleObjects(
			target->NumEvents,        // number of objects in array
			ghEvents,       // array of objects
			FALSE,           // wait for any object
			INFINITE);  // INFINITE) wait

		if (dwEvent == WAIT_OBJECT_0) {
			//Stop thread
			std::cout << "TCP client stop event raised  " << std::endl;
			break;
			
		}
		else if(dwEvent == WAIT_OBJECT_0 + 1 ) {

			//std::cout << "TCP client FD READ, WRITE  " << std::endl;
			WSANETWORKEVENTS NetworkEvents;
			if (SOCKET_ERROR == WSAEnumNetworkEvents(target->mClient, target->hClientEvent, &NetworkEvents))
			{
				std::cout << "WSAEnumNetworkEvent: " << WSAGetLastError() << " dwEvent  " << dwEvent << " lNetworkEvent " << std::hex << NetworkEvents.lNetworkEvents << std::endl;
				NetworkEvents.lNetworkEvents = 0;
			}
			else {
				if (NetworkEvents.lNetworkEvents & FD_READ) {
					if (NetworkEvents.iErrorCode[FD_READ_BIT] != 0)
					{
						std::cout << "FD_READ failed with error " << NetworkEvents.iErrorCode[FD_READ_BIT] << std::endl;
					}
					else
					{
						std::cout << "TCPClient FD_READ" << std::endl;

						ZeroMemory(buf, 1024);
						TCPDataHelper::ReadDataTcpNoBlock(target->mClient, buf, 1024);
						std::cout << "TCPClient READ FD_READ DATA KHANH: " << buf << std::endl;
					}

				}
				if (NetworkEvents.lNetworkEvents & FD_WRITE) {
					if (NetworkEvents.iErrorCode[FD_WRITE_BIT] != 0)
					{
						std::cout << "FD_WRITE failed with error " << NetworkEvents.iErrorCode[FD_WRITE_BIT] << std::endl;
					}
					else
					{
						std::cout << "FD_WRITE" << std::endl;

					}

				}
				if (NetworkEvents.lNetworkEvents & FD_CLOSE) {

					if (NetworkEvents.iErrorCode[FD_CLOSE_BIT] != 0){
						std::cout << "FD_CLOSE failed with error " << NetworkEvents.iErrorCode[FD_CLOSE_BIT] << std::endl;
						//TODO - have check to break or not
					}
					else
					{
						std::cout << "FD_CLOSE" << std::endl;
						break;
					}

				}

			}

			
		}
		else if (dwEvent == WAIT_OBJECT_0 + 2) {

		//	std::cout << "TCP client Heart beat event  " << std::endl;
			if (target != NULL) {
				target->SendHeartBeatToServer();
			}
		}
			
	}// end while

	target->TcpClientCleanup();

	return 0;



 }