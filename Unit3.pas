unit Unit3;

interface

uses
  Classes;

type
  ThrSearch = class(TThread)
  private
    toAdd : ShortString;  { Co jest do dodania przed wywo³aniem Sync. dla WynikAdd }
    procedure Success;
    procedure Failure;
    procedure WynikAdd;
    function Search(s : char) : boolean; { szukaj }
  protected
    procedure Execute; override;
  end;

implementation

uses Unit1;

procedure ThrSearch.WynikAdd;
begin
  Form1.WynikMemo.Lines.Add(toAdd);
end;

function ThrSearch.Search(s : Char) : boolean;
var
  busy : ShortString;
  x, y : integer;
  Fix : array of Char;
  myFixes : array of ShortString;
  myFixesAddr : array of integer;

label
  ExitFunc;

begin
  with Form1 do begin

  Inc(RecDepth);

  { Czy musimy siê zbieraæ, tj. czy wciœniêto Anuluj? }
  if Terminated then
    begin
      result:= False;
      goto ExitFunc;
    end;

  { Jeœli nie jest w Known }
  for y:= 0 to High(Known) do
    if s = Known[y] then
      begin
        result:= True;
        goto ExitFunc;
        Break;
      end;

  { Listuj wszystkie wpisy zaczynaj¹ce siê na "s" }
  SetLength(myFixes, 0);
  SetLength(myFixesAddr, 0);
  for x:= 0 to High(Fixes) do
    if Fixes[x][1] = s then
      begin
        { Sam wzór }
        SetLength(myFixes, Length(myFixes)+1);
        myFixes[High(myFixes)]:= Fixes[x];

        { Adres wzoru w tablicy macierzystej }
        SetLength(myFixesAddr, Length(myFixesAddr)+1);
        myFixesAddr[High(myFixesAddr)]:= x;
      end;

  if Length(myFixes) = 0 then
    begin
      result:= False;
      goto ExitFunc;
    end;

  { Dla ka¿dego w myFixes }
  result:= False;
  for x:= 0 to High(myFixes) do
    begin
      { Rozbij wzór na Fixy }
      SetLength(Fix, 0);
      for y:= 2 to High(myFixes[x]) do
        if IsChar(myFixes[x][y]) then
          begin
            SetLength(Fix, Length(fix)+1);
            Fix[High(Fix)]:= myFixes[x][y];
          end;

      { Usuwamy wzór z Fixes, ¿eby nie móg³ byæ u¿yty przez przysz³e rekurencje }
      busy:= Fixes[MyFixesAddr[x]];
      Fixes[MyFixesAddr[x]]:= '';


      { Dla ka¿dego w Fix }
      for y:= 0 to High(Fix) do { pomijamy szukan¹, ¿eby siê nie zapêtliæ }
        if not Search(Fix[y]) then
          begin
            result:= False;
            Break;
          end else
          begin
            { Jeœlik funkcja zakoñczy³a siê powodzeniem, to mo¿emy dodaæ t¹ literê do znanych }
            SetLength(Known, Length(Known)+1);
            Known[High(Known)]:= Fix[y];
            result:= True;
          end;

      { Przywracamy wzór do Fixes }
      Fixes[MyFixesAddr[x]]:= busy;

      { Jeœli po tym wszystkim funkcja Search zakoñczy³¹ siê powodzeniem, nie musimy przechodziæ do nastêpnego wzoru }
      { To znaczy nie musimy próbowaæ nastêpnego wzoru }
      if result = True then
        begin
          { Dopisujemy do potrzebnych wzorów }
          { Oczywiœcie metod¹ Synchronize }
          toAdd:= myFixes[x];
          Synchronize(WynikAdd);
          Break;
        end;
    end;

ExitFunc:
  Dec(RecDepth);

  end;
end;

procedure ThrSearch.Success;
begin
  { Czasami zdarza³o siê, ¿e program pisa³ Rozwi¹zanie, podczas gdy }
  { Lista wzorów by³a pusta. Zdarzy³o mi siê tak podczas pierwszej prezentacji, }
  { Na szczêœcie jedynym widzem by³ mój nauczyciel informatyki. Nie wiedzia³, ¿e  }
  { Istnieje napis "Nisetety", którego to zobaczyliœmy przy wprowadzeniu innych danych. }

  if Form1.WynikMemo.Lines.Count = 0 then Form1.Equal(61, 'Niestety, nie uda³o siê rozwi¹zaæ zadania.') else
  Form1.Equal(0, 'Rozwi¹zanie');
end;

procedure ThrSearch.Failure;
begin
  Form1.Equal(60, 'Niestety nie uda³o siê znaleŸæ rozwi¹zania.');
  toAdd:= 'To wszystko, do czego uda³o mi siê dojœæ. Mo¿e powinienieœ/aœ wybraæ wiêcej danych... Kliknij "Wstecz", aby wróciæ.';
  WynikAdd;
end;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure ThrSearch.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ ThrSearch }

procedure ThrSearch.Execute;
begin
  if Search(Form1.searchFor) then
    Synchronize(Success) else Synchronize(Failure);
end;

end.
