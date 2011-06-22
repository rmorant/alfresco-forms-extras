<#-- JSON-RPC ready ( http://groups.google.es/group/json-rpc/web/json-rpc-1-2-proposal ) -->
{
	"jsonrpc": "2.0"
<#if jsonrpc??>
	,"id" : ${jsonrpc.id!"null"}
</#if>
<#if node??>
	<#if (node?exists)>
	,"result" : {
		 "nodeRef" : "${nodeRef}"
		,"node" : {
			"name" : "${node.name?js_string}"
			,"mimeType" : "${node.mimeType}"
			,"size" : "${node.size}"
			,"thumbnails" : [<#list node.thumbnails as t>"${t}"<#if (t_has_next)>, </#if></#list>]
			,"pluginConditions": ${pluginConditionsJSON}
		}
		,"messages" : ${messages}
	}
	<#else>
    ,"error" : {
    	"code" : 2
    	,"message" : "Node not exist"
    }
	</#if>
<#else>
    ,"error" : {
    	"code" : 1
    	,"message" : "Internal error"
    }
</#if>
}