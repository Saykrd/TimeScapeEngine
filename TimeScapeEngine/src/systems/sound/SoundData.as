package systems.sound 
{
	import adobe.utils.CustomActions;
	import away3d.audio.Sound3D;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import interfaces.ITransient;
	/**
	 * ...
	 * @author Saykrd
	 */
	public class SoundData implements ITransient 
	{
		
		private const SAMPLES:int = 4096;
		
		private var _output:Sound               = new Sound;
		private var _sampleBytes:ByteArray      = new ByteArray;
		private var _phase:Number               = 0;
		private var _currentLoop:int            = 0;
		private var _outputChannel:SoundChannel
		private var _playbackData:*
		
		
		
		private var _channelNumber:int = 0;
		public function get channelNumber():int {
			return _channelNumber;
		}
		
		private var _volume:Number = 1;
		public function get volume():Number {
			return _volume;
		}
		
		public function set volume(v:Number):void {
			_volume = v;
			calibrateVolume();
		}
		
		private var _masterVolume:Number = 1;
		public function get masterVolume():Number {
			return _masterVolume;
		}
		
		public function set masterVolume(v:Number):void {
			_masterVolume = v;
			calibrateVolume();
		}
		
		public var playbackSpeed:Number       = 1;
		public var masterPlaybackSpeed:Number = 1;
		public var loopCount:int        = 0;
		public var continuous:Boolean   = false;
		public var playing:Boolean      = false;
		
		private function get _localPlaybackSpeed():Number {
			return playbackSpeed * masterPlaybackSpeed;
		}
		
		public function SoundData(channelNumber:int) 
		{
			_channelNumber = channelNumber;
		}
		
		public function destroy():void 
		{
			_sampleBytes  = null;
			_playbackData = null;
			_output       = null;
		}
		
		public function registerPlaybackData(data:*):void {
			if (!(data is Sound) &&	!(data is ByteArray)) {
				throw new Error("[SoundData] Invalid playback data format.");
			}
			
			_playbackData = data
		}
		
		public function play():void {
			_output.addEventListener(SampleDataEvent.SAMPLE_DATA, onSample);
			_outputChannel = _output.play();
			calibrateVolume();
			playing = true;
		}
		
		public function pause():void {
			_output.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSample);
			_outputChannel.stop();
			playing = false;
		}
		
		public function stop():void {
			_output.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSample);
			_outputChannel.stop();
			reset();
		}
		
		public function reset():void {
			loopCount = 0;
			playing   = false;
			_phase    = 0;
		}
		
		
		private function calibrateVolume():void {
			if (_outputChannel) {
				var tr:SoundTransform         = _outputChannel.soundTransform
				tr.volume                     = _volume * _masterVolume;
				_outputChannel.soundTransform = tr;
			}
		}
		
		private function extractSample(startPos:int):void {
			_sampleBytes.clear()
			if (_playbackData is Sound) {
				var s:Sound     = _playbackData
				s.extract(_sampleBytes, SAMPLES, startPos);
				
			} else if (_playbackData is ByteArray) {
				var d:ByteArray = _playbackData;
				
				d.position = startPos;
				//TODO:Finish
			}
			
			_sampleBytes.position = _localPlaybackSpeed > 0 ? 0 : _sampleBytes.position;
		}
		
		private function onSample(e:SampleDataEvent):void {
			var speed:Number = _localPlaybackSpeed;
			var startPos:int = int(_phase + (SAMPLES * (speed > 0 ? 0 : -1)));
			
			
			extractSample(startPos);
			
			//trace(_sampleBytes.length, _sampleBytes.position, _sampleBytes.bytesAvailable, phase, playbackSpeed, startPos)
			//trace("next pos", int(phase - startPos) * 8)
			while((speed > 0 && _sampleBytes.bytesAvailable > 0) || (speed < 0 && _sampleBytes.position > 0)) {
				
				var p:int = int(_phase - startPos) * 8; //8x Since we are reading 2 floats (4 bytes, one for left audio, one for right)
				
				if (speed < 0) {
					// Iterrate through the array backwards
					
					if (p > 0 && e.data.length <= SAMPLES * 8) {
						_sampleBytes.position = _sampleBytes.length - (_sampleBytes.length - p) - 8
						e.data.writeFloat(_sampleBytes.readFloat());
						e.data.writeFloat(_sampleBytes.readFloat());
					} else {
						_sampleBytes.position = 0;
						e.data.length = _sampleBytes.length;
					}
				} else {
					// Iterrate forwards
					
					if (p < _sampleBytes.length - 8 && e.data.length <= SAMPLES * 8) {
						_sampleBytes.position = p
						e.data.writeFloat(_sampleBytes.readFloat());
						e.data.writeFloat(_sampleBytes.readFloat());
					} else {
						_sampleBytes.position = _sampleBytes.length;
						e.data.length = _sampleBytes.length;
					}
				}
				
				_phase += speed;
				if (_phase < 0) {
					_phase = 0;
					break;
				}
			}
		}
		
	}

}