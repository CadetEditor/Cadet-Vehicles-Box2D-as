package model
{
	import cadet.core.CadetScene;
	
	import starling.display.DisplayObjectContainer;
	
	public interface ISceneModel
	{
		function init( parent:DisplayObjectContainer ):void
		
		function get cadetScene():CadetScene
		function set cadetScene( value:CadetScene ):void
	}
}