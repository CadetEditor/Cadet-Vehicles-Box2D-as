package vehicles 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import cadet.core.CadetScene;
	
	import cadet2D.operations.Cadet2DStartUpOperation;
	
	import core.app.CoreApp;
	import core.app.util.AsynchronousUtil;
	import core.app.util.SerializationUtil;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import vehicles.model.ISceneModel;
	import vehicles.model.SceneModel_Bike;
	import vehicles.model.SceneModel_BoxCar;
	import vehicles.model.SceneModel_XML;

	public class Main extends Sprite
	{
		public static var gameModel			:ISceneModel;

		public static var cadetFileURL		:String = null;
		public static var fileSystemType	:String = "url";
		
		public static var originalStageWidth:Number;
		public static var originalStageHeight:Number;
		
		public function Main()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:starling.events.Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			var star:Starling = Starling.current;
			var xScalar:Number = star.stage.stageWidth / originalStageWidth;
			var yScalar:Number = star.stage.stageHeight / originalStageHeight;
			
			star.stage.stageWidth /= xScalar;
			star.stage.stageHeight /= yScalar;
			
			// Required when loading data and assets.
			var startUpOperation:Cadet2DStartUpOperation = new Cadet2DStartUpOperation(cadetFileURL);
			startUpOperation.addManifest( startUpOperation.baseManifestURL + "Cadet2DBox2D.xml");
			startUpOperation.addManifest( startUpOperation.baseManifestURL + "Cadet2DBox2DVehicles.xml");
			startUpOperation.addEventListener(flash.events.Event.COMPLETE, startUpCompleteHandler);
			startUpOperation.execute();
		}
		
		private function startUpCompleteHandler( event:flash.events.Event ):void
		{
			var operation:Cadet2DStartUpOperation = Cadet2DStartUpOperation( event.target );
			
			// If a _cadetFileURL is specified, load the external CadetScene from XML
			// Otherwise, revert to the coded version of the CadetScene.
			if ( cadetFileURL ) {
				gameModel = new SceneModel_XML();
				gameModel.cadetScene = CadetScene(operation.getResult());
			} else {
				gameModel = new SceneModel_Bike( CoreApp.resourceManager );
				//gameModel = new SceneModel_BoxCar( CoreApp.resourceManager );
				
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
			var eventDispatcher:EventDispatcher = SerializationUtil.serialize(gameModel.cadetScene);
			eventDispatcher.addEventListener(flash.events.Event.COMPLETE, serializationCompleteHandler);
		}
		
		private function serializationCompleteHandler( event:flash.events.Event ):void
		{
			trace(SerializationUtil.getResult().toXMLString());
		}
	}
}











