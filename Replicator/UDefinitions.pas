unit UDefinitions;

interface

type
  TNotifyMessage = procedure(const AMsg: string) of object;
  TOnChangeStartId = procedure (const ANewStartId: Integer) of object;

  TServerRank = (srMaster, srSlave);

  TThreadKind = (tknDriven, tknNondriven);

implementation

end.
