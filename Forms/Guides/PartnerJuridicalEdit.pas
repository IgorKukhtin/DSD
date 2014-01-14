unit PartnerJuridicalEdit;

interface

uses
  AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, dsdGuides, cxMaskEdit,
  cxButtonEdit, cxCurrencyEdit, cxLabel, Vcl.Controls, cxTextEdit, dsdDB,
  dsdAction, System.Classes, Vcl.ActnList, cxPropertiesStore, dsdAddOn,
  Vcl.StdCtrls, cxButtons, dxSkinsCore, dxSkinsDefaultPainters, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxDropDownEdit, cxCalendar;

type
  TPartnerJuridicalEditForm = class(TAncestorEditDialogForm)
    edAddress: TcxTextEdit;
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    edGLNCode: TcxTextEdit;
    cxLabel3: TcxLabel;
    edJuridical: TcxButtonEdit;
    dsdJuridicalGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    ceRoute: TcxButtonEdit;
    cxLabel7: TcxLabel;
    ceRouteSorting: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cePersonalTake: TcxButtonEdit;
    dsdPersonalGuides: TdsdGuides;
    dsdRouteSortingGuides: TdsdGuides;
    dsdRouteGuides: TdsdGuides;
    cePrepareDayCount: TcxCurrencyEdit;
    ceDocumentDayCount: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    cePriceList: TcxButtonEdit;
    dsdPriceListGuides: TdsdGuides;
    cePriceListPromo: TcxButtonEdit;
    dsdPriceListPromoGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    edStartPromo: TcxDateEdit;
    edEndPromo: TcxDateEdit;

  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}


initialization
  RegisterClass(TPartnerJuridicalEditForm);

end.
