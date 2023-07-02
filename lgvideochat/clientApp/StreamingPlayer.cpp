#include "StreamingPlayer.h"
#include <Windows.h>

StreamingPlayer::StreamingPlayer(HWND wnd) : vidOutputContainer(wnd), playbin(NULL)
{
	gst_init(0, NULL);

	CreatePipeline();
}

bool StreamingPlayer::CreatePipeline()
{

	gchar* descr = g_strdup(
		"udpsrc multicast-group=224.0.10.2 auto-multicast=true port=5000 "
		"! application/x-rtp, payload=26 ! rtpjpegdepay ! jpegdec ! autovideosink "
	);
	GError* error = nullptr;
	playbin = gst_parse_launch(descr, &error);

	GstBus* bus = gst_element_get_bus(playbin);
	gst_bus_set_sync_handler(bus, (GstBusSyncHandler)bus_sync_handler, this, NULL);

	return true;
}

GstBusSyncReply StreamingPlayer::bus_sync_handler(GstBus* bus, GstMessage* message, StreamingPlayer* player)
{
	// ignore anything but 'prepare-window-handle' element messages
	if (!gst_is_video_overlay_prepare_window_handle_message(message))
		return GST_BUS_PASS;

	if (player->vidOutputContainer != NULL)
	{
		GstVideoOverlay* overlay;
		overlay = GST_VIDEO_OVERLAY(GST_MESSAGE_SRC(message));
		gst_video_overlay_set_window_handle(overlay, (guintptr)player->vidOutputContainer);
	}

	gst_message_unref(message);

	return GST_BUS_DROP;
}

bool StreamingPlayer::Play()
{
	return ChangePlaybinState(GST_STATE_PLAYING);
}

bool StreamingPlayer::Pause()
{
	return ChangePlaybinState(GST_STATE_PAUSED);
}

bool StreamingPlayer::Stop()
{
	return ChangePlaybinState(GST_STATE_READY);
}

bool StreamingPlayer::ChangePlaybinState(GstState state)
{
	GstStateChangeReturn m_Ret = gst_element_set_state(playbin, state);

	switch (m_Ret) {
	case GST_STATE_CHANGE_FAILURE:
		g_print("State Change Failure\n");
		return false;
		break;
	}
	return true;
}

StreamingPlayer::~StreamingPlayer()
{
	gst_element_set_state(playbin, GST_STATE_NULL);
	gst_object_unref(GST_OBJECT(playbin));
}

