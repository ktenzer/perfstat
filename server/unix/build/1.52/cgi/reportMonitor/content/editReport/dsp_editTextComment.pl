use strict;
package main;
print("<form action=\"index.pl\" method=\"post\">
print("<input type=\"hidden\" name=\"action\" value=\"editTextComment\">
my $formula0=$reportNameID;print("<input type=\"hidden\" name=\"reportNameID\" value=\"$formula0\">
my $formula1=$contentID;print("<input type=\"hidden\" name=\"contentID\" value=\"$formula1\">
print("	<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">
if ($sessionObj->param("userMessage1") ne "") {
print("		<tr>
my $formula2=$sessionObj->param("userMessage1");print("			<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula2</span></td>
print("		</tr>
print("		<tr>
print("			<td class=\"liteGray\" valign=\"top\" align=\"left\"><img name=\"xallHosts_host1\" src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>
print("		</tr>
$sessionObj->param("userMessage1", "");
 }
print("		<tr>
print("			<td>
print("				<fieldset>	
print("        			<legend align=\"top\">Edit Text Comment</legend>
my $formula3=$textComment;print("					<textarea name=\"textComment\" cols=\"65\" rows=\"7\">$formula3</textarea>
print("				</fieldset>
print("			</td>
print("		</tr>
print("		<td class=\"liteGray\" valign=\"top\" align=\"center\">
print("			<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
print("			  <tr>
print("				<td><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"UPDATE\"></td>
print("				<td>&nbsp;</td>
my $formula4=$reportNameID;print("				<td><input class=\"liteButton\" type=\"button\" name=\"clear\" value=\"Go Back\" onclick=\"location='index.pl?reportNameID=$formula4';\"></td>
print("			  </tr>
print("			</table>
print("      </td>
print("	</table>
print("</form>\n");