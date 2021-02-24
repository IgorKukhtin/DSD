unit CashSettingsEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  Vcl.Menus, dsdGuides, Data.DB,
  Datasnap.DBClient, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxPropertiesStore, dsdAddOn, dsdDB, dsdAction,
  Vcl.ActnList, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit,
  cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxCalendar,
  dxSkinsDefaultPainters, cxCheckBox;

type
  TCashSettingsEditForm = class(TParentForm)
    edShareFromPriceName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    spGet: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    edShareFromPriceCode: TcxTextEdit;
    cxLabel2: TcxLabel;
    FormParams: TdsdFormParams;
    cbGetHardwareData: TcxCheckBox;
    edDateBanSUN: TcxDateEdit;
    cxLabel11: TcxLabel;
    edSummaFormSendVIP: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    edSummaUrgentlySendVIP: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    cbBlockVIP: TcxCheckBox;
    cbPairedOnlyPromo: TcxCheckBox;
    edDaySaleForSUN: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    edAttemptsSub: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edDayNonCommoditySUN: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edLowerLimitPromoBonus: TcxCurrencyEdit;
    edUpperLimitPromoBonus: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    edMinPercentPromoBonus: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TCashSettingsEditForm);

end.
