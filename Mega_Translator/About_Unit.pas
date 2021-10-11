unit About_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, XPMan, ComCtrls, ExtCtrls;

type
  TAboutForm = class(TForm)
    AboutLabel: TLabel;
    OK: TBitBtn;
    XPManifest: TXPManifest;
    Timer: TTimer;
    procedure OKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

procedure TAboutForm.FormShow(Sender: TObject);
begin
  AboutLabel.Visible:=False;
  OK.Visible:=False;
  Timer.Enabled:=True;
end;

procedure TAboutForm.OKClick(Sender: TObject);
begin
AboutForm.Close;
end;

procedure TAboutForm.TimerTimer(Sender: TObject); // появление надписи "О программе" с эффектом печатания
var
i:integer;
s:string;
begin
  Timer.Enabled:=False;
  s:=AboutLabel.Caption;
  AboutLabel.Caption:='';
  AboutLabel.Visible:=True;
  for i := 1 to Length(s) do
    begin
      AboutLabel.Caption:=AboutLabel.Caption+s[i];
      Sleep(20);
      Application.ProcessMessages;
    end;
  Sleep(250);
  OK.Visible:=True;
end;

end.
