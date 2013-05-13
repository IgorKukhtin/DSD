unit ParentForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dsdDB;

type
  TParentForm = class(TForm)
  private
    FParams: TdsdParams;
  public
    { Public declarations }
    property Params: TdsdParams read FParams;
    procedure Execute(Params: TdsdParams);
  end;

implementation

uses cxPropertiesStore, cxControls, cxContainer, cxEdit, cxGroupBox,
  dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dxBar, Vcl.ActnList, dsdAction, cxTextEdit, cxLabel,
  StdActns, cxDBTL, cxCurrencyEdit, cxDropDownEdit, dsdGuides,
  cxDBLookupComboBox, DBGrids, cxCheckBox, cxCalendar, ExtCtrls;

{$R *.dfm}

procedure TParentForm.Execute(Params: TdsdParams);
var
  i: integer;
begin
  // Заполняет параметры формы переданными параметрами
  for I := 0 to ComponentCount - 1 do
    if Components[i] is TdsdFormParams then begin
       FParams := (Components[i] as TdsdFormParams).Params;
       FParams.Assign(Params);
  end;

  for I := 0 to ComponentCount - 1 do begin
    // Перечитывает видимые компоненты
    if Components[i] is TdsdDataSetRefresh then
       (Components[i] as TdsdDataSetRefresh).Execute;
    if Components[i] is TcxPropertiesStore then
       (Components[i] as TcxPropertiesStore).RestoreFrom;
  end;
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
  RegisterClass (TdxBevel);
  RegisterClass (TcxButton);
  RegisterClass (TcxCheckBox);
  RegisterClass (TcxDateEdit);
  RegisterClass (TcxGroupBox);
  RegisterClass (TcxGridDBTableView);
  RegisterClass (TcxGrid);
  RegisterClass (TcxPropertiesStore);
  RegisterClass (TcxTextEdit);
  RegisterClass (TcxLabel);
  RegisterClass (TcxCurrencyEdit);
  RegisterClass (TcxDBTreeList);
  RegisterClass (TcxDBTreeListColumn);
  RegisterClass (TcxPopupEdit);
  RegisterClass (TcxLookupComboBox);
  RegisterClass (TdxBarManager);
  // Собственнтые компоненты
  RegisterClass (TdsdOpenForm);
  RegisterClass (TdsdStoredProc);
  RegisterClass (TdsdFormParams);
  RegisterClass (TdsdFormClose);
  RegisterClass (TdsdUpdateErased);
  RegisterClass (TdsdDataSetRefresh);
  RegisterClass (TdsdExecStoredProc);
  RegisterClass (TdsdInsertUpdateAction);
  RegisterClass (TdsdGuides);


end.
