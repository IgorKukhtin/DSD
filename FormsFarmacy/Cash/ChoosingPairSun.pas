unit ChoosingPairSun;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  dxSkinsdxBarPainter, dxBar, cxSpinEdit, dxBarExtItems, cxBarEditItem,
  cxBlobEdit, cxCheckBox, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, System.Actions,
  dxDateRanges;

type
  TChoosingPairSunForm = class(TForm)
    ChoosingPairSunGrid: TcxGrid;
    ChoosingPairSunGridDBTableView: TcxGridDBTableView;
    ChoosingPairSunGridLevel: TcxGridLevel;
    ChoosingPairSunDS: TDataSource;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    ChoosingPairSunCDS: TClientDataSet;
    BarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarButton1: TdxBarButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    dxBarStatic1: TdxBarStatic;
    colRemains: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    dxBarButton3: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    Label10: TLabel;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    actOk: TAction;
    dxBarButton4: TdxBarButton;
    ChoosingPairSunCDSId: TIntegerField;
    ChoosingPairSunCDSGoodsCode: TIntegerField;
    ChoosingPairSunCDSGoodsName: TStringField;
    ChoosingPairSunCDSRemains: TCurrencyField;
    ChoosingPairSunCDSAmount: TCurrencyField;
    ChoosingPairSunCDSPrice: TCurrencyField;
    ChoosingPairSunCDSPartionDateKindId: TIntegerField;
    ChoosingPairSunCDSNDSKindId: TIntegerField;
    ChoosingPairSunCDSDiscountExternalID: TIntegerField;
    ChoosingPairSunCDSDivisionPartiesID: TIntegerField;
    procedure actOkExecute(Sender: TObject);
    procedure ChoosingPairSunGridDBTableViewDblClick(Sender: TObject);
  private
    { Private declarations }
    FAmount : Currency;
  public
    property Amount : Currency read FAmount write FAmount;
  end;


implementation

{$R *.dfm}

uses CommonData;


procedure TChoosingPairSunForm.actOkExecute(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TChoosingPairSunForm.ChoosingPairSunGridDBTableViewDblClick(
  Sender: TObject);
begin
  ModalResult := mrOk;
end;

End.
