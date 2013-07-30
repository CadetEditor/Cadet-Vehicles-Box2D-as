package vehicles.model
{	
	import flash.geom.Point;
	
	import cadet.components.processes.KeyboardInputMapping;
	import cadet.core.CadetScene;
	import cadet.util.ComponentUtil;
	
	import cadet2D.components.connections.Connection;
	import cadet2D.components.connections.Pin;
	import cadet2D.components.core.Entity;
	import cadet2D.components.geom.AbstractGeometry;
	import cadet2D.components.geom.CircleGeometry;
	import cadet2D.components.geom.PolygonGeometry;
	import cadet2D.components.geom.RectangleGeometry;
	import cadet2D.components.processes.InputProcess2D;
	import cadet2D.components.processes.TrackCamera2DProcess;
	import cadet2D.components.renderers.Renderer2D;
	import cadet2D.components.skins.ConnectionSkin;
	import cadet2D.components.skins.GeometrySkin;
	import cadet2D.components.skins.PinSkin;
	import cadet2D.components.transforms.Transform2D;
	import cadet2D.geom.Vertex;
	
	import cadet2DBox2D.components.behaviours.DistanceJointBehaviour;
	import cadet2DBox2D.components.behaviours.IJoint;
	import cadet2DBox2D.components.behaviours.PrismaticJointBehaviour;
	import cadet2DBox2D.components.behaviours.RevoluteJointBehaviour;
	import cadet2DBox2D.components.behaviours.RigidBodyBehaviour;
	import cadet2DBox2D.components.processes.PhysicsProcess;
	
	import cadet2DBox2DVehicles.components.behaviours.VehicleSideViewBehaviour;
	import cadet2DBox2DVehicles.components.behaviours.VehicleUserControlBehaviour;
	
	import core.app.managers.ResourceManager;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	// This class constructs a CadetEngine 2D scene using the CadetEngine API
	public class SceneModel_Bike implements ISceneModel
	{
		private var _cadetScene				:CadetScene;
		private var _renderer				:Renderer2D;
		private var _resourceManager		:ResourceManager;

		private var _parent					:DisplayObjectContainer;
		
		private var _accelerateMapping		:KeyboardInputMapping;
		private var _brakeMapping			:KeyboardInputMapping;
		private var _steerLeftMapping		:KeyboardInputMapping;
		private var _steerRightMapping		:KeyboardInputMapping;
		
		private var _chassis				:Entity;
		
		public function SceneModel_Bike( resourceManager:ResourceManager )
		{
			_resourceManager 	= resourceManager;
			
			// Create a CadetScene
			_cadetScene = new CadetScene();
			
			// Add a 2D Renderer to the scene
			_renderer = new Renderer2D();
			_cadetScene.children.addItem(_renderer);
			
			// Add Physics Process
			var physics:PhysicsProcess = new PhysicsProcess();
			_cadetScene.children.addItem(physics);	
			
			// Track the motorbike chassis with a tracking camera
			var trackCamera:TrackCamera2DProcess = new TrackCamera2DProcess();
			_cadetScene.children.addItem(trackCamera);
			
			createKeyboardMappings();
			buildBike();
			buildScene();
			
			trackCamera.target = _chassis;
			
		}
	
		public function init(parent:DisplayObjectContainer):void
		{
			_parent 			= parent;
			
			_renderer.viewportWidth = _parent.stage.stageWidth;
			_renderer.viewportHeight = _parent.stage.stageHeight;
			_renderer.enableToExisting(_parent);
			
			_parent.addEventListener( starling.events.Event.ENTER_FRAME, enterFrameHandler );
		}
		
		private function createKeyboardMappings():void
		{
			var inputProcess:InputProcess2D = new InputProcess2D();
			_cadetScene.children.addItem(inputProcess);
			
			_accelerateMapping = new KeyboardInputMapping("ACCELERATE");
			_accelerateMapping.input = KeyboardInputMapping.UP;
			inputProcess.children.addItem( _accelerateMapping );
			
			_brakeMapping = new KeyboardInputMapping("BRAKE");
			_brakeMapping.input = KeyboardInputMapping.DOWN;
			inputProcess.children.addItem( _brakeMapping );
			
			_steerLeftMapping = new KeyboardInputMapping("STEER LEFT");
			_steerLeftMapping.input = KeyboardInputMapping.LEFT;
			inputProcess.children.addItem(_steerLeftMapping);
			
			_steerRightMapping = new KeyboardInputMapping("STEER RIGHT");
			_steerRightMapping.input = KeyboardInputMapping.RIGHT;
			inputProcess.children.addItem(_steerRightMapping);
		}
		
		private function buildScene():void
		{
			// Add floor entity to the scene
			var floor:Entity = createPhysicsEntity(createRectangleGeom(3000, 20), 0, 240, true, "floor");
			_cadetScene.children.addItem(floor);
			
			// Add left wall entity to the scene
			var leftWall:Entity = createPhysicsEntity(createRectangleGeom(20, 230), 10, 10, true, "leftWall");
			_cadetScene.children.addItem(leftWall);
			
			// Add right wall entity to the scene
			var rightWall:Entity = createPhysicsEntity(createRectangleGeom(20, 230), 2980, 10, true, "rightWall");
			_cadetScene.children.addItem(rightWall);
		}
		
		private function buildBike():Entity
		{
			// Create motorbike container Entity
			var motorbike:Entity = new Entity("motorbike");
			_cadetScene.children.addItem(motorbike);
			
			// Add VehicleUserControl to motorbike & link to KeyboardInputMappings
			var userControl:VehicleUserControlBehaviour = new VehicleUserControlBehaviour();
			userControl.accelerateMapping = _accelerateMapping.name;
			userControl.brakeMapping = _brakeMapping.name;
			userControl.steerLeftMapping = _steerLeftMapping.name;
			userControl.steerRightMapping = _steerRightMapping.name;
			motorbike.children.addItem(userControl);
			
			// Add vehicle behaviour to motorbike
			var vehicleBehaviour:VehicleSideViewBehaviour = new VehicleSideViewBehaviour();
			motorbike.children.addItem(vehicleBehaviour);
			
			// Add chassis entity
			var vertices:Array = new Array(new Vertex(0,0), new Vertex(110,-20), new Vertex(90,50), new Vertex(40,50));
			_chassis = createPhysicsEntity(createPolygonGeom(vertices), 100, 100, false, "chassis");
			motorbike.children.addItem(_chassis);
			
			// Add front wheel entity to motorbike
			var frontWheel:Entity = createPhysicsEntity(createCircleGeom(30), 240, 160, false, "frontWheel");
			motorbike.children.addItem(frontWheel);
			
			// Add rear wheel entity to motorbike
			var rearWheel:Entity = createPhysicsEntity(createCircleGeom(30), 90, 160, false, "rearWheel");
			motorbike.children.addItem(rearWheel);
			
			// Add front wheel block entity to motorbike
			var frontWheelBlock:Entity = createPhysicsEntity(createRectangleGeom(20, 20), 230, 150, false, "frontWheelBlock");
			motorbike.children.addItem(frontWheelBlock);
			
			// Add rear wheel block entity to motorbike
			var rearWheelBlock:Entity = createPhysicsEntity(createRectangleGeom(20, 20), 80, 150, false, "rearWheelBlock");
			motorbike.children.addItem(rearWheelBlock);

			// Front axle for front wheel
			var transformA:Transform2D = ComponentUtil.getChildOfType(frontWheelBlock, Transform2D);
			var transformB:Transform2D = ComponentUtil.getChildOfType(frontWheel, Transform2D);
			// Update the names of the transforms so it's clearer when inspecting the Pin joint in the editor
			transformA.name = "frontWheelBlock Transform2D";
			transformB.name = "frontWheel Transform2D";
			var frontAxle:Entity = createPinEntity(235, 155, transformA, transformB, new Point(10, 10), "frontAxle");
			motorbike.children.addItem(frontAxle);
			
			// Rear axle for rear wheel
			transformA = ComponentUtil.getChildOfType(rearWheelBlock, Transform2D);
			transformB = ComponentUtil.getChildOfType(rearWheel, Transform2D);
			// Update the names of the transforms so it's clearer when inspecting the Pin joint in the editor
			transformA.name = "rearWheelBlock Transform2D";
			transformB.name = "rearWheel Transform2D";
			var rearAxle:Entity = createPinEntity(85, 155, transformA, transformB, new Point(10, 10), "rearAxle");
			motorbike.children.addItem(rearAxle);
			
			// Add front suspension
			transformA = ComponentUtil.getChildOfType(_chassis, Transform2D);
			transformB = ComponentUtil.getChildOfType(frontWheelBlock, Transform2D);
			// Update the names of the transforms so it's clearer when inspecting the Pin joint in the editor
			transformA.name = "chassis Transform2D";
			var frontSuspension:Entity = createConnectionEntity(transformA, 
															    transformB, 
																new Point(90, 0), 
																new Point(10, 10),
																createPrismaticJoint(true, 10),
																"frontSuspension");
			motorbike.children.addItem(frontSuspension);
			
			// Add rear suspension
			transformB = ComponentUtil.getChildOfType(rearWheelBlock, Transform2D);
			var rearSuspension:Entity = createConnectionEntity(transformA, 
															   transformB, 
															   new Point(20, 10), 
															   new Point(10, 10), 
															   createPrismaticJoint(true, 10),
															   "rearSuspension");
			motorbike.children.addItem(rearSuspension);
			
			// Set vehicle behaviour properties
			vehicleBehaviour.frontDriveShaft = frontAxle;
			vehicleBehaviour.rearDriveShaft = rearAxle;
			vehicleBehaviour.chasis = _chassis;
			//vehicleBehaviour.maxTorque = -2;
			
			return motorbike;
		}
		
		/* createPhysicsEntity
		* Utility function: Creates a general purpose physics entity
		* receives a geometry argument
		*/
		private function createPhysicsEntity(geom:AbstractGeometry, x:Number = 0, y:Number = 0, fixed:Boolean = false, name:String = null):Entity
		{
			var entity:Entity = new Entity();
			if (name) entity.name = name;
			entity.children.addItem(geom);
			// Add skin to entity
			var geomSkin:GeometrySkin = new GeometrySkin();
			entity.children.addItem(geomSkin);
			// Add transform to entity
			var transform:Transform2D = new Transform2D(x, y);
			entity.children.addItem(transform);
			var rigidBody:RigidBodyBehaviour = new RigidBodyBehaviour(fixed);
			entity.children.addItem(rigidBody);
			
			return entity;
		}
		
		private function createPolygonGeom(vertices:Array):PolygonGeometry
		{
			var geom:PolygonGeometry = new PolygonGeometry();
			geom.vertices = vertices;
			
			return geom;
		}
		
		private function createCircleGeom(radius:Number = 50):CircleGeometry
		{
			var geom:CircleGeometry = new CircleGeometry();
			geom.radius = radius;
			
			return geom;
		}
		
		private function createRectangleGeom(width:Number = 50, height:Number = 50):RectangleGeometry
		{
			var geom:RectangleGeometry = new RectangleGeometry(width, height);
			
			return geom;
		}
		
		private function createPinEntity(x:Number, y:Number, transformA:Transform2D, transformB:Transform2D, localPos:Point = null, name:String = null):Entity
		{
			var vertex:Vertex = new Vertex();
			if ( localPos ) {
				vertex.x = localPos.x;
				vertex.y = localPos.y;
			}
			
			var entity:Entity = new Entity();
			if (name) entity.name = name;
			
			var pin:Pin = new Pin();
			pin.transformA = transformA;
			pin.transformB = transformB;
			pin.localPos = vertex;
			entity.children.addItem(pin);
			
			var transform:Transform2D = new Transform2D(x, y);
			entity.children.addItem(transform);
			
			var skin:PinSkin = new PinSkin();
			skin.radius = 5;
			entity.children.addItem(skin);
			
			var joint:RevoluteJointBehaviour = new RevoluteJointBehaviour();
			entity.children.addItem(joint);
			
			return entity;
		}
		
		/* createConnectionEntity
		* Utility function: Creates a general purpose connection entity
		* receives an optional joint argument
		*/
		private function createConnectionEntity(transformA:Transform2D, transformB:Transform2D, pointA:Point = null, pointB:Point = null, joint:IJoint = null, name:String = null):Entity
		{
			var entity:Entity = new Entity();
			if (name) entity.name = name;
			
			var vertexA:Vertex = new Vertex();
			if ( pointA ) {
				vertexA.x = pointA.x;
				vertexA.y = pointA.y;
			}
			
			var vertexB:Vertex = new Vertex();
			if ( pointB ) {
				vertexB.x = pointB.x;
				vertexB.y = pointB.y;
			}
			
			var connection:Connection = new Connection();
			connection.transformA = transformA;
			connection.transformB = transformB;
			connection.localPosA = vertexA;
			connection.localPosB = vertexB;
			entity.children.addItem(connection);
			
			var skin:ConnectionSkin = new ConnectionSkin();
			entity.children.addItem(skin);

			if (!joint)	joint = new DistanceJointBehaviour();
			entity.children.addItem(joint);
			
			return entity;			
		}
		
		private function createPrismaticJoint(enableMotor:Boolean = false, maxMotorForce:Number = 1):PrismaticJointBehaviour
		{
			var joint:PrismaticJointBehaviour = new PrismaticJointBehaviour();
			joint.enableMotor = enableMotor;
			joint.maxMotorForce  = maxMotorForce
			return joint;
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
















