unit MobileEmployeeEdit;

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
  TMobileEmployeeEditForm = class(TParentForm)
    edPersonal: TcxButtonEdit;
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
    edComment: TcxTextEdit;
    lblComments: TcxLabel;
    PersonalGuides: TdsdGuides;
    lblMobileNumber: TcxLabel;
    ceMobileNumber: TcxTextEdit;
    edTariff: TcxButtonEdit;
    lblTariff: TcxLabel;
    MobileTariffGuide: TdsdGuides;
    cxGroupBox2: TcxGroupBox;
    lblLimit: TcxLabel;
    ceLimit: TcxCurrencyEdit;
    lblLimitDuty: TcxLabel;
    ceDutyLimit: TcxCurrencyEdit;
    lblNavigator: TcxLabel;
    ceNavigator: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    edRegion: TcxButtonEdit;
    RegionGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    edMobilePack: TcxButtonEdit;
    GuidesMobilePack: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TMobileEmployeeEditForm);
end.
