use strict;
package main;
print("<form action=\"index.pl\" method=\"post\">
print("<input type=\"hidden\" name=\"action\" value=\"insertTextComment\">
my $formula0=$reportNameID;print("<input type=\"hidden\" name=\"reportNameID\" value=\"$formula0\">
print("	<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
if ($sessionObj->param("userMessage1") ne "") {
print("		<tr>
my $formula1=$sessionObj->param("userMessage1");print("			<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula1</span></td>
print("		</tr>
print("		<tr>
print("			<td class=\"liteGray\" valign=\"top\" align=\"left\"><img name=\"xallHosts_host1\" src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>
print("		</tr>
$sessionObj->param("userMessage1", "");
 }
print("		<tr>
print("			<td>
print("				<fieldset>	
print("        			<legend align=\"top\">Add Text Comment</legend>
print("					<textarea name=\"textComment\" cols=\"65\" rows=\"7\"></textarea>
print("				</fieldset>
print("			</td>
print("		</tr>
print("		<td class=\"liteGray\" valign=\"top\" align=\"center\"><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"ADD\"></td>
print("	</table>
print("</form>\n");