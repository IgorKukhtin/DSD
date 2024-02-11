unit dsdDataSetDataLink;

interface

uses DB;

type
  // �������� ������� ��� ��������� ����� ���������� ��������
  IDataSetAction = interface
    procedure DataSetChanged;
    procedure UpdateData;
  end;


  TDataSetDataLink = class(TDataLink)
  private
    FAction: IDataSetAction;
    // ������ ����, ������ ��� UpdateData ����������� ������!!!
    FModified: Boolean;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure UpdateData; override;
  public
    constructor Create(Action: IDataSetAction);
  end;


implementation

{ TActionDataLink }

constructor TDataSetDataLink.Create(Action: IDataSetAction);
begin
  inherited Create;
  FAction := Action;
end;

procedure TDataSetDataLink.DataSetChanged;
begin
  inherited;
  if Assigned(FAction) then
    FAction.DataSetChanged;
end;

procedure TDataSetDataLink.EditingChanged;
begin
  inherited;
  if Assigned(DataSource) and (DataSource.State in [dsEdit, dsInsert]) then
    FModified := true;
end;

procedure TDataSetDataLink.UpdateData;
begin
  inherited;
  if Assigned(FAction) and FModified then
    FAction.UpdateData;
  FModified := false;
end;


end.
