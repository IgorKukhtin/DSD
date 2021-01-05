unit MakerEdit;

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
  TMakerEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    cxLabel4: TcxLabel;
    GuidesCountry: TdsdGuides;
    ceCountry: TcxButtonEdit;
    cxLabel2: TcxLabel;
    edContactPerson: TcxButtonEdit;
    GuidesContactPerson: TdsdGuides;
    cxLabel7: TcxLabel;
    edSendPlan: TcxDateEdit;
    cxLabel3: TcxLabel;
    edSendReal: TcxDateEdit;
    cbReport1: TcxCheckBox;
    cbReport2: TcxCheckBox;
    cbReport3: TcxCheckBox;
    cbReport4: TcxCheckBox;
    cxLabel5: TcxLabel;
    edAmountDay: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edAmountMonth: TcxCurrencyEdit;
    cbQuarter: TcxCheckBox;
    cb4Month: TcxCheckBox;
    cbReport5: TcxCheckBox;
    cbReport6: TcxCheckBox;
    cbReport7: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TMakerEditForm);

end.
