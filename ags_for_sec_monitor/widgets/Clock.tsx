import Gtk from "gi://Gtk"
import { createPoll } from "ags/time"

export default function Clock() {
  // 1초마다 시간 갱신 (JS Date 직접 사용 - subprocess 불필요)
  const time = createPoll("--:--", 1000, () => {
    const now = new Date()
    return now.toLocaleTimeString("ko-KR", {
      hour: "2-digit",
      minute: "2-digit",
      hour12: false,
    })
  })

  // 1분마다 날짜 갱신
  const date = createPoll("", 60_000, () => {
    const now = new Date()
    return now.toLocaleDateString("ko-KR", {
      weekday: "long",
      year: "numeric",
      month: "long",
      day: "numeric",
    })
  })

  return (
    <box orientation={Gtk.Orientation.VERTICAL} class="clock-widget" halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER}>
      <label class="clock-time" label={time} />
      <label class="clock-date" label={date} />
    </box>
  )
}
