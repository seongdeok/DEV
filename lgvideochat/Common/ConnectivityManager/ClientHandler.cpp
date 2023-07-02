#include "pch.h"
#include "ClientHandler.h"
#include "TCPDataHelper.h"
#include <iostream>





ClientHandler::ClientHandler(SOCKET socket, string ip) {

	clientSocket = socket;
	clientIP = ip;

	ThreadTcpAcceptedClientID = -1;
    hThreaTcpAcceptedClient = INVALID_HANDLE_VALUE;

	hAcceptEvent = INVALID_HANDLE_VALUE;
    NumEvents =0;
	hEndTcpClientEvent = INVALID_HANDLE_VALUE;

	hTimer = INVALID_HANDLE_VALUE;
	


}


bool ClientHandler::StartClientHandlingThread() {
	hThreaTcpAcceptedClient = CreateThread(NULL, 0, &ClientHandler::ThreadTcpClientHandlingLoop, this, 0, &ThreadTcpAcceptedClientID);
	return true;
}


bool ClientHandler::StopClientHandling() {
	SetClientExitEvent();
	AcceptClientCleanup();

	// do something more

	return true;//TODO

}

bool ClientHandler::SendDataToClient(string msg) {

	std::cout << " ClientHandler::SendDataToClient(+)" << std::endl;
	
	TCPDataHelper::WriteDataTcp(clientSocket, (char*)msg.c_str(), msg.length());
	return true;

}

void ClientHandler::SetClientExitEvent(void) {

	if (hEndTcpClientEvent != INVALID_HANDLE_VALUE)
		SetEvent(hEndTcpClientEvent);

}

void ClientHandler::AcceptClientCleanup(void)
{
	
	if (hAcceptEvent != INVALID_HANDLE_VALUE)
	{
		CloseHandle(hAcceptEvent);
		hAcceptEvent = INVALID_HANDLE_VALUE;
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


	if (clientSocket != INVALID_SOCKET)
	{
		closesocket(clientSocket);
		clientSocket = INVALID_SOCKET;
	}
	
}



 DWORD WINAPI ClientHandler::ThreadTcpClientHandlingLoop(LPVOID ivalue) {

	 // should has 2 kind of event 
	 //1->   and stop event ( manually )
	 //2-> SOCKET Event from system automatically 
	 std::cout << "ClientHandler::ThreadTcpClientHandlingLoop (+) " << std::endl;

	 HANDLE ghEvents[3];
	 DWORD dwEvent;


	 ClientHandler* target = (ClientHandler*)ivalue;
	 if (target == NULL) {
		 std::cout << "ClientHandler::ThreadTcpClientHandlingLoop error target  is null " << std::endl;
		 return 2;
	 }


	 target->hEndTcpClientEvent = CreateEvent(NULL, FALSE, FALSE, NULL);

	// hTestTcpClientEvent = CreateEvent(NULL, FALSE, FALSE, NULL);

	 target->hAcceptEvent = WSACreateEvent();
	 if (WSAEventSelect(target->clientSocket, target->hAcceptEvent, FD_READ | FD_WRITE | FD_CLOSE)) {
		 std::cout << "WSAEventSelect() failed with error " << WSAGetLastError() << std::endl;
		 return 1;

	 }



	 LARGE_INTEGER liDueTime;
	 liDueTime.QuadPart = 0LL;

	target->hTimer = CreateWaitableTimer(NULL, FALSE, NULL);

	 if (NULL == target->hTimer)
	 {
		 std::cout << "CreateWaitableTimer failed " << GetLastError() << std::endl;
		 return  2;
	 }

	 if (!SetWaitableTimer(target->hTimer, &liDueTime, 10000, NULL, NULL, 0))
	 {
		 std::cout << "SetWaitableTimer failed  " << GetLastError() << std::endl;
		 return 2;
	 }




	 ghEvents[0] = target->hEndTcpClientEvent;
	 ghEvents[1] = target->hAcceptEvent;
	// ghEvents[2] = hTimer;
	 target->NumEvents = 2;

	 std::cout << "ClientHandler::WaitForMultipleObjects (+) ^^^^^^^^^^^^^^ " << std::endl;
	 char buf[1024];
	 while (1) {

		 
		 dwEvent = WaitForMultipleObjects(
			 target->NumEvents,        // number of objects in array
			 ghEvents,       // array of objects
			 FALSE,           // wait for any object
			 INFINITE);  // INFINITE) wait


		 if (dwEvent == WAIT_OBJECT_0) {

			 std::cout << "ClientHandler  TEST  EVENT WAIT_OBJECT_0" << std::endl;
			// break;// stop 
		 }
		 else if (dwEvent == WAIT_OBJECT_0 + 1)// socket event
		 {

			 //std::cout << "TCP client FD READ, WRITE  " << std::endl;
			 WSANETWORKEVENTS NetworkEvents;
			 if (SOCKET_ERROR == WSAEnumNetworkEvents(target->clientSocket, target->hAcceptEvent, &NetworkEvents))
			 {
				 std::cout << "WSAEnumNetworkEvent: " << WSAGetLastError() << " dwEvent  " << dwEvent << " lNetworkEvent " << std::hex << NetworkEvents.lNetworkEvents << std::endl;
				 NetworkEvents.lNetworkEvents = 0;
			 }
			 else {
				 if (NetworkEvents.lNetworkEvents & FD_READ) {
					 if (NetworkEvents.iErrorCode[FD_READ_BIT] != 0)
					 {
						 std::cout << "ClientHandler FD_READ failed with error " << NetworkEvents.iErrorCode[FD_READ_BIT] << std::endl;
					 }
					 else
					 {
						 std::cout << "ClientHandler FD_READ" << std::endl;
						 ZeroMemory(buf, 1024);
                         TCPDataHelper::ReadDataTcpNoBlock(target->clientSocket, buf, 1024);
						 std::cout << "ClientHandler FD_READ DATA KHANH: "<< buf << std::endl;

					 }

				 }
				 if (NetworkEvents.lNetworkEvents & FD_WRITE) {
					 if (NetworkEvents.iErrorCode[FD_WRITE_BIT] != 0)
					 {
						 std::cout << "ClientHandler FD_WRITE failed with error " << NetworkEvents.iErrorCode[FD_WRITE_BIT] << std::endl;
					 }
					 else
					 {
						 std::cout << "ClientHandler FD_WRITE" << std::endl;
					 }

				 }
				 if (NetworkEvents.lNetworkEvents & FD_CLOSE) {

					 if (NetworkEvents.iErrorCode[FD_CLOSE_BIT] != 0) {
						 std::cout << "ClientHandler FD_CLOSE failed with error " << NetworkEvents.iErrorCode[FD_CLOSE_BIT] << std::endl;
						 //TODO - have check to break or not
					 }
					 else
					 {
						 std::cout << "ClientHandler FD_CLOSE" << std::endl;
						 break;
					 }

				 }

			 }


		 }
		 else if (dwEvent == WAIT_OBJECT_0 + 2) {// TImer
			// std::cout << "ClientHandler  TIMER EVENT" << std::endl;
		 } 

	 }
	 std::cout << "Accepted Client Handling Thred Stopped" << std::endl;
	 target->AcceptClientCleanup();
	 return 0;


}