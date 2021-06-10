unit RepriceSite;

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
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit;

type
  TRepriceSiteForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edTotalSumm: TcxTextEdit;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    PriceOld: TcxGridDBColumn;
    PriceNew: TcxGridDBColumn;
    SummRepriceSite: TcxGridDBColumn;
    MinExpirationDate: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
    PriceDiff: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    Juridical_GoodsName: TcxGridDBColumn;
    MakerName: TcxGridDBColumn;
    Juridical_Price: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    IsTop_Goods: TcxGridDBColumn;
    actRepriceSiteMI: TMultiAction;
    actExecRepriceSiteMI: TdsdExecStoredProc;
    spExecRepriceSiteMI: TdsdStoredProc;
    bbRepriceSiteMI: TdxBarButton;
    bbRepriceSiteMIAll: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarStatic1: TdxBarStatic;
    isResolution_224: TcxGridDBColumn;
    isPromoBonus: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
   
{$R *.dfm}

initialization
  RegisterClass(TRepriceSiteForm);
end.
