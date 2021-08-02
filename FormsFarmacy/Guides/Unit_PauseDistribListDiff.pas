unit Unit_PauseDistribListDiff;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxCurrencyEdit, cxButtonEdit;

type
  TUnit_PauseDistribListDiffForm = class(TAncestorDBGridForm)
    bbOpen: TdxBarButton;
    isRequestDistribListDiff: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    actisPauseDistribListDiff: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    spUnit_isPauseDistribListDiff: TdsdStoredProc;
    actShowAll: TBooleanStoredProcAction;
    dxBarButton3: TdxBarButton;
    isPauseDistribListDiff: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TUnit_PauseDistribListDiffForm);

end.
