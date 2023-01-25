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
    function isLastRecord: boolean;
    function RecordCount: integer;
    procedure Next;     virtual;
    procedure Close;    virtual; abstract;
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

function TExternalData.isLastRecord: boolean;
begin
  result := false;
  if FDataSet.EOF then
     exit;
  FDataSet.Next;
  result := FDataSet.EOF;
  if not result then
     FDataSet.Prior;
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

