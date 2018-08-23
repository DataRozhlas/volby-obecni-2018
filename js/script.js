// JS soubory ve složce /styles/ se do výsledného článku zakompilují automaticky

d3.csv("https://data.irozhlas.cz/volby-obecni-2018/data/kandidatky/app/obce/nazvyobci.csv").then(function(data){
  var nazvyObci = data.sort(function(a, b) {
    if(a.NAZEVFULL < b.NAZEVFULL) return -1;
    if(a.NAZEVFULL > b.NAZEVFULL) return 1;
    return 0;
  });

	var seznamObci = nazvyObci.map(function(d) {
		return d['NAZEVFULL'];
	});

  $('#vyberObce').autocomplete({
    delay: 500,
    source: seznamObci,
    minLength: 4,
    select: function(e) {
      document.getElementById("strany").innerHTML = 'Načítám data...'
      setTimeout(function() {
        document.getElementById("strany").innerHTML = 'Načítám data...'
        var zvolenaObec = document.getElementById("vyberObce").value;
        var index = seznamObci.indexOf(zvolenaObec);
        var idObce = nazvyObci[index]['KODZASTUP'];
        ukazStrany(zvolenaObec, idObce);
      }, 250);
    }
  });

	$('#vyberObce').on('change', function () {
		setTimeout(function() {
      document.getElementById("strany").innerHTML = 'Načítám data...'
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

		poskladejTabulkuStran(stranyBezId, idStran, idObce);

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
	});
};

function ukazKandidaty(idObce, idStrany, nazevStrany) {
  document.getElementById("kandidati").innerHTML = 'Načítám data...'

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
  })
}

function zpetStrany() {
  document.getElementById("obec").scrollIntoView();
  window.scrollBy(0, -50);

  document.getElementById("kandidati").innerHTML = '';
  document.getElementById("zpetStrany").innerHTML = '';
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
};

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
