package;

import flixel.FlxState;

class PlayState extends FlxState {
  override public function create():Void {
    super.create();

    var plist = new FlxPDPList("assets/data/particle_texture.plist");
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update():Void {
    super.update();
  }
}