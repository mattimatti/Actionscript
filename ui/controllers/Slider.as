package com.rensel.ui.controllers
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Event (name="change", type="flash.events.Event")]
	[Event (name="mouse_up", type="flash.events.MouseEvent")]
	[Event (name="mouse_down", type="flash.events.MouseEvent")]
	/**
	 * The slider class takes a MovieClip which contains a "Handle" and "Track" for a slidebar interface componant and add the functionality
	 * of a slidebar. Values for the handle position on the track are returned as a number between 0 and 1. The size of the handle can be changed
	 * dynamically by using the potential property. The slider movieclips must start in the vertical position, they will be rotated by the class for
	 * the horizontal = true;  This class dispatches an event everytime the value of the slider changes, listening for the Event.CHANGE can be used
	 * to update values.
	 * @author adamrensel
	 * 
	 */	
	public class Slider extends EventDispatcher
	{
		private var _handle:MovieClip;
		private var _track:MovieClip;
		private var _horizontal:Boolean;
		private var _percent:Number;
		private var _perc:Number;
		
		private var _reverse:Boolean = false
		
		public function Slider(handle:MovieClip,track:MovieClip,horizontal:Boolean = false)
		{
			_handle = handle;
			_track = track;
			_horizontal = horizontal;
			
			/*if(horizontal == true)
			{
				_handle.rotation = -90;
				_track.rotation = -90;
				
			}*/ 
			
			
			_track.addEventListener(MouseEvent.CLICK,track_ClickHandler);
			
			_handle.buttonMode = true;
			_handle.addEventListener(MouseEvent.MOUSE_DOWN,handle_mouseDownHandler);
			
			updateValue();
			
			
		}
		private function track_ClickHandler(evt:MouseEvent):void
		{
		
			
			if(_horizontal == true)
			{
				if(_track.mouseX > _handle.x)
				{
					_handle.x = _track.mouseX - _handle.width;
				}else{
					_handle.x = _track.mouseX; 
				}
			}
			
			if(_horizontal == false)
			{	if(_track.mouseY > _handle.y)
				{
					_handle.y = _track.mouseY - _handle.height;
				}else{
					_handle.y = _track.mouseY;
				}
			}
			updateValue();
		}
		private function handle_mouseDownHandler(evt:MouseEvent):void
		{
			if(_horizontal == true)
			{
				_handle.startDrag(false,new Rectangle(0,0,_track.width - _handle.width,0));
			}else{
				_handle.startDrag(false,new Rectangle(0,0,0,_track.height - _handle.height));
			}
			_handle.stage.addEventListener(MouseEvent.MOUSE_UP,handle_mouseUpHandler);
			_handle.addEventListener(Event.ENTER_FRAME, onFrame_Handler);
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			
		}
		private function handle_mouseUpHandler(evt:MouseEvent):void
		{
			_handle.stopDrag();
			_handle.stage.removeEventListener(MouseEvent.MOUSE_UP,handle_mouseUpHandler);
			_handle.removeEventListener(Event.ENTER_FRAME, onFrame_Handler);
			
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			
		}
		private function onFrame_Handler(evt:Event):void
		{
			updateValue();

		}
		private function updateValue():void
		{
			var perc:Number;
			
			if(_horizontal == true)
			{
				perc = _handle.x / (_track.width - _handle.width);
			}else{
				perc = _handle.y / (_track.height - _handle.height);
			}
			
			if (_percent != perc) 
			{
				_percent = perc;
					
				var e:Event = new Event(Event.CHANGE);
				this.dispatchEvent(e);
		
				//trace(_percent);
			}
		}
		private function handlePosition():void
		{
			if(_horizontal == true)
			{
				_handle.x = _percent * (_track.width /*- _handle.width*/);
			}else{
				_handle.y = _percent * (_track.height /*- _handle.height*/);
			}
		}
		
		
		//------------- GETTERS/SETTERS -----------//
		/**
		 *Used to set or return the value of the position of the slider. The value returned is a percentage of the total track length. 
		 * @return 
		 * 
		 */		
		public function get value():Number
		{
			return _percent;
		}
		/**
		 *@private 
		 * @param value
		 * 
		 */		
		public function set value(value:Number):void
		{
			_percent = value;
			
			handlePosition();
		}
		/**
		 *Used to set the size of the handle, the number is set or returned as a percentage. 
		 * @param value
		 * 
		 */		
		public function set potential(value:Number):void
		{
			if(value <= 1 && value >= 0)
			{
				_handle.height = _track.height * value;
				_perc = value;
				this.value = this.value;
			}else{
				if(value <= 0)
				{
					_perc = 0;
				}
				
				if(value >= 1)
				{
					_perc = 1;	
				}
				
			}
		}
		/**
		 *@private 
		 * @return 
		 * 
		 */		
		public function get potential():Number
		{
			return _perc;
		}
		
		public function removeClick():void
		{
			_track.removeEventListener(MouseEvent.CLICK,track_ClickHandler);
		}
		
		public function addClick():void
		{
			_track.addEventListener(MouseEvent.CLICK,track_ClickHandler);
		}

	}
}