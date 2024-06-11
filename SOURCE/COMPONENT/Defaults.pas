unit Defaults;

interface

uses Classes, Vcl.Controls, dsdCommon, dsdDB;

type

  TDefaultType = (dtGuides, dtText, dtDate);

  // Возвращает ключ для дефолтных значений
  TDefaultKey = class(TdsdComponent)
  private
    FParams: TdsdParams;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Key: string;
    function JSONKey: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Params: TdsdParams read FParams write FParams;
  end;

  //
  function GetDefaultJSON(DefaultType: TDefaultType; DefaultValue: Variant): string;

  procedure Register;

implementation

uses SysUtils, utilConvert;


procedure Register;
begin
   RegisterComponents('DSDComponent', [TDefaultKey]);
end;

function GetDefaultJSON(DefaultType: TDefaultType; DefaultValue: Variant): string;
begin
  result := '{"DefaultType":"dtGuides", "Value":"' + DefaultValue + '"}';
end;

{ TDefaultKey }

constructor TDefaultKey.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TdsdParams.Create(Self, TdsdParam);
end;

destructor TDefaultKey.Destroy;
begin
  FreeAndNil(FParams);
  inherited;
end;

function TDefaultKey.JSONKey: string;
var Param: TCollectionItem;
begin
  result := '';
  for Param in Params do
      with TdsdParam(Param) do
         if Value <> '' then begin
            if result <> '' then result := result + ',';
            result := result + '"' + Name + '":"' + Value +'"';
         end;
  result := '{' + result + '}';
  result := gfStrToXmlStr (result);
end;

function TDefaultKey.Key: string;
var Param: TCollectionItem;
begin
  result := '';
  for Param in Params do
      with TdsdParam(Param) do
         if Value <> '' then begin
            if result <> '' then result := result + ';';
            result := result + Value
         end;
end;

procedure TDefaultKey.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;

  if csDesigning in ComponentState then
    if (Operation = opRemove) and Assigned(Params) then
       for I := 0 to Params.Count - 1 do
           if Params[i].Component = AComponent then
              Params[i].Component := nil;
end;

initialization
  RegisterClass(TDefaultKey)

end.
