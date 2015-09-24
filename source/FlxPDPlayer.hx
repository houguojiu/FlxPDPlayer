package ;

import flixel.util.FlxAngle;
import flixel.FlxG;
import openfl._legacy.display.BlendMode;
import flixel.FlxState;
import flixel.FlxObject;

/**
 * Particle Designerによるパーティクル情報を再生するクラス
 **/
class FlxPDPlayer extends FlxObject {

  // エミッタ
  var _emitter:FlxPDEmitter;
  public var emitter(get, never):FlxPDEmitter;
  private function get_emitter():FlxPDEmitter {
    return _emitter;
  }
  // plist
  var _plist:FlxPDPList;

  /**
   * コンストラクタ
   * @param state 現在実行しているFlxState
   * @param X     中心座標(X)
   * @param Y     中心座標(Y)
   * @param plist plist
   **/
  public function new(state:FlxState, X:Float, Y:Float, plist:FlxPDPList):Void {
    super(X, Y);

    _emitter = new FlxPDEmitter();
    _plist = plist;
    // 座標設定
    _updateEmitterPosition();

    // パーティクル生成
    var image = 'assets/images/${_plist.textureFileName}';
    _emitter.makeParticles(image, _plist.maxParticles);

    // 出現エリアの設定
    _emitter.width = _plist.sourcePositionVariancex*2;
    _emitter.height = _plist.sourcePositionVariancey*2;

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

    // 重力(ツール上のYは上がプラス)
    _emitter.acceleration.set(_plist.gravityx, -_plist.gravityy);

    // 回転
    _emitter.rotationStart         = _plist.rotationStart;
    _emitter.rotationStartVariance = _plist.rotationStartVariance;
    _emitter.rotationEnd           = _plist.rotationEnd;
    _emitter.rotationEndVariance   = _plist.rotationEndVariance;
    // 生存時間で調整
    _emitter.minRotation /= _emitter.life.min;
    _emitter.maxRotation /= _emitter.life.max;
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

    state.add(this);
    state.add(_emitter);
  }

  /**
   * 更新
   **/
  override public function update():Void {
    super.update();

    // エミッタの座標を更新
    _updateEmitterPosition();
  }

  /**
   * エミッタの座標を更新
   **/
  private function _updateEmitterPosition():Void {
    _emitter.x = x - _plist.sourcePositionVariancex;
    _emitter.y = y - _plist.sourcePositionVariancey;
  }

  /**
   * パーティクル再生開始
   * @param Explode   一度にすべてを発射するかどうか
   * @param Frequency 発射間隔(秒) = (1 / EmissionRate)
   * @param Quantity  Explodeの値によって意味が変わる値
   *          Explode = true  => 一度に発射する数。0を指定するとすべて同時に発射
   *          Explode = false => 発射可能な最大数。発射した数がこの値を超えると撃てなくなる
   *                             0を指定すると永続的に発射
   **/
  public function start(Explode:Bool = true, Frequency:Float = 0.1, Quantity:Int = 0):Void {
    var life_min = _plist.particleLifespan - _plist.particleLifespanVariance;
    var life_max = _plist.particleLifespan + _plist.particleLifespanVariance;
    _emitter.start(Explode, life_min, Frequency, Quantity, life_max);
  }
}

