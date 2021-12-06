# <NAZWA>

## Developerzy
- [Bogusz Jakub](https://github.com/boguszj)
- [Czachorska Karolina](https://github.com/karolina-cz)
- [Kalata Krzysztof](https://github.com/KrzysztofKalata)
- [Ruciński Konrad](https://github.com/rucinsk1)

## [Link do prezentacji]


## Architektura + stos technologiczny
  
### Scraper
  
Skrypt NodeJS działający w postaci Azure Functions aktualizujący dane w Blob Storage.

## Opis funkcjonalności

## Proces tworzenia
  
1. Wybród danych
  
Jako źródło danych posłużył nam serwis [JustJoinIT](https://justjoin.it/). Został wybrany ze względu na:
- uporządkowany sposób przedstawiania danych:
  - każda oferta zawiera listę porządanych umiejęnotści wraz z poziomem zaawansowania, przedstawionym liczbą całkowitą w skali od 1 do 5
  - każda ofera zawiera informację o ogólnym stopniu zaawansowania (jeden z trzech poziomów: junior, mid, senior)
- obeność informacji o stawkach.
  
2. Ekstrakcja danych
  
Po analizie ruchu sieciowego na stronie okazało się, że korzysta ona z bardzo wygodnego API, serwującego interesujące nas dane w postaci dokumentów JSON. W związku z tym screen scraping okazał się być nie potrzebny (powodowałby jedynie narzut czasowy i pamięciowy). Zamiast tego zdecydowaliśmy się na zwykłe odpytanie API, sparsowanie wyników, wstępne wyczyszczenie danych (na przykład ofert bez infromacji o stawce) i zapisanie informacji o ofertach w formie pliku .csv w Azure Blob Storage. W związku z dynamiką na rynku pracy, zapisane dane są aktualizowane raz na dobę (Timer Triggered Azure Function).
  

## Schemat działania

## Zastosowanie

