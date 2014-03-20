var file = Session.Property("ReadMeFile");
var debug = Session.Property("DEBUG");
var sh = new ActiveXObject("WScript.Shell");
var m = file.match(/\..*$/g);
if(m){
    file = "\"" + file + "\"";
	var ext = m[0];
	var ext_key = "HKCR\\" + ext + "\\";
	var prog_id = sh.RegRead(ext_key);

	var prog_id_key = "HKCR\\" + prog_id + "\\shell\\open\\command\\";
	var exe = sh.RegRead(prog_id_key);
	var cmd = exe.replace(/%1/,file);
	if(cmd  == exe) cmd = exe + " " + file;

	if(debug=="1") sh.Popup(cmd);
	sh.Run(cmd);
}else if(debug=="1") sh.Popup("ReadMeFile is wrong:\n" + file);
