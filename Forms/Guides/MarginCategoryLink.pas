unit MarginCategoryLink;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxContainer, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxLabel, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox;

type
  TMarginCategoryLinkForm = class(TAncestorEnumForm)
    colMarginCategoryName: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actInsertUpdate: TdsdUpdateDataSet;
    colJuridicalName: TcxGridDBColumn;
    actChoiceMarginCategory: TOpenChoiceForm;
    actChoiceUnit: TOpenChoiceForm;
    actChoiceJuridical: TOpenChoiceForm;
    spErasedUnErased: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMarginCategoryLinkForm)


end.
