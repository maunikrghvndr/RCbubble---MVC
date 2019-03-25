﻿
//----------------------------------------------------------------------
// Copyright (c) 1996-2012 Accusoft Corporation.  All rights reserved. 
// </copyright>
//----------------------------------------------------------------------
Type.registerNamespace('ImageGear.Web.UI');ImageGear.Web.regEnum=function(name,flags){for(var i in this.prototype){this[i]=this.prototype[i];}this.__typeName=name;this.__flags=flags;this.__enum=true;};ImageGear.Web.regClass=function(typeName,baseType,interfaceTypes){this.prototype.constructor=this;this.__typeName=typeName;this.__class=true;if(baseType){this.__baseType=baseType;for(var sr in baseType.prototype){var Gn=baseType.prototype[sr];if(!this.prototype[sr]){this.prototype[sr]=Gn;}}}return this;};ImageGear.Web.II=function(vO,wO,zR){if(wO){if(!zR){wO.apply(vO);}else{wO.apply(vO,zR);}}return vO;};ImageGear.Web.UI.DebugErrorLevel=function(){};if(!window.Sys.Component){ImageGear.Web.UI.DebugErrorLevel.registerEnum=ImageGear.Web.regEnum;}ImageGear.Web.UI.DebugErrorLevel.prototype={Production:0,Development:1,Detailed:2};ImageGear.Web.UI.DebugErrorLevel.registerEnum('ImageGear.Web.UI.DebugErrorLevel',false);ImageGear.Web.UI.DebugItemCause=function(){};if(!window.Sys.Component){ImageGear.Web.UI.DebugItemCause.registerEnum=ImageGear.Web.regEnum;}ImageGear.Web.UI.DebugItemCause.prototype={FunctionCall:0,Exception:1,Custom:2,UserAction:3,Warning:4};ImageGear.Web.UI.DebugItemCause.registerEnum('ImageGear.Web.UI.DebugItemCause',false);ImageGear.Web.UI.MouseButton=function(){if(arguments.length!==0)throw new ImageGear.Web.UI.ImGearParameterCountException();throw new ImageGear.Web.UI.ImGearNotImplementedException();};if(!window.Sys.Component){ImageGear.Web.UI.MouseButton.registerEnum=ImageGear.Web.regEnum;}ImageGear.Web.UI.MouseButton.prototype={leftButton:0,middleButton:1,rightButton:2};ImageGear.Web.UI.MouseButton.registerEnum("ImageGear.Web.UI.MouseButton");ImageGear.Web.UI.Key=function(){if(arguments.length!==0)throw new ImageGear.Web.UI.ImGearParameterCountException();throw new ImageGear.Web.UI.ImGearNotImplementedException();};if(!window.Sys.Component){ImageGear.Web.UI.Key.registerEnum=ImageGear.Web.regEnum;}ImageGear.Web.UI.Key.prototype={backspace:8,tab:9,enter:13,esc:27,space:32,pageUp:33,pageDown:34,end:35,home:36,left:37,up:38,right:39,down:40,del:127};ImageGear.Web.UI.Key.registerEnum("ImageGear.Web.UI.Key");ImageGear.Web.UI.dQ=function(BO){var cV=BO;var AR=this.type=cV.type.toLowerCase();this.rawEvent=cV;this.altKey=cV.altKey;if(typeof(cV.button)!=='undefined'){this.button=(typeof(cV.which)!=='undefined')?cV.button:(cV.button===4)?ImageGear.Web.UI.MouseButton.middleButton:(cV.button===2)?ImageGear.Web.UI.MouseButton.rightButton:ImageGear.Web.UI.MouseButton.leftButton;}if(AR==='keypress'){this.charCode=cV.charCode||cV.keyCode;}else if(cV.keyCode&&(cV.keyCode===46)){this.keyCode=127;}else{this.keyCode=cV.keyCode;}this.clientX=cV.clientX;this.clientY=cV.clientY;this.ctrlKey=cV.ctrlKey;this.target=cV.target?cV.target:cV.srcElement;function Di(dP){var dX=0;var eg=0;while(dP&& !isNaN(dP.offsetLeft)&& !isNaN(dP.offsetTop)){dX+=dP.offsetLeft-dP.scrollLeft;eg+=dP.offsetTop-dP.scrollTop;if(dP.offsetparent){dP=dP.offsetParent;}else{dP=dP.parentNode;}}return{top:eg,left:dX};};var jz=new String(AR);var oe='key';if(!(jz.substr(0,oe.length)===oe)){if((typeof(cV.offsetX)!=='undefined')&&(typeof(cV.offsetY)!=='undefined')){this.offsetX=cV.offsetX;this.offsetY=cV.offsetY;}else if(this.target&&(this.target.nodeType!==3)&&(typeof(cV.clientX)==='number')){var xv=Di(this.target);var ar=this.target;var ba=ar.ownerDocument||ar.document||ar;var wJ=ba.defaultView||ba.parentWindow;this.offsetX=(wJ.pageXOffset||0)+cV.clientX-xv.left;this.offsetY=(wJ.pageYOffset||0)+cV.clientY-xv.top;}}this.screenX=cV.screenX;this.screenY=cV.screenY;this.shiftKey=cV.shiftKey;};ImageGear.Web.UI.dQ.prototype={preventDefault:function(){if(arguments.length!==0)throw new ImageGear.Web.UI.ImGearParameterCountException();if(this.rawEvent.preventDefault){this.rawEvent.preventDefault();}else if(window.event){this.rawEvent.returnValue=false;}},stopPropagation:function(){if(arguments.length!==0)throw new ImageGear.Web.UI.ImGearParameterCountException();if(this.rawEvent.stopPropagation){this.rawEvent.stopPropagation();}else if(window.event){this.rawEvent.cancelBubble=true;}}};if(!window.Sys.Component){ImageGear.Web.UI.dQ.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.dQ.registerClass('ImageGear.Web.UI.dQ');ImageGear.tL=function(du,yL){var rR;for(var aT in yL){var qv=yL[aT];var Iv=du["get_"+aT];var yc=du["set_"+aT];if(typeof(yc)==='function'){yc.apply(du,[qv]);}else if(qv instanceof Array){rR=Iv.apply(du);if(!(rR instanceof Array)){throw new new ImageGear.Web.UI.ImGearInvalidOperationException(aT+" is not an Array property");}for(var k=0,aZ=rR.length,tA=qv.length;k<tA;k++,aZ++){rR[aZ]=qv[k];}}}};var cr=ImageGear.Web.UI.dQ.addHandler=function(element,eventName,handler,autoRemove){ImageGear.Web.UI.dQ.qQ(element);if(eventName==="error")throw new ImageGear.Web.UI.ImGearInvalidOperationException(ImageGear.hb.addHandlerCantBeUsedForError);if(!element.aP){element.aP={};}var eventCache=element.aP[eventName];if(!eventCache){element.aP[eventName]=eventCache=[];}var browserHandler;if(element.addEventListener){browserHandler=function(e){return handler.call(element,new ImageGear.Web.UI.dQ(e));};element.addEventListener(eventName,browserHandler,false);}else if(element.attachEvent){browserHandler=function(){var e={};try{var doc=element.ownerDocument||element.document||element;var ar=doc.defaultView||doc.parentWindow;e=ar.event;}catch(ex){}return handler.call(element,new ImageGear.Web.UI.dQ(e));};element.attachEvent('on'+eventName,browserHandler);}eventCache[eventCache.length]={handler:handler,browserHandler:browserHandler,autoRemove:autoRemove};if(autoRemove){var d=element.dispose;if(d!==ImageGear.Web.UI.dQ.zA){element.dispose=ImageGear.Web.UI.dQ.zA;if(typeof(d)!=="undefined"){element.AI=d;}}}};var Kd=ImageGear.Web.UI.dQ.addHandlers=function(element,events,handlerOwner,autoRemove){ImageGear.Web.UI.dQ.qQ(element);for(var name in events){var handler=events[name];if(typeof(handler)!=='function')throw new ImageGear.Web.UI.ImGearInvalidOperationException('Can\'t add a handler that is not a function.');if(handlerOwner){handler=Function.createDelegate(handlerOwner,handler);}cr(element,name,handler,autoRemove||false);}};var ImGearClearHandlers=ImageGear.Web.UI.dQ.clearHandlers=function(element){ImageGear.Web.UI.dQ.qQ(element);ImageGear.Web.UI.dQ.zO(element,false);};ImageGear.Web.UI.dQ.zO=function(element,autoRemoving){if(element.aP){var cache=element.aP;for(var name in cache){var handlers=cache[name];for(var i=handlers.length-1;i>=0;i--){var entry=handlers[i];if(!autoRemoving||entry.autoRemove){ImGearRemoveHandler(element,name,entry.handler);}}}element.aP=null;}};ImageGear.Web.UI.dQ.zA=function(){ImageGear.Web.UI.dQ.zO(this,true);var d=this.AI,type=typeof(d);if(type!=="undefined"){this.dispose=d;this.AI=null;if(type==="function"){this.dispose();}}};var ImGearRemoveHandler=ImageGear.Web.UI.dQ.removeHandler=function(element,eventName,handler){ImageGear.Web.UI.dQ.ax(element,eventName,handler);};ImageGear.Web.UI.dQ.ax=function(element,eventName,handler){ImageGear.Web.UI.dQ.qQ(element);var browserHandler=null;if((typeof(element.aP)!=='object')|| !element.aP)throw new ImageGear.Web.UI.ImGearInvalidOperationException('DOM event handler was not added through the DomEvent.addHandler method.');var cache=element.aP[eventName];if(!(cache instanceof Array))throw new ImageGear.Web.UI.ImGearInvalidOperationException('DOM event handler was not added through the DomEvent.addHandler method.');for(var i=0,l=cache.length;i<l;i++){if(cache[i].handler===handler){browserHandler=cache[i].browserHandler;break;}}if(typeof(browserHandler)!=='function'){throw new ImageGear.Web.UI.ImGearInvalidOperationException('Handler was not added through the ImageGear.Web.UI.dQ.addHandler method.');}if(element.removeEventListener){element.removeEventListener(eventName,browserHandler,false);}else if(element.detachEvent){element.detachEvent('on'+eventName,browserHandler);}cache.splice(i,1);};ImageGear.Web.UI.dQ.qQ=function(element){if(element.tagName&&(element.tagName.toUpperCase()==="SCRIPT"))return;var doc=element.ownerDocument||element.document||element;if((typeof(element.document)!=='object')&&(element!=doc)&&(typeof(element.nodeType)!=='number')){throw new ImageGear.Web.UI.ImGearArgumentException("element",ImageGear.hb.argumentDomNode);}};ImageGear.jh=function(bK){var G=this;this.bK=bK;this.Kq=function(){return G.bK;}};ImageGear.jh.prototype.get_propertyName=function(){return this.bK;};ImageGear.Web.IW=function(dX){return!isNaN(dX-0)&&dX!=null;};ImageGear.HM=function ImageGearIndexOf(array,item,start){if(typeof(item)==="undefined")return-1;var length=array.length;if(length!==0){start=start-0;if(isNaN(start)){start=0;}else{if(isFinite(start)){start=start-(start%1);}if(start<0){start=Math.max(0,length+start);}}for(var i=start;i<length;i++){if((typeof(array[i])!=="undefined")&&(array[i]===item)){return i;}}}return-1;};ImageGear.Web.UI.fh=function fh(){if(arguments.length!==0)throw new ImageGear.Web.UI.ImGearParameterCountException();this.vC={};};ImageGear.Web.UI.fh.prototype.ao=function(dc,O){var pM=this.uM(dc,true);pM[pM.length]=O;};ImageGear.Web.UI.fh.prototype.addHandler=function(dc,O){this.ao(dc,O);};ImageGear.Web.UI.fh.prototype.ax=function(dc,O){var hU=this.uM(dc);if(!hU)return;var by=ImageGear.HM(hU,O);if(by>=0){hU.splice(by,1);}};ImageGear.Web.UI.fh.prototype.removeHandler=function(dc,O){this.ax(dc,O);};ImageGear.Web.UI.fh.prototype.getHandler=function(dc){var hU=this.uM(dc);if(!hU||(hU.length===0))return null;var pM=hU.slice();hU=pM;return function(source,args){for(var k=0,tA=hU.length;k<tA;k++){hU[k](source,args);}};};ImageGear.Web.UI.fh.prototype.uM=function(dc,Et){if(!this.vC[dc]){if(!Et)return null;this.vC[dc]=[];}return this.vC[dc];};ImageGear.Web.Qc=function String$format(qi,io){return ImageGear.Web.Qp(false,arguments);};ImageGear.Web.Qw=function String$localeFormat(qi,io){return ImageGear.Web.Qp(true,arguments);};ImageGear.Web.Qp=function(useLocale,io){var bD='';var qi=io[0];for(var k=0;;){var EN=qi.indexOf('{',k);var rX=qi.indexOf('}',k);if((EN<0)&&(rX<0)){bD+=qi.slice(k);break;}if((rX>0)&&((rX<EN)||(EN<0))){if(qi.charAt(rX+1)!=='}'){throw new ImageGear.Web.UI.ImGearArgumentException('format','The format string contains an unmatched opening or closing brace.');}bD+=qi.slice(k,rX+1);k=rX+2;continue;}bD+=qi.slice(k,EN);k=EN+1;if(qi.charAt(k)==='{'){bD+='{';k++;continue;}if(rX<0){throw new ImageGear.Web.UI.ImGearArgumentException('format','The format string contains an unmatched opening or closing brace.');}var CX=qi.substring(k,rX);var Fo=CX.indexOf(':');var KG=parseInt((Fo<0)?CX:CX.substring(0,Fo),10)+1;if(isNaN(KG)){throw new ImageGear.Web.UI.ImGearArgumentException('format','The format string is invalid.');}var It=(Fo<0)?'':CX.substring(Fo+1);var qW=io[KG];if(typeof(qW)==="undefined"||qW===null){qW='';}if(qW.toFormattedString){bD+=qW.toFormattedString(It);}else if(useLocale&&qW.localeFormat){bD+=qW.Qw(It);}else if(qW.format){bD+=qW.format(It);}else bD+=qW.toString();k=rX+1;}return bD;};ImageGear.hb={'paramName':'Parameter name: {0}','argumentNull':'Value cannot be null.','actualValue':'Actual value was {0}.','argumentOutOfRange':'Specified argument was out of the range of valid values.','argumentTypeWithTypes':'Object of type \'{0}\' cannot be converted to type \'{1}\'.','argumentType':'Object cannot be converted to the required type.','invalidOperation':'Operation is not valid due to the current state of the object.','notImplemented':'The method or operation is not implemented.','argument':'Value does not fall within the expected range.'};ImageGear.Web.UI.ImGearException=function(message,errorInfo){this.message=message;var G=this;if(errorInfo){for(var Kz in errorInfo){G[Kz]=errorInfo[Kz];}}};ImageGear.Web.UI.ImGearException.prototype=new Error();if(!window.Sys.Component){ImageGear.Web.UI.ImGearException.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.ImGearException.registerClass('ImageGear.Web.UI.ImGearException');ImageGear.Web.UI.ImGearHttpException=function(statusCode,message,customErrorCode){var cQ="ImageGear.Web.UI.ImGearHttpException: ";if(message){cQ+=message;}this.message=cQ;this.statusCode=statusCode;this.customErrorCode=customErrorCode;};ImageGear.Web.UI.ImGearHttpException.prototype=new Error();if(!window.Sys.Component){ImageGear.Web.UI.ImGearHttpException.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.ImGearHttpException.registerClass('ImageGear.Web.UI.ImGearHttpException');ImageGear.Web.UI.ImGearArgumentException=function(paramName,message){var cQ="ImageGear.Web.UI.ImGearArgumentException: "+(message?message:ImageGear.hb.argument);if(paramName){if(typeof(paramName)!=="undefined"&&paramName!=null){cQ+="\n"+ImageGear.Web.Qc(ImageGear.hb.paramName,paramName);}}this.message=cQ;this.paramName=paramName;};ImageGear.Web.UI.ImGearArgumentException.prototype=new Error();if(!window.Sys.Component){ImageGear.Web.UI.ImGearArgumentException.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.ImGearArgumentException.registerClass('ImageGear.Web.UI.ImGearArgumentException');ImageGear.Web.UI.ImGearArgumentNullException=function(paramName,message){var cQ="ImageGear.Web.UI.ImGearArgumentNullException: "+(message?message:ImageGear.hb.argumentNull);if(paramName){if(typeof(paramName)!=="undefined"&&paramName!=null){cQ+="\n"+ImageGear.Web.Qc(ImageGear.hb.paramName,paramName);}}this.message=cQ;this.paramName=paramName;};ImageGear.Web.UI.ImGearArgumentNullException.prototype=new Error();if(!window.Sys.Component){ImageGear.Web.UI.ImGearArgumentNullException.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.ImGearArgumentNullException.registerClass('ImageGear.Web.UI.ImGearArgumentNullException');ImageGear.Web.UI.ImGearArgumentOutOfRangeException=function(paramName,actualValue,message){var cQ="ImageGear.Web.UI.ImGearArgumentOutOfRangeException: "+(message?message:ImageGear.hb.argumentOutOfRange);if(paramName){if(typeof(paramName)!=="undefined"&&paramName!=null){cQ+="\n"+ImageGear.Web.Qc(ImageGear.hb.paramName,paramName);}}if(typeof(actualValue)!=="undefined"&&actualValue!==null){cQ+="\n"+ImageGear.Web.Qc(ImageGear.hb.actualValue,actualValue);}this.message=cQ;this.paramName=paramName;this.actualValue=actualValue;};ImageGear.Web.UI.ImGearArgumentOutOfRangeException.prototype=new Error();if(!window.Sys.Component){ImageGear.Web.UI.ImGearArgumentOutOfRangeException.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.ImGearArgumentOutOfRangeException.registerClass('ImageGear.Web.UI.ImGearArgumentOutOfRangeException');ImageGear.Web.UI.ImGearArgumentTypeException=function(paramName,actualType,expectedType,message){var cQ="ImageGear.Web.UI.ImGearArgumentTypeException ";if(message){cQ+=message;}else if(actualType&&expectedType){if(typeof(actualType.getName)=='function'&&typeof(expectedType.getName)=='function'){cQ+=ImageGear.Web.Qc(ImageGear.hb.argumentTypeWithTypes,actualType.getName(),expectedType.getName());}else{cQ+="actualType = "+actualType+" expectedType =  "+expectedType;}}else{cQ+=ImageGear.hb.argumentType;}if(paramName){if(typeof(paramName)!=="undefined"&&paramName!=null){cQ+="\n"+ImageGear.Web.Qc(ImageGear.hb.paramName,paramName);}}this.message=cQ;this.paramName=paramName;this.actualValue=actualValue;this.expectedType=expectedType;};ImageGear.Web.UI.ImGearArgumentTypeException.prototype=new Error();if(!window.Sys.Component){ImageGear.Web.UI.ImGearArgumentTypeException.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.ImGearArgumentTypeException.registerClass('ImageGear.Web.UI.ImGearArgumentTypeException');ImageGear.Web.UI.ImGearArgumentUndefinedException=function(paramName,message){var cQ="ImageGear.Web.UI.ImGearArgumentUndefinedException: "+(message?message:ImageGear.hb.argumentUndefined);if(paramName){if(typeof(paramName)!=="undefined"&&paramName!=null){cQ+="\n"+ImageGear.Web.Qc(ImageGear.hb.paramName,paramName);}}this.message=cQ;this.paramName=paramName;};ImageGear.Web.UI.ImGearArgumentUndefinedException.prototype=new Error();if(!window.Sys.Component){ImageGear.Web.UI.ImGearArgumentUndefinedException.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.ImGearArgumentUndefinedException.registerClass('ImageGear.Web.UI.ImGearArgumentUndefinedException');ImageGear.Web.UI.ImGearInvalidOperationException=function(message){var cQ="ImageGear.Web.UI.ImGearInvalidOperationException: "+(message?message:ImageGear.hb.invalidOperation);this.message=cQ;};ImageGear.Web.UI.ImGearInvalidOperationException.protype=new Error();if(!window.Sys.Component){ImageGear.Web.UI.ImGearInvalidOperationException.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.ImGearInvalidOperationException.registerClass('ImageGear.Web.UI.ImGearInvalidOperationException');ImageGear.Web.UI.ImGearNotImplementedException=function(message){var cQ="ImageGear.Web.UI.ImGearNotImplementedException: "+(message?message:ImageGear.hb.notImplemented);this.message=cQ;};ImageGear.Web.UI.ImGearNotImplementedException.prototype=new Error();if(!window.Sys.Component){ImageGear.Web.UI.ImGearNotImplementedException.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.ImGearNotImplementedException.registerClass('ImageGear.Web.UI.ImGearNotImplementedException');ImageGear.Web.UI.ImGearParameterCountException=function(message){var cQ="ImageGear.Web.UI.ImGearParameterCountException: "+(message?message:ImageGear.hb.parameterCount);this.message=cQ;};ImageGear.Web.UI.ImGearParameterCountException.prootype=new Error();if(!window.Sys.Component){ImageGear.Web.UI.ImGearParameterCountException.registerClass=ImageGear.Web.regClass;}ImageGear.Web.UI.ImGearParameterCountException.registerClass('ImageGear.Web.UI.ImGearParameterCountException');ImageGear.aG=ImageGear.aG||{};ImageGear.aG.rw=ImageGear.aG.rw||function(cw,Gv){if(cw==="")cw='""';try{var zg=cw.replace(new RegExp('(^|[^\\\\])\\"\\\\/Date\\((-?[0-9]+)(?:[a-zA-Z]|(?:\\+|-)[0-9]{4})?\\)\\\\/\\"','g'),"$1new Date($2)");var FC=new RegExp('[^,:{}\\[\\]0-9.\\-+Eaeflnr-u \\n\\r\\t]','g');var Fj=new RegExp('"(\\\\.|[^"\\\\])*"','g');if(Gv&&FC.test(zg.replace(Fj,'')))throw null;return eval('('+zg+')');}catch(e){throw new ImageGear.Web.UI.ImGearArgumentException('str','Cannot deserialize. The data does not correspond to valid JSON.');}};ImageGear.cg={};ImageGear.cg.InternetExplorer={};ImageGear.cg.Firefox={};ImageGear.cg.Safari={};ImageGear.cg.Opera={};ImageGear.cg.agent=null;ImageGear.cg.hasDebuggerStatement=false;ImageGear.cg.name=navigator.appName;ImageGear.cg.version=parseFloat(navigator.appVersion);ImageGear.cg.documentMode=0;if(navigator.userAgent.indexOf(' MSIE ')> -1){ImageGear.cg.agent=ImageGear.cg.InternetExplorer;ImageGear.cg.version=parseFloat(navigator.userAgent.match(/MSIE (\d+\.\d+)/)[1]);if(ImageGear.cg.version>=8){if(document.documentMode>=7){ImageGear.cg.documentMode=document.documentMode;}}ImageGear.cg.hasDebuggerStatement=true;}else if(navigator.userAgent.indexOf(' Firefox/')> -1){ImageGear.cg.agent=ImageGear.cg.Firefox;ImageGear.cg.version=parseFloat(navigator.userAgent.match(/ Firefox\/(\d+\.\d+)/)[1]);ImageGear.cg.name='Firefox';ImageGear.cg.hasDebuggerStatement=true;}else if(navigator.userAgent.indexOf(' AppleWebKit/')> -1){ImageGear.cg.agent=ImageGear.cg.Safari;ImageGear.cg.version=parseFloat(navigator.userAgent.match(/ AppleWebKit\/(\d+(\.\d+)?)/)[1]);ImageGear.cg.name='Safari';}else if(navigator.userAgent.indexOf('Opera/')> -1){ImageGear.cg.agent=ImageGear.cg.Opera;}ImageGear.lX=function(sj){this.kA=(typeof(sj)!=='undefined'&&sj!==null&&sj!=='')?[sj.toString()]:[];this.h={};this.cC=0;};ImageGear.lX.prototype.eD=function(az){this.kA[this.kA.length]=az;};ImageGear.lX.prototype.Ja=function(az){this.kA[this.kA.length]=((typeof(az)==='undefined')||(az===null)||(az===''))?'\r\n':az+'\r\n';};ImageGear.lX.prototype.Jp=function(){this.kA=[];this.h={};this.cC=0;};ImageGear.lX.prototype.JD=function(){if(this.kA.length===0)return true;return this.toString()==='';};ImageGear.lX.prototype.Bo=function(lk){lk=lk||'';var parts=this.kA;if(this.cC!==parts.length){this.h={};this.cC=parts.length;}var val=this.h;if(typeof(val[lk])==='undefined'){if(lk!==''){for(var i=0;i<parts.length;){if((typeof(parts[i])==='undefined')||(parts[i]==='')||(parts[i]===null)){parts.splice(i,1);}else{i++;}}}val[lk]=this.kA.join(lk);}return val[lk];};ImageGear.aG.rh=[];ImageGear.aG.oY=[];ImageGear.aG.Jw=new RegExp('(^|[^\\\\])\\"\\\\/Date\\((-?[0-9]+)(?:[a-zA-Z]|(?:\\+|-)[0-9]{4})?\\)\\\\/\\"','g');ImageGear.aG.nl={};ImageGear.aG.Dz=new RegExp('["\\\\\\x00-\\x1F]','i');ImageGear.aG.Ei=new RegExp('["\\\\\\x00-\\x1F]','g');ImageGear.aG.JO=new RegExp('[^,:{}\\[\\]0-9.\\-+Eaeflnr-u \\n\\r\\t]','g');ImageGear.aG.Kb=new RegExp('"(\\\\.|[^"\\\\])*"','g');ImageGear.aG.JL='__type';ImageGear.aG.HW=function(){var replaceChars=['\\u0000','\\u0001','\\u0002','\\u0003','\\u0004','\\u0005','\\u0006','\\u0007','\\b','\\t','\\n','\\u000b','\\f','\\r','\\u000e','\\u000f','\\u0010','\\u0011','\\u0012','\\u0013','\\u0014','\\u0015','\\u0016','\\u0017','\\u0018','\\u0019','\\u001a','\\u001b','\\u001c','\\u001d','\\u001e','\\u001f'];ImageGear.aG.oY[0]='\\';ImageGear.aG.rh['\\']=new RegExp('\\\\','g');ImageGear.aG.nl['\\']='\\\\';ImageGear.aG.oY[1]='"';ImageGear.aG.rh['"']=new RegExp('"','g');ImageGear.aG.nl['"']='\\"';for(var i=0;i<32;i++){var c=String.fromCharCode(i);ImageGear.aG.oY[i+2]=c;ImageGear.aG.rh[c]=new RegExp(c,'g');ImageGear.aG.nl[c]=replaceChars[i];}};ImageGear.aG.wU=function(object,dE){dE.eD(object.toString());};ImageGear.aG.vI=function(object,dE){if(isFinite(object)){dE.eD(String(object));}else{throw new ImageGear.Web.UI.ImGearInvalidOperationException('Cannot serialize non finite numbers.');}};ImageGear.aG.vj=function(string,dE){dE.eD('"');if(ImageGear.aG.Dz.test(string)){if(ImageGear.aG.oY.length===0){ImageGear.aG.HW();}if(string.length<128){string=string.replace(ImageGear.aG.Ei,function(x){return ImageGear.aG.nl[x];});}else{for(var i=0;i<34;i++){var c=ImageGear.aG.oY[i];if(string.indexOf(c)!== -1){if(ImageGear.cg.agent===ImageGear.cg.Opera||ImageGear.cg.agent===ImageGear.cg.FireFox){string=string.split(c).join(ImageGear.aG.nl[c]);}else{string=string.replace(ImageGear.aG.rh[c],ImageGear.aG.nl[c]);}}}}}dE.eD(string);dE.eD('"');};ImageGear.aG.sS=function(object,dE,sort,prevObjects){var i;switch(typeof object){case 'object':if(object){if(prevObjects){for(var j=0;j<prevObjects.length;j++){if(prevObjects[j]===object){throw new ImageGear.Web.UI.ImGearInvalidOperationException('Cannot serialize object with cyclic reference within child properties.');}}}else{prevObjects=new Array();}try{prevObjects[prevObjects.length]=object;if(typeof(object)=="number"){ImageGear.aG.vI(object,dE);}else if(typeof(object)=="boolean"){ImageGear.aG.wU(object,dE);}else if(typeof(object)=="string"){ImageGear.aG.vj(object,dE);}else if(object instanceof Array){dE.eD('[');for(i=0;i<object.length;++i){if(i>0){dE.eD(',');}ImageGear.aG.sS(object[i],dE,false,prevObjects);}dE.eD(']');}else{var properties=[];var propertyCount=0;for(var name in object){var jz=new String(name);var oe='$';if((jz.substr(0,oe.length)===oe)){continue;}if(name===ImageGear.aG.JL&&propertyCount!==0){properties[propertyCount++]=properties[0];properties[0]=name;}else{properties[propertyCount++]=name;}}if(sort)properties.sort();dE.eD('{');var needComma=false;for(i=0;i<propertyCount;i++){var value=object[properties[i]];if(typeof value!=='undefined'&&typeof value!=='function'){if(needComma){dE.eD(',');}else{needComma=true;}ImageGear.aG.sS(properties[i],dE,sort,prevObjects);dE.eD(':');ImageGear.aG.sS(value,dE,sort,prevObjects);}}dE.eD('}');}}finally{prevObjects.splice(prevObjects.length-1);}}else{dE.eD('null');}break;case 'number':ImageGear.aG.vI(object,dE);break;case 'string':ImageGear.aG.vj(object,dE);break;case 'boolean':ImageGear.aG.wU(object,dE);break;default:dE.eD('null');break;}};ImageGear.aG.yw=ImageGear.aG.yw||function(object){var dE=new ImageGear.lX();ImageGear.aG.sS(object,dE,false);return dE.Bo();};ImageGear.bO={bB:function(h,aT,bB){if(typeof(h)!==bB){throw new ImageGear.Web.UI.ImGearArgumentTypeException(aT,typeof(h),bB,"Invalid Type was found");}},iZ:function(h,aT){ImageGear.bO.bB(h,aT,'string');},ea:function(h,aT){ImageGear.bO.bB(h,aT,'number');if(!isFinite(h)){throw new ImageGear.Web.UI.ImGearArgumentOutOfRangeException(aT,h,'The value must be a number.');}},hc:function(h,aT,ld,kO){ImageGear.bO.bB(h,aT,'number');if(h<ld||h>kO|| !isFinite(h)){throw new ImageGear.Web.UI.ImGearArgumentOutOfRangeException(aT,h,'The value must be a number between '+ld+' and '+kO+' inclusive.');}},Ab:function(h,aT,oh){ImageGear.bO.bB(h,aT,'number');var k;for(k=0;k<oh.length;k++){if(h===oh[k]){return;}}var rn='';for(k=0;k<oh.length;k++){if(k>0){if(k===oh.length-1){rn+=' or ';}else{rn+=', ';}}rn+=oh[k];}throw new ImageGear.Web.UI.ImGearArgumentOutOfRangeException(aT,h,'The value must be '+rn+'.');},yE:function(h,aT,ld,kO){ImageGear.bO.hc(h,aT,ld,kO);if(h!==Math.floor(h)){throw new ImageGear.Web.UI.ImGearArgumentException(aT,'The value must be an integer.');}},qD:function(h,aT){ImageGear.bO.bB(h,aT,'string');if(!h.match(/#[0-9A-Fa-f]{6}/)){throw new ImageGear.Web.UI.ImGearArgumentException(aT,'Colors must be strings that begin with a # symbol, followed by 6 hexadecimal digits.');}},cX:function(h,aT,cX,yV){ImageGear.bO.bB(h,aT,'number');var bK;var uJ=0;for(bK in cX){if(cX.hasOwnProperty(bK)){if(yV){uJ|=cX[bK];}else{if(h===cX[bK]){return;}}}}var cw="";if(yV){if((h|uJ)===uJ){return;}else{if(window.Sys.Component){cw=cX.getName();}throw new ImageGear.Web.UI.ImGearArgumentOutOfRangeException(aT,h,'The value must be zero or more members of the '+cw+' enumeration.');}}throw new ImageGear.Web.UI.ImGearArgumentOutOfRangeException(aT,h,'The value must be a member of the '+cw+' enumeration.');},aw:function(h,aT){ImageGear.bO.ea(h.x,aT+'.x');ImageGear.bO.ea(h.y,aT+'.y');},L:function(h,aT){ImageGear.bO.ea(h.x,aT+'.x');ImageGear.bO.ea(h.y,aT+'.y');ImageGear.bO.ea(h.width,aT+'.width');ImageGear.bO.ea(h.height,aT+'.height');}};ImageGear.ds={fE:function(jk,pJ){var bB,cw,cf;if(jk===null){return 'null';}if(!pJ){pJ=0;}bB=typeof(jk);if(bB==='undefined'){return 'undefined';}else if(bB==='number'||bB==='boolean'){return jk.toString();}else if(bB==='string'){return '\''+jk+'\'';}else if(bB==='function'){return 'function';}else{if(pJ<0){return 'jk';}cw='{';for(cf in jk){if(jk.hasOwnProperty(cf)){if(cw.length>2){cw+=', ';}cw+=cf;cw+=': ';cw+=ImageGear.ds.fE(jk[cf],pJ-1);}}cw+='}';return cw;}},sM:function(az){var traceElement=document.getElementById('TraceConsole');if(traceElement&&(traceElement.tagName.toUpperCase()==='TEXTAREA')){traceElement.value+=az+'\n';}},Ku:function(){var traceElement=document.getElementById('TraceConsole');if(traceElement&&(traceElement.tagName.toUpperCase()==='TEXTAREA')){traceElement.value='';}},fe:function(cZ,mR,bA,mr,jY){var az="ImageGear - ";az+=(mr)?mr:" ";az+=" parent Div id = ";az+=(jY)?jY:" ";if(window.Sys.Component){az+=" - "+ImageGear.Web.UI.DebugItemCause.toString(mR);}else{if(mR){switch(mR){case 0:az+=" FunctionCall ";break;case 1:az+=" Exception ";break;case 2:az+=" Custom ";break;case 3:az+=" UserAction ";break;case 4:az+=" Warning ";break;default:az+=" unknown ";}}}az+=" - "+cZ;if((typeof(Debug)!=='undefined')&&Debug.writeln){Debug.writeln(az);}if(window.console&&window.console.log){window.console.log(az);}if(window.opera){window.opera.postError(az);}if(window.debugService){window.debugService.trace(az);}var traceElement=document.getElementById('TraceConsole');if(traceElement&&(traceElement.tagName.toUpperCase()==='TEXTAREA')){traceElement.value+=az+'\n';}try{var wI=onImageGearItemLogged;}catch(ex){}if(wI&&(typeof(wI)).toLowerCase()==='function'){var io=new ImageGear.Web.UI.LogItemEventArgs();io.message=cZ;io.cause=mR;io.level=bA;io.id=jY;wI(io);}}}; 