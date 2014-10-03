unit PersonalService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  TPersonalServiceForm = class(TAncestorDocumentForm)
    colINN: TcxGridDBColumn;
    colPersonalName: TcxGridDBColumn;
    colPositionName: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    colSummCard: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
    deServiceDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel12: TcxLabel;
    colSummService: TcxGridDBColumn;
    colSummMinus: TcxGridDBColumn;
    colSummAdd: TcxGridDBColumn;
    cePersonalServiceList: TcxButtonEdit;
    PersonalServiceListGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    colUnitCode: TcxGridDBColumn;
    colPersonalCode: TcxGridDBColumn;
    colIsMain: TcxGridDBColumn;
    colIsOfficial: TcxGridDBColumn;
    colAmountCash: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    ceJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    colSummCardRecalc: TcxGridDBColumn;
    colSummSocialIn: TcxGridDBColumn;
    colSummSocialAdd: TcxGridDBColumn;
    colSummChild: TcxGridDBColumn;
    colMemberName: TcxGridDBColumn;
    MemberChoiceForm: TOpenChoiceForm;
    colAmountToPay: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPersonalServiceForm);

end.
