package model
{	
	import cadet.core.CadetScene;
	
	import cadet2D.components.renderers.Renderer2D;
	
	import core.app.managers.ResourceManager;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	// This class constructs a CadetEngine 2D scene using the CadetEngine API
	public class SceneModel_Code implements ISceneModel
	{
		private var _cadetScene				:CadetScene;
		private var _renderer				:Renderer2D;
		private var _resourceManager		:ResourceManager;

		private var _parent					:DisplayObjectContainer;
		
		public function SceneModel_Code( resourceManager:ResourceManager )
		{
			_resourceManager 	= resourceManager;
			
			// Create a CadetScene
			_cadetScene = new CadetScene();
			
			// Add a 2D Renderer to the scene
			_renderer = new Renderer2D();
			_cadetScene.children.addItem(_renderer);
		}
	
		public function init(parent:DisplayObjectContainer):void
		{
			_parent 			= parent;
			
			_renderer.viewportWidth = _parent.stage.stageWidth;
			_renderer.viewportHeight = _parent.stage.stageHeight;
			_renderer.enableToExisting(_parent);
			
			_parent.addEventListener( starling.events.Event.ENTER_FRAME, enterFrameHandler );
			
			buildBike();
		}
		
		private function buildBike():void
		{
			// Create motorbike Entity
			// Add VehicleUserControl to motorbike
			// Add Motorbike behaviour to motorbike
			
			// Add PinRear Entity to motorbike
			// Add Pin connection to PinRear
			// Add Transform2D to PinRear
			// Add RevoluteJointBehaviour to PinRear
			// Add PinSkin to PinRear
			
			// Add ShaftRear Entity to motorbike
			// Add Connection to ShaftRear
			// Add Transform2D to ShaftRear
			// Add PrismaticJointBehaviour
			// Add SpringSkin
		}
		
		public function reset():void
		{

		}
		
		public function dispose():void
		{
			_cadetScene.dispose();
			_parent.removeEventListener( starling.events.Event.ENTER_FRAME, enterFrameHandler );	
		}
		
		private function enterFrameHandler( event:starling.events.Event ):void
		{
			_cadetScene.step();
		}
		
		public function get cadetScene():CadetScene
		{
			return _cadetScene;
		}
		
		public function set cadetScene( value:CadetScene ):void
		{
			_cadetScene = value;
		}
	}
}
















