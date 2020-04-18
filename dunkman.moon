-- title:  Dunkman
-- author: congusbongus
-- desc:   Get past the defenders for a slam dunk
-- script: moon

t=0
x=96
y=24

export TIC=->

	if btn(0)
		y=y-1
	if btn(1)
		y=y+1
	if btn(2)
		x=x-1
	if btn(3)
		x=x+1

	cls(13)
	spr(1+t%60//30*2,x,y,14,3,0,0,2,2)
	print("HELLO WORLD!",84,84)
	t=t+1

-- <TILES>
-- 001:efffffffff222222f8888888f8222222f8fffffff8ff0ffff8ff0ffff8ff0fff
-- 002:fffffeee2222ffee88880fee22280feefff80fff0ff80f0f0ff80f0f0ff80f0f
-- 003:efffffffff222222f8888888f8222222f8fffffff8fffffff8ff0ffff8ff0fff
-- 004:fffffeee2222ffee88880fee22280feefff80ffffff80f0f0ff80f0f0ff80f0f
-- 017:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 018:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- 019:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 020:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 014:8abcdeeffeedcba97532110001123457
-- </WAVES>

-- <SFX>
-- 000:020010001000200030004000600050005000500050006000600070007000700080008001800190009000900090009000900f900f90009000900090003040000000fd
-- 001:0f071f043f004f009f00bf00cf00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00100000000000
-- 002:0e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e00205000000000
-- </SFX>

-- <PATTERNS>
-- 000:000000000000000000000000000000000000000000000000d00004000000f00004000000500006000000800006000000000000000000500006000000000000000000f00004000000000000000000d00004000000000000000000000000000000100000000000000000000000000000000000000000000000d00004000000f00004000000500006000000800006000000000000000000500006000000000000000000f00004000000000000000000d00004000000000000000000000000000000
-- 001:600006000000000000000000500006000000100000000000500006000000f00004000000100000000000f00004000000000000000000d00004000000100000000000d00004000000100000800004a00004000000100000000000800004000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:600006000000000000000000500006000000100000000000500006000000f00004000000100000000000f00004000000000000000000d00004000000100000000000f00004000000100000f00004500006000000100000000000d00004000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:800006000000000000000000000000000000690006000000600006000000000000000000000000000000590006000000500006000000000000000000000000000000d90004000000d00004000000000000000000000000000000100000000000800006000000000000000000000000000000690006000000600006000000000000000000000000000000590006000000500006000000000000000000d90004000000d00004000000100000890004a00004000000000000000000800004000000
-- 004:000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:800006000000000000000000000000000000690006000000600006000000000000000000000000000000490006000000400006000000000000000000000000000000d90004000000d00004000000000000000000000000000000100000000000800006000000000000000000000000000000690006000000600006000000000000000000000000000000490006000000400006000000000000000000f00004000000100000000000d00004000000b00004000000100000000000d00004000000
-- 010:d00002000000100000000000d00002000000100000000000000000000000d00002000000100000000000d00002000000100000000000d00002000000000000000000100000000000d00002000000100000000000d00002000000100000000000a00002000000100000000000a00002000000100000000000000000000000a00002000000100000000000a00002000000100000000000a00002000000000000000000100000000000a00002000000100000000000800002000000000000000000
-- 011:b00002000000100000000000b00002000000100000000000000000000000b00002000000100000000000600002000000100000000000600002000000000000000000100000000000600002000000100000000000800002000000100000000000d00002000000100000000000d00002000000100000000000000000000000d00002000000100000000000d00002000000000000000000f00002000000500004000000800004000000d00004000000500004000000f00002000000d00002000000
-- 012:b00002000000100000000000b00002000000100000000000000000000000b00002000000100000000000b00002000000100000000000b00002000000000000000000100000000000b00002000000100000000000b00002000000100000000000600002000000100000000000600002000000100000000000000000000000600002000000100000000000600002000000100000000000600002000000000000000000100000000000600002000000100000000000800002000000000000000000
-- 013:d00002000000100000000000d00002000000100000000000000000000000d00002000000100000000000d00002000000100000000000d00002000000000000000000100000000000d00002000000100000000000d00002000000100000000000d00002000000100000000000d00002000000100000000000000000000000d00002000000100000000000d00002000000100000000000d00002000000000000000000100000000000d00002000000100000000000b00002000000000000000000
-- 014:900002000000100000000000900002000000100000000000000000000000900002000000100000000000900002000000100000000000900002000000000000000000100000000000900002000000100000000000900002000000100000000000b00002000000100000000000b00002000000100000000000000000000000b00002000000100000000000b00002000000100000000000b00002000000000000000000100000000000b00002000000100000000000b00002000000000000000000
-- 015:800002000000000000000000100000000000800002100000800002000000000000000000000000000000100000000000800002000000000000000000100000000000800002000000100000000000800002000000000000000000100000000000800002000000000000000000100000000000800002100000800002000000000000000000100000000000800002000000100000000000800002000000000000000000100000000000800002000000100000000000800002000000100000000000
-- 020:400012000000dc001a000000b00016000000dc001a000000400012000000400012000000b00016000000dc001a000000400012000000dc001a000000b00016000000dc001a000000400012000000400012000000b00016000000dc001a000000400012000000dc001a000000b00016000000dc001a000000400012000000400012000000b00016000000dc001a000000400012000000dc001a000000b00016000000dc001a000000400012000000400012000000b00016000000dc001a000000
-- 021:400012000000dc001a000000b00016000000dc001a000000400012000000400012000000b00016000000dc001a000000400012000000dc001a000000b00016000000dc001a000000400012000000400012000000b00016000000dc001a000000400012000000dc001a000000b00016000000dc001a000000400012000000400012000000b00016000000dc001a000000400012000000b00016000000dc001a000000400012000000b00016000000400012000000b00016000000dc001a000000
-- 022:400012000000000000000000da001a000000000000000000b00016000000000000000000dc001a000000000000000000400012000000000000000000400012000000400012000000b00016000000000000000000dc001a000000000000000000400012000000000000000000da001a000000000000000000b00016000000000000000000dc001a000000000000000000400012000000000000000000400012000000400012000000b00016000000000000000000dc001a000000dc001a000000
-- 023:400012000000dc001a000000b00016000000dc001a000000400012000000400012000000b00016000000dc001a000000400012000000dc001a000000b00016000000dc001a000000400012000000400012000000b00016000000dc001a000000400012000000dc001a000000b00016000000dc001a000000400012000000400012000000b00016000000dc001a000000400012000000b00016000000dc001a000000400012000000b00016000000400012d70014d60014970014970014670014
-- 024:400012000000000000000000da001a000000000000000000b00016000000000000000000dc001a000000000000000000400012000000000000000000400012000000400012000000b00016000000000000000000dc001a000000000000000000400012000000000000000000da001a000000000000000000b00016000000000000000000dc001a000000000000000000400012000000b00016000000dc001a000000400012000000b00016000000400012d70014d60014970014970014670014
-- 030:000000000000000000000000000000000000000000000000890004000000a90004000000d90004000000590006000000000000000000d90004000000000000000000a90004000000000000000000890004000000000000000000000000000000100000000000000000000000000000000000000000000000890004000000a90004000000d90004000000590006000000000000000000d90004000000000000000000a90004000000000000000000890004000000000000000000000000000000
-- 031:f90004000000000000000000d90004000000100000000000d90004000000a90004000000100000000000a90004000000000000000000890004000000100000000000a90004000000100000c90004d90004000000100000000000890004000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:490006000000000000000000000000000000fc0004000000f90004000000000000000000000000000000dc0004000000d900040000000000000000000000000000009c0004000000990004000000000000000000000000000000100000000000f90004000000000000000000000000000000bc0004000000b900040000000000000000000000000000008c0004000000890004000000000000000000690004000000100000000000490004000000f90002000000100000000000d90002000000
-- 033:890006100000d90006100000f90006100000890008100000f90006100000d90006100000890006100000d90006100000890006100000d90006100000f90006100000890008100000f90006100000d90006100000890006100000d90006100000a90006100000d90006100000f90006100000890008100000f90006100000d90006100000890006100000d90006100000a90006100000d90006100000f90006100000890008100000f90006100000d90006100000890006100000d90006100000
-- 034:b90006100000d90006100000f90006100000890008100000f90006100000d90006100000890006100000d90006100000690006100000d90006100000690008100000890008100000f90006100000690008100000890006100000d90006100000890006100000d90006100000f90006100000890008100000f90006100000d90006100000890006100000d90006100000890006100000d90006100000f90006100000890008100000f90006100000d90006100000890006100000d90006100000
-- 035:b90006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a90006000000b90006000000a90006000000890006000000a90006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000690006000000000000000000000000000000000000000000000000000000000000000000890006000000000000000000
-- 036:000000000000000000000000000000000000000000000000860004000000a90004000000d60004000000d60004000000100000000000d60004000000a60004000000890004000000560004000000f60002000000d60002000000000000000000100000000000000000000000000000000000000000000000860004000000a90004000000d60004000000d60004000000100000000000d60004000000a60004000000890004000000860006000000660006000000560006000000d60004000000
-- 037:890006000000100000000000890008000000000000000000f90006000000000000000000890006000000690008000000000000000000d90006000000000000000000890006000000000000000000690008000000000000000000590008000000000000000000d90006000000000000000000890006000000000000000000590008000000000000000000f90006000000000000000000d90006000000000000000000890006000000000000000000f90006000000000000000000d90006000000
-- </PATTERNS>

-- <TRACKS>
-- 000:1c25102036101c25d73036184435105836596c35585836591c25d72036181c25983036d84437195838596c37585049996f00ef
-- </TRACKS>

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

