/**
 * Copyright (C) 20010-2011 Alfresco Share Extras project
 *
 * This file is part of the Alfresco Share Extras project.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * DynamicPreview from EditPreviewFormTemplate add-on 
 * 
 * The new EditPreviewFormTemplate template only adds a preview button that 
 * dynamically loads the flash previewer component as needed.
 * 
 * @author: rmorant@albasoft.com ( www.albasoft.com )
 * @class YAHOO.albasoft.DynamicPreview
 */
(function() {
var DEF_VERSION = "34";
var CSS_URLS_34 = [
	 "/components/preview/web-preview.css"
	,"/albasoft/components/forms/form.css"               
	];
var CSS_URLS_35 = [
	 "/components/preview/web-preview.css"
	,"/components/preview/WebPreviewerHTML.css"
	,"/components/preview/Image.css"
	,"/albasoft/components/forms/form.css"
	];
var SCRIPT_URLS_34 = [
      "/components/preview/web-preview.js"
  	,"/js/flash/extMouseWheel.js"
  	];                      
var SCRIPT_URLS_35 = [
	 "/components/preview/web-preview.js"
	,"/components/preview/WebPreviewer.js"
	,"/js/flash/extMouseWheel.js"
	,"/components/preview/FlashFox.js"
	,"/components/preview/StrobeMediaPlayback.js"
	,"/components/preview/Video.js"
	,"/components/preview/Flash.js"
	,"/components/preview/Image.js"
	];

var DynamicPreview = function(conf) {
	this.htmlid = conf.htmlid;
	this.alfVersion = conf.version || DEF_VERSION;
	this.nodeRef = conf.nodeRef;
	this.urlContext = conf.urlContext;
	this.onSuccess = conf.onSuccess || this._onSuccess;
	this.onFailure = conf.onFailure || this._onFailure;
};

DynamicPreview.prototype = {
	 name : "DynamicPreview"
	,getFormDataURL : function() {
		return this.urlContext+"/page/albasoft/components/extras/preview/form-preview-"+this.alfVersion+".json?nodeRef="+this.nodeRef;
	}
	,contextualize : function(a) {
		var ret = [];
		for (var i in a) {
			ret.push(this.urlContext+"/res"+a[i]);
		}
		return ret;
	}
	,jsonCall : function() {
		var me = this;
		var successFn = function(serverResponse) {
			var result = serverResponse.responseText;
		    var error = null;
			try {
				var json = YAHOO.lang.JSON.parse(serverResponse.responseText);
		    	if (json.jsonrpc) {
		    		if (json.error) {
		    			error = json.error; 
		    		} else {
		    			result = json.result || {};
		    		} 
		    	} else {
		    		result = json;
		    	}
		    } catch (e) {
		    	error = {
		    		 code : -32700
		    		,message : "parse error."+ e
		    		,data : { 
		    			"responseText" : serverResponse.responseText
		    		}
		    	};
		    }
		    if (error) {
		    	me.onFailure(error);
		    } else {
				var scripts = (me.alfVersion == "34" ?  me.contextualize(SCRIPT_URLS_34) : me.contextualize(SCRIPT_URLS_35) );
				var csss = (me.alfVersion == "34" ?  me.contextualize(CSS_URLS_34) : me.contextualize(CSS_URLS_35) );
				YAHOO.util.Get.script( scripts, {
					onProgress : function(o) {
						// do nothing
					}
					,onSuccess : function() {
						me.displayPreview(result);
					}
					,onFailure : function(o) {
						alert("Error: "+o);
					}
				});
				YAHOO.util.Get.css( csss , {
					onSuccess : function() {
						// do nothing	
					}
				});
			}
		}
		
		YAHOO.util.Connect.asyncRequest( 'GET', this.getFormDataURL(), {
			success : successFn //this.formDataSuccess
			,failure : function(o) {
				this.onFailure({
					code : 0
					,message : "Connect error"
				});
			}
			,argument : {}
		}, null );
	}
	,formDataSuccess : function(serverResponse) {
		var result = serverResponse.responseText;
	    var error = null;
		try {
			var json = YAHOO.lang.JSON.parse(serverResponse.responseText);
	    	if (json.jsonrpc) {
	    		if (json.error) {
	    			error = json.error; 
	    		} else {
	    			result = json.result || {};
	    		} 
	    	} else {
	    		result = json;
	    	}
	    } catch (e) {
	    	error = {
	    		 code : -32700
	    		,message : "parse error."+ e
	    		,data : { 
	    			"responseText" : serverResponse.responseText
	    		}
	    	};
	    }
	    if (error) {
	    	this.onFailure(error);
	    } else {
			var scripts = (this.alfVersion == "34" ?  this.contextualize(SCRIPT_URLS_34) : this.contextualize(SCRIPT_URLS_35) );
			var csss = (this.alfVersion == "34" ?  this.contextualize(CSS_URLS_34) : this.contextualize(CSS_URLS_35) );
			YAHOO.util.Get.script( scripts, {
				onProgress : function(o) {
					// do nothing
				}
				,onSuccess : function() {
					this.displayPreview(result);
				}
				,onFailure : function(o) {
					alert("Error: "+o);
				}
			});
			YAHOO.util.Get.css( csss , {
				onSuccess : function() {
					// do nothing	
				}
			});
		}
	}
	

	,displayPreview : function(o) {
		var opts = {};
		if (this.alfVersion == "34") {
			// share 3.4
			opts = {
			      nodeRef: o.nodeRef,
			      name: o.node.name,
			      icon : o.node.icon,
			      mimeType: o.node.mimeType,
			      previews : o.node.previews,
			      size: o.node.size,
			      disableI18nInputFix: o.disableI18nInputFix
			 };
		} else {
			// share 3.5
		   opts = {
		      nodeRef: o.nodeRef,
		      name: o.node.name,
		      mimeType: o.node.mimeType,
		      size: o.node.size,
		      thumbnails: o.node.thumbnails,
		      pluginConditions: o.node.pluginConditions
		   };
		}
		new Alfresco.WebPreview(this.htmlid).setOptions(opts).setMessages(o.messages);
	    Alfresco.util.YUILoaderHelper.loadComponents(true);
	    this.onSuccess();
	}
	,_onSuccess : function() {
		YAHOO.util.Dom.setStyle("viewBttContainer", "display", "none");
	}
	,_onFailure : function(error) {
		alert("ERROR : "+error.code+" ( "+error.message+" )");
	}
}; // end prototype
YAHOO.namespace("albasoft");
YAHOO.albasoft.DynamicPreview = DynamicPreview;
})();