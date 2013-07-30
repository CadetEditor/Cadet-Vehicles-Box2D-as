package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	import vehicles.Main;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class C2D_Box2D_Vehicles_Mobile extends Sprite
	{
		// Starling object.
		private var myStarling:Starling;
		
		public static var instance:Sprite;
		
		public function C2D_Box2D_Vehicles_Mobile()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			instance = this;
		}
		
		// On added to stage. 
		// @param event
		protected function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// Initialize Starling object.
			myStarling = new Starling(Main, stage);
			
			// Define basic anti aliasing.
			myStarling.antiAliasing = 1;
			
			// Show statistics for memory usage and fps.
			myStarling.showStats = true;
			
			// Position stats.
			myStarling.showStatsAt("left", "bottom");
			
			// Start Starling Framework.
			myStarling.start();
		}
	}
}