package;

import flixel.effects.particles.FlxEmitterExt;
import flixel.util.FlxAngle;
import flixel.text.FlxText;
import flash.display.BlendMode;
import flixel.FlxG;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxState;

class FlxPDPlayer {
  public var emitter:FlxEmitterExt;
  var _plist:FlxPDPList;

  public function new(X:Float, Y:Float, plist:FlxPDPList):Void {
    emitter = new FlxEmitterExt();
    _plist = plist;
    // 座標設定
    setPosition(X, Y);

    // パーティクル生成
    var image = 'assets/images/${_plist.textureFileName}';
    emitter.makeParticles(image, _plist.maxParticles);

    // Motion
    // 初速度
    emitter.distance = _plist.speed - _plist.speedVariance;
    emitter.distanceRange = _plist.speedVariance * 2;

    // 角度
    emitter.angle = _plist.angle - _plist.angleVariance;
    emitter.angleRange = _plist.angleVariance * 2;
    // 上下反転
    emitter.angle = emitter.angle * -1;
    emitter.angleRange = emitter.angleRange * -1;
    // ラジアンに変換する
    emitter.angle *= FlxAngle.TO_RAD;
    emitter.angleRange *= FlxAngle.TO_RAD;

    // 重力(ツール上のYは上がプラス)
    emitter.acceleration.set(_plist.gravityx, -_plist.gravityy);

    // 回転
    emitter.minRotation = _plist.rotationStart - _plist.rotationStartVariance;
    emitter.maxRotation = _plist.rotationStart + _plist.rotationStartVariance;
    // 上下反転
    emitter.rotation.min *= -1;
    emitter.rotation.max *= -1;


    // Size
    // 初期サイズ
    var bmp = FlxG.bitmap.add(image);
    var w = bmp.bitmap.width;
    var startSize_min:Float = (_plist.startParticleSize - _plist.startParticleSizeVariance) / w;
    var startSize_max:Float = (_plist.startParticleSize + _plist.startParticleSizeVariance) / w;
    emitter.startScale.min = startSize_min;
    emitter.startScale.max = startSize_max;
    // 終了サイズ
    var endSize_min:Float = (_plist.finishParticleSize - _plist.finishParticleSizeVariance) / w;
    var endSize_max:Float = (_plist.finishParticleSize + _plist.finishParticleSizeVariance) / w;
    emitter.endScale.min = endSize_min;
    emitter.endScale.max = endSize_max;

    // Color
    // アルファ値
    emitter.setAlpha(
      _plist.startColorAlpha - _plist.startColorVarianceAlpha,
      _plist.startColorAlpha + _plist.startColorVarianceAlpha,
      _plist.finishColorAlpha - _plist.finishColorVarianceAlpha,
      _plist.finishColorAlpha + _plist.finishColorVarianceAlpha
    );
    // R成分
    emitter.startRed.min = _plist.startColorRed - _plist.startColorVarianceRed;
    emitter.startRed.max = _plist.startColorRed + _plist.startColorVarianceRed;
    emitter.endRed.min = _plist.finishColorRed - _plist.finishColorVarianceRed;
    emitter.endRed.max = _plist.finishColorRed + _plist.finishColorVarianceRed;
    // G成分
    emitter.startGreen.min = _plist.startColorGreen - _plist.startColorVarianceGreen;
    emitter.startGreen.max = _plist.startColorGreen + _plist.startColorVarianceGreen;
    emitter.endGreen.min = _plist.finishColorGreen - _plist.finishColorVarianceGreen;
    emitter.endGreen.max = _plist.finishColorGreen + _plist.finishColorVarianceGreen;
    // B成分
    emitter.startBlue.min = _plist.startColorBlue - _plist.startColorVarianceBlue;
    emitter.startBlue.max = _plist.startColorBlue + _plist.startColorVarianceBlue;
    emitter.endBlue.min = _plist.finishColorBlue - _plist.finishColorVarianceBlue;
    emitter.endBlue.max = _plist.finishColorBlue + _plist.finishColorVarianceBlue;

    // 加算合成有効
    emitter.blend = BlendMode.ADD;
  }

  public function setPosition(X:Float, Y:Float):Void {
    emitter.x = X - _plist.sourcePositionVariancex;
    emitter.y = Y - _plist.sourcePositionVariancey;
    emitter.width = _plist.sourcePositionVariancex*2;
    emitter.height = _plist.sourcePositionVariancey*2;
  }

  public function start(Explode:Bool = true, Lifespan:Float = 0, Frequency:Float = 0.1, Quantity:Int = 0, LifespanRange:Float = 0):Void {
    emitter.start(Explode, Lifespan, Frequency, Quantity, Lifespan);
  }
}

/**
 * Partilce生成テスト
 **/
class PlayState extends FlxState {

  private static inline var TXT_X = 0;
  private static inline var TXT_Y = 0;
  private static inline var TXT_SIZE = 12;
  private static inline var SPEED_RATIO:Float = 0.5;

  var _plist:FlxPDPList;
  var _player:FlxPDPlayer;

  var _txtList:List<FlxText>;

  override public function create():Void {
    super.create();

//    _plist = new FlxPDPList("assets/data/particle_texture.plist");
    _plist = new FlxPDPList("assets/data/particle_texture2.plist");

    var px = FlxG.width/2;
    var py = FlxG.height/2;
    _player = new FlxPDPlayer(px, py, _plist);
    this.add(_player.emitter);

    // デバッグ用
    var emitter:FlxEmitterExt = _player.emitter;
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
    var frequency = 1 / 600;
    _player.start(false, life_min, frequency, 0, life_max);
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