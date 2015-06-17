unit TaxJournalDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dsdAction, Vcl.ActnList;

type
  TTaxJournalDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    edDateRegistered: TcxDateEdit;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel6: TcxLabel;
    edIsElectron: TcxCheckBox;
    edInvNumberRegistered: TcxTextEdit;
    cxLabel1: TcxLabel;
    edInvNumber: TcxTextEdit;
    cxLabel2: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    spInsertUpdate: TdsdStoredProc;
    ActionList: TActionList;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxLabel9: TcxLabel;
    edContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTaxJournalDialogForm);

end.
