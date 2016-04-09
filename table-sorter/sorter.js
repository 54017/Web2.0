window.onload = function() {
	var tables = getAllTables();
	makeAllTablesSortable(tables);
}

function getAllTables() {
	return document.getElementsByTagName("table");
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
}


function sortTable(k, col, asc) {
		var t = document.getElementsByTagName("table")[k].getElementsByTagName("tbody");
		var rows = t[0].rows;
		var tt = 0;
		if (t[0].getElementsByTagName("tr")[0].getElementsByTagName("th").length > 0) {
			tt = 1;
		}
		var rowsLength = rows.length;
		var temp = new Array();
		for (var i = tt; i < rowsLength; ++i) {
			cells = rows[i].cells;
			temp[i - tt] = new Array();
			cellsLength = cells.length;
			for (var j = 0; j < cellsLength; ++j) {
				temp[i - tt][j] = cells[j].innerHTML;  //用二元数组存储tbody中的表格
			}
		}
		//Array自带排序
		temp.sort( function(x, y) {
            if (x[col] > y[col]) {
            	return (asc == 1) ? 1 : -1;
            } else {
                return (asc == 1) ? -1 : 1;
            }
        });
         for (i = tt; i < rowsLength; i++) {
                rows[i].innerHTML = "<td>" + temp[i - tt].join("</td><td>") + "</td>";
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