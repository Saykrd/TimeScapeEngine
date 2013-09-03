package engineTesting.practiceStates 
{
	import architecture.AppState;
	import away3d.events.MouseEvent3D;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import util.Random;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class SoundPractice extends AppState 
	{
		public function SoundPractice(id:String = "DEFAULT") 
		{
			super(id)
			setStartCommand(start)
		}
		
		private var _sound:Sound;
		
		public function start():void {
			trace("STARTING")
			
			DataLoad.startup();
			DataLoad.loadFile("music.mp3", DataType.SOUND, DataCategory.MP3, "music", loaded);
			
		}
		
		public var mp3:Sound;
		public var data:ByteArray;
		public var phase:Number = 0;
		public const SAMPLES:int = 4096;
		public var playbackSpeed:Number = 1.2;
		public var sprite:Sprite
		public function loaded(lObj:LoadObject):void {
			mp3 = DataLoad.getSound("music");
			data = new ByteArray;
			//mp3.play()
			//mp3.extract(data, mp3.length * 44.1);
			data.position = 0//data.length - 8;
			_sound = new Sound;
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSample);
			_sound.play();
			
			
			sprite = new Sprite;
			Main.STAGE.addChild(sprite);
			
			Main.STAGE.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{playbackSpeed -= 0.1})
			
		}
		
		public function onClick(e:MouseEvent):void {
			
		}
		
		public function onSample(e:SampleDataEvent):void {
			data.clear()
			var startPos:int = int(phase + (SAMPLES * (playbackSpeed > 0 ? 0 : -1)));
			mp3.extract(data, SAMPLES, startPos);
			data.position = playbackSpeed > 0 ? 0 : data.position;
			
			
			
			//trace(data.length, data.position, data.bytesAvailable, phase, playbackSpeed, startPos)
			//trace("next pos", int(phase - startPos) * 8)
			while((playbackSpeed > 0 && data.bytesAvailable > 0) || (playbackSpeed < 0 && data.position > 0)) {
				
				var p:int = int(phase - startPos) * 8; //8x Since we are reading 2 floats (4 bytes, one for left audio, one for right)
				
				if (playbackSpeed < 0) {
					// Iterrate through the array backwards
					
					if (p > 0 && e.data.length <= SAMPLES * 8) {
						data.position = data.length - (data.length - p) - 8
						e.data.writeFloat(data.readFloat());
						e.data.writeFloat(data.readFloat());
					} else {
						data.position = 0;
						e.data.length = data.length;
					}
				} else {
					// Iterrate forwards
					
					if (p < data.length - 8 && e.data.length <= SAMPLES * 8) {
						data.position = p
						e.data.writeFloat(data.readFloat());
						e.data.writeFloat(data.readFloat());
					} else {
						data.position = data.length;
						e.data.length = data.length;
					}
				}
				
				phase += playbackSpeed;
				if (phase < 0) {
					phase = 0;
					break;
				}
			}
		}
		
		
		
		override public function update():void {
			super.update();
		}
		
	}

}