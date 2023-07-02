#include "Streamer.h"
#include <iostream>

void Streamer::stream(std::string host) {
	gst_init(0, NULL);

	std::string str = "autovideosrc ! video/x-raw,width=640,height=480 ! videoconvert ! jpegenc ! rtpjpegpay ! udpsink ";
	str.append("host=224.0.10.2 ");
	str.append(" auto-multicast=true");
	str.append(" port=5000");

	std::cout << str << std::endl;

	gchar* descr = g_strdup(str.c_str());

	GError* error = nullptr;
	pipeline = gst_parse_launch(descr, &error);
	GstStateChangeReturn ret = gst_element_set_state(pipeline, GST_STATE_PLAYING);

	switch (ret) {
	case GST_STATE_CHANGE_FAILURE:
		g_print("State Change Failure\n");
		break;
	}
}