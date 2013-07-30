package vehicles.model
{
	import cadet.core.CadetScene;
	import cadet.util.ComponentUtil;
	
	import cadet2D.components.renderers.Renderer2D;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	public class SceneModel_XML implements ISceneModel
	{
		private var _parent			:DisplayObjectContainer;
		private var _cadetScene		:CadetScene;
		
		public function SceneModel_XML()
		{
		}
		
		public function init(parent:DisplayObjectContainer):void
		{
			_parent = parent;
			
			// Grab a reference to the Renderer2D and enable it
			var renderer:Renderer2D = ComponentUtil.getChildOfType(_cadetScene, Renderer2D);
			renderer.enableToExisting(parent);
			
			_parent.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
		}
		
		public function get cadetScene():CadetScene
		{
			return _cadetScene;
		}
		
		public function set cadetScene(value:CadetScene):void
		{
			_cadetScene = value;
		}
		
		private function enterFrameHandler( event:Event ):void
		{
			_cadetScene.step();
		}
	}
}