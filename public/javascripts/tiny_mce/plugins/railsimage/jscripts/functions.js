/* Functions for the railsimage plugin popup */

var preloadImg = null;

function insertAction() {
	var inst = tinyMCE.getInstanceById(tinyMCE.getWindowArg('editor_id'));
	var elm = inst.getFocusElement();
	var formObj = document.forms[0];
	var src = formObj.src.value;
	var onmouseoversrc = formObj.onmouseoversrc.value;
	var onmouseoutsrc = formObj.onmouseoutsrc.value;

	if (tinyMCE.getParam("accessibility_warnings")) {
		if (formObj.alt.value == "") {
			var answer = confirm(tinyMCE.getLang('lang_railsimage_missing_alt', '', true));
			if (answer == true) {
				formObj.alt.value = " ";
			}
		} else {
			var answer = true;
		}

		if (!answer)
			return;
	}

	// Fix output URLs
	src = convertURL(src, tinyMCE.imgElement);

	if (onmouseoversrc && onmouseoversrc != "")
		onmouseoversrc = "this.src='" + convertURL(onmouseoversrc, tinyMCE.imgElement) + "';";

	if (onmouseoutsrc && onmouseoutsrc != "")
		onmouseoutsrc = "this.src='" + convertURL(onmouseoutsrc, tinyMCE.imgElement) + "';";

	if (elm != null && elm.nodeName == "IMG") {
		setAttrib(elm, 'src', src);
		setAttrib(elm, 'mce_real_src', src);
		setAttrib(elm, 'alt');
		setAttrib(elm, 'title');
		setAttrib(elm, 'border');
		setAttrib(elm, 'vspace');
		setAttrib(elm, 'hspace');
		setAttrib(elm, 'width');
		setAttrib(elm, 'height');
		setAttrib(elm, 'onmouseover', onmouseoversrc);
		setAttrib(elm, 'onmouseout', onmouseoutsrc);
		setAttrib(elm, 'id');
		setAttrib(elm, 'dir');
		setAttrib(elm, 'lang');
		setAttrib(elm, 'longdesc');
		setAttrib(elm, 'usemap');
		setAttrib(elm, 'style');
		setAttrib(elm, 'class', getSelectValue(formObj, 'classlist'));
		setAttrib(elm, 'align', getSelectValue(formObj, 'align'));

		//tinyMCEPopup.execCommand("mceRepaint");

		// Refresh in old MSIE
		if (tinyMCE.isMSIE5)
			elm.outerHTML = elm.outerHTML;
	} else {
		var html = "<img";

		html += makeAttrib('src', src);
		html += makeAttrib('alt');
		html += makeAttrib('title');
		html += makeAttrib('border');
		html += makeAttrib('vspace');
		html += makeAttrib('hspace');
		html += makeAttrib('width');
		html += makeAttrib('height');
		html += makeAttrib('onmouseover', onmouseoversrc);
		html += makeAttrib('onmouseout', onmouseoutsrc);
		html += makeAttrib('id');
		html += makeAttrib('dir');
		html += makeAttrib('lang');
		html += makeAttrib('longdesc');
		html += makeAttrib('usemap');
		html += makeAttrib('style');
		html += makeAttrib('class', getSelectValue(formObj, 'classlist'));
		html += makeAttrib('align', getSelectValue(formObj, 'align'));
		html += " />";

		tinyMCEPopup.execCommand("mceInsertContent", false, html);
	}

	tinyMCE._setEventsEnabled(inst.getBody(), false);
	tinyMCEPopup.close();
}

function cancelAction() {
	tinyMCEPopup.close();
}

function changeAppearance() {
	var formObj = document.forms[0];
	var img = document.getElementById('alignSampleImg');

	if (img) {
		img.align = formObj.align.value;
		img.border = formObj.border.value;
		img.hspace = formObj.hspace.value;
		img.vspace = formObj.vspace.value;
	}
}

function changeMouseMove() {
	var formObj = document.forms[0];

	setSwapImageDisabled(!formObj.onmousemovecheck.checked);
}

function updateStyle() {
	var formObj = document.forms[0];
	var st = tinyMCE.parseStyle(formObj.style.value);

	if (tinyMCE.getParam('inline_styles', false)) {
		st['width'] = formObj.width.value == '' ? '' : formObj.width.value + "px";
		st['height'] = formObj.height.value == '' ? '' : formObj.height.value + "px";
		st['border-width'] = formObj.border.value == '' ? '' : formObj.border.value + "px";
		st['margin-top'] = formObj.vspace.value == '' ? '' : formObj.vspace.value + "px";
		st['margin-bottom'] = formObj.vspace.value == '' ? '' : formObj.vspace.value + "px";
		st['margin-left'] = formObj.hspace.value == '' ? '' : formObj.hspace.value + "px";
		st['margin-right'] = formObj.hspace.value == '' ? '' : formObj.hspace.value + "px";
	} else {
		st['width'] = st['height'] = st['border-width'] = null;

		if (st['margin-top'] == st['margin-bottom'])
			st['margin-top'] = st['margin-bottom'] = null;

		if (st['margin-left'] == st['margin-right'])
			st['margin-left'] = st['margin-right'] = null;
	}

	formObj.style.value = tinyMCE.serializeStyle(st);
}

function styleUpdated() {
	var formObj = document.forms[0];
	var st = tinyMCE.parseStyle(formObj.style.value);

	if (st['width'])
		formObj.width.value = st['width'].replace('px', '');

	if (st['height'])
		formObj.height.value = st['height'].replace('px', '');

	if (st['margin-top'] && st['margin-top'] == st['margin-bottom'])
		formObj.vspace.value = st['margin-top'].replace('px', '');

	if (st['margin-left'] && st['margin-left'] == st['margin-right'])
		formObj.hspace.value = st['margin-left'].replace('px', '');

	if (st['border-width'])
		formObj.border.value = st['border-width'].replace('px', '');
}

function changeHeight() {
	var formObj = document.forms[0];

	if (!formObj.constrain.checked || !preloadImg) {
		updateStyle();
		return;
	}

	var temp = (formObj.width.value / preloadImg.width) * preloadImg.height;
	formObj.height.value = temp.toFixed(0);
	updateStyle();
}

function changeWidth() {
	var formObj = document.forms[0];

	if (!formObj.constrain.checked || !preloadImg) {
		updateStyle();
		return;
	}

	var temp = (formObj.height.value / preloadImg.height) * preloadImg.width;
	formObj.width.value = temp.toFixed(0);
	updateStyle();
}

function onSelectMainImage(target_form_element, name, value) {
	var formObj = document.forms[0];

	formObj.alt.value = name;
	formObj.title.value = name;

	resetImageData();
	showPreviewImage(formObj.elements[target_form_element].value);
}

function showPreviewImage(src) {
	selectByValue(document.forms[0], 'imagelistsrc', src);

	var elm = document.getElementById('prev');
	var src = src == "" ? src : tinyMCE.convertRelativeToAbsoluteURL(tinyMCE.settings['base_href'], src);

	if (src == "")
		elm.innerHTML = "";
	else
		elm.innerHTML = '<img src="' + src + '" border="0" />'

	getImageData(src);
}

function getImageData(src) {
	preloadImg = new Image();

	tinyMCE.addEvent(preloadImg, "load", updateImageData);
	tinyMCE.addEvent(preloadImg, "error", resetImageData);

	preloadImg.src = src;
}

function updateImageData() {
	var formObj = document.forms[0];

	if (formObj.width.value == "")
		formObj.width.value = preloadImg.width;

	if (formObj.height.value == "")
		formObj.height.value = preloadImg.height;

	updateStyle();
}

function resetImageData() {
	var formObj = document.forms[0];
	formObj.width.value = formObj.height.value = "";	
}

function getSelectValue(form_obj, field_name) {
	var elm = form_obj.elements[field_name];

	if (elm == null || elm.options == null)
		return "";

	return elm.options[elm.selectedIndex].value;
}

function getImageListHTML(elm_id, target_form_element, onchange_func) {
	if (typeof(tinyMCEImageList) == "undefined" || tinyMCEImageList.length == 0)
		return "";

	var html = "";

	html += '<select id="' + elm_id + '" name="' + elm_id + '"';
	html += ' class="mceImageList" onfocus="tinyMCE.addSelectAccessibility(event, this, window);" onchange="this.form.' + target_form_element + '.value=';
	html += 'this.options[this.selectedIndex].value;';

	if (typeof(onchange_func) != "undefined")
		html += onchange_func + '(\'' + target_form_element + '\',this.options[this.selectedIndex].text,this.options[this.selectedIndex].value);';

	html += '"><option value="">---</option>';

	for (var i=0; i<tinyMCEImageList.length; i++)
		html += '<option value="' + tinyMCEImageList[i][1] + '">' + tinyMCEImageList[i][0] + '</option>';

	html += '</select>';

	return html;

	// tinyMCE.debug('-- image list start --', html, '-- image list end --');
}

// While loading
preinit();
