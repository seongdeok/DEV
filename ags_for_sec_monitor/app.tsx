#!/usr/bin/env -S ags run
import app from "ags/gtk4/app"
import Gdk from "gi://Gdk?version=4.0"
import { Astal } from "ags/gtk4"
import { createDashboardWindow } from "./windows/Dashboard"

const TARGET_CONNECTOR = "HDMI-A-1"

function findMonitor(): Gdk.Monitor | null {
  const display = Gdk.Display.get_default()
  if (!display) return null
  const list = display.get_monitors()
  for (let i = 0; i < list.get_n_items(); i++) {
    const mon = list.get_item(i) as Gdk.Monitor
    if (mon.get_connector() === TARGET_CONNECTOR) return mon
  }
  return null
}

app.start({
  css: `${SRC}/style.css`,
  main() {
    const display = Gdk.Display.get_default()!
    let win: Astal.Window | null = null

    function spawn(mon: Gdk.Monitor) {
      if (win) { win.destroy(); win = null }
      win = createDashboardWindow(mon)
      console.log(`[Dashboard] spawned on ${TARGET_CONNECTOR}`)
    }

    // 초기 실행
    const initial = findMonitor()
    if (initial) spawn(initial)
    else console.warn(`[Dashboard] ${TARGET_CONNECTOR} not found at startup`)

    // 모니터 핫플러그 감지 (GTK4: ListModel items-changed)
    display.get_monitors().connect("items-changed", () => {
      const found = findMonitor()
      if (found) {
        spawn(found)
      } else {
        win?.destroy()
        win = null
        console.log(`[Dashboard] ${TARGET_CONNECTOR} disconnected`)
      }
    })
  },
})
