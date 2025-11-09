unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellApi;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelWebpage: TLabel;
    LabelEmail: TLabel;
    OK: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    Label5: TLabel;
    Label6: TLabel;
    procedure LabelEmailClick(Sender: TObject);
    procedure LabelWebpageClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

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

end.
