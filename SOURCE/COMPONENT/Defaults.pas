unit Defaults;

interface

uses Classes, dsdDB;

type

  TDefaultType = (dtGuides, dtText, dtDate);

  // Возвращает ключ для дефолтных значений
  TDefaultKey = class(TComponent)
  private
    FParam: TdsdParam;
  public
    function Key: string;
    function JSONKey: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Param: TdsdParam read FParam write FParam;
  end;

  //
  function GetDefaultJSON(DefaultType: TDefaultType; DefaultValue: Variant): string;

implementation

function GetDefaultJSON(DefaultType: TDefaultType; DefaultValue: Variant): string;
begin
  result := '{"DefaultType":"dtGuides", "Value":"' + DefaultValue + '"}';
end;

{ TDefaultKey }

constructor TDefaultKey.Create(AOwner: TComponent);
begin
  inherited;
  FParam := TdsdParam.Create(nil);
end;

destructor TDefaultKey.Destroy;
begin
  FParam.Free;
  inherited;
end;

function TDefaultKey.JSONKey: string;
var FormClass: string;
begin
  if Assigned(Owner) then
     FormClass := Owner.ClassName
  else
     FormClass := '';
  result := '{"FormClass":"' + FormClass + '",' +
            ' "Param":"' + Param.Value + '"' +
            '}';
end;

function TDefaultKey.Key: string;
begin
  result := '';
  if Assigned(Owner) then
     result := Owner.ClassName;
  if Param.Value <> '' then
     result := result + ';' + Param.Value
end;

end.
