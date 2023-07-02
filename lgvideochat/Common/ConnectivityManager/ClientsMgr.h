#pragma once
#include "ClientHandler.h"
#include <vector>
class ClientsMgr
{

public :
	void AddToListClients(ClientHandler* clientHander);
	bool RemoveClient(ClientHandler* clientHander);

	void CloseAllConnectedClients();
	void SendDataToClient(string msg, string clientIP);

private:
	vector< ClientHandler*> mListClients;
};

