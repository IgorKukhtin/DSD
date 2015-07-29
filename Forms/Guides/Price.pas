unit Price;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, Vcl.ExtCtrls, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxCurrencyEdit, ExternalLoad;

type
  TPriceForm = class(TAncestorEnumForm)
    dxBarControlContainerItemUnit: TdxBarControlContainerItem;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    dxBarButton1: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    actShowDel: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clPrice: TcxGridDBColumn;
    clDateChange: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    dsdUpdatePrice: TdsdUpdateDataSet;
    rdUnit: TRefreshDispatcher;
    clMCSValue: TcxGridDBColumn;
    clMCSDateChange: TcxGridDBColumn;
    actStartLoadMCS: TMultiAction;
    actDoLoadMCS: TExecuteImportSettingsAction;
    dxBarButton3: TdxBarButton;
    spGetImportSetting_MCS: TdsdStoredProc;
    actGetImportSetting_MCS: TdsdExecStoredProc;
    spGetImportSetting_Price: TdsdStoredProc;
    actGetImportSetting_Price: TdsdExecStoredProc;
    actDoLoadPrice: TExecuteImportSettingsAction;
    actStartLoadPrice: TMultiAction;
    dxBarButton4: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PriceForm: TPriceForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPriceForm)
end.
