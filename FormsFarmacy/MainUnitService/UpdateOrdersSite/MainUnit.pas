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
  Data.Bind.ObjectScope, dsdAction, System.Actions, dsdDB, cxDateUtils,
  Datasnap.DBClient, DataModul;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    Panel2: TPanel;
    btnAll: TButton;
    btnSelect_UpdateOrdersSite: TButton;
    Panel3: TPanel;
    spSite_Param: TdsdStoredProc;
    ActionList: TActionList;
    actSite_Param: TdsdExecStoredProc;
    FormParams: TdsdFormParams;
    deStartDate: TcxDateEdit;
    spSelect_UpdateOrdersSite: TdsdStoredProc;
    actSelect_UpdateOrdersSite: TdsdExecStoredProc;
    cxGridUpdateOrdersSiteDBTableView1: TcxGridDBTableView;
    cxGridUpdateOrdersSiteLevel1: TcxGridLevel;
    cxGridUpdateOrdersSite: TcxGrid;
    UpdateOrdersSiteCDS: TClientDataSet;
    UpdateOrdersSiteDS: TDataSource;
    cxGridUpdateOrdersSite_Id: TcxGridDBColumn;
    cxGridUpdateOrdersSite_InvNumber: TcxGridDBColumn;
    cxGridUpdateOrdersSite_OperDate: TcxGridDBColumn;
    cxGridUpdateOrdersSite_InvNumberOrder: TcxGridDBColumn;
    cxGridUpdateOrdersSite_UnitId: TcxGridDBColumn;
    cxGridUpdateOrdersSite_UnitName: TcxGridDBColumn;
    maDo: TMultiAction;
    btnDo: TButton;
    actDo: TAction;
    PharmOrdersDS: TDataSource;
    PharmOrdersCDS: TClientDataSet;
    actDoone: TAction;
    btnDoone: TButton;
    actPharmOrders: TdsdForeignData;
    cxGridPharmOrders: TcxGrid;
    cxGridPharmOrdersDBTableView1: TcxGridDBTableView;
    cxGridPharmOrdersLevel1: TcxGridLevel;
    cxGridPharmOrders_id: TcxGridDBColumn;
    cxGridPharmOrders_pharmacy_order_id: TcxGridDBColumn;
    cxGridPharmOrders_name: TcxGridDBColumn;
    cxGridPharmOrders_phone: TcxGridDBColumn;
    cxGridPharmOrders_inDateComing: TcxGridDBColumn;
    PharmOrderProductsDS: TDataSource;
    PharmOrderProductsCDS: TClientDataSet;
    cxGridPharmOrderProducts: TcxGrid;
    cxGridPharmOrderProductsDBTableView1: TcxGridDBTableView;
    cxGridPharmOrderProductsLevel1: TcxGridLevel;
    cxGridPharmOrderProducts_id: TcxGridDBColumn;
    cxGridPharmOrderProducts_drug_id: TcxGridDBColumn;
    cxGridPharmOrderProducts_drug_name: TcxGridDBColumn;
    cxGridPharmOrderProducts_type_order: TcxGridDBColumn;
    cxGridPharmOrderProducts_price: TcxGridDBColumn;
    cxGridPharmOrderProducts_quantity: TcxGridDBColumn;
    actPharmOrderProductsCDS: TdsdForeignData;
    procedure btnAllClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actDoExecute(Sender: TObject);
    procedure actDooneExecute(Sender: TObject);
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

procedure TMainForm.actDooneExecute(Sender: TObject);
begin
  try
    if actSite_Param.Execute then actDo.Execute;
  except
    on E:Exception do
    begin
        Add_Log('Ошибка: ' + E.Message);
    end;
  end;
end;

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
  Add_Log('Запуск обработки заазов.'#13#10);

  if actSelect_UpdateOrdersSite.Execute then  maDo.Execute;

  Add_Log('Выполнено.');
end;

procedure TMainForm.FormCreate(Sender: TObject);
var ini: TIniFile;
begin

  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try

    deStartDate.Date := ini.ReadDateTime('Data', 'DataUpdate', Date);
    ini.WriteDateTime('Data','DataUpdate',deStartDate.Date);

  finally
    ini.free;
  end;

  if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
  begin
    Application.ShowMainForm := False;
    btnAll.Enabled := false;
    btnSelect_UpdateOrdersSite.Enabled := false;
    btnDo.Enabled := false;
    btnDoone.Enabled := false;
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

procedure TMainForm.actDoExecute(Sender: TObject);
begin
  try

    // Заказ с сайта
    if not actPharmOrders.Execute then Exit;

    // Содержимое заказа с сайта
    if not actPharmOrderProductsCDS.Execute then Exit;

  except
    on E:Exception do
    begin
        Add_Log('Ошибка: ' + E.Message);
    end;
  end;
end;



end.
