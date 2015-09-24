package ;

import flixel.FlxG;
import openfl.Assets;

/**
 * Particle Designerの plist 読み込みモジュール
 **/
class FlxPDPList {

  // ■エミッタの種別
  public static inline var TYPE_GRAVITY:Int = 0; // 重力
  public static inline var TYPE_RADIAL:Int  = 1; // 円運動

  // ■Emitter Parameters.
  public var angle:Float              = 0; // 発射角度
  public var angleVariance:Float      = 0; // 発射角度の乱数
  public var blendFuncDestination:Int = 0; // ブレンドモード(DST)
  public var blendFuncSource:Int      = 0; // ブレンドモード(SRC)
  public var duration:Float           = -1; // エミッタの生存時間 (-1で無限)
  public var emitterType:Int          = 0; // エミッタの種類(0:Gravity 1:Radial)
  public var finishColorAlpha:Float   = 0; // 終了時のアルファ値
  public var finishColorBlue:Float    = 0; // 終了時のB成分
  public var finishColorGreen:Float   = 0; // 終了時のG成分
  public var finishColorRed:Float     = 0; // 終了時のR成分
  public var finishColorVarianceAlpha:Float   = 0; // 終了時のアルファ値(乱数)
  public var finishColorVarianceBlue:Float    = 0; // 終了時のB成分(乱数)
  public var finishColorVarianceGreen:Float   = 0; // 終了時のG成分(乱数)
  public var finishColorVarianceRed:Float     = 0; // 終了時のR成分(乱数)
  public var finishParticleSize:Float         = 0; // 終了時のパーティクルのサイズ
  public var finishParticleSizeVariance:Float = 0; // 終了時のパーティクルのサイズ(乱数)
  public var gravityx:Float          = 0; // 重力(X)
  public var gravityy:Float          = 0; // 重力(Y)
  public var maxParticles:Int        = 0; // パーティクルの最大数
  public var maxRadius:Float         = 0; // ???
  public var maxRadiusVariance:Float = 0; // ???
  public var minRadius:Float         = 0; // ???

  // ■Particle
  public var particleLifespan:Float         = 0; // パーティクルの生存時間
  public var particleLifespanVariance:Float = 0; // パーティクルの生存時間(乱数)
  public var radialAccelVariance:Float      = 0; // ???
  public var radialAcceleration:Float       = 0; // ???
  public var rotatePerSecond:Float          = 0; // ???
  public var rotatePerSecondVariance:Float  = 0; // ???
  public var rotationEnd:Float              = 0; // ???
  public var rotationEndVariance:Float      = 0; // ???
  public var rotationStart:Float            = 0; // ???
  public var rotationStartVariance:Float    = 0; // ???
  public var sourcePositionVariancex:Float  = 0; // パーティクル出現の幅
  public var sourcePositionVariancey:Float  = 0; // パーティクル出現の高さ
  public var sourcePositionx:Float          = 0; // パーティクル出現座標(X)
  public var sourcePositiony:Float          = 0; // パーティクル出現座標(Y)
  public var speed:Float                    = 0; // パーティクル初速度
  public var speedVariance:Float            = 0; // パーティクル初速度(乱数)
  public var startColorAlpha:Float          = 0; // 開始時のアルファ値
  public var startColorBlue:Float           = 0; // 開始時のB成分
  public var startColorGreen:Float          = 0; // 開始時のR成分
  public var startColorRed:Float            = 0; // 開始時のG成分
  public var startColorVarianceAlpha:Float  = 0; // 開始時のアルファ値(乱数)
  public var startColorVarianceBlue:Float   = 0; // 開始時のB成分(乱数)
  public var startColorVarianceGreen:Float  = 0; // 開始時のR成分(乱数)
  public var startColorVarianceRed:Float    = 0; // 開始時のG成分(乱数)
  public var startParticleSize:Float        = 0; // 開始時のパーティクルのサイズ
  public var startParticleSizeVariance:Float= 0; // 開始時のパーティクルのサイズ(乱数)
  public var tangentialAccelVariance:Float  = 0; // ???
  public var tangentialAcceleration:Float   = 0; // ???
  public var textureFileName:String         = ""; // テクスチャファイル名
  public var textureImageData:String        = ""; // テクスチャ画像バイナリ

  public function new(filepath:String=null) {
    if(filepath != null) {
      load(filepath);
    }
  }

  /**
   * plistファイルを読み込む
   * @param filepath *.plistファイルのパス
   **/
  public function load(filepath:String):Void {
    var plist:String = Assets.getText(filepath);
    if(plist == null) {
      // 読み込み失敗
      FlxG.log.warn('FlxPDPList.load() plist is null. file: ${filepath}');
      return;
    }

    var root = Xml.parse(plist).firstElement();
    var dict = root.firstElement();
    var key = "";
    var tbl = new Map<String,String>();
    for(item in dict.elements()) {

      if(item.nodeName == "key") {
        key = item.firstChild().nodeValue;
      }
      else {
        var value:String = item.firstChild().nodeValue;
        tbl[key] = value;
      }
    }

    for(k in tbl.keys()) {
      var v = tbl[k];
      _set(k, v);
    }
  }

  private function _set(k:String, v:String):Void {
    switch(k) {
      // ■Emitter Parameters.
      case "angle":                      angle                      = Std.parseFloat(v); // 発射角度
      case "angleVariance":              angleVariance              = Std.parseFloat(v); // 発射角度の乱数
      case "blendFuncDestination":       blendFuncDestination       = Std.parseInt(v);   // ブレンドモード (DST)
      case "blendFuncSource":            blendFuncSource            = Std.parseInt(v);   // ブレンドモード (SRC)
      case "duration":                   duration                   = Std.parseFloat(v); // エミッタの生存時間 (-1で無限)
      case "emitterType":                emitterType                = Std.parseInt(v);   // エミッタの種類 (0:Gravity 1:Radial)
      case "finishColorAlpha":           finishColorAlpha           = Std.parseFloat(v); // 終了時のアルファ値
      case "finishColorBlue":            finishColorBlue            = Std.parseFloat(v); // 終了時のB成分
      case "finishColorGreen":           finishColorGreen           = Std.parseFloat(v); // 終了時のG成分
      case "finishColorRed":             finishColorRed             = Std.parseFloat(v); // 終了時のR成分
      case "finishColorVarianceAlpha":   finishColorVarianceAlpha   = Std.parseFloat(v); // 終了時のアルファ値 (乱数)
      case "finishColorVarianceBlue":    finishColorVarianceBlue    = Std.parseFloat(v); // 終了時のB成分 (乱数)
      case "finishColorVarianceGreen":   finishColorGreen           = Std.parseFloat(v); // 終了時のG成分 (乱数)
      case "finishColorVarianceRed":     finishColorRed             = Std.parseFloat(v); // 終了時のR成分 (乱数)
      case "finishParticleSize":         finishParticleSize         = Std.parseFloat(v); // 終了時のパーティクルのサイズ
      case "finishParticleSizeVariance": finishParticleSizeVariance = Std.parseFloat(v); // 終了時のパーティクルのサイズ (乱数)
      case "gravityx":                   gravityx                   = Std.parseFloat(v); // 重力 (X)
      case "gravityy":                   gravityy                   = Std.parseFloat(v); // 重力 (Y)
      case "maxParticles":               maxParticles               = Std.parseInt(v);   // パーティクルの最大数
      case "maxRadius":                  maxRadius                  = Std.parseFloat(v); // ???
      case "maxRadiusVariance":          maxRadiusVariance          = Std.parseFloat(v); // ???
      case "minRadius":                  minRadius                  = Std.parseFloat(v); // ???

        // ■Particle
      case "particleLifespan":          particleLifespan         = Std.parseFloat(v); // パーティクルの生存時間
      case "particleLifespanVariance":  particleLifespanVariance = Std.parseFloat(v); // パーティクルの生存時間 (乱数)
      case "radialAccelVariance":       radialAccelVariance      = Std.parseFloat(v); // ???
      case "radialAcceleration":        radialAcceleration       = Std.parseFloat(v); // ???
      case "rotatePerSecond":           rotatePerSecond          = Std.parseFloat(v); // ???
      case "rotatePerSecondVariance":   rotatePerSecondVariance  = Std.parseFloat(v); // ???
      case "rotationEnd":               rotationEnd              = Std.parseFloat(v); // 終了角度
      case "rotationEndVariance":       rotationEndVariance      = Std.parseFloat(v); // 終了角度 (乱数)
      case "rotationStart":             rotationStart            = Std.parseFloat(v); // 開始角度
      case "rotationStartVariance":     rotationStartVariance    = Std.parseFloat(v); // 開始角度 (乱数)
      case "sourcePositionVariancex":   sourcePositionVariancex  = Std.parseFloat(v); // パーティクル出現の幅
      case "sourcePositionVariancey":   sourcePositionVariancey  = Std.parseFloat(v); // パーティクル出現の高さ
      case "sourcePositionx":           sourcePositionx          = Std.parseFloat(v); // パーティクル出現座標 (X)
      case "sourcePositiony":           sourcePositiony          = Std.parseFloat(v); // パーティクル出現座標 (Y)
      case "speed":                     speed                    = Std.parseFloat(v); // パーティクル初速度
      case "speedVariance":             speedVariance            = Std.parseFloat(v); // パーティクル初速度(乱数)
      case "startColorAlpha":           startColorAlpha          = Std.parseFloat(v); // 開始時のアルファ値
      case "startColorBlue":            startColorBlue           = Std.parseFloat(v); // 開始時のB成分
      case "startColorGreen":           startColorGreen          = Std.parseFloat(v); // 開始時のR成分
      case "startColorRed":             startColorRed            = Std.parseFloat(v); // 開始時のG成分
      case "startColorVarianceAlpha":   startColorVarianceAlpha  = Std.parseFloat(v); // 開始時のアルファ値 (乱数)
      case "startColorVarianceBlue":    startColorVarianceBlue   = Std.parseFloat(v); // 開始時のB成分 (乱数)
      case "startColorVarianceGreen":   startColorVarianceGreen  = Std.parseFloat(v); // 開始時のR成分 (乱数)
      case "startColorVarianceRed":     startColorVarianceRed    = Std.parseFloat(v); // 開始時のG成分 (乱数)
      case "startParticleSize":         startParticleSize        = Std.parseFloat(v); // 開始時のパーティクルのサイズ
      case "startParticleSizeVariance": startParticleSizeVariance= Std.parseFloat(v); // 開始時のパーティクルのサイズ (乱数)
      case "tangentialAccelVariance":   tangentialAccelVariance  = Std.parseFloat(v); // ???
      case "tangentialAcceleration":    tangentialAcceleration   = Std.parseFloat(v); // ???
      case "textureFileName":           textureFileName          = v; // テクスチャファイル名
      case "textureImageData":          textureImageData         = v; // テクスチャ画像バイナリ
      default:
        throw 'Invalid key (${k})';
    }
  }
}
