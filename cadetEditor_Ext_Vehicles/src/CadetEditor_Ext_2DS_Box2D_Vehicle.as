package
{
	import flash.display.Sprite;
	
	import cadet.assets.CadetEngineIcons;
	import cadet.entities.ComponentFactory;
	
	import cadet2D.components.core.Entity;
	
	import cadet2DBox2DVehicles.components.behaviours.VehiclePlanViewBehaviour;
	import cadet2DBox2DVehicles.components.behaviours.VehiclePlanViewBehaviour;
	import cadet2DBox2DVehicles.components.behaviours.VehicleSideViewBehaviour;
	import cadet2DBox2DVehicles.components.behaviours.VehicleUserControlBehaviour;
	
	import core.app.CoreApp;
	import core.app.managers.ResourceManager;
	
	public class CadetEditor_Ext_2DS_Box2D_Vehicle extends Sprite
	{
		public function CadetEditor_Ext_2DS_Box2D_Vehicle()
		{
			var resourceManager:ResourceManager = CoreApp.resourceManager;
			
			resourceManager.addResource( new ComponentFactory( VehiclePlanViewBehaviour, 	"Vehicle (Plan View)", 			"Behaviours", 	CadetEngineIcons.Behaviour,	Entity, 	1 ) );
			resourceManager.addResource( new ComponentFactory( VehicleSideViewBehaviour, 	"Vehicle (Side View)",			"Behaviours", 	CadetEngineIcons.Behaviour,	Entity, 	1 ) );
			resourceManager.addResource( new ComponentFactory( VehicleUserControlBehaviour, "Vehicle User Control", 		"Behaviours", 	CadetEngineIcons.Behaviour,	Entity, 	1 ) );
		}
	}
}