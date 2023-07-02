#pragma once

#include <Windows.h>
#include <gst\gst.h>
#include <gst\video\video.h>
#include <string>

class StreamingPlayer {

public:
	StreamingPlayer(HWND wnd);
	~StreamingPlayer();

	bool LoadLocalFile(std::string path);
	bool Play();
	bool Pause();
	bool Stop();

private:
	bool CreatePipeline();
	bool ChangePlaybinState(GstState state);
	static GstBusSyncReply bus_sync_handler(GstBus* bus, GstMessage* message, StreamingPlayer* player);

	HWND vidOutputContainer;
	GstElement* playbin;
	void set_uri(const gchar* uri);
};
