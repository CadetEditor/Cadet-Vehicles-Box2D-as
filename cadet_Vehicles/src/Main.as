package
{
	import flash.events.Event;
	
	import cadet.core.CadetScene;
	
	import cadet2D.operations.Cadet2DStartUpOperation;
	
	import core.app.CoreApp;
	import core.app.util.AsynchronousUtil;
	
	import model.ISceneModel;
	import model.SceneModel_Code;
	import model.SceneModel_XML;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		public static var gameModel			:ISceneModel;
		
		// Comment out either of the below to switch ISceneModels.
		// URL = GameModel_XML, null = GameModel_Code
//		private var _cadetFileURL		:String = "/motorbike.cdt2d";
		private var _cadetFileURL		:String = null;
		
		public function Main()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:starling.events.Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			// Required when loading data and assets.
			var startUpOperation:Cadet2DStartUpOperation = new Cadet2DStartUpOperation(_cadetFileURL);
			startUpOperation.addManifest( startUpOperation.baseManifestURL + "Cadet2DBox2D.xml");
			startUpOperation.addEventListener(flash.events.Event.COMPLETE, startUpCompleteHandler);
			startUpOperation.execute();
		}
		
		private function startUpCompleteHandler( event:flash.events.Event ):void
		{
			var operation:Cadet2DStartUpOperation = Cadet2DStartUpOperation( event.target );
			
			// If a _cadetFileURL is specified, load the external CadetScene from XML
			// Otherwise, revert to the coded version of the CadetScene.
			if ( _cadetFileURL ) {
				gameModel = new SceneModel_XML();
				gameModel.cadetScene = CadetScene(operation.getResult());
			} else {
				gameModel = new SceneModel_Code( CoreApp.resourceManager );
				
				// Need to wait for the next frame to serialize, otherwise the manifests aren't ready
				//AsynchronousUtil.callLater(serialize);
			}

			// Initialize screens.
			AsynchronousUtil.callLater(init);
		}
		
		private function init():void
		{
			gameModel.init(this);
		}
		
		private function serialize():void
		{
//			var eventDispatcher:EventDispatcher = SerializationUtil.serialize(gameModel.cadetScene);
//			eventDispatcher.addEventListener(flash.events.Event.COMPLETE, serializationCompleteHandler);
		}
		
		private function serializationCompleteHandler( event:flash.events.Event ):void
		{
//			trace(SerializationUtil.getResult().toXMLString());
		}
	}
}











