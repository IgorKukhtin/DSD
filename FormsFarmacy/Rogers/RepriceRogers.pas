unit RepriceRogers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, dsdExportToXMLAction;

type
  TRepriceRogersForm = class(TAncestorDocumentForm)
    edUnit: TcxButtonEdit;
    lblUnit: TcxLabel;
    GuidesUnit: TdsdGuides;
    cxLabel3: TcxLabel;
    edTotalSumm: TcxTextEdit;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    PriceOld: TcxGridDBColumn;
    PriceNew: TcxGridDBColumn;
    SummRepriceRogers: TcxGridDBColumn;
    MinExpirationDate: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
    PriceDiff: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    Juridical_GoodsName: TcxGridDBColumn;
    MakerName: TcxGridDBColumn;
    MarginPercent: TcxGridDBColumn;
    Juridical_Price: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edUnitForwarding: TcxButtonEdit;
    UnitForwardingGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    Color_calc: TcxGridDBColumn;
    IsTop_Goods: TcxGridDBColumn;
    bbRepriceRogersMI: TdxBarButton;
    bbRepriceRogersMIAll: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarStatic1: TdxBarStatic;
    actExportToXML: TdsdExportToXML;
    spMovementItem_Reprice_XML: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
   
{$R *.dfm}

initialization
  RegisterClass(TRepriceRogersForm);
end.
