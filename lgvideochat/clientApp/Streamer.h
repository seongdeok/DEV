#pragma once

#include <gst\gst.h>
#include <string>

class Streamer
{
public:
	Streamer() {};
	void stream(std::string host);
private:
	GstElement* pipeline = nullptr;
};

