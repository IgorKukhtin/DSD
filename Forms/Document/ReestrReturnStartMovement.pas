unit ReestrReturnStartMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxSplitter,
  cxImageComboBox;

type
  TReestrReturnStartMovementForm = class(TAncestorDocumentForm)
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    actReturnChoiceForm: TOpenChoiceForm;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    BarCode: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    actUpdateDataSet: TdsdUpdateDataSet;
    spSelectBarCode: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    actRefreshStart: TdsdDataSetRefresh;
    LineNum: TcxGridDBColumn;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    RefreshDispatcher: TRefreshDispatcher;
    Checked: TcxGridDBColumn;
    macMISetErased: TMultiAction;
    ExternalDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    macUpdateMov: TMultiAction;
    actUpdate: TdsdDataSetRefresh;
    actPrintPeriod: TdsdPrintAction;
    spSelectPrintPeriod: TdsdStoredProc;
    bbPrintPeriod: TdxBarButton;
    macPrintPeriod: TMultiAction;
    actDialog_Print: TExecuteDialog;
    cxLabel5: TcxLabel;
    edInsertName: TcxButtonEdit;
    InsertGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReestrReturnStartMovementForm);

end.
