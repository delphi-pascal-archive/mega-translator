unit Dictionary_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, ValEdit, ComCtrls, XPMan, Menus, IniFiles;

type
  TDictionaryForm = class(TForm)
    DictionaryBox: TGroupBox;
    Dictionary: TValueListEditor;
    Save: TBitBtn;
    Load: TBitBtn;
    Bevel: TBevel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    InfoBox: TGroupBox;
    FilePath: TLabeledEdit;
    DeleteButton: TBitBtn;
    Label1: TLabel;
    CountOfWords: TPanel;
    SortBox: TCheckBox;
    WordBox: TGroupBox;
    English: TLabeledEdit;
    Russian: TLabeledEdit;
    Add: TBitBtn;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel1: TBevel;
    ShowBtn: TBitBtn;
    procedure LoadClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DictionaryStringsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SortBoxClick(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);

  private
    { Private declarations }
  public
    procedure Loading; // загрузка программы
    procedure Saving;  // сохранение последнего состояния программы
    procedure RefreshDictionaryList; // обновление листа слов словаря в главном окне
    function GetSubStr(st:string; expl:string; n:integer):string; // взятие подстроки
    procedure Expand; // развёртывание формочки добавления новых слов сбоку
    procedure Gather; // свёртывание формочки добавления новых слов сбоку
    { Public declarations }
  end;

var
  DictionaryForm: TDictionaryForm;
  Ini: TIniFile;

implementation

uses MainForm_Unit;

{$R *.dfm}

procedure TDictionaryForm.DeleteButtonClick(Sender: TObject);
var
Selected:integer;
begin
  Selected:=MessageDlgPos('Очистить путь?',mtInformation,[mbOk,mbCancel],0,(DictionaryForm.Left+Trunc(DictionaryForm.Width/2)),(DictionaryForm.Top+Trunc(DictionaryForm.Height/2)));
  if Selected=MrOk then FilePath.Text:='';
end;


procedure TDictionaryForm.DictionaryStringsChange(Sender: TObject);
begin
    DictionaryForm.CountOfWords.Caption:=IntToStr(DictionaryForm.Dictionary.Strings.Count); // выводим количество слов в словаре
    RefreshDictionaryList;
end;

procedure TDictionaryForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Saving;
end;

procedure TDictionaryForm.FormCreate(Sender: TObject);
begin
    Loading;
end;

procedure TDictionaryForm.LoadClick(Sender: TObject);
var
i:integer;
begin
    OpenDialog.Execute;
        if FileExists(OpenDialog.FileName) then // если файл cуществует, то...
          begin
              Dictionary.Strings.LoadFromFile(OpenDialog.FileName);
              FilePath.Text:=OpenDialog.FileName;
              DictionaryForm.CountOfWords.Caption:=IntToStr(DictionaryForm.Dictionary.Strings.Count); // выводим количество слов в словаре

                MainForm.DictionaryList.Items.Clear;
                for i:=1 to DictionaryForm.Dictionary.Strings.Count do
                MainForm.DictionaryList.Items.Add(DictionaryForm.Dictionary.Cells[0,i]);
                // ListBox на MainForm заполняем английскими словами из словаря
          end;
end;

procedure TDictionaryForm.N2Click(Sender: TObject);
begin
Expand;
end;

procedure TDictionaryForm.N6Click(Sender: TObject);
begin
    DictionaryForm.Close;
end;

procedure TDictionaryForm.OKClick(Sender: TObject);
begin
    DictionaryForm.Close;
end;

procedure TDictionaryForm.SaveClick(Sender: TObject);
begin
    SaveDialog.Execute;
    if SaveDialog.FileName<>'' then // если файл сохранился, то...
      begin
        Dictionary.Strings.SaveToFile(SaveDialog.FileName+'.txt');
        FilePath.Text:=SaveDialog.FileName+'.txt';
      end;
end;


procedure TDictionaryForm.SortBoxClick(Sender: TObject);
var
MyList:TStringList;
Selected,i:integer;
begin
if SortBox.Checked=True then
  begin
    Selected:=MessageDlgPos('Произвести сортировку словаря?',mtInformation,[mbOk,mbCancel],0,(DictionaryForm.Left+Trunc(DictionaryForm.Width/2)),(DictionaryForm.Top+Trunc(DictionaryForm.Height/2)));
    if Selected=MrOk then
      Begin
        MyList:=TStringList.Create;
        MyList.Clear;
            for i:=1 to Dictionary.Strings.Count do
            MyList.Append((Dictionary.Keys[i])+'='+(Dictionary.Values[(Dictionary.Keys[i])])); // формируем список в виде ключ=значение
        MyList.Sorted:=True; // сортируем его
        Dictionary.Strings.Clear; // очищаем словарь для дальнейшего перезаполнения

            for i := 0 to MyList.Count-1 do // возвращаем отсортированный список обратно в словарь
            Dictionary.InsertRow(GetSubStr(MyList.Strings[i],'=',1),GetSubStr(MyList.Strings[i],'=',2),true);
            RefreshDictionaryList;
      End;
  end;
end;


procedure TDictionaryForm.ShowBtnClick(Sender: TObject);
begin
  Case ShowBtn.Tag of
    0:  begin
      Expand;
      ShowBtn.Tag:=1;
      Exit;
        end;
    1:  begin
      Gather;
      ShowBtn.Tag:=0;
      Exit;
        end;
  end;
end;


//////////////////Ниже созданные функции и процедуры//////////////////////


function TDictionaryForm.GetSubStr(st:string; expl:string; n:integer):string; // функция взятия подстроки для сортировки словаря
Var p,i:integer;
Begin
  for i:= 1 to n-1 do
    begin
      p:=pos(expl,st);
      st:=copy(st,p+1,Length(st)-p);
      while (pos(expl,st)=1) and (length(st)>0) do delete(st,1,1);
    end;
  p:=pos(expl,st);
  if p<>0 then result:=copy(st,1,p-1)
  else result:=st;
end;


procedure TDictionaryForm.RefreshDictionaryList;
var
i:integer;
begin
    MainForm.DictionaryList.Items.Clear;
    for i := 1 to DictionaryForm.Dictionary.Strings.Count do
    MainForm.DictionaryList.Items.Add(DictionaryForm.Dictionary.Cells[0,i]);
   // ListBox на MainForm заполняем английскими словами из словаря
end;


procedure TDictionaryForm.Saving;
var
  Path:string;
begin
  Path:=FilePath.Text; // Путь файла
  Ini.WriteString('Dictionary','FilePath',Path); // строка пути файла

  if (FileExists(Path)) then Dictionary.Strings.SaveToFile(Path) else
  if (FilePath.Text<>'') then MessageDlg('По заданному пути файл отсутствует'+#13+'Сохраните файл заново...',mtWarning,[mbOk],0);
end;


procedure TDictionaryForm.Loading;
var
  ReadString:string;
begin
  ReadString:=Ini.ReadString('Dictionary','FilePath',DictionaryForm.FilePath.Text);
  DictionaryForm.FilePath.Text:=ReadString; // строка пути файла
  if (ReadString<>'') then DictionaryForm.Dictionary.Strings.LoadFromFile(Ini.ReadString('Dictionary','FilePath',DictionaryForm.FilePath.Text)) else MessageDlg('Не найдено файла словаря',mtWarning,[mbOk],0);; // если в пути файла не пусто загружаем из файла словарь
  DictionaryForm.CountOfWords.Caption:=IntToStr(DictionaryForm.Dictionary.Strings.Count); // количество слов в словаре
end;


Procedure TDictionaryForm.Expand; // процедура развёртывания окна добавления слов в словарь
var A,B:HRgn;
    i:integer;
begin
  A:=CreateRectRgn(0,0,565,494);
  B:=CreateRectRgn(343,141,565,494);
  CombineRgn(A,A,B,Rgn_DIFF);
  SetWindowRgn(Handle,A,False);
  With ShowBtn do
    begin
      Kind:=bkCancel;
      Caption:='&Скрыть';
      Enabled:=False;
    end;
  for i := 1 to 37 do
    begin
      DictionaryForm.Width:=DictionaryForm.Width+6;
      Sleep(15);
      Application.ProcessMessages;
    end;
  ShowBtn.Enabled:=True;
  DictionaryForm.Repaint;
end;

procedure TDictionaryForm.Gather; // процедура свертывания окна добавления слов в словарь
var
i:integer;
begin
With ShowBtn do
  begin
    Kind:=bkOk;
    Caption:='&Показать';
    Enabled:=False;
  end;
for i := 37 downto 1 do
  begin
    DictionaryForm.Width:=DictionaryForm.Width-6;
    Sleep(15);
    Application.ProcessMessages;
  end;
ShowBtn.Enabled:=True;
SetWindowRgn(Handle,0,True); // делаем окно обычным
DictionaryForm.Repaint;
end;



Initialization
  Ini:=TIniFile.Create(extractfilepath(paramstr(0))+'Settings.ini');


Finalization
  Ini.Free;



end.
