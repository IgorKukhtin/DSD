unit MarginCategory_All;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxCheckBox;

type
  TMarginCategory_AllForm = class(TAncestorEnumForm)
    MarginCategoryName: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actInsertUpdate: TdsdUpdateDataSet;
    Value_1: TcxGridDBColumn;
    avgPercent: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    dsdSetUnErased: TdsdUpdateErased;
    bbSetUnErased: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    ProtocolOpenForm1: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    ProvinceCityName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    ProtocolOpenForm2: TdsdOpenForm;
    ProtocolOpenForm7: TdsdOpenForm;
    ProtocolOpenForm6: TdsdOpenForm;
    ProtocolOpenForm3: TdsdOpenForm;
    ProtocolOpenForm4: TdsdOpenForm;
    ProtocolOpenForm5: TdsdOpenForm;
    bbProtocolOpenForm2: TdxBarButton;
    bbProtocolOpenForm3: TdxBarButton;
    bbProtocolOpenForm4: TdxBarButton;
    bbProtocolOpenForm5: TdxBarButton;
    bbProtocolOpenForm6: TdxBarButton;
    bbProtocolOpenForm7: TdxBarButton;
    actUpdateParam: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    macUpdateParam: TMultiAction;
    FormParams: TdsdFormParams;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMarginCategory_AllForm)


end.
