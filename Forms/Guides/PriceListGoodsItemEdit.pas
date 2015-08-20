unit PriceListGoodsItemEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore, dsdDB,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, dsdAction, ParentForm, cxCurrencyEdit, dxSkinsCore, dsdAddOn, cxCheckBox,
  dxSkinsDefaultPainters, dsdGuides, cxMaskEdit, cxButtonEdit, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxDropDownEdit, cxCalendar;

type
  TPriceListGoodsItemEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    Код: TcxLabel;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    edStartDate: TcxDateEdit;
    cxLabel1: TcxLabel;
    edEndDate: TcxDateEdit;
    cePrice: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceListGoodsItemEditForm);

end.
