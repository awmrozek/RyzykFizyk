unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XPMan, Menus;

type
  TForm1 = class(TForm)
    BottomPnl: TPanel;
    Bevel1: TBevel;
    PnlTop: TPanel;
    Bevel2: TBevel;
    LeftWelcome: TLabel;
    BtnClose: TButton;
    btnPolicz: TButton;
    EnterSymbolVLbl: TLabel;
    KnownSymbolsVLbl: TLabel;
    CautionVLbl: TLabel;
    KnownVList: TListBox;
    KnownVEd: TEdit;
    AddVBtn: TButton;
    DelSelVBtn: TButton;
    WelcomeL: TLabel;
    DataL: TLabel;
    SearchedL: TLabel;
    Label1: TLabel;
    SearchedEd: TEdit;
    DSSeparator: TBevel;
    TheResult: TPanel;
    ResType: TImage;
    ResultName: TLabel;
    lResultDetails1: TLabel;
    WynikMemo: TMemo;
    NoWarrantyL: TLabel;
    ImageError: TImage;
    ImageSucess: TImage;
    Label3: TLabel;
    XPManifest1: TXPManifest;
    ListPopup: TPopupMenu;
    Usuzaznaczony1: TMenuItem;
    Wyczy1: TMenuItem;
    btnDetails: TButton;
    btnAbout: TButton;
    procedure btnAboutClick(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
    procedure Usuzaznaczony1Click(Sender: TObject);
    procedure Wyczy1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPoliczClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure KnownVEdKeyPress(Sender: TObject; var Key: Char);
    procedure AddVBtnClick(Sender: TObject);
    procedure DelSelVBtnClick(Sender: TObject);
    procedure KnownVListClick(Sender: TObject);
  private
    { Private declarations }
  public
    RecDepth : integer;

    quitNow : boolean;

    using : array of ShortString;
    Fixes : array of ShortString;   { wszystkie wzory. Ostatni element jest "empty" }
    Known : array of ShortString;   { wszystkie znane dane }
    function Search(s : char) : boolean; { szukaj }
    function IsChar(s : shortstring) : boolean; { CzyZnak? }
    procedure Equal(suc : integer; msg : string);
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.Equal(suc : integer; msg : string);
begin
  TheResult.Visible:= True;
  ResultName.Caption:= msg;

  btnPolicz.Visible:= False;

  if suc = 0 then
    begin
      WynikMemo.Visible:= False;
      lResultDetails1.Visible:= False;
      BtnDetails.Visible:= True;
    end;
  if suc = 3 then
    begin
      lResultDetails1.Visible:= False;
      WynikMemo.Visible:= False;
      NoWarrantyL.Caption:= 'Proszê pobraæ plik FixesData.txt ze strony autora i umieœciæ go w folderze, w którym znajduje siê Ryzyk Fizyk.';
    end;
end;

function TForm1.IsChar(s : ShortString) : boolean;
begin
  if Length(S) <> 1 then
    begin
//      Showmessage('Funkcja IsChar: Podano niew³aœciwy ³añcuch: '+S);
      result:= False;
      Exit;
    end;

  result:= False;
  case S[1] of
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z':
      result:= True;
  end;
end;

function TForm1.Search(s : Char) : boolean;
const
    MAXRECDEPTH = 10;
label
    Szukanie;
var i : integer;  { który wzór z kolei na liœcie znalesionych }
    l : integer;  { numer dobrego wzoru w tablicy }
    k, m : integer;  { pomocnicza }
    Fix : array of Char;
begin
  Inc(RecDepth);

  i:= 0;

  Szukanie:
  if quitNow then
    begin
      Result:= False;
      Exit;
    end;

  { Szukanie wzoru zaczynaj¹cego siê na "s" }
  k:= 0;
  for l:= 0 to High(Fixes) do
    if Fixes[l][1] = s then
    if k = i then Break else k:= k +1;

  { Sprawdzamy, czy wzór zosta³ ju¿ u¿yty }
  for m:= 0 to High(using) do
    if Using[m] = Fixes[l] then
      begin
//        WynikMemo.Lines.Add('Wzór ju¿ u¿yty ' +Using[m]);
        Inc(i);
        goto Szukanie;
        Break;
      end;

  { Ostatni pusty element = nic nie znaleziono }
  if l = High(Fixes)+1 then
    begin
      result:= False;
      Dec(RecDepth);
      quitNow:= True;
      WynikMemo.Lines.Add('Niewystarczaj¹ca iloœæ wzorów do rozwi¹zania zadania.');
      Exit;
    end;

  { Dopisujemy do listy wzorów ju¿ w u¿yciu }
  SetLength(Using, Length(Using)+1);
  Using[High(Using)]:= Fixes[l];

  { No a jeœli coœ mamy, to wpisujemy to jako wzór }
  { Wpisaæ sk³adniki wzoru do tablicy Fix }
  { Dobry wzór = Fixes[l] }
  SetLength(Fix, 0);
  for k:= 3 to High(Fixes[l]) do { pierwsze 2 to szukana i = }
    { Dla ka¿dego znaku, sprawdzamy, czy jest znakiem }
    if IsChar(Fixes[l][k]) then
      begin
        SetLength(Fix, Length(Fix)+1);
        Fix[High(Fix)]:= Fixes[l][k];
       // WynikMemo.Lines.Add(Fix[High(Fix)]);
      end;

  { Dodajemy pusty element }
  SetLength(Fix, Length(Fix)+1);
  Fix[High(Fix)]:= ' ';

  { Dla ka¿dego el. wzoru (tablicy Fix), sprawdziæ, czy jest w Known }
  for k:= 0 to High(Fix) do
    begin
      { Czy el. Fix znajduje siê w Known? }
      for m:= 0 to High(Known) do
        if Fix[k] = Known[m] then Break;

      { Jeœli nie zosta³ znaleziony, to znaczy, ¿e go nie ma }
      { Szukamy elementu z pêtli nadrzêdnej, którego nie ma w Known }
      if m = High(Known)+1 then //Search(Fix[k]);
        if Fix[k] <> ' ' then
        if RecDepth < MAXRECDEPTH then
          begin
            if Search(Fix[k]) then
              begin
                SetLength(Known, Length(Known)+1);
                Known[High(Known)]:= Fix[k];
//                WynikMemo.Lines.Add('Dodano '+Fix[k]+' do known.');
              end else
              begin
//                WynikMemo.Lines.Add('Próba szukania '+IntToStr(i)+'-go wzoru. Poprzedni siê nie nadaje.');
                Inc(i);
                goto Szukanie;
              end;
          end else
            begin
              WynikMemo.Lines.Add('Przekroczono dopuszczalne zapêtlenie. Program koñczy.');
              result:= False;
              quitNow:= True;
              Exit;
//            inc(i);
//            goto Szukanie;
//              Showmessage(IntToStr(i));
            end;
    end;

  { Usuwamy wzór z listy u¿ywanych }
  for k:= 0 to High(Using) do
    if Using[k] = Fixes[l] then Using[k]:= '';

  { Wpisujemy do Known }
  for k:= 0 to High(Fix)-1 do
    begin
      SetLength(Known, Length(Known)+1);
      Known[High(Known)]:= Fix[k];
    end;

  WynikMemo.Lines.Add(Fixes[l]);
  Result:= True;
  Dec(RecDepth);
end;

procedure TForm1.KnownVListClick(Sender: TObject);
begin
  DelSelVBtn.Visible:= True;
end;

procedure TForm1.DelSelVBtnClick(Sender: TObject);
begin
  KnownVList.DeleteSelected;
  DelSelVBtn.Visible:= False;
end;

procedure TForm1.AddVBtnClick(Sender: TObject);
begin
  if not IsChar(KnownVEd.Text) then
    begin
      Showmessage('Proszê wpisaæ jedn¹ literê - symbol danej w zadaniu. Po wpisaniu tej litery wciœnij Enter.'#13#10'PóŸniej mo¿esz wpisaæ nastêpn¹ dan¹.');
      KnownVEd.Text:= '';
      Exit;
    end;

  KnownVList.Items.Add(KnownVEd.Text);
  KnownVEd.Text:= '';
end;

procedure TForm1.KnownVEdKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then AddVBtnClick(KnownVEd);
end;

procedure TForm1.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btnPoliczClick(Sender: TObject);
var i : integer;
begin
  { Czy poprawne? }
  if not IsChar(SearchedEd.Text) then
    begin
      Showmessage('W polu "Szukane" proszê wpisaæ tylko jedn¹ literê - znan¹ dan¹.'#13#10'Na przyk³ad ma³¹ literê m - symbol masy.');
      SearchedEd.Text:= '';
      Exit;
    end;

  { 1. Pozycje z listy Known do tablicy Known }
  SetLength(Known, 0);
  for i:= 0 to KnownVList.Items.Count -1 do
    begin
      SetLength(Known, Length(Known) +1);
      Known[i]:= KnownVList.Items[i];
    end;

  { Pusty elemnet dla orientacji w szukaniu }
  SetLength(Known, Length(Known) +1);
  Known[High(Known)]:= '';

  { 2. Uruchomiæ funkcjê Search z argumentem SearchedEd.Text[1] }
  if not Search(SearchedEd.Text[1]) then Equal(0, 'Niestey, nie uda³o siê rozwi¹zaæ zadania.')
    else Equal(1, 'Rozwi¹zanie');

  BtnPolicz.Visible:= False;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  f : TextFile;
  s : string;
begin
  { £adowanie wzorów }
  if FileExists('FixesData.txt') then
    begin
      AssignFile(f, 'FixesData.txt');
      try
        Reset(f);
        While not eof(f) do
          begin
            ReadLn(f, s);

            { Czy komentarz? }
            if s = '' then Continue;
            if s[1]='#' then Continue;

            { Wpis }
            SetLength(Fixes, Length(Fixes) +1);
            Fixes[High(Fixes)]:= s;
          end;
        CloseFile(f);
      except
        Showmessage('Nieznany b³¹d w trakcie odczytu pliku FixesData.txt. Program koñczy dzia³anie.');
        Close;
      end;
    end else
      begin
        Showmessage('Nie znaleziono pliku ze wzorami - FixesData.txt. Program koñczy dzia³anie.');
        Equal(3, 'Brakuj¹cy plik ze wzorami.');
        Close;
      end;

  { Dodajemy pusty element, ¿eby szukanie mia³o jak okreœliæ brak wzorów }
  SetLength(Fixes, Length(Fixes) +1);
  Fixes[High(Fixes)]:= '';
end;

procedure TForm1.Wyczy1Click(Sender: TObject);
begin
  KnownVList.Items.Clear;
end;

procedure TForm1.Usuzaznaczony1Click(Sender: TObject);
begin
  KnownVList.DeleteSelected;
end;

procedure TForm1.btnDetailsClick(Sender: TObject);
begin
  WynikMemo.Visible:= True;
  btnDetails.Visible:= False;
end;

procedure TForm1.btnAboutClick(Sender: TObject);
begin
  Form2.ShowModal;
end;

end.
