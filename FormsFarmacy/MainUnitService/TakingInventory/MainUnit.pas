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
  Data.Bind.ObjectScope, dsdAction, System.Actions, dsdDB, Datasnap.DBClient;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    Panel2: TPanel;
    btnAll: TButton;
    btnOpenIncome: TButton;
    Panel3: TPanel;
    ActionList1: TActionList;
    FormParams: TdsdFormParams;
    spSelectUnloadMovement: TdsdStoredProc;
    MasterCDS: TClientDataSet;
    MasterDS: TDataSource;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    btnSendIncome: TButton;
    actSelectUnloadMovement: TdsdExecStoredProc;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    Password: TcxGridDBColumn;
    procedure btnAllClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSendIncomeClick(Sender: TObject);
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

uses DiscountService;

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
  Add_Log('Запуск отправки приходов.'#13#10);

  actSelectUnloadMovement.Execute;

  MasterCDS.First;
  while not MasterCDS.Eof do
  begin
    btnSendIncomeClick(Sender);
    MasterCDS.Next;
  end;

  Add_Log('Выполнено.');
end;

procedure TMainForm.btnSendIncomeClick(Sender: TObject);
  var Msg : String;
begin
  Add_Log(MasterCDS.FieldByName('InvNumber').AsString + ' от ' +
          MasterCDS.FieldByName('OperDate').AsString + ' ' +
          MasterCDS.FieldByName('ToName').AsString);

  DiscountServiceForm.fPfizer_SendMovement (MasterCDS.FieldByName('URL').AsString
                                          , MasterCDS.FieldByName('Service').AsString
                                          , MasterCDS.FieldByName('Port').AsString
                                          , MasterCDS.FieldByName('UserName').AsString
                                          , MasterCDS.FieldByName('Password').AsString
                                          , MasterCDS.FieldByName('MovementId').AsInteger
                                          , MasterCDS.FieldByName('OperDate').AsDateTime
                                          , MasterCDS.FieldByName('InvNumber').AsString
                                          , MasterCDS.FieldByName('FromOKPO').AsString
                                          , MasterCDS.FieldByName('FromName').AsString
                                          , MasterCDS.FieldByName('ToOKPO').AsString
                                          , MasterCDS.FieldByName('ToName').AsString
                                          , Msg);

  if Msg <> '' then Add_Log('Ошибка: ' + Msg)
  else Add_Log('Отравлен.');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
  begin
    Application.ShowMainForm := False;
    btnAll.Enabled := false;
    btnOpenIncome.Enabled := false;
    btnSendIncome.Enabled := false;
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
