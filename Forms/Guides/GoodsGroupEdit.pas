unit GoodsGroupEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore, dsdDB,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, dsdAction, ParentForm, Data.DB, Datasnap.DBClient,
  cxCurrencyEdit, cxMaskEdit, cxDropDownEdit, cxDBEdit, cxCustomData, cxStyles,
  cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer, cxTLData, cxDBTL,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, dsdGuides,
  Vcl.Grids, Vcl.DBGrids, dxSkinsCore, cxButtonEdit, dsdAddOn,
  dxSkinsDefaultPainters;

type
  TGoodsGroupEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    ceCode: TcxCurrencyEdit;
    ���: TcxLabel;
    GoodsGroupGuides: TdsdGuides;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    ceParentGroup: TcxButtonEdit;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    cxLabel3: TcxLabel;
    ceGroupStat: TcxButtonEdit;
    GoodsGroupStatGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    ceTradeMark: TcxButtonEdit;
    TradeMarkGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    ceGoodsTag: TcxButtonEdit;
    GoodsTagGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    ceGoodsGroupAnalyst: TcxButtonEdit;
    GoodsGroupAnalystGuides: TdsdGuides;
    cxLabel7: TcxLabel;
    ceGoodsPlatform: TcxButtonEdit;
    GoodsPlatformGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    ceCodeUKTZED: TcxTextEdit;
    cxLabel10: TcxLabel;
    ceTaxImport: TcxTextEdit;
    cxLabel11: TcxLabel;
    ceDKPP: TcxTextEdit;
    cxLabel12: TcxLabel;
    ceTaxAction: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsGroupEditForm);

end.
