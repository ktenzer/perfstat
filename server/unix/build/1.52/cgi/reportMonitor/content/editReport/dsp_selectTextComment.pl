use strict;
package main;
print("<form action=\"index.pl\" method=\"post\">\n");
print("<input type=\"hidden\" name=\"action\" value=\"insertTextComment\">\n");
my $formula0=$reportNameID;print("<input type=\"hidden\" name=\"reportNameID\" value=\"$formula0\">\n");
print("	<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n");
if ($sessionObj->param("userMessage1") ne "") {
print("		<tr>\n");
my $formula1=$sessionObj->param("userMessage1");print("			<td class=\"liteGray\" valign=\"top\" align=\"left\"><span class=\"userMessage\">$formula1</span></td>\n");
print("		</tr>\n");
print("		<tr>\n");
print("			<td class=\"liteGray\" valign=\"top\" align=\"left\"><img name=\"xallHosts_host1\" src=\"../../../perfStatResources/images/common/spacer.gif\" border=\"0\" width=\"9\" height=\"9\"></td>\n");
print("		</tr>\n");
$sessionObj->param("userMessage1", "");
 }
print("		<tr>\n");
print("			<td>\n");
print("				<fieldset>	\n");
print("        			<legend align=\"top\">Add Text Comment</legend>\n");
print("					<textarea name=\"textComment\" cols=\"65\" rows=\"7\"></textarea>\n");
print("				</fieldset>\n");
print("			</td>\n");
print("		</tr>\n");
print("		<td class=\"liteGray\" valign=\"top\" align=\"center\"><input class=\"liteButton\" type=\"submit\" name=\"Update\" value=\"ADD\"></td>\n");
print("	</table>\n");
print("</form>\n");
