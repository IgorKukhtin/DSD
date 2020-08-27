unit UDefinitions;

interface

type
  TLogMessageType = (lmtPlain, lmtError);
  TNotifyMessage = procedure(const AMsg: string; const AFileName: string = ''; const aUID: Cardinal = 0; AMsgType: TLogMessageType = lmtPlain) of object;
  TOnChangeStartId = procedure (const ANewStartId: Integer) of object;
  TOnNewSession = procedure(const AStart: TDateTime; const AMinId, AMaxId, ARecCount, ASessionNumber: Integer) of object;
  TConditionFunc = reference to function(): Boolean;

  TCmdData = class
    Id: Integer;
    TranId: Integer;
  end;

  PMinMaxId = ^TMinMaxId;
  TMinMaxId = record
    MinId: Integer;
    MaxId: Integer;
    RecCount: Integer;
  end;

  TMinMaxTransId = record
    Min: Integer;
    Max: Integer;
  end;

  TSlaveValues = record
    LastId: Integer;
    LastId_DDL: Integer;
    ClientId: Int64;
  end;

  TMasterValues = record
    LastId: Integer;
    LastId_DDL: Integer;
  end;

  TSequenceData = record
    Name: string;
    LastValue: Int64;
    Increment: Integer;
  end;

  TSequenceDataArray = array of TSequenceData;

  PCompareMasterSlave = ^TCompareMasterSlave;
  TCompareMasterSlave = record
    ResultSQL: string;
  end;

  TServerRank = (srMaster, srSlave);

  TApplyScriptResult = (asNoAction, asSuccess, asError);

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

  TReplicaFinished = (rfUnknown, rfComplete, rfStopped, rfErrStopped, rfNoConnect, rfLostConnect);

implementation

end.
