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
  dxSkinsDefaultPainters;

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
    ButtonSaveItem: TSpeedButton;
    CodeInfoPanel: TPanel;
    EnterGoodsCodeScanerPanel: TPanel;
    EnterGoodsCodeScanerLabel: TLabel;
    EnterGoodsCodeScanerEdit: TEdit;
    EnterWeightPanel: TPanel;
    EnterWeightLabel: TLabel;
    EnterWeightEdit: TEdit;
    gbBillDate: TGroupBox;
    EnterGoodsCode_byZakazPanel: TPanel;
    EnterGoodsCode_byZakazLabel: TLabel;
    EnterGoodsCode_byZakazEdit: TEdit;
    PanelCountTare: TPanel;
    LabelCountTare: TLabel;
    CountTareEdit: TEdit;
    infoPanel_Scale: TPanel;
    ScaleLabel: TLabel;
    Panel_Scale: TPanel;
    EnterKindPackageCode_byZakazPanel: TPanel;
    EnterKindPackageCode_byZakazLabel: TLabel;
    EnterKindPackageCode_byZakazEdit: TEdit;
    EnterKindPackageName_byZakazPanel: TPanel;
    gbPartionDate: TGroupBox;
    PanelCountPoddon: TPanel;
    LabelCountPoddon: TLabel;
    CountPoddonEdit: TEdit;
    PanelCountVanna: TPanel;
    LabelCountVanna: TLabel;
    CountVannaEdit: TEdit;
    PanelCountUpakovka: TPanel;
    LabelCountUpakovka: TLabel;
    CountUpakovkaEdit: TEdit;
    PanelPartionStr_MB: TPanel;
    PartionStr_MBLabel: TLabel;
    Panel1: TPanel;
    infoPanelPartionStr_MB: TPanel;
    PartionStr_MBEdit: TEdit;
    PanelOperCount_sh: TPanel;
    LabelOperCount_sh: TLabel;
    OperCount_shEdit: TEdit;
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
    PartionDateEdit: TcxDateEdit;
    BillDateEdit: TcxDateEdit;
    spSelect: TdsdStoredProc;
    DS: TDataSource;
    CDS: TClientDataSet;
    procedure ButtonExportToEDIClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ButtonNewGetParamsClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
  private
    procedure GetParams;
    procedure newGetParamsGoods;
    function myCheckPartionStr:boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses UtilScale, DialogMovementDesc, GuideGoods;

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


     if GuideGoodsForm.Execute(calcClientId,StrToDate(BillDateEdit.Text))
//     if GuideGoodsForm.Execute
     then begin

     end;

//
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

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TInifile;
begin
  Ini:=TIniFile.Create('INI\scale.ini');
  SettingMain.ScaleNum:=Ini.ReadInteger('Main','ScaleNum',1);
  SettingMain.ComPort :=Ini.ReadString('Main','ComPort','1');
  Ini.Free;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = VK_F2 then GetParams;
     if Key = VK_SPACE then begin Key:=0;ButtonNewGetParamsClick(self);end
end;


procedure TMainForm.GetParams;
begin

     if DialogMovementDescForm.Execute
     then begin
      PanelPriceListName.Caption:= SettingMovement.PriceListName;
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
