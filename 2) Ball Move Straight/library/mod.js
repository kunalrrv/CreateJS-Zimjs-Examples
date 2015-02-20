
var mod = function(mod) {
	
	console.log("hi from mod");
	
	/*--
mod.rand = function(a, b, integer)
returns a random number between and including a and b
b is optional and if left out will default to 0 (includes 0)
integer is a boolean and defaults to true
if a and b are 0 then just returns Math.random()
--*/
	mod.rand = function(a, b, integer) { 
		if (not(integer)) integer = true;
		if (not(b)) b = 0;
		if (not(a)) a = 0;
		if (a>b) {a++;} else if (b>a) {b++;}
		var r;
		if (a == 0 && b == 0) {
			return Math.random();
		} else if (b == 0) {
			r = Math.random()*a;
		} else {
			r = Math.min(a,b) + Math.random()*(Math.max(a,b)-Math.min(a,b));
		}	
		if (integer) {
			return Math.floor(r);			
		} else {
			return r;
		}
	}

	
	mod.Bouncer = function(container, speedMax, speedMin, angleMax, angleMin) {
		
		console.log("hi from Bouncer");	
		
		if (not(container) || !container.getBounds || !container.getBounds() ) {
			console.log("Bouncer(): please provide a object with bounds set as first parameter");
			return;
		}
		
		if (not(speedMax)) speedMax = 5;
		if (not(speedMin)) speedMin = 1;
		if (not(angleMax)) angleMax = 360;
		if (not(angleMin)) angleMin = 0;
		
		var that = this;
		
		this.speed = mod.rand(speedMin, speedMax, false);
		this.angle = mod.rand(angleMin, angleMax, false);
		
		var b = container.getBounds();
		
		this.x = mod.rand(b.x, b.x+b.width);
		this.y = mod.rand(b.y, b.y+b.height);
		
		this.advance = function() {
			
			var b = container.getBounds();
			
			that.x += that.speed * Math.sin(that.angle*Math.PI/180); // degrees to radians
			that.y += that.speed * Math.cos(that.angle*Math.PI/180);
			
			
			if (that.x > (b.x+b.width))
			{
				that.x = b.x+b.width;
				that.angle = 360 - that.angle;
			}
			else if (that.x < b.x)
			{
				that.x = b.x;
				that.angle = 360 - that.angle;
			}
			
			
			if (that.y > b.y+b.height)
			{
				that.y = b.y+b.height;
				that.angle = 180 - that.angle;
			}
			else if (that.y < b.y)
			{
				that.y = b.y;
				that.angle = 180 - that.angle;
			}
		
		}
		
		console.log(this.speed);
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*
	mod.Bouncer = function(container, speedMax, speedMin, angleMax, angleMin) {
		if (zot(container) || !container.getBounds || !container.getBounds()) {
			zog("please provide a container with bounds");
		}
		if (zot(speedMax)) speedMax = 10;
		if (zot(speedMin)) speedMin = 2;
		if (zot(angleMax)) angleMax = 360;
		if (zot(angleMin)) angleMin = 0;
		
		var that = this;
		
		var b = container.getBounds();
		this.x = zim.rand(b.x, b.x+b.width);
		this.y = zim.rand(b.y, b.y+b.height);
		this.lastX = this.x;
		this.lastY = this.y;
		this.angle = zim.rand(angleMin, angleMax, false);
		this.speed = zim.rand(speedMin, speedMax, false);
		this.bounces = 0;
		var pauseCheck = false;
		this.advance = function() {
			if (!pauseCheck) {
				var diffX = Math.sin(that.angle*Math.PI/180) * that.speed;
				var diffY = Math.cos(that.angle*Math.PI/180) * that.speed;
				that.x += diffX;
				that.y += diffY;
				var b = container.getBounds();
			
				if (that.x > b.x+b.width) {
					that.x = b.x+b.width;				
					that.angle = 360 - that.angle;
					that.bounces++;
				} else if (that.x < b.x) {
					that.x = b.x;
					that.angle = 360 - that.angle;
					that.bounces++;
				}
				if (that.y > b.y+b.height) {
					that.y = b.y+b.height;
					that.angle = 180 - that.angle;
					that.bounces++;
				} else if (that.y < b.y) {
					that.angle = 180 - that.angle;
					that.bounces++;
				}
			}
			return {x:that.x, y:that.y, speed:that.speed, angle:that.angle, lastX:that.lastX, lastY:that.lastY, bounces:that.bounces};
		}
		this.toggle = function() {
			pauseCheck = !pauseCheck;
		}
	}
	*/
	
	// has namespace so can be used outside module
	// but is longer
	// mod.not = function() {
		
	//}
	
	// cannot be used outside namespace
	// can be used in module
	var not = function(p) {
		if (p === null) return true;
		return typeof p === "undefined";
	}
	
	// global scope can be used outside module
	// but wipes out any other not or gets wiped out
	// not = function() {
		
	// }
	
	// function not() {
		
	// }
	
	mod.scaleTo = function(obj, container, percentX, percentY) {
		
		// COLLECTING PARAMETERS
		// zim version of setting a default parameter
		// if ( zot(percentX) ) percentX = 100;
		
		// long version of setting default parameter
		if (not(percentX)) {
			percentX = -1;
		}
		
		if (percentY === null || typeof percentY === "undefined") {
			percentY = -1;
		}
		 
		// short version but be careful with false, 0, ""
		// percentX = (percentX || 100);
		
		console.log("percentX = " + percentX);
		
		if (zot(obj)) return;
		
		if (  not(container) ) {
			if (!obj.getStage()) {
				zog("please add obj to stage before scaling");
				return;
			}
			container = obj.getStage();		
		}
		
		// if (percentX != -1 && percentY != -1) {
			
		console.log(percentX, percentY);
		
		if (percentX >= 0 || percentY >= 0) {
			
			if (percentX >= 0) {
				var w = container.getBounds().width * percentX / 100;
				var sX = w / obj.getBounds().width;
				obj.scaleX = sX;	
			}
			
			if (percentY >= 0) {
				var h = container.getBounds().height * percentY / 100;
				var sY = h / obj.getBounds().height;	
				obj.scaleY = sY;
			}
			
			console.log(sX, sY);
			
			var s;
			if (sX && sY) {
				s = Math.min(sX, sY);
			} else if (sX) {
				s = sX;
			} else if (sY) {
				s = sY;	
			}
			
			// obj.scaleX = obj.scaleY = s;
			
		}
			
	}
	
	
	
	mod.Waiter = function(speed) {
		
		var makeWaiter = function() {
			console.log("hi from Waiter");
			
			console.log("speed = " + speed);
			
			if ( not(speed) ) speed = 30;
			//speed = Math.min(60, speed);
			//speed = Math.max(10, speed);
			speed = Math.max(10, Math.min(60, speed));
			
			console.log(speed);
			
			
			this.maxTime = 1; // public
			// this.body = new createjs.Container(); // public
			
			var shape = new createjs.Shape();
			var w=100;
			var h=50;
			shape.graphics.f("purple").rr(0,0,w,h,20);
			shape.setBounds(0,0,w,h);
			shape.regX = w/2;
			shape.regY = h/2;
			this.addChild(shape);
			
			var ticker = createjs.Ticker.on("tick", function() {
				shape.rotation += speed;
				stage.update();
			});
			
			checkTime(); // private (local) function
			function checkTime() {
				console.log("checkTime");
			}
			
			this.pause = function() { // public method
				console.log("pause");
			}
			
		}
		makeWaiter.prototype = new createjs.Container();
		makeWaiter.constructor = makeWaiter;
		return new makeWaiter();
		
	}
	
	
	return mod;
}(mod || {});




/*
var mod = function(mod) {
	console.log("hi from mod");
	
	// var mod = {};
	
	mod.mood = "Really Thirsty";
	mod.name = "Dan";
	
	mod.think = function() {
		console.log("thinking");	
	}
	
		
	return mod;
}(mod || {});


var mod = function(mod) {
	console.log("hi from mod2");
	
	// var mod = {};
	
	mod.sleep = function() {
		console.log("sleeping");	
	}
	
		
	return mod;
}(mod || {});
*/


var mod = function(mod) {
	
	// has namespace so can be used outside module
	// but is longer
	// mod.not = function() {
		
	//}
	
	// cannot be used outside namespace
	// can be used in module
	var not = function(p) {
		if (p === null) return true;
		return typeof p === "undefined";
	}
	
	// global scope can be used outside module
	// but wipes out any other not or gets wiped out
	// not = function() {
		
	// }
	
	// function not() {
		
	// }
	
	mod.scaleTo = function(obj, container, percentX, percentY) {
		
		// COLLECTING PARAMETERS
		// zim version of setting a default parameter
		// if ( zot(percentX) ) percentX = 100;
		
		// long version of setting default parameter
		if (not(percentX)) {
			percentX = -1;
		}
		
		if (percentY === null || typeof percentY === "undefined") {
			percentY = -1;
		}
		 
		// short version but be careful with false, 0, ""
		// percentX = (percentX || 100);
		
		console.log("percentX = " + percentX);
		
		if (zot(obj)) return;
		
		if (  not(container) ) {
			if (!obj.getStage()) {
				zog("please add obj to stage before scaling");
				return;
			}
			container = obj.getStage();		
		}
		
		// if (percentX != -1 && percentY != -1) {
			
		console.log(percentX, percentY);
		
		if (percentX >= 0 || percentY >= 0) {
			
			if (percentX >= 0) {
				var w = container.getBounds().width * percentX / 100;
				var sX = w / obj.getBounds().width;
				obj.scaleX = sX;	
			}
			
			if (percentY >= 0) {
				var h = container.getBounds().height * percentY / 100;
				var sY = h / obj.getBounds().height;	
				obj.scaleY = sY;
			}
			
			console.log(sX, sY);
			
			var s;
			if (sX && sY) {
				s = Math.min(sX, sY);
			} else if (sX) {
				s = sX;
			} else if (sY) {
				s = sY;	
			}
			
			// obj.scaleX = obj.scaleY = s;
			
		}
			
	}
	
	
	
	mod.Waiter = function(speed) {
		
		var makeWaiter = function() {
			console.log("hi from Waiter");
			
			console.log("speed = " + speed);
			
			if ( not(speed) ) speed = 30;
			//speed = Math.min(60, speed);
			//speed = Math.max(10, speed);
			speed = Math.max(10, Math.min(60, speed));
			
			console.log(speed);
			
			
			this.maxTime = 1; // public
			// this.body = new createjs.Container(); // public
			
			var shape = new createjs.Shape();
			var w=100;
			var h=50;
			shape.graphics.f("purple").rr(0,0,w,h,20);
			shape.setBounds(0,0,w,h);
			shape.regX = w/2;
			shape.regY = h/2;
			this.addChild(shape);
			
			var ticker = createjs.Ticker.on("tick", function() {
				shape.rotation += speed;
				stage.update();
			});
			
			checkTime(); // private (local) function
			function checkTime() {
				console.log("checkTime");
			}
			
			this.pause = function() { // public method
				console.log("pause");
			}
			
		}
		makeWaiter.prototype = new createjs.Container();
		makeWaiter.constructor = makeWaiter;
		return new makeWaiter();
		
	}
	
	
	return mod;
}(mod || {});




/*
var mod = function(mod) {
	console.log("hi from mod");
	
	// var mod = {};
	
	mod.mood = "Really Thirsty";
	mod.name = "Dan";
	
	mod.think = function() {
		console.log("thinking");	
	}
	
		
	return mod;
}(mod || {});


var mod = function(mod) {
	console.log("hi from mod2");
	
	// var mod = {};
	
	mod.sleep = function() {
		console.log("sleeping");	
	}
	
		
	return mod;
}(mod || {});
*/

