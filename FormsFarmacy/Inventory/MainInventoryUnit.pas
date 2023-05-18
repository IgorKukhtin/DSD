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
        case MessageDlg('�� ������ ' + #13#10 + UnitName + #13#10 + '�� ' +
          FormatDateTime('dd.mm.yyyy', OperDate) + #13#10'�� ���������� ������ �� ��������������' +
          #13#10#13#10'Yes - �����?' +
          #13#10#13#10'Ok - ��������� � �����?', mtInformation, [mbYes, mbOK, mbCancel], 0) Of
            mrOk : actSendInventChildExecute(Sender);
            mrYes : ;
        else Action := caNone;
        end;
    end else if MessageDlg('������� ����������?', mtInformation, mbOKCancel, 0) <> mrOk then Action := caNone;
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
      ShowMessage('�������������� �� �������. � ������ �������� ��');
      Exit;
    end;
  end else
  begin
    ShowMessage('�������������� �� �������. � ������ �������� ��');
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
      ShowMessage('�������������� �� �������. � ������ �������� ��');
      Exit;
    end;
  end else
  begin
    ShowMessage('�������������� �� �������. � ������ �������� ��');
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
    ShowMessage('� ��������� ������ �� ��������');
    Exit;
  end;

  StartSplash('�����', '���������� ��������������');
  try
    ChangeStatus('��������� "�������"');
    SaveGoods;
    ChangeStatus('��������� "����� ����� �������"');
    SaveGoodsBarCode;
    ChangeStatus('��������� "�������� �� ��������������"');
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
      ShowMessage('�������������� �� �������. � ������ �������� ��');
      Exit;
    end;
  end else
  begin
    ShowMessage('�������������� �� �������. � ������ �������� ��');
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

  edOperDateInfo.Date := FormParams.ParamByName('OperDate').Value;
  edUnitNameInfo.Text := FormParams.ParamByName('UnitName').Value;

  PageControl.ActivePage := tsInfo;
  spSelectInfo.Execute;
  MasterCDS.Close;
  ManualCDS.Close;
end;

procedure TMainInventoryForm.actSetEditAmountExecute(Sender: TObject);
  var I : Integer;
begin
  for I := 0 to ManualCDS.FieldCount - 1 do if ManualCDS.Fields.Fields[I].ReadOnly then
    ManualCDS.Fields.Fields[I].ReadOnly  := False;
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
      if MessageDlg('������� �������������� ��' + #13#10 + UnitName + #13#10 + '�� ' +
        FormatDateTime('dd.mm.yyyy', OperDate) + #13#10'������������ �������������� �������� � ������ ��������� ������.' +
        #13#10#13#10'�� ������������� ������ ����������� ��������������?', mtInformation, mbOKCancel, 0) = mrOk then
      begin
        if MessageDlg('������������� ������� �������� ��������������?', mtInformation, mbOKCancel, 0) <> mrOk then
          raise Exception.Create ('�������� �����������...');
      end else raise Exception.Create ('�������� �����������...');

    end else if OperDate >= IncDay(Date, - 7) then
    begin
      if MessageDlg('������� �������������� �� ' + UnitName + ' �� ' +
        FormatDateTime('dd.mm.yyyy', OperDate) + #13#10#13#10 +
        '����������� �������������� ������?', mtInformation, mbOKCancel, 0) <> mrOk then
          raise Exception.Create ('�������� �����������...');
    end;
  end;

  CreateInventoryTable;

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
    ShowMessage('� ��������� ������ �� ��������');
    Exit;
  end;

  if ChechActiveInv(OperDate, UnitName, isSave) then
  begin
    if isSave then
    begin
      ShowMessage('��� ������ ����������');
      Exit;
    end;
  end else
  begin
    ShowMessage('��� ������ ��� �������');
    Exit;
  end;

  if MessageDlg('������� �������������� ��' + #13#10 + UnitName + #13#10 + '�� ' +
    FormatDateTime('dd.mm.yyyy', OperDate) +
    #13#10#13#10'���������� ���������� ��������������?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

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
  Self.Caption := '���������� �������������� (' + GetFileVersionString(ParamStr(0)) + ')' +  ' - <' + gc_User.Login + '>';
  SQLiteChechAndArc;
  UserSettingsStorageAddOn.LoadUserSettings;
  FormParams.ParamByName('OperDate').Value := Date;
end;

procedure TMainInventoryForm.ParentFormDestroy(Sender: TObject);
begin
  inherited;
  if not gc_User.Local then UserSettingsStorageAddOn.SaveUserSettings;
end;

procedure TMainInventoryForm.InsertBarCode;
  var ds: TClientDataSet;
      BarCode: String;
      Params: TdsdParams;
      MainId : Integer;
begin
  BarCode := Trim(edBarCode.Text);

  if BarCode = '' then
  begin
    edBarCode.SetFocus;
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
        ShowMessage('������ ��������� ID ������ �� ��������� <' + BarCode + '>');
        Exit;
      end;
    end else if Copy(BarCode, 1, 3) = '202' then
    begin
      if TryStrToInt(Copy(BarCode, 4, Length(BarCode) - 4), MainId) then
      begin
        LoadSQLiteSQL(ds, Format(GetGoodsCodeSQL, [IntToStr(MainId)]));
      end else
      begin
        ShowMessage('������ ��������� ID ������ �� ��������� <' + BarCode + '>');
        Exit;
      end;
    end else
    begin
      LoadSQLiteSQL(ds, Format(GetGoodsBarCodeSQL, ['%'+ BarCode + '%']));
    end;

    if ds.IsEmpty then
    begin
      ShowMessage('����� �� ��������� <' + BarCode + '> �� ������');
      Exit;
    end;
    if ds.RecordCount > 1 then
    begin
      ShowMessage('�������� <' + BarCode + '> ���������� � ����� ��� ������ ������');
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
