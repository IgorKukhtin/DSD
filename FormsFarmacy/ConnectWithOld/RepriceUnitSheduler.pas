unit RepriceUnitSheduler;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, Vcl.ExtCtrls, cxSplitter, cxDropDownEdit,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dxBarBuiltInMenu, cxNavigator, cxCurrencyEdit;

type
  TRepriceUnitShedulerForm = class(TAncestorDBGridForm)
    PercentDifference: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    spInsertUpdateRepriceUnitSheduler: TdsdStoredProc;
    dsdUpdateMaster: TdsdUpdateDataSet;
    spErasedUnErased: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    dsdUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    bbdsdChoiceGuides: TdxBarButton;
    cxSplitter1: TcxSplitter;
    clEnumName: TcxGridDBColumn;
    PercentRepriceMax: TcxGridDBColumn;
    PercentRepriceMin: TcxGridDBColumn;
    EqualRepriceMax: TcxGridDBColumn;
    EqualRepriceMin: TcxGridDBColumn;
    DataStartLast: TcxGridDBColumn;
    actOpenUnit: TOpenChoiceForm;
    isEqual: TcxGridDBColumn;
    Ord: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    ProvinceCityName: TcxGridDBColumn;
    UnitRePriceName: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    actOpenUser: TOpenChoiceForm;
    actRepriceUnitSheduler_Line: TdsdExecStoredProc;
    spRepriceUnitSheduler_Line: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRepriceUnitShedulerForm);

end.
