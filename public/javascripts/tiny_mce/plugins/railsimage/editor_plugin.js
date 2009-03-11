/* Import plugin specific language pack */
tinyMCE.importPluginLanguagePack('railsimage', 'en,de,sv,zh_cn,cs,fa,fr_ca,fr,pl,pt_br,nl,he,no,ru,ru_KOI8-R,ru_UTF-8,cy,es,is');

function TinyMCE_railsimage_getInfo() {
	return {
		longname : 'Advanced image',
		author : 'Moxiecode Systems',
		authorurl : 'http://tinymce.moxiecode.com',
		infourl : 'http://tinymce.moxiecode.com/tinymce/docs/plugin_railsimage.html',
		version : tinyMCE.majorVersion + "." + tinyMCE.minorVersion
	};
};

function TinyMCE_railsimage_getControlHTML(control_name) {
	switch (control_name) {
		case "image":
			var cmd = 'tinyMCE.execInstanceCommand(\'{$editor_id}\',\'mceRailsImage\');return false;';
			return '<a href="javascript:' + cmd + '" onclick="' + cmd + '" target="_self" onmousedown="return false;"><img id="{$editor_id}_railsimage" src="{$themeurl}/images/image.gif" title="{$lang_image_desc}" width="20" height="20" class="mceButtonNormal" onmouseover="tinyMCE.switchClass(this,\'mceButtonOver\');" onmouseout="tinyMCE.restoreClass(this);" onmousedown="tinyMCE.restoreClass(this);" /></a>';
	}

	return "";
}

function TinyMCE_railsimage_execCommand(editor_id, element, command, user_interface, value) {
	switch (command) {
		case "mceRailsImage":
			var template = new Array();

			template['file']   = 'http://www.portallus.com/image/upload/';
			template['width']  = 400;
			template['height'] = 160;

			// Language specific width and height addons
			template['width']  += tinyMCE.getLang('lang_railsimage_delta_width', 0);
			template['height'] += tinyMCE.getLang('lang_railsimage_delta_height', 0);

			tinyMCE.openWindow(template, {editor_id : editor_id, inline : "yes"});

			return true;
	}

	return false;
}

function TinyMCE_railsimage_cleanup(type, content) {
	switch (type) {
		case "insert_to_editor_dom":
			var imgs = content.getElementsByTagName("img");
			for (var i=0; i<imgs.length; i++) {
				var onmouseover = tinyMCE.cleanupEventStr(tinyMCE.getAttrib(imgs[i], 'onmouseover'));
				var onmouseout = tinyMCE.cleanupEventStr(tinyMCE.getAttrib(imgs[i], 'onmouseout'));

				if ((src = tinyMCE.getImageSrc(onmouseover)) != "") {
					src = tinyMCE.convertRelativeToAbsoluteURL(tinyMCE.settings['base_href'], src);
					imgs[i].setAttribute('onmouseover', "this.src='" + src + "';");
				}

				if ((src = tinyMCE.getImageSrc(onmouseout)) != "") {
					src = tinyMCE.convertRelativeToAbsoluteURL(tinyMCE.settings['base_href'], src);
					imgs[i].setAttribute('onmouseout', "this.src='" + src + "';");
				}
			}
			break;

		case "get_from_editor_dom":
			var imgs = content.getElementsByTagName("img");
			for (var i=0; i<imgs.length; i++) {
				var onmouseover = tinyMCE.cleanupEventStr(tinyMCE.getAttrib(imgs[i], 'onmouseover'));
				var onmouseout = tinyMCE.cleanupEventStr(tinyMCE.getAttrib(imgs[i], 'onmouseout'));

				if ((src = tinyMCE.getImageSrc(onmouseover)) != "") {
					src = eval(tinyMCE.settings['urlconverter_callback'] + "(src, null, true);");
					imgs[i].setAttribute('onmouseover', "this.src='" + src + "';");
				}

				if ((src = tinyMCE.getImageSrc(onmouseout)) != "") {
					src = eval(tinyMCE.settings['urlconverter_callback'] + "(src, null, true);");
					imgs[i].setAttribute('onmouseout', "this.src='" + src + "';");
				}
			}
			break;
	}

	return content;
}

function TinyMCE_railsimage_handleNodeChange(editor_id, node, undo_index, undo_levels, visual_aid, any_selection) {
	tinyMCE.switchClassSticky(editor_id + '_railsimage', 'mceButtonNormal');

	if (node == null)
		return;

	do {
		if (node.nodeName == "IMG" && tinyMCE.getAttrib(node, 'class').indexOf('mceItem') == -1)
			tinyMCE.switchClassSticky(editor_id + '_railsimage', 'mceButtonSelected');
	} while ((node = node.parentNode));

	return true;
}
