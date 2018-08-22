// JS soubory ve složce /styles/ se do výsledného článku zakompilují automaticky

d3.csv("https://data.irozhlas.cz/volby-obecni-2018/data/kandidatky/app/obce/nazvyobci.csv").then(function(data){

	var nazvyObci = data;

	var seznamObci = nazvyObci.map(function(d) {
		return d['NAZEVFULL'];
	});

	autocomplete(document.getElementById("vyberObce"), seznamObci);

	$("input").on("change", function () {

		setTimeout(function() {

			var zvolenaObec = document.getElementById("vyberObce").value;
			var index = seznamObci.indexOf(zvolenaObec);
			var idObce = nazvyObci[index]['KODZASTUP'];
			ukazStrany(zvolenaObec, idObce);

		}, 250);

	});

});

function ukazStrany(zvolenaObec, idObce) {

	d3.csv("https://data.irozhlas.cz/volby-obecni-2018/data/kandidatky/app/strany/" + idObce + ".csv").then(function(data){

		var strany = data;

    var idStran = strany.map(function(d) {
      return d['StranaNr'];
    });

    var stranyBezId = strany.map(function(d) {
      delete(d['StranaNr'])
      return (d);
    });

		var html = '<h3>Kandidující strany</h3>'
		html += '<table id="tabulkaStran" class="display" style="width:100%"></table>'

		document.getElementById("strany").innerHTML = html;
    document.getElementById("kandidati").innerHTML = '<div></div>';

		poskladejTabulkuStran(stranyBezId, idStran, idObce)

    $(function() {
      $('#tabulkaStran').DataTable({
          "order": [[ 0, "asc" ]],
          "responsive": true,
          "ordering": true,
          "paging": false,
          "bInfo": false,
          "language": {
              "url": "https://interaktivni.rozhlas.cz/tools/datatables/Czech.json"
          }
      });
    });

	})

}

function ukazKandidaty(idObce, idStrany, nazevStrany) {

  d3.csv("https://data.irozhlas.cz/volby-obecni-2018/data/kandidatky/app/kandidati/" + idObce + ".csv").then(function(data){

    var kandidati = data;

    var kandidatiBezId = kandidati.map(function(d) {
      if (d['StranaNr'] == idStrany) {
        delete(d['StranaNr'])
        return (d);
      };
    });

    kandidatiBezId = kandidatiBezId.filter(function(d) {
      return d != undefined;
    });

    var html = '<div id = "zpetStrany"><button type = "button" onclick = "zpetStrany()">Zpět na výběr strany ↑</button></div>'
    html += '<h3>Kandidáti</h3>'
    html += '<h3 style = "font-weight: normal">' + nazevStrany + '</h3>'
    html += '<table id="tabulkaKandidatu" class="display" style="width:100%"></table>'

    document.getElementById("kandidati").innerHTML = html;

    poskladejTabulkuKandidatu(kandidatiBezId, nazevStrany);

    $(function() {
      $('#tabulkaKandidatu').DataTable({
          "order": [[ 0, "asc" ]],
          "responsive": true,
          "ordering": true,
          "paging": false,
          "bInfo": false,
          "language": {
              "url": "https://interaktivni.rozhlas.cz/tools/datatables/Czech.json"
          },
      });
    });

    document.getElementById("zpetStrany").scrollIntoView();
    window.scrollBy(0, -50);

  })

}

function zpetStrany() {

  document.getElementById("obec").scrollIntoView();
  window.scrollBy(0, -50);

  document.getElementById("kandidati").innerHTML = '';
  document.getElementById("zpetStrany").innerHTML = '';

}

function autocomplete(inp, arr) {
  /*the autocomplete function takes two arguments,
  the text field element and an array of possible autocompleted values:*/
  var currentFocus;
  /*execute a function when someone writes in the text field:*/
  inp.addEventListener("input", function(e) {
      var a, b, i, val = this.value;
      /*close any already open lists of autocompleted values*/
      closeAllLists();
      if (!val) { return false;}
      currentFocus = -1;
      /*create a DIV element that will contain the items (values):*/
      a = document.createElement("DIV");
      a.setAttribute("id", this.id + "autocomplete-list");
      a.setAttribute("class", "autocomplete-items");
      /*append the DIV element as a child of the autocomplete container:*/
      this.parentNode.appendChild(a);
      /*for each item in the array...*/
      for (i = 0; i < arr.length; i++) {
        /*check if the item starts with the same letters as the text field value:*/
        if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
          /*create a DIV element for each matching element:*/
          b = document.createElement("DIV");
          /*make the matching letters bold:*/
          b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
          b.innerHTML += arr[i].substr(val.length);
          /*insert a input field that will hold the current array item's value:*/
          b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
          /*execute a function when someone clicks on the item value (DIV element):*/
              b.addEventListener("click", function(e) {
              /*insert the value for the autocomplete text field:*/
              inp.value = this.getElementsByTagName("input")[0].value;
              /*close the list of autocompleted values,
              (or any other open lists of autocompleted values:*/
              closeAllLists();
          });
          a.appendChild(b);
        }
      }
  });
  /*execute a function presses a key on the keyboard:*/
  inp.addEventListener("keydown", function(e) {
      var x = document.getElementById(this.id + "autocomplete-list");
      if (x) x = x.getElementsByTagName("div");
      if (e.keyCode == 40) {
        /*If the arrow DOWN key is pressed,
        increase the currentFocus variable:*/
        currentFocus++;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 38) { //up
        /*If the arrow UP key is pressed,
        decrease the currentFocus variable:*/
        currentFocus--;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 13) {
        /*If the ENTER key is pressed, prevent the form from being submitted,*/
        e.preventDefault();
        if (currentFocus > -1) {
          /*and simulate a click on the "active" item:*/
          if (x) x[currentFocus].click();
        }
      }
  });
  function addActive(x) {
    /*a function to classify an item as "active":*/
    if (!x) return false;
    /*start by removing the "active" class on all items:*/
    removeActive(x);
    if (currentFocus >= x.length) currentFocus = 0;
    if (currentFocus < 0) currentFocus = (x.length - 1);
    /*add class "autocomplete-active":*/
    x[currentFocus].classList.add("autocomplete-active");
  }
  function removeActive(x) {
    /*a function to remove the "active" class from all autocomplete items:*/
    for (var i = 0; i < x.length; i++) {
      x[i].classList.remove("autocomplete-active");
    }
  }
  function closeAllLists(elmnt) {
    /*close all autocomplete lists in the document,
    except the one passed as an argument:*/
    var x = document.getElementsByClassName("autocomplete-items");
    for (var i = 0; i < x.length; i++) {
      if (elmnt != x[i] && elmnt != inp) {
      x[i].parentNode.removeChild(x[i]);
    }
  }
}
/*execute a function when someone clicks in the document:*/
document.addEventListener("click", function (e) {
    closeAllLists(e.target);
});
}

function poskladejTabulkuStran(seznamStran, idStran, idObce) {
  var columns = poskladejHlavickuStran(seznamStran);

  $('#tabulkaStran').append('<tbody>');
  for (var i = 0; i < seznamStran.length; i++) {
    var row$ = $('<tr/>');
    for (var colIndex = 0; colIndex < columns.length; colIndex++) {
      var cellValue = seznamStran[i][columns[colIndex]];
      var nazevStrany = '\'' + seznamStran[i]['Strana'] + '\'';
      if (colIndex == 0) cellValue = cellValue + '<p class="stranaKlik" onclick="ukazKandidaty(' + idObce + ', ' + idStran[i] + ', ' + nazevStrany + ')"><u>kandidáti</u></p>';
      if (cellValue == null) cellValue = "";
      row$.append($('<td/>').html(cellValue));
    }
    $('#tabulkaStran').append(row$);
  }
}

// Adds a header row to the table and returns the set of columns.
// Need to do union of keys from all records as some records may not contain
// all records.
function poskladejHlavickuStran(seznamStran) {
  var columnSet = [];

  $('#tabulkaStran').append('<thead id="seznamStranHlavicka">');
  var headerTr$ = $('<tr>');

  for (var i = 0; i < seznamStran.length; i++) {
    var rowHash = seznamStran[i];
    for (var key in rowHash) {
      if ($.inArray(key, columnSet) == -1) {
        columnSet.push(key);
        headerTr$.append($('<th/>').html(key));
      }
    }
  }

  $('#seznamStranHlavicka').append(headerTr$);

  return columnSet;
}

function poskladejTabulkuKandidatu(seznamKandidatu, nazevStrany) {
  var columns = poskladejHlavickuKandidatu(seznamKandidatu);

  $('#tabulkaKandidatu').append('<tbody>');
  for (var i = 0; i < seznamKandidatu.length; i++) {
    if ((seznamKandidatu[i]['Minulá kandidatura'] != nazevStrany) && (seznamKandidatu[i]['Minulá kandidatura'] != '')) {
      var row$ = $('<tr id = "prebehlik">');
    } else {
      var row$ = $('<tr>');
    }
    for (var colIndex = 0; colIndex < columns.length; colIndex++) {
      var cellValue = seznamKandidatu[i][columns[colIndex]];
      if (cellValue == null) cellValue = "";
      row$.append($('<td>').html(cellValue));
    }
    $('#tabulkaKandidatu').append(row$);
  }
}

// Adds a header row to the table and returns the set of columns.
// Need to do union of keys from all records as some records may not contain
// all records.
function poskladejHlavickuKandidatu(seznamKandidatu) {
  var columnSet = [];

  $('#tabulkaKandidatu').append('<thead id="seznamKandidatuHlavicka">');
  var headerTr$ = $('<tr>');

  for (var i = 0; i < seznamKandidatu.length; i++) {
    var rowHash = seznamKandidatu[i];
    for (var key in rowHash) {
      if ($.inArray(key, columnSet) == -1) {
        columnSet.push(key);
        headerTr$.append($('<th/>').html(key));
      }
    }
  }

  $('#seznamKandidatuHlavicka').append(headerTr$);

  return columnSet;
}
