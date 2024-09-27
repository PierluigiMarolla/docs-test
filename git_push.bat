@echo off
:: Richiedi l'inserimento di un messaggio di commit
set /p commitMessage="Inserisci il messaggio di commit: "

:: Esegui i comandi Git in sequenza
git add .
git commit -m "%commitMessage%"
git push
