#!/usr/local/bin/lua

-- test srlua

print("This is",_VERSION,"running a script inside",arg[0])

print("These are the arguments from varargs")
print(...)

print("These are the arguments from arg")
for i=0,#arg do
	print(i,arg[i])
end

print("These are the libraries")
for k,v in pairs(_G) do
	if type(v)=="table" then io.write(k,',') end
end
io.write('\n')

print("This is",_VERSION,"running a script inside",arg[0])

-- test dokun

window = Window:new()
window:create("Test", 1280, 720)
window:show()
while window:is_open() do
    window:set_viewport(window:get_client_width(), window:get_client_height())
	window:clear(32, 32, 32)
    window:update()
end
