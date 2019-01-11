window = Window:new()
window:create("Test", 1280, 720)
window:show()
while window:is_open() do
    window:set_viewport(window:get_client_width(), window:get_client_height())
	window:clear(32, 32, 32)
    window:update()
end
window:destroy()
dokun:close   ()