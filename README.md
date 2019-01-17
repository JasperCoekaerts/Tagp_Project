# Toepassingen en aloritmes van geavanceerde programeertalen project van Jasper Coekaerts en Luka Lageschaar
## Doel
Het doel aan het begin van het project was om een digital twin programma te schrijven dat een elektrisch circuit can simuleren. Hiervoor zijn meerdere bestanden geschreven gebaseerd op de voorbeeld code van de heer Paul Valkenaers in zijn [repository](https://github.com/ValckenaersPaul/TAGP).
## Simulatie elementen
..* Devices of gebruikers. Dit kunnen complexe gebruikers zijn of eenvoudige componenten zoals een weerstand, spoel, capaciteid, ... 
..* Kabels waarmee de gebruikers kunnen worden verbonden met de bron, in serie of parallel geplaatst kunnen worden met andere gebruikers, ...
..* Schakelaars om een bepaald deel van een kring te kunnen aan en uit schakelen, ...
..* Voedingsbronnen van verschillende spanningen, stromen, vermogens en configuraties zoals driefasige wisselspanning, gelijkstroom, eenfasige wisselspanning, ...
## Data structuur
Om verschillende elementen van een circuit te simuleren is er gebruik gemaakt van de resourceType en resourceInstance structuur, van de heer Paul Valckenaers, om verschillende elementen van een elektrische kring te simuleren. Ook wordt er gebruik gemaakt van een lichtjes aangepaste connector structuur gebruik gemaakt om elementen digitaal aan elkaar te verbinden en de stroom loop door de kring vast te leggen. 

De gedane aanpassingen zorgen ervoor dat een connector kan worden verbonden met meerdere andere connectors. Op deze manier kan een bron met maar een connector toch een volledige kring van energie voorzien. De stroom zin ( Van de bron naar de grond ) kan uit de connectors worden gehaalt door aan een uit connector de verbonden connectors op te vragen. Dit geeft een lijst van in connectoren als antwoord. Eender welke connector uit deze lijst zal echter teruggeven dat ze niet verbonden is. Dit wil zeggen dat de stroom niet van een ingang terug naar de uitgang kan lopen en de simulatie dus geen foutstromen kan verwerken. 
## Instantiatie van een voorbeeld kring
In de test.erl file wordt er een Keuken gesimuleerd. Deze keuken is op te roepen via de test_room() functie in dit bestand. 

Ook is er al een begin gemaakt van een functie waarmee eigenschappen van de kring kunnen worden berekent.