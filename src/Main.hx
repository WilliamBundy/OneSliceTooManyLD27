package ;

import embed.SndNom1;
import embed.SndNom2;
import embed.SndNom3;
import embed.SndNom4;
import embed.SndNom5;
import embed.SndNom6;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.TimerEvent;
import flash.Lib;
import flash.media.Sound;
import flash.utils.Timer;

/**
 * ...
 * @author William Bundy
 */

class Main 
{
	public static var frame:Int = 1;
	public static var frame1text = "That's it. We're going to die.";
	public static var frame2text = "It's going to detonate in about...";
	public static var frame3text = "...Eight seconds.";
	public static var frame4text_good = "I'm glad you were with me.";
	public static var frame4text_bad  = " And it's all your fault.";
	public static var frame5text_good = "Nobody else could have done what we did.";
	public static var frame5text_bad  = "On the verge of success, you chose yourself over us.";
	public static var frame6text_good = "But we still failed.";
	public static var frame6text_bad = "Gluttony and greed are all you have now.";
	public static var frame7text = "Actually, maybe it's better this way";
	public static var frame8text_good = "Now everybody can have as much as they want.";
	public static var frame8text_bad = "You ended life as we know it, but you get what you deserve.";
	public static var frame9text_good = "It's like being free.";
	public static var frame9text_bad = "Your 'just desserts'* so to speak.";
	public static var frame10text_good = "Thanks...";
	public static var frame10text_neutral = "But why didn't you sto-";
	public static var frame10text_bad = "I still hate you, though.";
	public static var alignment:Int = 0;
	public static var alt1text = "(In the strangest way known to man.)";
	public static var alt2text = "(There's something wrong with you!)";
	public static var alt3text = "(And who pushed the button to set it off?)";
	public static var alt4text_good = "(I'm not!)";
	public static var alt4text_bad = "(I was hungry!)";
	public static var alt5text_good = "(You mean eating a cake?)";
	public static var alt5text_bad = "(That was everybody's cake! Not just yours!)";
	public static var alt6text_bad = "(I only had one slice per day! With tea even!)";
	public static var alt6text_good = "(You're obsessive!)";
	public static var alt7text = "(How would transforming everybody into cake be better?)";
	public static var alt8text_good = "(That's cannibalism, if you didn't notice.)";
	public static var alt8text_bad = "(What's the punishment for insanity?)";
	public static var alt9text_good = "(It's like you've lost your mind.)";
	public static var alt9text_bad = "(Is that a bad pun or a spelling mistake?)";
	public static var nomsounds:Array<Sound>;
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		var curr = Lib.current;
		//ensure black background
		curr.graphics.beginFill(0, 1.0);
		curr.graphics.drawRect( -100, -100, 1000, 1000);
		curr.graphics.endFill();
		// entry point
		nomsounds = new Array<Sound>();
		nomsounds.push(new SndNom1());
		nomsounds.push(new SndNom2());
		nomsounds.push(new SndNom3());
		nomsounds.push(new SndNom4());
		nomsounds.push(new SndNom5());
		nomsounds.push(new SndNom6());
		
		cframe = new GameFrame(frame1text, alt1text, 11-frame);
		stage.addChild(cframe);
		
	}
	
	public static var cframe:GameFrame;
	public static var route:String;
	
	public static function omnomnom(times:Int):Void
	{
		var t:Timer = new Timer(Std.int(Math.random() * 50 + 170), times);
		t.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):Void
		{
			var i = Std.int(Math.random() * 6);
			nomsounds[i].play();
		});
		t.start();
	}
	
	public static function nextFrame():Void
	{
		var stage = Lib.current.stage;
		stage.removeChild(cframe);
		//cframe = null;
		frame++;
		if (frame == 2) {
			
				cframe = new GameFrame(frame2text, alt2text, 11 - frame);
		} else if (frame == 3) {
				cframe = new GameFrame(frame3text, alt3text, 11 - frame);
		} else if (frame == 4) {
			
				if (alignment <= -1) {
					
					route = "bad";
					cframe = new GameFrame(frame4text_bad, alt4text_bad, 11-frame);
				}
				else {
					
					route = "good";
					cframe = new GameFrame(frame4text_good, alt4text_good, 11-frame);
				}
		}
			else if (frame == 5) {
				
				if(route == "bad")
					cframe = new GameFrame(frame5text_bad, alt5text_bad, 11-frame);
				else if (route == "good")
					cframe = new GameFrame(frame5text_good, alt5text_good, 11-frame);
			}
		else if (frame == 6) {
			
				if(route == "bad")
					cframe = new GameFrame(frame6text_bad, alt6text_bad, 11-frame);
				else if (route == "good")
					cframe = new GameFrame(frame6text_good, alt6text_good, 11 - frame);
					
		}
		else if(frame == 7) {
				if (route == "good" && alignment < 0)
					route = "neutral-bad";
				else if (route == "bad" && alignment > 0)
					route = "neutral-good";
				cframe = new GameFrame(frame7text, alt7text, 11-frame);
		}
		else if (frame == 8) {
			
				if(route == "good" || route == "neutral-good")
					cframe = new GameFrame(frame8text_good, alt8text_good, 11-frame);
				else if (route == "bad" || route == "neutral-bad")
					cframe = new GameFrame(frame8text_bad, alt8text_bad, 11 - frame);
		} else if (frame == 9) { 
				if(route == "good" || route == "neutral-good")
					cframe = new GameFrame(frame9text_good, alt9text_good, 11-frame);
				else if (route == "bad" || route == "neutral-bad")
					cframe = new GameFrame(frame9text_bad, alt9text_bad, 11 - frame);
		} else if (frame == 10) {
				if(route == "bad")
					cframe = new GameFrame(frame10text_bad, "", 11-frame);
				else if (route == "neutral-good" || route == "neutral-bad")
					cframe = new GameFrame(frame10text_neutral, "", 11-frame);
				else if (route == "good")
					cframe = new GameFrame(frame10text_good, "", 11 - frame);
		}
		else {
			frame = 1;
			cframe = new GameFrame(frame1text, alt1text, 11-frame);
		}
		stage.addChild(cframe);
	}
}