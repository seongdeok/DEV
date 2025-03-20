import subprocess


def run_cmd(cmd):
    ret = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    print(cmd)
    print(ret.stdout)
    return ret.stdout.strip()


def get_current_workspace():
    return run_cmd("/usr/local/bin/aerospace list-workspaces --focused")


def focus_window_id(id):
    ret = run_cmd(f"/usr/local/bin/aerospace focus --window-id {id}")
    return ret


def move_to_workspace(id, workspace, focus):
    if focus:
        param = "--focus-follows-window"
    else:
        param = ""
    ret = run_cmd(
        f"/usr/local/bin/aerospace move-node-to-workspace {param} --window-id {id} {workspace}"
    )
    return ret


class windows:
    def __init__(self, id, title, fullscreen, name, workspace):
        self.id = id
        self.title = title
        self.fullscreen = fullscreen
        self.name = name
        self.workspace = workspace

    @staticmethod
    def get_all_window():
        res = run_cmd(
            '/usr/local/bin/aerospace list-windows --all --format "%{window-id}|%{window-title}|%{window-is-fullscreen}|%{app-name}|%{workspace}" '
        )
        list = res.strip().split("\n")
        print(list)
        window_list = []
        for str in list:
            info = str.split("|")
            window_list.append(windows(info[0], info[1], info[2], info[3], info[4]))
        return window_list

    @staticmethod
    def get_window_with_title(title):
        all_windows = windows.get_all_window()  # Get all windows
        matching_window = next(
            (window for window in all_windows if title in window.title), None
        )
        return matching_window


ai_window = windows.get_window_with_title("LGenie.AI")
cur_workspace = get_current_workspace()
if ai_window and ai_window.workspace == cur_workspace:
    move_to_workspace(ai_window.id, "5", False)
else:
    move_to_workspace(ai_window.id, cur_workspace, True)
