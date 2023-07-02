#pragma once

class TCPDataHelper
{
public:
	static int ReadDataTcp(SOCKET socket,  char* data, int length);
	static int ReadDataTcpNoBlock(SOCKET socket,  char* data, int length);
	static int WriteDataTcp(SOCKET socket,  char* data, int length);
};

