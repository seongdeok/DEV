import Gtk from "gi://Gtk"
import { createPoll } from "ags/time"
import { Accessor } from "ags"

// 2초마다 시스템 자원 폴링
// 배열 방식으로 bash 명령 전달 (ENV 변수 확장, 파이프 지원)
export default function SystemStats() {
  const cpu = createPoll("-%", 2000, [
    "bash",
    "-c",
    "top -bn1 | grep 'Cpu(s)' | awk '{printf \"%d%%\", $2+$4}'",
  ])

  const ram = createPoll("-%", 2000, [
    "bash",
    "-c",
    "free | awk '/Mem:/{printf \"%d%%\", $3/$2*100}'",
  ])

  const disk = createPoll("-%", 30_000, [
    "bash",
    "-c",
    "df -h / | awk 'NR==2{print $5}'",
  ])

  return (
    <box orientation={Gtk.Orientation.VERTICAL} class="sysstat-widget" halign={Gtk.Align.CENTER}>
      <label class="section-title" label="SYSTEM" />
      <box class="stat-row" halign={3} spacing={24}>
        <StatCard label="CPU" value={cpu} />
        <StatCard label="RAM" value={ram} />
        <StatCard label="DISK" value={disk} />
      </box>
    </box>
  )
}

function StatCard({ label, value }: { label: string; value: Accessor<string> }) {
  return (
    <box orientation={Gtk.Orientation.VERTICAL} class="stat-card" halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER}>
      <label class="stat-label" label={label} />
      <label class="stat-value" label={value} />
    </box>
  )
}
