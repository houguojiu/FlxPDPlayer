package;

import flixel.util.FlxAngle;
import flixel.text.FlxText;
import flash.display.BlendMode;
import flixel.FlxG;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxState;

/**
 * Partilce生成テスト
 **/
class PlayState extends FlxState {

  private static inline var TXT_X = 0;
  private static inline var TXT_Y = 0;
  private static inline var TXT_SIZE = 12;
  private static inline var SPEED_RATIO:Float = 0.5;

  var _plist:FlxPDPList;
  var _emitter:FlxEmitterExt;

  var _txtList:List<FlxText>;

  override public function create():Void {
    super.create();

    _plist = new FlxPDPList("assets/data/particle_texture.plist");

    var px = FlxG.width/2;
    var py = FlxG.height/2;
    _emitter = new FlxEmitterExt(px, py);
    // パーティクル生成
    var image = 'assets/images/${_plist.textureFileName}';
    _emitter.makeParticles(image, _plist.maxParticles);

    // Motion
    // 初速度
    _emitter.distance = _plist.speed - _plist.speedVariance;
    _emitter.distanceRange = _plist.speedVariance * 2;

    // 角度
    _emitter.angle = _plist.angle - _plist.angleVariance;
    _emitter.angleRange = _plist.angleVariance * 2;
    // 上下反転
    _emitter.angle = _emitter.angle * -1;
    _emitter.angleRange = _emitter.angleRange * -1;
    // ラジアンに変換する
    _emitter.angle *= FlxAngle.TO_RAD;
    _emitter.angleRange *= FlxAngle.TO_RAD;

    // 発生範囲
    _emitter.width = _plist.sourcePositionVariancex;
    _emitter.height = _plist.sourcePositionVariancey;

    // 重力(ツール上のYは上がプラス)
    _emitter.acceleration.set(_plist.gravityx, -_plist.gravityy);

    // 回転
    _emitter.minRotation = _plist.rotationStart - _plist.rotationStartVariance;
    _emitter.maxRotation = _plist.rotationStart + _plist.rotationStartVariance;
    // 上下反転
    _emitter.rotation.min *= -1;
    _emitter.rotation.max *= -1;


    // Size
    // 初期サイズ
    var bmp = FlxG.bitmap.add(image);
    var w = bmp.bitmap.width;
    var startSize_min:Float = (_plist.startParticleSize - _plist.startParticleSizeVariance) / w;
    var startSize_max:Float = (_plist.startParticleSize + _plist.startParticleSizeVariance) / w;
    _emitter.startScale.min = startSize_min;
    _emitter.startScale.max = startSize_max;
    // 終了サイズ
    var endSize_min:Float = (_plist.finishParticleSize - _plist.finishParticleSizeVariance) / w;
    var endSize_max:Float = (_plist.finishParticleSize + _plist.finishParticleSizeVariance) / w;
    _emitter.endScale.min = endSize_min;
    _emitter.endScale.max = endSize_max;

    // Color
    // アルファ値
    _emitter.setAlpha(
      _plist.startColorAlpha - _plist.startColorVarianceAlpha,
      _plist.startColorAlpha + _plist.startColorVarianceAlpha,
      _plist.finishColorAlpha - _plist.finishColorVarianceAlpha,
      _plist.finishColorAlpha + _plist.finishColorVarianceAlpha
    );
    // R成分
    _emitter.startRed.min = _plist.startColorRed - _plist.startColorVarianceRed;
    _emitter.startRed.max = _plist.startColorRed + _plist.startColorVarianceRed;
    _emitter.endRed.min = _plist.finishColorRed - _plist.finishColorVarianceRed;
    _emitter.endRed.max = _plist.finishColorRed + _plist.finishColorVarianceRed;
    // G成分
    _emitter.startGreen.min = _plist.startColorGreen - _plist.startColorVarianceGreen;
    _emitter.startGreen.max = _plist.startColorGreen + _plist.startColorVarianceGreen;
    _emitter.endGreen.min = _plist.finishColorGreen - _plist.finishColorVarianceGreen;
    _emitter.endGreen.max = _plist.finishColorGreen + _plist.finishColorVarianceGreen;
    // B成分
    _emitter.startBlue.min = _plist.startColorBlue - _plist.startColorVarianceBlue;
    _emitter.startBlue.max = _plist.startColorBlue + _plist.startColorVarianceBlue;
    _emitter.endBlue.min = _plist.finishColorBlue - _plist.finishColorVarianceBlue;
    _emitter.endBlue.max = _plist.finishColorBlue + _plist.finishColorVarianceBlue;

    // 加算合成有効
    _emitter.blend = BlendMode.ADD;
    this.add(_emitter);

    // デバッグ用
    _txtList = new List<FlxText>();
    var txtLifetime = _addText();
    _addText().text = 'Angle: ${_emitter.angle*FlxAngle.TO_DEG} + ${_emitter.angleRange*FlxAngle.TO_DEG}';
    _addText().text = 'Scale: (${_emitter.startScale.min},${_emitter.startScale.max}) (${_emitter.endScale.min},${_emitter.endScale.max})';

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
    var frequency = 0.01;
    _emitter.start(false, life_min, frequency, 0, life_max);
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