unit TransportService;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TTransportServiceForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceInvNumber: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel67: TcxLabel;
    cxLabel5: TcxLabel;
    ceContractConditionKind: TcxButtonEdit;
    cePaidKind: TcxButtonEdit;
    ceRoute: TcxButtonEdit;
    ceInfoMoney: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    ceCar: TcxButtonEdit;
    cxLabel9: TcxLabel;
    GuidesContractConditionKind_Old: TdsdGuides;
    GuidesPaidKind: TdsdGuides;
    GuidesRoute: TdsdGuides;
    GuidesInfoMoney: TdsdGuides;
    GuidesCar: TdsdGuides;
    ceJuridical: TcxButtonEdit;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    ceContract: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    GuidesContract: TdsdGuides;
    cxLabel4: TcxLabel;
    ceDistance: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    cePrice: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    ceCountPoint: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    ceTrevelTime: TcxCurrencyEdit;
    GuidesContractJuridical: TdsdGuides;
    cxLabel7: TcxLabel;
    ceUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    cxLabel14: TcxLabel;
    edStartRunPlan: TcxDateEdit;
    cxLabel15: TcxLabel;
    edStartRun: TcxDateEdit;
    cxLabel16: TcxLabel;
    ceWeightTransport: TcxCurrencyEdit;
    GuidesContractConditionKind: TdsdGuides;
    cxLabel17: TcxLabel;
    ceValue: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    ceSummAdd: TcxCurrencyEdit;
    cxLabel19: TcxLabel;
    edMemberExternal: TcxButtonEdit;
    GuidesMemberExternal: TdsdGuides;
    cxLabel20: TcxLabel;
    edDriverCertificate: TcxTextEdit;
    cxLabel21: TcxLabel;
    edSummTransport: TcxCurrencyEdit;
    cxLabel22: TcxLabel;
    edCarTrailer: TcxButtonEdit;
    GuidesCarTrailer: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TTransportServiceForm);

end.
