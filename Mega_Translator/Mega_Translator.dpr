program Mega_Translator;

uses
  Forms,
  MainForm_Unit in 'MainForm_Unit.pas' {MainForm},
  Dictionary_Unit in 'Dictionary_Unit.pas' {DictionaryForm},
  About_Unit in 'About_Unit.pas' {AboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Mega Translator';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDictionaryForm, DictionaryForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
