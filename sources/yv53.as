package  
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.geom.Rectangle;

    /**
     * Snake Game とりあえず100行以内で書きたかった。
     * 簡易のAI 例 http://wonderfl.net/code/c4b660633f93dee3264a37ca5fbbdb3a7e3adf02
     */
    [SWF (backgroundColor = "0xFFFFFF", frameRate = "60", width = "465", height = "465")]
    public class SnakeGame extends Sprite
    {
        // bmp, bmd 描画されるところ。
        private var bmp: Bitmap, bmd: BitmapData;
        // key は今から進もうと思っている方向, way は今進んでいる方向。
        private var key: uint, way: uint;
        // snake は ヘビの配列、[0] が先頭。 point はヘビが取っていくドット。
        private var snake: Array, point: Snake;
        // 描画領域
        private var viewRect: Rectangle;
        // speedK は スピード調整用の係数。 1 ～ N (小さいほど早い)、 speedC は wait 用のカウンタ(いじる必要なす)、 snakeLength は ヘビの長さ。(1～)
        private var speedK: int = 30, speedC: int = 0, snakeLength: int = 1;
       
        public function SnakeGame()
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
       
        private function init(e: Event = null): void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            //
            addChild(bmp = new Bitmap(bmd = new BitmapData(stageW, stageW, false, 0)));
            bmp.scaleX = bmp.scaleY = cellSize;
            bmd.fillRect(viewRect = new Rectangle(1, 1, stageW2, stageW2), 0xFFFFFF);
            snake = [new Snake(stageW >> 1, stageW >> 1)], point = new Snake();
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown); // AI を作るときはこの行をコメントアウト。
            addEventListener(Event.ENTER_FRAME, loop);
        }
        
        /**
         * ココを書いたりする。
         */
        private function ai(): void
        {
        }
       
        private function onKeyDown(e: KeyboardEvent ): void { changeWay(e.keyCode); }
        /**
         * 方向変更
         * @param    keyCode
         * @return    <Boolean> : 方向変更可能だったら true
         */
        private function changeWay(keyCode: uint): Boolean
        {
            var b: Boolean;
            switch (keyCode)
            {
                case UP:       if (b = (way != 1 << 1)) key = 1 << 0; break;
                case DOWN:     if (b = (way != 1 << 0)) key = 1 << 1; break;
                case LEFT:     if (b = (way != 1 << 3)) key = 1 << 2; break;
                case RIGHT:    if (b = (way != 1 << 2)) key = 1 << 3; break;
            }
            return b;
        }
        
        private function loop(e: Event ): void
        {
            if (speedC++ % speedK == 0)
            {
                way = key;
                var s: Snake = snake[0], i: int, c: uint, tx: int, ty: int, vx: int = key & 12 ? (key >> 1) - 3 : 0, vy: int = key & 3 ? (key << 1) - 3 : 0
                bmd.lock();
                if ((c = bmd.getPixel(s.x + vx, s.y + vy)) == 0) { removeEventListener(Event.ENTER_FRAME, loop); return; }
                else if (c == 0xFF0000) snakeLength = snake.push(point), point = new Snake(), speedK = speedK < 2 ? 1 : speedK - 1;
                bmd.fillRect(viewRect, 0xFFFFFF);
                tx = s.x, ty = s.y;
                bmd.setPixel(s.x += vx, s.y += vy, 1);
                for (i = 1; i < snakeLength; i++)
                {
                    s = snake[i];
                    vx = s.x, vy = s.y;
                    bmd.setPixel(s.x = tx, s.y = ty, 0);
                    tx = vx, ty = vy;
                }
                c = bmd.getPixel(point.x, point.y);
                bmd.setPixel(point.x, point.y, c == 0xFFFFFF ? 0xFF0000 : 0xFF0001);
                bmd.unlock();
                ai();
            }
        }
    }
}

const stageW:    int = 31;            // stage のサイズ
const stageW2:   int = stageW - 2;    // stage のサイズから、枠を除いた数
const cellSize:  int = 15;            // 一つ一つのセルのサイズ (px)
const UP:        uint = 38;           // AI が changeWay する時用の 上 Key のキーコード
const DOWN:      uint = 40;           // AI が changeWay する時用の 下 Key のキーコード
const LEFT:      uint = 37;           // AI が changeWay する時用の 左 Key のキーコード
const RIGHT:     uint = 39;           // AI が changeWay する時用の 右 Key のキーコード

class Snake
{
    public var x: int, y: int;
    function Snake(x_: int = 0, y_: int = 0)
    {
        x = x_ || Math.random() * stageW2 + 1, y = y_ || Math.random() * stageW2 + 1;
    }
}