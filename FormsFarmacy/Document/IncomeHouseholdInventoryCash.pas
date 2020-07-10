unit IncomeHouseholdInventoryCash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IncomeHouseholdInventory, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems,
  dxBar, cxClasses, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxLabel, cxTextEdit, Vcl.ExtCtrls, cxSplitter, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC;

type
  TIncomeHouseholdInventoryCashForm = class(TIncomeHouseholdInventoryForm)
    spGet_UserUnit: TdsdStoredProc;
    actspGet_UserUnit: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TIncomeHouseholdInventoryCashForm);

end.
