package systems.sound 
{
	import flash.media.SoundCodec;
	import flash.utils.ByteArray;
	import interfaces.ITransient;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class SoundModule implements ITransient
	{
		
		private const MAX_CHANNELS:int = 12;
		
		private var _soundChannels:Vector.<SoundData>;
		private var _channelEffects:Vector.<Object>;
		private var _masterVolume:Number        = 1;
		private var _masterPlaybackSpeed:Number = 1;
		
		public function SoundModule() 
		{
			init();
		}
		
		/* INTERFACE interfaces.ITransient */
		
		public function destroy():void 
		{
			for (var i:int = 0; i < MAX_CHANNELS; i++) {
				var soundData:SoundData = getDataForChannel(i);
				soundData.destroy();
			}
			
			_soundChannels.length  = 0;
			_channelEffects.length = 0;
			
			_soundChannels  = null;
			_channelEffects = null;
			
		}
		
		public function init():void {
			_soundChannels  = new Vector.<SoundData>;
			_channelEffects = new Vector.<Object>;
			
			//Allocate space in the sound channels vector
			for (var i:uint = 0; i < MAX_CHANNELS; i++) {
				var data:SoundData = new SoundData(i);
				_soundChannels.push(data);
			}
		}
		
		public function getDataForChannel(channelNum:int):SoundData {
			if (channelNum >= MAX_CHANNELS) {
				throw new Error("[SoundModule] Channel " + channelNum + " exceeds max number of channels: " + MAX_CHANNELS);
			}
			
			if (channelNum < 0) {
				throw new Error("[SoundModule] Channel number cannot be negative!");
			}
			
			return _soundChannels[channelNum];
		}
		
		public function addTrackToChannel(playbackData:*, channelNum:int):void {
			var soundData:SoundData = getDataForChannel(channelNum);
			
			soundData.registerPlaybackData(playbackData);
		}
		
		public function setMasterVolume(v:Number):void {
			_masterVolume = v;
			
			for (var i:int = 0; i < MAX_CHANNELS; i++) {
				var soundData:SoundData = getDataForChannel(i);
				soundData.masterVolume = _masterVolume;
			}
		}
		
		public function setChannelVolume(v:Number, channelNum:int):void {
			var soundData:SoundData = getDataForChannel(channelNum);
			
			soundData.volume = v;
		}
		
		public function setMasterPlaybackSpeed(v:Number):void {
			_masterPlaybackSpeed = v;
			
			for (var i:int = 0; i < MAX_CHANNELS; i++) {
				var soundData:SoundData = getDataForChannel(i);
				soundData.masterPlaybackSpeed = _masterPlaybackSpeed;
			}
		}
		
		public function setChannelPlayBackSpeed(v:Number, channelNum:int):void {
			var soundData:SoundData = getDataForChannel(channelNum);
			
			soundData.playbackSpeed = v;
		}
		
		public function playChannel(channelNum:int):void {
			var soundData:SoundData = getDataForChannel(channelNum);
			
			soundData.play();
		}
		
		public function stopChannel(channelNum:int):void {
			var soundData:SoundData = getDataForChannel(channelNum);
			
			soundData.stop();
		}
		
		public function pauseChannel(channelNum:int):void {
			var soundData:SoundData = getDataForChannel(channelNum);
			
			soundData.pause();
		}
		
		public function playAll():void {
			for (var i:int = 0; i < MAX_CHANNELS; i++) {
				playChannel(i);
			}
		}
		
		public function stopAll():void {
			for (var i:int = 0; i < MAX_CHANNELS; i++) {
				stopChannel(i);
			}
		}
		
		public function pauseAll():void {
			for (var i:int = 0; i < MAX_CHANNELS; i++) {
				pauseChannel(i);
			}
		}
		
		public function addEffect(effectType:int, channelNum:int, params:Object):void {
			var effect:Object = { };
			effect.effectType = effectType;
			effect.channelNum = effect.channelNum;
			
			for (var k:String in params) {
				effect[k] = params[k];
			}
			
			_channelEffects.push(effect);
		}
		
	}

}