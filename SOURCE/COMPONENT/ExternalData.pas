unit ExternalData;

interface
uses DB;

type

  TExternalData = class
  protected
    FActive: boolean;
    FDataSet: TDataSet;
    FOEM: boolean;
    // Установка на первую запись
    procedure First; virtual; abstract;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function EOF: boolean;
    function RecordCount: integer;
    procedure Next;     virtual;
    procedure Activate; virtual; abstract;
    property Active: boolean read FActive;
  end;


implementation

uses SysUtils;
{ TExternalData }

constructor TExternalData.Create;
begin
  FActive := false;
  FOEM := false;
end;

destructor TExternalData.Destroy;
begin
  if Assigned(FDataSet) then
     FreeAndNil(FDataSet);
end;

function TExternalData.EOF: boolean;
begin
  result := (not Assigned(FDataSet)) or (not FDataSet.Active) or FDataSet.Eof;
end;

procedure TExternalData.Next;
begin
  FDataSet.Next;
end;

function TExternalData.RecordCount: integer;
begin
  result  := FDataSet.RecordCount
end;

end.
