window.onload = function() {
	var tables = getAllTables();
	makeAllTablesFilterable(makeAllTablesSortable(tables));
}

function getAllTables() {
	return document.getElementsByTagName("table");
}

function filterTable(input, t) {
	var text = input.value;
	var trs = t.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
	for (var i = 0; i < trs.length; ++i) {
		tds = trs[i].getElementsByTagName('td');
		for (var j = 0; j < tds.length; ++j) {
			if (tds[j].innerText.indexOf(text) >= 0) {
				var reg = new RegExp("("+text+")","g");   
				tds[j].innerHTML = tds[j].innerText.replace(reg,"<font color=red>$1</font>");   
				break;
			}
			if (j == tds.length - 1) { 
				trs[i].style.display = "none";
			}
		}
	}
}

function clearDisplay(t) {
	var trs = t.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
	for (var i = 0; i < trs.length; ++i) {
		trs[i].style.display = "table-row";
	}
}

function makeAllTablesFilterable(t) {
	for (var i = 0; i < t.length; ++i) {
		var input = document.createElement('input');
		input.type = "text";
		input.onkeyup = (function() {  //closure 传递参数
				var k = i;
				return function() {
					clearDisplay(t[k]);
					filterTable(this, t[k]);
				}
			})();
		document.body.insertBefore(input, t[i]);
	}
	return t;
}


function makeAllTablesSortable(t) {
	for (var i = 0; i < t.length; ++i) {
		var thObjects = t[i].getElementsByTagName("th");
		for (var j = 0; j < thObjects.length; ++j) {
			thObjects[j].value = 1; //设置value, 1为升序, 0降序. 第一次设置为1默认升序
			thObjects[j].onclick = (function() {  //closure 传递参数
				var k = i;
				var q = j;
				var ths = thObjects;
				return function() {
					sortTable(k, q, this.value);  //t[k].id为需要sort的table的id，p为需要sort的列数
					styleChange(this, t[k]);  //为被点击的调整样式
					var alt = this.value;
					for (var p = 0; p < ths.length; ++p) {  //将其他的th恢复为默认值
						ths[p].value = 1;
					} 
					this.value = -1 * alt;
				}
			})();
		}
	}
	return t;
}

// Sortable Table

function sortTable(k, col, asc) {
		var t = document.getElementsByTagName("table")[k].getElementsByTagName("tbody");
		var rows = t[0].rows;
		var tt = 0;
		if (t[0].getElementsByTagName("tr")[0].getElementsByTagName("th").length > 0) {
			tt = 1;
		}
		var display = new Array();
		var rowsLength = rows.length;
		for (var i = tt; i < rowsLength; ++i) {
			if (rows[i].style.display == "none") {
				display[i - tt] = 0;
			} else {
				display[i - tt] = 1;
			}
		}
		var temp = new Array();
		for (var i = tt; i < rowsLength; ++i) {
			cells = rows[i].cells;
			temp[i - tt] = new Array();
			cellsLength = cells.length;
			for (var j = 0; j < cellsLength; ++j) {
				temp[i - tt][j] = cells[j].innerHTML;  //用二元数组存储tbody中的表格
			}
		}
		for (var i = rowsLength - 1; i > 0; --i) {
			for (var j = 0; j < i; ++j) {
				if (temp[j][col] > temp[j + 1][col] && asc == 1) {   //两个功能table会很繁琐，数组做的缺陷。
					for (var k = 0; k < cellsLength; ++k) {
						var ttt = temp[j][k];
						temp[j][k] = temp[j + 1][k];
						temp[j + 1][k] = ttt;
					}
					ttt = display[j];
					display[j] = display[j + 1];
					display[j + 1] = ttt; 
				} else if (temp[j][col] < temp[j + 1][col] && asc != 1) {
					for (var k = 0; k < cellsLength; ++k) {
						var ttt = temp[j][k];
						temp[j][k] = temp[j + 1][k];
						temp[j + 1][k] = ttt;
					}
					ttt = display[j];
					display[j] = display[j + 1];
					display[j + 1] = ttt; 
				}
			}
		}

        for (i = tt; i < rowsLength; i++) {
                rows[i].innerHTML = "<td>" + temp[i - tt].join("</td><td>") + "</td>";
                if (display[i] == 0) rows[i].style.display = "none";
                if (display[i] == 1) rows[i].style.display = "table-row";
        }
    }

function styleChange(thClicked, table) {
	var thObjects = table.getElementsByTagName("th");
	for (var i = 0; i < thObjects.length; ++i) {
		thObjects[i].className = "";
	}
	if (thClicked.value == 1) {
		thClicked.className = "ascend";
	} else {
		thClicked.className = "descend";
	}
}