unit UDefinitions;

interface

uses
  FireDAC.Comp.Client;

type
  TNotifyProc = procedure of object;
  TNotifyMsgProc = procedure(const AMsg: string) of object;

  TDataObjects = record
    HeaderQry, DetailQry, InsertQry, ErrorQry, SelectQry, DoneQry, ExecQry: TFDQuery;
  end;

implementation

end.
