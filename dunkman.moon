-- title:  Dunkman
-- author: congusbongus
-- desc:   Get past the defenders for a slam dunk
-- script: moon

tt=0
WIDTH=240
CENTERX=WIDTH/2
HEIGHT=136
CENTERY=HEIGHT/2

SFXHIT=10
MUSGAME=0
MUSLEN=5500

outquad = (t) -> return 1-(1-t)*(1-t)
inoutcirc=(t)->
	return if t<0.5
		(1-math.sqrt(1-math.pow(2*t,2)))/2
	else
		(math.sqrt(1-math.pow(-2*t+2,2))+1)/2
inoutquad=(t)->
	return if t<0.5
		2*t*t
	else 1-math.pow(-2*t+2,2)/2

lerp = (s,e,t) -> return s*(1-t)+e*t

distance=(x1,y1,x2,y2)->
	dx=x1-x2
	dy=y1-y2
	return math.sqrt(dx*dx+dy*dy)

thickline=(x1,y1,x2,y2,whalf,c)->
	dx,dy=x1-x2,y1-y2
	d=distance(x1,y1,x2,y2)
	dxn,dyn=dx/d,dy/d
	pxn,pyn=dyn,-dxn
	px,py=pxn*whalf,pyn*whalf
	xa,ya=x1+px,y1+py
	xb,yb=x2+px,y2+py
	xc,yc=x2-px,y2-py
	xd,yd=x1-px,y1-py
	tri(xa,ya,xb,yb,xc,yc,c)
	tri(xc,yc,xd,yd,xa,ya,c)

arm=(x1,y1,x2,y2)->
	whalf=4
	dx,dy=x1-x2,y1-y2
	d=distance(x1,y1,x2,y2)
	dxn,dyn=dx/d,dy/d
	pxn,pyn=dyn,-dxn
	px,py=pxn*whalf,pyn*whalf
	xa,ya=x1+px,y1+py
	xb,yb=x2+px,y2+py
	xc,yc=x2-px,y2-py
	xd,yd=x1-px,y1-py
	-- arm and hand outlines
	thickline(x1,y1,x2,y2,5,0)
	circb(x2,y2,8,0)
	-- arm and hand fills
	thickline(x1,y1,x2,y2,4,7)
	circ(x2,y2,7,7)

class Ball
	@D=40
	@SIZE=16
	@HANDSIZE=8
	@COLRADIUS=8
	@LERP=8

	get_pos:(x,y)=>return CENTERX+x*@@D,CENTERY+y*@@D

	new:=>
		@sx,@sy=@get_pos(0,0)
		@ex,@ey=@sx,@sy
		@x,@y=@sx,@sy
		@lerpcnt=0
		@angle=0

	get_target:=>
		tx=0
		ty=0
		if btn(0)
			ty=-1
		else if btn(1)
			ty=1
		else
			ty=0
		if btn(2)
			tx=-1
		else if btn(3)
			tx=1
		else
			tx=0
		d=distance(tx,ty,0,0)
		if d > 0
			tx/=d
			ty/=d
		return @get_pos(tx,ty)

	update:=>
		xnew,ynew=@get_target!
		if @ex!=xnew or @ey!=ynew
			@lerpcnt=0
			@sx,@sy=@x,@y
			@ex,@ey=xnew,ynew
		if @lerpcnt<@@LERP
			@lerpcnt+=1
			@angle+=0.1
			if @angle>math.pi
				@angle=0
			t=outquad(@lerpcnt/@@LERP)
			@x=lerp(@sx,@ex,t)
			@y=lerp(@sy,@ey,t)

	draw:=>
		-- hands and arms
		-- left
		lx,ly=100,98
		if @x<CENTERX+20
			lx,ly=@x-8,@y
		arm(106,70,lx,ly)
		-- right
		rx,ry=150,80
		if @x>CENTERX-20
			rx,ry=@x+8,@y
		arm(138,77,rx,ry)
		-- ball
		spr(256,@x-@@SIZE,@y-@@SIZE,0,1,0,@angle,4,4)

class Hand
	@SIZE=16
	@COLRADIUS=8
	@COUNT=math.pi

	-- theta in radians
	new:(cx,cy,theta,w,h,speed)=>
		@cx=cx
		@cy=cy
		@theta=theta
		@counter=0
		@w=w
		@h=h
		@speed=speed
		@x=0
		@y=0

	update:=>
		@counter+=@speed
		t=inoutquad(@counter/@@COUNT)*@@COUNT
		@x=math.cos(@theta+t)*@w+@cx
		@y=math.sin(@theta+t)*@h+@cy

	isout:=>return @counter>@@COUNT

	draw:=>
		spr(320,@x-@@SIZE,@y-@@SIZE,0,1,0,0,4,4)

	onball:(ball)=>return distance(@x,@y,ball.x,ball.y)<@@COLRADIUS+ball.__class.COLRADIUS

HANDS1={
	-- NE
	{x:WIDTH-10,y:40,th:math.pi/2,w:80,h:0},
	-- E
	{x:WIDTH,y:HEIGHT/2,th:math.pi/2,w:75,h:0},
}
HANDS2={
	-- N,NE
	{x:WIDTH-20,y:30,th:math.pi/2,w:100,h:0},
	-- NE,E
	{x:WIDTH,y:40,th:math.pi/2,w:85,h:50},
	-- C,E
	{x:WIDTH-20,y:HEIGHT/2,th:math.pi/2,w:100,h:0},
}
HANDS3={
	-- N,NE,E
	{x:WIDTH,y:0,th:math.pi/2,w:120,h:HEIGHT/2},
	-- NE,E,SE
	{x:WIDTH,y:HEIGHT/2,th:math.pi/2,w:85,h:HEIGHT/2},
}

class HandGen
	new:=>
		@hands={}
		@nextpat=0

	gethandonball:(ball)=>
		for hand in *@hands
			if hand\onball(ball)
				return hand
		return nil

	update:(tt)=>
		if @nextpat<=0
			if tt>100
				switch tt//500
					when 0
						-- single swipes
						@genhands(HANDS1[math.random(#HANDS1)])
					when 1
						-- two singles
						@gen2hands(HANDS1)
					when 2
						-- double
						@genhands(HANDS2[math.random(#HANDS2)])
					when 3
						-- double+single
						@genhands(HANDS2[math.random(#HANDS2)])
						@genhands(HANDS1[math.random(#HANDS1)])
					when 4
						-- triple
						@genhands(HANDS3[math.random(#HANDS3)])
					when 5
						-- triple+double
						@genhands(HANDS3[math.random(#HANDS3)])
						@genhands(HANDS2[math.random(#HANDS2)])
					when 6
						-- triple+double
						@genhands(HANDS3[math.random(#HANDS3)])
						@genhands(HANDS2[math.random(#HANDS2)])
					when 7
						-- double+2single
						@genhands(HANDS2[math.random(#HANDS2)])
						@gen2hands(HANDS1)
					when 8
						-- double+2single
						@genhands(HANDS2[math.random(#HANDS2)])
						@gen2hands(HANDS1)
					else
						-- triple+double+single
						@genhands(HANDS3[math.random(#HANDS3)])
						@genhands(HANDS2[math.random(#HANDS2)])
						@genhands(HANDS1[math.random(#HANDS1)])
		else
			@nextpat-=1
		for hand in *@hands
			hand\update!

	gen2hands:(swipes)=>
		swipe1=swipes[math.random(#swipes)]
		swipe2=nil
		while true
			swipe2=swipes[math.random(#swipes)]
			if swipe1!=swipe2
				break
		@genhands(swipe1)
		@genhands(swipe2)

	genhands:(swipe)=>
		-- gen new hands
		@nextpat=100-tt*30/MUSLEN
		speed=150-tt*30/MUSLEN
		-- randomly flip: x,y
		x,w=if math.random(2)==1
			swipe.x,swipe.w
		else
			WIDTH-swipe.x,-swipe.w
		y,h=if math.random(2)==1
			swipe.y,swipe.h
		else
			HEIGHT-swipe.y,-swipe.h
		table.insert(@hands, Hand(x,y,swipe.th,w,h,math.pi/speed))

	postupdate:(ball)=>
		@hands=[hand for hand in *@hands when not hand\isout! and not hand\onball(ball)]

	draw:=>
		for hand in *@hands
			hand\draw!

img_values = {0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,3,7,0,7,0,7,0,7,3,7,3,7,0,7,3,7,3,7,3,7,0,7,3,7,3,7,3,7,3,7,0,7,3,7,3,7,3,7,3,7,3,7,3,7,0,7,3,7,3,7,3,7,3,7,3,0,7,3,7,3,7,3,7,3,7,3,7,3,0,7,3,7,3,7,3,7,3,7,3,0,3,7,3,7,3,7,3,7,3,0,3,7,3,7,3,7,3,7,3,6,3,0,3,7,3,7,3,7,3,7,3,6,3,0,3,7,3,7,3,6,1,0,3,7,3,7,3,1,6,1,0,3,7,3,6,1,6,1,6,1,0,3,1,6,1,9,6,1,9,6,1,0,3,1,6,1,9,1,6,1,9,1,6,1,0,3,1,6,1,9,6,1,9,1,0,3,1,6,1,6,1,0,3,1,6,1,6,1,0,3,5,6,1,6,1,0,3,5,6,1,0,3,5,6,9,1,0,3,5,6,4,1,0,1,5,6,9,1,0,1,5,6,1,0,1,5,6,1,6,1,0,1,0,1,5,6,5,1,0,1,6,1,0,1,5,6,5,6,5,1,0,1,6,5,6,1,4,1,5,6,5,6,5,1,0,1,6,5,6,1,10,4,1,6,5,6,5,1,0,1,6,5,6,1,10,1,6,5,6,5,1,0,1,6,5,6,1,10,1,6,5,6,5,6,1,0,1,6,5,6,1,10,1,6,5,6,5,6,1,0,1,6,5,6,1,10,1,6,5,6,5,6,1,4,1,0,1,6,5,6,1,10,1,6,5,6,1,10,1,6,1,0,1,6,5,6,1,10,4,10,1,6,5,6,1,10,1,6,1,0,1,6,5,6,1,10,4,10,1,6,1,10,1,6,1,0,1,6,5,6,1,10,4,10,1,6,1,10,1,6,1,0,1,6,5,1,10,4,10,1,6,1,10,1,6,1,0,1,5,1,4,10,4,10,1,10,1,6,1,0,1,4,10,2,10,4,10,4,10,1,6,5,6,1,0,1,4,10,2,4,2,10,4,10,1,6,5,6,1,0,1,4,10,2,10,2,10,2,10,4,10,4,1,6,5,6,1,0,1,4,10,2,10,2,10,2,10,2,10,2,10,4,10,1,6,5,6,1,0,1,4,10,2,10,2,10,2,10,2,10,2,10,2,10,4,10,1,6,5,6,1,0,1,4,10,2,4,2,10,2,10,2,10,2,4,10,2,10,1,5,6,1,0,1,4,10,4,10,2,10,2,10,2,10,2,10,2,10,2,10,1,0,1,0,1,4,10,2,4,10,2,10,2,10,2,10,2,10,1,0,1,4,10,2,10,2,10,1,0,1,4,10,2,10,2,10,4,1,0,1,10,2,4,10,2,10,4,1,0,1,10,2,4,10,2,10,2,10,4,1,0,1,10,4,10,2,10,2,10,4,2,10,4,1,0,1,10,4,10,2,10,2,10,4,2,10,1,0,1,10,4,10,2,10,2,10,2,10,4,1,0,1,10,4,10,2,10,2,10,2,10,4,1,0,1,10,4,10,4,2,10,2,10,2,10,4,1,0,1,10,4,10,4,2,10,2,10,2,10,1,0,1,10,4,10,2,10,2,10,2,10,1,0,1,4,10,4,10,4,2,10,2,10,2,10,1,0,1,4,10,4,10,4,10,2,10,1,0,1,4,10,4,10,2,10,1,0,1,4,10,1,0,1,4,10,4,10,1,0,1,4,10,4,10,4,10,1,0,1,4,10,4,10,4,10,1,0,1,4,10,4,10,4,10,1,0,1,4,10,4,10,4,10,4,10,1,0,1,4,10,4,10,4,10,4,10,1,0,1,4,10,4,10,4,10,4,10,4,1,0,1,10,4,10,4,10,4,1,0,1,10,4,10,4,10,4,1,0,1,4,1,10,4,10,4,10,4,1,0,1,4,1,4,10,4,10,1,0,1,4,10,4,1,4,10,4,10,1,10,1,0,1,4,10,4,10,1,10,4,1,10,1,0,1,4,10,4,1,10,1,0,1,4,10,4,10,1,0,1,4,10,1,0,1,4,10,4,10,1,0,1,4,10,4,10,1,0,1,4,10,1,4,10,1,0,1,4,10,1,0,1,4,10,1,0,1,4,10,4,1,0,1,4,10,1,6,1,0,1,4,10,4,1,0,1,4,10,1,6,1,0,1,4,10,4,1,0,1,4,10,1,6,1,0,1,4,10,4,1,0,1,4,10,1,6,1,0,1,5,1,10,4,1,0,1,4,10,1,6,1,0,1,5,1,10,4,1,0,1,4,10,1,6,1,0,1,5,1,10,4,1,0,1,4,1,6,1,0,1,5,1,10,4,1,0,1,4,1,6,5,6,1,0,1,5,6,5,1,10,4,1,0,1,4,1,6,5,6,1,0,1,6,5,1,0,1,4,1,6,5,6,5,1,0,1,5,6,1,0,1,4,1,5,6,5,6,1,0,1,5,6,1,0,1,5,6,1,0,1,5,6,1,0,1,5,6,1,0,1,5,6,1,0,1,5,6,1,0,1,6,1,0,1,5,6,1,0,1,6,1,0,1,5,6,1,0}
img_runs = {8042,1,6,1,232,2,5,1,4,1,227,3,3,3,3,1,227,4,2,4,1,2,222,2,3,7,1,2,1,3,221,4,1,2,1,4,2,5,221,7,2,3,1,1,2,8,217,6,1,1,3,5,1,1,1,4,217,3,1,2,1,3,1,3,1,1,1,2,1,3,212,8,2,1,1,7,1,4,1,2,1,213,7,1,1,2,4,1,3,1,2,1,2,1,214,4,1,2,1,2,1,4,8,1,2,215,1,1,3,1,1,4,1,1,12,215,1,2,1,1,2,4,1,1,1,7,4,216,1,1,1,2,1,1,1,2,2,9,2,217,1,1,2,3,5,10,1,218,5,1,1,1,2,4,6,2,218,4,1,5,4,3,1,2,1,1,218,8,2,2,1,2,3,1,1,1,1,219,6,1,3,1,2,1,2,1,1,1,1,1,219,6,1,4,1,2,3,1,1,1,220,6,1,9,1,2,1,221,6,2,8,1,1,1,221,6,2,7,1,2,1,222,4,2,11,1,222,2,3,5,6,2,222,1,3,5,7,1,223,1,2,6,7,1,223,1,1,14,1,222,1,1,5,2,6,2,209,8,6,1,1,5,2,6,210,1,8,4,1,1,1,1,1,5,3,1,211,2,2,1,7,1,2,2,1,1,1,5,3,1,210,1,3,1,8,1,2,1,1,2,1,6,2,1,209,1,3,1,8,1,4,1,3,1,5,1,1,210,1,2,1,9,1,4,1,3,1,4,1,1,2,209,1,1,1,10,1,4,1,3,1,4,1,2,5,205,1,10,1,1,1,4,1,3,1,3,1,3,1,3,5,201,1,9,1,1,1,5,1,7,1,3,1,3,1,4,2,199,1,8,1,2,1,3,1,2,1,5,1,4,1,2,1,6,1,199,1,7,1,2,1,4,1,2,1,9,1,3,1,7,1,199,2,4,1,3,1,4,1,3,1,6,2,4,1,7,1,201,1,1,4,2,5,1,3,3,3,1,6,1,7,1,202,2,1,2,2,4,1,7,3,6,1,9,1,203,1,4,2,1,1,1,13,1,2,1,1,1,7,1,203,1,3,2,3,1,1,11,1,3,1,2,1,5,1,204,1,3,2,3,1,1,1,1,8,2,2,1,1,2,1,5,1,204,1,2,2,1,1,1,1,1,1,1,1,1,7,1,3,1,4,1,3,1,204,2,2,2,1,1,1,1,1,1,1,1,1,1,4,1,2,3,1,4,1,2,1,205,1,3,6,1,1,1,1,2,1,2,1,1,1,1,1,2,5,1,2,1,205,1,2,8,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,5,2,206,1,2,7,1,1,4,1,1,1,1,1,1,1,2,2,212,2,1,7,3,9,2,2,2,212,2,1,5,5,3,3,6,1,1,213,1,10,1,1,3,4,5,1,1,213,1,9,2,1,2,2,2,2,4,1,1,212,1,4,1,5,2,3,2,1,1,2,4,1,1,212,1,4,1,5,1,3,2,2,1,1,5,1,213,1,4,1,4,2,3,2,2,2,4,1,1,213,1,3,2,4,2,2,2,3,2,4,1,1,212,1,4,2,3,1,2,2,2,3,2,4,1,1,212,1,4,2,3,1,1,3,2,2,2,5,1,212,1,5,2,3,2,3,2,2,2,5,1,212,1,1,4,1,3,1,2,3,2,1,2,6,1,211,1,2,4,1,3,1,5,4,7,1,211,1,1,9,1,6,2,8,1,210,1,2,26,1,210,1,1,16,1,10,1,209,1,1,7,1,9,1,9,1,209,1,2,6,2,8,1,10,1,209,1,1,7,2,8,1,10,1,208,1,1,7,3,7,1,5,1,5,1,208,1,1,6,4,6,2,4,2,5,1,207,1,2,5,5,5,2,4,2,5,1,1,208,2,5,5,11,2,5,2,1,207,1,5,6,10,2,5,3,1,206,1,1,1,3,8,8,3,5,1,3,205,1,2,5,7,7,3,6,3,205,1,2,1,5,6,1,6,4,2,4,3,1,204,1,1,4,4,5,4,3,1,5,8,2,201,1,2,14,3,4,15,1,199,1,2,17,3,18,1,197,1,2,40,1,195,1,3,20,1,20,2,193,1,2,18,5,21,1,191,1,3,17,1,6,21,1,189,1,4,16,1,1,1,6,19,2,190,1,3,15,1,1,2,1,6,17,1,2,2,188,1,2,15,1,1,4,1,7,14,1,5,1,188,1,1,14,2,1,5,1,8,11,1,7,1,187,1,1,13,2,1,7,1,9,8,1,8,1,186,1,1,1,11,3,1,9,1,10,5,1,10,1,185,1,1,1,10,4,1,10,1,11,3,1,10,1,184,1,3,2,7,4,1,12,2,11,1,11,1,184,1,5,2,4,4,1,15,2,9,1,2,1,7,1,184,1,1,5,2,2,1,5,1,17,2,6,1,2,1,8,1,184,1,8,2,6,20,2,4,1,1,1,7,2,1,178,6,1,13,1,24,2,1,2,1,5,3,1,1,177,2,6,14,1,26,3,1,9,1,174,3,7,14,1,28,1,2,9,1,171,3,9,15,1,28,1,2,9,1,169,2,26,1,29,1,2,8,1,168,2,28,1,29,1,2,8,1,100}
-- swap some colours
imgmap = {
	9,10,13,6,7,11,7,12,
	12,12,12,11,12,13,14,15,
}
img_values=[imgmap[v-1] for v in *img_values]

ball=Ball!
handgen=HandGen!
music(MUSGAME,-1,-1,true)

export TIC=->

	ball\update!
	handgen\update(tt)
	handonball=handgen\gethandonball(ball)
	if handonball
		sfx(SFXHIT)
	handgen\postupdate(ball)

	cls(0)

	-- draw image
	val_i=0
	run=0
	for y=0,136-1
		for x=0,240-1
			if run==0
				val_i=val_i+1
				run=img_runs[val_i]
			run=run-1
			pix(x,y,img_values[val_i])

	ball\draw!
	handgen\draw!
	print("DUNKING: #{tt*1000//MUSLEN/10}%",84,12,12)
	tt+=1
	if tt==MUSLEN
		music!

-- <SPRITES>
-- 001:0000000000000000000000000000000000000333000332220333322232222322
-- 002:0000000000000000000000000000000033300000222330002222233022222323
-- 016:0000000300000032000000320000032200000333000032220000322200003222
-- 017:2222223322222222222222222222222233332222222233222222223322222222
-- 018:2222232232222322233222322223223222223223222232232222232332222332
-- 019:3000000023000000230000002230000023300000322300003223000023330000
-- 032:0000322200003222000032220000033300000322000000320000003200000003
-- 033:2222222222222222222222223333333322222222222222222222222222222222
-- 034:2322333223332232333222322232223222322232223222322232223222322232
-- 035:2223000022230000222300002230000022300000230000002300000030000000
-- 049:3222222203322222000332220000033300000000000000000000000000000000
-- 050:2322223323222330322330003330000000000000000000000000000000000000
-- 065:0000000000000000000000000000000000000000000000000005550000556655
-- 066:0000000000000000000000000000000000000000000000000000000050000000
-- 080:0000000500000005000000050000000000000000000000000000000000000000
-- 081:5555666666665566566665555566666505566666005566660005566600005566
-- 082:5555550066655655666655655666656655666666655666666666666666666666
-- 083:0000000000000000500000005500000065000000665500006665500066665500
-- 097:0000056600000556000000560000005600000555000556665556666656666666
-- 098:6666666666666666666666666666666666666666666666666666666666666666
-- 099:6666655066666655666666666666666666666666666666666666666666666666
-- 113:5666666655555555000000000000000000000000000000000000000000000000
-- 114:6666666655555555000000000000000000000000000000000000000000000000
-- 115:6666666656666666055666660005566600005555000000000000000000000000
-- </SPRITES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 014:8abcdeeffeedcba97532110001123457
-- </WAVES>

-- <SFX>
-- 000:720080009000a000a000b000b000c000c000c000c000c000c000c000c000c000c000c001c001c000c000c000c000c000c00fc00fc000c000c000c0003000000000fd
-- 001:6f079f04af00bf00cf00ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00100000000000
-- 002:0e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e000e00200000000000
-- 010:0f008f00af00bf00cf00df00ef00ef004f00af00bf00cf00df00ef00ef00ef006f00cf00df00ef00ef009f00df00ef00ef00ef00cf00ef00ef00ff00050000000000
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
-- 000:000000d63600e47200f2b500ffff00a0470ce7964ef7b88e3072a43b5dcb41a6f673eff7f4f4f4a3a3a3525252bc1616
-- </PALETTE>

