unit ReestrStartDialog;

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
  TReestrStartDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    spInsertUpdate: TdsdStoredProc;
    ActionList: TActionList;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    edMember: TcxTextEdit;
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    edDriver: TcxTextEdit;
    cxLabel2: TcxLabel;
    edCar: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReestrStartDialogForm);

end.
