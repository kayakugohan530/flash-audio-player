!function(){
  /* playSE(0) */
  function $id(id){ return window[id] || document[id]; }
  var $external_bgm = null;

  function initBGM(){
    var FlashPlayer = swfobject.getFlashPlayerVersion();
    var flashvars = {}, params = {}, attributes = {};

    params.allowscriptaccess = 'always';
    params.menu    = 'false';
    params.quality = 'high';
    params.base    = 'swf';

    flashvars.url   = './';
    flashvars.names = 'xx01.mp3,xx02.mp3,xx03.mp3';

    attributes.id   = 'external_bgm';

    swfobject.embedSWF('./bgm.swf?' + new Date().getTime(), 'external_bgm', '0', '0', '9.0.0', false, flashvars, params, attributes, function(){
      $external_bgm = $id('external_bgm');
    });
  }

  function play(id, loop){
    loop = (loop) || false;
    if(!$external_bgm){ return; }
    try{
      $external_bgm.jsPlay(id, loop);
    }catch(e){}
  }

  function mute(){
    if(!$external_bgm){ return; }
    try{
      $external_bgm.jsMute();
    }catch(e){}
  }

  function unmute(){
    if(!$external_bgm){ return; }
    try{
      $external_bgm.jsUnMute();
    }catch(e){}
  }

  function fadePlay(id, loop){
    loop = (loop) || false;
    if(!$external_bgm){ return; }
    try{
      $external_bgm.jsFadePlay(id, loop);
    }catch(e){}
  }

  function fadeIn(){
    if(!$external_bgm){ return; }
    try{
      $external_bgm.jsFadeIn();
    }catch(e){}
  }

  function fadeOut(){
    if(!$external_bgm){ return; }
    try{
      $external_bgm.jsFadeOut();
    }catch(e){}
  }

  function loaded(){
    console.log('loaded !!');
  }

  function fadeOutComplete(){
    console.log('fadeOut !!');
  }

  function fadeInComplete(){
    console.log('fadeIn !!');
  }

  initBGM();
}();
