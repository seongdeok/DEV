import Gdk from "gi://Gdk?version=4.0"
import Gtk from "gi://Gtk"
import { Astal } from "ags/gtk4"
import Clock from "../widgets/Clock"
import SystemStats from "../widgets/SystemStats"
import Launcher from "../widgets/Launcher"

// gdkmonitor는 Wayland 레이어 쉘 프로토콜 상 생성 시에만 적용됨
// 모니터 재연결 시 윈도우를 destroy → 재생성해야 올바른 모니터에 뜸
export function createDashboardWindow(gdkmonitor: Gdk.Monitor): Astal.Window {
  const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      class="Dashboard"
      gdkmonitor={gdkmonitor}
      anchor={TOP | BOTTOM | LEFT | RIGHT}
      layer={Astal.Layer.BOTTOM}
      exclusivity={Astal.Exclusivity.IGNORE}
      namespace="sec-dashboard"
    >
      <box orientation={Gtk.Orientation.VERTICAL} class="dashboard-container">
        {/* 상단: 시계 */}
        <Clock />

        {/* 중앙: 시스템 상태 (남은 공간 채움) */}
        <box orientation={Gtk.Orientation.VERTICAL} vexpand class="content-area">
          <SystemStats />
        </box>

        {/* 하단: 빠른 실행 버튼 */}
        <Launcher />
      </box>
    </window>
  ) as Astal.Window
}
