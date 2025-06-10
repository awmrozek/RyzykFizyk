unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellApi;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    LabelVersion: TLabel;
    Label4: TLabel;
    LabelWebpage: TLabel;
    LabelEmail: TLabel;
    OK: TButton;
    Image1: TImage;
    Bevel1: TBevel;
    Label5: TLabel;
    Image2: TImage;
    TimerEgg: TTimer;
    PaintBoxEgg: TPaintBox;
    PanelStandardInfo: TPanel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EggControlLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerEggTimer(Sender: TObject);
    procedure LabelEmailClick(Sender: TObject);
    procedure LabelWebpageClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
  private
    Eggc , EggI : integer;  { KolorBtnFace, stopieñ œciemnienia }
    Eggr, Eggg, Eggb : double;
  public
    EggBmp : TBitmap;
    EggX, EggY : integer;
    EggStuffText : string; { Aktualnie wyœwietlany tekst }
    EggList : array of string; { Lista wszystkich wpisów w pliku }
    EggInd : integer; { Index aktualnie wyœwietlanego tekstu }
//    EggRndOf : integer; { szerokoœæ tekstu w pixelach, tak, ¿eby nie wycodzi³ poza ekran }

    EggEnabled : Boolean;
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.OKClick(Sender: TObject);
begin
  Close;
end;

procedure TForm2.LabelWebpageClick(Sender: TObject);
begin
  ShellExecute(handle, 'open', 'http://www.frozenfire.republika.pl', nil, nil, SW_SHOWNORMAL);
end;

procedure TForm2.LabelEmailClick(Sender: TObject);
begin
  ShellExecute(handle, 'open', 'mailto:mrozekss@gmail.com', nil, nil, SW_SHOWNORMAL);
end;

procedure TForm2.TimerEggTimer(Sender: TObject);
begin
  { Inicjalizacja nowego napisu, jeœli trzeba }
  if EggI = 0 then
    begin
      Inc(EggInd);

      if EggInd = Length(EggList) then
        begin
          TimerEgg.Enabled:= False;
          Exit;
        end;

      EggControlLabel.Caption:= EggList[EggInd];
      EggX:= random(EggBmp.Width -EggControlLabel.Width);
      EggY:= random(EggBmp.Height -20);
      EggI:= JMPCOUNT;
    end;

  {Piszemy napis o wybranym stopniu œciemnienia }
  EggBmp.Canvas.Font.Color:= trunc(EggI * Eggr)+trunc(EggI * Eggg) * 256 + trunc(EggI * Eggb) * 256 * 256;
  EggBmp.Canvas.TextOut(EggX, EggY, EggList[EggInd]);
  PaintBoxEgg.Canvas.Draw(0, 0, EggBmp);
  EggI:= EggI -1;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerEgg.Enabled:= False;
  EggBmp.Free;
end;

procedure TForm2.FormShow(Sender: TObject);
var
  f : TextFile;
begin
  EggBmp:= TBitmap.Create;
  if EggEnabled then
    begin
      if FileExists(ExtractFileDir(Application.ExeName)+'\wxsData.dat') then
        begin
          AssignFile(f, ExtractFileDir(Application.ExeName)+'\wxsData.dat');
          SetLength(EggList, 0);
          try
            Reset(f);
            while not eof(f) do
              begin
                ReadLn(f, EggStuffText);
                SetLength(EggList, Length(EggList)+1);
                EggList[High(EggList)]:= EggStuffText;
              end;
            CloseFile(f);
          except
            EggEnabled:= False;
            Exit;
          end;
        end;

      { Nowy du¿y tytu³ aplikacji }
      Label1.Caption:= EggList[0];

      { Wartoœci pocz¹tkowe dla bitmapy }
      EggBmp.Canvas.Brush.Color:= clBtnFace;
      EggBmp.Width:= PaintBoxEgg.Width;
      EggBmp.Height:= PaintBoxEgg.Height;

      Eggc:= ColorToRGB(Form1.Color);
      Eggr:= ($FF and Eggc)/JMPCOUNT;
      Eggg:= ($FF and (Eggc div 256))/JMPCOUNT;
      Eggb:= ($FF and (Eggc div 256 div 256))/JMPCOUNT;

      EggBmp.Canvas.Font.Size:= 9;
      EggBmp.Canvas.Font.Name:= 'Verdana';
      EggControlLabel.Font.Size:= 9;
      EggControlLabel.Font.Name:= 'Verdana';

      EggInd:= 0;   { Bo 0 to nowy tytu³, autoinc. ptrzy timerze }
      PanelStandardInfo.Visible:= False;
      TimerEgg.Enabled:= True;
    end;
end;

procedure TForm2.Image1DblClick(Sender: TObject);
begin
  EggEnabled:= True;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  { Czytamy informacje o wersji }
  LabelVersion.Caption:= 'Wersja '+PRODUCTVERSION+'.FIX:'+FixesBaseVer+'.GLS:'+GlossaryBaseVer;
end;

end.
