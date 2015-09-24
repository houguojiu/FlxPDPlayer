package;

import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;


/**
 * Partilce生成テスト
 **/
class PlayState extends FlxState {

  private static inline var TXT_X = 0;
  private static inline var TXT_Y = 0;
  private static inline var TXT_SIZE = 12;

  var _player:FlxPDPlayer = null;
  var _txtList:List<FlxText> = null;
  var _txtCount:FlxText = null;

  override public function create():Void {
    super.create();

    var btnX = FlxG.width - 120;
    var btnY = 8;
    var btnDY = 32;
    // Meteor.
    this.add(new FlxButton(btnX, btnY, "Meteor", function() {
      _reset();
      var px = FlxG.width/2;
      var py = FlxG.height/2;
      var freq = 1/300;
      // 生成
      _create(px, py, "particle_texture.plist", freq);
    }));
    btnY += btnDY;

    // Firefloor.
    this.add(new FlxButton(btnX, btnY, "Firefloor", function() {
      _reset();
      var px = FlxG.width/2;
      var py = FlxG.height/3*2;
      var freq = 1/600;
      // 生成
      _create(px, py, "particle_texture2.plist", freq);
    }));
    btnY += btnDY;

    // galaxy3.
    this.add(new FlxButton(btnX, btnY, "galaxy3", function() {
      _reset();
      var px = FlxG.width/2;
      var py = FlxG.height/2;
      var freq = 1/150;
      // 生成
      _create(px, py, "particle_texture3.plist", freq);
    }));
    btnY += btnDY;

    // funsui
    this.add(new FlxButton(btnX, btnY, "funsui", function() {
      _reset();
      var px = FlxG.width/2;
      var py = FlxG.height/4*3;
      var freq = 1/150;
      // 生成
      _create(px, py, "particle_texture4.plist", freq);
    }));
    btnY += btnDY;

    // kirawine
    this.add(new FlxButton(btnX, btnY, "kirawine", function() {
      _reset();
      var px = FlxG.width/2;
      var py = FlxG.height/2;
      var freq = 1/150;
      // 生成
      _create(px, py, "particle_texture5.plist", freq);
    }));
    btnY += btnDY;

    // FireRing
    this.add(new FlxButton(btnX, btnY, "FireRing", function() {
      _reset();
      var px = FlxG.width/2;
      var py = FlxG.height/2;
      var freq = 1/1200;
      // 生成
      _create(px, py, "particle_texture6.plist", freq);
    }));
    btnY += btnDY;

    // Show
    this.add(new FlxButton(btnX, btnY, "Show", function() {
      _reset();
      var px = FlxG.width/2;
      var py = FlxG.height/2;
      var freq = 1/200;
      // 生成
      _create(px, py, "particle_texture7.plist", freq);
    }));
    btnY += btnDY;

    // Sun1
    this.add(new FlxButton(btnX, btnY, "Sun1", function() {
      _reset();
      var px = FlxG.width/2;
      var py = FlxG.height/2;
      var freq = 1/200;
      // 生成
      _create(px, py, "particle_texture8.plist", freq);
    }));
    btnY += btnDY;

    // FireBar
    this.add(new FlxButton(btnX, btnY, "FireBar", function() {
      _reset();
      var px = FlxG.width/2;
      var py = FlxG.height/2;
      var freq = 1/400;
      // 生成
      _create(px, py, "particle_texture9.plist", freq);
    }));
    btnY += btnDY;

    // 初期状態に再生するパーティクル
    var px = FlxG.width/2;
    var py = FlxG.height/2;
    var freq = 1/300;
    // 生成
    _create(px, py, "particle_texture.plist", freq);
  }

  private function _create(px:Float, py:Float, plist:String, freq:Float):Void {
    var texdir = "assets/data";
    var plistpath = '${texdir}/${plist}';
    _player = new FlxPDPlayer(this, px, py, plistpath, texdir);
    this.add(_player);

    _setDebugText();

    // 発射
    _player.start(false, freq, 0);
  }

  private function _reset():Void {
    if(_player != null) {
      this.remove(_player);
      this.remove(_player.emitter);
    }

    if(_txtList != null) {
      for(txt in _txtList) {
        this.remove(txt);
      }
      _txtList.clear();
    }
  }

  /**
   * デバッグ用テキスト
   **/
  private function _setDebugText():Void {
    // デバッグ用
    var emitter:FlxPDEmitter = _player.emitter;
    _txtList = new List<FlxText>();
    _txtCount = _addText();
    _addText().text = 'Area: (${emitter.x},${emitter.y}) (${emitter.width},${emitter.height})';
    _addText().text = 'Angle: ${emitter.angle*FlxAngle.TO_DEG} + ${emitter.angleRange*FlxAngle.TO_DEG}';
    _addText().text = 'Scale: (${emitter.startScale.min},${emitter.startScale.max}) (${emitter.endScale.min},${emitter.endScale.max})';

    var px = TXT_X;
    var py = TXT_Y;
    for(txt in _txtList) {
      txt.x = px;
      txt.y = py;
      this.add(txt);
      py += TXT_SIZE;
    }
  }

  private function _addText():FlxText {
    var txt = new FlxText();
    txt.setFormat(null, TXT_SIZE);
    _txtList.add(txt);
    return txt;
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update():Void {
    super.update();

    var emitter = _player.emitter;
    _txtCount.text  = 'Count: ${emitter.countLiving()}/${emitter.maxSize}';

    if(FlxG.keys.justPressed.ENTER) {
      FlxG.resetState();
    }

    #if neko
    if(FlxG.keys.justPressed.ESCAPE) {
      throw "Terminate.";
    }
    #end
  }
}