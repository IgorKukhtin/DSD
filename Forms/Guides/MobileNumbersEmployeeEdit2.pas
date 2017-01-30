unit MobileNumbersEmployeeEdit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction, cxButtonEdit, dsdAddOn, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxCalendar, cxGroupBox, dxSkinsCore, dxSkinsDefaultPainters;

type
  TMobileNumbersEmployeeEdit2Form = class(TParentForm)
    edEmployeeName: TcxButtonEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
    lblID: TcxLabel;
    ceCode: TcxCurrencyEdit;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    edComments: TcxTextEdit;
    lblComments: TcxLabel;
    cxGroupBox2: TcxGroupBox;
    lblLimit: TcxLabel;
    ceLimit: TcxCurrencyEdit;
    lblLimitDuty: TcxLabel;
    ceLimitDuty: TcxCurrencyEdit;
    lblOverLimit: TcxLabel;
    ceOverLimit: TcxCurrencyEdit;
    lblNavigator: TcxLabel;
    ceNavigator: TcxCurrencyEdit;
    EmployeeGuides: TdsdGuides;
    lblMobileNumber: TcxLabel;
    ceMobileNumber: TcxTextEdit;
    edTariff: TcxButtonEdit;
    lblTariff: TcxLabel;
    MobileTariffGuide: TdsdGuides;
    dsdStoredProc1: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TMobileNumbersEmployeeEdit2Form);
end.
