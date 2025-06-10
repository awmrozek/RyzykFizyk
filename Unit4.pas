unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg;

type
  TFormHelp = class(TForm)
    Label1: TLabel;
    HelpMemoDane: TMemo;
    Label2: TLabel;
    Image1: TImage;
    Label3: TLabel;
    HelpMemoSzukane: TMemo;
    Image2: TImage;
    Label4: TLabel;
    HelpMemoGotowe: TMemo;
    PanelHelpError: TPanel;
    Label5: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label6: TButton;
    procedure Label6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormHelp: TFormHelp;

implementation

{$R *.dfm}

procedure TFormHelp.FormCreate(Sender: TObject);
var i : integer;
begin
  try
   { Czy za³¹dowaæ inne opisy? }
   { Dla HelpMemoDane }
   if FileExists(ExtractFileDir(Application.ExeName)+'\HelpMemoDane.txt') then
     HelpMemoDane.Lines.LoadFromFile(ExtractFileDir(Application.ExeName)+'\HelpMemoDane.txt');

   { Dla HelpMemoSzukane }
   if FileExists(ExtractFileDir(Application.ExeName)+'\HelpMemoSzukane.txt') then
     HelpMemoSzukane.Lines.LoadFromFile(ExtractFileDir(Application.ExeName)+'\HelpMemoSzukane.txt');

   { Dla HelpMemoGotowe }
   if FileExists(ExtractFileDir(Application.ExeName)+'\HelpMemoGotowe.txt') then
     HelpMemoGotowe.Lines.LoadFromFile(ExtractFileDir(Application.ExeName)+'\HelpMemoGotowe.txt');
  except
   PanelHelpError.Visible:= True;
  end;
end;

procedure TFormHelp.Label6Click(Sender: TObject);
begin
  Close;
end;

end.
