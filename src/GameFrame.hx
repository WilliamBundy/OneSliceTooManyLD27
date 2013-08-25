package ;

import embed.SndBass;
import embed.SndBomb;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.media.Sound;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.Timer;
import flash.Lib;
/**
 * ...
 * @author William Bundy
 */
class GameFrame extends Sprite
{
	public var text:String;
	public var alttext:String;
	public var tminus:Int;
	public var cmd:String;
	public var k1:String;
	public var k2:String;

	public var tminusTF:TextField;
	public var textTF:TextField;
	public var alttextTF:TextField;
	public var cmdTF:TextField;
	public var style1:TextFormat;
	public var style2:TextFormat;
	
	public var timer:Timer;
	public var tcount:Int;
	
	public var key1:Bool;
	public var key2:Bool;
	
	public var phase:Int;
	
	public function new(t, at, tm) 
	{
		super();
		text = t;
		alttext = at;
		tminus = tm;
		
	/*	trace("New Frame!");
		trace(t);
		trace(at);
		trace(tm); */
		style1 = new TextFormat("_sans", 256, 0xFFFFFF);
		style2 = new TextFormat("_sans", 24, 0xFFFFFF, false, true);
		tminusTF = initTF(tminusTF, style1, Std.string(tminus));
		textTF = initTF(textTF, style2, text);
		textTF.y += tminusTF.height / 2;
		alttextTF = initTF(alttextTF, style2, alttext);
		alttextTF.y += tminusTF.height / 2 + 6;
		k1 = tminus % 2 == 0 ? "Backspace" : "Space";
		k2 = tminus % 2 == 0 ? "Space" : "Backspace";
		cmd = "There's some cake here. \n"+(Math.random()<0.25 ? "You have a cup of tea to go with it." : "")+"\n\nPress " + k1 + " to take a slice, or " + k2 + " to leave it be.";
		cmdTF = initTF(cmdTF, style2, cmd);
		cmdTF.alpha = 0;
		phase = 1;
		metTarget = false;
		addChild(cmdTF);
		
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      	Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
       	this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	var metTarget:Bool;
	var nobomb:Bool;
	
	private function onEnterFrame(e:Event):Void 
	{
		var dt:Float = .5;
		if (phase == 1)
		{
			cmdTF.alpha += .05 * dt;
			if (cmdTF.alpha >= 1) {
				cmdTF.alpha = 1;
				metTarget = true;
			}
			
		}
		if (phase == 2)
		{
			
			if (key1 && metTarget)
			{
				textTF.alpha -= .1 * dt;
				tminusTF.alpha -= .1 * dt;
				cmdTF.alpha -= .1 * dt;
			}
			else if (key2 && metTarget)
			{
				textTF.alpha -= .1 * dt;
				if (textTF.alpha <= 0) textTF.alpha = 0;
				alttextTF.alpha += .1 * dt;
				if (alttextTF.alpha >= .5) alttextTF.alpha = .5;
			}
			else if (!key2) {
				tminusTF.alpha += .1 * dt;
				if (tminusTF.alpha >= 2.0) tminusTF.alpha = 2.0;
				textTF.alpha += .1 * dt;
				if (textTF.alpha >= 1) textTF.alpha = 1.0;
				alttextTF.alpha  -= .1 * dt;
				if (alttextTF.alpha <= 0) alttextTF.alpha = 0;
			}
			
			if (textTF.alpha >= .95 && !metTarget) {
				metTarget = true;
			}
			if (metTarget && !key1) {
				cmdTF.alpha += .1 * dt;
				if (cmdTF.alpha >= 1.0) cmdTF.alpha = 1.0;
			}
			
			if (tminus == 1 && !nobomb) {
				new SndBomb().play();
				nobomb = true;
			}
			
			if (nobomb && metTarget) {
				this.alpha -= .0125 * dt;
			}
			
			
			if (tminusTF.alpha <= 0 && metTarget && key1)
			{
			
				key1 = false;
				key2 = false;
				metTarget = false;
				destroy();
				
			}
			
			//trace(key2);
		}
	}
	
	public function destroy():Void
	{
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		Main.nextFrame();
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		if (e.keyCode == 8) {
			// backspace
			if(k1 == "Backspace")
				key1 = false;
			else if (k2 == "Backspace")
				key2 = false;
		}
		if (e.keyCode == 32) {
			if(k1 == "Space")
				key1 = false;
			else if (k2 == "Space")
				key2 = false;
		}
	}
	
	private function onKeyDown(e:KeyboardEvent):Void 
	{
		if (tminus == 1 && phase == 2) {
			return;
		}
		if (e.keyCode == 8) {
			
			if (phase == 1 && k1 == "Backspace" && metTarget)
			{
				eatCake();
			}
			else if (phase == 1 && k2 == "Backspace" && metTarget)
			{
				ignoreCake();
			}
			if(k1 == "Backspace")
				key1 = true;
			else if (k2 == "Backspace")
				key2 = true;
		}
		if (e.keyCode == 32) {
			if (phase == 1 && k1 == "Space" && metTarget)
			{
				eatCake();
			}
			else if (phase == 1 && k2 == "Space" && metTarget )
			{
				ignoreCake();
			}
			if(k1 == "Space")
				key1 = true;
			else if (k2 == "Space")
				key2 = true;
		}
	}
	
	public function eatCake()
	{
		Main.alignment -= 1;
		phase++;
		if (tminus != 4 && tminus != 7 && tminus != 1) {
			Main.omnomnom(Std.int(Math.random() * 9 + 4));
		}
		initPhase2();
		
		
	}
	
	public function initPhase2()
	{
		if (tminus == 4 || tminus == 7 || tminus == 1)
		{
			new SndBass().play();
		}
		
		key1 = false;
		key2 = false;
		metTarget = false;
		removeChild(cmdTF);
		addChild(tminusTF);
		textTF.alpha = 0;
		addChild(textTF);
		alttextTF.alpha = 0;
		addChild(alttextTF);
		tminus--;
		k1 = tminus % 2 == 0 ? "Backspace" : "Space";
		k2 = tminus % 2 == 0 ? "Space" : "Backspace";
		tminus++;
		cmd = "Hold " + k1 + " to continue.";
		cmdTF = initTF(cmdTF, style2, cmd);
        cmdTF.y = stage.stageHeight - cmdTF.height * 2;
		addChild(cmdTF);
	}
	
	public function ignoreCake()
	{
		Main.alignment += 1;
		phase++;
		initPhase2();
	}
	
	public function altmsg()
	{
		
	}
	
	public function nextFrame()
	{
		
	}
	
	public function initTF(tf:TextField, style:TextFormat, t:String):TextField
	{
		var tf = new TextField();
		tf.selectable = false;
		tf.defaultTextFormat = style;
		tf.autoSize = TextFieldAutoSize.CENTER;
		tf.text = Std.string(t);
		tf.x = Lib.current.stage.stageWidth - tf.width;
		tf.x /= 2;
		tf.y = Lib.current.stage.stageHeight - tf.height;
		tf.y /= 2;
		return tf;
	}
}