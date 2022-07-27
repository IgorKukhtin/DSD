unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Win.ComObj, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, System.RegularExpressions,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxSpinEdit, Vcl.StdCtrls,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxPC, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, IniFiles,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.ActnList, IdText, IdSSLOpenSSL, IdGlobal, strUtils, IdAttachmentFile,
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  cxImageComboBox, cxNavigator, System.JSON,
  cxDataControllerConditionalFormattingRulesManagerDialog, ZStoredProcedure,
  dxDateRanges, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, dsdAction, System.Actions, dsdDB;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    Panel2: TPanel;
    btnAll: TButton;
    btnDownloadPublished: TButton;
    Panel3: TPanel;
    spSite_Param: TdsdStoredProc;
    spUpdate_PublishedSite: TdsdStoredProc;
    ActionList1: TActionList;
    actSite_Param: TdsdExecStoredProc;
    actUpdate_PublishedSite: TdsdExecStoredProc;
    actFD_DownloadPublishedSite: TdsdForeignData;
    FormParams: TdsdFormParams;
    procedure btnAllClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnDownloadPublishedClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    APIUser: String;
    APIPassword: String;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.Add_Log(AMessage: String);
var
  F: TextFile;

begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'.log')) then
      Rewrite(F)
    else
      Append(F);
  try
    if Pos('----', AMessage) > 0 then Writeln(F, AMessage)
    else Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now) + ' - ' + AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

procedure TMainForm.btnAllClick(Sender: TObject);
begin
  Add_Log('-----------------');
  Add_Log('Запуск процессов загрузки.'#13#10);

  btnDownloadPublishedClick(Sender);

  Add_Log('Выполнено.');
end;

procedure TMainForm.btnDownloadPublishedClick(Sender: TObject);
begin
  try
    actFD_DownloadPublishedSite.ShowGaugeForm := Application.ShowMainForm;
    actFD_DownloadPublishedSite.Execute;
  except
    on E:Exception do
    begin
        Add_Log('Ошибка: ' + E.Message{+ actFD_DownloadPublishedSite.JsonParam.Value});
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
  begin
    Application.ShowMainForm := False;
    btnAll.Enabled := false;
    btnDownloadPublished.Enabled := false;
    Timer1.Enabled := true;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    Timer1.Enabled := False;
    btnAllClick(Sender);
  finally
    Close;
  end;
end;

end.
