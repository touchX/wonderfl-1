package {
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    public class HumanClock extends Sprite {
        private var _sec:int;
        private var _shpSec:Shape;
        private var _shpMin:Shape;
        private var _shpHour:Shape;
        private var _pathCommands:Vector.<int> = Vector.<int>([1,2,2,2,2]);
        
        public function HumanClock() {
            initView();
            var timer:Timer = new Timer(100);
            timer.addEventListener(TimerEvent.TIMER, onTimer);
            timer.start();
        }
        
        private function initView():void {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            var spContainer:Sprite = new Sprite;
            var shp:Shape;
            var t:Number;
            var layer:int;
            for (var i:int = 0; i < 2; ++i)
                spContainer.addChild(new Sprite);
            
            for (i = 0; i < 360; i += 30) {
                shp = new Shape;
                shp.graphics.beginFill(0);
                layer = 1;
                drawTrapezium(shp.graphics, 2, 16, 4, 0);
                shp.rotation = i;
                t = Math.PI / 180 * i - Math.PI / 2;
                shp.x = 180 * Math.cos(t); shp.y = 180 * Math.sin(t);
                Sprite(spContainer.getChildAt(layer)).addChild(shp);
            }
            
            _shpHour = new Shape;
            _shpHour.graphics.beginFill(0xdc143c);
            drawTrapezium(_shpHour.graphics, 6, 90, 10, -5);
            _shpHour.graphics.endFill();
            
            _shpMin = new Shape;
            _shpMin.graphics.beginFill(0x228b22);
            drawTrapezium(_shpMin.graphics, 5, 130, 8, -5);
            _shpMin.graphics.endFill();
            
            _shpSec = new Shape;
            _shpSec.graphics.beginFill(0xeb6101);
            drawTrapezium(_shpSec.graphics, 3, 150, 5, -5);
            _shpSec.graphics.endFill();
            
            spContainer.x = spContainer.y = 465 >> 1;
            addChild(spContainer);
            spContainer =  Sprite(spContainer.addChild(new Sprite));
            spContainer.addChild(_shpHour);
            spContainer.addChild(_shpMin);
            spContainer.addChild(_shpSec);
            spContainer.rotation = 180;
            
            onTimer(null);
        }
        
        private function drawTrapezium($graphics:Graphics, $right:Number, $top:Number, $left:Number, $bottom:Number):void {
            $graphics.drawPath(_pathCommands, Vector.<Number>([
                $left, $bottom, -$left, $bottom, -$right, $top, $right, $top, $left, $bottom
            ]));
        }
        
        private function onTimer(e:TimerEvent):void {
            var time:Date = new Date;
            var sec:int = time.getSeconds();
            if (_sec == sec) return;
            
            _sec = sec;
            updateView(time.getHours(), time.getMinutes(), sec);
        }
        
        private function updateView($hour:int, $min:int, $sec:int):void {
            _shpHour.rotation = ($hour % 12) * 30 + $min / 2;
            _shpMin.rotation = $min * 6;
            _shpSec.rotation = _sec * 6;
        }
    }
}