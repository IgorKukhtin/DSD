unit LoadingFarmacyCash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, Registry, StrUtils,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, dsdDB, DB,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, cxClasses, cxPropertiesStore,  dxSkinsCore,
  dxSkinsDefaultPainters, Vcl.ComCtrls, cxProgressBar, ZConnection, cxMemo,
  System.IOUtils;

type


  TLoadingFarmacyCashForm = class(TForm)
    Timer: TTimer;
    Panel1: TPanel;
    cxMemo1: TcxMemo;
    btnOk: TcxButton;
    btnCancel: TcxButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    FPath : string;
  public
    { Public declarations }
  end;

implementation

uses UtilConst, CommonData, ZStoredProcedure, FormStorage, UnilWin, Updater;

{$R *.dfm}

  {TLoadingFarmacyCashForm}

procedure TLoadingFarmacyCashForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  try

    if ModalResult = mrOk then
    begin

      if FileExists (FPath + 'FarmacyCash.exe') then
      begin
        if MessageDlg('Файл FarmacyCash.exe существует.'#13#13'Заменить?', mtConfirmation, mbYesNo, 0) <> mrYes then Exit;
      end;

      cxMemo1.Lines.Add('Загружаем FarmacyCash.exe');
      Application.ProcessMessages;
      TUpdater.AutomaticDownloadFarmacyCash(FPath);

      cxMemo1.Lines.Add('Загружаем FarmacyCashServise.exe');
      Application.ProcessMessages;
      TUpdater.AutomaticDownloadFarmacyCashServise(FPath);

      ShowMessage('Файлы FarmacyCash.exe и FarmacyCashServise.exe скопированы.');
    end;

  finally
    Action := TCloseAction.caFree;
  end;
end;

procedure TLoadingFarmacyCashForm.FormCreate(Sender: TObject);
begin
  Timer.Enabled := True;
end;

procedure TLoadingFarmacyCashForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;

  try

    FPath := ExpandFileName('..\..\Project Cash\Bin\');
    if not TDirectory.Exists(FPath) then
      if TDirectory.Exists(ExpandFileName('..\..\ProjectCash\Bin\')) then FPath := ExpandFileName('..\..\ProjectCash\Bin\');

    if not TDirectory.Exists(FPath) then
    begin
      ShowMessage('Проверьте путь ' + FPath + 'FarmacyCash.exe.');
      ModalResult := mrCancel;
    end else btnOk.Enabled := True;
  finally
  end;
end;

initialization
  RegisterClass(TLoadingFarmacyCashForm);

end.
