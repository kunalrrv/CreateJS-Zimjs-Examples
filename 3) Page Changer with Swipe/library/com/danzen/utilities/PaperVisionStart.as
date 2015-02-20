package com.danzen.utilities {
	
	// PaperVisionStart is a base class which you can extend like so:
	// MyClass extends PaperVisionStart {
	// then in your MyClass constructor run the init() function
	// then make your shapes, etc.
	// then override the animate3D() method like so:
	// override protected function animate3D():void {
	// in there make any updates to your shape or camera properties
	
	import flash.display.Sprite; 
	import flash.events.Event; 
	
	// import classes needed
	// see http://papervision3d.googlecode.com for classes and documentation
	
	import org.papervision3d.view.Viewport3D; 
	import org.papervision3d.render.BasicRenderEngine; 
	import org.papervision3d.scenes.Scene3D; 
	import org.papervision3d.cameras.Camera3D;
	
	public class PaperVisionStart extends Sprite {
				
		public var myViewport:Viewport3D; // what you look at the 3D stuff through
		public var myRenderer:BasicRenderEngine; // handles drawing the 3D
		public var myScene:Scene3D; // a scene holding 3D
		public var myCamera:Camera3D; // a camera through which the scenes are viewed
				
		public function init(w:Number=0, h:Number=0):void {			
			if (w == 0) {
				myViewport = new Viewport3D(stage.stageWidth, stage.stageHeight, true, true);
			}else{
				myViewport = new Viewport3D(w, h, false, true);
			}	
			addChild(myViewport); 
			myRenderer = new BasicRenderEngine();
			myScene = new Scene3D();
			myCamera = new Camera3D();			
			
			addEventListener(Event.ENTER_FRAME, animate);
		}
		
		protected function animate3D():void {
			// override this protected function to make 3D movement and changes
		}
		
		protected function animate(e:Event):void {
			animate3D();
			myRenderer.renderScene(myScene, myCamera, myViewport);
		}
		
	}
	
}