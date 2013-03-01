unit dsdActionUnit;

interface

uses VCL.ActnList, Classes, dsdDataSetWrapperUnit;

type

  TdsdDataSetRefresh = class(TCustomAction)
  private
    FDataSetWrapper: TdsdDataSetWrapper;
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  published
    property DataSetWrapper: TdsdDataSetWrapper read FDataSetWrapper write FDataSetWrapper;
    property Caption;
    property Hint;
    property ShortCut;
  end;

  procedure Register;

implementation

uses Windows;

procedure Register;
begin
  RegisterActions('DSDLib', [TdsdDataSetRefresh], TdsdDataSetRefresh);
end;

{ TdsdDataSetRefresh }

constructor TdsdDataSetRefresh.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Перечитать';
  Hint:='Обновить данные';
  ShortCut:=VK_F5
end;

function TdsdDataSetRefresh.Execute: boolean;
begin
  if Assigned(DataSetWrapper) then
     DataSetWrapper.Execute
end;

end.
