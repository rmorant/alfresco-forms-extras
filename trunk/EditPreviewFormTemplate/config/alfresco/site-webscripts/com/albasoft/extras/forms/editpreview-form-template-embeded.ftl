<#assign el=args.htmlid?html />

	  <#if formUI == "true">
         <@formLib.renderFormsRuntime formId=formId />
      </#if>
	<div class="yui-gd">
	  <div class="yui-u first">
      <@formLib.renderFormContainer formId=formId>
         <#list form.structure as item>
            <#if item.kind == "set">
               <@formLib.renderSet set=item />
            <#else>
               <@formLib.renderField field=form.fields[item.id] />
            </#if>
         </#list>
      </@>
      </div>
      <div class="yui-u">
      	<div id="viewBttContainer" style="position:absolute; left:850px ">
	      	<span id="viewBtt" class="yui-button" title="" >
			    <span class="first-child">
			        <button type="button">${msg("form_preview.lb.preview")}</button>
			    </span>
			</span>
		</div>
      	<div id="${el}-preview-div">
	      	<div id="${el}-body" class="web-preview">
				<div id="${el}-previewer-div" class="previewer">
					<div class="message"><#if (node?exists)>${msg("label.preparingPreviewer")}</#if></div>
				</div>
			</div>
		</div>
      </div>
	</div>

<script type="text/javascript">//<![CDATA[
/** rmorant@albasoft.com (www.albasoft.com) */
(function() {
<#if page.url.args.nodeRef??>
var nr = "${page.url.args.nodeRef}";
<#else>	
var nr = "none";
</#if>

var formDataURL = "${page.url.context}/page/albasoft/components/extras/preview/form-preview.json?nodeRef="+nr;
var urlCSSs = [
	 "${page.url.context}/res/components/preview/web-preview.css"
	,"${page.url.context}/res/components/preview/WebPreviewerHTML.css"
	,"${page.url.context}/res/components/preview/Image.css"
	,"${page.url.context}/res/albasoft/components/forms/form.css"
	];
var urlScripts = [
	 "${page.url.context}/res/components/preview/web-preview.js"
	,"${page.url.context}/res/components/preview/WebPreviewer.js"
	,"${page.url.context}/res/js/flash/extMouseWheel.js"
	,"${page.url.context}/res/components/preview/FlashFox.js"
	,"${page.url.context}/res/components/preview/StrobeMediaPlayback.js"
	,"${page.url.context}/res/components/preview/Video.js"
	,"${page.url.context}/res/components/preview/Flash.js"
	,"${page.url.context}/res/components/preview/Image.js"
	];

	
var formDataSuccess = function(serverResponse) {
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
    	displayError(error);
    } else {
		
		YAHOO.util.Get.script( urlScripts, {
			onProgress : function(o) {
				var mod = o;
			}
			,onSuccess : function() {
				displayPreview(result);
			}
			,onFailure : function(o) {
				alert("Error: "+o);
			}
		});
		YAHOO.util.Get.css(urlCSSs, {
			onSuccess : function() {
				// do nothing	
			}
		});
	}
};

function jsonCall() {
	YAHOO.util.Connect.asyncRequest( 'GET', formDataURL, {
		success : formDataSuccess
		,failure : function(o) {
			displayError({
				code : 0
				,message : "Connect error"
			});
		}
		,argument : {}
	}, null );
}

var viewButton  = new YAHOO.widget.Button("viewBtt", {
		onclick : { 
			fn : function(e,o) {
				jsonCall();
			}
			//, obj : {}
			//,scope : userSession
		}
	});

/* UI */
function displayError(error) {
	alert("ERROR : "+error.code+" ( "+error.message+" )");
}

function displayPreview(o) {
	new Alfresco.WebPreview("${el}").setOptions(
   {
      nodeRef: o.nodeRef,
      name: o.node.name,
      mimeType: o.node.mimeType,
      size: o.node.size,
      thumbnails: o.node.thumbnails,
      pluginConditions: o.node.pluginConditions
   }).setMessages(o.messages);
   
   Alfresco.util.YUILoaderHelper.loadComponents(true);
   YAHOO.util.Dom.setStyle("viewBttContainer", "display", "none");
}
   
})();
//]]></script>

