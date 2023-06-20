unit MainInventoryUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Win.ComObj, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, System.RegularExpressions,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxSpinEdit, Vcl.StdCtrls, DataModul,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxPC, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, IniFiles,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.ActnList, IdText, IdSSLOpenSSL, IdGlobal, strUtils, IdAttachmentFile,
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  cxImageComboBox, cxNavigator, dxDateRanges, Data.Bind.Components,
  Data.Bind.ObjectScope, System.Actions, dsdDB, Datasnap.DBClient, dsdAction,
  AncestorBase, cxPropertiesStore, dsdAddOn, dxBarBuiltInMenu, cxDateUtils,
  Vcl.StdActns, Vcl.Buttons, cxButtons, dsdGuides;

type
  TMainInventoryForm = class(TAncestorBaseForm)
    Panel3: TPanel;
    MasterCDS: TClientDataSet;
    MasterDS: TDataSource;
    actDoLoadData: TAction;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    actLoadData: TMultiAction;
    actUnitChoice: TOpenChoiceForm;
    FormParams: TdsdFormParams;
    spGet_User_IsAdmin: TdsdStoredProc;
    mactCreteNewInvent: TMultiAction;
    actDataDialog: TExecuteDialog;
    N3: TMenuItem;
    N4: TMenuItem;
    actReCreteInventDate: TAction;
    actDoCreateInventory: TAction;
    actContinueInvent: TAction;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    PageControl: TcxPageControl;
    tsStart: TcxTabSheet;
    tsInventory: TcxTabSheet;
    cxGridChild: TcxGrid;
    cxGridChildDBTableView: TcxGridDBTableView;
    ChildisLast: TcxGridDBColumn;
    ChildNum: TcxGridDBColumn;
    ChildGoodsCode: TcxGridDBColumn;
    ChildGoodsName: TcxGridDBColumn;
    ChildAmount: TcxGridDBColumn;
    ChildUserName: TcxGridDBColumn;
    ChildDate_Insert: TcxGridDBColumn;
    cxGridChildLevel: TcxGridLevel;
    Panel1: TPanel;
    edBarCode: TcxTextEdit;
    ceAmount: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    ceAmountAdd: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edGoodsCode: TcxTextEdit;
    cxLabel7: TcxLabel;
    edGoodsName: TcxTextEdit;
    spSelectChilg: TdsdStoredProcSQLite;
    cxLabel1: TcxLabel;
    edOperDate: TcxDateEdit;
    ChildIsSend: TcxGridDBColumn;
    N10: TMenuItem;
    actExit: TAction;
    tsInfo: TcxTabSheet;
    Panel2: TPanel;
    cxLabel10: TcxLabel;
    edOperDateInfo: TcxDateEdit;
    edUnitNameInfo: TcxTextEdit;
    actInfoInvent: TAction;
    N11: TMenuItem;
    InfoDS: TDataSource;
    InfoCDS: TClientDataSet;
    spSelectInfo: TdsdStoredProcSQLite;
    cxGridInfo: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    InfoGoodsCode: TcxGridDBColumn;
    InfoGoodsName: TcxGridDBColumn;
    InfoRemains: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    actGoodsInventory: TOpenChoiceForm;
    cxButton1: TcxButton;
    actSetFocusededBarCode: TdsdSetFocusedAction;
    DBViewAddOnInfo: TdsdDBViewAddOn;
    DBViewAddOn: TdsdDBViewAddOn;
    InfoAmount: TcxGridDBColumn;
    actSendInventChild: TAction;
    N8: TMenuItem;
    mactSendInvent: TMultiAction;
    SendInventDS: TDataSource;
    SendInventCDS: TClientDataSet;
    spSendInvent: TdsdStoredProcSQLite;
    spInsert_MI_Inventory: TdsdStoredProc;
    actInsert_MI_Inventory: TdsdExecStoredProc;
    actUpdateSend: TAction;
    chAmountGoods: TcxGridDBColumn;
    edUnitName: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    HeaderSaver: THeaderSaver;
    spUpdateIventory: TdsdStoredProcSQLite;
    actSetFocusedAmount: TdsdSetFocusedAction;
    tsInventoryManual: TcxTabSheet;
    Panel4: TPanel;
    cxLabel11: TcxLabel;
    edOperDateManual: TcxDateEdit;
    cxButton2: TcxButton;
    edUnitNameManual: TcxButtonEdit;
    GuidesUnitManual: TdsdGuides;
    actContinueInventManual: TAction;
    N9: TMenuItem;
    HeaderSaverManual: THeaderSaver;
    spUpdateIventoryManual: TdsdStoredProcSQLite;
    cxGridManual: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    ManualGoodsCode: TcxGridDBColumn;
    ManualcxGoodsName: TcxGridDBColumn;
    ManualRemains: TcxGridDBColumn;
    ManualAmount: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    spSelectManual: TdsdStoredProcSQLite;
    ManualCDS: TClientDataSet;
    ManualDS: TDataSource;
    actShowAll: TBooleanStoredProcAction;
    actSetFocusedManualAmount: TdsdSetFocusedAction;
    actSetEditAmount: TAction;
    DBViewAddOnManual: TdsdDBViewAddOn;
    TextEdit: TcxTextEdit;
    FieldFilter: TdsdFieldFilter;
    InfoDeficit: TcxGridDBColumn;
    InfoProficit: TcxGridDBColumn;
    InfoDiffSumm: TcxGridDBColumn;
    InfoCountUser: TcxGridDBColumn;
    InfoExpirationDate: TcxGridDBColumn;
    InfoPrice: TcxGridDBColumn;
    InfoRemains_Summ: TcxGridDBColumn;
    InfoSumm: TcxGridDBColumn;
    InfoAmountUser: TcxGridDBColumn;
    InfoDeficitSumm: TcxGridDBColumn;
    InfoProficitSumm: TcxGridDBColumn;
    InfoMIComment: TcxGridDBColumn;
    InfoisAuto: TcxGridDBColumn;
    InfoDiff: TcxGridDBColumn;
    spUpdate_Comment: TdsdStoredProc;
    cxButton3: TcxButton;
    actRefreshItog: TAction;
    ManualPrice: TcxGridDBColumn;
    cxButton4: TcxButton;
    actInsert_InventoryCheck: TAction;
    InventoryCheckCDS: TClientDataSet;
    spInventoryCheck: TdsdStoredProc;
    InfoisCheck: TcxGridDBColumn;
    actSetFocusedInfoAmount: TdsdSetFocusedAction;
    spUnitComplInventFull: TdsdStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure ParentFormDestroy(Sender: TObject);
    procedure actDoLoadDataExecute(Sender: TObject);
    procedure actReCreteInventDateExecute(Sender: TObject);
    procedure actDoCreateInventoryExecute(Sender: TObject);
    procedure actContinueInventExecute(Sender: TObject);
    procedure edBarCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actCloseAllExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actInfoInventExecute(Sender: TObject);
    procedure edBarCodeDblClick(Sender: TObject);
    procedure actSendInventChildExecute(Sender: TObject);
    procedure actUpdateSendExecute(Sender: TObject);
    procedure actContinueInventManualExecute(Sender: TObject);
    procedure ManualCDSPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure actSetEditAmountExecute(Sender: TObject);
    procedure InfoCDSPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure InfoCDSBeforePost(DataSet: TDataSet);
    procedure InfoCDSAfterPost(DataSet: TDataSet);
    procedure actRefreshItogExecute(Sender: TObject);
    procedure actInsert_InventoryCheckExecute(Sender: TObject);
  protected
    procedure FormClose(Sender: TObject; var Action: TCloseAction); override;
  private
    { Private declarations }

    APIUser: String;
    APIPassword: String;
    procedure InsertBarCode;
  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
  end;

var
  MainInventoryForm: TMainInventoryForm;

implementation

{$R *.dfm}

uses UnilWin, CommonData, IniUtils, Splash, StorageSQLite;

procedure TMainInventoryForm.FormClose(Sender: TObject; var Action: TCloseAction);
 var OperDate: TDateTime; UnitName : String; isSave: boolean;
begin
  if  PageControl.ActivePage = tsStart then
  begin
    if ChechActiveInv(OperDate, UnitName, isSave) then
    begin
      if not isSave then
        case MessageDlg('По аптеке ' + #13#10 + UnitName + #13#10 + 'от ' +
          FormatDateTime('dd.mm.yyyy', OperDate) + #13#10'Не отправлены данные по инвентаризации' +
          #13#10#13#10'Yes - Выйти?' +
          #13#10#13#10'Ok - Отправить и выйти?', mtInformation, [mbYes, mbOK, mbCancel], 0) Of
            mrOk : actSendInventChildExecute(Sender);
            mrYes : ;
        else Action := caNone;
        end;
    end else if MessageDlg('Закрыть приложение?', mtInformation, mbOKCancel, 0) <> mrOk then Action := caNone;
  end else
  begin
    Action := caNone;
    InfoCDS.Close;
    MasterCDS.Close;
    ManualCDS.Close;
    PageControl.ActivePage := tsStart;
  end;

  if Action <> caNone then inherited;
end;

procedure TMainInventoryForm.actCloseAllExecute(Sender: TObject);
begin
  PageControl.ActivePage := tsStart;
  InfoCDS.Close;
  MasterCDS.Close;
  ManualCDS.Close;
end;

procedure TMainInventoryForm.actContinueInventExecute(Sender: TObject);
 var OperDate: TDateTime; UnitName : String; isSave: boolean;
     Params : TdsdParams;
begin

  if ChechActiveInv(OperDate, UnitName, isSave) then
  begin
    if isSave and (OperDate < IncDay(Date, - 3)) then
    begin
      ShowMessage('Инвентаризация не создана. С начало создайте ее');
      Exit;
    end;
  end else
  begin
    ShowMessage('Инвентаризация не создана. С начало создайте ее');
    Exit;
  end;

  Params := TdsdParams.Create(Self, TdsdParam);
  try
    Params.AddParam('Id', TFieldType.ftInteger, ptOutput, 0);
    Params.AddParam('OperDate', TFieldType.ftDateTime, ptOutput, FormParams.ParamByName('OperDate').Value);
    Params.AddParam('UnitId', TFieldType.ftInteger, ptOutput, FormParams.ParamByName('UnitId').Value);
    Params.AddParam('UnitName', TFieldType.ftString, ptOutput, '');
    if not SQLite_Get(InventoryGetActiveSQL, Params) then Exit;
    FormParams.ParamByName('Id').Value := Params.ParamByName('Id').Value;
    FormParams.ParamByName('OperDate').Value := Params.ParamByName('OperDate').Value;
    FormParams.ParamByName('UnitId').Value := Params.ParamByName('UnitId').Value;
    FormParams.ParamByName('UnitName').Value := Params.ParamByName('UnitName').Value;
  finally
    FreeAndNil(Params);
  end;

  PageControl.ActivePage := tsInventory;
  spSelectChilg.Execute;
  InfoCDS.Close;
  ManualCDS.Close;
  edBarCode.SetFocus;
end;

procedure TMainInventoryForm.actContinueInventManualExecute(Sender: TObject);
 var OperDate: TDateTime; UnitName : String; isSave: boolean;
     Params : TdsdParams;
begin

  if ChechActiveInv(OperDate, UnitName, isSave) then
  begin
    if isSave and (OperDate < IncDay(Date, - 3)) then
    begin
      ShowMessage('Инвентаризация не создана. С начало создайте ее');
      Exit;
    end;
  end else
  begin
    ShowMessage('Инвентаризация не создана. С начало создайте ее');
    Exit;
  end;

  Params := TdsdParams.Create(Self, TdsdParam);
  try
    Params.AddParam('Id', TFieldType.ftInteger, ptOutput, 0);
    Params.AddParam('OperDate', TFieldType.ftDateTime, ptOutput, FormParams.ParamByName('OperDate').Value);
    Params.AddParam('UnitId', TFieldType.ftInteger, ptOutput, FormParams.ParamByName('UnitId').Value);
    Params.AddParam('UnitName', TFieldType.ftString, ptOutput, '');
    if not SQLite_Get(InventoryGetActiveSQL, Params) then Exit;
    FormParams.ParamByName('Id').Value := Params.ParamByName('Id').Value;
    FormParams.ParamByName('OperDate').Value := Params.ParamByName('OperDate').Value;
    FormParams.ParamByName('UnitId').Value := Params.ParamByName('UnitId').Value;
    FormParams.ParamByName('UnitName').Value := Params.ParamByName('UnitName').Value;
  finally
    FreeAndNil(Params);
  end;

  edOperDateManual.Date := FormParams.ParamByName('OperDate').Value;
  GuidesUnitManual.Params.ParamByName('Key').Value := FormParams.ParamByName('UnitId').Value;
  GuidesUnitManual.Params.ParamByName('TextValue').Value := FormParams.ParamByName('UnitName').Value;


  PageControl.ActivePage := tsInventoryManual;
  spSelectManual.Execute;
  actSetEditAmount.Execute;

  InfoCDS.Close;
  MasterCDS.Close;
  actSetFocusedManualAmount.Execute;
end;

procedure TMainInventoryForm.actDoCreateInventoryExecute(Sender: TObject);
  var Params : TdsdParams;
begin

  Params := TdsdParams.Create(Self, TdsdParam);
  try
    Params.AddParam('Id', TFieldType.ftInteger, ptOutput, 0);
    Params.AddParam('OperDate', TFieldType.ftDateTime, ptInput, FormParams.ParamByName('OperDate').Value);
    Params.AddParam('UnitId', TFieldType.ftInteger, ptInput, FormParams.ParamByName('UnitId').Value);
    Params.AddParam('DateInput', TFieldType.ftDateTime, ptInput, Now);
    Params.AddParam('UserInputId', TFieldType.ftInteger, ptInput, StrToInt(gc_User.Session));
    if not SQLite_Insert(Inventory_Table, Params) then Exit;
    FormParams.ParamByName('Id').Value := Params.ParamByName('Id').Value;
  finally
    FreeAndNil(Params);
  end;

  PageControl.ActivePage := tsInventory;
  spSelectChilg.Execute;
  edBarCode.SetFocus;
end;

procedure TMainInventoryForm.actDoLoadDataExecute(Sender: TObject);
begin

  gc_User.Local := False;

  try
    spGet_User_IsAdmin.Execute;
  except
  end;

  if gc_User.Local then
  begin
    ShowMessage('В локальном режиме не работает');
    Exit;
  end;

  StartSplash('Старт', 'Проведение инвентаризации');
  try
    ChangeStatus('Получение "Товаров"');
    SaveGoods;
    ChangeStatus('Получение "Штрих кодов товаров"');
    SaveGoodsBarCode;
    ChangeStatus('Получение "Остатков по подразделениям"');
    SaveRemains;
  finally
    EndSplash;
  end;
end;

procedure TMainInventoryForm.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainInventoryForm.actInfoInventExecute(Sender: TObject);
 var OperDate: TDateTime; UnitName : String; isSave: boolean;
     Params : TdsdParams;
begin

  if ChechActiveInv(OperDate, UnitName, isSave) then
  begin
    if isSave and (OperDate < IncDay(Date, - 3)) then
    begin
      ShowMessage('Инвентаризация не создана. С начало создайте ее');
      Exit;
    end;
  end else
  begin
    ShowMessage('Инвентаризация не создана. С начало создайте ее');
    Exit;
  end;

  gc_User.Local := False;

  try
    spGet_User_IsAdmin.Execute;
  except
  end;

  if gc_User.Local then
  begin
    ShowMessage('В локальном режиме не работает');
    Exit;
  end;

  Params := TdsdParams.Create(Self, TdsdParam);
  try
    Params.AddParam('Id', TFieldType.ftInteger, ptOutput, 0);
    Params.AddParam('OperDate', TFieldType.ftDateTime, ptOutput, FormParams.ParamByName('OperDate').Value);
    Params.AddParam('UnitId', TFieldType.ftInteger, ptOutput, FormParams.ParamByName('UnitId').Value);
    Params.AddParam('UnitName', TFieldType.ftString, ptOutput, '');
    if not SQLite_Get(InventoryGetActiveSQL, Params) then Exit;
    FormParams.ParamByName('Id').Value := Params.ParamByName('Id').Value;
    FormParams.ParamByName('OperDate').Value := Params.ParamByName('OperDate').Value;
    FormParams.ParamByName('UnitId').Value := Params.ParamByName('UnitId').Value;
    FormParams.ParamByName('UnitName').Value := Params.ParamByName('UnitName').Value;
  finally
    FreeAndNil(Params);
  end;

  StartSplash('Старт', 'Проведение инвентаризации');
  try
    ChangeStatus('Получение "Получение данных инвентаризации"');
    if not SaveInventory(FormParams.ParamByName('UnitId').Value, FormParams.ParamByName('OperDate').Value) then Exit;
  finally
    EndSplash;
  end;

  edOperDateInfo.Date := FormParams.ParamByName('OperDate').Value;
  edUnitNameInfo.Text := FormParams.ParamByName('UnitName').Value;

  PageControl.ActivePage := tsInfo;
  spSelectInfo.Execute;
  actSetEditAmount.Execute;
  MasterCDS.Close;
  ManualCDS.Close;
end;

procedure TMainInventoryForm.actInsert_InventoryCheckExecute(Sender: TObject);
  var OperDate: TDateTime; UnitName : String; isSave: boolean;
      Params : TdsdParams;
begin
  inherited;

  try

    gc_User.Local := False;

    try
      spGet_User_IsAdmin.Execute;
    except
    end;

    if gc_User.Local then
    begin
      ShowMessage('В локальном режиме не работает');
      Exit;
    end;

    if ChechActiveInv(OperDate, UnitName, isSave) then
    begin
      if not isSave then
      begin
        ShowMessage('Перед загрузкой чеков надо отправить все данные');
        Exit;
      end;
    end;

    spInventoryCheck.Execute;

    if InventoryCheckCDS.IsEmpty then
    begin
      ShowMessage('Нет данных для загрузки.');
      Exit;
    end;

    if MessageDlg('Уточните у первостольника сумма чеков икс отчета совпадает с программой?' +
      #13#10#13#10'Производить загрузку чеков?', mtInformation, [mbYes, mbCancel], 0) <> mrYes then Exit;

    spUnitComplInventFull.Execute;

    Params := TdsdParams.Create(Self, TdsdParam);
    Params.AddParam('Id', TFieldType.ftInteger, ptOutput, 0);
    Params.AddParam('Inventory', TFieldType.ftInteger, ptInput, 0);
    Params.AddParam('GoodsId', TFieldType.ftInteger, ptInput, 0);
    Params.AddParam('Amount', TFieldType.ftFloat, ptInput, 0);
    Params.AddParam('DateInput', TFieldType.ftDateTime, ptInput, Now);
    Params.AddParam('UserInputId', TFieldType.ftInteger, ptInput, 0);
    Params.AddParam('CheckId', TFieldType.ftInteger, ptInput, 0);
    Params.AddParam('IsSend', TFieldType.ftBoolean, ptInput, False);

    try
      InventoryCheckCDS.First;
      while not InventoryCheckCDS.Eof do
      begin

        Params.ParamByName('Id').Value := 0;
        Params.ParamByName('Inventory').Value := FormParams.ParamByName('Id').Value;
        Params.ParamByName('GoodsId').Value := InventoryCheckCDS.FieldByName('GoodsId').AsInteger;
        Params.ParamByName('Amount').Value := InventoryCheckCDS.FieldByName('Amount').AsCurrency;
        Params.ParamByName('DateInput').Value := InventoryCheckCDS.FieldByName('OperDate').AsDateTime;
        Params.ParamByName('UserInputId').Value := InventoryCheckCDS.FieldByName('UserId').AsInteger;
        Params.ParamByName('CheckId').Value := InventoryCheckCDS.FieldByName('MovementId').AsInteger;
        Params.ParamByName('IsSend').ParamType := ptOutput;
        if not SQLite_Exists(InventoryChild_Table, Params) then
        begin
          Params.ParamByName('IsSend').ParamType := ptInput;
          Params.ParamByName('IsSend').Value := False;
          SQLite_Insert(InventoryChild_Table, Params);
        end;

        InventoryCheckCDS.Next;
      end;

      ShowMessage('Загружено.');
    finally
      FreeAndNil(Params);
      spSelectInfo.Execute;
    end;

  finally
    spSelectInfo.Execute;
    actSetFocusedInfoAmount.Execute;
    actSetEditAmount.Execute;
  end;
end;

procedure TMainInventoryForm.actSetEditAmountExecute(Sender: TObject);
  var I : Integer;
begin
  if ManualCDS.Active then
    for I := 0 to ManualCDS.FieldCount - 1 do if ManualCDS.Fields.Fields[I].ReadOnly then
      ManualCDS.Fields.Fields[I].ReadOnly  := False;
  if InfoCDS.Active then
    for I := 0 to InfoCDS.FieldCount - 1 do if InfoCDS.Fields.Fields[I].ReadOnly then
      InfoCDS.Fields.Fields[I].ReadOnly  := False;
end;

procedure TMainInventoryForm.actReCreteInventDateExecute(Sender: TObject);
 var OperDate: TDateTime; UnitName : String; isSave: boolean;
begin

  PageControl.ActivePage := tsStart;
  InfoCDS.Close;
  MasterCDS.Close;
  ManualCDS.Close;

  if ChechActiveInv(OperDate, UnitName, isSave) then
  begin
    if not isSave then
    begin
      if MessageDlg('Активна инвентаризация по' + #13#10 + UnitName + #13#10 + 'от ' +
        FormatDateTime('dd.mm.yyyy', OperDate) + #13#10'Пересоздание инвентаризации преведет к потере введенных данных.' +
        #13#10#13#10'Вы действительно хотите пересоздать инвентаризацию?', mtInformation, mbOKCancel, 0) = mrOk then
      begin
        if MessageDlg('Действительно удалить активную инвентаризацию?', mtInformation, mbOKCancel, 0) <> mrOk then
          raise Exception.Create ('Прервано сотрудником...');
      end else raise Exception.Create ('Прервано сотрудником...');

    end else if OperDate >= IncDay(Date, - 7) then
    begin
      if MessageDlg('Создана инвентаризация по ' + UnitName + ' от ' +
        FormatDateTime('dd.mm.yyyy', OperDate) + #13#10#13#10 +
        'Пересоздать инвентаризацию заново?', mtInformation, mbOKCancel, 0) <> mrOk then
          raise Exception.Create ('Прервано сотрудником...');
    end;
  end;

  CreateInventoryTable;

end;

procedure TMainInventoryForm.actRefreshItogExecute(Sender: TObject);
  var Params : TdsdParams;
begin
  inherited;
  if PageControl.ActivePage = tsInfo then
  try

    gc_User.Local := False;

    try
      spGet_User_IsAdmin.Execute;
    except
    end;

    if gc_User.Local then
    begin
      ShowMessage('В локальном режиме не работает');
      Exit;
    end;

    Params := TdsdParams.Create(Self, TdsdParam);
    try
      Params.AddParam('Id', TFieldType.ftInteger, ptOutput, 0);
      Params.AddParam('OperDate', TFieldType.ftDateTime, ptOutput, FormParams.ParamByName('OperDate').Value);
      Params.AddParam('UnitId', TFieldType.ftInteger, ptOutput, FormParams.ParamByName('UnitId').Value);
      Params.AddParam('UnitName', TFieldType.ftString, ptOutput, '');
      if not SQLite_Get(InventoryGetActiveSQL, Params) then Exit;
      FormParams.ParamByName('Id').Value := Params.ParamByName('Id').Value;
      FormParams.ParamByName('OperDate').Value := Params.ParamByName('OperDate').Value;
      FormParams.ParamByName('UnitId').Value := Params.ParamByName('UnitId').Value;
      FormParams.ParamByName('UnitName').Value := Params.ParamByName('UnitName').Value;
    finally
      FreeAndNil(Params);
    end;

    StartSplash('Старт', 'Проведение инвентаризации');
    try
      ChangeStatus('Получение "Получение данных инвентаризации"');
      if not SaveInventory(FormParams.ParamByName('UnitId').Value, FormParams.ParamByName('OperDate').Value) then Exit;
    finally
      EndSplash;
    end;

    edOperDateInfo.Date := FormParams.ParamByName('OperDate').Value;
    edUnitNameInfo.Text := FormParams.ParamByName('UnitName').Value;

    spSelectInfo.Execute;
    actSetEditAmount.Execute;
  finally
    actSetFocusedInfoAmount.Execute;
  end;
end;

procedure TMainInventoryForm.actSendInventChildExecute(Sender: TObject);
var OperDate: TDateTime; UnitName : String; isSave: boolean;
begin

  gc_User.Local := False;

  try
    spGet_User_IsAdmin.Execute;
  except
  end;

  if gc_User.Local then
  begin
    ShowMessage('В локальном режиме не работает');
    Exit;
  end;

  if ChechActiveInv(OperDate, UnitName, isSave) then
  begin
    if isSave then
    begin
      ShowMessage('Все данные отправлены');
      Exit;
    end;
  end else
  begin
    ShowMessage('Нет данных для отпраки');
    Exit;
  end;

  if MessageDlg('Активна инвентаризация по' + #13#10 + UnitName + #13#10 + 'от ' +
    FormatDateTime('dd.mm.yyyy', OperDate) +
    #13#10#13#10'Отправлять результаты инвентаризации?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

  InfoCDS.Close;
  MasterCDS.Close;
  ManualCDS.Close;
  PageControl.ActivePage := tsStart;

  try
    spSendInvent.Execute;
    if SendInventCDS.RecordCount > 0 then mactSendInvent.Execute;
  finally
    SendInventCDS.Close;
  end;
end;

procedure TMainInventoryForm.actUpdateSendExecute(Sender: TObject);
 var Params : TdsdParams;
begin

  Params := TdsdParams.Create(Self, TdsdParam);
  try
    Params.AddParam('IsSend', TFieldType.ftBoolean, ptInput, True);
    if not SQLite_Update(InventoryChild_Table, SendInventCDS.FieldByName('Id').AsInteger, Params) then Exit;
  finally
    FreeAndNil(Params);
  end;
end;

procedure TMainInventoryForm.Add_Log(AMessage: String);
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

procedure TMainInventoryForm.edBarCodeDblClick(Sender: TObject);
begin
  actGoodsInventory.Execute;
end;

procedure TMainInventoryForm.edBarCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift = []) then
    case Key of
      VK_RETURN: InsertBarCode;
    end;
end;

procedure TMainInventoryForm.FormCreate(Sender: TObject);
  var i : Integer;
begin
  FormClassName := Self.ClassName;
  for i:=0 to PageControl.PageCount-1 do PageControl.Pages[I].TabVisible := False;
  PageControl.ActivePage := tsStart;
  Self.Caption := 'Проведение инвентаризации (' + GetFileVersionString(ParamStr(0)) + ')' +  ' - <' + gc_User.Login + '>';
  SQLiteChechAndArc;
  UserSettingsStorageAddOn.LoadUserSettings;
  FormParams.ParamByName('OperDate').Value := Date;
end;

procedure TMainInventoryForm.ParentFormDestroy(Sender: TObject);
begin
  inherited;
  if not gc_User.Local then UserSettingsStorageAddOn.SaveUserSettings;
end;

procedure TMainInventoryForm.InfoCDSAfterPost(DataSet: TDataSet);
begin
  inherited;
  if DataSet.FieldByName('MIComment').AsVariant <>
     DataSet.FieldByName('MIComment').OldValue then
  begin
    spSelectInfo.Execute;
    actSetEditAmount.Execute;
  end;
end;

procedure TMainInventoryForm.InfoCDSBeforePost(DataSet: TDataSet);
var Id : Integer;
    MIComment, MICommentOld : Variant;
    Params : TdsdParams;
begin
  Id := DataSet.FieldByName('Id').AsInteger;
  MIComment := DataSet.FieldByName('MIComment').AsVariant;
  MICommentOld := DataSet.FieldByName('MIComment').OldValue;
  if MIComment <> MICommentOld then
  begin

    spUpdate_Comment.ParamByName('inId').Value := Id;
    spUpdate_Comment.ParamByName('inComment').Value := MIComment;
    spUpdate_Comment.Execute;

    Params := TdsdParams.Create(Self, TdsdParam);
    try
      Params.AddParam('MIComment', TFieldType.ftString, ptInput, MIComment);
      SQLite_Update(InventoryDate_Table, Id, Params);
    finally
      FreeAndNil(Params);
    end;

  end;
end;

procedure TMainInventoryForm.InfoCDSPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
var GoodsId : Integer;
    AmountUser, AmountUserOld : Currency;
    Params : TdsdParams;
begin
  GoodsId := DataSet.FieldByName('GoodsId').AsInteger;
  AmountUser := DataSet.FieldByName('AmountUser').AsCurrency;
  AmountUserOld := DataSet.FieldByName('AmountUser').OldValue;
  DataSet.Cancel;
  Action := daAbort;

  if AmountUser <> AmountUserOld then
  begin

    Params := TdsdParams.Create(Self, TdsdParam);
    try
      Params.AddParam('Id', TFieldType.ftInteger, ptOutput, 0);
      Params.AddParam('Inventory', TFieldType.ftInteger, ptInput, FormParams.ParamByName('Id').Value);
      Params.AddParam('GoodsId', TFieldType.ftInteger, ptInput, GoodsId);
      Params.AddParam('Amount', TFieldType.ftFloat, ptInput, AmountUser - AmountUserOld);
      Params.AddParam('DateInput', TFieldType.ftDateTime, ptInput, Now);
      Params.AddParam('UserInputId', TFieldType.ftInteger, ptInput, StrToInt(gc_User.Session));
      Params.AddParam('IsSend', TFieldType.ftBoolean, ptInput, False);
      SQLite_Insert(InventoryChild_Table, Params);
    finally
      FreeAndNil(Params);
    end;

    spSelectInfo.Execute;
    actSetEditAmount.Execute;
    cxGridDBTableView1.DataController.GotoNext;
  end;
end;

procedure TMainInventoryForm.InsertBarCode;
  var ds: TClientDataSet;
      BarCode: String;
      Params: TdsdParams;
      MainId : Integer;
begin
  BarCode := Trim(edBarCode.Text);

  if Screen.ActiveControl is TcxCustomInnerTextEdit then
  begin
    if TcxCustomInnerTextEdit(Screen.ActiveControl).Parent = ceAmount then
    begin
      edBarCode.SetFocus;
      Exit;
    end else if TcxCustomInnerTextEdit(Screen.ActiveControl).Parent <> edBarCode then
    begin
      edBarCode.SetFocus;
      Exit;
    end;
  end else
  begin
    edBarCode.SetFocus;
    Exit;
  end;

  if BarCode = '' then
  begin
    edBarCode.SetFocus;
    Exit;
  end;

  if Abs(ceAmount.Value) > 10000 then
  begin
    ShowMessage('Ошибка количество <' + FormatCurr(',0.0', ceAmount.Value) + '> превышает допустимое.'#13#10+
      'Проверьте столбец количество - возможно вы внесли значения ш/к вместо количества по товару');
    Exit;
  end;

  ds := TClientDataSet.Create(nil);
  try
    if Copy(BarCode, 1, 3) = '201' then
    begin
      if TryStrToInt(Copy(BarCode, 4, Length(BarCode) - 4), MainId) then
      begin
        LoadSQLiteSQL(ds, Format(GetGoodsIdSQL, [IntToStr(MainId)]));
      end else
      begin
        ShowMessage('Ошибка получения ID товара из штрихкода <' + BarCode + '>');
        Exit;
      end;
    end else if Copy(BarCode, 1, 3) = '202' then
    begin
      if TryStrToInt(Copy(BarCode, 4, Length(BarCode) - 4), MainId) then
      begin
        LoadSQLiteSQL(ds, Format(GetGoodsCodeSQL, [IntToStr(MainId)]));
      end else
      begin
        ShowMessage('Ошибка получения ID товара из штрихкода <' + BarCode + '>');
        Exit;
      end;
    end else
    begin
      LoadSQLiteSQL(ds, Format(GetGoodsBarCodeSQL, ['%'+ BarCode + '%']));
    end;

    if ds.IsEmpty then
    begin
      ShowMessage('Товар по штрихкоду <' + BarCode + '> не найден');
      Exit;
    end;
    if ds.RecordCount > 1 then
    begin
      ShowMessage('Штрихкод <' + BarCode + '> прикреплен к более чем одному товару');
      Exit;
    end;

    Params := TdsdParams.Create(Self, TdsdParam);
    try
      Params.AddParam('Id', TFieldType.ftInteger, ptOutput, 0);
      Params.AddParam('Inventory', TFieldType.ftInteger, ptInput, FormParams.ParamByName('Id').Value);
      Params.AddParam('GoodsId', TFieldType.ftInteger, ptInput, ds.FieldByName('Id').AsString);
      Params.AddParam('Amount', TFieldType.ftFloat, ptInput, ceAmount.Value);
      Params.AddParam('DateInput', TFieldType.ftDateTime, ptInput, Now);
      Params.AddParam('UserInputId', TFieldType.ftInteger, ptInput, StrToInt(gc_User.Session));
      Params.AddParam('IsSend', TFieldType.ftBoolean, ptInput, False);
      if not SQLite_Insert(InventoryChild_Table, Params) then Exit;
    finally
      FreeAndNil(Params);
    end;

    edGoodsCode.Text := ds.FieldByName('Code').AsString;
    edGoodsName.Text := ds.FieldByName('Name').AsString;
    ceAmountAdd.Value := ceAmount.Value;

    spSelectChilg.Execute;
    MasterCDS.First;
    edBarCode.Text := '';

  finally
    freeAndNil(ds);
    ceAmount.Value := 1;
    edBarCode.SetFocus;
  end;
end;

procedure TMainInventoryForm.ManualCDSPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
var GoodsId : Integer; Remains, AmountOld, Amount : Currency;
    Params : TdsdParams;
begin
  GoodsId := DataSet.FieldByName('GoodsId').AsInteger;
  Remains := DataSet.FieldByName('Remains').AsCurrency;
  AmountOld := DataSet.FieldByName('Amount').OldValue;
  Amount := DataSet.FieldByName('Amount').AsCurrency;
  DataSet.Cancel;
  Action := daAbort;

  if AmountOld <> Amount then
  begin

    Params := TdsdParams.Create(Self, TdsdParam);
    try
      Params.AddParam('Id', TFieldType.ftInteger, ptOutput, 0);
      Params.AddParam('Inventory', TFieldType.ftInteger, ptInput, FormParams.ParamByName('Id').Value);
      Params.AddParam('GoodsId', TFieldType.ftInteger, ptInput, GoodsId);
      Params.AddParam('Amount', TFieldType.ftFloat, ptInput, Amount - AmountOld);
      Params.AddParam('DateInput', TFieldType.ftDateTime, ptInput, Now);
      Params.AddParam('UserInputId', TFieldType.ftInteger, ptInput, StrToInt(gc_User.Session));
      Params.AddParam('IsSend', TFieldType.ftBoolean, ptInput, False);
      SQLite_Insert(InventoryChild_Table, Params);
    finally
      FreeAndNil(Params);
    end;

    spSelectManual.Execute;
    actSetEditAmount.Execute;
    cxGridDBTableView2.DataController.GotoNext;
  end;
end;

end.
