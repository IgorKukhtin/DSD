unit CorrectWagesPercentage;

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
  dxBarBuiltInMenu, cxNavigator, cxCalendar, cxCurrencyEdit;

type
  TCorrectWagesPercentageForm = class(TAncestorDBGridForm)
    UnitName: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    spInsertUpdateCorrectWagesPercentage: TdsdStoredProc;
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
    actOpenUnit: TOpenChoiceForm;
    Code: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    actOpenUser: TOpenChoiceForm;
    dxBarButton1: TdxBarButton;
    DateStart: TcxGridDBColumn;
    DateEnd: TcxGridDBColumn;
    Percent: TcxGridDBColumn;
    isCheck: TcxGridDBColumn;
    isStore: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCorrectWagesPercentageForm);

end.
