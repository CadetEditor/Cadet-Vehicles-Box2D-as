package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import cadet.core.CadetScene;
	
	import cadet2D.operations.Cadet2DStartUpOperation;
	
	import model.ISceneModel;
	import model.SceneModel_XML;
	
	[SWF( width="800", height="600", backgroundColor="0x002135", frameRate="60" )]
	public class C2D_Box2D_Motorbike extends Sprite
	{
		private var _sceneModel			:ISceneModel;
		private var _cadetFileURL		:String = "/motorbike2.cdt2d";	
		
		public function C2D_Box2D_Motorbike()
		{
			// Required when loading data and assets.
			var startUpOperation:Cadet2DStartUpOperation = new Cadet2DStartUpOperation(_cadetFileURL);
			startUpOperation.addManifest( startUpOperation.baseManifestURL + "Cadet2DBox2D.xml");
			startUpOperation.addEventListener(flash.events.Event.COMPLETE, startUpCompleteHandler);
			startUpOperation.execute();
		}
		
		private function startUpCompleteHandler( event:Event ):void
		{
			var operation:Cadet2DStartUpOperation = Cadet2DStartUpOperation( event.target );
			
			if ( _cadetFileURL ) {
				_sceneModel = new SceneModel_XML();
				_sceneModel.cadetScene = CadetScene(operation.getResult());
			}
			
			_sceneModel.init(this);
		}
	}
}