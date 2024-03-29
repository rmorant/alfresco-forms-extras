EditPreviewFormTemplate for Alfresco Share
================================================

Summary: Document preview while editing meta data.
Author: rmorant@albasoft.com ( www.albasoft.com )

Description 
-------------

new add-on EditPreviewFormTemplate

editpreview-form-template.jar allow document preview while editing meta data. 
Useful for manual metadata registration when the actual document is not available.

The new template only adds a preview button that dynamically loads the flash previewer 
component as needed. 

Installation
------------

The extension has been developed to be installed on top of an existing Alfresco
3.4.d installation.

For Alfresco 3.5 a global config entry is needed
<alfresco-config> 
  <config>
	<formsExtrasVersion>35</formsExtrasVersion>
  </config>
  ...
  
may be in <alfresco_instal>/tomcat/shared/classes/alfresco/web-extension/share-config-custom.xml

An Ant build script is provided to build a JAR file containing the 
custom files, which can then be installed into the 'tomcat/shared/lib' folder 
of your Alfresco installation.

To build the JAR file, run the following command from the base project 
directory.

    ant clean dist-jar

The command should build a JAR file named hello-world-dashlet.jar
in the 'dist' directory within your project.

To deploy the dashlet files into a local Tomcat instance for testing, you can 
use the hotcopy-tomcat-jar task. You will need to set the tomcat.home
property in Ant.

    ant -Dtomcat.home=C:/Alfresco/tomcat clean hotcopy-tomcat-jar
    
Once you have run this you will need to restart Tomcat so that the classpath 
resources in the JAR file are picked up.

Or just drop the jar in <alfresco_instal>/tomcat/shared/lib

Using Forms Extras
-----------------

EditPreviewFormTemplate

Nothing to do, the default edit-form template is changed to :
<forms>
  <form>
	<edit-form template="/com/albasoft/extras/forms/editpreview-form-template.ftl" />
  </form>
</form>

