function DecorateText(str, link) {
    var e = document.createElement("a");
    e.href = link;
    e.className = "automated";
//    e.style.color = "#ff0000";
    e.appendChild(document.createTextNode(str));
    return e;
}

function hasClass(element, cls) {
    return (' ' + element.className + ' ').indexOf(' ' + cls + ' ') > -1;
}

function searchAndReplaceElement(elem, strSearch, link) {
    for(var i = elem.childNodes.length; i--;) {
        var childNode = elem.childNodes[i];
        if(childNode.nodeType == 3) { // 3 => a Text Node
            var strSrc = childNode.nodeValue; // for Text Nodes, the nodeValue property contains the text
            var pos = strSrc.indexOf(strSearch);

            if((pos==0 || (pos > 0 && strSrc.charAt(pos-1)!='-' && strSrc.charAt(pos-1)!="'")) &&
            		(((pos + strSearch.length) == strSrc.length) || strSrc.charAt(pos + strSearch.length)!='-')) {
                var fragment = document.createDocumentFragment();

                if(pos > 0)
                    fragment.appendChild(document.createTextNode(strSrc.substr(0, pos)));

                fragment.appendChild(DecorateText(strSearch, link));

                if((pos + strSearch.length) < strSrc.length)
                    fragment.appendChild(document.createTextNode(strSrc.substr(pos + strSearch.length)));

                elem.replaceChild(fragment, childNode);
            }
        } else if (childNode.nodeType == 1 && childNode.nodeName.toUpperCase()!='DT'
        	&& childNode.nodeName.toUpperCase()!='A' && !hasClass(childNode, 'no-markup')) { // 1 => an Element Node
        	searchAndReplaceElement(childNode, strSearch, link);
        }
    }
}

function addMarkupToClass(className, strSearch, link)
{
	var nodeList = document.getElementsByClassName(className);
	var nodeArray = [];
	for (var i = 0; i < nodeList.length; ++i) {
		searchAndReplaceElement(nodeList[i], strSearch, link);
	}
}

function addMarkup()
{
	var nodeList = document.getElementsByClassName("include");
	for (var i = 0; i < nodeList.length; ++i) {
		var name = nodeList[i].textContent;
		addMarkupToClass("markup", name, "#"+nodeList[i].attributes.id.value);
	}
}

addMarkup();