package modules.expres
{
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.AIREvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Window;
	
	import _me.Scene_data;
	
	import common.utils.frame.BasePanel;
	import common.utils.ui.cbox.ComLabelBox;
	import common.utils.ui.check.CheckLabelBox;
	
	import modules.brower.fileTip.RadiostiyInfoEndBut;
	import modules.hierarchy.FileSaveModel;
	import modules.scene.sceneSave.FilePathManager;
	
	public class ExpResPanel extends BasePanel
	{	

		private var _panelVec:Vector.<BasePanel>;
		private var _bg:UIComponent;
		private var _tittleA:Label;


		public function ExpResPanel()
		{
			super();
			this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x000000);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			addBack();
			addSearch()
			addTbCombobox();
			addQualityComboBox();
	
			addList();
			addButs();
			addCheckLabelBox();

			addEvents();

		}
		private var _expUiCheck:CheckLabelBox
		private function addCheckLabelBox():void
		{
			_expUiCheck = new CheckLabelBox;
			_expUiCheck.label = "导出UI"
			_expUiCheck.width = 120;
			_expUiCheck.height = 18;
			_expUiCheck.changFun = _expUiCheckChange
			this.addChild(_expUiCheck)
		}
	
		
		public var isUi:Boolean=false
		public function _expUiCheckChange(value:Boolean):void
		{
			isUi=value
				trace(isUi)
		}
		
		private static var _win:Window;
		private static var _sceneConfigPanel:ExpResPanel;
		private static var breakFun:Function
		private static function winEnterFun(value:Object):void
		{
			if(_win){
				if(!_win.closed){
					_win.close()
				}
				_win=null
			}
			breakFun(value);
		}

		
		public static function initExpPanel($bfun:Function,$tbList:Array=null):void
		{
		
				
			if($tbList){
				useTabelName=$tbList;
			}else{
				useTabelName=["tb_creature_template","tb_item_template","tb_map"];
			}
			breakFun=$bfun
			if(_win&&!_win.closed){
				_win.close()
			}
			_sceneConfigPanel=new ExpResPanel
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.NORMAL;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 400;
			$win.height= 400;
			$win.alwaysInFront=false
			$win.resizable=true
			$win.showStatusBar = false;
			
			
			_sceneConfigPanel.setStyle("left",0);
			_sceneConfigPanel.setStyle("right",0);
			_sceneConfigPanel.setStyle("top",0);
			_sceneConfigPanel.setStyle("bottom",0);
	
			$win.addElement(_sceneConfigPanel);
			$win.addEventListener(AIREvent.WINDOW_COMPLETE,windowComplete)

	
			$win.open(true);
			_win=$win;
			_win.visible=false;
			_sceneConfigPanel.selectBackFun=winEnterFun;
			
			
		
		}
		

		private static function windowComplete(event:AIREvent):void
		{
			Window(event.target).nativeWindow.x=Scene_data.stage.nativeWindow.x+Scene_data.stage.stageWidth/2-Window(event.target).nativeWindow.width/2;
			Window(event.target).nativeWindow.y=Scene_data.stage.nativeWindow.y+Scene_data.stage.stageHeight/2-Window(event.target).nativeWindow.height/2;
			_win.visible=true
			_sceneConfigPanel.initData()
			
		}
		
		private var _searchTxt:TextInput
		private function addSearch():void
		{
			_searchTxt=new TextInput;
			_searchTxt.height=22;
			_searchTxt.y=3;
			_searchTxt.x=150;
			_searchTxt.width=200;
			
			_searchTxt.setStyle("contentBackgroundColor",0x404040);
			_searchTxt.setStyle("borderVisible",true);
			_searchTxt.setStyle("fontSize",11);
			_searchTxt.setStyle("fontFamily","Microsoft Yahei");
			_searchTxt.setStyle("color",0x9c9c9c);
			
			this.addChild(_searchTxt)
			_searchTxt.addEventListener(FlexEvent.ENTER,onEnterTxt);
			_searchTxt.addEventListener(Event.CHANGE,onSecarchTextChange)
			
		}
		

		
		protected function onSecarchTextChange(event:Event):void
		{
			var $str:String=Trim(_searchTxt.text);
			if($str.length>1&&_searchArr){
				var arr:ArrayCollection=new ArrayCollection
				for(var i:Number=0;i<_searchArr.length;i++){
					if(String(_searchArr[i].id).search($str)!=-1||String(_searchArr[i].info).search($str)!=-1){
						arr.addItem(_searchArr[i])
					}
				}
				setDataToList(arr)
			}
			if($str.length==0){
				setDataToList(_searchArr)
			}
			
		}
		
		protected function onEnterTxt(event:FlexEvent):void
		{
			
			var $str:String=Trim(_searchTxt.text);
			if($str.length&&_searchArr){
				var arr:ArrayCollection=new ArrayCollection
				for(var i:Number=0;i<_searchArr.length;i++){
					if(String(_searchArr[i].id).search($str)!=-1||String(_searchArr[i].info).search($str)!=-1){
						arr.addItem(_searchArr[i])
					}
				}
				setDataToList(arr)
			}
			//setDataToList(_searchArr)
			
		}
		private function Trim(ostr:String):String 
		{
			return ostr.replace(/([ ]{1})/g,"");
		}
		private function addEvents():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onStage);
			this.addEventListener(ResizeEvent.RESIZE,onStage);
		}
		private function addButs():void
		{
			_btnEnd = new RadiostiyInfoEndBut;
			_btnEnd.label = "确定"
			_btnEnd.height = 30;
			_btnEnd.width = 130;
			_btnEnd.x=0
			_btnEnd.y=0
			this.addChild(_btnEnd)
			_btnEnd.refreshViewValue();
			
			_btnEnd.addEventListener(MouseEvent.CLICK,_btnEndClik)
		}
		public var selectBackFun:Function
		protected function _btnEndClik(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var obj:ExpResFunVo=new ExpResFunVo;
		    if(_tree.selectedItem){
			
				obj.id=_tree.selectedItem.id;
				obj.isUi=this.isUi;
				selectBackFun(obj);
			}else{
				var $str:String=_searchTxt.text
				if($str.length){
					obj.id=$str;
					obj.isUi=this.isUi;
					selectBackFun(obj);
				}
				else{
					if(ExpResModel.getInstance().hasTbData){
						trace("请选取导出的目标")
					}else{
						this.notTbData();
					}
				}
			}
		}
		private var _suffixLabelText:String
		private function notTbData():void
		{
			var $str:String=_searchTxt.text
			if($str.length){
				var obj:Object=new Object;
				obj.id=$str;  //id 
				obj.name=$str;
				obj.info=$str;
				selectBackFun(obj);
			}
		}
		
		
		private var tbComboBox:ComLabelBox
		private function addTbCombobox():void
		{
			this.tbComboBox = new ComLabelBox;
			this.tbComboBox.label = "请选导出表 "
			this.tbComboBox.width = 200;
			this.tbComboBox.x=5
			this.tbComboBox.y=5
			this.tbComboBox.height = 18;
			this.tbComboBox.changFun=changeDrawType
			this.addChild(this.tbComboBox)
			
		}
		
		private var qualityComboBox:ComLabelBox
		public function addQualityComboBox():void
		{
			this.qualityComboBox = new ComLabelBox;
			this.qualityComboBox.label = "导出品质 "
			this.qualityComboBox.width = 200;
			this.qualityComboBox.x=5
			this.qualityComboBox.y=5
			this.qualityComboBox.height = 18;
			this.qualityComboBox.changFun=changeQualityeComboBox
			this.addChild(this.qualityComboBox)
				
			var  $data:Array=new Array();
			$data.push({name:"100%",type:100});
			$data.push({name:"75%",type:75});
			$data.push({name:"50%",type:50});
			$data.push({name:"25%",type:25});
			qualityComboBox.data =$data;
			

			qualityComboBox.selectIndex=1;
			FileSaveModel.expPicQualityType=75;

		}
		private function changeQualityeComboBox(value:Object):void
		{
			FileSaveModel.expPicQualityType=value.type;
			trace(FileSaveModel.expPicQualityType)
		}

		private function changeDrawType(value:Object):void
		{
			var tbName:String=value.name;
			var keyItem:Array;
			if(tbName.indexOf("#")>-1){
				var $ssss: Array = tbName.split("#");
				tbName = $ssss[0];
				keyItem=String($ssss[1]).split(",");
			}
			this.saveLastTimeTabelName(value.name)
		    trace(tbName);
			trace(ExpResModel.getInstance().getTableField(tbName));
			var $nameItem:Vector.<String>;
			var $infoItem:Vector.<String>;
			var $idItem:Vector.<String>=ExpResModel.getInstance().getListByTabelAndfield(tbName,"id");
			FilePathManager.getInstance().setPathByUid("expTbLastName",tbName)
		
			if(keyItem){
				$idItem=new Vector.<String>
				$nameItem=new Vector.<String>
				$infoItem=new Vector.<String>
				if(keyItem[0]){
					$idItem=ExpResModel.getInstance().getListByTabelAndfield(tbName,keyItem[0]);
				}
				if(keyItem[1]){
					$nameItem=ExpResModel.getInstance().getListByTabelAndfield(tbName,keyItem[1]);
				}
				if(keyItem[2]){
					$infoItem=ExpResModel.getInstance().getListByTabelAndfield(tbName,keyItem[2]);
				}
			}
			
			_searchArr=new ArrayCollection;
			for(var i:uint=0;$idItem&&i<$idItem.length;i++){
				var tempObj:Object=new Object;
				tempObj.id=$idItem[i];  //id 
				
				if($nameItem.length){
					tempObj.name=$nameItem[i];
				}else{
					tempObj.name="";
				}
				if($infoItem.length){
					tempObj.info=$infoItem[i];
				}else{
					tempObj.info="";
				}
				_searchArr.addItem(tempObj)
			}

			setDataToList(_searchArr)

		}
		private function setDataToList(value:ArrayCollection):void
		{
			_tree.dataProvider = value;
			_tree.invalidateList();
			_tree.validateNow();
			//	_tree.selectedIndex=0;
		}
		
		private var _searchArr:ArrayCollection
		private var _tree:Tree;
		private var _collisionItem:Array
		private function addList():void
		{
			_tree = new Tree;
			_tree.setStyle("top",30);
			_tree.setStyle("bottom",50);
			_tree.setStyle("left",5);
			_tree.setStyle("right",5);
			_tree.setStyle("contentBackgroundColor",0x505050);
			_tree.setStyle("color",0x9f9f9f);
			_tree.setStyle("borderVisible",false);
			this.addChild(_tree);
			_tree.labelField="id";
			_tree.itemRenderer = new ClassFactory(ExpResTreeRenderer);
			
	
		}
	
		private static var useTabelName:Array=["tb_creature_template","tb_item_template","tb_map"]
		private var tableItem:Array
		private var _btnEnd:RadiostiyInfoEndBut;
		public function initData():void
		{
			ExpResModel.getInstance().initData(function ():void{
				var lastTableName:String=FilePathManager.getInstance().getPathByUid("expTbLastName");
				var $tbListArr:Array=ExpResModel.getInstance().getTablList();
				if(useTabelName.length){
					$tbListArr=useTabelName;
				}
				var $arr:Array=new Array;
				tableItem=new Array;
				var $haveIt:Boolean=false;
				for(var i:uint=0;i<$tbListArr.length;i++){
					var $tempObj:Object=new Object;
					$tempObj.name=$tbListArr[i];
					$tempObj.type=i
					$arr.push($tempObj);
					tableItem.push($tempObj)
					if(lastTableName==$tempObj.name){
						$haveIt=true
					}
				}
				tbComboBox.data =tableItem;

				if(!$haveIt&&$tbListArr.length){
					lastTableName=$tbListArr[0]
					lastTableName=getLastTimeTabel($tbListArr)
				}
				if(lastTableName){
					tbComboBox.selectItem=lastTableName;
					changeDrawType({name:lastTableName})
				}
			})
		}
		private function getLastTimeTabel($tbListArr:Array):String
		{
			//得到最近一次选择的表
			var $returnName:String=$tbListArr[0]
			var expShare:SharedObject = SharedObject.getLocal("expTabel", "/");
			 for(var i:Number=0;i<$tbListArr.length;i++){
			   if($tbListArr[i]==expShare.data.name){
				   $returnName=$tbListArr[i]
			   }
			 }
			 return $returnName
		}

		private function saveLastTimeTabelName(value:String):void
		{
			trace("保存上一次的表名",value);
			var expShare:SharedObject = SharedObject.getLocal("expTabel", "/");
			expShare.data.name=value
		}
	

		private function addBack():void
		{
			_bg = new UIComponent;
			this.addChild(_bg);
		}
		protected function onStage(event:Event):void
		{

			changeSize()
		}
		
		private function drawback():void{
			

			_bg.graphics.clear();
			_bg.graphics.beginFill(0x282828,1);
			_bg.graphics.drawRect(0,0,this.width,this.height);
			_bg.graphics.endFill();
			

			
			var $w:uint=Math.max(300,this.width)
			var $h:uint=Math.max(300,this.height)
			


				

		}
		
		override public function set width(value:Number):void{
			super.width = value;
			drawback();
		}
		
		override public function changeSize():void{
			drawback();

			_btnEnd.y=this.height-40
			_btnEnd.x=this.width-_btnEnd.width-0
				
			var tw:Number=Math.max(this.width-240,100)	
			_searchTxt.x=240
			_searchTxt.width=tw-10;

			
			
			_expUiCheck.y=this.height-40
			_expUiCheck.x=20
				

				
			if(qualityComboBox){
				qualityComboBox.y=this.height-40
				qualityComboBox.x=110
			}

		//	roleTypeComboBox.visible=this.needsuffix;
		}
		override public function show($parent:Sprite):void{
			if(this.parent != $parent){
				$parent.addChild(this);
			}
		}
		
	}
}





