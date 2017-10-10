unit uIntf;

interface

uses
  Data.DB;

type
  IDataSetCacheItem = interface
    ['{A48DA462-CDD5-4A16-A13B-5194B0833F73}']
    function GetName: string;
    function GetParams: TParams;
    function GetDataSet: TDataSet;

    function IsEqual(AName: string; AParams: TParams): Boolean;

    property Name: string read GetName;
    property Params: TParams read GetParams;
    property DataSet: TDataSet read GetDataSet;
  end;

  IDataSetCache = interface
    ['{34477535-8C3E-4FCE-9F44-D70DECF8A710}']
    function GetActiveDataSet: TDataSet;

    procedure Add(AName: string; AParams: TParams; ASource: TDataSet);
    function Find(AName: string; AParams: TParams): IDataSetCacheItem;
    procedure Clear;

    property ActiveDataSet: TDataSet read GetActiveDataSet;
  end;

var
  DataSetCache: IDataSetCache;

implementation

end.
