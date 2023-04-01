program Gauss;

type
  tMacierz = array of array of double;
  tWektorDouble = array of double;
  tWektorIndeks = array of word;

function Modul (x:double) : double;
begin
  if (x<0) then
  Modul:=x*(-1)
  else
  Modul:=x;
end;

function EliminacjaGaussa (macierz : tMacierz; ileNiewiadomych : word; eps : double;
                          var wektorX : tWektorDouble) : boolean;
var
  i, j, kolumna, k, l : word;
  mnoznik, suma : double;
begin
  //petla for - tworzymy macierz trojkatna gorna
  //do -2, bo nie potrzebujemy zerowac parametru przy ostatniej niewiadomej.
  for i:=0 to ileNiewiadomych-2 do
  begin
    //od i+1, wiec schodzi wiersz nizej niz i, a indeks i tworzy "schodki"
    for j:=i+1 to ileNiewiadomych-1 do
    begin
      //jezeli przekatna ma ktorykolwiek element = 0, wtedy macierz jest osobliwa,
      //zwracamy false i konczymy funkcje
      if (Modul(macierz[i][i]) < eps) then
      begin
        EliminacjaGaussa := false;
        Exit;
      end;
      mnoznik := (macierz[j][i]/macierz[i][i])*(-1);
      //dodawanie wiersza przemnozonego przez mnoznik
      for kolumna:=i to ileNiewiadomych do
      macierz[j][kolumna] := macierz [j][kolumna] + mnoznik * macierz[i][kolumna];

      //kontrolne wypisanie
      writeln ('Macierz AB:');
      for k:=0 to ileNiewiadomych-1 do
      begin
        for l:=0 to ileNiewiadomych do
        write (macierz[k][l]:8:3,' ');
        writeln;
      end;
      //
    end;
  end;

  //obliczanie x i wpisywanie wartosci x do wektora X
  //od konca, bo macierz trojkatna gorna
  for i:=(ileNiewiadomych-1) downto 0 do
  begin
    //suma jest rowna wyrazowi wolnemu
    suma := macierz[i][ileNiewiadomych];
    //j do i+1 po to, zeby petla nie wykonywala sie gdy wektorX jest pusty
    for j:=(ileNiewiadomych-1) downto (i+1) do
    begin
      suma := suma - macierz[i][j] * wektorX[j];
    end;
    //jezeli przekatna ma ktorykolwiek element = 0, wtedy macierz jest osobliwa,
    //zwracamy false i konczymy funkcje
    if (Modul(macierz[i][i]) < eps) then
    begin
      EliminacjaGaussa := false;
      Exit;
    end;
    wektorX[i]:=suma/macierz[i][i];
  end;
  EliminacjaGaussa := true;
end;

procedure Gauss (macierzAB : tMacierz; ileNiewiadomych: word; eps : double);
var
  wektorX : tWektorDouble;
  wektorKolumna : tWektorIndeks;
  i, j : word;
begin
  SetLength (wektorX,ileNiewiadomych);

  //jezeli funkcja zwrocila 'true', to oznacza, ze det!=0 i mozna wypisac wyniki
  if (EliminacjaGaussa (macierzAB, ileNiewiadomych, eps, wektorX)) then
  begin
    writeln ('Funkcja eliminacji Gaussa zwrocila true');
    for i:=0 to ileNiewiadomych-1 do
    begin
      writeln ('x', i+1, ' = ', wektorX[i]:8:4);
    end;
  end
  //jezeli funkcja zwrocila 'false', to oznacza, ze det=0 i nie mozna wypisac wynikow
  else
  begin
    writeln ('Macierz osobliwa, det = 0');
  end;
end;

function EliminacjaGaussaCrouta (var macierz : tMacierz; ileNiewiadomych : word; eps : double;
                          var wektorX : tWektorDouble; var wektorKolumna : tWektorIndeks) : boolean;
var
  i, j, kolumna, k, l : word;
  mnoznik, suma : double;
begin
  //petla for - tworzymy macierz trojkatna gorna
  //do -2, bo nie potrzebujemy zerowac parametru przy ostatniej niewiadomej.
  for i:=0 to ileNiewiadomych-2 do
  begin
    kolumna := i;
    for j:=i+1 to ileNiewiadomych-1 do
    begin
      if (Modul(macierz[i][wektorKolumna[kolumna]]) < Modul(macierz[i][wektorKolumna[j]])) then
         kolumna := j;
    end;
    j:=wektorKolumna[kolumna];
    wektorKolumna[kolumna]:=wektorKolumna[i];
    wektorKolumna[i]:=j;
    for j:=i+1 to ileNiewiadomych-1 do
    begin
      if (Modul(macierz[i][wektorKolumna[i]]) < eps) then
      begin
        EliminacjaGaussaCrouta := false;
        Exit;
      end;
      mnoznik:= (-1)*macierz[j][wektorKolumna[i]] / macierz [i][wektorKolumna[i]];
      for kolumna:=i to ileNiewiadomych do
      begin
        macierz[j][wektorKolumna[kolumna]]:=macierz[j][wektorKolumna[kolumna]] + mnoznik * macierz[i][wektorKolumna[kolumna]];
      end;
      //kontrolne wypisanie
      writeln ('Macierz AB:');
      for kolumna:=0 to ileNiewiadomych-1 do
      begin
        for l:=0 to ileNiewiadomych do
        write (macierz[kolumna][l]:8:3,' ');
        writeln;
      end;
      //
    end;
  end;

  //niewiadome
  for i:=ileNiewiadomych-1 downto 0 do
  begin
    if (Modul(macierz[i][wektorKolumna[kolumna]])<eps) then
    begin
      EliminacjaGaussaCrouta:=false;
      Exit;
    end;
    suma:= macierz [i][ileNiewiadomych];
    for j:=ileNiewiadomych-1 downto i+1 do
    begin
      suma:= suma - macierz[i][wektorKolumna[j]]*wektorX[wektorKolumna[j]];
    end;
    wektorX[wektorKolumna[i]]:=suma/macierz[i][wektorKolumna[i]];
  end;
  EliminacjaGaussaCrouta := true;
end;

procedure GaussCrout (var macierzAB : tMacierz; ileNiewiadomych: word; eps : double);
var
  wektorX : tWektorDouble;
  wektorKolumna : tWektorIndeks;
  i, j : word;
begin
  SetLength (wektorX,ileNiewiadomych);
  SetLength (wektorKolumna, ileNiewiadomych+1);

  for i:=0 to ileNiewiadomych do
      wektorKolumna[i]:=i;

  //jezeli funkcja zwrocila 'true', to oznacza, ze det!=0 i mozna wypisac wyniki
  if (EliminacjaGaussaCrouta (macierzAB, ileNiewiadomych, eps, wektorX, wektorKolumna)) then
  begin
    writeln ('Funkcja eliminacji Gaussa-Crouta zwrocila true:');
    for i:=0 to ileNiewiadomych-1 do
    begin
      writeln ('x', i+1, ' = ', wektorX[i]:8:4);
    end;
  end
  //jezeli funkcja zwrocila 'false', to oznacza, ze det=0 i nie mozna wypisac wynikow
  else
  begin
    writeln ('Macierz osobliwa, det = 0');
  end;
end;

procedure CzytajDane (var macierzAB : tMacierz; var ileNiewiadomych : word; var eps : double);
var
  i, j : word;
begin
  write ('Podaj ile chcesz niewiadomych: ');
  read (ileNiewiadomych);

  //write ('Podaj jakiej oczekujesz dokladnosci (bliskosc do zera): ');
  //read (eps);
  eps:=1e-12;
  //+1 kolumn, poniewaz dopisujemy do macierzy kolumne wyrazow wolnych
  //SetLength oprocz ustawienia wymiarow, wypelnia wszystkie komorki tabeli zerami
  SetLength (macierzAB, ileNiewiadomych, ileNiewiadomych+1);
  //numerowanie indeksow jest od 0, wiec liczymy do ile-1
  //odczytywanie zawartosci macierzy, tzn. parametrow
  for i:=0 to ileNiewiadomych-1 do
  begin
    for j:=0 to ileNiewiadomych do
    read (macierzAB[i][j]);
  end;
end;

procedure Implementacja;
var
  macierzAB : tMacierz;
  ileNiewiadomych : word;
  eps : double;
begin
  CzytajDane (macierzAB, ileNiewiadomych, eps);
  //writeln ('Metoda eliminacji Gaussa:');
  //Gauss (macierzAB, ileNiewiadomych, eps);
  writeln ('Metoda eliminacji Gaussa-Crouta:');
  GaussCrout (macierzAB, ileNiewiadomych, eps);
end;

begin
  Implementacja;
  readln;
  readln;
end.
