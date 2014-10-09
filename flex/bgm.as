private var soundDic:Dictionary   = new Dictionary();
private var channelDic:Dictionary = new Dictionary();
private var isMute:Boolean = false;
private var isFade:Boolean = false;
private var index:int = 0;

private function init():void {
	var param:Object = this.parameters;
	var requestUrl:String = param['url'];
	var names:String  = param['names'];
	var audioList:Array = names.split(',');
	index = audioList.length;
	for(var i:int = 0; i < index; i++){
		var url:URLRequest = new URLRequest(requestUrl + audioList[i]);
		var s:String = i.toString();
		soundDic[s] = new Sound(url);
	}
}

// 再生
private function asPlay(s:String, f:Boolean):void {
	if(soundDic.hasOwnProperty(s)){
		var t:SoundTransform = new SoundTransform();
		if(isMute || isFade){ t.volume = 0.0; }
		else{ t.volume = 1.0; }
		var sound:Sound = soundDic[s] as Sound;
		channelDic[s] = sound.play(0, 0, t);
		if(f){
			channelDic[s].addEventListener(Event.SOUND_COMPLETE, playend(s));
		}
	}
}

// フェードしながら再生
private function asFadePlay(s:String, f:Boolean):void {
	if(soundDic.hasOwnProperty(s)){
		isFade = true;
		var t:SoundTransform = new SoundTransform();
		if(isMute || isFade){ t.volume = 0.0; }
		else{ t.volume = 1.0; }
		var sound:Sound = soundDic[s] as Sound;
		channelDic[s] = sound.play(0, 0, t);
		asFadeIn();
		if(f){
			channelDic[s].addEventListener(Event.SOUND_COMPLETE, playend(s));
		}
	}
}

private function playend(s:String):Function {
	return function(e:Event):void {
		var t:SoundTransform = new SoundTransform();
		if(isMute || isFade){ t.volume = 0.0; }
		else{ t.volume = 1.0; }
		var sound:Sound = soundDic[s] as Sound;
		channelDic[s] = sound.play(0, 0, t);
		channelDic[s].addEventListener(Event.SOUND_COMPLETE, playend(s));
	}
}

// ミュート
private function asMute():void {
	if(!isMute){
		for (var i:int = 0; i < index; i++){
			var s:String = i.toString();
			if(channelDic.hasOwnProperty(s)){
				try{
					var t:SoundTransform = new SoundTransform();
					t.volume = 0.0;
					channelDic[s].soundTransform = t;
				}catch(e:Error){
				}
			}
		}
	}
	isMute = true;
}

// アンミュート
private function asUnMute():void {
	if(isMute){
		for (var i:int = 0; i < index; i++){
			var s:String = i.toString();
			if(channelDic.hasOwnProperty(s)){
				try{
					var t:SoundTransform = new SoundTransform();
					t.volume = 1.0;
					channelDic[s].soundTransform = t;
				}catch(e:Error){
				}
			}
		}
	}
	isMute = false;
}

// 初期化
private function comp():void {
	try{
		ExternalInterface.addCallback('jsPlay', asPlay);
		ExternalInterface.addCallback('jsFadePlay', asFadePlay);
		ExternalInterface.addCallback('jsMute', asMute);
		ExternalInterface.addCallback('jsUnMute', asUnMute);
		ExternalInterface.addCallback('jsFadeOut', asFadeOut);
		ExternalInterface.addCallback('jsFadeIn', asFadeIn);
		
		onLoadComplete();
	}catch(e:Error){
		//Alert.show(e.toString());
	}
}

// 音ファイルのFadeOut
private var fadeOutVol:Number = 10;
private function asFadeOut():void {
	if(!isFade && !isMute){
		for (var i:int = 0; i < index; i++){
			var s:String = i.toString();
			if(channelDic.hasOwnProperty(s)){
				try{
					var t:SoundTransform = new SoundTransform();
					var _v:Number = --fadeOutVol / 10
					t.volume = _v;
					channelDic[s].soundTransform = t;
				}catch(e:Error){
				}
			}
		}
		if(fadeOutVol <= 0){
			fadeOutComplete(arguments[0]);
		}else{
			setTimeout(asFadeOut, 100, arguments[0]);
		}
	}else{
		if(!isFade){
			fadeOutComplete(arguments[0]);
		}
	}
}

private function fadeOutComplete(str:String):void {
	try{
		ExternalInterface.call('fadeOutComplete', str);
	}catch(e:Error){
		//Alert.show(e.toString());
	}
	isFade = true;
	fadeOutVol = 10;
}

// 音ファイルのFadeIn
private var fadeInVol:Number = 0;
private function asFadeIn():void {
	if(isFade && !isMute){
		for (var i:int = 0; i < index; i++){
			var s:String = i.toString();
			if(channelDic.hasOwnProperty(s)){
				try{
					var t:SoundTransform = new SoundTransform();
					var _v:Number = ++fadeInVol / 10
					t.volume = _v;
					channelDic[s].soundTransform = t;
				}catch(e:Error){
				}
			}
		}
		if(fadeInVol >= 10){
			fadeInComplete(arguments[0]);
		}else{
			setTimeout(asFadeIn, 100, arguments[0]);
		}
	}else{
		if(isFade){
			fadeInComplete(arguments[0]);
		}
	}
}

private function fadeInComplete(str:String):void {
	try{
		ExternalInterface.call('fadeInComplete', str);
	}catch(e:Error){
		//Alert.show(e.toString());
	}
	fadeInVol = 0;
	isFade = false;
}


// 読み込み完了？
private function onLoadComplete():void {
	try{
		ExternalInterface.call('loaded', 'end');
	}catch(e:Error){
		//Alert.show(e.toString());
	}
}

// デバッグ用
private function debug(s:String):void {
	try{
		ExternalInterface.call('debug', s);
	}catch(e:Error){
		//Alert.show(e.toString());
	}
}
