```
for $el in //* return $el/name()

for $prix in //pdv/prix[@nom="Gazole"]/@valeur return $prix*2.5

for $n in //pdv return concat($n/adresse, ' ', $n/ville)
for $i in (1 to 100) return  if ($i mod 3 = 0) then $i else ()

for $pdv in //pdv return if ($pdv/services/count(child::*)=1 and $pdv/services/service/text()="Vente de gaz domestique") then $pdv/@id  else $pdv/adresse

for $i in //pdv/adresse return if (contains($i/text(), "Avenue")) then $i/upper-case(text()) else ()

/pdv_liste/pdv/services/service union /pdv_liste/pdv/services/service

/pdv_liste/pdv[./prix/@nom="SP95"] union /pdv_liste/pdv[./prix/@nom="SP98"]

/pdv_liste/pdv[rupture/@*] intersect /pdv_liste/pdv[ouverture[contains(@saufjour,'Dimanche')]]

/pdv_liste/pdv except /pdv_liste/pdv[contains(adresse/text(), "ROUTE NATIONALE")]

some $pdv in /pdv_liste/pdv satisfies not(./services/service="Automate CB")

every $pdv in /pdv_liste/pdv satisfies ./ouverture/@saufjour=""
```