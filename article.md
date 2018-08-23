title: "Interaktivní kandidátky: proklikejte si, kdo kandiduje, kdo obhajuje a kdo přestoupil"
perex: "K obecním volbám volbám 5. a 6. října jsme připravili praktickou aplikaci. Na pár kliků vám prozradí informace, které na papíře nenajdete."
published: "21. dubna 2018"
coverimg: https://www.irozhlas.cz/sites/default/files/styles/zpravy_snowfall/public/uploader/komunalni-volby_1802_180823-084533_jab.png?itok=6XCgU6KR
coverimg_note: ""
styles: ["//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"]
# snadné načítání csv: d3csv v libraries, d3.csv("soubor.csv").then(function(data){} ) v kódu
libraries: [jquery, d3csv, datatables, "https://code.jquery.com/ui/1.12.1/jquery-ui.js"] #highcharts, d3, d3v5
options: [noheader, nopic] #wide, noheader (, nopic)
---

_U obhajoby mandátu nebo kandidatury za jinou stranu než minule jsme nejprve museli určit, zda jde na minulých a letošních kandidátkách o stejnou osobu. Kandidáty jsme spojovali podle shodného jména, příjmení, o čtyři roky vyššího věku a kandidatury do stejného zastupitelstva. Pokud se tedy například kandidátka vdala a změnila si jméno, nebo jen kandiduje do jiného zastupitelstva než minule, nespojíme si ji._

_Sloupec_ minulá kandidatura _znamená, že kandidát nastupuje za hnutí s jiným názvem než v minulých volbách. Neznamená tedy automaticky přestup do jiné strany._

_U Prahy 9 a obce Lišov, které mají volební obvody, je pořadí kandidáta ve formátu {obvod}/{pořadí na kandidátce}._

<wide>
<div id="container">
	<div id="obec">
		<h3>Obec</h3>
		<form onsubmit="return false">
			<div class="autocomplete" style="width:300px;">
				<input id="vyberObce" name="vyberObce" type="text" placeholder="Napište jméno obce">
			</div>
		</form>
	</div>
	<div id="strany">
		<table id="tabulkaStran" class="display" style="width:100%"></table></div>
	<div id="kandidati"><table id="tabulkaKandidatu" class="display" style="width:100%"></table></div>
</div>
</wide>

V podzimních komunálních volbách kandiduje 216 520 kandidátů z 403 stran, hnutí a koalic. Je to nejméně od roku 2006, téměř o desetinu méně než před čtyřmi lety.

Víc než polovina z nich – 111 tisíc – kandiduje za lokální strany a hnutí. Mezi celostátními politickými stranami postaví nejvíc kandidátů KDU-ČSL (15,9 tisíce), KSČM (15,3 tisíce) a ČSSD (13,5 tisíce). Je to poprvé v rámci samostatné České republiky, kdy komunisté nebudou nejpočetnější.

<left>
<h3>Čtěte také</h3>
<ul>
	<li><a href="https://www.irozhlas.cz/volby/komunalni-volby-2018" target="_blank">Speciál ke komunálním volbám</a></li>
	<li><a href="https://www.irozhlas.cz/volby/senatni-volby-2018" target="_blank">Speciál k senátním volbám</a></li>
</ul>
</left>

Všem třem zmíněným stranám nicméně proti minulým volbám kandidátů podstatně ubylo: křesťanští demokraté přišli o 11 procent, komunisti o 20 procent a sociální demokrati o 27 procent kandidátů. Ještě hůř je na tom TOP 09, která nasadí o 54 procent lidí méně než minule – a to včetně koalic.

Naopak polepšili si Starostové a nezávislí, ti vyrostli o 21 procent, a taky piráti, kterých bude letos oproti minulým volbám trojnásobně. Nicméně největším skokanem je hnutí SPD Tomia Okamury, které před čtyřmi lety nekandidovalo a letos postaví 4,5 tisíce lidí.

Průměrný věk všech kandidátů je 47 let. Ve všech dosavadních komunálních volbách byl průměrný kandidát o rok až dva mladší. Naznačuje to, že zájem o lokální politiku v posledním období poklesl.

Necelá třetina kandidátů jsou ženy. Podíl žen v konkrétní straně, stejně jako věkový průměr, prozradí interaktivní kandidátky.