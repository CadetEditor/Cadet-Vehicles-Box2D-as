// =================================================================================================
//
//	CadetEngine Framework
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package cadet2DBox2DVehicles.components.behaviours
{
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	
	import cadet.core.Component;
	import cadet.core.IComponentContainer;
	import cadet.core.ISteppableComponent;
	import cadet.util.ComponentReferenceUtil;
	
	import cadet2DBox2D.components.behaviours.RevoluteJointBehaviour;
	import cadet2DBox2D.components.behaviours.RigidBodyBehaviour;

	public class VehicleSideViewBehaviour extends Component implements ISteppableComponent, IVehicleBehaviour
	{
		private var _acceleration			:Number = 0; // 0 or 1
		private var _brake					:Number = 0; // 0 or 1
		private var _steering				:Number = 0; // -1, 0 or 1
		private var _direction				:Number = 0; // -1, 0 or 1
		
		[Serializable][Inspectable(priority="104")]
		public var maxTorque				:Number = -2;
		
		[Serializable][Inspectable(priority="105")]
		public var brakeTorque				:Number = 1;
		
		[Serializable][Inspectable(priority="106")]
		public var maxSpeed					:Number = 60;
		
		[Serializable][Inspectable(priority="107")]
		public var maxChasisTorque			:Number = 8;
		
		private var _rearDriveShaft			:IComponentContainer;	// A Pin Entity
		private var _frontDriveShaft		:IComponentContainer;	// A Pin Entity
		private var _chasis					:IComponentContainer;
		
		/* 	transmission
		*	A value between 0 and 1
		*	0 = rear wheel drive
		*	0.5 = front & rear wheel drive
		*	1 = front wheel drive
		*/
		private var _transmission			:Number = 0;
		
		public var rearWheelJoint			:RevoluteJointBehaviour;
		public var frontWheelJoint			:RevoluteJointBehaviour;
		public var chasisRigidBody			:RigidBodyBehaviour;
		
		public function VehicleSideViewBehaviour( name:String = "VehicleBehaviour (SideView)" )
		{
			super(name);
		}
		
		// VehicleUserControl API
		public function set acceleration( value:Number ):void 
		{ 
			_acceleration = value;
			
			if (_acceleration) {
				_direction = 1;
			} else if (_direction != -1 ) {
				_direction = 0;
			}
		}
		public function get acceleration():Number { return _acceleration; }
		public function set brake( value:Number ):void 
		{ 
			_brake = value;
			
			if (_brake) {
				_direction = -1;
			} else if (_direction != 1) {
				_direction = 0;
			}
		}
		public function get brake():Number { return _brake; }
		public function set steering( value:Number ):void { _steering = value; }
		public function get steering():Number { return _steering; }
		
		
		[Serializable][Inspectable( priority="103", editor="Slider", min="0", max="1", snapInterval="0.1" )]
		public function set transmission( value:Number ):void
		{
			// Limit to a value between 0 & 1 inclusive
			value = Math.min(value, 1);
			value = Math.max(value, 0);
			_transmission = value;
		}
		public function get transmission():Number { return _transmission; }
		
		
		[Serializable][Inspectable( editor="ComponentList", priority="100" )]
		public function set rearDriveShaft( value:IComponentContainer ):void
		{
			if ( _rearDriveShaft ) {
				ComponentReferenceUtil.removeReferenceByType(  _rearDriveShaft, RevoluteJointBehaviour, this, "rearWheelJoint" );
			}
			_rearDriveShaft = value;
			if ( _rearDriveShaft ) {
				ComponentReferenceUtil.addReferenceByType( _rearDriveShaft, RevoluteJointBehaviour, this, "rearWheelJoint" );
			}
		}
		public function get rearDriveShaft():IComponentContainer { return _rearDriveShaft; }
		
		[Serializable][Inspectable( editor="ComponentList", priority="101" )]
		public function set frontDriveShaft( value:IComponentContainer ):void
		{
			if ( _frontDriveShaft ) {
				ComponentReferenceUtil.removeReferenceByType(  _frontDriveShaft, RevoluteJointBehaviour, this, "frontWheelJoint" );
			}
			_frontDriveShaft = value;
			if ( _frontDriveShaft ) {
				ComponentReferenceUtil.addReferenceByType( _frontDriveShaft, RevoluteJointBehaviour, this, "frontWheelJoint" );
			}
		}
		public function get frontDriveShaft():IComponentContainer { return _frontDriveShaft; }
		
		[Serializable][Inspectable( editor="ComponentList", priority="102" )]
		public function set chasis( value:IComponentContainer ):void
		{
			//trace("set chasis : " + (value ? value.name : "null"));
			if ( _chasis ) {
				ComponentReferenceUtil.removeReferenceByType(  _chasis, RigidBodyBehaviour, this, "chasisRigidBody" );
			}
			_chasis = value;
			if ( _chasis ) {
				ComponentReferenceUtil.addReferenceByType( _chasis, RigidBodyBehaviour, this, "chasisRigidBody" );
			}
		}
		public function get chasis():IComponentContainer { return _chasis; }
		
		
		public function step( dt:Number ):void
		{
			if ( !rearWheelJoint ) return;
			if ( !chasisRigidBody ) return;
			if ( !frontWheelJoint ) return;
			
			//trace("test acceleration "+acceleration+" brake "+brake+" direction "+_direction);
			
			rearWheelJoint.enableMotor = true;
			frontWheelJoint.enableMotor = true;
			
			//
			var torque:Number = (_acceleration * maxTorque) + (_brake * brakeTorque);
			//var speed:Number = (1-_brake) * maxSpeed;
			
			//var torque:Number = Math.abs(_direction) * maxTorque; // Torque == maxTorque or 0
			var speed:Number = _direction * maxSpeed; // Speed == -maxSpeed, 0 or maxSpeed
			
			//trace("1 torque "+torque+" speed "+speed);
			
			// Default transmission == 0, so default is full rear wheel drive
			rearWheelJoint.maxMotorTorque = torque * (1-_transmission);
			rearWheelJoint.motorSpeed = speed;
			
			frontWheelJoint.maxMotorTorque = torque * _transmission;
			frontWheelJoint.motorSpeed = speed;
			
			// Apply an equal and opposite force to the chasis to simulate a downforce, keeping the motorcycle stuck to the ground
			var _rearWheelJoint:b2RevoluteJoint = rearWheelJoint.getJoint();
			if ( _rearWheelJoint ) {
				chasisRigidBody.applyTorque( _rearWheelJoint.GetMotorTorque() * 1 );
			}
			
			//rearWheelJoint.motorSpeed *= 1-_brake; 
			//frontWheelJoint.motorSpeed *= 1-_brake; 
			
			var ratio:Number = Math.abs(chasisRigidBody.getBody().GetAngularVelocity() / 2.5);
			ratio = ratio < 0 ? 0 : ratio > 1 ? 1 : ratio;
			ratio = 1-ratio;
			chasisRigidBody.applyTorque( _steering * maxChasisTorque * ratio );
		}
	}
}