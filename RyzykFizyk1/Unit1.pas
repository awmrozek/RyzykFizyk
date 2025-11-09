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
    Label3: TLabel;
    XPManifest1: TXPManifest;
    ListPopup: TPopupMenu;
    Usuzaznaczony1: TMenuItem;
    Wyczy1: TMenuItem;
    btnDetails: TButton;
    btnAbout: TButton;
    BtnBack: TButton;
    procedure BtnBackClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
    debugFile: TextFile;

    quitNow : boolean;

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
  if msg <> '' then ResultName.Caption:= msg else
  if suc >= 1 then ResultName.Caption:= 'Nie uda³o siê rozwi¹zaæ zadania.' else
  if suc < 1 then ResultName.Caption:= 'Uda³o siê.';

  btnPolicz.Visible:= False;

  if suc >= 1 then
    begin
      btnDetails.Visible:= True;
      lResultDetails1.Visible:= False;
      WynikMemo.Visible:= False;
    end;

  case suc of
    1: WynikMemo.Lines.Add('Nieznany b³¹d.');
    3:
      begin
        NoWarrantyL.Caption:= 'Proszê pobraæ plik FixesData.txt ze strony autora i umieœciæ go w folderze, w którym znajduje siê Ryzyk Fizyk.';
        btnDetails.Visible:= False;
      end;
    4: WynikMemo.Lines.Add('Przepe³nienie stosu. Prawdopodobne zapêtlenie.');
    5: WynikMemo.Lines.Add('System stwierdzi³ brak pamiêci. Najprawdopodobniej wynika to z b³êdu programu i nie nale¿y dokupywaæ pamiêci do komputera.');
  end;

  if WynikMemo.Lines.Count = 0 then btnDetails.Visible:= False;
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
var
  busy : ShortString;
  x, y : integer;
  Fix : array of Char;
  myFixes : array of ShortString;
  myFixesAddr : array of integer;
  debugString : ShortString;
begin
  Inc(RecDepth);

  { Jeœli nie jest w Known }
  for y:= 0 to High(Known) do
    if s = Known[y] then
      begin
        result:= True;
        Exit;
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
//      WynikMemo.Lines.Add('Nie znaleziono wzoru dla '+s);
      Exit;
    end;

  { Info }
  if ParamStr(1) = 'debugfile' then
  for x:= 0 to High(myFixes) do
    begin
      debugString:= '';
      for y:= 0 to RecDepth do
        debugString:= debugString+'>';

      debugString:= debugString+' '+myFixes[x];
      WriteLn(debugFile, debugString);
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
          WynikMemo.Lines.Add(myFixes[x]);
          Break;
        end;
    end;

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
  try
    if Search(SearchedEd.Text[1]) then Equal(0, 'Rozwi¹zanie')
    else Equal(60, 'Niestety, nie uda³o siê rozwi¹zaæ zadania.');
  except on EStackOverflow do
    Equal(4, 'B³¹d w programie.');
  end;

  BtnPolicz.Visible:= False;
  BtnBack.Visible:= True;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  f : TextFile;
  s : string;
begin
  { debugFile }
  if ParamStr(1) = 'debugfile' then
    begin
      AssignFile(debugFile, ParamStr(2));
      Rewrite(debugFile);
    end;


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
        Equal(1, '');
//        Close;
      end;
    end else
      begin
        Showmessage('Nie znaleziono pliku ze wzorami - FixesData.txt. Program koñczy dzia³anie.');
        Equal(3, 'Brakuj¹cy plik ze wzorami.');
//        Close;
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

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ParamStr(1) = 'debugfile' then
    begin
      CloseFile(debugfile);
//      WinExec(PChar('notepad.exe "'+ExtractFileDir(ParamStr(0))+'\'+ParamStr(2)+'"'), SW_SHOWNORMAL);
    end;
end;

procedure TForm1.BtnBackClick(Sender: TObject);
begin
  WynikMemo.Lines.Clear;
  TheResult.Visible:= False;
  BtnBack.Visible:= False;
  BtnPolicz.Visible:= True;
end;

end.
