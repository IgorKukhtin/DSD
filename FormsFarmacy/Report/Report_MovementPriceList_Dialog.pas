unit Report_MovementPriceList_Dialog;

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
  TReport_MovementPriceList_DialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    cxLabel4: TcxLabel;
    edJuridical1: TcxButtonEdit;
    cxLabel1: TcxLabel;
    edJuridical2: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edJuridical3: TcxButtonEdit;
    GuidesJuridical1: TdsdGuides;
    GuidesJuridical2: TdsdGuides;
    GuidesJuridical3: TdsdGuides;
    cxLabel5: TcxLabel;
    edContract1: TcxButtonEdit;
    cxLabel2: TcxLabel;
    edContract2: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edContract3: TcxButtonEdit;
    GuidesContract1: TdsdGuides;
    GuidesContract2: TdsdGuides;
    GuidesContract3: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MovementPriceList_DialogForm);

end.
