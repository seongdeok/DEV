#include "pch.h"
#include "TCPDataHelper.h"
#include <iostream>
#include <stdio.h>



//-----------------------------------------------------------------
// ReadDataTcp - Reads the specified amount TCP data 
//-----------------------------------------------------------------
int TCPDataHelper::ReadDataTcp(SOCKET socket,  char* data, int length)
{
    if (socket == INVALID_SOCKET) {
        return 0;
    }
   
    std::cout << "recv ReadDataTcp"<< "function "<< __func__ << std::endl;
    int bytes;

    for (size_t i = 0; i < length; i += bytes)
    {
        if ((bytes = recv(socket, (char*)(data + i), (int)(length - i), 0)) == SOCKET_ERROR)
        {
            if (WSAGetLastError() == WSAEWOULDBLOCK)
            {
                std::cout << "recv WSAEWOULDBLOCK" << std::endl;
                bytes = 0;
                Sleep(10);
            }
            else return (SOCKET_ERROR);
        }
    }
    return(length);
}


int TCPDataHelper::ReadDataTcpNoBlock(SOCKET socket, char* data, int length)
{
    if (socket == INVALID_SOCKET) {
        return 0;
    }
    return(recv(socket, (char*)data, length, 0));
}

int TCPDataHelper::WriteDataTcp(SOCKET socket,  char* data, int length)
{
    if (socket == INVALID_SOCKET) {
        return 0;
    }
    int total_bytes_written = 0;
    unsigned int retry_count = 0;
    int bytes_written;
    while (total_bytes_written != length)
    {
        bytes_written = send(socket,
            (char*)(data + total_bytes_written),
            (int)(length - total_bytes_written), 0);
        if (bytes_written == SOCKET_ERROR)
        {
            if (WSAGetLastError() == WSAEWOULDBLOCK)
            {
                std::cout << "send WSAEWOULDBLOCK" << std::endl;
                bytes_written = 0;
                retry_count++;
                if (retry_count > 15) return (SOCKET_ERROR);
                else Sleep(10);
            }
            else return (SOCKET_ERROR);
        }
        else retry_count = 0;
        total_bytes_written += bytes_written;
    }
    std::cout << "Write data len: " << total_bytes_written<<std::endl;
}
