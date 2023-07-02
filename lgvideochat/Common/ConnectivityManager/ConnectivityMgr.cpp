#include "pch.h"
#include "ConnectivityMgr.h"
#include <iostream>



ConnectivityMgr* ConnectivityMgr::Instance = NULL;





IConnectivity* GetInstance() {

    std::cout << " Testing here" << std::endl;
    return ConnectivityMgr::GetInstance();

}


ConnectivityMgr::ConnectivityMgr()
{
    mTcpServer = NULL;
    InitWinsockFunction();
} 


void ConnectivityMgr::InitWinsockFunction() {

    int iResult;
    WSADATA wsaData;
    iResult = WSAStartup(MAKEWORD(2, 2), &wsaData);
    if (iResult != 0) {
        std::cout << "WSAStartup failed: " << iResult << std::endl;
        return;
    }
}


 ConnectivityMgr* ConnectivityMgr::GetInstance() {
    if (!Instance)
        Instance = new ConnectivityMgr();
    return Instance;
}

 bool ConnectivityMgr::ConnectTcpSocket(string remotehost, unsigned short port) {
     TCPClient*  client = new TCPClient(remotehost, port);
     ClientList.push_back(client);

     client->StartTcpClientThread();


     return true;
 }

  bool ConnectivityMgr::StartTcpServer(string remotehost, unsigned short port) {
      mTcpServer = new TCPServer(remotehost, port);

      mTcpServer->StartTcpServer();

      
      return true;
 }

  bool ConnectivityMgr::StopTcpServer() {
      std::cout << " ConnectivityMgr::StopTcpServer(+)" << std::endl;
      if (mTcpServer != NULL) {
          mTcpServer->StopTcpServer();
          
          //may be delete TCP server here
          mTcpServer = NULL;
      }
      else {

      }

      return true;

  }

  int ConnectivityMgr::FindSocketClientIndex(string remotehost, unsigned short port) {

      for (int i = 0; i < ClientList.size(); i++) {
          TCPClient* client = ClientList.at(i);
          if (client != NULL && client->GetRemoteHost().compare(remotehost) == 0 && client->GetRemotePort() == port) {
              return i;
          }
      }
      return -1;

  }

  bool ConnectivityMgr::StopTcpClient(string remotehost, unsigned short port) {

      int clientIdx= FindSocketClientIndex( remotehost,  port);
      if (clientIdx != -1 && ClientList.at(clientIdx) != NULL) {
          ClientList.at(clientIdx)->StopTcpClient(); 
          ClientList.erase(ClientList.begin() + clientIdx);
          return true;
      }
      return false;



  }


  bool ConnectivityMgr::SendMessageToServer(string msg, string remotehost, unsigned short port) {

   

     int clientIdx = FindSocketClientIndex(remotehost, port);
     if (clientIdx != -1 && ClientList.at(clientIdx) != NULL) {
         ClientList.at(clientIdx)->SendMessageToServer(msg);
         
         return true;
     }
     return false;

  }

  bool ConnectivityMgr::SendMessageToClient(string msg, string clientIP) {

      if (mTcpServer != NULL) {
          mTcpServer->SendMessageToClient(msg, clientIP);
      }
      return  true;

  }









