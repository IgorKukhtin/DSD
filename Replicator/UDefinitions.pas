unit UDefinitions;

interface

type
  TMessageLine = (mlNew, mlSame);
  TNotifyMessage = procedure(const AMsg: string; const AFileName: string = ''; ALine: TMessageLine = mlNew) of object;
  TOnChangeStartId = procedure (const ANewStartId: Integer) of object;
  TOnNewSession = procedure(const AStart: TDateTime; const AMinId, AMaxId, ARecCount, ASessionNumber: Integer) of object;

  TServerRank = (srMaster, srSlave);

  TThreadKind = (tknDriven, tknNondriven);

  TDataRec = record
    Id: Integer;
    TransId: Integer;
    SQL: string;
  end;

  TMaxIdTransId = record
    MaxId: Integer;
    TransId: Integer;
  end;

  TDataRecArray = array of TDataRec;

  TMaxIdTransIdArray = array of TMaxIdTransId;

implementation

end.
