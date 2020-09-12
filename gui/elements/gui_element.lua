function create_gui_element(x, y, w, h, act_table, parent)
  local ge = act_table
  ge.x = x
  ge.y = y
  ge.w = w
  ge.h = h
  ge.visible = true
  ge.active = true
  ge.parent = parent or 0
  return ge
end