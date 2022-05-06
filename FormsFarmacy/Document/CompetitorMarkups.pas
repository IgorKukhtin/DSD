unit CompetitorMarkups;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad;

type
  TCompetitorMarkupsForm = class(TAncestorDocumentForm)
    cxSplitter1: TcxSplitter;
    bbactStartLoad: TdxBarButton;
    dxBarButton1: TdxBarButton;
    spCalculationAllDay: TdsdStoredProc;
    dxBarButton2: TdxBarButton;
    bbReport_CalcMonthForm: TdxBarButton;
    CompetitorCDS: TClientDataSet;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Value: TcxGridDBColumn;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    GroupsName: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    mactLoadGoods: TMultiAction;
    actGetImportSetting_LoadGoods: TdsdExecStoredProc;
    actExecuteImportSettings_LoadGoods: TExecuteImportSettingsAction;
    spGetImportSetting_LoadGoods: TdsdStoredProc;
    dxBarButton4: TdxBarButton;
    spInsertUpdateMIMasterAdd: TdsdStoredProc;
    actOpenChoiceCompetitor: TOpenChoiceForm;
    actExecuteSummaDialog: TExecuteDialog;
    actInsertUpdateMIMasterAdd: TdsdExecStoredProc;
    mactInsertUpdateMIMasterAdd: TMultiAction;
    dxBarButton5: TdxBarButton;
    MovementItemProtocolParentOpenForm: TdsdOpenForm;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    actOpenCompetitor: TdsdOpenForm;
    actOpenPriceSubgroups: TdsdOpenForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCompetitorMarkupsForm);

end.
