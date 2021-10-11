unit MainForm_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, ExtCtrls, XPMan, clipbrd, IniFiles;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    DictionaryList: TListBox;
    TranslateBox: TGroupBox;
    Word: TEdit;
    ConsistBox: TGroupBox;
    ResultBox: TGroupBox;
    Result: TPanel;
    XPManifest: TXPManifest;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure WordChange(Sender: TObject);
    procedure DictionaryListClick(Sender: TObject);
  private
    { Private declarations }
  public
      function SearchTranslate(str: string): string;
    { Public declarations }
  end;

var
  MainForm: TMainForm;


implementation

uses Dictionary_Unit, About_Unit;

{$R *.dfm}


procedure TMainForm.DictionaryListClick(Sender: TObject);
begin
    Result.Caption := SearchTranslate(DictionaryList.Items.Strings[DictionaryList.ItemIndex]);
end;


procedure TMainForm.N3Click(Sender: TObject); // ������ [� ���������]
begin
    AboutForm.Show;
end;


procedure TMainForm.N4Click(Sender: TObject); // ������ ������ �������
begin
    DictionaryForm.Show;
end;


procedure TMainForm.N5Click(Sender: TObject); // ������ �������� �����
begin
    MainForm.Close;
end;


procedure TMainForm.WordChange(Sender: TObject);
begin
    Result.Caption := SearchTranslate(Word.Text); // ���� ������� ���������
end;


function TMainForm.SearchTranslate(str: string): string; // ������� ����� ��������
var
  keyword:string;
  row:integer;
begin
try
    str:=Trim(str); // ������� ������� ������ � �����, ���� ��� �������

    if (str = '') then // ���� ������ �� �������
        begin
            Result := '������� �����...';
            Exit;
        end;

    DictionaryList.Perform(LB_SELECTSTRING,-1,Longint(PChar(Str))); // ��������� ���������� �������� �����

    DictionaryForm.Dictionary.FindRow(LowerCase(Str),row); // ���� ����� � �������
    if (LowerCase(Str)) = LowerCase(DictionaryForm.Dictionary.Keys[row]) then
        begin
            keyword:= DictionaryForm.Dictionary.Keys[row];
            str:=     DictionaryForm.Dictionary.Values[keyword];
            Result:=  str // ���� ��� �������, �� ������� ��������
        end
        else
            Result := '������� �� ������';
except
end;
end;

end.
