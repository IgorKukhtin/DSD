unit Report_Check_PromoBonusDiscoDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dsdAction, Vcl.ActnList, cxCurrencyEdit;

type
  TReport_Check_PromoBonusDiscoDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    edGoods: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel6: TcxLabel;
    GoodsGuides: TdsdGuides;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    FormParams: TdsdFormParams;
    ceUnit: TcxButtonEdit;
    cxLabel1: TcxLabel;
    UnitGuides: TdsdGuides;
    deEnd: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Check_PromoBonusDiscoDialogForm);

end.
