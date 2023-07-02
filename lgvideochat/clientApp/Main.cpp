#include "Main.h"

IMPLEMENT_APP_CONSOLE(Main)

bool Main::OnInit()
{
	window = new MainWindow();
	window->Show();
	return true;
}
