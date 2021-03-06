package ;
import flixel.util.FlxRandom;
import flixel.effects.particles.FlxTypedEmitterExt;

/**
 * Particle Designer用のエミッタ
 **/
class FlxPDEmitter extends FlxTypedEmitterExt<FlxPDParticle> {

  // 中心座標
  public var xcenter:Float = 0;
  public var ycenter:Float = 0;

  // 回転パラメータ
  public var rotationStart:Float         = 0; // 開始回転角度
  public var rotationStartVariance:Float = 0; // 開始回転角度 (乱数)
  public var rotationEnd:Float           = 0; // 終了回転角度
  public var rotationEndVariance:Float   = 0; // 終了回転角度 (乱数)

  // エミッタの種類
  public var emitterType:Int = 0;

  // Radial用パラメータ
  public var maxRadius:Float               = 0; // 開始点の半径
  public var maxRadiusVariance:Float       = 0; // 開始点の半径 (乱数)
  public var minRadius:Float               = 0; // 終点の半径
  public var mixRadiusVariance:Float       = 0; // 終点の半径 (乱数)
  public var rotatePerSecond:Float         = 0; // 1秒あたりの進む角度
  public var rotatePerSecondVariance:Float = 0; // 1秒あたりの進む角度 (乱数)

  /**
	 * Creates a new FlxEmitterExt object at a specific position.
	 * Does NOT automatically generate or attach particles!
	 *
	 * @param	X		The X position of the emitter.
	 * @param	Y		The Y position of the emitter.
	 * @param	Size	Optional, specifies a maximum capacity for this emitter.
	 */
  public function new(X:Float = 0, Y:Float = 0, Size:Int = 0)
  {
    super(X, Y, Size);

    // FlxPDParticleを使う
    _particleClass = FlxPDParticle;
  }

  override public function emitParticle():Void
  {
    var particle:FlxPDParticle = cast recycle(cast _particleClass);
    particle.elasticity = bounce;

    // エミッタの種類を設定
    particle.emitterType = emitterType;

    particle.reset(x - (Std.int(particle.width) >> 1) + FlxRandom.float() * width, y - (Std.int(particle.height) >> 1) + FlxRandom.float() * height);
    particle.visible = true;

    if (life.min != life.max)
    {
      particle.lifespan = particle.maxLifespan = life.min + FlxRandom.float() * (life.max - life.min);
    }
    else
    {
      particle.lifespan = particle.maxLifespan = life.min;
    }

    if (startAlpha.min != startAlpha.max)
    {
      particle.startAlpha = startAlpha.min + FlxRandom.float() * (startAlpha.max - startAlpha.min);
    }
    else
    {
      particle.startAlpha = startAlpha.min;
    }
    particle.alpha = particle.startAlpha;

    var particleEndAlpha:Float = endAlpha.min;
    if (endAlpha.min != endAlpha.max)
    {
      particleEndAlpha = endAlpha.min + FlxRandom.float() * (endAlpha.max - endAlpha.min);
    }

    if (particleEndAlpha != particle.startAlpha)
    {
      particle.useFading = true;
      particle.rangeAlpha = particleEndAlpha - particle.startAlpha;
    }
    else
    {
      particle.useFading = false;
      particle.rangeAlpha = 0;
    }

    // particle color settings
    var startRedComp:Float = particle.startRed = startRed.min;
    var startGreenComp:Float = particle.startGreen = startGreen.min;
    var startBlueComp:Float = particle.startBlue = startBlue.min;

    var endRedComp:Float = endRed.min;
    var endGreenComp:Float = endGreen.min;
    var endBlueComp:Float = endBlue.min;

    if (startRed.min != startRed.max)
    {
      particle.startRed = startRedComp = startRed.min + FlxRandom.float() * (startRed.max - startRed.min);
    }
    if (startGreen.min != startGreen.max)
    {
      particle.startGreen = startGreenComp = startGreen.min + FlxRandom.float() * (startGreen.max - startGreen.min);
    }
    if (startBlue.min != startBlue.max)
    {
      particle.startBlue = startBlueComp = startBlue.min + FlxRandom.float() * (startBlue.max - startBlue.min);
    }

    if (endRed.min != endRed.max)
    {
      endRedComp = endRed.min + FlxRandom.float() * (endRed.max - endRed.min);
    }

    if (endGreen.min != endGreen.max)
    {
      endGreenComp = endGreen.min + FlxRandom.float() * (endGreen.max - endGreen.min);
    }

    if (endBlue.min != endBlue.max)
    {
      endBlueComp = endBlue.min + FlxRandom.float() * (endBlue.max - endBlue.min);
    }

    particle.rangeRed = endRedComp - startRedComp;
    particle.rangeGreen = endGreenComp - startGreenComp;
    particle.rangeBlue = endBlueComp - startBlueComp;

    particle.useColoring = false;

    if (particle.rangeRed != 0 || particle.rangeGreen != 0 || particle.rangeBlue != 0)
    {
      particle.useColoring = true;
    }

    // End of particle color settings
    if (startScale.min != startScale.max)
    {
      particle.startScale = startScale.min + FlxRandom.float() * (startScale.max - startScale.min);
    }
    else
    {
      particle.startScale = startScale.min;
    }
    particle.scale.x = particle.scale.y = particle.startScale;

    var particleEndScale:Float = endScale.min;

    if (endScale.min != endScale.max)
    {
      particleEndScale = endScale.min + Std.int(FlxRandom.float() * (endScale.max - endScale.min));
    }

    if (particleEndScale != particle.startScale)
    {
      particle.useScaling = true;
      particle.rangeScale = particleEndScale - particle.startScale;
    }
    else
    {
      particle.useScaling = false;
      particle.rangeScale = 0;
    }

    particle.blend = blend;

    // Set particle motion
    setParticleMotion(particle, angle, distance, angleRange, distanceRange);
    particle.acceleration.set(acceleration.x, acceleration.y);

    /*
    if (rotation.min != rotation.max)
    {
      particle.angularVelocity = rotation.min + FlxRandom.float() * (rotation.max - rotation.min);
    }
    else
    {
      particle.angularVelocity = rotation.min;
    }
    if (particle.angularVelocity != 0)
    {
      particle.angle = FlxRandom.float() * 360 - 180;
    }
    */
    // 回転速度を決定する
    var vStart = rotationStartVariance;
    var vEnd   = rotationEndVariance;
    var rotStart = rotationStart + FlxRandom.floatRanged(-vStart, vStart);
    var rotEnd   = rotationEnd   + FlxRandom.floatRanged(-vEnd, vEnd);
    particle.angularVelocity = (rotEnd - rotStart) / particle.lifespan;

    particle.drag.set(particleDrag.x, particleDrag.y);


    // Radial用パラメータ
    if(emitterType == FlxPDPList.TYPE_RADIAL) {
      // Radial
      particle.emitterType = emitterType;

      // 基準座標
      particle.xemitter = xcenter;
      particle.yemitter = ycenter;

      // 半径
      // 開始半径を決める
      var vStart = maxRadiusVariance;
      particle.startRadius = minRadius;
      var max = maxRadius + FlxRandom.floatRanged(-vStart, vStart);
      var d = (max - minRadius);
      // 移動範囲を決定
      particle.rangeRadius = d;

      // 回転
      particle.startRotate = FlxRandom.floatRanged(-179, 180);
      var vRotate = rotatePerSecondVariance;
      var speed = rotatePerSecond + FlxRandom.floatRanged(-vRotate, vRotate);
      particle.rangeRotate = speed * lifespan;

      // 移動を無効化
      particle.acceleration.set();
      particle.velocity.set();
    }

    particle.onEmit();
  }

  public function stop():Void {
    _explode = true;
    _quantity = 1;
  }
}
