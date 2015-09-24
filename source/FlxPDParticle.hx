package ;
import flixel.util.FlxAngle;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.effects.particles.FlxParticle;

/**
 * Partlcle Designerのパーティクル
 **/
class FlxPDParticle extends FlxParticle {

  // エミッタの種類
  public var emitterType:Int = 0;

  // Radialパラメータ
  public var startRadius:Float = 0;
  public var rangeRadius:Float = 0;
  public var startRotate:Float = 0;
  public var rangeRotate:Float = 0;
  public var xemitter:Float    = 0;
  public var yemitter:Float    = 0;

  /**
	 * The particle's main update logic.  Basically it checks to see if it should
	 * be dead yet, and then has some special bounce behavior if there is some gravity on it.
	 */
  override public function update():Void
  {
    // Lifespan behavior
    if (lifespan > 0)
    {
      lifespan -= FlxG.elapsed;
      if (lifespan <= 0)
      {
        kill();
      }

      var lifespanRatio:Float = (1 - lifespan / maxLifespan);

      // Fading
      if (useFading)
      {
        alpha = startAlpha + lifespanRatio * rangeAlpha;
      }

      // Changing size
      if (useScaling)
      {
        scale.x = scale.y = startScale + lifespanRatio * rangeScale;
      }

      // Tinting
      if (useColoring)
      {
        var redComp:Float = startRed + lifespanRatio * rangeRed;
        var greenComp:Float = startGreen + lifespanRatio * rangeGreen;
        var blueComp:Float = startBlue + lifespanRatio * rangeBlue;

        color = Std.int(255 * redComp) << 16 | Std.int(255 * greenComp) << 8 | Std.int(255 * blueComp);
      }

      // Simpler bounce/spin behavior for now
      if (touching != 0)
      {
        if (angularVelocity != 0)
        {
          angularVelocity = -angularVelocity;
        }
      }
      // Special behavior for particles with gravity
      if (acceleration.y > 0)
      {
        if ((touching & FlxObject.FLOOR) != 0)
        {
          drag.x = friction;

          if ((wasTouching & FlxObject.FLOOR) == 0)
          {
            if (velocity.y < -elasticity * 10)
            {
              if (angularVelocity != 0)
              {
                angularVelocity *= -elasticity;
              }
            }
            else
            {
              velocity.y = 0;
              angularVelocity = 0;
            }
          }
        }
        else
        {
          drag.x = 0;
        }
      }

      if(emitterType == FlxPDPList.TYPE_RADIAL) {
        // Radial
        var radius = startRadius + (1 - lifespanRatio) * rangeRadius;
        var rotate = startRotate + lifespanRatio * rangeRotate;
        var rad    = rotate * FlxAngle.TO_RAD;
        x = xemitter + radius * Math.cos(rad);
        y = yemitter + radius * Math.sin(rad);
      }
    }

    if (exists && alive)
    {
      super.update();
    }
  }
}
