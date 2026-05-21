import Gtk from "gi://Gtk"
import { execAsync } from "ags/process"

type LaunchItem = {
  label: string
  icon: string
  command: string[]
}

// 자주 쓰는 앱 목록 - 필요에 따라 수정
const LAUNCH_ITEMS: LaunchItem[] = [
  { label: "터미널", icon: "utilities-terminal",      command: ["kitty"] },
  { label: "브라우저", icon: "web-browser",            command: ["brave"] },
  { label: "파일",   icon: "system-file-manager",    command: ["thunar"] },
  { label: "에디터", icon: "text-editor",             command: ["code"] },
  { label: "btop",  icon: "utilities-system-monitor", command: ["kitty", "--title", "btop", "-e", "btop"] },
]

export default function Launcher() {
  return (
    <box orientation={Gtk.Orientation.VERTICAL} class="launcher-section">
      <label class="section-title" label="LAUNCH" />
      <box class="launcher-widget" halign={3} spacing={16}>
        {LAUNCH_ITEMS.map(({ label, icon, command }) => (
          <button
            class="launcher-btn"
            onClicked={() =>
              execAsync(command).catch((err: unknown) =>
                console.error(`Failed to launch ${label}:`, err)
              )
            }
            tooltipText={label}
          >
            <box orientation={Gtk.Orientation.VERTICAL} halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} spacing={8}>
              <image iconName={icon} pixelSize={44} />
              <label label={label} class="launcher-label" />
            </box>
          </button>
        ))}
      </box>
    </box>
  )
}
