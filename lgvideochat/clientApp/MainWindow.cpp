#include "MainWindow.h"

static wxTextCtrl* TextCtrl2;

MainWindow::MainWindow() : wxFrame(NULL, wxID_ANY, "wxGstreamer")
{
	mMainSizer = new wxBoxSizer(wxVERTICAL);
	mStreamer = new Streamer();

	composeCommandLayout();
	composeVideoLayout();
	

	SetSizer(mMainSizer);

}

void MainWindow::composeCommandLayout()
{

	mCommandPanel = new wxPanel(this, wxID_ANY);
	mCommandSizer = new wxBoxSizer(wxVERTICAL);
	mCommandPanel->SetSizer(mCommandSizer);
	
	wxButton* bt = new wxButton(mCommandPanel, wxID_ANY, "Stream");
	bt->Bind(wxEVT_BUTTON, &MainWindow::onStream, this);
	mCommandSizer->Add(bt, wxSizerFlags().Proportion(1).Expand().Border());

	wxButton* bt2 = new wxButton(mCommandPanel, wxID_ANY, "Play");
	bt2->Bind(wxEVT_BUTTON, &MainWindow::onPlay, this);
	mCommandSizer->Add(bt2, wxSizerFlags().Proportion(1).Expand().Border());

	TextCtrl2 = new wxTextCtrl(mCommandPanel, wxID_ANY, _T("127.0.0.1"));
	mCommandSizer->Add(TextCtrl2, wxSizerFlags().Proportion(1).Expand().Border());

	mMainSizer->Add(mCommandPanel, 0, wxEXPAND);

}
void MainWindow::composeVideoLayout()
{
	mVideoSizer = new wxFlexGridSizer(1,0,0);

	
	mMainSizer->Add(mVideoSizer, 4, wxEXPAND);
	
}
void MainWindow::onStream(wxCommandEvent&) {
	mStreamer->stream(TextCtrl2->GetLineText(0).ToStdString());
}
void MainWindow::onPlay(wxCommandEvent&) {
	if (mVideoPanelList.size() == 0) {

	}
	

	wxPanel* panel = new wxPanel(this, wxID_ANY);
	mVideoSizer->Add(panel, wxSizerFlags().Proportion(1).Expand().Border());
	//panel->SetMinSize(wxSize(320, 240));
	StreamingPlayer* player = new StreamingPlayer(panel->GetHandle());
	player->Play();
	mVideoSizer->Layout();
	mMainSizer->Layout();
	Refresh();
}
MainWindow::~MainWindow()
{

}
