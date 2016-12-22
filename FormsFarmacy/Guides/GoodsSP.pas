unit GoodsSP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm,
  DataModul, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCheckBox, dsdAddOn, dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, ChoicePeriod, cxButtonEdit,
  cxCurrencyEdit, ExternalLoad;

type
  TGoodsSPForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    bbShowAll: TdxBarButton;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    actBrandSPChoice: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    actIntenalSPChoice: TOpenChoiceForm;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    spInsertUpdate: TdsdStoredProc;
    bbDateOut: TdxBarButton;
    actGoodsChoiceForm: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    actKindOutSPChoice: TOpenChoiceForm;
    spUpdate_Goods_isSP: TdsdStoredProc;
    actGetImportSetting: TdsdExecStoredProc;
    actStartLoad: TMultiAction;
    spGetImportSettingId: TdsdStoredProc;
    bbStartLoad: TdxBarButton;
    actDoLoad: TExecuteImportSettingsAction;
    FormParams: TdsdFormParams;
    spInsertUpdateLoad: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TGoodsSPForm);
end.
