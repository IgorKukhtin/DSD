program Configurator;



{$R *.dres}

uses
  Vcl.Forms,
  RDBDataModule in 'RDBDataModule.pas' {RDB: TDataModule},
  FormDumpRestore in 'FormDumpRestore.pas' {DumpRestoreForm},
  Common in 'Common.pas',
  RDBClass in 'RDBClass.pas',
  RDBGrid in 'RDBGrid.pas',
  MainUnit in 'MainUnit.pas' {MainForm},
  FrameMapTable in 'Frames\FrameMapTable.pas' {MapFrame: TFrame},
  FormScripts in 'FormScripts.pas' {ScriptsForm},
  GenData in 'GenData.pas',
  FrameList in 'Frames\FrameList.pas' {ListFrame: TFrame},
  RDBGridProvider in 'RDBGridProvider.pas',
  FrameSchema in 'Frames\FrameSchema.pas' {SchemaFrame: TFrame},
  FormWizard in 'FormWizard.pas' {WizardForm},
  FrameTable in 'Frames\FrameTable.pas' {TableFrame: TFrame},
  FormMapResult in 'FormMapResult.pas' {MapResultForm},
  MinJobs in 'MinJobs.pas';

{$R *.res}



begin
  //ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TRDB, RDB);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TScriptsForm, ScriptsForm);
  Application.CreateForm(TWizardForm, WizardForm);
  Application.CreateForm(TMapResultForm, MapResultForm);
  Application.Run;

end.
