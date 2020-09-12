-- TODO : CREATE CHAINS OF TICKERS
--        WHILE TICKERS
--        FOR-ITERATORS TICKERS

-- Tries to emulate multithreading

return {
	func = {},
	register_tick = function(self, func, ticks, name, on_end)
		self.func[name] = {func = func, ticks = ticks, max_ticks = ticks, on_end = on_end}
	end,
	tick = function(self, name, ticks)
		if self.func[name] ~= nil then
      for i = 1, ticks do
        self.func[name].func(self.func[name].max_ticks - self.func[name].ticks)
        self.func[name].ticks = self.func[name].ticks - 1
        if self.func[name].ticks <= 0 then
          if self.func[name].on_end ~= nil then self.func[name].on_end() end
          self.func[name] = nil
          break
        end
      end
		end
	end,
	get_tick = function(self, name) return (self.func[name] or {ticks=0}).ticks end,
	get_start_tick = function(self, name) return (self.func[name] or {max_ticks=0}).max_ticks end
}