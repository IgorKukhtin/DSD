unit MCS_Lite;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Price, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, dsdAddOn, dsdDB, dsdGuides, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, ExternalLoad, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, dxSkinsdxBarPainter, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxLabel, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxCheckBox;

type
  TMCS_LiteForm = class(TPriceForm)
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MCS_LiteForm: TMCS_LiteForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TMCS_LiteForm);
end.
