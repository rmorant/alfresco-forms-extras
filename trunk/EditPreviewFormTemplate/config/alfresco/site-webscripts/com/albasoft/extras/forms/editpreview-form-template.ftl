<#assign el=args.htmlid?html />
<#if config.global.formsExtrasVersion??>
	<#assign formsExtrasVersion = config.global.formsExtrasVersion.value />
<#else>
	<#assign formsExtrasVersion = "34" />
</#if>
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
      	<#if formsExtrasVersion == "34">
      		<div class="web-preview shadow">
			   <div class="hd" style="display:none;">
			      <div class="title">
			         <h4>
			            <img id="${el}-title-img" src="${url.context}/res/components/images/generic-file-32.png" alt="File" />
			            <span id="${el}-title-span"></span>
			         </h4>
			      </div>
			   </div>
			   <div class="bd">
			      <div id="${el}-shadow-swf-div" class="preview-swf">
			         <div id="${el}-swfPlayerMessage-div"><#if (node?exists)>${msg("label.preparingPreviewer")}</#if></div>
			      </div>
			   </div>
			</div>
      	<#else>
	      	<div id="${el}-body" class="web-preview">
				<div id="${el}-previewer-div" class="previewer">
					<div class="message"><#if (node?exists)>${msg("label.preparingPreviewer")}</#if></div>
				</div>
			</div>
		</#if>
		</div>
      </div>
	</div>

<script type="text/javascript">//<![CDATA[
/** rmorant@albasoft.com (www.albasoft.com) */
(function() {
<#if page.url.args.nodeRef??>

var conf = {
	 htmlid : "${el}"
	,version : "${formsExtrasVersion}"
	,nodeRef : "${page.url.args.nodeRef}"
	,urlContext : "${page.url.context}"
	,onSuccess : function() {
		YAHOO.util.Dom.setStyle("viewBttContainer", "display", "none");
	}
};
var dynamicPreview = new YAHOO.albasoft.DynamicPreview(conf);

var viewButton  = new YAHOO.widget.Button("viewBtt", {
		onclick : { 
			fn : function(e,o) {
				dynamicPreview.jsonCall();
			}
			//, obj : {}
			,scope : dynamicPreview
		}
	});
<#else>	
	YAHOO.util.Dom.setStyle("viewBttContainer", "display", "none");
	YAHOO.util.Dom.setStyle("${el}-preview-div", "display", "none");
</#if>

})();
//]]></script>

