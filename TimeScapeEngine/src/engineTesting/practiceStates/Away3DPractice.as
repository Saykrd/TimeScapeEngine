package engineTesting.practiceStates 
{
	import adobe.utils.CustomActions;
	import architecture.AppState;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import util.Random;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class Away3DPractice extends AppState 
	{
		
		private var view:View3D;
		private var world:AWPDynamicsWorld;
		private var light:PointLight;
		
		public function Away3DPractice(id:String) 
		{
			super(id);
			setStartCommand(start);
		}
		
		public function start():void {
			view = new View3D();
			
			world = AWPDynamicsWorld.getInstance();
			world.initWithDbvtBroadphase();
			
			Main.STAGE.addChild(view);
			
			light = new PointLight();
			light.y = 1000;
			light.z = -700;
			light.color = 0x444444;
			
			view.scene.addChild(light);
			view.camera.z = -600;
			view.camera.y =  500;
			
			view.camera.lookAt(new Vector3D(0, 0, 0));
			
			var floor:Mesh = new Mesh(new CubeGeometry(1000, 5, 1000));
			var material:ColorMaterial = new ColorMaterial(0xFFFF00);
			
			material.lightPicker = new StaticLightPicker([light]);
			floor.material = material;
			
			view.scene.addChild(floor);
			
			var floorShape:AWPBoxShape = new AWPBoxShape(1000, 5, 1000);
			var floorRigidBody:AWPRigidBody = new AWPRigidBody(floorShape, floor, 0);
			
			floorRigidBody.friction = 1;
			floorRigidBody.position = new Vector3D(0, 0, 0);
			
			var cubeMesh:Mesh = new Mesh(new CubeGeometry(50,50,50));
			cubeMesh.material = new ColorMaterial();
			cubeMesh.material.lightPicker = new StaticLightPicker([light]);
			view.scene.addChild(cubeMesh);
			
			var cubeShape:AWPBoxShape = new AWPBoxShape(50, 50, 50);
			var cubeRigidBody:AWPRigidBody = new AWPRigidBody(cubeShape);
			world.addRigidBody(cubeRigidBody);
			cubeRigidBody.friction = 1;
			cubeRigidBody.position = new Vector3D(Math.random() * 600 - 300, 400, Math.random() * 600 - 300);
			
            Main.STAGE.addEventListener(MouseEvent.CLICK,addCube);
		}
		
		private function addCube(e:MouseEvent):void {
            var cubeMesh:Mesh=new Mesh(new CubeGeometry(50,50,50));
            cubeMesh.material=new ColorMaterial();
            cubeMesh.material.lightPicker = new StaticLightPicker([light]);
            view.scene.addChild(cubeMesh);
            var cubeShape:AWPBoxShape=new AWPBoxShape(50,50,50);
            var cubeRigidBody:AWPRigidBody=new AWPRigidBody(cubeShape,cubeMesh,1); // notice the final "1" as it's dynamic
            world.addRigidBody(cubeRigidBody);
            cubeRigidBody.friction=1;
            cubeRigidBody.position=new Vector3D(Math.random()*600-300,400,Math.random()*600-300);
        }
		
		public function update():void {
			world.step(1 / 30, 1);
			view.render();
		}
		
		
		
	}

}