use strict;
package main;
print("<form action=\"index.pl\" method=\"post\">\n");
print("<input type=\"hidden\" name=\"action\" value=\"editTextComment\">\n");
my $formula0=$reportNameID;print("<input type=\"hidden\" name=\"reportNameID\" value=\"$formula0\">\n");
my $formula1=$contentID;print("<input type=\"hidden\" name=\"contentID\" value=\"$formula1\">\n");
print("	<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
if ($sessionObj->param("userMessage1") ne "") {
print("		<tr>\n");
my $formula2=$sessionObj->param("userMessage1");print("			<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula2</span></td>\n");
print("		</tr>\n");
print("		<tr>\n");
print("			<td class=\"liteGray\" valign=\"top\" align=\"left\"><img name=\"xallHosts_host1\" src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("		</tr>\n");
$sessionObj->param("userMessage1", "");
 }
print("		<tr>\n");
print("			<td>\n");
print("				<fieldset>	\n");
print("        			<legend align=\"top\">Edit Text Comment</legend>\n");
my $formula3=$textComment;print("					<textarea name=\"textComment\" cols=\"65\" rows=\"7\">$formula3</textarea>\n");
print("				</fieldset>\n");
print("			</td>\n");
print("		</tr>\n");
print("		<td class=\"liteGray\" valign=\"top\" align=\"center\">\n");
print("			<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n");
print("			  <tr>\n");
print("				<td><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"UPDATE\"></td>\n");
print("				<td>&nbsp;</td>\n");
my $formula4=$reportNameID;print("				<td><input class=\"liteButton\" type=\"button\" name=\"clear\" value=\"Go Back\" onclick=\"location='index.pl?reportNameID=$formula4';\"></td>\n");
print("			  </tr>\n");
print("			</table>\n");
print("      </td>\n");
print("	</table>\n");
print("</form>\n");
