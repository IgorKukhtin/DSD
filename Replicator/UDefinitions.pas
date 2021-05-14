unit UDefinitions;

interface

type
  TLogMessageType = (lmtPlain, lmtError);
  TNotifyMessage = procedure(const AMsg: string; const AFileName: string = ''; const aUID: Cardinal = 0; AMsgType: TLogMessageType = lmtPlain) of object;
  TOnChangeStartId = procedure (const ANewStartId: Int64; const ANewDT: TDateTime ) of object;
  TOnNewSession = procedure(const AStart: TDateTime; const AMinId, AMaxId: Int64; const AMinDT, AMaxDT: TDateTime; const ARecCount, ASessionNumber: Integer) of object;
  TOnCompareRecCountMS = procedure(const AIntermediateResultSQL: string) of object;
  TConditionFunc = reference to function(): Boolean;

  TCmdData = class
    Id: Int64;
    TranId: Int64;
  end;

  PMinMaxId = ^TMinMaxId;
  TMinMaxId = record
    MinDT: TDateTime;
    MaxDT: TDateTime;
    MinId: Int64;
    MaxId: Int64;
    RecCount: Int64;
  end;

  TMinMaxTransId = record
    Min: Int64;
    Max: Int64;
  end;

  TSlaveValues = record
    LastId: Int64;
    LastId_DDL: Int64;
    ClientId: Int64;
  end;

  TMasterValues = record
    LastId: Int64;
    LastId_DDL: Int64;
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
    Id: Int64;
    DT : TDateTime;
    TransId: Int64;
    SQL: string;
  end;

  TMaxIdTransId = record
    MaxId: Int64;
    TransId: Int64;
  end;

  TDataRecArray = array of TDataRec;

  TMaxIdTransIdArray = array of TMaxIdTransId;

  TReplicaFinished = (rfUnknown, rfComplete, rfStopped, rfErrStopped, rfNoConnect, rfLostConnect);

implementation

end.
