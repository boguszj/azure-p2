# Salary Predictor

## Developerzy
- [Bogusz Jakub](https://github.com/boguszj)
- [Czachorska Karolina](https://github.com/karolina-cz)
- [Kalata Krzysztof](https://github.com/KrzysztofKalata)
- [Ruciński Konrad](https://github.com/rucinsk1)

## [Link do prezentacji]


## Architektura + stos technologiczny
  ![architecture](https://user-images.githubusercontent.com/46794180/144915538-e1894a46-5807-4970-bdb8-91fad38090d8.png)

  
### Scraper  
Skrypt NodeJS działający w postaci Azure Functions aktualizujący dane w Blob Storage.

### Model
Model wytrenowany w Azure ML wystawiony przez Container Instance na świat.

### Salesforce
Krzysiek pls

## Opis funkcjonalności
- przewidywanie pensji dla podanego zestawu umiejętności,

## Proces tworzenia
  
### 1. Wybród danych  
Jako źródło danych posłużył nam serwis [JustJoinIT](https://justjoin.it/). Został wybrany ze względu na:
- uporządkowany sposób przedstawiania danych:
  - każda oferta zawiera listę porządanych umiejęnotści wraz z poziomem zaawansowania, przedstawionym liczbą całkowitą w skali od 1 do 5
  - każda ofera zawiera informację o ogólnym stopniu zaawansowania (jeden z trzech poziomów: junior, mid, senior)
- obeność informacji o stawkach.
  
### 2. Ekstrakcja danych
  
Po analizie ruchu sieciowego na stronie okazało się, że korzysta ona z bardzo wygodnego API, serwującego interesujące nas dane w postaci dokumentów JSON. W związku z tym screen scraping okazał się być nie potrzebny (powodowałby jedynie narzut czasowy i pamięciowy). Zamiast tego zdecydowaliśmy się na zwykłe odpytanie API, sparsowanie wyników, wstępne wyczyszczenie danych (na przykład ofert bez infromacji o stawce) i zapisanie informacji o ofertach w formie pliku .csv w Azure Blob Storage. W związku z dynamiką na rynku pracy, zapisane dane są aktualizowane raz na dobę (Timer Triggered Azure Function).
  
### 3. Czyszczenie danych
 
W Azure ML studio stworzyliśmy notebook, który pozwala nam oczyścić dane: zamienia wartości NaN na 0 oraz tworzy kolumnę avg_salary, która będzie przewidywana w kolejnych        krokach.

### 4. Trenowanie modelu
 
Azure Machine Learning umożliwia tworzenie użytkownikowi pipeline'ów, które wykorzystaliśmy by rozdzielić dane na treningowe oraz testowe. Następnie wybraliśmy typ modelu, którego bedziemy używać. Po wytrenowaniu modelu stworzyliśmy Container Instance, które pozwala nam wystawić nasz model na świat z którym możemy się komunikować za pomocą API.
  
### 5. KRZYSZTOF KALATA PUNKT
  
  

## Schemat działania
  - użytkownik uruchamia aplikację w Salesforce,
  - użytkownik wybiera cechy oraz ich stopień zaawansowania,
  - dane są przesyłane do Endpoint'u poprzez który nasz model komunikuje się ze światem,
  - aplikacja wyświetla zwrócone przez model przewidywane wynagrodzenie 

## Zastosowanie
Wielu pracodawców spotkało się z sytuajcą w której zastanawiają się jaką pensję zaproponować nowemu pracownikowi. Dzięki naszej aplikacji wystarczy, że wpisze oczekiwane umiejętności i dzięki proponowanej pensji zwróconej przez naszą aplikacją będzie w stanie zaproponować konkurencyjne wynagrodzenie dla nowego pracownika. Aplikacja będzie użyteczna także dla programistów szukających pracy, dzięki naszemu modelowi będą mogli oszacować pensję na którą będą mogli liczyć co na pewno przyda się na potencjalnej rozmowie kwalifikacyjnej.
