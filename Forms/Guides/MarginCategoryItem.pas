unit MarginCategoryItem;

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
  cxLabel, cxCurrencyEdit;

type
  TMarginCategoryItemForm = class(TAncestorEnumForm)
    colMinPice: TcxGridDBColumn;
    colMarginPercent: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actInsertUpdate: TdsdUpdateDataSet;
    MarginCategoryGuides: TdsdGuides;
    cxLabel1: TcxLabel;
    bbLabel: TdxBarControlContainerItem;
    ceMarginCategory: TcxButtonEdit;
    bbGuides: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMarginCategoryItemForm)


end.
