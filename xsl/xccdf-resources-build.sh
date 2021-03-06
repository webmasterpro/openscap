# A horrible little script that builds and minifies CSS and JS we bundle with HTML report and guide

ALL_CSS=`mktemp`
ALL_CSS_MIN=`mktemp`
ALL_JS=`mktemp`
ALL_JS_MIN=`mktemp`

echo "" > $ALL_CSS
cat xccdf-resources/jquery.treetable.css >> $ALL_CSS
cat xccdf-resources/jquery.treetable.theme.css >> $ALL_CSS
cat xccdf-resources/openscap.css >> $ALL_CSS
csstidy $ALL_CSS --template=highest $ALL_CSS_MIN
rm $ALL_CSS
echo "" > $ALL_JS
cat xccdf-resources/jquery.treetable.js >> $ALL_JS
cat xccdf-resources/bootstrap.min.js >> $ALL_JS
cat xccdf-resources/openscap.js >> $ALL_JS
slimit $ALL_JS > $ALL_JS_MIN
rm $ALL_JS

XCCDF_RESOURCES="xccdf-resources.xsl"

echo "<?xml version=\"1.0\" encoding=\"utf-8\" ?>" > $XCCDF_RESOURCES
echo "<!-- This file was autogenerated! See the xccdf-resources/ folder! -->" >> $XCCDF_RESOURCES

echo "<xsl:stylesheet version=\"1.1\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">" >> $XCCDF_RESOURCES
echo "<xsl:template name=\"css-sources\"><![CDATA[" >> $XCCDF_RESOURCES
# bootstrap.min.css can't be minified further without breaking behavior
cat xccdf-resources/bootstrap.min.css >> $XCCDF_RESOURCES
cat $ALL_CSS_MIN >> $XCCDF_RESOURCES
echo "]]></xsl:template>" >> $XCCDF_RESOURCES
echo "<xsl:template name=\"js-sources\"><![CDATA[" >> $XCCDF_RESOURCES
# jquery.min.js can't be minified further without breaking behavior
cat xccdf-resources/jquery.min.js >> $XCCDF_RESOURCES
cat $ALL_JS_MIN >> $XCCDF_RESOURCES
echo "]]></xsl:template>" >> $XCCDF_RESOURCES

echo "</xsl:stylesheet>" >> $XCCDF_RESOURCES

rm $ALL_CSS_MIN
rm $ALL_JS_MIN
