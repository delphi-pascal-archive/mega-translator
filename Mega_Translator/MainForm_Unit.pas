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


procedure TMainForm.N3Click(Sender: TObject); // кнопка [О программе]
begin
    AboutForm.Show;
end;


procedure TMainForm.N4Click(Sender: TObject); // кнопка вызова словаря
begin
    DictionaryForm.Show;
end;


procedure TMainForm.N5Click(Sender: TObject); // кнопка закрытия формы
begin
    MainForm.Close;
end;


procedure TMainForm.WordChange(Sender: TObject);
begin
    Result.Caption := SearchTranslate(Word.Text); // ищем перевод введённого
end;


function TMainForm.SearchTranslate(str: string): string; // функция поиск перевода
var
  keyword:string;
  row:integer;
begin
try
    str:=Trim(str); // убираем пробелы справа и слева, если они введены

    if (str = '') then // если ничего не введено
        begin
            Result := 'Введите слово...';
            Exit;
        end;

    DictionaryList.Perform(LB_SELECTSTRING,-1,Longint(PChar(Str))); // выделение ближайшего похожего слова

    DictionaryForm.Dictionary.FindRow(LowerCase(Str),row); // ищем слово в словаре
    if (LowerCase(Str)) = LowerCase(DictionaryForm.Dictionary.Keys[row]) then
        begin
            keyword:= DictionaryForm.Dictionary.Keys[row];
            str:=     DictionaryForm.Dictionary.Values[keyword];
            Result:=  str // если его находим, то выводим значение
        end
        else
            Result := 'Перевод не найден';
except
end;
end;

end.
