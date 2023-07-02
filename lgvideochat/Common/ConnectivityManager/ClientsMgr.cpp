#include "pch.h"
#include "ClientsMgr.h"
#include <winsock2.h>
#include <iostream>

void ClientsMgr::AddToListClients(ClientHandler* clientHander) {

	// check if already added- add if not exiested 

	if (clientHander == NULL) {
		return;
	}

	for (int i = 0; i < mListClients.size(); i++) {
		if (mListClients.at(i) == clientHander) {
			return;
		}

	}

	mListClients.push_back(clientHander);
	

}
bool ClientsMgr::RemoveClient(ClientHandler* clientHander) {

	return true;

}

void ClientsMgr::CloseAllConnectedClients() {
	std::cout << " ClientsMgr::CloseAllConnectedClients(+)" << std::endl;
	for (int i = 0; i < mListClients.size(); i++) {
		
		if (mListClients.at(i) != NULL) {
			mListClients.at(i)->StopClientHandling();
			SOCKET socket = mListClients.at(i)->clientSocket;
			if (socket != INVALID_SOCKET) {
				closesocket(socket);
				socket = INVALID_SOCKET;
			}
		}


	}
}

void  ClientsMgr::SendDataToClient(string msg, string clientIP) {

	std::cout << " ClientsMgr::SendDataToClient(+)" << std::endl;
	for (int i = 0; i < mListClients.size(); i++) {
		ClientHandler* cliendHandler = mListClients.at(i);
		if (cliendHandler == NULL) {
			break;
		}
		
		std::cout << " ClientsMgr::SendDataToClient Client IP: " << cliendHandler->clientIP << std::endl;

		if ( cliendHandler->clientIP.compare(clientIP) ==0 ){
			cliendHandler->SendDataToClient(msg);
			
		}


	}

}


