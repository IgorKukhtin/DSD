unit ParentForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dsdDB;

type
  TParentForm = class(TForm)
  private
    FParams: TdsdParams;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    { Public declarations }
    property Params: TdsdParams read FParams;
    procedure Execute(Params: TdsdParams);
  end;

implementation

uses UtilConst, cxPropertiesStore, cxControls, cxContainer, cxEdit, cxGroupBox,
  dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dxBar, Vcl.ActnList, dsdAction, cxTextEdit, cxLabel,
  StdActns, cxDBTL, cxCurrencyEdit, cxDropDownEdit, dsdGuides,
  cxDBLookupComboBox, DBGrids, cxCheckBox, cxCalendar, ExtCtrls, dsdAddOn,
  cxButtonEdit, cxSplitter;

{$R *.dfm}

procedure TParentForm.Execute(Params: TdsdParams);
var
  i: integer;
begin
  onKeyDown := FormKeyDown;
  // Заполняет параметры формы переданными параметрами
  for I := 0 to ComponentCount - 1 do
    if Components[i] is TdsdFormParams then begin
       FParams := (Components[i] as TdsdFormParams).Params;
       FParams.AssignParams(Params);
  end;

  for I := 0 to ComponentCount - 1 do begin
    // Перечитывает видимые компоненты
    if Components[i] is TdsdDataSetRefresh then
       (Components[i] as TdsdDataSetRefresh).Execute;
    if Components[i] is TcxPropertiesStore then
       (Components[i] as TcxPropertiesStore).RestoreFrom;
  end;
end;

procedure TParentForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) and (ssCtrl in Shift)
      and (Key in [byte('s'), byte('S')]) then
      gc_isDebugMode := not gc_isDebugMode;
end;

initialization
  // Стандартные компоненты
  RegisterClass (TActionList);
  RegisterClass (TClientDataSet);
  RegisterClass (TDataSource);
  RegisterClass (TDBGrid);
  RegisterClass (TFileExit);
  RegisterClass (TPanel);
  // Библиотека DevExpress

  RegisterClass (TcxButton);
  RegisterClass (TcxButtonEdit);
  RegisterClass (TcxCheckBox);
  RegisterClass (TcxCurrencyEdit);
  RegisterClass (TcxDateEdit);
  RegisterClass (TcxDBTreeList);
  RegisterClass (TcxDBTreeListColumn);
  RegisterClass (TcxGroupBox);
  RegisterClass (TcxGridDBTableView);
  RegisterClass (TcxGrid);
  RegisterClass (TcxLabel);
  RegisterClass (TcxLookupComboBox);
  RegisterClass (TcxPopupEdit);
  RegisterClass (TcxPropertiesStore);
  RegisterClass (TcxSplitter);
  RegisterClass (TcxTextEdit);

  RegisterClass (TdxBarManager);
  RegisterClass (TdxBevel);
  // Собственнтые компоненты
  RegisterClass (TdsdChoiceGuides);
  RegisterClass (TdsdDataSetRefresh);
  RegisterClass (TdsdDBTreeAddOn);
  RegisterClass (TdsdExecStoredProc);
  RegisterClass (TdsdFormClose);
  RegisterClass (TdsdFormParams);
  RegisterClass (TdsdGuides);
  RegisterClass (TdsdInsertUpdateAction);
  RegisterClass (TdsdOpenForm);
  RegisterClass (TdsdStoredProc);
  RegisterClass (TdsdUpdateErased);

end.
