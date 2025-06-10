unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XPMan, Menus, ComCtrls, ShellApi;

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
    KnownVList: TListBox;
    KnownVEd: TEdit;
    AddVBtn: TButton;
    DelSelVBtn: TButton;
    WelcomeL: TLabel;
    DataL: TLabel;
    SearchedL: TLabel;
    Label1: TLabel;
    DSSeparator: TBevel;
    Label3: TLabel;
    XPManifest1: TXPManifest;
    ListPopup: TPopupMenu;
    Usuzaznaczony1: TMenuItem;
    Wyczy1: TMenuItem;
    btnHelp: TButton;
    BtnBack: TButton;
    PanelGlossary: TPanel;
    PanelNoGlossary: TPanel;
    BvNoGlossary: TBevel;
    NoGlossaryLabel: TLabel;
    lListHint: TLabel;
    FixesList: TListBox;
    lListHint2: TLabel;
    ArrowImgBlue: TImage;
    ArrowImgGray: TImage;
    SearchedEd: TComboBox;
    TheResult: TPanel;
    ImageResType: TImage;
    ResultName: TLabel;
    NoWarrantyL: TLabel;
    lResultDetails1: TLabel;
    WynikMemo: TMemo;
    btnDetails: TButton;
    lTrans: TLabel;
    PanelWaitPlease: TPanel;
    LabelWaitPlease: TLabel;
    Animate1: TAnimate;
    LabelSearching: TLabel;
    AnimatedStuff: TPaintBox;
    TimerAnimation: TTimer;
    BtnCancel: TButton;
    PopupHelp: TPopupMenu;
    Szybkapomoc1: TMenuItem;
    Stronainternetowa1: TMenuItem;
    N1: TMenuItem;
    Oprogramie1: TMenuItem;
    ImageResSuc: TImage;
    ImageResFail: TImage;
    procedure Szybkapomoc1Click(Sender: TObject);
    procedure Stronainternetowa1Click(Sender: TObject);
    procedure Oprogramie1Click(Sender: TObject);
    procedure TimerAnimationTimer(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure KnownVListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure KnownVListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FixesListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SearchedEdChange(Sender: TObject);
    procedure ArrowImgBlueClick(Sender: TObject);
    procedure FixesListDblClick(Sender: TObject);
    procedure BtnBackClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnHelpClick(Sender: TObject);
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
    { S³ownik, który przechowuje, ¿e m = Masa }
    glSymbols : array of Char;            { Symbole: F, m, t, etc. }
    glWords : array of ShortString;       { S³owa: Si³a, Masa, Czas, et cetera... }

    RecDepth : integer;

    searchFor : char;  { Czego szukamy? Z t¹d czyta proceura ThrSearch.Execute }
    ThrSearchHnd : TThread;

    Fixes : array of ShortString;   { wszystkie wzory. Ostatni element jest "empty" }
    Known : array of ShortString;   { wszystkie znane dane }

    { Wodotryski - zmienne }
    AniX, AniY : integer;           { Wspó³rzêdne napisu }
    c, AniI : integer;           { Aktualny kolor oraz ztadium œciemnienia }
    r, g, b : double;         { Sk³adowe - wiêcej nie wiem }
    AniBmp : TBitmap;
    AniStuffText : ShortString;{ Bie¿¹cy wzór wypisywany na ekranie }
    procedure InitAniStuff;

    function IsChar(s : shortstring) : boolean; { CzyZnak? }
    procedure Equal(suc : integer; msg : string); { Pokazuje Panel z wynikiem }

    { T³umaczenie s³ownikowe }
    function Translate(c : Char) : ShortString; overload;
    function Translate(c : ShortString) : Char; overload;
  end;

var
  Form1: TForm1;
  
  { Informacje dla okna About }
  FixesBaseVer, GlossaryBaseVer : ShortString;

const
  JMPCOUNT = 100;      { Ile skoków w animacji podczas szukania? }
  PRODUCTVERSION = '1.2.2.0'; { Pewnie da siê to zrobiæ jak¹œ dyrektyw¹, ale tego nie wiem }
  { Przyjmujê konwencjê: Major Version, Minor Version, Nr. Poprawki, Nr. Wydania. }
  { Wartoœci Minor Version, Nr. Poprawki, oraz Nr. wydania s¹ liczone od zera. }  

implementation

uses Unit2, Unit3, Unit4;

{$R *.dfm}

procedure TForm1.InitAniStuff;
begin
//  AniStuffText:= 'Balblabla';
//  Randomize;
  AniStuffText:= Fixes[random(High(Fixes))];
  AniX:= random(AniBmp.Width);
  AniY:= random(AniBmp.Height);

  c:= ColorToRGB(Form1.Color);
  r:= ($FF and c)/JMPCOUNT;
  g:= ($FF and (c div 256))/JMPCOUNT;
  b:= ($FF and (c div 256 div 256))/JMPCOUNT;

  AniBmp.Canvas.Font.Size:= 12;
  AniBmp.Canvas.Font.Name:= 'Verdana';
  SetBKMode(AniBmp.Canvas.Handle, TRANSPARENT);

  AniI:= JMPCOUNT;
end;

function TForm1.Translate(c : Char) : ShortString;
var i : integer;
begin
  result:= '';
  for i:= 0 to High(glSymbols) do
    if glSymbols[i] = c then
      begin
        result:= glWords[i];
        Break;
      end;
end;

function TForm1.Translate(c : ShortString) : Char;
var i : integer;
begin
  result:= #0;
  for i:= 0 to High(glWords) do
    if glWords[i] = c then
      begin
        result:= glSymbols[i];
        Break;
      end;
end;

procedure TForm1.Equal(suc : integer; msg : string);
begin
  { Ustawiamy ikonkê }
  if suc = 0 then ImageResType.Picture:= ImageResSuc.Picture else ImageResType.Picture:= ImageResFail.Picture;

  { ¯eby nie przeszkadza³o }
  PanelNoGlossary.Visible:= False;
  PanelWaitPlease.Visible:= False;
  Animate1.Active:= False;
  TimerAnimation.Enabled:= False;

  { No i reszta wartoœci pocz¹tkowych }
  btnDetails.Visible:= False;
  btnCancel.Visible:= False;
  btnBack.Visible:= True;

  TheResult.Visible:= True;

  { Czasami, jeœli po klikniêciu przycisku Powrót pojawi siê rozwi¹zanie, WynikMemo musi byæ widoczny }
  lResultDetails1.Visible:= True;
  WynikMemo.Visible:= True;

  { Przetwarzanie komunikatu }
  if msg <> '' then ResultName.Caption:= msg else
  if suc >= 1 then ResultName.Caption:= 'Nie uda³o siê rozwi¹zaæ zadania.' else
  if suc < 1 then ResultName.Caption:= 'Uda³o siê.';

  { Wyniki powy¿ej 120 - b³êdy u¿ytkownika. Nie wyœwietlamy informacji o braku gwarancji. }
  if suc >= 120 then NoWarrantyL.Visible:= False else NoWarrantyL.Visible:= True;

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
var i, j : integer;
begin
  { Wodotryski On! }
  InitAniStuff;

  { Czy mamy _jak¹œ_ szukan¹? }
  if SearchedEd.Text = '' then
    begin
      Equal(120, 'Proszê wybraæ jak¹œ szukan¹!');
      Exit;
    end;

  { Czy mamy jakieœ dane? }
  if KnownVList.Items.Count = 0 then
    begin
      Equal(121, 'Proszê wybraæ jakieœ dane!');
      Exit;
    end;

  { Czy poprawne? }
  { Czy wybieramy, czy wpisujemy? Poznamy to po stylu SearcedEd }
  if SearchedEd.Style = csSimple then
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

  { 2. Uruchomiæ funkcjê Search z argumentem SearchedEd.Text[1] }
  try
    case SearchedEd.Style of
      csSimple:
        begin
          { Dla stylu prostego }
          searchFor:= SearchedEd.Text[1];
          ThrSearchHnd:= ThrSearch.Create(False);
          PanelWaitPlease.Visible:= True;
          Animate1.Active:= True;
          TimerAnimation.Enabled:= True;
        end;

      csDropDown:
        begin
          { I bardziej wyrafinowanego }
          searchFor:= Translate(SearchedEd.Text);
          ThrSearchHnd:= ThrSearch.Create(False);
          PanelWaitPlease.Visible:= True;
          Animate1.Active:= True;
          TimerAnimation.Enabled:= True;
        end;
    end;

  except
    Equal(1, 'B³¹d w programie.');
  end;

  BtnPolicz.Visible:= False;
  BtnCancel.Visible:= True;

  { Wpisy nie mog¹ siê powtarzaæ. }
  for i:= 0 to WynikMemo.Lines.Count do
    for j:= 0 to WynikMemo.Lines.Count do
      if WynikMemo.Lines[i] = WynikMemo.Lines[j] then
      if i <> j then WynikMemo.Lines.Delete(j);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  f : TextFile;
  s : ShortString;
  i : integer;
begin
  { Wodotryski }
  AniBmp:= TBitmap.Create;
  AniBmp.Canvas.Brush.Color:= clBtnFace;
  AniBmp.Width:= AnimatedStuff.Width;
  AniBmp.Height:= AnimatedStuff.Height;

  { debugFile }
//  if ParamStr(1) = 'debugfile' then
//    begin
//      AssignFile(debugFile, ParamStr(2));
//      Rewrite(debugFile);
//    end;


  { £adowanie wzorów }
  if FileExists(ExtractFileDir(Application.ExeName)+'\FixesData.txt') then
    begin
      AssignFile(f, ExtractFileDir(Application.ExeName)+'\FixesData.txt');
      try
        Reset(f);

        { Odczyt informacji o wersji bazy wzorów }
        if not eof(f) then
            ReadLn(f, FixesBaseVer)
        else GlossaryBaseVer:= 'FIXES_EMPTY';

        { Odczyt w³aœciwych wzorów }
        while not eof(f) do
          begin
            ReadLn(f, s);

            { Czy komentarz? }
            if s = '' then Continue;
            if s[1]='#' then Continue;
            if s[1]='[' then Continue;

            { Wpis }
            SetLength(Fixes, Length(Fixes) +1);
            Fixes[High(Fixes)]:= s;
          end;
        CloseFile(f);
      except
        Showmessage('Nieznany b³¹d w trakcie odczytu pliku FixesData.txt. Program koñczy dzia³anie.');
        Equal(1, '');
      end;
    end else
      begin
        Showmessage('Nie znaleziono pliku ze wzorami - FixesData.txt. Program koñczy dzia³anie.');
        Equal(3, 'Brakuj¹cy plik ze wzorami.');
      end;

  { Dodajemy pusty element, ¿eby szukanie mia³o jak okreœliæ brak wzorów }
  { Chyba sobiebez tego poradzi... Na pewno :) }
//  SetLength(Fixes, Length(Fixes) +1);
//  Fixes[High(Fixes)]:= '';

  { £adujemy s³ownik }
  if FileExists(ExtractFileDir(Application.ExeName)+'\glossary.txt') then
    begin
      SetLength(glSymbols, 0);
      SetLength(glWords, 0);
      AssignFile(f, ExtractFileDir(Application.ExeName)+'\glossary.txt');
      try
        Reset(f);

        { Odczyt informacji o wersji s³ownika }
        if not eof(f) then
            ReadLn(f, GlossaryBaseVer)
        else GlossaryBaseVer:= 'GLOSS_EMPTY';

        { Odczyt w³aœciwych wzorów }
        while not eof(f) do
          begin
            ReadLn(f, s);

            { Lest RangeCheckError }
            if High(s) < 4 then Continue;

            { Czy komentarz? }
            if s = '' then Continue;
            if s[1]='#' then Continue;
            if s[1]='[' then Continue;

            { Dopisujemy symbol }
            SetLength(glSymbols, Length(glSymbols) +1);
            glSymbols[High(glSymbols)]:= s[1];

            { I jego definicjê }
            SetLength(glWords, Length(glWords) +1);
            Delete(s, 1, 2);
            glWords[High(glWords)]:= s;
          end;
        CloseFile(f);

        { Wpisz wszystko do listy danych }
        for i:= 0 to High(glWords) do
          begin
            FixesList.Items.Add(glWords[i]);
            SearchedEd.Items.Add(glWords[i]);
          end;

        { Pozwól, aby szukana by³a wybierana, a nie wpisywana }
        SearchedEd.Style:= csDropDown;
      except
        PanelNoGlossary.Visible:= True;
      end;
      PanelGlossary.Visible:= True;
    end else PanelNoGlossary.Visible:= True;
end;

procedure TForm1.Wyczy1Click(Sender: TObject);
begin
  KnownVList.Items.Clear;
  DelSelVBtn.Visible:= False;
end;

procedure TForm1.Usuzaznaczony1Click(Sender: TObject);
begin
  KnownVList.DeleteSelected;
  DelSelVBtn.Visible:= False;
end;

procedure TForm1.btnDetailsClick(Sender: TObject);
begin
  WynikMemo.Visible:= True;
  btnDetails.Visible:= False;
end;

procedure TForm1.btnHelpClick(Sender: TObject);
begin
//  Form2.ShowModal;
  PopupHelp.Popup(Form1.Left+ BtnHelp.Left, Form1.Top+ Form1.Width- BtnHelp.Top -5);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  if ParamStr(1) = 'debugfile' then
//    begin
//      CloseFile(debugfile);
//      WinExec(PChar('notepad.exe "'+ExtractFileDir(ParamStr(0))+'\'+ParamStr(2)+'"'), SW_SHOWNORMAL);
//    end;
  AniBmp.Free;
end;

procedure TForm1.BtnBackClick(Sender: TObject);
begin
  WynikMemo.Lines.Clear;
  TheResult.Visible:= False;
  BtnBack.Visible:= False;
  BtnPolicz.Visible:= True;
end;

procedure TForm1.FixesListDblClick(Sender: TObject);
begin
  { Dodanie wzoru do listy }
  KnownVList.Items.Add(Translate(FixesList.Items[FixesList.ItemIndex]));
end;

procedure TForm1.ArrowImgBlueClick(Sender: TObject);
begin
  if FixesList.ItemIndex <> -1 then
    KnownVList.Items.Add(Translate(FixesList.Items[FixesList.ItemIndex]));
end;

procedure TForm1.SearchedEdChange(Sender: TObject);
begin
  if SearchedEd.Style = csDropDown then
  if SearchedEd.Text <> '' then
  if Translate(SearchedEd.Text) <> #0 then
  lTrans.Caption:= SearchedEd.Text +', czyli ' +Translate(SearchedEd.Text)+'.';
end;

procedure TForm1.FixesListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  { Mechanizma Drag and Drop - pocz¹tek przeci¹gania }
  if Button = mbLeft then FixesList.BeginDrag(False);
end;

procedure TForm1.KnownVListDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  { Mechanizma Drag and Drop - pozwalamy na upuszczenie }
  if Source = FixesList then Accept:= True;
end;

procedure TForm1.KnownVListDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  { Mechanizma Drag and Drop -  przyjêcie wpisu }
  if Source = FixesList then
    KnownVList.Items.Add(Translate(FixesList.Items[FixesList.ItemIndex]));
end;

procedure TForm1.BtnCancelClick(Sender: TObject);
begin
  ThrSearchHnd.Terminate;
  Equal(-1, 'Przerwane na ¿yczenie u¿ytkownika.');
end;

procedure TForm1.TimerAnimationTimer(Sender: TObject);
begin
  { Piszemy napis o wybranym stopniu œciemnienia }
  AniBmp.Canvas.Font.Color:= trunc(AniI * r)+trunc(AniI * g) * 256 + trunc(AniI * b) * 256 * 256;
  AniBmp.Canvas.TextOut(AniX, AniY, AniStuffText);
  AniI:= AniI -1;

  if AniI = 0 then
    begin
      AniStuffText:= Fixes[random(High(Fixes))];
//      SetBKMode(AniBmp.Canvas.Handle, TRANSPARENT);
      AniX:= random(AniBmp.Width -200);
      AniY:= random(AniBmp.Height -50);
      AniI:= JMPCOUNT;
    end;

  AnimatedStuff.Canvas.Draw(0, 0, AniBmp);
end;

procedure TForm1.Oprogramie1Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.Stronainternetowa1Click(Sender: TObject);
begin
  ShellExecute(handle, 'open', 'http://www.frozenfire.republika.pl', nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.Szybkapomoc1Click(Sender: TObject);
begin
  ShellExecute(handle, 'open', 'http://www.frozenfire.republika.pl/help/help0.htm', nil, nil, SW_SHOWNORMAL);
end;

end.
