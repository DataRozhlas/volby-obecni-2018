title: "XXX"
perex: "XXX"
published: "21. dubna 2018"
coverimg: https://interaktivni.rozhlas.cz/brexit/media/cover.jpg
coverimg_note: "Foto <a href='#'>ČTK</a>"
styles: []
# snadné načítání csv: d3csv v libraries, d3.csv("soubor.csv").then(function(data){} ) v kódu
libraries: [jquery, d3csv, datatables] #highcharts, d3, d3v5
options: [] #wide, noheader (, nopic)
---

<wide>

<div id="container">

<div id="obec">

<h3>Obec</h3>

<form autocomplete="off" action="/action_page.php">
  <div class="autocomplete" style="width:300px;">
    <input id="vyberObce" name="vyberObce" type="text" placeholder="Vyberte obec">
  </div>
</form>

</div>

<div id="strany"><table id="tabulkaStran" class="display" style="width:100%"></table></div>

<div id="kandidati"><table id="tabulkaKandidatu" class="display" style="width:100%"></table></div>

</div>
