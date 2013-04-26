unit GoodsPropertyValueEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction;

type
  TGoodsPropertyValueEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdExecStoredProc: TdsdExecStoredProc;
    dsdFormClose1: TdsdFormClose;
    cxLabel3: TcxLabel;
    ceGoodsProperty: TcxLookupComboBox;
    GoodsPropertyDataSet: TClientDataSet;
    spGetGoodsProperty: TdsdStoredProc;
    GoodsPropertyDS: TDataSource;
    dsdGoodsPropertyGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    ceGoods: TcxLookupComboBox;
    cxLabel4: TcxLabel;
    ceGoodsKind: TcxLookupComboBox;
    GoodsDataSet: TClientDataSet;
    spGetGoods: TdsdStoredProc;
    GoodsDS: TDataSource;
    dsdGoodsGuides: TdsdGuides;
    GoodsKindDataSet: TClientDataSet;
    spGetGoodsKind: TdsdStoredProc;
    GoodsKindDS: TDataSource;
    dsdGoodsKindGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edBarCode: TcxTextEdit;
    cxLabel6: TcxLabel;
    edBarCodeGLN: TcxTextEdit;
    cxLabel7: TcxLabel;
    edArticle: TcxTextEdit;
    edArticleGLN: TcxTextEdit;
    cxLabel8: TcxLabel;
    ceAmount: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsPropertyValueEditForm);

end.
