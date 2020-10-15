
import csv
import lxml.etree as etree

# indiquer la racine, soit "toilettes(<toilettes></toilettes)"
toilettes=etree.Element("toilettes")

# le module "DictReader" permet de créer un objet qui opère comme un lecteur ordinaire 
# mais assemble les informations de chaque ligne dans un dict

# "row" permet de parcourir les colonnes dans le fichier csv et les faire afficher
# etree.SubElement permet d'ajouter les sous-éléments

with open("sanisettesparis.csv") as csvfile:
    reader = csv.DictReader(csvfile,delimiter=';')
    
    for row in reader:
        toilette=etree.SubElement(toilettes,"toilette",type=row["TYPE"],statut=row["STATUT"])
        
        adresse=etree.SubElement(toilette,"adresse")
        libelle=etree.SubElement(adresse,"libelle")
        arrondissement=etree.SubElement(adresse,"arrondissement")
        libelle.text=row["ADRESSE"]
        arrondissement.text=row["ARRONDISSEMENT"]
        
        horaire=etree.SubElement(toilette,"horaire")
        horaire.text=row["HORAIRE"]
    
        services=etree.SubElement(toilette,"services")
        acces_pmr=etree.SubElement(services,"acces-pmr")
        relais_bebe=etree.SubElement(services,"relais-bebe")
        acces_pmr.text=row["ACCES_PMR"]
        relais_bebe.text=row["RELAIS_BEBE"]
        
        equipement=etree.SubElement(toilette,"equipement")
        equipement.text=row["URL_FICHE_EQUIPEMENT"]
        
tree_out = (ET.tostring(toilettes,pretty_print=True,xml_declaration=True,encoding="UTF-8"))

with open('toilettes-paris.xml','wb') as f:
    f.write(tree_out)