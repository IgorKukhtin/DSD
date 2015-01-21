unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Data.DB,
  Bde.DBTables, Vcl.Mask, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdDB, Datasnap.DBClient, Inifiles, dxSkinsCore,
  dxSkinsDefaultPainters
 ,SysScalesLib_TLB;

type
  TMainForm = class(TForm)
    GridPanel: TPanel;
    DBGrid: TDBGrid;
    ButtonPanel: TPanel;
    ButtonSaveAllItem: TSpeedButton;
    ButtonDeleteItem: TSpeedButton;
    ButtonExit: TSpeedButton;
    ButtonCancelItem: TSpeedButton;
    ButtonRefresh: TSpeedButton;
    ButtonRefreshZakaz: TSpeedButton;
    ButtonNewGetParams: TSpeedButton;
    ButtonPrintBill_detail_byInvNumber: TSpeedButton;
    ButtonChangePartionDate: TSpeedButton;
    ButtonChangeNumberTare: TSpeedButton;
    ButtonChangeNumberLevel: TSpeedButton;
    ButtonExportToMail: TSpeedButton;
    ButtonChangeMember: TSpeedButton;
    ButtonExportToEDI: TSpeedButton;
    ButtonChangePartionStr: TSpeedButton;
    infoPanelTotalSumm: TPanel;
    GBTotalSummGoods_Weight: TGroupBox;
    PanelTotalSummGoods_Weight: TPanel;
    TotalSummTare_Weight: TGroupBox;
    PanelTotalSummTare_Weight: TPanel;
    GBTotalSummGoods_Weight_Discount: TGroupBox;
    PanelTotalSummGoods_Weight_Discount: TPanel;
    gbTotalSumm: TGroupBox;
    PanelTotalSumm: TPanel;
    PanelZakaz: TPanel;
    GroupBox1: TGroupBox;
    DiffZakazSalePanel: TPanel;
    GroupBox2: TGroupBox;
    ZakazCountPanel: TPanel;
    GroupBox3: TGroupBox;
    ZakazChangePanel: TPanel;
    GroupBox4: TGroupBox;
    calcZakazCountPanel: TPanel;
    GroupBox5: TGroupBox;
    SaleCountPanel: TPanel;
    GroupBox6: TGroupBox;
    TotalDiffZakazSalePanel: TPanel;
    GroupBox7: TGroupBox;
    TotalZakazCountPanel: TPanel;
    PanelSaveItem: TPanel;
    CodeInfoPanel: TPanel;
    EnterGoodsCodeScanerPanel: TPanel;
    EnterGoodsCodeScanerLabel: TLabel;
    EnterGoodsCodeScanerEdit: TEdit;
    EnterWeightPanel: TPanel;
    EnterWeightLabel: TLabel;
    EnterWeightEdit: TEdit;
    gbOperDate: TGroupBox;
    infoPanel_Scale: TPanel;
    ScaleLabel: TLabel;
    PanelWeight_Scale: TPanel;
    PanelInfoItem: TPanel;
    PanelProduction_Goods: TPanel;
    LabelProduction_Goods: TLabel;
    GBProduction_GoodsCode: TGroupBox;
    PanelProduction_GoodsCode: TPanel;
    EditProduction_GoodsCode: TEdit;
    GBProduction_Goods_Weight: TGroupBox;
    PanelProduction_Goods_Weight: TPanel;
    GBProduction_GoodsName: TGroupBox;
    PanelProduction_GoodsName: TPanel;
    PanelTare_Goods: TPanel;
    LabelTare_Goods: TLabel;
    GBTare_GoodsCode: TGroupBox;
    PanelTare_GoodsCode: TPanel;
    GBTare_Goods_Weight: TGroupBox;
    PanelTare_Goods_Weight: TPanel;
    GBTare_GoodsName: TGroupBox;
    PanelTare_GoodsName: TPanel;
    gbTare_Goods_Count: TGroupBox;
    PanelTare_Goods_Count: TPanel;
    PanelSpace1: TPanel;
    PanelSpace2: TPanel;
    infoPanelTotalWeight: TPanel;
    GBTotalWeight: TGroupBox;
    PanelTotalWeight: TPanel;
    GBDiscountWeight: TGroupBox;
    PanelDiscountWeight: TPanel;
    PanelInfo: TPanel;
    PanelMessage: TPanel;
    PanelBillKind: TPanel;
    infoPanel: TPanel;
    PanelPartner: TPanel;
    LabelPartner: TLabel;
    PanelPartnerCode: TPanel;
    PanelPartnerName: TPanel;
    PanelPriceList: TPanel;
    PriceListNameLabel: TLabel;
    PanelPriceListName: TPanel;
    PanelRouteUnit: TPanel;
    LabelRouteUnit: TLabel;
    PanelRouteUnitCode: TPanel;
    PanelRouteUnitName: TPanel;
    PanelIsRecalc: TPanel;
    PopupMenu: TPopupMenu;
    miPrintZakazMinus: TMenuItem;
    miPrintZakazAll: TMenuItem;
    miLine11: TMenuItem;
    miPrintBill_byInvNumber: TMenuItem;
    miPrintBill_andNaliog_byInvNumber: TMenuItem;
    miPrintBillTotal_byClient: TMenuItem;
    miPrintBillTotal_byFozzi: TMenuItem;
    miLine12: TMenuItem;
    miPrintSchet_byInvNumber: TMenuItem;
    miPrintBillTransport_byInvNumber: TMenuItem;
    miPrintBillTransportNew_byInvNumber: TMenuItem;
    miPrintBillKachestvo_byInvNumber: TMenuItem;
    miPrintBillNumberTare_byInvNumber: TMenuItem;
    miPrintBillNotice_byInvNumber: TMenuItem;
    miLine13: TMenuItem;
    miPrintSaleAll: TMenuItem;
    miPrint_Report_byTare: TMenuItem;
    miPrint_Report_byMemberProduction: TMenuItem;
    miLine14: TMenuItem;
    miScaleIni_DB: TMenuItem;
    miScaleIni_BI: TMenuItem;
    miScaleIni_Zeus: TMenuItem;
    miScaleIni_BI_R: TMenuItem;
    miLine15: TMenuItem;
    miScaleRun_DB: TMenuItem;
    miScaleRun_BI: TMenuItem;
    miScaleRun_Zeus: TMenuItem;
    miScaleRun_BI_R: TMenuItem;
    OperDateEdit: TcxDateEdit;
    spSelect: TdsdStoredProc;
    DS: TDataSource;
    CDS: TClientDataSet;
    procedure ButtonExportToEDIClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ButtonNewGetParamsClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure ButtonRefreshZakazClick(Sender: TObject);
    procedure PanelWeight_ScaleClick(Sender: TObject);
  private
  Scale_BI: TCasBI;
  Scale_DB: TCasDB;

    procedure GetParams;
    procedure newGetParamsGoods;
    function myCheckPartionStr:boolean;
    procedure Initialize_Scale;
    function fGetScale_CurrentWeight:Double;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;


implementation
{$R *.dfm}

uses DMMainScale, UtilScale, UtilConst, DialogMovementDesc, GuideGoods,UtilPrint;

function TMainForm.myCheckPartionStr:boolean;
begin
     Result:=false;

     Result:=true;
end;

procedure TMainForm.newGetParamsGoods;
var GoodsWeight_two,GoodsWeight_set:Double;
    calcClientId:Integer;
begin

     calcClientId:=0;//ParamsBill_ScaleHistory.ParamByName('@inToId').AsInteger


     if GuideGoodsForm.Execute(calcClientId,ParamsMovement.ParamByName('OperDate').AsDateTime)
//     if GuideGoodsForm.Execute
     then begin

     end;

//
end;


procedure TMainForm.PanelWeight_ScaleClick(Sender: TObject);
begin
     fGetScale_CurrentWeight;
end;

procedure TMainForm.ButtonExitClick(Sender: TObject);
begin
 Close;
end;

procedure TMainForm.ButtonExportToEDIClick(Sender: TObject);
begin
// spTest.Execute;
end;

procedure TMainForm.ButtonNewGetParamsClick(Sender: TObject);
begin
  newGetParamsGoods;
end;

procedure TMainForm.ButtonRefreshZakazClick(Sender: TObject);
begin
    PrintSale(StrToInt(EnterGoodsCodeScanerEdit.Text));
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TInifile;
begin
  //global Initialize
  Ini:=TIniFile.Create('D:\Project-Basis\Bin\INI\scale.ini');
  SettingMain.ScaleNum:=Ini.ReadInteger('Main','ScaleNum',1);
  SettingMain.ComPort :=Ini.ReadString('Main','ComPort','COM1');
  if AnsiUpperCase(Ini.ReadString('Main','BI','FALSE')) = AnsiUpperCase('TRUE') then SettingMain.BI :=TRUE else SettingMain.BI := FALSE ;
  if AnsiUpperCase(Ini.ReadString('Main','DB','TRUE')) = AnsiUpperCase('TRUE') then SettingMain.DB :=TRUE else SettingMain.DB := FALSE ;
  Ini.Free;
  //global Initialize
  DMMainScaleForm.gpInitialize_MovementDesc;
  //global Initialize
  Default_Array:=       DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.ScaleNum,'Default');
  Service_Array:=       DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.ScaleNum,'Service');
  //global Initialize
  Create_ParamsMovement(ParamsMovement);
  //global Initialize
  Scale_DB:=TCasDB.Create(self);
  Scale_BI:=TCasBI.Create(self);
  Initialize_Scale;
  //
  //local Initialize
  ParamsMovement.ParamByName('MovementNumber').AsString:=GetArrayList_Value_byName(Default_Array,'MovementNumber');
  //local Initialize
  OperDateEdit.Text:=DateToStr(DMMainScaleForm.gpInitialize_OperDate(ParamsMovement));
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.Initialize_Scale;
begin
     if SettingMain.BI = TRUE
     then
          // !!! SCALE BI !!!
          try
             Scale_BI.Active := 0;
             Scale_BI.CommPort:=SettingMain.ComPort;
             Scale_BI.CommSpeed := 9600;//NEW!!!
             Scale_BI.Active := 1;//NEW!!!
             if Scale_BI.Active=1
             then ScaleLabel.Caption:='BI.Active = OK'
             else ScaleLabel.Caption:='BI.Active = Error';
          except
               ScaleLabel.Caption:='BI.Active = Error-ALL';
          end;

     if SettingMain.DB = TRUE
     then try
             // !!! SCALE DB !!!
             Scale_DB.Active:=0;
             Scale_DB.CommPort:=SettingMain.ComPort;
             Scale_DB.Active := 1;
             //
             if Scale_BI.Active=1
             then ScaleLabel.Caption:='DB.Active = OK'
             else ScaleLabel.Caption:='DB.Active = Error';
          except
             ScaleLabel.Caption:='DB.Active = Error-ALL';
         end;

     //
     PanelWeight_Scale.Caption:='';
end;
//------------------------------------------------------------------------------------------------
function TMainForm.fGetScale_CurrentWeight:Double;
begin
     // открываем ВЕСЫ, только когда НУЖЕН вес
     //Initialize_Scale_DB;
     // считывание веса
     try
        if SettingMain.BI = TRUE
        then Result:=Scale_BI.Weight
             else if SettingMain.DB = TRUE
                  then Result:=Scale_DB.Weight
                  else Result:=0;
     except Result:=0;end;
     // закрываем ВЕСЫ
     // Scale_DB.Active:=0;
     //
//*****
     // if (_Weight_Main<>'')and(_beginUser=1) then Weight:=_Weight_Main;
//     Weight:='0,123456';
     PanelWeight_Scale.Caption:=FloatToStr(Result);
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = VK_F2 then GetParams;
     if Key = VK_SPACE then begin Key:=0;ButtonNewGetParamsClick(self);end;

  if ShortCut(Key, Shift) = 24659 then begin
     gc_isDebugMode := not gc_isDebugMode;
     if gc_isDebugMode then
        ShowMessage('Установлен режим отладки')
      else
        ShowMessage('Снят режим отладки');
  end;
end;


procedure TMainForm.GetParams;
begin

     if DialogMovementDescForm.Execute
     then begin
      //PanelPriceListName.Caption:= SettingMovement.PriceListName;
{      PanelPartnerCode.Caption:= IntToStr(SettingMovement.PartnerCode);
      PanelPartnerName.Caption:= SettingMovement.PartnerName;
      PanelRouteUnitCode.Caption:= IntToStr(SettingMovement.RouteSortingCode);
      PanelRouteUnitName.Caption:= SettingMovement.RouteSortingName;

      PanelBillKind.Caption:= CurSetting.DescName+' ';
      if SettingMovement.FromId<>0 then
         PanelBillKind.Caption:= PanelBillKind.Caption+ ' (От Кого) = ' + CurSetting.FromName + ' ';
      if CurSetting.ToId<>0 then
         PanelBillKind.Caption:= PanelBillKind.Caption+ ' (Кому) = ' + CurSetting.ToName + ' ';
      if CurSetting.PaidKindId<>0 then
         PanelBillKind.Caption:= PanelBillKind.Caption + ' (' + CurSetting.PaidKindName + ')' ;
}
     end;

end;


end.
