package;

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

  var _plist:FlxPDPList;
  var _player:FlxPDPlayer;

  var _txtList:List<FlxText>;

  override public function create():Void {
    super.create();

//    _plist = new FlxPDPList("assets/data/particle_texture.plist");
//    _plist = new FlxPDPList("assets/data/particle_texture2.plist");
    _plist = new FlxPDPList("assets/data/particle_texture3.plist");

    var px = FlxG.width/2;
    var py = FlxG.height/2;
    py = FlxG.height;
    _player = new FlxPDPlayer(this, px, py, _plist);
    this.add(_player);

    // デバッグ用
    var emitter:FlxPDEmitter = _player.emitter;
    _txtList = new List<FlxText>();
    var txtLifetime = _addText();
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


    // 発射
    _start(txtLifetime);
  }

  private function _addText():FlxText {
    var txt = new FlxText();
    txt.setFormat(null, TXT_SIZE);
    _txtList.add(txt);
    return txt;
  }

  private function _start(txt:FlxText):Void {
    // 開始
    var life_min = _plist.particleLifespan - _plist.particleLifespanVariance;
    var life_max = _plist.particleLifespan + _plist.particleLifespanVariance;
    txt.text = 'Lifetime: ${life_min} +- ${life_max}';
    var frequency:Float = 1;
//    frequency /= 600;
    _player.start(false, frequency, 0);
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update():Void {
    super.update();

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