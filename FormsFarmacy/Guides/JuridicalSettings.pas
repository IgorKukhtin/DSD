unit JuridicalSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxCheckBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit;

type
  TJuridicalSettingsForm = class(TAncestorEnumForm)
    colJuridicalName: TcxGridDBColumn;
    colContract: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    UpdateDataSet: TdsdUpdateDataSet;
    colisPriceClose: TcxGridDBColumn;
    colMainJuridical: TcxGridDBColumn;
    colBonus: TcxGridDBColumn;
    colStartDate: TcxGridDBColumn;
    colEndDate: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colPriceLimit: TcxGridDBColumn;
    col�onditionalPercent: TcxGridDBColumn;
    colisSite: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    bbShowAll: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    colisBonusVirtual: TcxGridDBColumn;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TJuridicalSettingsForm);

end.
