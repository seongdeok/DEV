#pragma once

#include <wx\frame.h>
#include <wx\sizer.h>
#include <wx\panel.h>
#include <wx\button.h>
#include "StreamingPlayer.h"
#include "Streamer.h"
#include <wx\textctrl.h>
#include <vector>

class MainWindow : public wxFrame
{
public:
	MainWindow();
		
	~MainWindow();

private:
	wxBoxSizer* mMainSizer;
	wxBoxSizer* mCommandSizer;
	wxFlexGridSizer* mVideoSizer;
	wxPanel* mCommandPanel;
	
	Streamer* mStreamer;
	std::vector<StreamingPlayer*> mPlayerList;
	std::vector<wxPanel*> mVideoPanelList;

	void onStream(wxCommandEvent&);
	void onPlay(wxCommandEvent&);
	void composeVideoLayout();
	void composeCommandLayout();
};

