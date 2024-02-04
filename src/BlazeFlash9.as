package {
	
	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.controls.TextArea;
	import fl.data.DataProvider;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.net.registerClassAlias;
	
	public class BlazeFlash9 extends MovieClip {
		
		/**
		 * Connection string for remote service
		 */
		public static const CONNECTION_URL:String = "http://localhost:8400/samples/messagebroker/amf";
		
		/**
		 * Method to call for remote service
		 */
		public static const CONNECTION_METHOD:String = "location.getLocations";
		
		/**
		 * Trigger button
		 */
		public var trigger:Button
		
		/**
		 * Results grid
		 */
		public var results:DataGrid;
		
		/**
		 * onscreen logger window
		 */
		public var status:TextArea;
		
		/**
		 * Net connection for making data call
		 */
		private var _netConnection:NetConnection;
		
		/**
		 * Constructor
		 */
		public function BlazeFlash9() {
			status.htmlText = "Initializing Application<br>";
			
			//prepare button
			trigger.addEventListener(MouseEvent.CLICK, onClickTrigger);
			
			//register actionscript object with java equivalent
			flash.net.registerClassAlias( "com.coursevector.service.Location", Location9);
			
			//add columns to results grid
			results.addColumn("id");
	    	results.addColumn("userId");
	    	results.addColumn("name");
	    	results.addColumn("notes");
	    	results.addColumn("createdAt");
	    	results.addColumn("updatedAt");
		}
		
		/**
		 * Make connection and get results
		 */
		private function onClickTrigger(eventObj:MouseEvent):void {
			status.htmlText += "Initializing Connection to <b>" + CONNECTION_URL + "</b><br>";
			status.htmlText += "Invoking Method <b>" + CONNECTION_METHOD + "</b><br>";
			
			//create net connection and add listeners
			_netConnection = new NetConnection();
			_netConnection.objectEncoding = ObjectEncoding.AMF0;
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
            _netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectionError);
            _netConnection.addEventListener(IOErrorEvent.IO_ERROR , onConnectionError);
            _netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR , onConnectionError);
            
            //make connection and call method
            _netConnection.connect(CONNECTION_URL);
            _netConnection.call(CONNECTION_METHOD, new Responder(onResult, onFault));
		}
		
		/**
		 * Get products result
		 * 
		 * @param resultObj Untyped object that carries a property "source" which is the actual results of the data call
		 */
		public function onResult(resultObj:Object):void {
			status.htmlText += "onResult<br>";

			//create data provider for results grid
			var resultsProvider:DataProvider = new DataProvider();
			
			//cast source to array and pick off the Product objects
			try {
				var resultsList:Array = resultObj.source as Array;
				for(var i:int=0; i<resultsList.length; i++) {
					resultsProvider.addItem(resultsList[i] as Location9);
				}
			} catch (error:Error) {
				status.htmlText += error.message+  "<br>";
			}
			
			//set datagrid provider
			results.dataProvider = resultsProvider;
		}
		
		/**
		 * Get products fault
		 */
		public function onFault(fault:Object):void {
			status.htmlText += "onFault<br>";
		}
		
		/**
		 * Connection status
		 */
		private function onNetStatus(eventObj:NetStatusEvent):void {
			status.htmlText += "onNetStatus " + eventObj.info.code + "<br>";
		}
		
		/**
		 * Connection fault
		 */
		private function onConnectionError(eventObj:ErrorEvent):void {
			status.htmlText += "Connection error " + eventObj.toString() + "<br>";
		}
		
		
	}
	
	
}
