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
  Vcl.ActnList, strUtils, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  cxImageComboBox, cxNavigator, System.JSON,
  cxDataControllerConditionalFormattingRulesManagerDialog, ZStoredProcedure,
  dxDateRanges, Data.Bind.Components, Data.Bind.ObjectScope, dsdAction, System.Actions, dsdDB, cxDateUtils,
  Datasnap.DBClient, DataModul;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    Panel2: TPanel;
    btnAll: TButton;
    btnSelect_GoodsToUpdateSite: TButton;
    spSite_Param: TdsdStoredProc;
    ActionList: TActionList;
    actSite_Param: TdsdExecStoredProc;
    FormParams: TdsdFormParams;
    spSelect_GoodsToUpdateSite: TdsdStoredProc;
    actSelect_GoodsToUpdateSite: TdsdExecStoredProc;
    cxGridGoodsToUpdateSiteDBTableView1: TcxGridDBTableView;
    cxGridGoodsToUpdateSiteLevel1: TcxGridLevel;
    cxGridGoodsToUpdateSite: TcxGrid;
    GoodsToUpdateSiteCDS: TClientDataSet;
    GoodsToUpdateSiteDS: TDataSource;
    maDo: TMultiAction;
    btnDo: TButton;
    actDo: TAction;
    PharmDrugsDS: TDataSource;
    PharmDrugsCDS: TClientDataSet;
    actSelect_Pharm_Drugs: TdsdForeignData;
    cxGridPharmOrderProducts: TcxGrid;
    cxGridPharmOrderProductsDBTableView1: TcxGridDBTableView;
    cxGridPharmOrderProductsLevel1: TcxGridLevel;
    btnDoone: TButton;
    actUpdatePharmDrugs: TdsdForeignData;
    cxGridGoodsToUpdateSiteDB_Id: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_Code: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_isPublished: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_Name: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_NameUkr: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_MakerName: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_MakerNameUkr: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_FormDispensingId: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_NumberPlates: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_QtyPackage: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_isRecipe: TcxGridDBColumn;
    btnSelect_Pharm_Drugs: TButton;
    cxGridPharmOrderProductsDB_Id: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_postgres_drug_id: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_sky: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_title: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_title_uk: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_manufacturer: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_manufacturer_uk: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_status: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_formdispensing_Id: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_NumberPlates: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_QtyPackage: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_isRecipe: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_isMakerNameSite: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_isMakerNameUkrSite: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_isNameUkrSite: TcxGridDBColumn;
    spUpdate_SiteUpdate: TdsdStoredProc;
    ObjectIDCDS: TClientDataSet;
    actSelect_Pharm_ObjectID: TdsdForeignData;
    btnSelect_Pharm_ObjectID: TButton;
    cxGridGoodsToUpdateSiteDB_Multiplicity: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_isDoesNotShare: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_isSP: TcxGridDBColumn;
    cxGridGoodsToUpdateSiteDB_isDiscountExternal: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_Multiplicity: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_isDoesNotShare: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_isSP: TcxGridDBColumn;
    cxGridPharmOrderProductsDB_isDiscountExternal: TcxGridDBColumn;
    procedure btnAllClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actDoExecute(Sender: TObject);
    procedure actOpenGridExecute(Sender: TObject);
  private
    { Private declarations }

    APIUser: String;
    APIPassword: String;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
    function GetObjectID(AId : Integer) : Integer;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.actOpenGridExecute(Sender: TObject);
begin
  try
    if actSite_Param.Execute then
    begin

//      // Заказ с сайта
//      if not actPharmOrders.Execute then Exit;
//
//      // Содержимое заказа с сайта
//      if not actPharmOrderProducts.Execute then Exit;
//
//      // Содержимое заказа с фармаси
//      if not actSelect_MI_UpdateOrdersSite.Execute then Exit;

    end;
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
  Add_Log('Запуск обновления данных.'#13#10);

  // Звгрузим наше
  actSelect_GoodsToUpdateSite.Execute;

  // Загрузим с сайта Id справочников
  actSelect_Pharm_ObjectID.Execute;

  // Загрузим с сайта
  actSelect_Pharm_Drugs.Execute;

  // обновляем
  maDo.Execute;

  Add_Log('Выполнено.');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin

  if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
  begin
    Application.ShowMainForm := False;
    btnAll.Enabled := false;
    btnSelect_GoodsToUpdateSite.Enabled := false;
    btnSelect_Pharm_Drugs.Enabled := false;
    btnSelect_Pharm_ObjectID.Enabled := false;
    btnDo.Enabled := false;
    btnDoone.Enabled := false;
    actUpdatePharmDrugs.ShowGaugeForm := False;
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

function TMainForm.GetObjectID(AId : Integer) : Integer;
begin
  if AId <> 0 then
  begin
    if ObjectIDCDS.Locate('pharmacy_id', AId, []) then
      Result := ObjectIDCDS.FieldByName('Id').AsInteger
    else Result := 0;
  end else Result := 0;
end;


procedure TMainForm.actDoExecute(Sender: TObject);
  var bGo : boolean; S : string; FormatSettings: TFormatSettings; Id : Integer;
begin
  try

    if PharmDrugsCDS.IsEmpty then Exit;
    if PharmDrugsCDS.FieldByName('status').AsInteger <> 1 then Exit;
    if not GoodsToUpdateSiteCDS.FieldByName('isPublished').AsBoolean then Exit;

    S := ''; FormatSettings.DecimalSeparator := '.';

    if (PharmDrugsCDS.FieldByName('title_uk').AsString = '') and (GoodsToUpdateSiteCDS.FieldByName('NameUkr').AsString <> '') OR
       GoodsToUpdateSiteCDS.FieldByName('isNameUkrSite').AsBoolean and (PharmDrugsCDS.FieldByName('title_uk').AsString <> GoodsToUpdateSiteCDS.FieldByName('NameUkr').AsString) then
      S := 'title_uk = ''' + StringReplace(GoodsToUpdateSiteCDS.FieldByName('NameUkr').AsString, '''', '''''', [rfReplaceAll]) + '''';

    if (PharmDrugsCDS.FieldByName('manufacturer').AsString = '') and (GoodsToUpdateSiteCDS.FieldByName('MakerName').AsString <> '') OR
       GoodsToUpdateSiteCDS.FieldByName('isMakerNameSite').AsBoolean and (PharmDrugsCDS.FieldByName('manufacturer').AsString <> GoodsToUpdateSiteCDS.FieldByName('MakerName').AsString)  then
    begin
      if S <> '' then S := S + ', ';
      S := S + 'manufacturer = ''' + StringReplace(GoodsToUpdateSiteCDS.FieldByName('MakerName').AsString, '''', '''''', [rfReplaceAll]) + '''';
    end;

    if (PharmDrugsCDS.FieldByName('manufacturer_uk').AsString = '') and (GoodsToUpdateSiteCDS.FieldByName('MakerNameUkr').AsString <> '') OR
       GoodsToUpdateSiteCDS.FieldByName('isMakerNameUkrSite').AsBoolean and (PharmDrugsCDS.FieldByName('manufacturer_uk').AsString <> GoodsToUpdateSiteCDS.FieldByName('MakerNameUkr').AsString)  then
    begin
      if S <> '' then S := S + ', ';
      S := S + 'manufacturer_uk = ''' + StringReplace(GoodsToUpdateSiteCDS.FieldByName('MakerNameUkr').AsString, '''', '''''', [rfReplaceAll]) + '''';
    end;

    Id := GetObjectID(GoodsToUpdateSiteCDS.FieldByName('FormDispensingID').AsInteger);
    if PharmDrugsCDS.FieldByName('formdispensing_Id').AsInteger <> Id  then
    begin
      if S <> '' then S := S + ', ';
      if Id <> 0 then S := S + 'formdispensing_Id = ' + IntToStr(Id)
      else S := S + 'formdispensing_Id = Null';
    end;

    if PharmDrugsCDS.FieldByName('NumberPlates').AsInteger <> GoodsToUpdateSiteCDS.FieldByName('NumberPlates').AsInteger  then
    begin
      if S <> '' then S := S + ', ';
      S := S + 'NumberPlates = ' + GoodsToUpdateSiteCDS.FieldByName('NumberPlates').AsString;
    end;

    if PharmDrugsCDS.FieldByName('QtyPackage').AsInteger <> GoodsToUpdateSiteCDS.FieldByName('QtyPackage').AsInteger  then
    begin
      if S <> '' then S := S + ', ';
      S := S + 'QtyPackage = ' + GoodsToUpdateSiteCDS.FieldByName('QtyPackage').AsString;
    end;

    if PharmDrugsCDS.FieldByName('isRecipe').AsInteger <> IfThen(GoodsToUpdateSiteCDS.FieldByName('isRecipe').AsBoolean, 1, 0)  then
    begin
      if S <> '' then S := S + ', ';
      S := S + 'isRecipe = ' + IfThen(GoodsToUpdateSiteCDS.FieldByName('isRecipe').AsBoolean, '1', '0');
    end;

    if PharmDrugsCDS.FieldByName('Multiplicity').AsCurrency <> GoodsToUpdateSiteCDS.FieldByName('Multiplicity').AsCurrency  then
    begin
      if S <> '' then S := S + ', ';
      S := S + 'Multiplicity = ' + CurrToStr(GoodsToUpdateSiteCDS.FieldByName('Multiplicity').AsCurrency, FormatSettings);
    end;

    if PharmDrugsCDS.FieldByName('isDoesNotShare').AsInteger <> IfThen(GoodsToUpdateSiteCDS.FieldByName('isDoesNotShare').AsBoolean, 1, 0)  then
    begin
      if S <> '' then S := S + ', ';
      S := S + 'isDoesNotShare = ' + IfThen(GoodsToUpdateSiteCDS.FieldByName('isDoesNotShare').AsBoolean, '1', '0');
    end;

    if PharmDrugsCDS.FieldByName('isSP').AsInteger <> IfThen(GoodsToUpdateSiteCDS.FieldByName('isSP').AsBoolean, 1, 0)  then
    begin
      if S <> '' then S := S + ', ';
      S := S + 'isSP = ' + IfThen(GoodsToUpdateSiteCDS.FieldByName('isSP').AsBoolean, '1', '0');
    end;

    if PharmDrugsCDS.FieldByName('isDiscountExternal').AsInteger <> IfThen(GoodsToUpdateSiteCDS.FieldByName('isDiscountExternal').AsBoolean, 1, 0)  then
    begin
      if S <> '' then S := S + ', ';
      S := S + 'isDiscountExternal = ' + IfThen(GoodsToUpdateSiteCDS.FieldByName('isDiscountExternal').AsBoolean, '1', '0');
    end;

    if S <> '' then
    begin
      S := 'update pharm_drugs set ' + S + ', updated_at = CURRENT_TIMESTAMP() where Id = ' + PharmDrugsCDS.FieldByName('Id').AsString;
      Add_Log('SQL ' + S);
      actUpdatePharmDrugs.SQLParam.Value := S;
      actUpdatePharmDrugs.Execute;
    end;

    if GoodsToUpdateSiteCDS.FieldByName('isNameUkrSite').AsBoolean or
       GoodsToUpdateSiteCDS.FieldByName('isMakerNameSite').AsBoolean or
       GoodsToUpdateSiteCDS.FieldByName('isMakerNameUkrSite').AsBoolean then
    begin
      spUpdate_SiteUpdate.Execute;
    end;

  except
    on E:Exception do
    begin
        Add_Log('Ошибка: ' + E.Message);
    end;
  end;
end;



end.
