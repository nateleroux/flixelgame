package  
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	public class Collision 
	{
		private static var x0: Number; 
		private static var y0: Number; 
		private static var x1: Number; 
		private static var y1: Number; 
		private static var x2: Number; 
		private static var y2: Number; 
		private static var l : Number; 
		private static var r : Number; 
		private static var t : Number; 
		private static var b : Number; 
		
		private static var t0 : int;
		private static var t1 : int;
		private static var t2 : int;
		
		private static var s : Number
		
		private static var lm0 : Number
		private static var lm1 : Number
		private static var lm2 : Number
		
		private static var rm0 : Number
		private static var rm1 : Number
		private static var rm2 : Number
		
		private static var b0 : int;
		private static var b1 : int;
		private static var b2 : int;
		
		private static var i0 : int;
		private static var i1 : int;
		private static var i2 : int;
		
		private static var m : Number;
		private static var c : Number;
		private static var m0 : Number;
		private static var c0 : Number;
		private static var m1 : Number;
		private static var c1 : Number;
		private static var m2 : Number;
		private static var c2 : Number;
		
		public static var tempTri00 : Point;
		public static var tempTri01 : Point;
		public static var tempTri02 : Point;
		public static var tempTri10 : Point;
		public static var tempTri11 : Point;
		public static var tempTri12 : Point;
		public static var tempRect0 : Rectangle;
		public static var tempRect1 : Rectangle;
		
		public static var tileBB : Array;
		public static var tileTri : Array;
		
		public static function init() : void
		{
			tileBB = new Array(
				new Array(new Rectangle(0, 0, 16, 16)),
				
				new Array(new Rectangle(8, 0, 8, 16), new Rectangle(0, 8, 16, 8)),
				new Array(new Rectangle(0, 0, 8, 16), new Rectangle(0, 8, 16, 8)),
				new Array(new Rectangle(0, 0, 16, 8), new Rectangle(0, 0, 8, 16)),
				new Array(new Rectangle(0, 0, 16, 8), new Rectangle(8, 0, 8, 16)),
				
				new Array(new Rectangle(0, 0, 8, 16)),
				new Array(new Rectangle(0, 0, 16, 8)),
				new Array(new Rectangle(8, 0, 8, 16)),
				new Array(new Rectangle(0, 8, 16, 8)),
				
				new Array(new Rectangle(0, 0, 8, 8)),
				new Array(new Rectangle(8, 0, 8, 8)),
				new Array(new Rectangle(8, 8, 8, 8)),
				new Array(new Rectangle(0, 8, 8, 8)),
				new Array(), new Array(),
				new Array(), new Array(),
				new Array(), new Array(),
				new Array(), new Array()
				);
			
			tileTri = new Array(
				new Array(),
				new Array(), new Array(),
				new Array(), new Array(),
				new Array(), new Array(),
				new Array(), new Array(),
				new Array(), new Array(),
				new Array(), new Array(),
				/*
				new Array(new Array(new Point(0, 0), new Point(16, 0), new Point(0, 16))),
				new Array(new Array(new Point(0, 0), new Point(16, 0), new Point(16, 16))),
				new Array(new Array(new Point(0, 16), new Point(16, 16), new Point(16, 0))),
				new Array(new Array(new Point(0, 0), new Point(16, 16), new Point(0, 16))),
				
				new Array(new Array(new Point(0, 0), new Point(8, 0), new Point(0, 8))),
				new Array(new Array(new Point(8, 0), new Point(16, 0), new Point(16, 8))),
				new Array(new Array(new Point(16, 8), new Point(16, 16), new Point(8, 16))),
				new Array(new Array(new Point(0, 8), new Point(8, 16), new Point(0, 16)))
				/**/
				/**/
				new Array(new Array(new Point(0, 0), new Point(16, 0), new Point(0, 16))),
				new Array(new Array(new Point(0, 0), new Point(16, 0), new Point(16, 16))),
				new Array(new Array(new Point(0, 16), new Point(16, 16), new Point(16, 0))),
				new Array(new Array(new Point(0, 0), new Point(16, 16), new Point(0, 16))),
				
				new Array(new Array(new Point(0, 0), new Point(8, 0), new Point(0, 8))),
				new Array(new Array(new Point(8, 0), new Point(16, 0), new Point(16, 8))),
				new Array(new Array(new Point(16, 8), new Point(16, 16), new Point(8, 16))),
				new Array(new Array(new Point(0, 8), new Point(8, 16), new Point(0, 16)))
				/**/
				);
			
			tempTri00 = new Point;
			tempTri01 = new Point;
			tempTri02 = new Point;
			tempTri10 = new Point;
			tempTri11 = new Point;
			tempTri12 = new Point;
			tempRect0 = new Rectangle;
			tempRect1 = new Rectangle;
		}
		
		public static function rectangleTest(rect:Rectangle, rect2:Rectangle) : Boolean
		{
			return !(rect.left >= rect2.right ||
					 rect.right <= rect2.left ||
					 rect.top >= rect2.bottom ||
					 rect.bottom <= rect2.top);
		}
		
		public static function rectangleTestToPoint(rect:Rectangle, x:int, y:int, point:Point, w:int, h:int) : Boolean
		{
			return !(rect.left + x >= point.x + w ||
					 rect.right + x <= point.x ||
					 rect.top + y >= point.y + h ||
					 rect.bottom + y <= point.y);
		}
	  
		public static function triangleTest(rect:Rectangle, vertex0:Point, vertex1:Point, vertex2:Point) : Boolean
		{
			// YOU MUST LEAVE THESE DECLARATIONS; they simulate necessary data exchange within PV3D
			l = rect.left;
			r = rect.right;
			t = rect.top;
			b = rect.bottom;
			
			x0 = vertex0.x;
			y0 = vertex0.y;
			x1 = vertex1.x;
			y1 = vertex1.y;
			x2 = vertex2.x;
			y2 = vertex2.y;
			
			b0 =  int(x0 >= l) | int(y0 >= t) << 1 | int (x0 >= r) << 2 | int (y0 >= b) << 3;
			if (b0 == 3) return true;
			b1 =  int(x1 >= l) | int(y1 >= t) << 1 | int (x1 >= r) << 2 | int (y1 >= b) << 3;
			if (b1 == 3) return true;
			b2 =  int(x2 >= l) | int(y2 >= t) << 1 | int (x2 >= r) << 2 | int (y2 >= b) << 3;
			if (b2 == 3) return true;
			
			i0 = b0 ^ b1;
			if (i0 != 0)
			{
				m = (y1-y0) / (x1-x0); 
				c = y0 -(m * x0);
				if (Boolean(i0 & 1)) { s = m * l + c; if ( s > t && s < b) return true; }
				if (Boolean(i0 & 2)) { s = (t - c) / m; if ( s > l && s < r) return true; }
				if (Boolean(i0 & 4)) { s = m * r + c; if ( s > t && s < b) return true; }
				if (Boolean(i0 & 8)) { s = (b - c) / m; if ( s > l && s < r) return true; }
			}
			
			i1 = b1 ^ b2;
			if (i1 != 0)
			{
				m = (y2-y1) / (x2-x1); 
				c = y1 -(m * x1);
				if (Boolean(i1 & 1)) { s = m * l + c; if ( s > t && s < b) return true; }
				if (Boolean(i1 & 2)) { s = (t - c) / m; if ( s > l && s < r) return true; }
				if (Boolean(i1 & 4)) { s = m * r + c; if ( s > t && s < b) return true; }
				if (Boolean(i1 & 8)) { s = (b - c) / m; if ( s > l && s < r) return true; }
			}
			
			i2 = b0 ^ b2;
			if (i2 != 0)
			{
				m = (y2-y0) / (x2-x0); 
				c = y0 -(m * x0);
				if (Boolean(i2 & 1)) { s = m * l + c; if ( s > t && s < b) return true; }
				if (Boolean(i2 & 2)) { s = (t - c) / m; if ( s > l && s < r) return true; }
				if (Boolean(i2 & 4)) { s = m * r + c; if ( s > t && s < b) return true; }
				if (Boolean(i2 & 8)) { s = (b - c) / m; if ( s > l && s < r) return true; }
			}
			
			return false;
		}
		
	}

}