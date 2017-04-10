// afx で新規ファイル作成用コマンド
// wscript $~\script\MakeNewFile.js $P


// この jsファイルがあるフォルダを返す。
function GetCurrentFolder()
{
	var pathLength = WScript.ScriptFullName.length - WScript.ScriptName.length;
	var currentFolder = WScript.ScriptFullName.substr(0,pathLength);
	return currentFolder;
}


// InputBox表示
function InputBox(strMsg, title, strDefault) {
	var script = new ActiveXObject('ScriptControl');
	script.Language = 'VBScript';
	script.AddCode('Function IB(p,t,d)\n IB=InputBox(p,t,d)\n End Function');
	return script.Run('IB', strMsg, title, strDefault);
}

// 各種タグを変換
function ReplaceTags( template, filename )
{
	var _path = filename.replace( /\\/g, "/" );
	var _file = _path.replace( /.*\/(.*)/, "$1" );
	var _fname="";
	var _ext  ="";
	if( _file.match( /(.*)\.(.*)/, "$1" ) )
	{
		_fname = RegExp.$1;
		_ext   = RegExp.$2;
	}
	else
	{
		_fname = _file;
	}
	
	// Date型を文字列に変換
	var d = new Date();
	function s2(n){ return (n<10?"0":"")+n; }
	var dd = ["日","月","火","水","木","金","土"];
	var _date = d.getFullYear() + "/" + s2(d.getMonth() + 1) + "/" + s2(d.getDate()) + "(" + dd[ d.getDay() ] + ")";
	var _time = s2(d.getHours()) + ":" + s2(d.getMinutes()) + ":" + s2(d.getSeconds());
	var _date_time = _date + " " + _time

    var net = new ActiveXObject("WScript.Network");
	var _userName = net.UserName;
	
	function _capitalize(str)
	{
		return str.substring(0,1).toUpperCase() + str.substring(1);
	}
	function _replace( src, tag, str )
	{
		_re = new RegExp("");
		
		_tag = _capitalize( tag );
		_str = _capitalize( str );
		_re.compile("%"+_tag+"%", "g");			// %File% タグが1文字目のみ大文字, str をcapitalizeする
		src  =	src.replace( _re,  _str );
		
		_tag = tag.toUpperCase();
		_str = str.toUpperCase();
		_re.compile("%"+_tag+"%", "g");			// %FILE% タグが全部大文字 str を 全部大文字で置換
		src  =	src.replace( _re,  _str );

		_re.compile("%"+tag+"%", "ig");			// %file% そのた、　そのまま置換
		src  =	src.replace( _re,  str );
		return src;
	}

	template  =	_replace( template, "file",  _file );		// ファイル名  %fname%.%ext%
	template  =	_replace( template, "fname", _fname );		// ファイル名から拡張子を除く
	template  =	_replace( template, "ext",   _ext );		// ファイル名から拡張子のみ取り出す

	template  =	template.replace( /%DATE%/ig,  _date );				// 2009/05/11(月)
	template  =	template.replace( /%TIME%/ig,  _time );				// 19:15:10
	template  =	template.replace( /%DATE_TIME%/ig,  _date_time );	// %DATE% %TIME%
	template  =	template.replace( /%USER_NAME%/ig,  _userName );	// %DATE% %TIME%
	
	return template;
}

function saveTextUTF8(fname, text)
{
	var adTypeBinary = 1, adTypeText = 2;
	var adSaveCreateNotExist = 1, adSaveCreateOverWrite = 2;
	var adWriteLine = 1;
	var s = new ActiveXObject("ADODB.Stream");
	s.Type = adTypeText;
	s.charset = "utf-8";
	s.Open();
	s.WriteText(text, adWriteLine);
	s.SaveToFile(fname, adSaveCreateOverWrite);
	s.Close();
}

function saveText(filePath, text)
{
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	fso.CreateTextFile(filePath, true);
	var file = fso.OpenTextFile(filePath, 2, 0);
	file.Write(text);
	file.Close();
}

function main()
{
	var args = WScript.Arguments;
	if( args.Length < 1 )
		WScript.Quit();

	var dir = args(0);


	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if( fso.FolderExists( dir ) == false )
	{
		WScript.Echo( "フォルダ " + dir + " は存在しません" );
		WScript.Quit();
	}

	var ret = InputBox( dir, "新規ファイル作成", "test.txt" );
	if( !ret )
	{
		WScript.Quit();
	}
	//var WSHShell = new ActiveXObject("WScript.Shell");
	//WSHShell.Popup(ret, 0, "title", 1);

	var newFile = dir + "\\" + ret;
	//WScript.Echo( newFile );

	if( fso.FileExists(newFile) )
	{
		WScript.Echo( "ファイル " + newFile + " は既に存在します。" );
		WScript.Quit();
	}

	var idx = newFile.lastIndexOf(".");
	if (idx < -1)
		return;	
	var ext = newFile.slice(idx+1, newFile.length);
	var front = newFile.substr(0, idx);

	var s = ext.split("/");
	for (var i=0; i<s.length; ++i)
	{
		newFile = front + "." + s[i];
		var isUTF8 = false;
		if (s[i] == "cpp" || s[i] == "h")
			isUTF8 = true;
	
		//var a = fso.CreateTextFile(newFile, true);
		var text = "";
		if( newFile.match( /.*\.(.*)/ ) )
		{
			var ext = RegExp.$1;
			var templateFile = GetCurrentFolder() + "template." + ext;
			if( fso.FileExists(templateFile) )
			{
				var f = fso.OpenTextFile( templateFile, 1 );
				var template = f.ReadAll();

				template = ReplaceTags( template, newFile );
				text = template;
				//a.Write( template );
			}
		}
		
		if (isUTF8 == false)
			saveText(newFile, text);
		else
			saveTextUTF8(newFile, text);

		//a.Close();
	}
}

main();