{*****************************************************************}
{                                                                 }
{ ModLink                                                         }
{ Copyright (C) 2002 - 2013 Ing. Ivo Bauer                        }
{ All Rights Reserved.                                            }
{                                                                 }
{ Web site: http://www.ozm.cz/ivobauer/modlink/                   }
{ E-mail:   bauer@ozm.cz                                          }
{                                                                 }
{ For a detailed information regarding the distribution and use   }
{ of this software product, please refer to the License Agreement }
{ embedded in the accompanying online documentation (ModLink.chm) }
{                                                                 }
{*****************************************************************}

unit ModLink;

{$I ModLink.inc}

interface

//--------------------------------------------------------------------------------------------------

uses
  { Windows } Windows, Messages,
  { Delphi  } SysUtils, Classes;

//--------------------------------------------------------------------------------------------------

const
  // Signature of current release.

  ModLinkVersion = '2.42 (December 27, 2013)';

  // Modbus PDU = [Command | N * Data]

  MinQueryPDUSize = 1;   // Just stand-alone [Command] field.
  MinReplyPDUSize = 2;   // Exception reply PDU size [Command | Exception].
  MaxFramePDUSize = 253; // Size constraint inherited by the first Modbus implementation.

  // Modbus/RS485 RTU ADU = [ServerAddress | PDU | CRC16]

  MinQueryADUSizeRTU = SizeOf(Byte) + MinQueryPDUSize + SizeOf(Word);
  MinReplyADUSizeRTU = SizeOf(Byte) + MinReplyPDUSize + SizeOf(Word);
  MaxFrameADUSizeRTU = SizeOf(Byte) + MaxFramePDUSize + SizeOf(Word);

  // Modbus/RS485 ASCII ADU = [ServerAddress | PDU | LRC8]

  MinQueryADUSizeASCII = SizeOf(Byte) + MinQueryPDUSize + SizeOf(Byte);
  MinReplyADUSizeASCII = SizeOf(Byte) + MinReplyPDUSize + SizeOf(Byte);
  MaxFrameADUSizeASCII = SizeOf(Byte) + MaxFramePDUSize + SizeOf(Byte);

  // Supported Modbus commands

  Cmd_ReadCoils                  = $01;
  Cmd_ReadDiscreteInputs         = $02;
  Cmd_ReadHoldingRegisters       = $03;
  Cmd_ReadInputRegisters         = $04;
  Cmd_WriteSingleCoil            = $05;
  Cmd_WriteSingleRegister        = $06;
  Cmd_ReadExceptionStatus        = $07;
  Cmd_Diagnostics                = $08;
  Cmd_WriteMultipleCoils         = $0F;
  Cmd_WriteMultipleRegisters     = $10;
  Cmd_ReportServerID             = $11;
  Cmd_ReadFileRecord             = $14;
  Cmd_WriteFileRecord            = $15;
  Cmd_MaskWriteRegister          = $16;
  Cmd_ReadWriteMultipleRegisters = $17;

  // Supported Cmd_Diagnostics actions (sub-commands)

  Subcmd_Diagnostics_ReturnQueryData                      = $0000;
  Subcmd_Diagnostics_RestartCommsOption                   = $0001;
  Subcmd_Diagnostics_RestartCommsOptionAndClearEventLog   = $0001;
  Subcmd_Diagnostics_ReturnDiagnosticRegister             = $0002;
  Subcmd_Diagnostics_ForceListenOnlyMode                  = $0004;
  Subcmd_Diagnostics_ClearCountersAndDiagnosticRegister   = $000A;
  Subcmd_Diagnostics_ReturnBusMessageCount                = $000B;
  Subcmd_Diagnostics_ReturnBusCommErrorCount              = $000C;
  Subcmd_Diagnostics_ReturnBusExceptionErrorCount         = $000D;
  Subcmd_Diagnostics_ReturnServerMessageCount             = $000E;
  Subcmd_Diagnostics_ReturnServerNoReplyCount             = $000F;
  Subcmd_Diagnostics_ReturnServerNegativeAcknowledgeCount = $0010;
  Subcmd_Diagnostics_ReturnServerBusyCount                = $0011;
  Subcmd_Diagnostics_ReturnBusCharacterOverrunCount       = $0012;
  Subcmd_Diagnostics_ClearOverrunCounterAndFlag           = $0014;

//--------------------------------------------------------------------------------------------------

type
{$IFNDEF COMPILER_12_UP}
  // Declaration of NativeInt was seriously flawed before Delphi 2009/C++ Builder 2009
  NativeInt = Integer;
{$ENDIF}

  EModLinkError = class(Exception) end;

  // Forward declarations

  TModbusClient = class;
  TModbusServer = class;
  TModbusConnection = class;

//--------------------------------------------------------------------------------------------------
// TModbusBuffer class
//--------------------------------------------------------------------------------------------------

  TSeekMode = (
    smBufStart,
    smBufEnd,
    smPriorByte,
    smNextByte,
    smPriorWord,
    smNextWord
  );

  TModbusBuffer = class(TObject)
  private
    FCapacity: Integer;
    FCurPtr, FPeakPtr, FStartPtr: PAnsiChar;
    procedure CheckAvailableSpace(SizeOfData: Integer);
    function GetSize: Integer;
    function GetPosition: Integer;
    procedure SetPosition(Value: Integer);
    procedure SetSize(Value: Integer);
  public
    constructor Create(ACapacity: Integer);
    destructor Destroy; override;
    function CRC16: Word;
    procedure GetBlock(var Buffer; BlockSize: Integer);
    function GetByte: Byte;
    function GetWordHiLo: Word;
    function GetWordLoHi: Word;
    function LRC8: Byte;
    procedure PutBlock(const Buffer; BlockSize: Integer);
    procedure PutByte(Data: Byte);
    procedure PutWordHiLo(Data: Word);
    procedure PutWordLoHi(Data: Word);
    procedure Seek(Mode: TSeekMode);
    property Capacity: Integer read FCapacity;
    property Position: Integer read GetPosition write SetPosition;
    property Size: Integer read GetSize write SetSize;
    property StartPtr: PAnsiChar read FStartPtr;
  end;

//--------------------------------------------------------------------------------------------------
// TModbusTransaction class
//--------------------------------------------------------------------------------------------------

  TServerReply = (
    srNone,
    srInvalidFrame,    { v2.8 }
    srUnexpectedReply, { v2.9 }
    srUnmatchedReply,
    srExceptionReply,
    srNormalReply
  );

  TServerException = (
    seUnknown,
    seIllegalCommand,
    seIllegalDataAddress,
    seIllegalDataValue,
    seServerFailure,
    seAcknowledge,
    seServerBusy,
    seNegativeAcknowledge,
    seMemoryParityError
  );

  TTransactionInfo = record
    ID: Cardinal;
    Address: Byte;
    UserData: Pointer;
    Retries: Cardinal;
    Reply: TServerReply;
    Exception: TServerException;
    ExceptionCode: Byte;
  end;

  TModbusTransaction = class(TObject)
  private
    FQueryBuffer: TModbusBuffer;
    FReplyBuffer: TModbusBuffer;
  public
    Custom: Boolean;
    Info: TTransactionInfo;
    Originator: TModbusClient;
    Promiscuous: Boolean;
    constructor Create(BufCapacity: Cardinal);
    destructor Destroy; override;
    property QueryBuffer: TModbusBuffer read FQueryBuffer;
    property ReplyBuffer: TModbusBuffer read FReplyBuffer;
  end;

//--------------------------------------------------------------------------------------------------
// TModbusClient class
//--------------------------------------------------------------------------------------------------

  // 1-bit access (discrete inputs, coils)

  TBitValues = array of Boolean;

  TMultipleBitsAccessEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    StartBit: Word;
    BitCount: Word;
    const BitValues: TBitValues
  ) of object;

  TSingleCoilWriteEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    BitAddr: Word;
    BitValue: Boolean
  ) of object;

  // 16-bit access (input/holding registers)

  TRegValues = array of Word;

  TMultipleRegistersAccessEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    StartReg: Word;
    RegCount: Word;
    const RegValues: TRegValues
  ) of object;

  TSingleRegisterWriteEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    RegAddr: Word;
    RegValue: Word
  ) of object;

  TSingleRegisterMaskWriteEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    RegAddr: Word;
    AndMask: Word;
    OrMask: Word
  ) of object;

  TMultipleRegistersReadWriteEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    StartRegToRead: Word;
    RegCountToRead: Word;
    const RegValuesToRead: TRegValues;
    StartRegToWrite: Word;
    RegCountToWrite: Word;
    const RegValuesToWrite: TRegValues
  ) of object;

  // 16-bit access (file records)

  TModbusFileRecord = class(TObject)
  private
    FFileID: Word;
    FRegValues: TRegValues;
    FStartReg: Word;
    function GetRegCount: Integer;
    function GetRegValue(Index: Integer): Word;
    procedure SetRegCount(Value: Integer);
    procedure SetRegValue(Index: Integer; Value: Word);
    procedure SetStartReg(Value: Word);
  public
    constructor Create(AFileID: Word; AStartReg: Word; ARegCount: Integer);
    destructor Destroy; override;
    procedure AdjustRange(AStartReg: Word; ARegCount: Integer);
    property FileID: Word read FFileID write FFileID;
    property RegCount: Integer read GetRegCount write SetRegCount;
    property RegValues[Index: Integer]: Word read GetRegValue write SetRegValue; default;
    property StartReg: Word read FStartReg write SetStartReg;
  end;

  TModbusFileRecordList = class(TObject)
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TModbusFileRecord;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AFileID: Word; AStartReg: Word; ARegCount: Integer): TModbusFileRecord; overload;
    function Add(AFileID: Word; AStartReg: Word; const ARegValues: array of Word): TModbusFileRecord; overload;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Remove(FileRecord: TModbusFileRecord): Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TModbusFileRecord read GetItem; default;
  end;

  TFileRecordAccessEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    FileRecList: TModbusFileRecordList
  ) of object;

  // Modbus diagnostics

  TExceptionStatusValues = array of Boolean;

  TExceptionStatusReadEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    const StatusValues: TExceptionStatusValues
  ) of object;

  TServerIdentificationData = array of Byte;

  TServerIdentificationReportEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    Count: Integer;
    const Data: TServerIdentificationData
  ) of object;

  TDiagnosticAction = (
    daReturnQueryData,
    daRestartCommsOption,
    daRestartCommsOptionAndClearEventLog,
    daReturnDiagnosticRegister,
    daForceListenOnlyMode,
    daClearCountersAndDiagnosticRegister,
    daReturnBusMessageCount,
    daReturnBusCommErrorCount,
    daReturnBusExceptionErrorCount,
    daReturnServerMessageCount,
    daReturnServerNoReplyCount,
    daReturnServerNegativeAcknowledgeCount,
    daReturnServerBusyCount,
    daReturnBusCharacterOverrunCount,
    daClearOverrunCounterAndFlag
  );

  TDiagnosticsEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    Action: TDiagnosticAction;
    Result: Word
  ) of object;

  // Custom Modbus transactions (i.e. private commands)

  TCustomTransactionCompleteEvent = procedure (
    Sender: TModbusClient;
    Transaction: TModbusTransaction;
    Command: Byte
  ) of object;

  // Used to retrieve the server exception description.

  TTranslateExceptionCodeEvent = procedure (
    Sender: TModbusClient;
    ExceptionCode: Byte;
    var Description: string
  ) of object;

  // Occurs whenever a queued transaction gets entirely processed.

  TTransactionProcessedEvent = procedure (
    Sender: TModbusClient;
    const Info: TTransactionInfo;
    Command: Byte;
    Custom: Boolean
  ) of object;

  // Common event prototype for parameterless notifications
  TModbusClientNotifyEvent = procedure (Sender: TModbusClient) of object;

  TModbusClient = class(TComponent)
  private
    FConnection: TModbusConnection;
    FConsecutiveTimeoutCount: Cardinal;
    FMaxConsecutiveTimeouts: Integer;
    FOnCoilsRead: TMultipleBitsAccessEvent;
    FOnConsecutiveTimeoutLimitExceed: TModbusClientNotifyEvent;
    FOnCustomTransactionComplete: TCustomTransactionCompleteEvent;
    FOnDiagnostics: TDiagnosticsEvent;
    FOnDiscreteInputsRead: TMultipleBitsAccessEvent;
    FOnExceptionStatusRead: TExceptionStatusReadEvent;
    FOnFileRecordRead: TFileRecordAccessEvent;
    FOnFileRecordWrite: TFileRecordAccessEvent;
    FOnHoldingRegistersRead: TMultipleRegistersAccessEvent;
    FOnInputRegistersRead: TMultipleRegistersAccessEvent;
    FOnMultipleCoilsWrite: TMultipleBitsAccessEvent;
    FOnMultipleRegistersReadWrite: TMultipleRegistersReadWriteEvent;
    FOnMultipleRegistersWrite: TMultipleRegistersAccessEvent;
    FOnServerIdentificationReport: TServerIdentificationReportEvent;
    FOnSingleCoilWrite: TSingleCoilWriteEvent;
    FOnSingleRegisterMaskWrite: TSingleRegisterMaskWriteEvent;
    FOnSingleRegisterWrite: TSingleRegisterWriteEvent;
    FOnTransactionProcessed: TTransactionProcessedEvent;
    FOnTranslateExceptionCode: TTranslateExceptionCodeEvent;
    FServerAddress: Byte;
    procedure DoneCustomTransaction(Transaction: TModbusTransaction; Command: Byte);
    procedure DoneDiagnostics(Transaction: TModbusTransaction);
    procedure DoneReadDiscreteBits(Transaction: TModbusTransaction; Coils: Boolean);
    procedure DoneReadExceptionStatus(Transaction: TModbusTransaction);
    procedure DoneReadFileRecord(Transaction: TModbusTransaction);
    procedure DoneReadModbusRegisters(Transaction: TModbusTransaction; HoldingRegisters: Boolean);
    procedure DoneReadWriteMultipleRegisters(Transaction: TModbusTransaction);
    procedure DoneReportServerID(Transaction: TModbusTransaction);
    procedure DoneMaskWriteSingleRegister(Transaction: TModbusTransaction);
    procedure DonePublicTransaction(Transaction: TModbusTransaction; Command: Byte);
    procedure DoneWriteFileRecord(Transaction: TModbusTransaction);
    procedure DoneWriteMultipleCoils(Transaction: TModbusTransaction);
    procedure DoneWriteMultipleRegisters(Transaction: TModbusTransaction);
    procedure DoneWriteSingleCoil(Transaction: TModbusTransaction);
    procedure DoneWriteSingleRegister(Transaction: TModbusTransaction);
    procedure KeepTrackOfConsecutiveTimeouts(const Info: TTransactionInfo);
    procedure SetConnection(Value: TModbusConnection);
    procedure SetMaxConsecutiveTimeouts(Value: Integer);
    procedure SetServerAddress(Value: Byte);
  protected
    procedure DoCoilsRead(const Info: TTransactionInfo; StartBit: Word; BitCount: Word;
      const BitValues: TBitValues); dynamic;
    procedure DoConsecutiveTimeoutLimitExceed; dynamic;
    procedure DoCustomTransactionComplete(Transaction: TModbusTransaction; Command: Byte); dynamic;
    procedure DoDiagnostics(const Info: TTransactionInfo; Action: TDiagnosticAction; Result: Word); dynamic;
    procedure DoDiscreteInputsRead(const Info: TTransactionInfo; StartBit: Word; BitCount: Word;
      const BitValues: TBitValues); dynamic;
    procedure DoExceptionStatusRead(const Info: TTransactionInfo; const StatusValues: TExceptionStatusValues); dynamic;
    procedure DoFileRecordRead(const Info: TTransactionInfo; FileRecList: TModbusFileRecordList); dynamic;
    procedure DoFileRecordWrite(const Info: TTransactionInfo; FileRecList: TModbusFileRecordList); dynamic;
    procedure DoHoldingRegistersRead(const Info: TTransactionInfo; StartReg: Word; RegCount: Word;
      const RegValues: TRegValues); dynamic;
    procedure DoInputRegistersRead(const Info: TTransactionInfo; StartReg: Word; RegCount: Word;
      const RegValues: TRegValues); dynamic;
    procedure DoMultipleCoilsWrite(const Info: TTransactionInfo; StartBit: Word; BitCount: Word;
      const BitValues: TBitValues); dynamic;
    procedure DoMultipleRegistersReadWrite(const Info: TTransactionInfo;
      StartRegToRead: Word; RegCountToRead: Word; const RegValuesToRead: TRegValues;
      StartRegToWrite: Word; RegCountToWrite: Word; const RegValuesToWrite: TRegValues); dynamic;
    procedure DoMultipleRegistersWrite(const Info: TTransactionInfo; StartReg: Word; RegCount: Word;
      const RegValues: TRegValues); dynamic;
    procedure DoServerIdentificationReport(const Info: TTransactionInfo; Count: Integer; const Data: TServerIdentificationData); dynamic;
    procedure DoSingleCoilWrite(const Info: TTransactionInfo; BitAddr: Word; BitValue: Boolean); dynamic;
    procedure DoSingleRegisterMaskWrite(const Info: TTransactionInfo; RegAddr: Word; AndMask: Word;
      OrMask: Word); dynamic;
    procedure DoSingleRegisterWrite(const Info: TTransactionInfo; RegAddr: Word; RegValue: Word); dynamic;
    procedure DoTransactionProcessed(const Info: TTransactionInfo; Command: Byte; Custom: Boolean); dynamic;
    procedure DoTranslateExceptionCode(ExceptionCode: Byte; var Description: string); dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CheckConnected;
    procedure CheckDisconnected;
    procedure ClearConsecutiveTimeoutCounter;
    function Diagnostics(Action: TDiagnosticAction; UserData: Pointer = nil): Cardinal;
    procedure DoneTransaction(Transaction: TModbusTransaction);
    function ExceptionCodeToStr(ExceptionCode: Byte): string;
    function InitCustomTransaction(Command: Byte; const RequestData: array of Byte; PromiscuousMode: Boolean; UserData: Pointer = nil): Cardinal;
    function MaskWriteSingleRegister(RegAddr: Word; AndMask: Word; OrMask: Word; UserData: Pointer = nil): Cardinal;
    function ReadCoils(StartBit: Word; BitCount: Word; UserData: Pointer = nil): Cardinal;
    function ReadDiscreteInputs(StartBit: Word; BitCount: Word; UserData: Pointer = nil): Cardinal;
    function ReadExceptionStatus(UserData: Pointer = nil): Cardinal;
    function ReadFileRecord(FileRecList: TModbusFileRecordList; UserData: Pointer = nil): Cardinal;
    function ReadHoldingRegisters(StartReg: Word; RegCount: Word; UserData: Pointer = nil): Cardinal;
    function ReadInputRegisters(StartReg: Word; RegCount: Word; UserData: Pointer = nil): Cardinal;
    function ReadWriteMultipleRegisters(StartRegToRead: Word; RegCountToRead: Word;
      StartRegToWrite: Word; const RegValuesToWrite: array of Word; UserData: Pointer = nil): Cardinal;
    function ReportServerID(UserData: Pointer = nil): Cardinal;
    function WriteFileRecord(FileRecList: TModbusFileRecordList; UserData: Pointer = nil): Cardinal;
    function WriteMultipleCoils(StartBit: Word; const BitValues: array of Boolean;
      UserData: Pointer = nil): Cardinal;
    function WriteMultipleRegisters(StartReg: Word; const RegValues: array of Word;
      UserData: Pointer = nil): Cardinal;
    function WriteSingleCoil(BitAddr: Word; BitValue: Boolean; UserData: Pointer = nil): Cardinal;
    function WriteSingleRegister(RegAddr: Word; RegValue: Word; UserData: Pointer = nil): Cardinal;
    property ConsecutiveTimeoutCount: Cardinal read FConsecutiveTimeoutCount;
  published
    property Connection: TModbusConnection read FConnection write SetConnection;
    property MaxConsecutiveTimeouts: Integer
      read FMaxConsecutiveTimeouts write SetMaxConsecutiveTimeouts default -1;
    property OnCoilsRead: TMultipleBitsAccessEvent read FOnCoilsRead write FOnCoilsRead;
    property OnConsecutiveTimeoutLimitExceed: TModbusClientNotifyEvent
      read FOnConsecutiveTimeoutLimitExceed write FOnConsecutiveTimeoutLimitExceed;
    property OnCustomTransactionComplete: TCustomTransactionCompleteEvent
      read FOnCustomTransactionComplete write FOnCustomTransactionComplete;
    property OnDiagnostics: TDiagnosticsEvent read FOnDiagnostics write FOnDiagnostics;
    property OnDiscreteInputsRead: TMultipleBitsAccessEvent
      read FOnDiscreteInputsRead write FOnDiscreteInputsRead;
    property OnExceptionStatusRead: TExceptionStatusReadEvent
      read FOnExceptionStatusRead write FOnExceptionStatusRead;
    property OnFileRecordRead: TFileRecordAccessEvent
      read FOnFileRecordRead write FOnFileRecordRead;
    property OnFileRecordWrite: TFileRecordAccessEvent
      read FOnFileRecordWrite write FOnFileRecordWrite;
    property OnHoldingRegistersRead: TMultipleRegistersAccessEvent
      read FOnHoldingRegistersRead write FOnHoldingRegistersRead;
    property OnInputRegistersRead: TMultipleRegistersAccessEvent
      read FOnInputRegistersRead write FOnInputRegistersRead;
    property OnMultipleCoilsWrite: TMultipleBitsAccessEvent
      read FOnMultipleCoilsWrite write FOnMultipleCoilsWrite;
    property OnMultipleRegistersReadWrite: TMultipleRegistersReadWriteEvent
      read FOnMultipleRegistersReadWrite write FOnMultipleRegistersReadWrite;
    property OnMultipleRegistersWrite: TMultipleRegistersAccessEvent
      read FOnMultipleRegistersWrite write FOnMultipleRegistersWrite;
    property OnServerIdentificationReport: TServerIdentificationReportEvent
      read FOnServerIdentificationReport write FOnServerIdentificationReport;
    property OnSingleCoilWrite: TSingleCoilWriteEvent
      read FOnSingleCoilWrite write FOnSingleCoilWrite;
    property OnSingleRegisterMaskWrite: TSingleRegisterMaskWriteEvent
      read FOnSingleRegisterMaskWrite write FOnSingleRegisterMaskWrite;
    property OnSingleRegisterWrite: TSingleRegisterWriteEvent
      read FOnSingleRegisterWrite write FOnSingleRegisterWrite;
    property OnTransactionProcessed: TTransactionProcessedEvent
      read FOnTransactionProcessed write FOnTransactionProcessed;
    property OnTranslateExceptionCode: TTranslateExceptionCodeEvent
      read FOnTranslateExceptionCode write FOnTranslateExceptionCode;
    property ServerAddress: Byte read FServerAddress write SetServerAddress default 1;
  end;

//--------------------------------------------------------------------------------------------------
// TModbusServer class
//--------------------------------------------------------------------------------------------------

  TAcceptCommandEvent = procedure (
    Sender: TModbusServer;
    Command: Byte;
    var Accept: Boolean
  ) of object;

  TItemWriteStatus = (
    iwsIllegalAddress,
    iwsIllegalValue,
    iwsAllowWrite
  );

  TCommandHandlerExceptionEvent = procedure (
    Sender: TModbusServer;
    Command: Byte;
    Exception: TServerException;
    ExceptionCode: Byte
  ) of object;

  // 1-bit access (discrete inputs, coils)

  TCanReadDiscreteBitEvent = procedure (
    Sender: TModbusServer;
    BitAddr: Word;
    var Allow: Boolean
  ) of object;

  TCanWriteCoilEvent = procedure (
    Sender: TModbusServer;
    BitAddr: Word;
    BitValue: Boolean;
    var Status: TItemWriteStatus
  ) of object;

  TGetDiscreteBitValueEvent = procedure (
    Sender: TModbusServer;
    BitAddr: Word;
    var BitValue: Boolean
  ) of object;

  TSetCoilValueEvent = procedure (
    Sender: TModbusServer;
    BitAddr: Word;
    BitValue: Boolean
  ) of object;

  // 16-bit access (input/holding registers)

  TCanReadRegisterEvent = procedure (
    Sender: TModbusServer;
    RegAddr: Word;
    var Allow: Boolean
  ) of object;

  TCanWriteRegisterEvent = procedure (
    Sender: TModbusServer;
    RegAddr: Word;
    RegValue: Word;
    var Status: TItemWriteStatus
  ) of object;

  TGetRegisterValueEvent = procedure (
    Sender: TModbusServer;
    RegAddr: Word;
    var RegValue: Word
  ) of object;

  TSetRegisterValueEvent = procedure (
    Sender: TModbusServer;
    RegAddr: Word;
    RegValue: Word
  ) of object;

  TModbusServer = class(TComponent)
  private
    FActiveTransaction: TModbusTransaction;
    FAddress: Byte;
    FConnection: TModbusConnection;
    FOnAcceptCommand: TAcceptCommandEvent;
    FOnCanReadCoil: TCanReadDiscreteBitEvent;
    FOnCanReadDiscreteInput: TCanReadDiscreteBitEvent;
    FOnCanReadHoldingRegister: TCanReadRegisterEvent;
    FOnCanReadInputRegister: TCanReadRegisterEvent;
    FOnCanWriteCoil: TCanWriteCoilEvent;
    FOnCanWriteHoldingRegister: TCanWriteRegisterEvent;
    FOnCommandHandlerException: TCommandHandlerExceptionEvent;
    FOnGetCoilValue: TGetDiscreteBitValueEvent;
    FOnGetDiscreteInputValue: TGetDiscreteBitValueEvent;
    FOnGetHoldingRegisterValue: TGetRegisterValueEvent;
    FOnGetInputRegisterValue: TGetRegisterValueEvent;
    FOnSetCoilValue: TSetCoilValueEvent;
    FOnSetHoldingRegisterValue: TSetRegisterValueEvent;
    procedure BuildExceptionReply(Buffer: TModbusBuffer; Command: Byte; Exception: TServerException);
    procedure ProcessReadDiscreteBits(Transaction: TModbusTransaction; Coils: Boolean);
    procedure ProcessReadModbusRegisters(Transaction: TModbusTransaction; HoldingRegisters: Boolean);
    procedure ProcessWriteMultipleCoils(Transaction: TModbusTransaction);
    procedure ProcessWriteMultipleRegisters(Transaction: TModbusTransaction);
    procedure ProcessWriteSingleCoil(Transaction: TModbusTransaction);
    procedure ProcessWriteSingleRegister(Transaction: TModbusTransaction);
    procedure SetAddress(Value: Byte);
    procedure SetConnection(Value: TModbusConnection);
  protected
    function DoAcceptCommand(Command: Byte): Boolean; dynamic;
    function DoCanReadCoil(BitAddr: Word): Boolean; dynamic;
    function DoCanReadDiscreteInput(BitAddr: Word): Boolean; dynamic;
    function DoCanReadHoldingRegister(RegAddr: Word): Boolean; dynamic;
    function DoCanReadInputRegister(RegAddr: Word): Boolean; dynamic;
    function DoCanWriteCoil(BitAddr: Word; BitValue: Boolean): TItemWriteStatus; dynamic;
    function DoCanWriteHoldingRegister(RegAddr: Word; RegValue: Word): TItemWriteStatus; dynamic;
    procedure DoCommandHandlerException(Command: Byte; Exception: TServerException; ExceptionCode: Byte); dynamic;
    function DoGetCoilValue(BitAddr: Word): Boolean; dynamic;
    function DoGetDiscreteInputValue(BitAddr: Word): Boolean; dynamic;
    function DoGetHoldingRegisterValue(RegAddr: Word): Word; dynamic;
    function DoGetInputRegisterValue(RegAddr: Word): Word; dynamic;
    procedure DoSetCoilValue(BitAddr: Word; BitValue: Boolean); dynamic;
    procedure DoSetHoldingRegisterValue(RegAddr: Word; RegValue: Word); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CheckActiveTransaction;
    procedure CheckConnected;
    procedure EmitExceptionReply(Exception: TServerException);
    procedure ProcessTransaction(Transaction: TModbusTransaction);
  published
    property Address: Byte
      read FAddress write SetAddress default 1;
    property Connection: TModbusConnection
      read FConnection write SetConnection;
    property OnAcceptCommand: TAcceptCommandEvent
      read FOnAcceptCommand write FOnAcceptCommand;
    property OnCanReadCoil: TCanReadDiscreteBitEvent
      read FOnCanReadCoil write FOnCanReadCoil;
    property OnCanReadDiscreteInput: TCanReadDiscreteBitEvent
      read FOnCanReadDiscreteInput write FOnCanReadDiscreteInput;
    property OnCanReadHoldingRegister: TCanReadRegisterEvent
      read FOnCanReadHoldingRegister write FOnCanReadHoldingRegister;
    property OnCanReadInputRegister: TCanReadRegisterEvent
      read FOnCanReadInputRegister write FOnCanReadInputRegister;
    property OnCanWriteCoil: TCanWriteCoilEvent
      read FOnCanWriteCoil write FOnCanWriteCoil;
    property OnCanWriteHoldingRegister: TCanWriteRegisterEvent
      read FOnCanWriteHoldingRegister write FOnCanWriteHoldingRegister;
    property OnCommandHandlerException: TCommandHandlerExceptionEvent
      read FOnCommandHandlerException write FOnCommandHandlerException;
    property OnGetCoilValue: TGetDiscreteBitValueEvent
      read FOnGetCoilValue write FOnGetCoilValue;
    property OnGetDiscreteInputValue: TGetDiscreteBitValueEvent
      read FOnGetDiscreteInputValue write FOnGetDiscreteInputValue;
    property OnGetHoldingRegisterValue: TGetRegisterValueEvent
      read FOnGetHoldingRegisterValue write FOnGetHoldingRegisterValue;
    property OnGetInputRegisterValue: TGetRegisterValueEvent
      read FOnGetInputRegisterValue write FOnGetInputRegisterValue;
    property OnSetCoilValue: TSetCoilValueEvent
      read FOnSetCoilValue write FOnSetCoilValue;
    property OnSetHoldingRegisterValue: TSetRegisterValueEvent
      read FOnSetHoldingRegisterValue write FOnSetHoldingRegisterValue;
  end;

//--------------------------------------------------------------------------------------------------
// TModbusConnection class
//--------------------------------------------------------------------------------------------------

  TBaudRate = (br110, br300, br600, br1200, br2400, br4800, br9600, br14400, br19200, br38400,
    br56000, br57600, br115200, br128000, br256000, brCustom);

  TConnectionMode = (
    cmClient,
    cmServer,
    cmMonitor
  );

  TDataBits = (
    db7,
    db8
  );

  TFlowControl = (
    fcNone,
    fcRtsToggle,
    fcRtsCts,
    fcDtrDsr
  );

  TFlowControls = set of TFlowControl;

  TMaxRetries = 1..High(Cardinal);

  TParityScheme = (
    psNone,
    psOdd,
    psEven
  );

  TSerialPort = type string;

  TStopBits = (
    sb1,
    sb2
  );

  TTransmissionMode = (
    tmRTU,
    tmASCII
  );

  PFrameData = ^TFrameData;
  TFrameData = array of Byte;

  TFrameDataEvent = procedure (
    Sender: TModbusConnection;
    const Data: TFrameData
  ) of object;

  TGetHookedPortHandleEvent = procedure (
    Sender: TModbusConnection;
    var HookHandle: THandle
  ) of object;

  TPreprocessIncomingFrameEvent = procedure (
    Sender: TModbusConnection;
    var Buffer;
    Capacity: Integer;
    var DataSize: Integer) of object;

  TInspectCapturedFrameEvent = procedure (
    Sender: TModbusConnection;
    ServerAddress: Byte;
    CommandCode: Byte;
    const CommandData: TFrameData) of object;

  TModbusConnection = class(TComponent)
  private
    FActive: Boolean;
    FBaudRate: TBaudRate;
    FBreakEvent: THandle;
    FClientList: TList;
    FConnectionMode: TConnectionMode;
    FCustomBaudRate: Cardinal;
    FDataBits: TDataBits;
    FDeviceHandle: THandle;
    FDTREnabled: Boolean;
    FEchoQueryBeforeReply: Boolean;
    FFlowControl: TFlowControl;
    FHookExistingPort: Boolean;
    FInputBufferSize: Integer;
    FInternalWindow: HWND;
    FLock: TMultiReadExclusiveWriteSynchronizer;
    FMaxRetries: TMaxRetries;
    FNextUniqueID: Cardinal;
    FOnAfterClose: TNotifyEvent;
    FOnAfterFrameSendAsync: TNotifyEvent;
    FOnAfterOpen: TNotifyEvent;
    FOnBeforeClose: TNotifyEvent;
    FOnBeforeFrameSendAsync: TNotifyEvent;
    FOnBeforeOpen: TNotifyEvent;
    FOnFrameReceive: TFrameDataEvent;
    FOnFrameSend: TFrameDataEvent;
    FOnGetHookedPortHandle: TGetHookedPortHandleEvent;
    FOnInspectCapturedFrame: TInspectCapturedFrameEvent;
    FOnInvalidFrameDiscard: TNotifyEvent;
    FOnPreprocessIncomingFrame: TPreprocessIncomingFrameEvent;
    FOutputBufferSize: Integer;
    FOverlappedEvent: THandle;
    FParity: TParityScheme;
    FPort: TSerialPort;
    FRealSilentInterval: Cardinal;
    FReceiveTimeout: Cardinal;
    FRefetchDelay: Cardinal;
    FRTSEnabled: Boolean;
    FRTSHoldDelay: Cardinal;
    FServerList: TList;
    FSilentInterval: Cardinal;
    FStopBits: TStopBits;
    FStreamedActive: Boolean;
    FThread: TThread;
    FThreadPriority: TThreadPriority;
    FTransmissionMode: TTransmissionMode;
    FSendTimeout: Cardinal;
    FTurnaroundDelay: Cardinal;
    FWaitInProgress: Boolean;
    FOverlappedWait: TOverlapped;
    FOverlappedWaitEvent: THandle;
    FOverlappedWaitEventMask: Cardinal;
    procedure CancelIO;
    function GetClient(Index: Integer): TModbusClient;
    function GetClientCount: Integer;
    function GetMaxRetries: TMaxRetries;
    function GetRealSilentInterval: Cardinal;
    function GetReceiveTimeout: Cardinal;
    function GetRefetchDelay: Cardinal;
    function GetRTSHoldDelay: Cardinal;
    function GetSendTimeout: Cardinal;
    function GetServer(Index: Integer): TModbusServer;
    function GetServerCount: Integer;
    function GetTurnaroundDelay: Cardinal;
    procedure InternalWndProc(var Message: TMessage);
    function IsPortStored: Boolean;
    function ReceiveFrameASCII(var Buffer; Capacity: Integer; Timeout: Cardinal; Silence: Cardinal): Integer;
    function ReceiveFrameRTU(var Buffer; Capacity: Integer; Timeout: Cardinal; Silence: Cardinal): Integer;
    procedure SetActive(Value: Boolean);
    procedure SetBaudRate(Value: TBaudRate);
    procedure SetConnectionMode(Value: TConnectionMode);
    procedure SetCustomBaudRate(Value: Cardinal);
    procedure SetDataBits(Value: TDataBits);
    procedure SetDTREnabled(Value: Boolean);
    procedure SetEchoQueryBeforeReply(Value: Boolean);
    procedure SetFlowControl(Value: TFlowControl);
    procedure SetHookExistingPort(Value: Boolean);
    procedure SetInputBufferSize(Value: Integer);
    procedure SetMaxRetries(Value: TMaxRetries);
    procedure SetOutputBufferSize(Value: Integer);
    procedure SetParity(Value: TParityScheme);
    procedure SetPortProperty(Value: TSerialPort);
    procedure SetRefetchDelay(Value: Cardinal);
    procedure SetReceiveTimeout(Value: Cardinal);
    procedure SetRTSEnabled(Value: Boolean);
    procedure SetRTSHoldDelay(Value: Cardinal);
    procedure SetSendTimeout(Value: Cardinal);
    procedure SetSilentInterval(Value: Cardinal);
    procedure SetStopBits(Value: TStopBits);
    procedure SetThreadPriority(Value: TThreadPriority);
    procedure SetTransmissionMode(Value: TTransmissionMode);
    procedure SetTurnaroundDelay(Value: Cardinal);
    procedure UpdateDCB;
    procedure UpdateRealSilentInterval;
  protected
    function AcquireModbusCommand(Buffer: TModbusBuffer): Byte;
    function AcquireServerAddress(Buffer: TModbusBuffer): Byte;
    procedure AcquireServerException(Buffer: TModbusBuffer; var Exception: TServerException;
      var ExceptionCode: Byte);
    procedure CheckClosed;
    procedure CheckFlowControl(AFlowControls: TFlowControls);
    procedure CheckOpened;
    procedure ClearDeviceBuffers(RX, TX: Boolean);
    function CommandsMatch(QueryBuffer, ReplyBuffer: TModbusBuffer): Boolean;
    function DecodeFrame(const Source; Dest: TModbusBuffer; SourceSize: Integer): Boolean;
    function DetermineErrorCheckSize: Integer;
    function DetermineHeaderSize: Integer;
    function DetermineInterimBufferSize: Integer;
    function DetermineMaximumFrameSize: Integer;
    function DetermineMinimumQuerySize: Integer;
    function DetermineMinimumReplySize: Integer;
    procedure DoAfterClose; dynamic;
    procedure DoAfterFrameSendAsync; dynamic;
    procedure DoAfterOpen; dynamic;
    procedure DoBeforeClose; dynamic;
    procedure DoBeforeFrameSendAsync; dynamic;
    procedure DoBeforeOpen; dynamic;
    procedure DoInspectCapturedFrame(ServerAddress: Byte; CommandCode: Byte; const CommandData: TFrameData); dynamic;
    procedure DoFrameReceive(const Data: TFrameData); dynamic;
    procedure DoFrameSend(const Data: TFrameData); dynamic;
    function DoGetHookedPortHandle: THandle; dynamic;
    procedure DoInvalidFrameDiscard; dynamic;
    procedure DoPreprocessIncomingFrame(var Buffer; Capacity: Integer; var DataSize: Integer); dynamic;
    function EncodeFrame(Source: TModbusBuffer; var Dest; DestCapacity: Integer): Integer;
    function ErrorChecksEqual(Buffer: TModbusBuffer): Boolean;
    function ExamineInputBuffer(out UnreadCount: Integer): Boolean;
    function HeadersMatch(QueryBuffer, ReplyBuffer: TModbusBuffer): Boolean;
    procedure InternalClose;
    procedure InternalOpen;
    function InternalReceiveFrame(var Buffer; RequestedSize: Integer): Integer;
    function IsEcho(const QueryBuffer; QuerySize: Integer; const ReplyBuffer; ReplySize: Integer): Boolean;
    function IsExceptionReply(Buffer: TModbusBuffer): Boolean;
    function IsExpectedReply(QueryBuffer, ReplyBuffer: TModbusBuffer; PromiscuousMode: Boolean): Boolean;
    procedure Loaded; override;
    function ReceiveFrame(var Buffer; Capacity: Integer; Timeout: Cardinal): Integer;
    function SendFrame(const Buffer; Size: Integer; Timeout: Cardinal): Boolean;
    function WaitForData(Timeout: Cardinal): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeDTR(AValue: Boolean);
    procedure ChangeRTS(AValue: Boolean);
    procedure Close;
    function CountPendingTransactions(Client: TModbusClient = nil): Integer;
    procedure DiscardPendingTransactions(Client: TModbusClient = nil);
    procedure EmitErrorCheck(Buffer: TModbusBuffer);
    procedure EmitHeader(Client: TModbusClient; Buffer: TModbusBuffer); overload;
    procedure EmitHeader(Server: TModbusServer; Buffer: TModbusBuffer); overload;
    procedure EnqueueTransaction(Transaction: TModbusTransaction; AOriginator: TModbusClient);
    function GetNextUniqueID: Cardinal;
    procedure Open;
    procedure ProcessRemoteTransaction(Transaction: TModbusTransaction);
    procedure RegisterClient(Client: TModbusClient);
    procedure RegisterServer(Server: TModbusServer);
    procedure UnregisterClient(Client: TModbusClient);
    procedure UnregisterServer(Server: TModbusServer);
    function WriteMultipleCoils(StartBit: Word; const BitValues: array of Boolean;
      UserData: Pointer = nil): Cardinal;
    function WriteMultipleRegisters(StartReg: Word; const RegValues: array of Word;
      UserData: Pointer = nil): Cardinal;
    function WriteSingleCoil(BitAddr: Word; BitValue: Boolean; UserData: Pointer = nil): Cardinal;
    function WriteSingleRegister(RegAddr: Word; RegValue: Word; UserData: Pointer = nil): Cardinal;
    property ClientCount: Integer read GetClientCount;
    property Clients[Index: Integer]: TModbusClient read GetClient;
    property RealSilentInterval: Cardinal read GetRealSilentInterval;
    property ServerCount: Integer read GetServerCount;
    property Servers[Index: Integer]: TModbusServer read GetServer;
  published
    property Active: Boolean read FActive write SetActive default False;
    property BaudRate: TBaudRate read FBaudRate write SetBaudRate default br19200;
    property ConnectionMode: TConnectionMode read FConnectionMode write SetConnectionMode default cmClient;
    property CustomBaudRate: Cardinal read FCustomBaudRate write SetCustomBaudRate default 19200;
    property DataBits: TDataBits read FDataBits write SetDataBits default db8;
    property DTREnabled: Boolean read FDTREnabled write SetDTREnabled default True;
    property EchoQueryBeforeReply: Boolean read FEchoQueryBeforeReply write SetEchoQueryBeforeReply default False;
    property FlowControl: TFlowControl read FFlowControl write SetFlowControl default fcNone;
    property HookExistingPort: Boolean read FHookExistingPort write SetHookExistingPort default False;
    property InputBufferSize: Integer read FInputBufferSize write SetInputBufferSize default 1024;
    property MaxRetries: TMaxRetries read GetMaxRetries write SetMaxRetries default 1;
    property OnAfterClose: TNotifyEvent read FOnAfterClose write FOnAfterClose;
    property OnAfterFrameSendAsync: TNotifyEvent read FOnAfterFrameSendAsync write FOnAfterFrameSendAsync;
    property OnAfterOpen: TNotifyEvent read FOnAfterOpen write FOnAfterOpen;
    property OnBeforeClose: TNotifyEvent read FOnBeforeClose write FOnBeforeClose;
    property OnBeforeFrameSendAsync: TNotifyEvent read FOnBeforeFrameSendAsync write FOnBeforeFrameSendAsync;
    property OnBeforeOpen: TNotifyEvent read FOnBeforeOpen write FOnBeforeOpen;
    property OnFrameReceive: TFrameDataEvent read FOnFrameReceive write FOnFrameReceive;
    property OnFrameSend: TFrameDataEvent read FOnFrameSend write FOnFrameSend;
    property OnGetHookedPortHandle: TGetHookedPortHandleEvent read FOnGetHookedPortHandle write FOnGetHookedPortHandle;
    property OnInspectCapturedFrame: TInspectCapturedFrameEvent read FOnInspectCapturedFrame write FOnInspectCapturedFrame;
    property OnInvalidFrameDiscard: TNotifyEvent read FOnInvalidFrameDiscard write FOnInvalidFrameDiscard;
    property OnPreprocessIncomingFrame: TPreprocessIncomingFrameEvent read FOnPreprocessIncomingFrame write FOnPreprocessIncomingFrame;
    property OutputBufferSize: Integer read FOutputBufferSize write SetOutputBufferSize default 1024;
    property Parity: TParityScheme read FParity write SetParity default psEven;
    property Port: TSerialPort read FPort write SetPortProperty stored IsPortStored;
    property ReceiveTimeout: Cardinal read GetReceiveTimeout write SetReceiveTimeout default 1000;
    property RefetchDelay: Cardinal read GetRefetchDelay write SetRefetchDelay default 0;
    property RTSEnabled: Boolean read FRTSEnabled write SetRTSEnabled default True;
    property RTSHoldDelay: Cardinal read GetRTSHoldDelay write SetRTSHoldDelay default 0;
    property SendTimeout: Cardinal read GetSendTimeout write SetSendTimeout default 1000;
    property SilentInterval: Cardinal read FSilentInterval write SetSilentInterval default 4;
    property StopBits: TStopBits read FStopBits write SetStopBits default sb1;
    property ThreadPriority: TThreadPriority read FThreadPriority write SetThreadPriority default tpNormal;
    property TransmissionMode: TTransmissionMode read FTransmissionMode write SetTransmissionMode default tmRTU;
    property TurnaroundDelay: Cardinal read GetTurnaroundDelay write SetTurnaroundDelay default 100;
  end;

// Enumerates all serial ports installed on the PC.

procedure EnumSerialPorts(Dest: TStrings);

// Strips a specific number of bytes off the start/end of the Modbus frame.
procedure TrimModbusFrame(
  var Buffer;
  Capacity: Integer;
  var DataSize: Integer;
  LeadingBytesTrimmed,
  TrailingBytesTrimmed: Integer);

//--------------------------------------------------------------------------------------------------
// A set of utility routines intended for a bidirectional conversion between a real world values,
// and a Modbus register's native storage format compliant values.
//--------------------------------------------------------------------------------------------------

function SmallInt2Mod(Number: SmallInt): Word;
procedure LongInt2Mod(Number: LongInt; var RegValue1, RegValue2: Word;
  BigEndian: Boolean = False);
procedure LongWord2Mod(Number: LongWord; var RegValue1, RegValue2: Word;
  BigEndian: Boolean = False);
function ScaledFloat2Mod(const Number: Single; Decimals: Integer): Word;
procedure Single2Mod(const Number: Single; var RegValue1, RegValue2: Word;
  BigEndian: Boolean = False);
procedure Double2Mod(const Number: Double; var RegValue1, RegValue2, RegValue3, RegValue4: Word;
  BigEndian: Boolean = False);

function Mod2SmallInt(RegValue: Word): SmallInt;
function Mod2LongInt(RegValue1, RegValue2: Word; BigEndian: Boolean = False): LongInt;
function Mod2LongWord(RegValue1, RegValue2: Word; BigEndian: Boolean = False): LongWord;
function Mod2ScaledFloat(RegValue: Word; Decimals: Integer): Single;
function Mod2Single(RegValue1, RegValue2: Word; BigEndian: Boolean = False): Single;
function Mod2Double(RegValue1, RegValue2, RegValue3, RegValue4: Word;
  BigEndian: Boolean = False): Double;

//--------------------------------------------------------------------------------------------------

implementation

(*

  References:
  ===========

  [1] Modicon Modbus Protocol Reference Guide
      (PI_MBUS_300.pdf)

  [2] MODBUS Application Protocol Specification V1.1
      (ModbusApplicationProtocol_v1_1.pdf)

  [3] MODBUS over Serial Line - Specification & Implementation guide V1.0
      (Modbus_over_serial_line_V1.pdf)

  All these documents can be obtained directly from 'Standard Modbus Library' section
  located at Modbus.Org community site (http://www.modbus.org/).

*)

uses
  { Delphi } {$IFDEF MODLINK_SHAREWARE_VERSION} Dialogs, {$ENDIF MODLINK_SHAREWARE_VERSION}
             {$IFNDEF COMPILER_6_UP} Forms, {$ENDIF COMPILER_6_UP} Math, Registry, MMSystem;

//--------------------------------------------------------------------------------------------------
// Utility routines
//--------------------------------------------------------------------------------------------------

procedure ModLinkError(ResStringRec: PResStringRec); overload;
begin
  {$IFDEF COMPILER_5_UP}
  raise EModLinkError.CreateRes(ResStringRec);
  {$ELSE}
  raise EModLinkError.Create(LoadResString(ResStringRec));
  {$ENDIF COMPILER_5_UP}
end;

//--------------------------------------------------------------------------------------------------

procedure ModLinkError(ResStringRec: PResStringRec; const Args: array of const); overload;
begin
  {$IFDEF COMPILER_5_UP}
  raise EModLinkError.CreateResFmt(ResStringRec, Args);
  {$ELSE}
  raise EModLinkError.CreateFmt(LoadResString(ResStringRec), Args);
  {$ENDIF COMPILER_5_UP}
end;

//--------------------------------------------------------------------------------------------------

resourcestring
  RsInternalError = 'Internal error';

//--------------------------------------------------------------------------------------------------

procedure InternalError;
begin
  {$IFDEF COMPILER_5_UP}
  raise EModLinkError.CreateRes(@RsInternalError);
  {$ELSE}
  raise EModLinkError.Create(LoadResString(@RsInternalError));
  {$ENDIF COMPILER_5_UP}
end;

//--------------------------------------------------------------------------------------------------

{$IFNDEF COMPILER_5_UP}

// FreeAndNil doesn't exist in Delphi 4.
procedure FreeAndNil(var Obj);
var
  TempObj: TObject;
begin
  TempObj := TObject(Obj);
  Pointer(Obj) := nil;
  TempObj.Free;
end;

{$ENDIF COMPILER_5_UP}

//--------------------------------------------------------------------------------------------------

procedure CheckEventCreated(AEvent: THandle);
begin
  if AEvent = 0 then
    {$IFDEF COMPILER_6_UP} RaiseLastOSError {$ELSE} RaiseLastWin32Error {$ENDIF COMPILER_6_UP};
end;

//--------------------------------------------------------------------------------------------------

procedure SafeDestroyEvent(AEvent: THandle);
begin
  if AEvent <> 0 then CloseHandle(AEvent);
end;

//--------------------------------------------------------------------------------------------------

function CreateFrameBuffer(Capacity: Integer): PFrameData;
begin
  GetMem(Result, SizeOf(PFrameData));
  try
    ZeroMemory(Result, SizeOf(PFrameData));
    SetLength(Result^, Capacity);
  except
    FreeMem(Result);
    raise;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure DestroyFrameBuffer(var Buffer: PFrameData);
var
  Temp: PFrameData;
begin
  if Buffer <> nil then
  begin
    Temp := Buffer;
    Buffer := nil;
    Finalize(Temp^);
    FreeMem(Temp);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure Delay(Duration: Cardinal);
begin
  if Duration > 0 then
    Sleep(Duration);
end;

//--------------------------------------------------------------------------------------------------
// TModbusBuffer class
//--------------------------------------------------------------------------------------------------

resourcestring
  RsNotEnoughBufferSpace = 'There is not enough space in the buffer to perform the requested action';
  RsInvalidBufferPositionArgs = 'Buffer position is invalid (%d)';
  RsInvalidBufferSizeArgs = 'Buffer size is invalid (%d)';

//--------------------------------------------------------------------------------------------------

constructor TModbusBuffer.Create(ACapacity: Integer);
// Standard constructor.
begin
  inherited Create;

  FCapacity := ACapacity;

  // Allocate the memory.
  GetMem(FStartPtr, FCapacity);

  // Adjust internal pointers.
  FCurPtr := FStartPtr;
  FPeakPtr := FStartPtr;
end;

//--------------------------------------------------------------------------------------------------

destructor TModbusBuffer.Destroy;
// Standard destructor.
begin
  FreeMem(FStartPtr, FCapacity);
  inherited;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusBuffer.CheckAvailableSpace(SizeOfData: Integer);
// Checks if there is at least SizeOfData bytes available between the current position,
// and the top of the buffer. Upon a failure, it raises an exception.
begin
  if Integer(FStartPtr + FCapacity - FCurPtr) < SizeOfData then
    ModLinkError(@RsNotEnoughBufferSpace);
end;

//--------------------------------------------------------------------------------------------------

var
  CRC16LookupTable: array[Byte] of Word;

//--------------------------------------------------------------------------------------------------

function TModbusBuffer.CRC16: Word;
// References [1,3] recommend the following steps to generate Modbus/RTU 16-bit CRC
// error check field:
//
// 1. Load a 16–bit register with FFFF hex (all 1’s). Call this the CRC register.
// 2. Exclusive OR the first 8–bit byte of the message with the low–order byte
//    of the 16–bit CRC register, putting the result in the CRC register.
// 3. Shift the CRC register one bit to the right (toward the LSB), zero–filling
//    the MSB. Extract and examine the LSB.
// 4. (If the LSB was 0): Repeat Step 3 (another shift).
//    (If the LSB was 1): Exclusive OR the CRC register with the polynomial
//                        value A001 hex (1010 0000 0000 0001).
// 5. Repeat Steps 3 and 4 until 8 shifts have been performed. When this is
//    done, a complete 8–bit byte will have been processed.
// 6. Repeat Steps 2 through 5 for the next 8–bit byte of the message. Continue
//    doing this until all bytes have been processed.
// 7. The final contents of the CRC register is the CRC value.
//
// The strict translation of these steps into Object Pascal language yielded
// this code fragment:
//
// var
// I, J: Integer;
// begin
//   Result := $FFFF;
//   // Iterate the buffer from the start to the current position (exclusive).
//   for I := 0 to Position - 1 do
//   begin
//     Result := Result xor PByte(FStartPtr + I)^;
//     for J := 0 to 7 do
//       if (Result and $0001) <> 0 then
//         Result := (Result shr 1) xor $A001
//       else
//         Result := Result shr 1;
//   end;
// end;
//
// However, I decided to use a bit optimized algorithm based on a lookup
// table that gets precalculated at runtime during initialization of this unit:
//
var
  I, Index: Integer;
begin
  Result := $FFFF;

  // Iterate the buffer from the start to the current position (exclusive).
  for I := 0 to Position - 1 do
  begin
    Index := Byte(Result) xor PByte(FStartPtr + I)^;
    Result := CRC16LookupTable[Index] xor (Result shr 8);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusBuffer.GetBlock(var Buffer; BlockSize: Integer);
// Extracts BlockSize bytes from the buffer without updating the current position.
begin
  if BlockSize < 1 then Exit;
  CheckAvailableSpace(BlockSize);
  System.Move(FCurPtr^, Buffer, BlockSize);
end;

//--------------------------------------------------------------------------------------------------

function TModbusBuffer.GetByte: Byte;
// Extracts the Byte from the buffer without updating the current position.
begin
  CheckAvailableSpace(SizeOf(Result));
  Result := PByte(FCurPtr)^;
end;

//--------------------------------------------------------------------------------------------------

function TModbusBuffer.GetPosition: Integer;
// Property getter for Position property.
begin
  Result := FCurPtr - FStartPtr;
end;

//--------------------------------------------------------------------------------------------------

function TModbusBuffer.GetSize: Integer;
// Property getter for Size property.
begin
  Result := FPeakPtr - FStartPtr;
end;

//--------------------------------------------------------------------------------------------------

function TModbusBuffer.GetWordHiLo: Word;
// Extracts the Word from the buffer without updating the current position.
begin
  CheckAvailableSpace(SizeOf(Result));
  // Extract the bytes in a reverse order.
  WordRec(Result).Hi := PByte(FCurPtr)^;
  WordRec(Result).Lo := PByte(FCurPtr + SizeOf(Byte))^;
end;

//--------------------------------------------------------------------------------------------------

function TModbusBuffer.GetWordLoHi: Word;
// Extracts the Word from the buffer without updating the current position.
begin
  CheckAvailableSpace(SizeOf(Result));
  // Extract the bytes in a normal order.
  Result := PWord(FCurPtr)^;
end;

//--------------------------------------------------------------------------------------------------

function TModbusBuffer.LRC8: Byte;
// References [1,3] recommend the following steps to generate Modbus/ASCII 8-bit LRC
// error check field:
//
// 1. Add all bytes in the frame, excluding the starting 'colon',
//    and ending CRLF, into an 8-bit field, so that carries will be discarded.
// 2. Subtract the final field value from $FF (all 1's), to produce the ones-complement.
// 3. Add 1 to produce the twos-complement.
var
  I: Integer;
begin
  Result := 0;

  // Iterate the buffer from the start to the current position (exclusive).
  for I := 0 to Position - 1 do
    Result := Byte(Result + PByte(FStartPtr + I)^);
  Result := Byte(-ShortInt(Result));
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusBuffer.PutBlock(const Buffer; BlockSize: Integer);
// Puts BlockSize bytes into the buffer and adjusts the current position appropriately.
begin
  if BlockSize < 1 then Exit;
  CheckAvailableSpace(BlockSize);
  System.Move(Buffer, FCurPtr^, BlockSize);
  Inc(FCurPtr, BlockSize);
  if FCurPtr > FPeakPtr then FPeakPtr := FCurPtr;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusBuffer.PutByte(Data: Byte);
// Puts a Byte into the buffer and adjusts the current position appropriately.
begin
  CheckAvailableSpace(SizeOf(Data));
  PByte(FCurPtr)^ := Data;
  Inc(FCurPtr, SizeOf(Data));
  if FCurPtr > FPeakPtr then FPeakPtr := FCurPtr;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusBuffer.PutWordHiLo(Data: Word); // Used to emit the common data.
// Puts a Word into the buffer and adjusts the current position appropriately.
begin
  CheckAvailableSpace(SizeOf(Data));
  // Put the bytes in a reverse order.
  PByte(FCurPtr)^ := WordRec(Data).Hi;
  PByte(FCurPtr + SizeOf(Byte))^ := WordRec(Data).Lo;
  Inc(FCurPtr, SizeOf(Data));
  if FCurPtr > FPeakPtr then FPeakPtr := FCurPtr;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusBuffer.PutWordLoHi(Data: Word); // Used to emit the CRC16 error check field only.
// Puts a Word into the buffer and adjusts the current position appropriately.
begin
  CheckAvailableSpace(SizeOf(Data));
  // Put the bytes in a normal order.
  PWord(FCurPtr)^ := Data;
  Inc(FCurPtr, SizeOf(Data));
  if FCurPtr > FPeakPtr then FPeakPtr := FCurPtr;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusBuffer.Seek(Mode: TSeekMode);
// Allows to change the current position in a variety of ways.
begin
  case Mode of
    smBufStart:
      FCurPtr := FStartPtr;
    smBufEnd:
      FCurPtr := FPeakPtr;
    smPriorByte:
      Position := Position - SizeOf(Byte);
    smNextByte:
      Position := Position + SizeOf(Byte);
    smPriorWord:
      Position := Position - SizeOf(Word);
    smNextWord:
      Position := Position + SizeOf(Word);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusBuffer.SetPosition(Value: Integer);
// Property setter for Position property.
begin
  if GetPosition <> Value then
  begin
    if (Value < 0 ) or (Value > Integer(FPeakPtr - FStartPtr)) then
      ModLinkError(@RsInvalidBufferPositionArgs, [Value]);
    FCurPtr := FStartPtr + Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusBuffer.SetSize(Value: Integer);
// Property setter for Size property.
begin
  if GetSize <> Value then
  begin
    if (Value < 0) or (Value > FCapacity) then
      ModLinkError(@RsInvalidBufferSizeArgs, [Value]);

    // Set buffer size.
    FPeakPtr := FStartPtr + Value;

    // Validate current buffer position.
    if FCurPtr > FPeakPtr then FCurPtr := FPeakPtr;
  end;
end;

//--------------------------------------------------------------------------------------------------
// TModbusTransaction class
//--------------------------------------------------------------------------------------------------

constructor TModbusTransaction.Create(BufCapacity: Cardinal);
// Standard constructor.
begin
  inherited Create;
  FQueryBuffer := TModbusBuffer.Create(BufCapacity);
  FReplyBuffer := TModbusBuffer.Create(BufCapacity);
end;

//--------------------------------------------------------------------------------------------------

destructor TModbusTransaction.Destroy;
// Standard destructor.
begin
  FReplyBuffer.Free;
  FQueryBuffer.Free;
  inherited;
end;

//--------------------------------------------------------------------------------------------------
// TModbusFileRecord class
//--------------------------------------------------------------------------------------------------

const
  MaxFileRecordIndex = 9999;

//--------------------------------------------------------------------------------------------------

resourcestring
  RsInvalidStartRegArgs = 'Starting register index is invalid (%d)';
  RsInvalidRegisterArgs = 'Register index is invalid (%d)';

//--------------------------------------------------------------------------------------------------

constructor TModbusFileRecord.Create(AFileID: Word; AStartReg: Word; ARegCount: Integer);
// Standard constructor.
begin
  inherited Create;
  // There is no special restrictions imposed on a file id.
  FFileID := AFileID;
  AdjustRange(AStartReg, ARegCount);
end;

//--------------------------------------------------------------------------------------------------

destructor TModbusFileRecord.Destroy;
// Standard desctructor.
begin
  Finalize(FRegValues);
  inherited;
end;

//--------------------------------------------------------------------------------------------------

function TModbusFileRecord.GetRegCount: Integer;
// Property getter for RegCount property.
begin
  Result := Length(FRegValues);
end;

//--------------------------------------------------------------------------------------------------

function TModbusFileRecord.GetRegValue(Index: Integer): Word;
// Property getter for RegValues property.
begin
  if (Index < 0) or (Index > High(FRegValues)) then ModLinkError(@RsInvalidRegisterArgs, [Index]);
  Result := FRegValues[Index];
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusFileRecord.AdjustRange(AStartReg: Word; ARegCount: Integer);
// Allows to modify the StartReg and the RegCount properties at once.
begin
  // We do not need to check the validity of ARegCount here since it is already done by
  // ReadFileRecord or WriteFileRecord methods of TModbusClient.
  // But we must assure that entire range of register references should fit into 16-bits.
  if AStartReg + ARegCount - 1 > MaxFileRecordIndex then
    ModLinkError(@RsInvalidStartRegArgs, [AStartReg]);

  SetLength(FRegValues, ARegCount);
  FStartReg := AStartReg;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusFileRecord.SetRegCount(Value: Integer);
// Property setter for RegCount property.
begin
  if GetRegCount <> Value then AdjustRange(FStartReg, Value);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusFileRecord.SetRegValue(Index: Integer; Value: Word);
// Property setter for RegValues property.
begin
  if (Index < 0) or (Index > High(FRegValues)) then ModLinkError(@RsInvalidRegisterArgs, [Index]);
  FRegValues[Index] := Value;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusFileRecord.SetStartReg(Value: Word);
// Property setter for StartReg property.
begin
  if FStartReg <> Value then AdjustRange(Value, GetRegCount);
end;

//--------------------------------------------------------------------------------------------------
// TModbusFileRecordList class
//--------------------------------------------------------------------------------------------------

constructor TModbusFileRecordList.Create;
// Standard constructor.
begin
  inherited;
  FList := TList.Create;
end;

//--------------------------------------------------------------------------------------------------

destructor TModbusFileRecordList.Destroy;
// Standard destructor.
begin
  Clear;
  FList.Free;
  inherited;
end;

//--------------------------------------------------------------------------------------------------

function TModbusFileRecordList.Add(AFileID: Word; AStartReg: Word; ARegCount: Integer): TModbusFileRecord;
// Creates a new instance of TModbusFileRecord object using given method parameters
// and adds it to the internal list.
begin
  Result := TModbusFileRecord.Create(AFileID, AStartReg, ARegCount);
  try
    // Add this record to the list.
    FList.Add(Pointer(Result));
  except
    Result.Free;
    raise;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusFileRecordList.Add(AFileID: Word; AStartReg: Word; const ARegValues: array of Word): TModbusFileRecord;
// Creates a new instance of TModbusFileRecord object using given method parameters
// and adds it to the internal list.
begin
  Result := TModbusFileRecord.Create(AFileID, AStartReg, Length(ARegValues));
  try
    // Copy the supplied register values into internal array before adding
    // this record in the list. Keep in mind that source (i.e. ARegValues)
    // may not necessarily be the zero based array.
    Move(ARegValues[Low(ARegValues)], Result.FRegValues[0], Result.RegCount * SizeOf(Word));
    FList.Add(Pointer(Result));
  except
    Result.Free;
    raise;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusFileRecordList.Clear;
// Clears the internal list.
begin
  while FList.Count > 0 do Self.Delete(0);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusFileRecordList.Delete(Index: Integer);
// Removes the file record referenced by the Index parameter from the internal list.
var
  Dummy: TModbusFileRecord;
begin
  Dummy := GetItem(Index);
  FList.Delete(Index);
  Dummy.Free;
end;

//--------------------------------------------------------------------------------------------------

function TModbusFileRecordList.GetCount: Integer;
// Property getter for Count property.
begin
  Result := FList.Count;
end;

//--------------------------------------------------------------------------------------------------

function TModbusFileRecordList.GetItem(Index: Integer): TModbusFileRecord;
// Property getter for Items property.
begin
  Result := TModbusFileRecord(FList[Index]);
end;

//--------------------------------------------------------------------------------------------------

function TModbusFileRecordList.Remove(FileRecord: TModbusFileRecord): Integer;
// Removes the file record referenced by FileRecord parameter from the internal list.
begin
  Result := FList.IndexOf(Pointer(FileRecord));
  if Result >= 0 then Self.Delete(Result);
end;

//--------------------------------------------------------------------------------------------------
// TModbusClient class
//--------------------------------------------------------------------------------------------------

const

  // Diagnostic action to sub-command mappings.

  DiagnosticActions: array [TDiagnosticAction] of Word = (
    Subcmd_Diagnostics_ReturnQueryData,
    Subcmd_Diagnostics_RestartCommsOption,
    Subcmd_Diagnostics_RestartCommsOptionAndClearEventLog,
    Subcmd_Diagnostics_ReturnDiagnosticRegister,
    Subcmd_Diagnostics_ForceListenOnlyMode,
    Subcmd_Diagnostics_ClearCountersAndDiagnosticRegister,
    Subcmd_Diagnostics_ReturnBusMessageCount,
    Subcmd_Diagnostics_ReturnBusCommErrorCount,
    Subcmd_Diagnostics_ReturnBusExceptionErrorCount,
    Subcmd_Diagnostics_ReturnServerMessageCount,
    Subcmd_Diagnostics_ReturnServerNoReplyCount,
    Subcmd_Diagnostics_ReturnServerNegativeAcknowledgeCount,
    Subcmd_Diagnostics_ReturnServerBusyCount,
    Subcmd_Diagnostics_ReturnBusCharacterOverrunCount,
    Subcmd_Diagnostics_ClearOverrunCounterAndFlag
  );

  // Server address reserved for broadcasting mode.

  BroadcastAddress = 0;

  // Data to be looped back used in daReturnQueryData diagnostic action.
  // Taken from the example in the Ref. [1]

  LoopbackTestData = $A537;

  // Causes event log to be cleared also during daRestartCommsOption diagnostic action.

  ClearEventLogData = $FF00;

  // Used in ReadFileRecord / WriteFileRecord Modbus commands.

  ReferenceType = $06;

  // Used in 1-bit discrete access support routines.

  BitsPerByte = 8;

  BitMasks: array[0..BitsPerByte - 1] of Byte = (
    $01, // 00000001
    $02, // 00000010
    $04, // 00000100
    $08, // 00001000
    $10, // 00010000
    $20, // 00100000
    $40, // 01000000
    $80  // 10000000
  );

  // Used to set a specific coil to On (True).

  CoilOn = $FF00;

  // Used to set a specific coil to Off (False).

  CoilOff = $0000;


//--------------------------------------------------------------------------------------------------

resourcestring
  RsNoActiveConnection = 'There is no active connection';
  RsClientNotDisconnected = 'Client must be disconnected';
  RsNoActiveTransaction = 'There is no active transaction';

  RsOutOfRangeArgs = 'Value must be between %d and %d';
  RsUnknownDiagnosticAction = 'Diagnostic action was not recognized';
  RsInvalidStartBitArgs = 'Starting discrete i/o index is invalid (%d)';
  RsInvalidBitCountArgs = 'Discrete i/o count must be between 1 and %d';
  RsInvalidRegCountArgs = 'Register count must be between 1 and %d';
  RsInvalidFileRecList = 'File record list is empty or invalid';
  RsInvalidRequestDataSizeArgs = 'Invalid request data size (%d)';

  RsServerExceptionUnknown = 'Unknown exception code';
  RsServerExceptionIllegalCommand = 'Illegal command';
  RsServerExceptionIllegalDataAddress = 'Illegal data address';
  RsServerExceptionIllegalDataValue = 'Illegal data value';
  RsServerExceptionServerFailure = 'Server failure';
  RsServerExceptionAcknowledge = 'Acknowledge';
  RsServerExceptionServerBusy = 'Server is busy';
  RsServerExceptionNegativeAcknowledge = 'Negative acknowledge';
  RsServerExceptionMemoryParityError = 'Memory parity error';

//--------------------------------------------------------------------------------------------------

function DetermineEncodedSize(RawSize: Integer): Integer;
begin
  Result := RawSize div BitsPerByte;
  if RawSize mod BitsPerByte <> 0 then
    Inc(Result);
end;

//--------------------------------------------------------------------------------------------------

procedure EncodeBits(const Source: array of Boolean; Dest: TModbusBuffer);
var
  I, LastIndex, Bit: Integer;
  Accumulator: Byte;
begin
  I := Low(Source);
  LastIndex := High(Source);
  Bit := 0;
  Accumulator := 0;

  while I <= LastIndex do
  begin
    if Source[I] then
      Accumulator := Accumulator or BitMasks[Bit];

    Inc(I);
    Inc(Bit);

    if (Bit = BitsPerByte) and (I <= LastIndex) then
    begin
      Dest.PutByte(Accumulator);
      Bit := 0;
      Accumulator := 0;
    end;
  end;

  if Bit > 0 then
    Dest.PutByte(Accumulator);
end;

//--------------------------------------------------------------------------------------------------

procedure DecodeBits(Source: TModbusBuffer; var Dest: array of Boolean);
// Dest must already have enough room.
var
  I, LastIndex, Bit: Integer;
  Accumulator: Byte;
begin
  I := Low(Dest);
  LastIndex := High(Dest);
  Bit := 0;

  Accumulator := Source.GetByte;
  Source.Seek(smNextByte);

  while I <= LastIndex do
  begin
    Dest[I] := Accumulator and BitMasks[Bit] <> 0;

    Inc(I);
    Inc(Bit);

    // Fetch next byte from the buffer.
    if (Bit = BitsPerByte) and (I <= LastIndex) then
    begin
      Bit := 0;
      Accumulator := Source.GetByte;
      Source.Seek(smNextByte);
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

constructor TModbusClient.Create(AOwner: TComponent);
// Standard constructor.
begin
  inherited;
  FMaxConsecutiveTimeouts := -1;
  FServerAddress := 1;
end;

//--------------------------------------------------------------------------------------------------

destructor TModbusClient.Destroy;
// Standard destructor.
begin
  // Unregister this client with the FConnection (if applicable).
  SetConnection(nil);
  inherited;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.CheckConnected;
// Checks the Connection property to determine if we can initiate transactions.
// Upon a success it does nothing, but upon a failure it raises an exception.
begin
  if not ((FConnection <> nil) and FConnection.Active and
    (FConnection.ComponentState * [csLoading, csDesigning] = [])) then
  begin
    ModLinkError(@RsNoActiveConnection);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.CheckDisconnected;
// Checks the Connection property to determine if we can initiate transactions.
// Upon a success it does nothing, but upon a failure it raises an exception.
begin
  if (Connection <> nil) and Connection.Active and
    (Connection.ComponentState * [csLoading, csDesigning] = []) then
  begin
    ModLinkError(@RsClientNotDisconnected);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.ClearConsecutiveTimeoutCounter;
begin
  FConsecutiveTimeoutCount := 0;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.Diagnostics(Action: TDiagnosticAction; UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
var
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_Diagnostics);
          // Diagnostics sub-command code.
          PutWordHiLo(DiagnosticActions[Action]);
          // Data field.
          if Action = daReturnQueryData then
            PutWordHiLo(LoopbackTestData)
          else
            if Action = daRestartCommsOptionAndClearEventLog then
              PutWordHiLo(ClearEventLogData)
            else
              PutWordHiLo($0000);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoCoilsRead(const Info: TTransactionInfo; StartBit: Word; BitCount: Word;
  const BitValues: TBitValues);
// Event trigger.
begin
  if Assigned(FOnCoilsRead) then
    FOnCoilsRead(Self, Info, StartBit, BitCount, BitValues);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoConsecutiveTimeoutLimitExceed;
begin
  if Assigned(FOnConsecutiveTimeoutLimitExceed) then
    FOnConsecutiveTimeoutLimitExceed(Self);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoCustomTransactionComplete(Transaction: TModbusTransaction; Command: Byte);
// Event trigger.
begin
  if Assigned(FOnCustomTransactionComplete) then
    FOnCustomTransactionComplete(Self, Transaction, Command);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoDiagnostics(const Info: TTransactionInfo; Action: TDiagnosticAction; Result: Word);
// Event trigger.
begin
  if Assigned(FOnDiagnostics) then
    FOnDiagnostics(Self, Info, Action, Result);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoDiscreteInputsRead(const Info: TTransactionInfo; StartBit: Word; BitCount: Word;
  const BitValues: TBitValues);
// Event trigger.
begin
  if Assigned(FOnDiscreteInputsRead) then
    FOnDiscreteInputsRead(Self, Info, StartBit, BitCount, BitValues);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoExceptionStatusRead(const Info: TTransactionInfo; const StatusValues: TExceptionStatusValues);
// Event trigger.
begin
  if Assigned(FOnExceptionStatusRead) then
    FOnExceptionStatusRead(Self, Info, StatusValues);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoFileRecordRead(const Info: TTransactionInfo; FileRecList: TModbusFileRecordList);
// Event trigger.
begin
  if Assigned(FOnFileRecordRead) then
    FOnFileRecordRead(Self, Info, FileRecList);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoFileRecordWrite(const Info: TTransactionInfo; FileRecList: TModbusFileRecordList);
// Event trigger.
begin
  if Assigned(FOnFileRecordWrite) then
    FOnFileRecordWrite(Self, Info, FileRecList);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoHoldingRegistersRead(const Info: TTransactionInfo; StartReg: Word;
  RegCount: Word; const RegValues: TRegValues);
// Event trigger.
begin
  if Assigned(FOnHoldingRegistersRead) then
    FOnHoldingRegistersRead(Self, Info, StartReg, RegCount, RegValues);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoInputRegistersRead(const Info: TTransactionInfo; StartReg: Word;
  RegCount: Word; const RegValues: TRegValues);
// Event trigger.
begin
  if Assigned(FOnInputRegistersRead) then
    FOnInputRegistersRead(Self, Info, StartReg, RegCount, RegValues);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoMultipleCoilsWrite(const Info: TTransactionInfo; StartBit: Word;
  BitCount: Word; const BitValues: TBitValues);
// Event trigger.
begin
  if Assigned(FOnMultipleCoilsWrite) then
    FOnMultipleCoilsWrite(Self, Info, StartBit, BitCount, BitValues);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoMultipleRegistersReadWrite(const Info: TTransactionInfo;
  StartRegToRead: Word; RegCountToRead: Word; const RegValuesToRead: TRegValues;
  StartRegToWrite: Word; RegCountToWrite: Word; const RegValuesToWrite: TRegValues);
// Event trigger.
begin
  if Assigned(FOnMultipleRegistersReadWrite) then
    FOnMultipleRegistersReadWrite(Self, Info, StartRegToRead, RegCountToRead,
      RegValuesToRead, StartRegToWrite, RegCountToWrite, RegValuesToWrite);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoMultipleRegistersWrite(const Info: TTransactionInfo; StartReg: Word;
  RegCount: Word; const RegValues: TRegValues);
// Event trigger.
begin
  if Assigned(FOnMultipleRegistersWrite) then
    FOnMultipleRegistersWrite(Self, Info, StartReg, RegCount, RegValues);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneCustomTransaction(Transaction: TModbusTransaction; Command: Byte);
begin
  { In promiscuous mode, obtain the server address from the reply buffer }
  if Transaction.Promiscuous and (Transaction.Info.Reply >= srUnmatchedReply) then
    Transaction.Info.Address := Connection.AcquireServerAddress(Transaction.ReplyBuffer);

  // Trigger an appropriate event.
  DoCustomTransactionComplete(Transaction, Command);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneDiagnostics(Transaction: TModbusTransaction);

  function SubcommandToAction(Subcmd: Word): TDiagnosticAction;
  begin
    for Result := Low(Result) to High(Result) do
      if Subcmd = DiagnosticActions[Result] then Exit;
    ModLinkError(@RsUnknownDiagnosticAction);
    // The following line will actually never get executed, because a call to
    // ModLinkError procedure above will cause an exception to be raised.
    // It is there just to suppress the incorrectly emitted compiler warning
    // "FOR-Loop variable 'Result' may be undefined after loop".
    Result := daReturnQueryData;
  end;

const
  EchoActions = [daReturnQueryData, daRestartCommsOption, daRestartCommsOptionAndClearEventLog,
    daClearCountersAndDiagnosticRegister, daClearOverrunCounterAndFlag];
var
  Subcommand, Data: Word;
  Action: TDiagnosticAction;
  Result: Word;
begin
  with Transaction.QueryBuffer do
  begin
    // Skip ADU header and Command field. Acquire Subcommand.
    Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
    Subcommand := GetWordHiLo;
    Action := SubcommandToAction(Subcommand);

    // Skip Subcommand field. Acquire Data.
    Seek(smNextWord);
    Data := GetWordHiLo;

    // The following test is needed to distinguish between daRestartCommsOption and
    // daRestartCommsOptionAndClearEventLog actions, since they both share the same
    // sub-command code and differ only in the frame data field.
    if (Action = daRestartCommsOption) and (Data = ClearEventLogData) then
      Action := daRestartCommsOptionAndClearEventLog;
  end;

  Result := 0;

  if Transaction.Info.Reply = srNormalReply then
    with Transaction.ReplyBuffer do
    begin
      try
        // Skip ADU header and Command field.
        Position := FConnection.DetermineHeaderSize + SizeOf(Byte);

        // Subcommand field must match the same field in the query.
        if GetWordHiLo <> Subcommand then InternalError;

        // Skip Subcommand field.
        Seek(smNextWord);

        // Certain diagnostic actions echo the Data field in the reply (see EchoActions).
        // Action daForceListenOnlyMode causes no reply to be returned at all.
        // The rest of diagnostic actions cause the result of diagnostics to be returned
        // by the server in the reply's Data field.
        if Action in EchoActions then
        begin
          if GetWordHiLo <> Data then InternalError;
        end
        else
          Result := GetWordHiLo;
      except
        on EModLinkError do
        begin
          Transaction.Info.Reply := srUnmatchedReply;
        end;
      else
        raise;
      end;
    end;

  // Trigger an appropriate event.
  DoDiagnostics(Transaction.Info, Action, Result);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneMaskWriteSingleRegister(Transaction: TModbusTransaction);
var
  RegAddr, AndMask, OrMask: Word;
begin
  with Transaction.QueryBuffer do
  begin
    // Skip ADU header and Command field. Acquire RegAddr.
    Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
    RegAddr := GetWordHiLo;

    // Skip RegAddr field, and acquire AndMask.
    Seek(smNextWord);
    AndMask := GetWordHiLo;

    // Skip AndMask field, and acquire OrMask.
    Seek(smNextWord);
    OrMask := GetWordHiLo;
  end;

  if Transaction.Info.Reply = srNormalReply then
    with Transaction.ReplyBuffer do
    begin
      try
        // Skip ADU header and Command field.
        Position := FConnection.DetermineHeaderSize + SizeOf(Byte);

        // RegAddr field must match the same field in the query.
        if GetWordHiLo <> RegAddr then InternalError;

        // Skip RegAddr field.
        Seek(smNextWord);

        // AndMask field must match the same field in the query.
        if GetWordHiLo <> AndMask then InternalError;

        // Skip AndMask RegAddr field.
        Seek(smNextWord);

        // OrMask field must match the same field in the query.
        if GetWordHiLo <> OrMask then InternalError;
      except
        on EModLinkError do
        begin
          Transaction.Info.Reply := srUnmatchedReply;
        end;
      else
        raise;
      end;
    end;

  // Trigger an appropriate event.
  DoSingleRegisterMaskWrite(Transaction.Info, RegAddr, AndMask, OrMask);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DonePublicTransaction(Transaction: TModbusTransaction; Command: Byte);
begin
  case Command of
    Cmd_ReadCoils:
      DoneReadDiscreteBits(Transaction, True);
    Cmd_ReadDiscreteInputs:
      DoneReadDiscreteBits(Transaction, False);
    Cmd_ReadHoldingRegisters:
      DoneReadModbusRegisters(Transaction, True);
    Cmd_ReadInputRegisters:
      DoneReadModbusRegisters(Transaction, False);
    Cmd_WriteSingleCoil:
      DoneWriteSingleCoil(Transaction);
    Cmd_WriteSingleRegister:
      DoneWriteSingleRegister(Transaction);
    Cmd_ReadExceptionStatus:
      DoneReadExceptionStatus(Transaction);
    Cmd_Diagnostics:
      DoneDiagnostics(Transaction);
    Cmd_WriteMultipleCoils:
      DoneWriteMultipleCoils(Transaction);
    Cmd_WriteMultipleRegisters:
      DoneWriteMultipleRegisters(Transaction);
    Cmd_ReportServerID:
      DoneReportServerID(Transaction);
    Cmd_ReadFileRecord:
      DoneReadFileRecord(Transaction);
    Cmd_WriteFileRecord:
      DoneWriteFileRecord(Transaction);
    Cmd_MaskWriteRegister:
      DoneMaskWriteSingleRegister(Transaction);
    Cmd_ReadWriteMultipleRegisters:
      DoneReadWriteMultipleRegisters(Transaction);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneReadDiscreteBits(Transaction: TModbusTransaction; Coils: Boolean);
var
  StartBit, BitCount: Word;
  BitValues: TBitValues;
begin
  with Transaction.QueryBuffer do
  begin
    // Skip ADU header and Command field. Acquire StartBit.
    Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
    StartBit := GetWordHiLo;

    // Skip StartBit field, and acquire BitCount.
    Seek(smNextWord);
    BitCount := GetWordHiLo;
  end;

  SetLength(BitValues, BitCount);

  try
    if Transaction.Info.Reply = srNormalReply then
      with Transaction.ReplyBuffer do
      begin
        try
          // Skip ADU header and Command field.
          Position := FConnection.DetermineHeaderSize + SizeOf(Byte);

          // Check the ByteCount field.
          if GetByte <> DetermineEncodedSize(BitCount) then InternalError;

          // Skip ByteCount field.
          Seek(smNextByte);

          // Decode the bits.
          DecodeBits(Transaction.ReplyBuffer, BitValues);
        except
          on EModLinkError do
          begin
           Transaction.Info.Reply := srUnmatchedReply;
          end;
        else
          raise;
        end;
      end;

    // Trigger an appropriate event depending on the command code.
    if Coils then
      DoCoilsRead(Transaction.Info, StartBit, BitCount, BitValues)
    else
      DoDiscreteInputsRead(Transaction.Info, StartBit, BitCount, BitValues);
  finally
    Finalize(BitValues);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneReadExceptionStatus(Transaction: TModbusTransaction);
var
  StatusValues: TExceptionStatusValues;
begin
  SetLength(StatusValues, 8);
  if Transaction.Info.Reply = srNormalReply then
    with Transaction.ReplyBuffer do
    begin
      try
        // Skip ADU header and Command field.
        Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
        // Decode the exception status byte.
        DecodeBits(Transaction.ReplyBuffer, StatusValues);
      except
        on EModLinkError do
        begin
          Transaction.Info.Reply := srUnmatchedReply;
        end;
      else
        raise;
      end;
    end;

  // Trigger an appropriate event.
  DoExceptionStatusRead(Transaction.Info, StatusValues);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneReadFileRecord(Transaction: TModbusTransaction);
const
  QuerySubRequestSize = SizeOf(Byte) + 3 * SizeOf(Word); // [RefType | FileID | StartReg | RegCount]
var
  FileRecList: TModbusFileRecordList;
  SubRequestCount, I, J: Integer;
  ByteCount: Cardinal;
  XFileID, XStartReg, XRegCount: Word;
begin
  FileRecList := TModbusFileRecordList.Create;
  try
    with Transaction.QueryBuffer do
    begin
      // Skip ADU header and Command field.
      // Acquire ByteCount to determine the sub-request count.
      Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
      SubRequestCount := GetByte div QuerySubRequestSize;

      // Skip ByteCount field.
      Seek(smNextByte);

      ByteCount := 0;

      // Fetch individual sub-requests.
      for I := 0 to SubRequestCount - 1 do
      begin
        // Skip RefType field. Acquire FileID.
        Seek(smNextByte);
        XFileID := GetWordHiLo;
        // Skip FileID field. Acquire StartReg.
        Seek(smNextWord);
        XStartReg := GetWordHiLo;
        // Skip StartReg field. Acquire RegCount.
        Seek(smNextWord);
        XRegCount := GetWordHiLo;
        // Skip RegCount field.
        Seek(smNextWord);
        // Add new file record to the list.
        FileRecList.Add(XFileID, XStartReg, Integer(XRegCount));
        // Increment the variable by number of bytes occupied by this sub-request in the reply
        // [LocalByteCount | RefType | N * Data].
        Inc(ByteCount, 2 * SizeOf(Byte) + XRegCount * SizeOf(Word));
      end;
    end;

    if Transaction.Info.Reply = srNormalReply then
      with Transaction.ReplyBuffer do
      begin
        try
          // Skip ADU header and Command field.
          Position := FConnection.DetermineHeaderSize + SizeOf(Byte);

          // Global ByteCount field must match the expected value.
          if GetByte <> ByteCount then InternalError;

          // Skip global ByteCount field.
          Seek(smNextByte);

          for I := 0 to SubRequestCount - 1 do
            with FileRecList[I] do
            begin
              // Local ByteCount field must match the expected value.
              if GetByte <> (SizeOf(Byte) + RegCount * SizeOf(Word)) then InternalError;
              // Skip local ByteCount field.
              Seek(smNextByte);

              // RefType field must match the expected value.
              if GetByte <> ReferenceType then InternalError;
              // Skip refType field.
              Seek(smNextByte);

              // Fill the array with register values.
              for J := 0 to RegCount - 1 do
              begin
                // Acquire the register value and move to the next one.
                RegValues[J] := GetWordHiLo;
                Seek(smNextWord);
              end;
            end;
        except
          on EModLinkError do
          begin
           Transaction.Info.Reply := srUnmatchedReply;
          end;
        else
          raise;
        end;
      end;

    // Trigger an appropriate event.
    DoFileRecordRead(Transaction.Info, FileRecList);
  finally
    FileRecList.Free;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneReadModbusRegisters(Transaction: TModbusTransaction; HoldingRegisters: Boolean);
var
  StartReg, RegCount: Word;
  RegValues: TRegValues;
  I: Integer;
begin
  with Transaction.QueryBuffer do
  begin
    // Skip ADU header and Command field. Acquire StartReg.
    Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
    StartReg := GetWordHiLo;

    // Skip StartReg field, and acquire RegCount.
    Seek(smNextWord);
    RegCount := GetWordHiLo;
  end;

  SetLength(RegValues, RegCount);

  try
    if Transaction.Info.Reply = srNormalReply then
      with Transaction.ReplyBuffer do
      begin
        try
          // Skip ADU header and Command field.
          Position := FConnection.DetermineHeaderSize + SizeOf(Byte);

          // ByteCount field divided by SizeOf(Word) must match RegCount field in the query.
          if GetByte div SizeOf(Word) <> RegCount then InternalError;

          // Skip ByteCount field.
          Seek(smNextByte);

          // Fill the array with register values.
          for I := 0 to High(RegValues) do
          begin
            // Acquire the register value and move to the next one.
            RegValues[I] := GetWordHiLo;
            Seek(smNextWord);
          end;
        except
          on EModLinkError do
          begin
           Transaction.Info.Reply := srUnmatchedReply;
          end;
        else
          raise;
        end;
      end;

    // Trigger an appropriate event depending on the command code.
    if HoldingRegisters then
      DoHoldingRegistersRead(Transaction.Info, StartReg, RegCount, RegValues)
    else
      DoInputRegistersRead(Transaction.Info, StartReg, RegCount, RegValues);
  finally
    Finalize(RegValues);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneReadWriteMultipleRegisters(Transaction: TModbusTransaction);
var
  StartRegToRead, RegCountToRead, StartRegToWrite, RegCountToWrite: Word;
  RegValuesToRead, RegValuesToWrite: TRegValues;
  I: Integer;
begin
  with Transaction.QueryBuffer do
  begin
    // Skip ADU header and Command field. Acquire StartRegToRead.
    Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
    StartRegToRead := GetWordHiLo;

    // Skip StartRegToRead field, and acquire RegCountToRead.
    Seek(smNextWord);
    RegCountToRead := GetWordHiLo;

    // Skip RegCountToRead, and acquire StartRegToWrite.
    Seek(smNextWord);
    StartRegToWrite := GetWordHiLo;

    // Skip StartRegToWrite, and acquire RegCountToWrite.
    Seek(smNextWord);
    RegCountToWrite := GetWordHiLo;
  end;

  SetLength(RegValuesToWrite, RegCountToWrite);
  try
    with Transaction.QueryBuffer do
    begin
      // Skip RegCountToWrite and ByteCount fields.
      Position := Position + SizeOf(Word) + SizeOf(Byte);

      // Fill the array with register values to write.
      for I := 0 to High(RegValuesToWrite) do
      begin
        // Acquire the register value and move to the next one.
        RegValuesToWrite[I] := GetWordHiLo;
        Seek(smNextWord);
      end;
    end;

    SetLength(RegValuesToRead, RegCountToRead);
    try
      if Transaction.Info.Reply = srNormalReply then
        with Transaction.ReplyBuffer do
        begin
          try
            // Skip ADU header and Command field.
            Position := FConnection.DetermineHeaderSize + SizeOf(Byte);

            // ByteCount field divided by SizeOf(Word) must match RegCountToRead field in the query.
            if GetByte div SizeOf(Word) <> RegCountToRead then InternalError;

            // Skip ByteCount field.
            Seek(smNextByte);

            // Fill the array with register values to read.
            for I := 0 to High(RegValuesToRead) do
            begin
              // Acquire the register value and move to the next one.
              RegValuesToRead[I] := GetWordHiLo;
              Seek(smNextWord);
            end;
          except
            on EModLinkError do
            begin
              Transaction.Info.Reply := srUnmatchedReply;
            end;
          else
            raise;
          end;
        end;

      // Trigger an appropriate event.
      DoMultipleRegistersReadWrite(Transaction.Info, StartRegToRead, RegCountToRead,
        RegValuesToRead, StartRegToWrite, RegCountToWrite, RegValuesToWrite);
    finally
      Finalize(RegValuesToRead);
    end;
  finally
    Finalize(RegValuesToWrite);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneReportServerID(Transaction: TModbusTransaction);
var
  Count, I: Integer;
  Data: TServerIdentificationData;
begin
  Count := 0;
  Data  := nil;
  try
    if Transaction.Info.Reply = srNormalReply then
      with Transaction.ReplyBuffer do
      begin
        try
          // Skip ADU header and Command field.
          Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
          // Acquire the ByteCount, allocate enough data space.
          Count := GetByte;
          SetLength(Data, Count);
          // Skip ByteCount field.
          Seek(smNextByte);

          // Fill the array with identification data.
          for I := 0 to High(Data) do
          begin
            // Acquire the byte and move to the next one.
            Data[I] := GetByte;
            Seek(smNextByte);
          end;
        except
          on EModLinkError do
          begin
            Transaction.Info.Reply := srUnmatchedReply;
          end;
        else
          raise;
        end;
      end;

    // Trigger an appropriate event.
    DoServerIdentificationReport(Transaction.Info, Count, Data);
  finally
    Finalize(Data);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneTransaction(Transaction: TModbusTransaction);
var
  Command: Byte;
begin
  CheckConnected;
  Command := FConnection.AcquireModbusCommand(Transaction.QueryBuffer);
  if Transaction.Custom then
  begin
    DoneCustomTransaction(Transaction, Command);
  end
  else
  begin
    DonePublicTransaction(Transaction, Command);
  end;
  DoTransactionProcessed(Transaction.Info, Command, Transaction.Custom);
  KeepTrackOfConsecutiveTimeouts(Transaction.Info);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneWriteFileRecord(Transaction: TModbusTransaction);
var
  FileRecList: TModbusFileRecordList;
  I: Integer;
  MaxBufferPosition: Integer;
  XFileID, XStartReg, XRegCount: Word;
begin
  FileRecList := TModbusFileRecordList.Create;
  try
    with Transaction.QueryBuffer do
    begin
      // Skip ADU header and Command field. Acquire ByteCount to determine
      // the buffer position immediately after the sub-request block.
      // Do not forget to compensate for the ByteCount field itself by
      // adding an extra SizeOf(Byte) to that position. This approach is
      // needed since neither the query nor the reply contains explicit
      // information about the sub-request count.
      Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
      MaxBufferPosition := Position + GetByte + SizeOf(Byte);

      // Skip ByteCount field.
      Seek(smNextByte);

      // Fetch individual sub-requests.
      while Position < MaxBufferPosition do
      begin
        // Skip RefType field. Acquire FileID.
        Seek(smNextByte);
        XFileID := GetWordHiLo;
        // Skip FileID field. Acquire StartReg.
        Seek(smNextWord);
        XStartReg := GetWordHiLo;
        // Skip StartReg field. Acquire RegCount.
        Seek(smNextWord);
        XRegCount := GetWordHiLo;
        // Skip RegCount field.
        Seek(smNextWord);
        // Add new file record to the list. Fill the array with register values.
        with FileRecList.Add(XFileID, XStartReg, Integer(XRegCount)) do
          for I := 0 to RegCount - 1 do
          begin
            // Acquire the register value and move to the next one.
            RegValues[I] := GetWordHiLo;
            Seek(smNextWord);
          end;
      end;
    end;

    if Transaction.Info.Reply = srNormalReply then
      try
        // Reply is an echo of the query.
        with Transaction do
          if not ((QueryBuffer.Size = ReplyBuffer.Size) and
            CompareMem(QueryBuffer.StartPtr, ReplyBuffer.StartPtr, QueryBuffer.Size)) then
          begin
            InternalError;
          end;
      except
        on EModLinkError do
        begin
         Transaction.Info.Reply := srUnmatchedReply;
        end;
      else
        raise;
      end;

    // Trigger an appropriate event.
    DoFileRecordWrite(Transaction.Info, FileRecList);
  finally
    FileRecList.Free;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneWriteMultipleCoils(Transaction: TModbusTransaction);
var
  StartBit, BitCount: Word;
  BitValues: TBitValues;
begin
  with Transaction.QueryBuffer do
  begin
    // Skip ADU header and Command field. Acquire StartBit.
    Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
    StartBit := GetWordHiLo;

    // Skip StartBit field, and acquire BitCount.
    Seek(smNextWord);
    BitCount := GetWordHiLo;
  end;

  SetLength(BitValues, BitCount);

  try
    with Transaction.QueryBuffer do
    begin
      // Skip BitCount and ByteCount fields.
      Position := Position + SizeOf(Word) + SizeOf(Byte);

      // Decode the bits.
      DecodeBits(Transaction.QueryBuffer, BitValues);
    end;

    if Transaction.Info.Reply = srNormalReply then
      with Transaction.ReplyBuffer do
      begin
        try
          // Skip the ADU header and Command field.
          Position := FConnection.DetermineHeaderSize + SizeOf(Byte);

          // StartBit field must match the same field in the query.
          if GetWordHiLo <> StartBit then InternalError;

          // Skip the StartBit field.
          Seek(smNextWord);

          // BitCount field must match the same field in the query.
          if GetWordHiLo <> BitCount then InternalError;
        except
          on EModLinkError do
          begin
            Transaction.Info.Reply := srUnmatchedReply;
          end;
        else
          raise;
        end;
      end;

    // Trigger an appropriate event.
    DoMultipleCoilsWrite(Transaction.Info, StartBit, BitCount, BitValues);
  finally
    Finalize(BitValues);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneWriteMultipleRegisters(Transaction: TModbusTransaction);
var
  StartReg, RegCount: Word;
  RegValues: TRegValues;
  I: Integer;
begin
  with Transaction.QueryBuffer do
  begin
    // Skip ADU header and Command field. Acquire StartReg.
    Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
    StartReg := GetWordHiLo;

    // Skip StartReg field, and acquire RegCount.
    Seek(smNextWord);
    RegCount := GetWordHiLo;
  end;

  SetLength(RegValues, RegCount);

  try
    with Transaction.QueryBuffer do
    begin
      // Skip RegCount and ByteCount fields.
      Position := Position + SizeOf(Word) + SizeOf(Byte);

      // Fill the array with register values.
      for I := 0 to High(RegValues) do
      begin
        // Acquire the register value and move to the next one.
        RegValues[I] := GetWordHiLo;
        Seek(smNextWord);
      end;
    end;

    if Transaction.Info.Reply = srNormalReply then
      with Transaction.ReplyBuffer do
      begin
        try
          // Skip the ADU header and Command field.
          Position := FConnection.DetermineHeaderSize + SizeOf(Byte);

          // StartReg field must match the same field in the query.
          if GetWordHiLo <> StartReg then InternalError;

          // Skip the StartReg field.
          Seek(smNextWord);

          // RegCount field must match the same field in the query.
          if GetWordHiLo <> RegCount then InternalError;
        except
          on EModLinkError do
          begin
            Transaction.Info.Reply := srUnmatchedReply;
          end;
        else
          raise;
        end;
      end;

    // Trigger an appropriate event.
    DoMultipleRegistersWrite(Transaction.Info, StartReg, RegCount, RegValues);
  finally
    Finalize(RegValues);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneWriteSingleCoil(Transaction: TModbusTransaction);
var
  BitAddr, BitValue: Word;
begin
  with Transaction.QueryBuffer do
  begin
    // Skip ADU header and Command field. Acquire BitAddr.
    Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
    BitAddr := GetWordHiLo;

    // Skip BitAddr field, and acquire BitValue.
    Seek(smNextWord);
    BitValue := GetWordHiLo;
  end;

  if Transaction.Info.Reply = srNormalReply then
    with Transaction.ReplyBuffer do
    begin
      try
        // Skip ADU header and Command field.
        Position := FConnection.DetermineHeaderSize + SizeOf(Byte);

        // BitAddr field must match the same field in the query.
        if GetWordHiLo <> BitAddr then InternalError;

        // Skip the RegAddr field.
        Seek(smNextWord);

        // BitValue field must match the same field in the query.
        if GetWordHiLo <> BitValue then InternalError;
      except
        on EModLinkError do
        begin
          Transaction.Info.Reply := srUnmatchedReply;
        end;
      else
        raise;
      end;
    end;

  // Trigger an appropriate event.
  DoSingleCoilWrite(Transaction.Info, BitAddr, BitValue = CoilOn);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoneWriteSingleRegister(Transaction: TModbusTransaction);
var
  RegAddr, RegValue: Word;
begin
  with Transaction.QueryBuffer do
  begin
    // Skip ADU header and Command field. Acquire RegAddr.
    Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
    RegAddr := GetWordHiLo;

    // Skip RegAddr field, and acquire RegValue.
    Seek(smNextWord);
    RegValue := GetWordHiLo;
  end;

  if Transaction.Info.Reply = srNormalReply then
    with Transaction.ReplyBuffer do
    begin
      try
        // Skip ADU header and Command field.
        Position := FConnection.DetermineHeaderSize + SizeOf(Byte);

        // RegAddr field must match the same field in the query.
        if GetWordHiLo <> RegAddr then InternalError;

        // Skip the RegAddr field.
        Seek(smNextWord);

        // RegValue field must match the same field in the query.
        if GetWordHiLo <> RegValue then InternalError;
      except
        on EModLinkError do
        begin
          Transaction.Info.Reply := srUnmatchedReply;
        end;
      else
        raise;
      end;
    end;

  // Trigger an appropriate event.
  DoSingleRegisterWrite(Transaction.Info, RegAddr, RegValue);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoServerIdentificationReport(const Info: TTransactionInfo; Count: Integer; const Data: TServerIdentificationData);
begin
  if Assigned(FOnServerIdentificationReport) then
    FOnServerIdentificationReport(Self, Info, Count, Data);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoSingleCoilWrite(const Info: TTransactionInfo; BitAddr: Word; BitValue: Boolean);
// Event trigger.
begin
  if Assigned(FOnSingleCoilWrite) then
    FOnSingleCoilWrite(Self, Info, BitAddr, BitValue);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoSingleRegisterMaskWrite(const Info: TTransactionInfo; RegAddr: Word;
  AndMask: Word; OrMask: Word);
// Event trigger.
begin
  if Assigned(FOnSingleRegisterMaskWrite) then
    FOnSingleRegisterMaskWrite(Self, Info, RegAddr, AndMask, OrMask);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoSingleRegisterWrite(const Info: TTransactionInfo; RegAddr: Word;
  RegValue: Word);
// Event trigger.
begin
  if Assigned(FOnSingleRegisterWrite) then
    FOnSingleRegisterWrite(Self, Info, RegAddr, RegValue);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoTransactionProcessed(const Info: TTransactionInfo; Command: Byte; Custom: Boolean);
// Event trigger.
begin
  if Assigned(FOnTransactionProcessed) then
    FOnTransactionProcessed(Self, Info, Command, Custom);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.DoTranslateExceptionCode(ExceptionCode: Byte; var Description: string);
begin
  if Assigned(OnTranslateExceptionCode) then
    FOnTranslateExceptionCode(Self, ExceptionCode, Description); 
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.ExceptionCodeToStr(ExceptionCode: Byte): string;

  // begin of local block --------------------------------------------------------------------------

  function ExceptionCodeToServerException(Code: Byte): TServerException;
  begin
    if Code > Byte(High(TServerException)) then Code := Ord(seUnknown);
    Result := TServerException(Code);
  end;

  // end of local block ----------------------------------------------------------------------------

const
  ServerExceptions: array [TServerException] of PResStringRec = (
    @RsServerExceptionUnknown,
    @RsServerExceptionIllegalCommand,
    @RsServerExceptionIllegalDataAddress,
    @RsServerExceptionIllegalDataValue,
    @RsServerExceptionServerFailure,
    @RsServerExceptionAcknowledge,
    @RsServerExceptionServerBusy,
    @RsServerExceptionNegativeAcknowledge,
    @RsServerExceptionMemoryParityError
  );
begin
  // Fill the Result with a default description according to the supplied exception code.
  Result := LoadResString(ServerExceptions[ExceptionCodeToServerException(ExceptionCode)]);
  // Let the application to adjust the default description as needed.
  DoTranslateExceptionCode(ExceptionCode, Result);
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.InitCustomTransaction(Command: Byte; const RequestData: array of Byte;
  PromiscuousMode: Boolean; UserData: Pointer = nil): Cardinal;
// Implementation of custom Modbus command.
const
  MaxRequestDataSize = MaxFramePDUSize - SizeOf(Byte);
var
  RequestDataSize: Integer;
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  // Request data size must fall in range from 0 through MaxRequestDataSize.
  RequestDataSize := Length(RequestData);
  if (RequestDataSize < 0) or (RequestDataSize > MaxRequestDataSize) then
    ModLinkError(@RsInvalidRequestDataSizeArgs, [RequestDataSize]);

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        Custom := True;
        Promiscuous := PromiscuousMode;

        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Command);
          // Modbus request data.
          PutBlock(RequestData[Low(RequestData)], RequestDataSize);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.KeepTrackOfConsecutiveTimeouts(const Info: TTransactionInfo);
begin
  if MaxConsecutiveTimeouts >= 0 then
  begin
    if Info.Reply >= srUnmatchedReply then
    begin
      { Valid data frame was received. Remote server seems to be responding. }
      ClearConsecutiveTimeoutCounter;
    end
    else
    begin
      { Transaction timed out. Remote server does not seem to be responding. }
      Inc(FConsecutiveTimeoutCount, Info.Retries);
      if ConsecutiveTimeoutCount > Cardinal(MaxConsecutiveTimeouts) then
      begin
        ClearConsecutiveTimeoutCounter;
        DoConsecutiveTimeoutLimitExceed;
      end;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.MaskWriteSingleRegister(RegAddr: Word; AndMask: Word; OrMask: Word;
  UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
var
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_MaskWriteRegister);
          // The address of a holding register to be modified.
          PutWordHiLo(RegAddr);
          // The data value to be used as the AND mask.
          PutWordHiLo(AndMask);
          // The data value to be used as the OR mask.
          PutWordHiLo(OrMask);
        end;
        
        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  // Clear the Connection reference in case it's going to be destroyed.
  if (AComponent = FConnection) and (Operation = opRemove) then FConnection := nil;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.ReadCoils(StartBit: Word; BitCount: Word; UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
const
  // Calculation based on the reply PDU:
  // [Command | ByteCount | N * Data]
  MaxBitCount = (MaxFramePDUSize - 2 * SizeOf(Byte)) * BitsPerByte;
var
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  // BitCount must fall in range from 1 through MaxBitCount.
  if (BitCount < 1) or (BitCount > MaxBitCount) then
    ModLinkError(@RsInvalidBitCountArgs, [MaxBitCount]);

  // Entire range of bit references should fit into 16-bits.
  if (StartBit + BitCount - 1 > High(Word)) then
    ModLinkError(@RsInvalidStartBitArgs, [StartBit]);

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_ReadCoils);
          // The first coil to start the reading from.
          PutWordHiLo(StartBit);
          // The number of coils to be read.
          PutWordHiLo(BitCount);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.ReadDiscreteInputs(StartBit: Word; BitCount: Word; UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
const
  // Calculation based on the reply PDU:
  // [Command | ByteCount | N * Data]
  MaxBitCount = (MaxFramePDUSize - 2 * SizeOf(Byte)) * BitsPerByte;
var
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  // BitCount must fall in range from 1 through MaxBitCount.
  if (BitCount < 1) or (BitCount > MaxBitCount) then
    ModLinkError(@RsInvalidBitCountArgs, [MaxBitCount]);

  // Entire range of bit references should fit into 16-bits.
  if (StartBit + BitCount - 1 > High(Word)) then
    ModLinkError(@RsInvalidStartBitArgs, [StartBit]);

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_ReadDiscreteInputs);
          // The first discrete input to start the reading from.
          PutWordHiLo(StartBit);
          // The number of discrete inputs to be read.
          PutWordHiLo(BitCount);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.ReadExceptionStatus(UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
var
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_ReadExceptionStatus);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.ReadFileRecord(FileRecList: TModbusFileRecordList; UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
const
  QuerySubRequestSize = SizeOf(Byte) + 3 * SizeOf(Word); // [RefType | FileID | StartReg | RegCount]

  // begin of local block --------------------------------------------------------------------------

  procedure NeedValidFileRecordList;
  // Checks the validity of supplied Modbus file record list. Neither the query PDU nor
  // the reply PDU built upon this list is allowed to exceed the maximum Modbus PDU size.
  // Since it's not possible (unlike WriteFileRecord command) to unambinguously determine
  // which of these is greater, both frame sizes need to be examined.
  var
    FrameSize: Cardinal;
    I: Integer;
  begin
    // Examine the query size.
    FrameSize := 2 * SizeOf(Byte); // [Command | ByteCount]
    for I := 0 to FileRecList.Count - 1 do
      Inc(FrameSize, QuerySubRequestSize);
    if FrameSize > MaxFramePDUSize then
      ModLinkError(@RsInvalidFileRecList);

    // Examine the reply size.
    FrameSize := 2 * SizeOf(Byte); // [Command | ByteCount]
    for I := 0 to FileRecList.Count - 1 do
      // [LocalByteCount | RefType | N * Data]
      Inc(FrameSize, 2 * SizeOf(Byte) + FileRecList[I].RegCount * SizeOf(Word));
    if FrameSize > MaxFramePDUSize then
      ModLinkError(@RsInvalidFileRecList);
  end;

  // end of local block ----------------------------------------------------------------------------

var
  Transaction: TModbusTransaction;
  I: Integer;
begin
  CheckConnected;
  NeedValidFileRecordList;

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_ReadFileRecord);
          // The number of bytes occupied by all sub-requests.
          PutByte(FileRecList.Count * QuerySubRequestSize);
          // Individual sub-requests.
          for I := 0 to FileRecList.Count - 1 do
            with FileRecList[I] do
            begin
              // Reference type.
              PutByte(ReferenceType);
              // File identification.
              PutWordHiLo(FileID);
              // The first register to start the reading from.
              PutWordHiLo(StartReg);
              // The number of registers to be read.
              PutWordHiLo(RegCount);
            end;
        end;
        
        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.ReadHoldingRegisters(StartReg: Word; RegCount: Word;
  UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
const
  // Calculation based on the reply PDU:
  // [Command | ByteCount | N * Data]
  MaxRegCount = (MaxFramePDUSize - 2 * SizeOf(Byte)) div SizeOf(Word);
var
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  // RegCount must fall in range from 1 through MaxRegCount.
  if (RegCount < 1) or (RegCount > MaxRegCount) then
    ModLinkError(@RsInvalidRegCountArgs, [MaxRegCount]);

  // Entire range of register references should fit into 16-bits.
  if (StartReg + RegCount - 1 > High(Word)) then
    ModLinkError(@RsInvalidStartRegArgs, [StartReg]);

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_ReadHoldingRegisters);
          // The first holding register to start the reading from.
          PutWordHiLo(StartReg);
          // The number of holding registers to be read.
          PutWordHiLo(RegCount);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.ReadInputRegisters(StartReg: Word; RegCount: Word;
  UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
const
  // Calculation based on the reply PDU:
  // [Command | ByteCount | N * Data]
  MaxRegCount = (MaxFramePDUSize - 2 * SizeOf(Byte)) div SizeOf(Word);
var
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  // RegCount must fall in range from 1 through MaxRegCount.
  if (RegCount < 1) or (RegCount > MaxRegCount) then
    ModLinkError(@RsInvalidRegCountArgs, [MaxRegCount]);

  // Entire range of register references should fit into 16-bits.
  if (StartReg + RegCount - 1 > High(Word)) then
    ModLinkError(@RsInvalidStartRegArgs, [StartReg]);

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_ReadInputRegisters);
          // The first holding register to start the reading from.
          PutWordHiLo(StartReg);
          // The number of holding registers to be read.
          PutWordHiLo(RegCount);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.ReadWriteMultipleRegisters(StartRegToRead: Word; RegCountToRead: Word;
  StartRegToWrite: Word; const RegValuesToWrite: array of Word; UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
const
  // Calculation based on the reply PDU:
  // [Command | ByteCount | N * Data]
  MaxRegCountToRead = (MaxFramePDUSize - 2 * SizeOf(Byte)) div SizeOf(Word);
  // Calculation based on the query PDU:
  // [Command | StartReg | RegCount | StartReg | RegCount | ByteCount | N * Data]
  MaxRegCountToWrite = (MaxFramePDUSize - 2 * SizeOf(Byte) - 4 * SizeOf(Word)) div SizeOf(Word);
var
  RegCountToWrite, I: Integer;
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  // RegCountToRead must fall in range from 1 through MaxRegCountToRead.
  if (RegCountToRead < 1) or (RegCountToRead > MaxRegCountToRead) then
    ModLinkError(@RsInvalidRegCountArgs, [MaxRegCountToRead]);

  // Entire range of register references should fit into 16-bits.
  if (StartRegToRead + RegCountToRead - 1 > High(Word)) then
    ModLinkError(@RsInvalidStartRegArgs, [StartRegToRead]);

  // Acquire the number of holding registers to be written.
  RegCountToWrite := Length(RegValuesToWrite);

  // RegCountToWrite must fall in range from 1 through MaxRegCountToWrite.
  if (RegCountToWrite < 1) or (RegCountToWrite > MaxRegCountToWrite) then
    ModLinkError(@RsInvalidRegCountArgs, [MaxRegCountToWrite]);

  // Entire range of register references should fit into 16-bits.
  if (StartRegToWrite + RegCountToWrite - 1 > High(Word)) then
    ModLinkError(@RsInvalidStartRegArgs, [StartRegToWrite]);

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_ReadWriteMultipleRegisters);

          // The first holding register to start the reading from.
          PutWordHiLo(StartRegToRead);
          // The number of holding registers to be read.
          PutWordHiLo(RegCountToRead);

          // The first holding register to start the writing to.
          PutWordHiLo(StartRegToWrite);
          // The number of holding registers to be written.
          PutWordHiLo(RegCountToWrite);

          // The total number of bytes to be written.
          PutByte(RegCountToWrite * SizeOf(Word));

          // Register values to be written. Note that RegValuesToWrite may be either static or dynamic array
          // (we are using an open array parameters) so be careful when determining the array bounds.
          for I := Low(RegValuesToWrite) to High(RegValuesToWrite) do
            PutWordHiLo(RegValuesToWrite[I]);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;     
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.ReportServerID(UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
var
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_ReportServerID);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.SetConnection(Value: TModbusConnection);
// Property setter for Connection property.
begin
  if FConnection <> Value then
  begin
    if FConnection <> nil then
    begin
      FConnection.UnregisterClient(Self);
      {$IFDEF COMPILER_5_UP}
      FConnection.RemoveFreeNotification(Self);
      {$ENDIF COMPILER_5_UP}
    end;

    FConnection := Value;

    if FConnection <> nil then
    begin
      FConnection.RegisterClient(Self);
      FConnection.FreeNotification(Self);
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.SetMaxConsecutiveTimeouts(Value: Integer);
// Setter for MaxConsecutiveTimeouts property.
begin
  if Value < -1 then
  begin
    Value := -1;
  end;
  if FMaxConsecutiveTimeouts <> Value then
  begin
    FMaxConsecutiveTimeouts := Value;
    ClearConsecutiveTimeoutCounter;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusClient.SetServerAddress(Value: Byte);
// Property setter for SlaveAddress property.
begin
  { (v2.7) There is no restriction imposed on the value of this property
           anymore. However, this property may not be changed while the client
           is linked to an active connection. }
  { (v2.8) This property may now be changed at any time, again. However,
           if the change occurs while the client is linked to an active
           connection, all pending Modbus transactions originated by that
           client will be immediately discarded. }
  if FServerAddress <> Value then
  begin
    if Assigned(Connection) then
      Connection.DiscardPendingTransactions(Self);
    FServerAddress := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.WriteFileRecord(FileRecList: TModbusFileRecordList; UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.

  // begin of local block --------------------------------------------------------------------------

  function NeedValidFileRecordList: Cardinal;
  // Checks the validity of supplied Modbus file record list and returns the number of
  // bytes occupied by all sub-requests. Neither the query PDU nor the reply PDU built
  // upon this list is allowed to exceed the maximum Modbus PDU size.
  // Since the reply is an echo of the query, the single frame size needs to be examined.
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to FileRecList.Count - 1 do
      // [RefType | FileID | StartReg | RegCount | N * Data]
      Inc(Result, SizeOf(Byte) + (FileRecList[I].RegCount + 3) * SizeOf(Word));
      
    // Turn the ByteCount into PDU before comparison by including [Command | ByteCount] fields.
    if Result + 2 * SizeOf(Byte) > MaxFramePDUSize then
      ModLinkError(@RsInvalidFileRecList);
  end;

  // end of local block ----------------------------------------------------------------------------

var
  Transaction: TModbusTransaction;
  ByteCount: Cardinal;
  I, J: Integer;
begin
  CheckConnected;
  ByteCount := NeedValidFileRecordList;

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_WriteFileRecord);
          // The number of bytes occupied by all sub-requests.
          PutByte(ByteCount);
          // Individual sub-requests.
          for I := 0 to FileRecList.Count - 1 do
            with FileRecList[I] do
            begin
              // Reference type.
              PutByte(ReferenceType);
              // File identification.
              PutWordHiLo(FileID);
              // The first register to start the reading from.
              PutWordHiLo(StartReg);
              // The number of registers to be read.
              PutWordHiLo(RegCount);
              // Register values to be written.
              for J := 0 to RegCount - 1 do
                PutWordHiLo(RegValues[J]);
            end;
        end;
        
        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.WriteMultipleCoils(StartBit: Word; const BitValues: array of Boolean;
  UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
const
  // Calculation based on the query PDU:
  // [Command | StartBit | BitCount | ByteCount | N * Data]
  MaxBitCount = (MaxFramePDUSize - 2 * SizeOf(Byte) - 2 * SizeOf(Word)) * BitsPerByte;
var
  BitCount: Integer;
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  // Acquire the number of coils to be written.
  BitCount := Length(BitValues);

  // BitCount must fall in range from 1 through MaxBitCount.
  if (BitCount < 1) or (BitCount > MaxBitCount) then
    ModLinkError(@RsInvalidBitCountArgs, [MaxBitCount]);

  // Entire range of bit references should fit into 16-bits.
  if (StartBit + BitCount - 1 > High(Word)) then
    ModLinkError(@RsInvalidStartBitArgs, [StartBit]);

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_WriteMultipleCoils);
          // The first coil to start the writing to.
          PutWordHiLo(StartBit);
          // The number of coils to be written.
          PutWordHiLo(BitCount);
          // The total number of bytes to be written.
          PutByte(DetermineEncodedSize(BitCount));
          // Coil values to be written.
          EncodeBits(BitValues, QueryBuffer);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.WriteMultipleRegisters(StartReg: Word; const RegValues: array of Word;
  UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
const
  // Calculation based on the query PDU:
  // [Command | StartReg | RegCount | ByteCount | N * Data]
  MaxRegCount = (MaxFramePDUSize - 2 * SizeOf(Byte) - 2 * SizeOf(Word)) div SizeOf(Word);
var
  RegCount, I: Integer;
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  // Acquire the number of holding registers to be written.
  RegCount := Length(RegValues);

  // RegCount must fall in range from 1 through MaxRegCount.
  if (RegCount < 1) or (RegCount > MaxRegCount) then
    ModLinkError(@RsInvalidRegCountArgs, [MaxRegCount]);

  // Entire range of register references should fit into 16-bits.
  if (StartReg + RegCount - 1 > High(Word)) then
    ModLinkError(@RsInvalidStartRegArgs, [StartReg]);

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_WriteMultipleRegisters);
          // The first holding register to start the writing to.
          PutWordHiLo(StartReg);
          // The number of holding registers to be written.
          PutWordHiLo(RegCount);
          // The total number of bytes to be written.
          PutByte(RegCount * SizeOf(Word));
          // Register values to be written. Note that RegValues may be either static or dynamic array
          // (we are using an open array parameters) so be careful when determining the array bounds.
          for I := Low(RegValues) to High(RegValues) do
            PutWordHiLo(RegValues[I]);
        end;
        
        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.WriteSingleCoil(BitAddr: Word; BitValue: Boolean; UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
var
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_WriteSingleCoil);
          // The address of a coil to be preset.
          PutWordHiLo(BitAddr);
          // The requested preset value for a coil.
          if BitValue then
            PutWordHiLo(CoilOn)
          else
            PutWordHiLo(CoilOff);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusClient.WriteSingleRegister(RegAddr: Word; RegValue: Word; UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command.
var
  Transaction: TModbusTransaction;
begin
  CheckConnected;

  with FConnection do
  begin
    Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
    try
      with Transaction do
      begin
        // Acquire an unique ID for this transaction.
        Result := GetNextUniqueID;

        // Setup transaction info.
        ZeroMemory(@Info, SizeOf(Info));
        Info.ID := Result;
        Info.Address := FServerAddress;
        Info.UserData := UserData;

        // Modbus ADU header.
        EmitHeader(Self, QueryBuffer);

        with QueryBuffer do
        begin
          // Modbus command code.
          PutByte(Cmd_WriteSingleRegister);
          // The address of a holding register to be preset.
          PutWordHiLo(RegAddr);
          // The requested preset value for a holding register.
          PutWordHiLo(RegValue);
        end;

        // Modbus error check field.
        EmitErrorCheck(QueryBuffer);
      end;

      // Enqueue this transaction for asynchronous execution.
      EnqueueTransaction(Transaction, Self);
    except
      Transaction.Free;
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------
// TModbusServer class
//--------------------------------------------------------------------------------------------------

constructor TModbusServer.Create(AOwner: TComponent);
// Standard constructor.
begin
  inherited;
  FAddress := 1;
end;

//--------------------------------------------------------------------------------------------------

destructor TModbusServer.Destroy;
// Standard destructor.
begin
  // Unregister this server with the FConnection (if applicable).
  SetConnection(nil);
  inherited;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.BuildExceptionReply(Buffer: TModbusBuffer; Command: Byte;
  Exception: TServerException);
begin
  // Clear the buffer contents.
  Buffer.Size := 0;

  // Modbus ADU header.
  FConnection.EmitHeader(Self, Buffer);

  with Buffer do
  begin
    // Modbus command code with the most significant bit (i.e. the "exception" bit) set.
    PutByte(Command or $80);
    // Exception code.
    PutByte(Ord(Exception));
  end;

  // Modbus error check field.
  FConnection.EmitErrorCheck(Buffer);

  DoCommandHandlerException(Command, Exception, Ord(Exception));
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.CheckActiveTransaction;
begin
  if FActiveTransaction = nil then
  begin
    ModLinkError(@RsNoActiveTransaction);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.CheckConnected;
// Checks the Connection property to determine if we can process transactions.
// Upon a success it does nothing, but upon a failure it raises an exception.
begin
  if not ((FConnection <> nil) and FConnection.Active and
    (FConnection.ComponentState * [csLoading, csDesigning] = [])) then
  begin
    ModLinkError(@RsNoActiveConnection);
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoAcceptCommand(Command: Byte): Boolean;
begin
  Result := False;
  if Assigned(FOnAcceptCommand) then
    FOnAcceptCommand(Self, Command, Result);
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoCanReadCoil(BitAddr: Word): Boolean;
begin
  Result := False;
  if Assigned(FOnCanReadCoil) then
    FOnCanReadCoil(Self, BitAddr, Result);
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoCanReadDiscreteInput(BitAddr: Word): Boolean;
begin
  Result := False;
  if Assigned(FOnCanReadDiscreteInput) then
    FOnCanReadDiscreteInput(Self, BitAddr, Result);
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoCanReadHoldingRegister(RegAddr: Word): Boolean;
begin
  Result := False;
  if Assigned(FOnCanReadHoldingRegister) then
    FOnCanReadHoldingRegister(Self, RegAddr, Result);
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoCanReadInputRegister(RegAddr: Word): Boolean;
begin
  Result := False;
  if Assigned(FOnCanReadInputRegister) then
    FOnCanReadInputRegister(Self, RegAddr, Result);
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoCanWriteCoil(BitAddr: Word; BitValue: Boolean): TItemWriteStatus;
begin
  Result := iwsIllegalAddress;
  if Assigned(FOnCanWriteCoil) then
    FOnCanWriteCoil(Self, BitAddr, BitValue, Result);
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoCanWriteHoldingRegister(RegAddr: Word; RegValue: Word): TItemWriteStatus;
begin
  Result := iwsIllegalAddress;
  if Assigned(FOnCanWriteHoldingRegister) then
    FOnCanWriteHoldingRegister(Self, RegAddr, RegValue, Result);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.DoCommandHandlerException(Command: Byte; Exception: TServerException; ExceptionCode: Byte);
begin
  if Assigned(FOnCommandHandlerException) then
    FOnCommandHandlerException(Self, Command, Exception, ExceptionCode);
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoGetCoilValue(BitAddr: Word): Boolean;
begin
  Result := False;
  if Assigned(FOnGetCoilValue) then
    FOnGetCoilValue(Self, BitAddr, Result);
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoGetDiscreteInputValue(BitAddr: Word): Boolean;
begin
  Result := False;
  if Assigned(FOnGetDiscreteInputValue) then
    FOnGetDiscreteInputValue(Self, BitAddr, Result);
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoGetHoldingRegisterValue(RegAddr: Word): Word;
begin
  Result := 0;
  if Assigned(FOnGetHoldingRegisterValue) then
    FOnGetHoldingRegisterValue(Self, RegAddr, Result);
end;

//--------------------------------------------------------------------------------------------------

function TModbusServer.DoGetInputRegisterValue(RegAddr: Word): Word;
begin
  Result := 0;
  if Assigned(FOnGetInputRegisterValue) then
    FOnGetInputRegisterValue(Self, RegAddr, Result);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.DoSetCoilValue(BitAddr: Word; BitValue: Boolean);
begin
  if Assigned(FOnSetCoilValue) then
    FOnSetCoilValue(Self, BitAddr, BitValue);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.DoSetHoldingRegisterValue(RegAddr: Word; RegValue: Word);
begin
  if Assigned(FOnSetHoldingRegisterValue) then
    FOnSetHoldingRegisterValue(Self, RegAddr, RegValue);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.EmitExceptionReply(Exception: TServerException);
var
  Command: Byte;
begin
  CheckActiveTransaction;
  Assert(Assigned(FActiveTransaction));
  Assert(Assigned(Connection));
  Command := Connection.AcquireModbusCommand(FActiveTransaction.QueryBuffer);
  BuildExceptionReply(FActiveTransaction.ReplyBuffer, Command, Exception);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.ProcessReadDiscreteBits(Transaction: TModbusTransaction; Coils: Boolean);
const
  // Calculation based on the reply PDU:
  // [Command | ByteCount | N * Data]
  MaxBitCount = (MaxFramePDUSize - 2 * SizeOf(Byte)) * BitsPerByte;
var
  Command: Byte;
  StartBit, BitCount: Word;
  I: Integer;
  BitValues: TBitValues;
begin
  if Coils then
    Command := Cmd_ReadCoils
  else
    Command := Cmd_ReadDiscreteInputs;

  try
    with Transaction.QueryBuffer do
    begin
      // Skip ADU header and Command field. Acquire StartBit.
      Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
      StartBit := GetWordHiLo;

      // Skip StartBit field, and acquire BitCount.
      Seek(smNextWord);
      BitCount := GetWordHiLo;
    end;
  except
    on EModLinkError do
    begin
      BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
      Exit;
    end;
  else
    raise;
  end;

  // BitCount must fall in range from 1 through MaxBitCount.
  if (BitCount < 1) or (BitCount > MaxBitCount) then
  begin
    BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
    Exit;
  end;

  // Entire range of bit references should fit into 16-bits.
  if (StartBit + BitCount - 1 > High(Word)) then
  begin
    BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
    Exit;
  end;

  // Ask the application if each requested coil/discrete input can be read.
  if Coils then
  begin
    for I := 0 to BitCount - 1 do
      if not DoCanReadCoil(StartBit + I) then
      begin
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
        Exit;
      end;
  end
  else
  begin
    for I := 0 to BitCount - 1 do
      if not DoCanReadDiscreteInput(StartBit + I) then
      begin
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
        Exit;
      end;
  end;

  SetLength(BitValues, BitCount);
  try
    { (v2.7) Should the application for any reason fail to perform the requested
             action, Modbus exception reply with code 4 (SERVER_DEVICE_FAILURE)
             will be sent back to the remote client. }
    try
      // Ask the application for the requested discrete bit values.
      for I := 0 to BitCount - 1 do
        if Coils then
          BitValues[I] := DoGetCoilValue(StartBit + I)
        else
          BitValues[I] := DoGetDiscreteInputValue(StartBit + I);
    except
      if Transaction.Info.Address <> BroadcastAddress then
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seServerFailure);
      Exit;
    end;

    // Always build the reply - broadcasting not supported here.
    { (v2.7) Build normal reply only if there is no exception reply
             already present in the buffer due to an application override. }
    if Transaction.ReplyBuffer.Size = 0 then
    begin
      // Modbus ADU header.
      FConnection.EmitHeader(Self, Transaction.ReplyBuffer);

      with Transaction.ReplyBuffer do
      begin
        // Modbus command code.
        PutByte(Command);
        // The total number of bytes to be read.
        PutByte(DetermineEncodedSize(BitCount));
      end;

      // Coil values to be written.
      EncodeBits(BitValues, Transaction.ReplyBuffer);

      // Modbus error check field.
      FConnection.EmitErrorCheck(Transaction.ReplyBuffer);
    end;
  finally
    Finalize(BitValues);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.ProcessReadModbusRegisters(Transaction: TModbusTransaction; HoldingRegisters: Boolean);
const
  // Calculation based on the reply PDU:
  // [Command | ByteCount | N * Data]
  MaxRegCount = (MaxFramePDUSize - 2 * SizeOf(Byte)) div SizeOf(Word);
var
  Command: Byte;
  StartReg, RegCount: Word;
  I: Integer;
  RegValues: TRegValues;
begin
  if HoldingRegisters then
    Command := Cmd_ReadHoldingRegisters
  else
    Command := Cmd_ReadInputRegisters;

  try
    with Transaction.QueryBuffer do
    begin
      // Skip ADU header and Command field. Acquire StartReg.
      Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
      StartReg := GetWordHiLo;

       // Skip StartReg field, and acquire RegCount.
      Seek(smNextWord);
      RegCount := GetWordHiLo;
    end;
  except
    on EModLinkError do
    begin
      BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
      Exit;
    end;
  else
    raise;
  end;

  // RegCount must fall in range from 1 through MaxRegCount.
  if (RegCount < 1) or (RegCount > MaxRegCount) then
  begin
    BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
    Exit;
  end;

  // Entire range of register references should fit into 16-bits.
  if (StartReg + RegCount - 1 > High(Word)) then
  begin
    BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
    Exit;
  end;

  // Ask the application if each requested holding/input register can be read.
  if HoldingRegisters then
  begin
    for I := 0 to RegCount - 1 do
      if not DoCanReadHoldingRegister(StartReg + I) then
      begin
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
        Exit;
      end;
  end
  else
  begin
    for I := 0 to RegCount - 1 do
      if not DoCanReadInputRegister(StartReg + I) then
      begin
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
        Exit;
      end;
  end;

  SetLength(RegValues, RegCount);
  try
    { (v2.7) Should the application for any reason fail to perform the requested
             action, Modbus exception reply with code 4 (SERVER_DEVICE_FAILURE)
             will be sent back to the remote client. }
    try
      // Ask the application for the requested register values.
      for I := 0 to RegCount - 1 do
        if HoldingRegisters then
          RegValues[I] := DoGetHoldingRegisterValue(StartReg + I)
        else
          RegValues[I] := DoGetInputRegisterValue(StartReg + I);
    except
      if Transaction.Info.Address <> BroadcastAddress then
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seServerFailure);
      Exit;
    end;

    // Always build the reply - broadcasting not supported here.
    { (v2.7) Build normal reply only if there is no exception reply
             already present in the buffer due to an application override. }
    if Transaction.ReplyBuffer.Size = 0 then
    begin
      // Modbus ADU header.
      FConnection.EmitHeader(Self, Transaction.ReplyBuffer);

      with Transaction.ReplyBuffer do
      begin
        // Modbus command code.
        PutByte(Command);
        // ByteCount field divided by SizeOf(Word) must match RegCount field in the query.
        PutByte(Byte(RegCount * SizeOf(Word)));
        // Register values to be read.
        for I := 0 to RegCount - 1 do
          PutWordHiLo(RegValues[I]);
      end;

      // Modbus error check field.
      FConnection.EmitErrorCheck(Transaction.ReplyBuffer);
    end;
  finally
    Finalize(RegValues);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.ProcessTransaction(Transaction: TModbusTransaction);
const
  SupportedCommands = [
    Cmd_ReadCoils,
    Cmd_ReadDiscreteInputs,
    Cmd_ReadHoldingRegisters,
    Cmd_ReadInputRegisters,
    Cmd_WriteSingleCoil,
    Cmd_WriteSingleRegister,
    Cmd_WriteMultipleCoils,
    Cmd_WriteMultipleRegisters];
var
  Command: Byte;

  procedure CommandNotSupported;
  begin
    if Transaction.Info.Address <> BroadcastAddress then
      BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalCommand);
  end;

begin
  CheckConnected;

  { (v2.7) Allow the application to override the default command handling
           and force the exception reply to be emitted at any time while
           the active transaction is being processed. }
  FActiveTransaction := Transaction;
  try
    Command := FConnection.AcquireModbusCommand(Transaction.QueryBuffer);

    if (Command in SupportedCommands) and DoAcceptCommand(Command) then
    begin
      case Command of
        Cmd_ReadCoils:
          ProcessReadDiscreteBits(Transaction, True);
        Cmd_ReadDiscreteInputs:
          ProcessReadDiscreteBits(Transaction, False);
        Cmd_ReadHoldingRegisters:
          ProcessReadModbusRegisters(Transaction, True);
        Cmd_ReadInputRegisters:
          ProcessReadModbusRegisters(Transaction, False);
        Cmd_WriteSingleCoil:
          ProcessWriteSingleCoil(Transaction);
        Cmd_WriteSingleRegister:
          ProcessWriteSingleRegister(Transaction);
        Cmd_WriteMultipleCoils:
          ProcessWriteMultipleCoils(Transaction);
        Cmd_WriteMultipleRegisters:
          ProcessWriteMultipleRegisters(Transaction);
      else
        CommandNotSupported;
      end; // case
    end
    else
      CommandNotSupported;
  finally
    FActiveTransaction := nil;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.ProcessWriteMultipleCoils(Transaction: TModbusTransaction);
const
  // Calculation based on the query PDU:
  // [Command | StartBit | BitCount | ByteCount | N * Data]
  MaxBitCount = (MaxFramePDUSize - 2 * SizeOf(Byte) - 2 * SizeOf(Word)) * BitsPerByte;
var
  Command: Byte;
  StartBit, BitCount: Word;
  BitValues: TBitValues;
  I: Integer;
begin
  Command := Cmd_WriteMultipleCoils;

  try
    with Transaction.QueryBuffer do
    begin
      // Skip ADU header and Command field. Acquire StartBit.
      Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
      StartBit := GetWordHiLo;

      // Skip StartBit field, and acquire BitCount.
      Seek(smNextWord);
      BitCount := GetWordHiLo;
    end;
  except
    on EModLinkError do
    begin
      if Transaction.Info.Address <> BroadcastAddress then
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
      Exit;
    end;
  else
    raise;
  end;

  // BitCount must fall in range from 1 through MaxBitCount.
  if (BitCount < 1) or (BitCount > MaxBitCount) then
  begin
    if Transaction.Info.Address <> BroadcastAddress then
      BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
    Exit;
  end;

  // Entire range of bit references should fit into 16-bits.
  if (StartBit + BitCount - 1 > High(Word)) then
  begin
    if Transaction.Info.Address <> BroadcastAddress then
      BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
    Exit;
  end;

  SetLength(BitValues, BitCount);
  try
    try
      with Transaction.QueryBuffer do
      begin
          // Skip BitCount and ByteCount fields.
        Position := Position + SizeOf(Word) + SizeOf(Byte);

        // Decode the bits.
        DecodeBits(Transaction.QueryBuffer, BitValues);
      end;
    except
      on EModLinkError do
      begin
        if Transaction.Info.Address <> BroadcastAddress then
          BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
        Exit;
      end;
    else
      raise;
    end;

    // Ask the application if each requested coil can be written.
    for I := 0 to BitCount - 1 do
      case DoCanWriteCoil(StartBit + I, BitValues[I]) of
        iwsIllegalAddress:
          begin
            if Transaction.Info.Address <> BroadcastAddress then
              BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
            Exit;
          end;
        iwsIllegalValue:
          begin
            if Transaction.Info.Address <> BroadcastAddress then
              BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
            Exit;
          end;
      end;

    { (v2.7) Should the application for any reason fail to perform the requested
             action, Modbus exception reply with code 4 (SERVER_DEVICE_FAILURE)
             will be sent back to the remote client. }
    try
      // Let the application developer to see the requested coil values to be written.
      for I := 0 to BitCount - 1 do
        DoSetCoilValue(StartBit + I, BitValues[I]);
    except
      if Transaction.Info.Address <> BroadcastAddress then
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seServerFailure);
      Exit;
    end;

    // Build the reply only if we have received the unicast query.
    { (v2.7) Build normal reply only if there is no exception reply
             already present in the buffer due to an application override. }
    if (Transaction.Info.Address <> BroadcastAddress) and (Transaction.ReplyBuffer.Size = 0) then
    begin
      // Modbus ADU header.
      FConnection.EmitHeader(Self, Transaction.ReplyBuffer);

      with Transaction.ReplyBuffer do
      begin
        // Modbus command code.
        PutByte(Command);
        // The first coil to start the writing to.
        PutWordHiLo(StartBit);
        // The number of coils to be written.
        PutWordHiLo(BitCount);
      end;

      // Modbus error check field.
      FConnection.EmitErrorCheck(Transaction.ReplyBuffer);
    end;
  finally
    Finalize(BitValues);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.ProcessWriteMultipleRegisters(Transaction: TModbusTransaction);
const
  // Calculation based on the query PDU:
  // [Command | StartReg | RegCount | ByteCount | N * Data]
  MaxRegCount = (MaxFramePDUSize - 2 * SizeOf(Byte) - 2 * SizeOf(Word)) div SizeOf(Word);
var
  Command: Byte;
  StartReg, RegCount: Word;
  RegValues: TRegValues;
  I: Integer;
begin
  Command := Cmd_WriteMultipleRegisters;

  try
    with Transaction.QueryBuffer do
    begin
      // Skip ADU header and Command field. Acquire StartReg.
      Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
      StartReg := GetWordHiLo;

       // Skip StartReg field, and acquire RegCount.
      Seek(smNextWord);
      RegCount := GetWordHiLo;
    end;
  except
    on EModLinkError do
    begin
      if Transaction.Info.Address <> BroadcastAddress then
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
      Exit;
    end;
  else
    raise;
  end;

  // RegCount must fall in range from 1 through MaxRegCount.
  if (RegCount < 1) or (RegCount > MaxRegCount) then
  begin
    if Transaction.Info.Address <> BroadcastAddress then
      BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
    Exit;
  end;

  // Entire range of register references should fit into 16-bits.
  if (StartReg + RegCount - 1 > High(Word)) then
  begin
    if Transaction.Info.Address <> BroadcastAddress then
      BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
    Exit;
  end;

  SetLength(RegValues, RegCount);
  try
    try
      with Transaction.QueryBuffer do
      begin
        // Skip RegCount and ByteCount fields.
        Position := Position + SizeOf(Word) + SizeOf(Byte);

        // Fill the array with register values.
        for I := 0 to High(RegValues) do
        begin
          // Acquire the register value and move to the next one.
          RegValues[I] := GetWordHiLo;
          Seek(smNextWord);
        end;
      end;
    except
      on EModLinkError do
      begin
        if Transaction.Info.Address <> BroadcastAddress then
          BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
        Exit;
      end;
    else
      raise;
    end;

    // Ask the application if each requested holding register can be written.
    for I := 0 to RegCount - 1 do
      case DoCanWriteHoldingRegister(StartReg + I, RegValues[I]) of
        iwsIllegalAddress:
          begin
            if Transaction.Info.Address <> BroadcastAddress then
              BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
            Exit;
          end;
        iwsIllegalValue:
          begin
            if Transaction.Info.Address <> BroadcastAddress then
              BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
            Exit;
          end;
      end;

    { (v2.7) Should the application for any reason fail to perform the requested
             action, Modbus exception reply with code 4 (SERVER_DEVICE_FAILURE)
             will be sent back to the remote client. }
    try
      // Let the application developer to see the requested register values to be written.
      for I := 0 to RegCount - 1 do
        DoSetHoldingRegisterValue(StartReg + I, RegValues[I]);
    except
      if Transaction.Info.Address <> BroadcastAddress then
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seServerFailure);
      Exit;
    end;

    // Build the reply only if we have received the unicast query.
    { (v2.7) Build normal reply only if there is no exception reply
             already present in the buffer due to an application override. }
    if (Transaction.Info.Address <> BroadcastAddress) and (Transaction.ReplyBuffer.Size = 0) then
    begin
      // Modbus ADU header.
      FConnection.EmitHeader(Self, Transaction.ReplyBuffer);

      with Transaction.ReplyBuffer do
      begin
        // Modbus command code.
        PutByte(Command);
        // The first holding register to start the writing to.
        PutWordHiLo(StartReg);
        // The number of holding registers to be written.
        PutWordHiLo(RegCount);
      end;

      // Modbus error check field.
      FConnection.EmitErrorCheck(Transaction.ReplyBuffer);
    end;
  finally
    Finalize(RegValues);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.ProcessWriteSingleCoil(Transaction: TModbusTransaction);
var
  Command: Byte;
  BitAddr, BitValue: Word;
begin
  Command := Cmd_WriteSingleCoil;

  try
    with Transaction.QueryBuffer do
    begin
      // Skip ADU header and Command field. Acquire BitAddr.
      Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
      BitAddr := GetWordHiLo;

      // Skip BitAddr field, and acquire BitValue.
      Seek(smNextWord);
      BitValue := GetWordHiLo;
    end;
  except
    on EModLinkError do
    begin
      if Transaction.Info.Address <> BroadcastAddress then
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
      Exit;
    end;
  else
    raise;
  end;

  // Make sure that the requested coil value to be written is either CoilOff or CoilOn.
  if (BitValue <> CoilOff) and (BitValue <> CoilOn) then
  begin
    if Transaction.Info.Address <> BroadcastAddress then
      BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
    Exit;
  end;

  // Ask the application if the requested coil can be written.
  case DoCanWriteCoil(BitAddr, BitValue = CoilOn) of
    iwsIllegalAddress:
      begin
        if Transaction.Info.Address <> BroadcastAddress then
          BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
        Exit;
      end;
    iwsIllegalValue:
      begin
        if Transaction.Info.Address <> BroadcastAddress then
          BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
        Exit;
      end;
  end;

  { (v2.7) Should the application for any reason fail to perform the requested
           action, Modbus exception reply with code 4 (SERVER_DEVICE_FAILURE)
           will be sent back to the remote client. }
  try
    // Let the application developer to see the requested coil value to be written.
    DoSetCoilValue(BitAddr, BitValue = CoilOn);
  except
    if Transaction.Info.Address <> BroadcastAddress then
      BuildExceptionReply(Transaction.ReplyBuffer, Command, seServerFailure);
    Exit;
  end;

  // Build the reply only if we have received the unicast query.
  { (v2.7) Build normal reply only if there is no exception reply
           already present in the buffer due to an application override. }
  if (Transaction.Info.Address <> BroadcastAddress) and (Transaction.ReplyBuffer.Size = 0) then
  begin
    // Modbus ADU header.
    FConnection.EmitHeader(Self, Transaction.ReplyBuffer);

    with Transaction.ReplyBuffer do
    begin
      // Modbus command code.
      PutByte(Command);
      // The address of a coil to be preset.
      PutWordHiLo(BitAddr);
      // The requested preset value for a coil.
      PutWordHiLo(BitValue);
    end;

    // Modbus error check field.
    FConnection.EmitErrorCheck(Transaction.ReplyBuffer);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.ProcessWriteSingleRegister(Transaction: TModbusTransaction);
var
  Command: Byte;
  RegAddr, RegValue: Word;
begin
  Command := Cmd_WriteSingleRegister;

  try
    with Transaction.QueryBuffer do
    begin
      // Skip ADU header and Command field. Acquire RegAddr.
      Position := FConnection.DetermineHeaderSize + SizeOf(Byte);
      RegAddr := GetWordHiLo;

      // Skip RegAddr field, and acquire RegValue.
      Seek(smNextWord);
      RegValue := GetWordHiLo;
    end;
  except
    on EModLinkError do
    begin
      if Transaction.Info.Address <> BroadcastAddress then
        BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
      Exit;
    end;
  else
    raise;
  end;

  // Ask the application if the requested holding register can be written.
  case DoCanWriteHoldingRegister(RegAddr, RegValue) of
    iwsIllegalAddress:
      begin
        if Transaction.Info.Address <> BroadcastAddress then
          BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataAddress);
        Exit;
      end;
    iwsIllegalValue:
      begin
        if Transaction.Info.Address <> BroadcastAddress then
          BuildExceptionReply(Transaction.ReplyBuffer, Command, seIllegalDataValue);
        Exit;
      end;
  end;

  { (v2.7) Should the application for any reason fail to perform the requested
           action, Modbus exception reply with code 4 (SERVER_DEVICE_FAILURE)
           will be sent back to the remote client. }
  try
    // Let the application developer to see the requested register value to be written.
    DoSetHoldingRegisterValue(RegAddr, RegValue);
  except
    if Transaction.Info.Address <> BroadcastAddress then
      BuildExceptionReply(Transaction.ReplyBuffer, Command, seServerFailure);
    Exit;
  end;

  // Build the reply only if we have received the unicast query.
  { (v2.7) Build normal reply only if there is no exception reply
           already present in the buffer due to an application override. }
  if (Transaction.Info.Address <> BroadcastAddress) and (Transaction.ReplyBuffer.Size = 0) then
  begin
    // Modbus ADU header.
    FConnection.EmitHeader(Self, Transaction.ReplyBuffer);

    with Transaction.ReplyBuffer do
    begin
      // Modbus command code.
      PutByte(Command);
      // The address of a holding register to be preset.
      PutWordHiLo(RegAddr);
      // The requested preset value for a holding register.
      PutWordHiLo(RegValue);
    end;

    // Modbus error check field.
    FConnection.EmitErrorCheck(Transaction.ReplyBuffer);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.SetAddress(Value: Byte);
// Property setter for Address property.
begin
  // The server address must fall in the range of 1 through 247.
  // Zero address is reserved for the broadcast address which all servers recognize.
  if FAddress <> Value then
  begin
    if (Value < 1) or (Value > 247) then
      ModLinkError(@RsOutOfRangeArgs, [1, 247]);
    FAddress := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusServer.SetConnection(Value: TModbusConnection);
// Property setter for Connection property.
begin
  if FConnection <> Value then
  begin
    if FConnection <> nil then
    begin
      FConnection.UnregisterServer(Self);
      {$IFDEF COMPILER_5_UP}
      FConnection.RemoveFreeNotification(Self);
      {$ENDIF COMPILER_5_UP}
    end;

    FConnection := Value;

    if FConnection <> nil then
    begin
      FConnection.RegisterServer(Self);
      FConnection.FreeNotification(Self);
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------
// TTransactionThread class
//--------------------------------------------------------------------------------------------------

type

  TTransactionThread = class(TThread)
  private
    FConnection: TModbusConnection;
    FEvent: THandle;
    FException: Exception;
    FExceptionAddress: Pointer;
    FInputBuffer, FOutputBuffer: PAnsiChar;
    FInterimBufferSize: Cardinal;
    FRemoteTransaction: TModbusTransaction;
    FTransactionQueue: TThreadList;
    procedure ClientExecute;
    procedure DoHandleException;
    procedure DoProcessTransaction;
    procedure InitFrameDataEvent(const Buffer; Size: Integer; Sending: Boolean);
    procedure MonitorExecute;
    procedure ServerExecute;
  protected
    procedure Execute; override;
    procedure HandleException; virtual;
  public
    constructor Create(AConnection: TModbusConnection);
    destructor Destroy; override;
    procedure DiscardPendingTransactions(Client: TModbusClient = nil);
    procedure Enqueue(Transaction: TModbusTransaction);
  end;

//--------------------------------------------------------------------------------------------------

const
  UM_TRANSACTIONCOMPLETE  = WM_USER + 1;
  UM_FRAMEDATA            = WM_USER + 2;
  UM_INSPECTCAPTUREDFRAME = WM_USER + 3;

type
  TInspectCapturedFrameEventArgs = class(TObject)
  public
    CommandCode: Byte;
    CommandData: TFrameData;
    ServerAddress: Byte;
  end;

//--------------------------------------------------------------------------------------------------

constructor TTransactionThread.Create(AConnection: TModbusConnection);
// Standard constructor.
begin
  FConnection := AConnection;

{$IFDEF COMPILER_6_UP}
  // Delphi/C++ Builder 6 and above: Pass False to inherited constructor to create the background
  // thread running. Internally, the thread is created in a suspended state, but it gets resumed
  // automatically from within the AfterConstruction method to ensure that this constructor finished
  // its execution before the Execute method starts running.
  inherited Create(False);
{$ELSE}
  // Delphi/C++ Builder 5 and below: Pass True to inherited constructor to create the background
  // thread in a suspended state and resume it manually at the end of this method. This is required
  // due to a bug that could cause the Execute method to begin its execution while this constructor
  // is still running. This bug was fixed in Delphi/C++ Builder 6.
  inherited Create(True);
{$ENDIF COMPILER_6_UP}

  // Create the thread-safe transaction queue.
  FTransactionQueue := TThreadList.Create;
{$IFDEF COMPILER_5_UP}
  FTransactionQueue.Duplicates := dupAccept;
{$ENDIF COMPILER_5_UP}

  // Create event objects.
  FEvent := CreateEvent(nil, False, False, nil); // auto-reset, non-signaled
  CheckEventCreated(FEvent);

  // Create I/O buffers.
  FInterimBufferSize := FConnection.DetermineInterimBufferSize;
  GetMem(FInputBuffer, FInterimBufferSize);
  GetMem(FOutputBuffer, FInterimBufferSize);

  Priority := FConnection.ThreadPriority;

{$IFNDEF COMPILER_6_UP}
  // Delphi/C++ Builder 5 and below: Resume the background thread.
  Resume;
{$ENDIF ~COMPILER_6_UP}
end;

//--------------------------------------------------------------------------------------------------

destructor TTransactionThread.Destroy;
// Standard destructor.
begin
  // Stop the thread.
  Terminate;
  if FConnection.ConnectionMode = cmClient then
    SetEvent(FEvent)
  else
    SetEvent(FConnection.FBreakEvent);
  Sleep(0);
  inherited;

  // Release I/O buffers.
  FreeMem(FOutputBuffer, FInterimBufferSize);
  FreeMem(FInputBuffer, FInterimBufferSize);

  // Release event objects.
  SafeDestroyEvent(FEvent);

  // Release the transaction list.
  if FTransactionQueue <> nil then DiscardPendingTransactions;
  FTransactionQueue.Free;
end;

//--------------------------------------------------------------------------------------------------

procedure TTransactionThread.ClientExecute;

  // begin of local block --------------------------------------------------------------------------

  function FetchNextTransaction(out Transaction: TModbusTransaction): Boolean;
  // Attempts to remove the oldest (the first) item - the transaction object -
  // from the transaction list without releasing it, fills the function
  // parameter with a reference to that object and returns True to indicate
  // success. Upon a failure (that is, if the transaction list is empty) returns
  // False and function parameter is set to nil.
  begin
    // Lock the list.
    with FTransactionQueue.LockList do
      try
        // Is there at least one transaction in the list ?
        Result := Count > 0;
        if Result then
        begin
          // If yes, then extract it.
          Transaction := TModbusTransaction(First);
          Delete(0);
        end
        else
          // No, the list is empty. Clear the reference to indicate failure.
          Transaction := nil;
      finally
        // Unlock the list.
        FTransactionQueue.UnlockList;
      end;
  end;

  // end of local block ----------------------------------------------------------------------------

var
  Transaction: TModbusTransaction;
  QuerySize, ReplySize: Cardinal;
begin
  // Clear the serial device's both internal RX and TX buffers.
  FConnection.ClearDeviceBuffers(True, True);
  FConnection.WaitForData(FConnection.RealSilentInterval);

  while not Terminated do
  begin
    // Wait for the new transaction(s) to arrive.
    WaitForSingleObject(FEvent, INFINITE);

    // Fetch the transactions from the queue and execute them one by one.
    // Exit the loop if we were asked to terminate or when the queue become empty.
    while not Terminated and FetchNextTransaction(Transaction) do
      with FConnection, Transaction, Transaction.Info do
        try
          // Reset the Retries counter.
          Retries := 0;

          // Encode the query into the interim output buffer.
          QuerySize := EncodeFrame(QueryBuffer, FOutputBuffer^, FInterimBufferSize);

          repeat
            // Reset the Reply field and increment the Retries counter.
            Reply := srNone;
            Inc(Retries);

            // Let the application developer to see the final, encoded frame (query)
            // right before it is sent.
            InitFrameDataEvent(FOutputBuffer^, QuerySize, True);

            // Clear the serial device's both internal RX and TX buffers.
            ClearDeviceBuffers(True, True);

            // Send the frame over the network to the server(s).
            if SendFrame(FOutputBuffer^, QuerySize, SendTimeout) then
            begin
              // Are we in the broadcast mode?
              if (Address = BroadcastAddress) and not Custom then
              begin
                // Insert a time delay in order to let all servers process the query.
                Delay(TurnaroundDelay);
                // No reply is expected; behave as if normal reply was received.
                Reply := srNormalReply;
              end
              else // We are in the unicast mode.
              repeat
                // Wait for the reply from the server to arrive.
                ReplySize := ReceiveFrame(FInputBuffer^, FInterimBufferSize, ReceiveTimeout);

                // Do we need to take care of query echoed back to the wire?
                if EchoQueryBeforeReply and IsEcho(FOutputBuffer^, QuerySize,
                  FInputBuffer^, ReplySize) then
                begin
                  if QuerySize = ReplySize then
                  begin
                    // Echo only. Wait for the reply from the server to arrive.
                    ReplySize := ReceiveFrame(FInputBuffer^, FInterimBufferSize, ReceiveTimeout);
                  end
                  else
                  begin
                    // Echo followed by actual reply
                    Assert(ReplySize > QuerySize, 'ClientExecute: ReplySize > QuerySize');

                    // Adjust the reply size and remove the query echo from the buffer.
                    Dec(ReplySize, QuerySize);
                    System.Move(PAnsiChar(FInputBuffer + QuerySize)^, FInputBuffer^, ReplySize);
                  end;
                end;

                // Let the application developer to see the raw frame (reply)
                // just right after it has been received (no echo).
                InitFrameDataEvent(FInputBuffer^, ReplySize, False);

                // Examine the reply.
                if ReplySize > 0 then
                  if DecodeFrame(FInputBuffer^, ReplyBuffer, ReplySize) then
                    if IsExpectedReply(QueryBuffer, ReplyBuffer, Promiscuous) then
                      if CommandsMatch(QueryBuffer, ReplyBuffer) then
                        if IsExceptionReply(ReplyBuffer) then
                        begin
                          Reply := srExceptionReply;
                          AcquireServerException(ReplyBuffer, Info.Exception, Info.ExceptionCode);
                        end
                        else
                          Reply := srNormalReply
                      else
                        Reply := srUnmatchedReply
                    else
                      Reply := srUnexpectedReply
                  else
                    Reply := srInvalidFrame
                else
                  Reply := srNone;

              // If a reply from unexpected server was received,
              // wait for another (hopefuly correct) one.
              until Reply <> srUnexpectedReply;
            end;

            // Insert an additional time delay right before this transaction gets reexecuted
            // (retried) or a new transaction gets refetched from the queue.
            Delay(RefetchDelay);

          // A transaction is considered to be completed if at least one of the
          // following conditions is met:
          // 1. Normal, exception or unmatched reply has been received.
          // 2. Query has already been transmitted for MaxRetries times.
          until (Reply > srUnexpectedReply) or (Retries >= MaxRetries);

          // If we are in the broadcast mode, release the transaction object now. Otherwise,
          // notify the connection that there is another completed transaction available.
          if (Address = BroadcastAddress) and not Custom then
            Transaction.Free
          else
            Win32Check(PostMessage(FInternalWindow, UM_TRANSACTIONCOMPLETE, 0, LPARAM(Transaction)));
        except
          // In case of an exception release the current transaction object.
          // Handle the exception at this point so that thread can continue to run.
          Transaction.Free;
          HandleException;
        end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TTransactionThread.DiscardPendingTransactions(Client: TModbusClient = nil);
var
  Transaction: TModbusTransaction;
  I: Integer;
begin
  with FTransactionQueue.LockList do
  begin
    try
      if Client = nil then
        // Extract and release all transactions one by one.
        while Count > 0 do
        begin
          Transaction := TModbusTransaction(First);
          Delete(0);
          Transaction.Free;
        end
      else
        // Loop backwards when deleting selected items from the queue.
        for I := Count - 1 downto 0 do
        begin
          { (v2.8) This function now checks for the matching client reference
                   instead of the server address. }
          Transaction := TModbusTransaction(Items[I]);
          if Transaction.Originator = Client then
          begin
            Delete(I);
            Transaction.Free;
          end;
        end;
    finally
      FTransactionQueue.UnlockList;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TTransactionThread.DoHandleException;
// HandleException support method.
begin
  // Cancel the mouse capture.
  if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  // Now actually show the exception.
  if FException is Exception then
  begin
    {$IFDEF COMPILER_6_UP}
    if Assigned(ApplicationShowException) then
      ApplicationShowException(FException);
    {$ELSE}
    Application.ShowException(FException);
    {$ENDIF COMPILER_6_UP}
  end
  else
    SysUtils.ShowException(FException, FExceptionAddress);
end;

//--------------------------------------------------------------------------------------------------

procedure TTransactionThread.DoProcessTransaction;
begin
  FConnection.ProcessRemoteTransaction(FRemoteTransaction);
end;

//--------------------------------------------------------------------------------------------------

procedure TTransactionThread.Enqueue(Transaction: TModbusTransaction);
// Adds a reference to given transaction object to the transaction list and
// notifies the thread that it has something to do by turning the state of the
// internal event object to signaled. Transaction reference is assumed to be
// valid since all necessary tests have already been performed by connection's
// EnqueueTransaction method.
begin
  FTransactionQueue.Add(Pointer(Transaction));
  SetEvent(FEvent);
end;

//--------------------------------------------------------------------------------------------------

procedure TTransactionThread.Execute;
begin
  try
    case FConnection.ConnectionMode of
      cmClient:
        ClientExecute;
      cmServer:
        ServerExecute;
      cmMonitor:
        MonitorExecute;
    else
      InternalError;
    end;
  except
    // No exception should go unhandled beyond this method.
    // Otherwise, one may get nasty AVs when running outside the Delphi IDE.
    HandleException;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TTransactionThread.HandleException;
// Handles exceptions raised from within the Execute method of the transaction
// management thread in a safe way.
begin
  FException := Exception(ExceptObject);
  FExceptionAddress := ExceptAddr;
  try
    // Ignore all silent exceptions.
    if not (FException is EAbort) then
      Synchronize(DoHandleException);
  finally
    FException := nil;
    FExceptionAddress := nil;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TTransactionThread.InitFrameDataEvent(const Buffer; Size: Integer; Sending: Boolean);
var
  FrameData: PFrameData;
begin
  { v2.7; revisited in v2.10 }
  if (Size > 0) and ((Sending and Assigned(FConnection.FOnFrameSend)) or
    (not Sending and Assigned(FConnection.FOnFrameReceive))) then
  begin
    FrameData := CreateFrameBuffer(Size);
    try
      Move(Buffer, FrameData^[0], Size);
      Win32Check(PostMessage(FConnection.FInternalWindow, UM_FRAMEDATA, Ord(Sending), LPARAM(FrameData)));
    except
      DestroyFrameBuffer(FrameData);
      raise;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TTransactionThread.MonitorExecute;

  procedure InspectCapturedFrame(
    AServerAddress: Byte;
    ACommandCode: Byte;
    const ACommandData: TFrameData);
  var
    LEventArgs: TInspectCapturedFrameEventArgs;
  begin
    LEventArgs := TInspectCapturedFrameEventArgs.Create;
    try
      LEventArgs.ServerAddress := AServerAddress;
      LEventArgs.CommandCode := ACommandCode;
      LEventArgs.CommandData := ACommandData;
      Win32Check(PostMessage(FConnection.FInternalWindow, UM_INSPECTCAPTUREDFRAME, 0, LPARAM(LEventArgs)));
    except
      LEventArgs.Free;
      raise;
    end;
  end;

var
  LFrameBuffer: TModbusBuffer;
  LFrameSize, LCommandDataSize: Integer;
  LServerAddress, LCommandCode: Byte;
  LCommandData: TFrameData;
begin
  // Clear the serial device's both internal RX and TX buffers.
  FConnection.ClearDeviceBuffers(True, True);
  FConnection.WaitForData(FConnection.RealSilentInterval);

  LFrameBuffer := TModbusBuffer.Create(FConnection.DetermineMaximumFrameSize);
  try
    while not Terminated do
    begin
      try
        // Wait for the data frame to arrive.
        LFrameSize := FConnection.ReceiveFrame(FInputBuffer^, FInterimBufferSize, INFINITE);

        // Let the application developer to see the raw frame (query)
        // just right after it has been received.
        InitFrameDataEvent(FInputBuffer^, LFrameSize, False);

        // Examine the query.
        if FConnection.DecodeFrame(FInputBuffer^, LFrameBuffer, LFrameSize) then
        begin
          LFrameBuffer.Seek(smBufStart);

          LServerAddress := LFrameBuffer.GetByte;
          LFrameBuffer.Seek(smNextByte);

          LCommandCode := LFrameBuffer.GetByte;
          LFrameBuffer.Seek(smNextByte);

          LCommandDataSize := LFrameBuffer.Size - LFrameBuffer.Position - FConnection.DetermineErrorCheckSize;
          SetLength(LCommandData, LCommandDataSize);

          if LCommandDataSize > 0 then
            LFrameBuffer.GetBlock(LCommandData[0], LCommandDataSize);

          InspectCapturedFrame(LServerAddress, LCommandCode, LCommandData);

          // Clear the serial device's both internal RX and TX buffers.
          FConnection.ClearDeviceBuffers(True, True);
        end
        else
          Synchronize(FConnection.DoInvalidFrameDiscard);
      except
        // Handle the exception at this point so that thread can continue to run.
        HandleException;
      end;
    end;
  finally
    LFrameBuffer.Free;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TTransactionThread.ServerExecute;
var
  Transaction: TModbusTransaction;
  QuerySize, ReplySize: Cardinal;
begin
  // Clear the serial device's both internal RX and TX buffers.
  FConnection.ClearDeviceBuffers(True, True);
  FConnection.WaitForData(FConnection.RealSilentInterval);

  Transaction := TModbusTransaction.Create(FConnection.DetermineMaximumFrameSize);
  try
    while not Terminated do
      with FConnection, Transaction do
        try
          // Wait for the query to arrive from the client.
          QuerySize := ReceiveFrame(FInputBuffer^, FInterimBufferSize, INFINITE);

          // Let the application developer to see the raw frame (query)
          // just right after it has been received.
          InitFrameDataEvent(FInputBuffer^, QuerySize, False);

          // Examine the query.
          if DecodeFrame(FInputBuffer^, QueryBuffer, QuerySize) then
          begin
            Info.Address := AcquireServerAddress(QueryBuffer);
            ReplyBuffer.Size := 0;
            FRemoteTransaction := Transaction;
            Synchronize(DoProcessTransaction);

            // Send reply back to the client.
            if Info.Address <> BroadcastAddress then
            begin
              // Encode the reply into the interim output buffer.
              ReplySize := EncodeFrame(ReplyBuffer, FOutputBuffer^, FInterimBufferSize);

              // Let the application developer to see the final, encoded frame (reply)
              // right before it is sent.
              InitFrameDataEvent(FOutputBuffer^, ReplySize, True);

              // Clear the serial device's both internal RX and TX buffers.
              ClearDeviceBuffers(True, True);

              // Send the frame over the network back to the client.
              SendFrame(FOutputBuffer^, ReplySize, SendTimeout);
            end;
          end
          else
            Synchronize(DoInvalidFrameDiscard);
        except
          // Handle the exception at this point so that thread can continue to run.
          HandleException;
        end;
  finally
    Transaction.Free;
  end;
end;

//--------------------------------------------------------------------------------------------------
// TModbusConnection class
//--------------------------------------------------------------------------------------------------

{$IFDEF MODLINK_SHAREWARE_VERSION}
var
  ShowReminder: Boolean = True;
{$ENDIF MODLINK_SHAREWARE_VERSION}

const
  // Frame delimiters used in Modbus/ASCII.
  Colon = AnsiChar(#$3A);
  CarriageReturn = AnsiChar(#$0D);
  LineFeed = AnsiChar(#$0A);

  // Default value for Port property.
  DefaultPort = 'COM1';

  // Used to work around the delayed serial driver notification issue in Windows OS family.
  MinimumRealSilentInterval = 16; // milliseconds

//--------------------------------------------------------------------------------------------------

resourcestring
  RsCreateDeviceHandleFailed = 'Could not open serial port';
  RsInitBuffersFailed = 'Failed to initialize serial I/O buffers';
  RsInitTimeoutsFailed = 'Failed to initialize communication timeouts';
  RsInitEventMaskFailed = 'Failed to initialize serial event mask';
  RsUpdateDcbFailed = 'Failed to update device control block';

  RsConnectionNotClosed = 'Connection must NOT be active for the requested action to be performed';
  RsConnectionNotOpened = 'Connection MUST be active for the requested action to be performed';
  RsEncodeFrameFailed = 'Failed to encode frame';
  RsDecodeFrameFailed = 'Failed to decode frame';
  RsInvalidFlowControl = 'Flow control is not valid for the requested action to be performed';

  {$IFDEF MODLINK_SHAREWARE_VERSION}
  RsSharewareReminderFmt = 'This application uses a shareware, unregistered ' +
    'edition of ModLink VCL component suite!'#13#10#13#10'ModLink version %s' +
    #13#10'Copyright © 2002 - 2013 Ing. Ivo Bauer' +
    #13#10'All Rights Reserved.' +
    #13#10#13#10'Web site: http://www.ozm.cz/ivobauer/modlink/' +
    #13#10'E-mail: bauer@ozm.cz' +
    #13#10#13#10'For a detailed information regarding the distribution and use ' +
    'of this software product, please refer to the License Agreement ' +
    'embedded in the accompanying online documentation (ModLink.chm)';
  {$ENDIF MODLINK_SHAREWARE_VERSION}

//--------------------------------------------------------------------------------------------------

constructor TModbusConnection.Create(AOwner: TComponent);
// Standard constructor.
begin
  inherited;

  // Create the lock.
  FLock := TMultiReadExclusiveWriteSynchronizer.Create;

  // Create the client/server lists.
  FClientList := TList.Create;
  FServerList := TList.Create;

  // Allocate the hidden window.
  FInternalWindow := {$IFDEF COMPILER_6_UP} Classes {$ELSE} Forms {$ENDIF COMPILER_6_UP} .AllocateHwnd(InternalWndProc);

  // Create event object for breaking purposes when in cmServer mode.
  FBreakEvent := CreateEvent(nil, False, False, nil); // auto-reset, non-signaled
  CheckEventCreated(FBreakEvent);

  // Create event object for use with overlapped I/O operations.
  FOverlappedEvent := CreateEvent(nil, True, False, nil); // manual-reset, nonsignalled
  CheckEventCreated(FOverlappedEvent);

  // Create event object for use with overlapped WaitCommEvent operations.
  FOverlappedWaitEvent := CreateEvent(nil, True, False, nil); // manual-reset, nonsignalled
  CheckEventCreated(FOverlappedWaitEvent);

  FBaudRate := br19200;
  FConnectionMode := cmClient;
  FCustomBaudRate := 19200;
  FDataBits := db8;
  FDeviceHandle := INVALID_HANDLE_VALUE;
  FDTREnabled := True;
  FFlowControl := fcNone;
  FInputBufferSize := 1024;
  FMaxRetries := 1;
  FOutputBufferSize := 1024;
  FParity := psEven;
  FPort := DefaultPort;
  FReceiveTimeout := 1000;
  FRTSEnabled := True;
  FSilentInterval := 4;
  FStopBits := sb1;
  FThreadPriority := tpNormal;
  FTransmissionMode := tmRTU;
  FSendTimeout := 1000;
  FTurnaroundDelay := 100;

  {$IFDEF MODLINK_SHAREWARE_VERSION}
  // Show the shareware reminder.
  if ShowReminder and not (csDesigning in ComponentState) then
  begin
    ShowReminder := False;
    MessageDlg(Format(RsSharewareReminderFmt, [ModLinkVersion]), mtWarning, [mbOK], 0);
  end;
  {$ENDIF MODLINK_SHAREWARE_VERSION}
end;

//--------------------------------------------------------------------------------------------------

destructor TModbusConnection.Destroy;
// Standard destructor.
begin
  // Drop the connection in order to release the transaction management thread
  // and dispatch all pending UM_TRANSACTIONCOMPLETE messages.
  Close;

  // Release event objects.
  SafeDestroyEvent(FOverlappedWaitEvent);
  SafeDestroyEvent(FOverlappedEvent);
  SafeDestroyEvent(FBreakEvent);

  // Deallocate the hidden window.
  {$IFDEF COMPILER_6_UP} Classes {$ELSE} Forms {$ENDIF COMPILER_6_UP} .DeallocateHwnd(FInternalWindow);

  // Destroy the client/server lists.
  FClientList.Free;
  FServerList.Free;

  // Destroy the lock.
  FLock.Free;

  inherited;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.AcquireModbusCommand(Buffer: TModbusBuffer): Byte;
begin
  with Buffer do
  begin
    // Skip the Modbus ADU header.
    Position := DetermineHeaderSize;
    Result := GetByte;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.AcquireServerAddress(Buffer: TModbusBuffer): Byte;
begin
  with Buffer do
  begin
    Seek(smBufStart);
    Result := GetByte;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.AcquireServerException(Buffer: TModbusBuffer;
  var Exception: TServerException; var ExceptionCode: Byte);
// Extracts the exception code from the reply returned by the server and also converts it into
// a meaningful value. Unknown (custom) exception codes are mapped to seUnknown.

  // begin of local block --------------------------------------------------------------------------

  function ExceptionCodeToServerException(Code: Byte): TServerException;
  begin
    if Code > Byte(High(TServerException)) then Code := Ord(seUnknown);
    Result := TServerException(Code);
  end;

  // end of local block ----------------------------------------------------------------------------
  
begin
  with Buffer do
  begin
    // Skip the Modbus ADU header and the Command field. Acquire exception code.
    Position := DetermineHeaderSize + SizeOf(Byte);
    ExceptionCode := GetByte;
    // Turn the exception code into a meaningful value.
    Exception := ExceptionCodeToServerException(ExceptionCode);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.CancelIO;
{ Cancels any pending overlapped operation, particularly WaitCommEvent().
  Takes care of Win95 platform where CancelIO() API is not available. }

  {----------------------------------------------------------------------------}

  function IsWin98orLater: Boolean;
  begin
    case Win32Platform of
      VER_PLATFORM_WIN32_WINDOWS:
        Result := (Win32MajorVersion > 4) or
          ((Win32MajorVersion = 4) and (Win32MinorVersion >= 10));
      VER_PLATFORM_WIN32_NT:
        Result := True;
    else
      Result := False;
    end;
  end;

  {----------------------------------------------------------------------------}

begin
  if IsWin98orLater then
    Windows.CancelIO(FDeviceHandle)
  else
  begin
    SetCommMask(FDeviceHandle, 0);
    SetCommMask(FDeviceHandle, EV_RXCHAR);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.ChangeDTR(AValue: Boolean);
const
  CFunctions: array [Boolean] of Cardinal = (
    CLRDTR,
    SETDTR
  );
begin
  CheckOpened;
  CheckFlowControl([fcNone, fcRtsToggle, fcRtsCts]);
  EscapeCommFunction(FDeviceHandle, CFunctions[AValue]);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.ChangeRTS(AValue: Boolean);
const
  CFunctions: array [Boolean] of Cardinal = (
    CLRRTS,
    SETRTS
  );
begin
  CheckOpened;
  CheckFlowControl([fcNone, fcDtrDsr]);
  EscapeCommFunction(FDeviceHandle, CFunctions[AValue]);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.CheckClosed;
// Checks if the connection is closed (inactive). Upon a success it does nothing,
// but upon a failure it raises an exception.
begin
  if FActive and (ComponentState * [csLoading, csDesigning] = []) then
    ModLinkError(@RsConnectionNotClosed);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.CheckFlowControl(AFlowControls: TFlowControls);
begin
  if [FlowControl] * AFlowControls = [] then
    ModLinkError(@RsInvalidFlowControl);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.CheckOpened;
// Checks if the connection is opened (active). Upon a success it does nothing,
// but upon a failure it raises an exception.
begin
  if not (FActive and (ComponentState * [csLoading, csDesigning] = [])) then
  begin
    ModLinkError(@RsConnectionNotOpened);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.ClearDeviceBuffers(RX, TX: Boolean);
var
  Flags: Cardinal;
begin
  if RX then
    Flags := PURGE_RXABORT or PURGE_RXCLEAR
  else
    Flags := 0;

  if TX then
    Flags := Flags or PURGE_TXABORT or PURGE_TXCLEAR;

  if Flags <> 0 then
    PurgeComm(FDeviceHandle, Flags);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.Close;
begin
  SetActive(False);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.CommandsMatch(QueryBuffer, ReplyBuffer: TModbusBuffer): Boolean;
var
  Command1, Command2: Byte;
begin
  { The most significant bit (i.e. the "exception" bit) has to be cleared from
    the reply's Command field before the comparison. }
  Command1 := AcquireModbusCommand(QueryBuffer);
  Command2 := AcquireModbusCommand(ReplyBuffer) and $7F;
  Result := Command1 = Command2;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.CountPendingTransactions(Client: TModbusClient = nil): Integer;
// If the Client parameter is nil, this method returns the number of all pending transactions
// in the internally maintained transaction queue (no filtering occurs). If the Client parameter
// is not nil, this method returns the number of those pending transactions in the internally
// maintained transaction queue who has been originated by given Client (filtering occurs).
var
  I: Integer;
begin
  Result := 0;
  if FActive and (ComponentState * [csLoading, csDesigning] = []) then
    with TTransactionThread(FThread).FTransactionQueue.LockList do
      try
        if Client = nil then
          Result := Count
        else
          for I := 0 to Count - 1 do
            if TModbusTransaction(Items[I]).Info.Address = Client.ServerAddress then
              Inc(Result);
      finally
        TTransactionThread(FThread).FTransactionQueue.UnlockList;
      end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.DecodeFrame(const Source; Dest: TModbusBuffer; SourceSize: Integer): Boolean;

  // begin of local block --------------------------------------------------------------------------

  function DetermineMinimumRawFrameSize: Integer;
  begin
    Result := 0;
    case FConnectionMode of
      cmClient:
        Result := DetermineMinimumReplySize;
      cmServer:
        Result := DetermineMinimumQuerySize;
      cmMonitor:
        Result := Min(DetermineMinimumReplySize, DetermineMinimumQuerySize);
    else
      InternalError;
    end;

    if FTransmissionMode = tmASCII then
      Inc(Result, 3); // Leading colon plus traling CRLF pair
  end;

  procedure DecodeByte(var P: PAnsiChar; var B: Byte);

    function ASCIIToNibble(Value: Byte): Byte;
    begin
      if Value < 65 then // Ord('A')
        Result := Byte(Value - 48) // Value - Ord('0')
      else
        Result := Value - 55; // Value - Ord('A') + $0A
    end;

  begin
    // High part.
    B := Byte(ASCIIToNibble(PByte(P)^) shl 4);
    Inc(P);

    // Low part.
    B := B or ASCIIToNibble(PByte(P)^);
    Inc(P);
  end;

  // end of local block ----------------------------------------------------------------------------

var
  SourcePtr: PAnsiChar;
  DestSize: Integer;
  I: Integer;
begin
  Result := False;
  SourcePtr := PAnsiChar(@Source);
  Dest.Size := 0;

  case FTransmissionMode of
    tmRTU:
      if SourceSize >= DetermineMinimumRawFrameSize then
      begin
        // Is the Dest big enough?
        if SourceSize > Dest.Capacity then ModLinkError(@RsDecodeFrameFailed);

        // Just do the copy of the Source and adjust the Dest size appropriately.
        Move(Source, Dest.StartPtr^, SourceSize);
        Dest.Size := SourceSize;

        Result := ErrorChecksEqual(Dest);
      end;
    tmASCII:
      if (SourceSize >= DetermineMinimumRawFrameSize) and Odd(SourceSize) and
        (SourcePtr^ = Colon) and
        ((SourcePtr + SourceSize - 2)^ = CarriageReturn) and
        ((SourcePtr + SourceSize - 1)^ = LineFeed) then
      begin
        // These boolean tests should never fail.
        Assert(SourceSize >= DetermineMinimumRawFrameSize, 'DecodeFrame: The size is too small.');
        Assert(Odd(SourceSize), 'DecodeFrame: The size is not an odd number.');
        Assert(SourcePtr^ = Colon, 'DecodeFrame: Leading colon is missing.');
        Assert((SourcePtr + SourceSize - 2)^ = CarriageReturn, 'DecodeFrame: Trailing CR is missing.');
        Assert((SourcePtr + SourceSize - 1)^ = LineFeed, 'DecodeFrame: Trailing LF is missing.');

        // The size of the decoded frame.
        DestSize := (SourceSize - 3 * SizeOf(Byte)) div SizeOf(Word);

        // Is the Dest big enough?
        if DestSize > Dest.Capacity then ModLinkError(@RsDecodeFrameFailed);

        // Skip the leading colon.
        Inc(SourcePtr);

        // Process appropriate number of bytes in the Source and decode them into the Dest.
        for I := 0 to DestSize - 1 do
          DecodeByte(SourcePtr, PByte(Dest.StartPtr + I)^);

        // Adjust the Dest size appropriately.
        Dest.Size := DestSize;

        Result := ErrorChecksEqual(Dest);
      end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.DetermineErrorCheckSize: Integer;
begin
  if FTransmissionMode = tmRTU then
    Result := SizeOf(Word)
  else
    Result := SizeOf(Byte);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.DetermineHeaderSize: Integer;
begin
  Result := SizeOf(Byte); // Just stand-alone ServerAddress field.
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.DetermineInterimBufferSize: Integer;
// Determines the size of interim buffers intended for temporary I/O operations.
begin
  if FTransmissionMode = tmRTU then
    Result := MaxFrameADUSizeRTU
  else
    Result := SizeOf(Word) * MaxFrameADUSizeASCII + 3 * SizeOf(Byte);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.DetermineMaximumFrameSize: Integer;
begin
  if FTransmissionMode = tmRTU then
    Result := MaxFrameADUSizeRTU
  else
    Result := MaxFrameADUSizeASCII;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.DetermineMinimumQuerySize: Integer;
begin
  if FTransmissionMode = tmRTU then
    Result := MinQueryADUSizeRTU
  else
    Result := MinQueryADUSizeASCII;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.DetermineMinimumReplySize: Integer;
begin
  if FTransmissionMode = tmRTU then
    Result := MinReplyADUSizeRTU
  else
    Result := MinReplyADUSizeASCII;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DiscardPendingTransactions(Client: TModbusClient = nil);
// If the Client parameter is nil, this method discards all pending transactions in the internally
// maintained transaction queue (no filtering occurs). If the Client parameter is not nil,
// this method discards only those pending transactions in the internally maintained transaction
// queue who has been originated by given Client (filtering occurs).
begin
  if FActive and (ComponentState * [csLoading, csDesigning] = []) and
    (FConnectionMode = cmClient) then
  begin
    TTransactionThread(FThread).DiscardPendingTransactions(Client);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoAfterClose;
begin
  if Assigned(FOnAfterClose) then FOnAfterClose(Self);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoAfterFrameSendAsync;
begin
  if Assigned(FOnAfterFrameSendAsync) then
    FOnAfterFrameSendAsync(Self);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoAfterOpen;
begin
  if Assigned(FOnAfterOpen) then FOnAfterOpen(Self);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoBeforeClose;
begin
  if Assigned(FOnBeforeClose) then FOnBeforeClose(Self);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoBeforeFrameSendAsync;
begin
  if Assigned(FOnBeforeFrameSendAsync) then
    FOnBeforeFrameSendAsync(Self);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoBeforeOpen;
begin
  if Assigned(FOnBeforeOpen) then FOnBeforeOpen(Self);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoFrameReceive(const Data: TFrameData);
begin
  if Assigned(FOnFrameReceive) then FOnFrameReceive(Self, Data);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoFrameSend(const Data: TFrameData);
begin
  if Assigned(FOnFrameSend) then FOnFrameSend(Self, Data);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.DoGetHookedPortHandle: THandle;
begin
  Result := INVALID_HANDLE_VALUE;
  if Assigned(FOnGetHookedPortHandle) then
    FOnGetHookedPortHandle(Self, Result);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoInspectCapturedFrame(ServerAddress, CommandCode: Byte;
  const CommandData: TFrameData);
begin
  if Assigned(FOnInspectCapturedFrame) then
    FOnInspectCapturedFrame(Self, ServerAddress, CommandCode, CommandData);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoInvalidFrameDiscard;
begin
  if Assigned(FOnInvalidFrameDiscard) then
    FOnInvalidFrameDiscard(Self);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.DoPreprocessIncomingFrame(
  var Buffer;
  Capacity: Integer;
  var DataSize: Integer);
begin
  if Assigned(FOnPreprocessIncomingFrame) then
    FOnPreprocessIncomingFrame(Self, Buffer, Capacity, DataSize);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.EmitErrorCheck(Buffer: TModbusBuffer);
begin
  with Buffer do
    if FTransmissionMode = tmRTU then
      PutWordLoHi(CRC16)
    else
      PutByte(LRC8);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.EmitHeader(Client: TModbusClient; Buffer: TModbusBuffer);
begin
  if Client = nil then
    Buffer.PutByte(BroadcastAddress)
  else
    Buffer.PutByte(Client.ServerAddress);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.EmitHeader(Server: TModbusServer; Buffer: TModbusBuffer);
begin
  Buffer.PutByte(Server.Address);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.EncodeFrame(Source: TModbusBuffer; var Dest; DestCapacity: Integer): Integer;

  // begin of local block --------------------------------------------------------------------------

  procedure EncodeByte(B: Byte; var P: PAnsiChar);

    function NibbleToASCII(Value: Byte): Byte;
    begin
      if Value < $0A then
        Result := Value + 48 // Value + Ord('0')
      else
        Result := Value + 55; // Value + Ord('A') - $0A
    end;

  begin
    // High part.
    PByte(P)^ := NibbleToASCII(B shr 4);
    Inc(P);

    // Low part.
    PByte(P)^ := NibbleToASCII(B and $0F);
    Inc(P);
  end;

  // end of local block ----------------------------------------------------------------------------

var
  DestPtr: PAnsiChar;
  I: Integer;
begin
  Result := Source.Size;

  if FTransmissionMode = tmRTU then
  begin
    if Result > 0 then
    begin
      // Is the Dest big enough?
      if Result > DestCapacity then ModLinkError(@RsEncodeFrameFailed);

      // Just do the copy of the Source.
      Move(Source.StartPtr^, Dest, Result);
    end;
  end
  else
    if Result > 0 then
    begin
      // The size of the encoded frame.
      Result := SizeOf(Word) * Result + 3 * SizeOf(Byte);

      // Is the Dest big enough?
      if Result > DestCapacity then ModLinkError(@RsEncodeFrameFailed);

      // Acquire pointer to the Dest.
      DestPtr := PAnsiChar(@Dest);

      // Emit the leading colon.
      DestPtr^ := Colon;
      Inc(DestPtr);

      // Process all bytes in the Source and encode them into the Dest.
      for I := 0 to Source.Size - 1 do
        EncodeByte(PByte(Source.StartPtr + I)^, DestPtr);

      // Emit the trailing 'CR'.
      DestPtr^ := CarriageReturn;
      Inc(DestPtr);

      // Emit the trailing 'LF'.
      DestPtr^ := LineFeed;
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.EnqueueTransaction(Transaction: TModbusTransaction; AOriginator: TModbusClient);
// Attempts to add given transaction to the internal FIFO queue maintained by
// the transaction management thread. If the transaction cannot be enqueued,
// an exception is raised.
begin
  CheckOpened;
  Transaction.Originator := AOriginator; { v2.8 }
  TTransactionThread(FThread).Enqueue(Transaction);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.ErrorChecksEqual(Buffer: TModbusBuffer): Boolean;
begin
  with Buffer do
    if FTransmissionMode = tmRTU then
    begin
      Seek(smBufEnd);
      Seek(smPriorWord);
      Result := CRC16 = GetWordLoHi;
    end
    else
      begin
        Seek(smBufEnd);
        Seek(smPriorByte);
        Result := LRC8 = GetByte;
      end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.ExamineInputBuffer(out UnreadCount: Integer): Boolean;
var
  ErrorMask: Cardinal;
  ComStat: TComStat;
begin
  ClearCommError(FDeviceHandle, ErrorMask, @ComStat);
  UnreadCount := ComStat.cbInQue;
  Result := True;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetClient(Index: Integer): TModbusClient;
// Property getter for Client property.
begin
  Result := TModbusClient(FCLientList[Index]);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetClientCount: Integer;
// Property getter for ClientCount property.
begin
  Result := FClientList.Count;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetMaxRetries: TMaxRetries;
// Property getter for MaxRetries property.
begin
  FLock.BeginRead;
  try
    Result := FMaxRetries;
  finally
    FLock.EndRead;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetNextUniqueID: Cardinal;
// Returns the unique number to be used for unique identification of each Modbus transaction.
begin
  Result := FNextUniqueID;
  Inc(FNextUniqueID);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetRealSilentInterval: Cardinal;
// Property getter for RealSilentInterval property.
begin
  FLock.BeginRead;
  try
    Result := FRealSilentInterval;
  finally
    FLock.EndRead;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetReceiveTimeout: Cardinal;
// Property getter for ReceiveTimeout property.
begin
  FLock.BeginRead;
  try
    Result := FReceiveTimeout;
  finally
    FLock.EndRead;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetRefetchDelay: Cardinal;
// Property getter for RefetchDelay property.
begin
  FLock.BeginRead;
  try
    Result := FRefetchDelay;
  finally
    FLock.EndRead;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetRTSHoldDelay: Cardinal;
// Property getter for RTSHoldDelay property.
begin
  FLock.BeginRead;
  try
    Result := FRTSHoldDelay;
  finally
    FLock.EndRead;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetSendTimeout: Cardinal;
// Property getter for SendTimeout property.
begin
  FLock.BeginRead;
  try
    Result := FSendTimeout;
  finally
    FLock.EndRead;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetServer(Index: Integer): TModbusServer;
// Property getter for Server property.
begin
  Result := TModbusServer(FServerList[Index]);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetServerCount: Integer;
// Property getter for ServerCount property.
begin
  Result := FServerList.Count;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.GetTurnaroundDelay: Cardinal;
// Property getter for TurnaroundDelay property.
begin
  FLock.BeginRead;
  try
    Result := FTurnaroundDelay;
  finally
    FLock.EndRead;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.HeadersMatch(QueryBuffer, ReplyBuffer: TModbusBuffer): Boolean;
var
  Address1, Address2: Byte;
begin
  Address1 := AcquireServerAddress(QueryBuffer);
  Address2 := AcquireServerAddress(ReplyBuffer);
  Result := Address1 = Address2;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.InternalClose;

  // begin of local block --------------------------------------------------------------------------

  procedure DestroyDeviceHandle;
  begin
    if FDeviceHandle <> INVALID_HANDLE_VALUE then
    begin
      if not FHookExistingPort then
        CloseHandle(FDeviceHandle);
      FDeviceHandle := INVALID_HANDLE_VALUE;
    end;
  end;

  // end of local block ----------------------------------------------------------------------------

begin
  FreeAndNil(FThread);
  if FWaitInProgress then
  begin
    CancelIO;
    FWaitInProgress := False;
  end;
  DestroyDeviceHandle;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.InternalOpen;

  // begin of local block --------------------------------------------------------------------------

  procedure CreateDeviceHandle;
  begin
    if FHookExistingPort then
      FDeviceHandle := DoGetHookedPortHandle
    else
      FDeviceHandle := CreateFile(PChar('\\.\' + FPort),
        GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED, 0);
    if FDeviceHandle = INVALID_HANDLE_VALUE then
      ModLinkError(@RsCreateDeviceHandleFailed);
  end;

  procedure InitBuffers;
  begin
    if not SetupComm(FDeviceHandle, InputBufferSize, OutputBufferSize) then
      ModLinkError(@RsInitBuffersFailed);
  end;

  procedure InitTimeouts;
  var
    Timeouts: TCommTimeouts;
  begin
    ZeroMemory(@Timeouts, SizeOf(Timeouts));
    Timeouts.ReadIntervalTimeout := MAXDWORD;
    if not SetCommTimeouts(FDeviceHandle, Timeouts) then
      ModLinkError(@RsInitTimeoutsFailed);
  end;

  procedure InitEventMask;
  begin
    if not SetCommMask(FDeviceHandle, EV_RXCHAR) then
      ModLinkError(@RsInitEventMaskFailed);
  end;

  // end of local block ----------------------------------------------------------------------------

begin
  CreateDeviceHandle;
  try
    InitBuffers;
    InitTimeouts;
    InitEventMask;
    UpdateDCB;
    UpdateRealSilentInterval;
    FThread := TTransactionThread.Create(Self);
  except
    InternalClose;
    raise;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.InternalReceiveFrame(var Buffer; RequestedSize: Integer): Integer;
var
  Overlapped: TOverlapped;
  BytesRead: Cardinal;
  CurPtr: PByte;
begin
  Result := 0;
  BytesRead := 0;
  CurPtr := PByte(@Buffer);

  // Setup overlapped structure. Make sure that event object is in non-signalled state
  // before doing an overlapped operation.
  ZeroMemory(@Overlapped, SizeOf(Overlapped));
  Overlapped.hEvent := FOverlappedEvent;
  Win32Check(ResetEvent(Overlapped.hEvent));

  repeat
    // Read as much bytes from the device's input buffer as possible.
    if ReadFile(FDeviceHandle, CurPtr^, Cardinal(RequestedSize), BytesRead, @Overlapped) then
    begin
      Inc(Result, Integer(BytesRead));
      Dec(RequestedSize, Integer(BytesRead));
      Inc(CurPtr, Integer(BytesRead));
    end
    else if (GetLastError = ERROR_IO_PENDING) then
    begin
      // If this read is still pending, it may be turned into non-overlapped operation
      // since it will likely be completed as soon as possible.
      if GetOverlappedResult(FDeviceHandle, Overlapped, BytesRead, True) then
      begin
        Inc(Result, Integer(BytesRead));
        Dec(RequestedSize, Integer(BytesRead));
        Inc(CurPtr, Integer(BytesRead));
      end
      else
        {$IFDEF COMPILER_6_UP} RaiseLastOSError {$ELSE} RaiseLastWin32Error {$ENDIF COMPILER_6_UP};
    end
    else
      {$IFDEF COMPILER_6_UP} RaiseLastOSError {$ELSE} RaiseLastWin32Error {$ENDIF COMPILER_6_UP};
  until (BytesRead = 0) or (RequestedSize = 0);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.InternalWndProc(var Message: TMessage);

  // begin of local block --------------------------------------------------------------------------

  function FindClientFromTransaction(ATransaction: TModbusTransaction): TModbusClient;
  begin
    { (v2.8) This function now also checks for the matching client reference
             in addition to the server address. }
    Result := ATransaction.Originator;
    if (FClientList.IndexOf(Pointer(Result)) < 0) or
      (Result.ServerAddress <> ATransaction.Info.Address) then
    begin
      Result := nil;
    end;
  end;

  // end of local block ----------------------------------------------------------------------------

var
  Transaction: TModbusTransaction;
  Client: TModbusClient;
  FrameData: PFrameData;
  LEventArgs: TInspectCapturedFrameEventArgs;
begin
  with Message do
    case Msg of
      UM_TRANSACTIONCOMPLETE:
        try
          // Extract the reference to a transaction object.
          Transaction := TModbusTransaction(LParam);
          try
            // Does the client that initiated this transaction still exist in the client list ?
            Client := FindClientFromTransaction(Transaction);
            // (v2.4) Do not call DoneTransaction when this client is being
            // destroyed in order to avoid seeing exceptions at shutdown time.
            // (v2.5) Correct version of the above bug fix from v2.4
            if Assigned(Client) and Active and not (csDestroying in ComponentState) and not
              (csDestroying in Client.ComponentState) then
            begin
              Client.DoneTransaction(Transaction);
            end;
          finally
            // Release the transaction object.
            Transaction.Free;
          end;
        except
          // No exception should go unhandled beyond the window procedure.
          {$IFDEF COMPILER_6_UP}
          if Assigned(ApplicationHandleException) then
            ApplicationHandleException(Self);
          {$ELSE}
          Application.HandleException(Self);
          {$ENDIF COMPILER_6_UP}
        end;
      UM_FRAMEDATA:
        try
          // Extract the reference to the frame data.
          FrameData := PFrameData(LParam);
          try
            if Boolean(WParam) then
              DoFrameSend(FrameData^)
            else
              DoFrameReceive(FrameData^);
          finally
            // Release the frame data.
            DestroyFrameBuffer(FrameData);
          end;
        except
          // No exception should go unhandled beyond the window procedure.
          {$IFDEF COMPILER_6_UP}
          if Assigned(ApplicationHandleException) then
            ApplicationHandleException(Self);
          {$ELSE}
          Application.HandleException(Self);
          {$ENDIF COMPILER_6_UP}
        end;
      UM_INSPECTCAPTUREDFRAME:
        try
          LEventArgs := TInspectCapturedFrameEventArgs(LParam);
          try
            DoInspectCapturedFrame(LEventArgs.ServerAddress, LEventArgs.CommandCode, LEventArgs.CommandData);
          finally
            LEventArgs.Free;
          end;
        except
          // No exception should go unhandled beyond the window procedure.
          {$IFDEF COMPILER_6_UP}
          if Assigned(ApplicationHandleException) then
            ApplicationHandleException(Self);
          {$ELSE}
          Application.HandleException(Self);
          {$ENDIF COMPILER_6_UP}
        end;
    else
      // Pass any other unhandled messages to default window procedure.
      Result := DefWindowProc(FInternalWindow, Msg, WParam, LParam);
    end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.IsEcho(const QueryBuffer; QuerySize: Integer;
  const ReplyBuffer; ReplySize: Integer): Boolean;
begin
  Result := (ReplySize >= QuerySize) and
    CompareMem(@QueryBuffer, @ReplyBuffer, QuerySize);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.IsExceptionReply(Buffer: TModbusBuffer): Boolean;
begin
  with Buffer do
  begin
    // Skip the Modbus ADU header.
    Position := DetermineHeaderSize;
    Result := (Size = DetermineMinimumReplySize) and (GetByte > $80);
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.IsExpectedReply(QueryBuffer, ReplyBuffer: TModbusBuffer; PromiscuousMode: Boolean): Boolean;
begin
  Result := HeadersMatch(QueryBuffer, ReplyBuffer) or PromiscuousMode;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.IsPortStored: Boolean;
begin
  Result := FPort <> DefaultPort;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.Loaded;
begin
  inherited;
  try
    SetActive(FStreamedActive);
  except
    {$IFDEF COMPILER_6_UP}
    if Assigned(ApplicationHandleException) then
      ApplicationHandleException(Self);
    {$ELSE}
    Application.HandleException(Self);
    {$ENDIF COMPILER_6_UP}
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.Open;
begin
  SetActive(True);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.ProcessRemoteTransaction(Transaction: TModbusTransaction);

  // begin of local block --------------------------------------------------------------------------

  function FindServerFromServerAddress(AServerAddress: Byte): TModbusServer;
  var
    I: Integer;
  begin
    Result := nil;
    for I := 0 to FServerList.Count - 1 do
      if TModbusServer(FServerList[I]).Address = AServerAddress then
      begin
        Result := TModbusServer(FServerList[I]);
        Break;
      end;
  end;

  // end of local block ----------------------------------------------------------------------------
var
  I: Integer;
  Server: TModbusServer;
begin
  with Transaction do
  begin
    if Info.Address = BroadcastAddress then
      for I := 0 to FServerList.Count - 1 do
        TModbusServer(FServerList[I]).ProcessTransaction(Transaction)
    else
    begin
      Server := FindServerFromServerAddress(Info.Address);
      if Server <> nil then Server.ProcessTransaction(Transaction);
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.ReceiveFrame(var Buffer; Capacity: Integer; Timeout: Cardinal): Integer;
begin
  if FTransmissionMode = tmRTU then
    Result := ReceiveFrameRTU(Buffer, Capacity, Timeout, RealSilentInterval)
  else
    Result := ReceiveFrameASCII(Buffer, Capacity, Timeout, RealSilentInterval);

  DoPreprocessIncomingFrame(Buffer, Result, Capacity);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.ReceiveFrameASCII(var Buffer; Capacity: Integer; Timeout: Cardinal;
  Silence: Cardinal): Integer;
type
  TReceiveFrameStage = (rfsIdle, rfsCollecting, rfsCompleting, rfsCompleted);

  // begin of local block --------------------------------------------------------------------------

  function AcquireData(var Stage: TReceiveFrameStage; var Dest; DestFree: Integer;
    out Count: Integer; out RelocBase: PAnsiChar): Boolean;
  var
    Ptr, PeakPtr: PAnsiChar;
  begin
    Count := 0;
    RelocBase := nil;

    // Try to acquire data from the device's input buffer.
    Count := InternalReceiveFrame(Dest, DestFree);

    Result := Count > 0;

    if not Result then
      Exit;

    // Acquire pointers to the beginning and the end of Dest.
    Ptr := PAnsiChar(@Dest);
    PeakPtr := Ptr + Count - 1;

    // Reset the count.
    Count := 0;

    // Iterate the buffer.
    while Ptr <= PeakPtr do
    begin
      // Reception of 'colon' always means the beginning of a new frame.
      if Ptr^ = Colon then
      begin
        Stage := rfsCollecting;
        RelocBase := Ptr;
        Count := 1;
      end
      // Collect bytes of a new frame and wait for CR to arrive.
      else if Stage = rfsCollecting then
      begin
        if Ptr^ = CarriageReturn then Stage := rfsCompleting;
        Inc(Count);
      end
      // The next byte received immediately after CR must be LF.
      else if Stage = rfsCompleting then
        if Ptr^ = LineFeed then
        begin
          Stage := rfsCompleted;
          Inc(Count);
          Break;
        end
        else
        // Otherwise, this frame must be discarded.
        begin
          Stage := rfsIdle;
          RelocBase := nil;
          Count := 0;
        end;

      // Move to the next byte.
      Inc(Ptr);
    end; // while
  end;

  // end of local block ----------------------------------------------------------------------------

var
  StartPtr: PAnsiChar;
  //Dummy: Cardinal;
  BytesRead: Integer;
  Stage: TReceiveFrameStage;
  RelocBase: PAnsiChar;
begin
  // No bytes were read yet.
  Result := 0;

  if Timeout = 0 then
    Exit;

  // Acquire pointer to the buffer.
  StartPtr := PAnsiChar(@Buffer);

  // Clear device error flags, if any.
  //ClearCommError(FDeviceHandle, Dummy, nil);

  // Setup the stage.
  Stage := rfsIdle;

  // Wait for the beginning of the frame to arrive within given timeout
  // and harvest all incoming bytes from the device's input buffer.
  while (Stage = rfsIdle) and WaitForData(Timeout) and
    AcquireData(Stage, PByte(StartPtr + Result)^, Capacity - Result, BytesRead, RelocBase) do
  begin
    // Relocate the memory block if needed.
    if RelocBase <> nil then
    begin
      Move(RelocBase^, Buffer, BytesRead);
      Result := BytesRead;
    end
    else
      Inc(Result, BytesRead);
  end;

  // Wait for the remainder of the frame to arrive within the silent interval
  // and harvest all incoming bytes from the device's input buffer.
  while (Stage in [rfsCollecting, rfsCompleting]) and WaitForData(Silence) and
    AcquireData(Stage, PByte(StartPtr + Result)^, Capacity - Result, BytesRead, RelocBase) do
  begin
    // Relocate the memory block if needed.
    if RelocBase <> nil then
    begin
      Move(RelocBase^, Buffer, BytesRead);
      Result := BytesRead;
    end
    else
      Inc(Result, BytesRead);
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.ReceiveFrameRTU(var Buffer; Capacity: Integer; Timeout: Cardinal;
  Silence: Cardinal): Integer;

  // begin of local block --------------------------------------------------------------------------

  function AcquireData(var Dest; DestFree: Integer; out Count: Integer): Boolean;
  begin
    // Try to acquire data from the device's input buffer.
    Count := InternalReceiveFrame(Dest, DestFree);
    Result := Count > 0;
  end;

  // end of local block ----------------------------------------------------------------------------

var
  StartPtr: PAnsiChar;
  //Dummy: Cardinal;
  BytesRead: Integer;
begin
  // No bytes were read yet.
  Result := 0;

  if Timeout = 0 then
    Exit;

  // Acquire pointer to the buffer.
  StartPtr := PAnsiChar(@Buffer);

  // Clear device error flags, if any.
  //ClearCommError(FDeviceHandle, Dummy, nil);

  // Wait for the beginning of the frame to arrive within given timeout
  // and harvest all incoming bytes from the device's input buffer.
  if WaitForData(Timeout) and
    AcquireData(PByte(StartPtr + Result)^, Capacity - Result, BytesRead) then
  begin
    Inc(Result, BytesRead);
    // Wait for the remainder of the frame to arrive within the silent interval
    // and harvest all incoming bytes from the device's input buffer.
    while WaitForData(Silence) do
      while AcquireData(PByte(StartPtr + Result)^, Capacity - Result, BytesRead) do
        Inc(Result, BytesRead);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.RegisterClient(Client: TModbusClient);
// Adds a reference of given Client to the internal list of all clients
// who share this connection. Do not call this method manually as it is
// called automatically by the client when needed.
begin
  // Neither nil nor duplicate references are allowed.
  if (Client <> nil) and (FClientList.IndexOf(Client) < 0) then
    FClientList.Add(Client);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.RegisterServer(Server: TModbusServer);
// Adds a reference of given Server to the internal list of all servers
// who share this connection. Do not call this method manually as it is
// called automatically by the server when needed.
begin
  // Neither nil nor duplicate references are allowed.
  if (Server <> nil) and (FServerList.IndexOf(Server) < 0) then
    FServerList.Add(Server);
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.SendFrame(const Buffer; Size: Integer; Timeout: Cardinal): Boolean;
var
  Overlapped: TOverlapped;
  BytesWritten: Cardinal;
begin
  Result := False;
  BytesWritten := 0;

  // Setup overlapped structure. Make sure that event object is in non-signalled state
  // before doing an overlapped operation.
  ZeroMemory(@Overlapped, SizeOf(Overlapped));
  Overlapped.hEvent := FOverlappedEvent;
  Win32Check(ResetEvent(Overlapped.hEvent));

  DoBeforeFrameSendAsync;

  // If the requested flow control is fcRtsToggle, the RTS line has to be raised
  // to tell the DCE that there are bytes available for transmission.
  if FFlowControl = fcRtsToggle then
    Win32Check(EscapeCommFunction(FDeviceHandle, SETRTS));

  // Do actual write.
  if WriteFile(FDeviceHandle, Buffer, Cardinal(Size), BytesWritten, @Overlapped) then
    Result := BytesWritten = Cardinal(Size)
  else if GetLastError = ERROR_IO_PENDING then
  begin
    if GetOverlappedResult(FDeviceHandle, Overlapped, BytesWritten, True) then
      Result := BytesWritten = Cardinal(Size)
    else
      {$IFDEF COMPILER_6_UP} RaiseLastOSError {$ELSE} RaiseLastWin32Error {$ENDIF COMPILER_6_UP};
  end
  else
    {$IFDEF COMPILER_6_UP} RaiseLastOSError {$ELSE} RaiseLastWin32Error {$ENDIF COMPILER_6_UP};

  Win32Check(FlushFileBuffers(FDeviceHandle));

  // If the requested flow control is fcRtsToggle, the RTS line has to be lowered
  // after all buffered bytes have been sent.
  if FlowControl = fcRtsToggle then
  begin
    Delay(RTSHoldDelay);
    Win32Check(EscapeCommFunction(FDeviceHandle, CLRRTS));
  end;

  DoAfterFrameSendAsync;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetActive(Value: Boolean);
// Property setter for Active property.
begin
  if csReading in ComponentState then
    FStreamedActive := Value
  else
    if FActive <> Value then
    begin
      if not (csDesigning in ComponentState) then
      begin
        if Value then
        begin
          DoBeforeOpen;
          InternalOpen;
          DoAfterOpen;
        end
        else
        begin
          DoBeforeClose;
          InternalClose;
          DoAfterClose;
        end;
      end;
      FActive := Value;
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetBaudRate(Value: TBaudRate);
// Property setter for BaudRate property.
begin
  if FBaudRate <> Value then
  begin
    FBaudRate := Value;
    if FActive and (ComponentState * [csReading, csDesigning] = []) then
    begin
      UpdateDCB;
      UpdateRealSilentInterval;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetConnectionMode(Value: TConnectionMode);
// Property setter for ConnectionMode property.
begin
  if FConnectionMode <> Value then
  begin
    // In order to avoid multi-thread conflicts, ConnectionMode property
    // cannot be modified while the connection is active.
    CheckClosed;
    FConnectionMode := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetCustomBaudRate(Value: Cardinal);
// Property setter for CustomBaudRate property.
begin
  if FCustomBaudRate <> Value then
  begin
    FCustomBaudRate := Value;
    FBaudRate := brCustom;
    if FActive and (ComponentState * [csReading, csDesigning] = []) then
    begin
      UpdateDCB;
      UpdateRealSilentInterval;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetDataBits(Value: TDataBits);
// Property setter for DataBits property.
begin
  if FDataBits <> Value then
  begin
    FDataBits := Value;
    if FActive and (ComponentState * [csReading, csDesigning] = []) then
    begin
      UpdateDCB;
      UpdateRealSilentInterval;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetDTREnabled(Value: Boolean);
// Property setter for DTREnabled property.
begin
  if FDTREnabled <> Value then
  begin
    // Currently, this property should not be changed while the connection is active.
    CheckClosed;
    FDTREnabled := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetEchoQueryBeforeReply(Value: Boolean);
begin
  FLock.BeginWrite;
  try
    FEchoQueryBeforeReply := Value;
  finally
    FLock.EndWrite;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetFlowControl(Value: TFlowControl);
// Property setter for FlowControl property.
begin
  if FFlowControl <> Value then
  begin
    // In order to avoid multi-thread conflicts, FlowControl property
    // cannot be modified while the connection is active.
    CheckClosed;
    FFlowControl := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetHookExistingPort(Value: Boolean);
// Property setter for HookExistingPort property.
begin
  if FHookExistingPort <> Value then
  begin
    // HookExistingPort property cannot be modified while the connection is active.
    CheckClosed;
    FHookExistingPort := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetInputBufferSize(Value: Integer);
begin
  if fInputBufferSize <> Value then
  begin
    // Device buffer size cannot be modified while the connection is active.
    CheckClosed;
    fInputBufferSize := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetMaxRetries(Value: TMaxRetries);
// Property setter for MaxTransactionRetries property.
begin
  FLock.BeginWrite;
  try
    if FMaxRetries <> Value then
    begin
      // Each transaction gets executed at least once.
      if Value > 0 then
        FMaxRetries := Value
      else
        ModLinkError(@RsOutOfRangeArgs, [Int64(Low(FMaxRetries)), Int64(High(FMaxRetries))]);
    end;
  finally
    FLock.EndWrite;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetOutputBufferSize(Value: Integer);
begin
  if fOutputBufferSize <> Value then
  begin
    // Device buffer size cannot be modified while the connection is active.
    CheckClosed;
    fOutputBufferSize := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetParity(Value: TParityScheme);
// Property setter for Parity property.
begin
  if FParity <> Value then
  begin
    FParity := Value;
    if FActive and (ComponentState * [csReading, csDesigning] = []) then
    begin
      UpdateDCB;
      UpdateRealSilentInterval;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetPortProperty(Value: TSerialPort);
// Property setter for Port property.
begin
  if FPort <> Value then
  begin
    // Port property cannot be modified while the connection is active.
    CheckClosed;
    FPort := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetReceiveTimeout(Value: Cardinal);
// Property setter for ReceiveTimeout property.
begin
  FLock.BeginWrite;
  try
    if FReceiveTimeout <> Value then FReceiveTimeout := Value;
  finally
    FLock.EndWrite;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetRefetchDelay(Value: Cardinal);
// Property setter for RefetchDelay property.
begin
  FLock.BeginWrite;
  try
    // Value of zero means no additional delay at all.
    if FRefetchDelay <> Value then FRefetchDelay := Value;
  finally
    FLock.EndWrite;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetRTSEnabled(Value: Boolean);
// Property setter for RTSEnabled property.
begin
  if FRTSEnabled <> Value then
  begin
    // Currently, this property should not be changed while the connection is active.
    CheckClosed;
    FRTSEnabled := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetRTSHoldDelay(Value: Cardinal);
// Property setter for RTSHoldDelay property.
begin
  FLock.BeginWrite;
  try
    // Value of zero means no additional delay at all.
    if FRTSHoldDelay <> Value then FRTSHoldDelay := Value;
  finally
    FLock.EndWrite;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetSendTimeout(Value: Cardinal);
// Property setter for SendTimeout property.
begin
  FLock.BeginWrite;
  try
    if FSendTimeout <> Value then FSendTimeout := Value;
  finally
    FLock.EndWrite;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetSilentInterval(Value: Cardinal);
// Property setter for SilentInterval property.
begin
  if FSilentInterval <> Value then
  begin
    FSilentInterval := Value;
    if FActive and (ComponentState * [csReading, csDesigning] = []) then
      UpdateRealSilentInterval;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetStopBits(Value: TStopBits);
// Property setter for StopBits property.
begin
  if FStopBits <> Value then
  begin
    FStopBits := Value;
    if FActive and (ComponentState * [csReading, csDesigning] = []) then
    begin
      UpdateDCB;
      UpdateRealSilentInterval;
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetThreadPriority(Value: TThreadPriority);
// Property setter for ThreadPriority property.
begin
  if FThreadPriority <> Value then
  begin
    FThreadPriority := Value;
    if FActive and (ComponentState * [csReading, csDesigning] = []) then
      FThread.Priority := FThreadPriority;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetTransmissionMode(Value: TTransmissionMode);
// Property setter for TransmissionMode property.
begin
  if FTransmissionMode <> Value then
  begin
    // In order to avoid multi-thread conflicts, TransmissionMode property
    // cannot be modified while the connection is active.
    CheckClosed;
    // RealSilentInterval property will be updated during the activation sequence.
    FTransmissionMode := Value;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.SetTurnaroundDelay(Value: Cardinal);
// Property setter for TurnaroundDelay property.
begin
  FLock.BeginWrite;
  try
    if FTurnaroundDelay <> Value then FTurnaroundDelay := Value;
  finally
    FLock.EndWrite;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.UnregisterClient(Client: TModbusClient);
// Removes a reference of given Client from the internal list of all clients
// who share this connection. Do not call this method manually as
// it is called automatically by the client when needed.
begin
  if Client <> nil then FClientList.Remove(Client);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.UnregisterServer(Server: TModbusServer);
// Removes a reference of given Server from the internal list of all servers
// who share this connection. Do not call this method manually as
// it is called automatically by the server when needed.
begin
  if Server <> nil then FServerList.Remove(Server);
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.UpdateDCB;
const
  Flag_Binary              = $00000001;
  Flag_Parity              = $00000002;
  Flag_OutxCtsFlow         = $00000004;
  Flag_OutxDsrFlow         = $00000008;
  Flag_DtrControlDisable   = $00000000;
  Flag_DtrControlEnable    = $00000010;
  Flag_DtrControlHandshake = $00000020;
  Flag_RtsControlDisable   = $00000000;
  Flag_RtsControlEnable    = $00001000;
  Flag_RtsControlHandshake = $00002000;
  Flag_RtsControlToggle    = $00003000;
  Flag_AbortOnError        = $00004000;

  CBaudRates: array [TBaudRate] of Cardinal = (
    CBR_110,
    CBR_300,
    CBR_600,
    CBR_1200,
    CBR_2400,
    CBR_4800,
    CBR_9600,
    CBR_14400,
    CBR_19200,
    CBR_38400,
    CBR_56000,
    CBR_57600,
    CBR_115200,
    CBR_128000,
    CBR_256000,
    0
  );
  CDataBits: array [TDataBits] of Cardinal = (
    7,
    8
  );
  CFlowControls: array [TFlowControl] of Cardinal = (
    0,
    0, { Flag_RtsControlToggle }
    Flag_RtsControlHandshake or Flag_OutxCtsFlow,
    Flag_DtrControlHandshake or Flag_OutxDsrFlow
  );
  CParitySchemes: array [TParityScheme] of Cardinal = (
    NOPARITY,
    ODDPARITY,
    EVENPARITY
  );
  CStopBits: array [TStopBits] of Cardinal = (
    ONESTOPBIT,
    TWOSTOPBITS
  );
var
  DCB: TDCB;
begin
  if FDeviceHandle <> INVALID_HANDLE_VALUE then
  begin
    ZeroMemory(@DCB, SizeOf(DCB));
    with DCB do
    begin
      DCBlength := SizeOf(DCB);
      if FBaudRate = brCustom then
        BaudRate := FCustomBaudRate
      else
        BaudRate := CBaudRates[FBaudRate];
      ByteSize := CDataBits[FDataBits];
      Parity := CParitySchemes[FParity];
      StopBits := CStopBits[FStopBits];
      XonChar := AnsiChar(#17);
      XoffChar := AnsiChar(#19);
      Flags := Flag_Binary { or Flag_AbortOnError } or CFlowControls[FFlowControl];
      if FParity <> psNone then Flags := Flags or Flag_Parity;
      // RTS and DTR lines are disabled by default. Therefore, determine only if the application
      // wants those lines to be enabled, provided that this doesn't interfere with the current
      // value of FlowControl property.
      if FRTSEnabled and not (FFlowControl in [fcRtsToggle, fcRtsCts]) then
        Flags := Flags or Flag_RtsControlEnable;
      if FDTREnabled and (FFlowControl <> fcDtrDsr) then
        Flags := Flags or Flag_DtrControlEnable;
    end;
    if not SetCommState(FDeviceHandle, DCB) then
      ModLinkError(@RsUpdateDcbFailed);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TModbusConnection.UpdateRealSilentInterval;
// Serial character time is defined as a period of time elapsed between the
// start bits of two consecutive characters during the serial transmission.
// It could be expressed as a total number of bits in the serial byte
// excluding the start bit (that is a sum of data bits, eventual parity bit
// and stop bits), divided by the current baud rate.
const
  CBaudRates: array [TBaudRate] of Cardinal = (
    CBR_110,
    CBR_300,
    CBR_600,
    CBR_1200,
    CBR_2400,
    CBR_4800,
    CBR_9600,
    CBR_14400,
    CBR_19200,
    CBR_38400,
    CBR_56000,
    CBR_57600,
    CBR_115200,
    CBR_128000,
    CBR_256000,
    0
  );
  CDataBits: array [TDataBits] of Cardinal = (
    7,
    8
  );
  CStopBits: array [TStopBits] of Cardinal = (
    1,
    2
  );
var
  RealBaudRate: Cardinal;
begin
  FLock.BeginWrite;
  try
    if FTransmissionMode = tmRTU then
    begin
      if FBaudRate = brCustom then
        RealBaudRate := FCustomBaudRate
      else
        RealBaudRate := CBaudRates[BaudRate];
      FRealSilentInterval := Cardinal(Ceil(FSilentInterval * (CDataBits[FDataBits] +
       Cardinal(Boolean(FParity <> psNone)) + CStopBits[FStopBits]) * 1000 / RealBaudRate));
    end
    else
      FRealSilentInterval := FSilentInterval;

    // Work around the delayed serial driver notification issue in Windows OS family.
    if FRealSilentInterval < MinimumRealSilentInterval then
      FRealSilentInterval := MinimumRealSilentInterval;
  finally
    FLock.EndWrite;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.WaitForData(Timeout: Cardinal): Boolean;
var
  EventHandles: array [0..1] of THandle;
  Dummy: Cardinal;
begin
  Result := False;

  if not FWaitInProgress then
  begin
    // Setup overlapped structure. Make sure that event object is in non-signalled state
    // before doing an overlapped operation.
    ZeroMemory(@FOverlappedWait, SizeOf(FOverlappedWait));
    FOverlappedWait.hEvent := FOverlappedWaitEvent;
    Win32Check(ResetEvent(FOverlappedWait.hEvent));

    // Do actual wait.
    if WaitCommEvent(FDeviceHandle, FOverlappedWaitEventMask, @FOverlappedWait) then
    begin
      Result := (FOverlappedWaitEventMask and EV_RXCHAR) <> 0;
    end
    else if GetLastError = ERROR_IO_PENDING then
    begin
      FWaitInProgress := True;
    end
    else
      {$IFDEF COMPILER_6_UP} RaiseLastOSError {$ELSE} RaiseLastWin32Error {$ENDIF COMPILER_6_UP};
  end;

  if FWaitInProgress then
  begin
    EventHandles[0] := FOverlappedWait.hEvent;
    EventHandles[1] := FBreakEvent;

    case WaitForMultipleObjects(2, @EventHandles, False, Timeout) of
      WAIT_OBJECT_0:
        begin
          if GetOverlappedResult(FDeviceHandle, FOverlappedWait, Dummy, False) then
          begin
            Result := (FOverlappedWaitEventMask and EV_RXCHAR) <> 0;
            FWaitInProgress := False;
          end
          else if GetLastError <> ERROR_IO_INCOMPLETE then
            {$IFDEF COMPILER_6_UP} RaiseLastOSError {$ELSE} RaiseLastWin32Error {$ENDIF COMPILER_6_UP};
        end;
      WAIT_TIMEOUT:
        {do nothing} ;
      WAIT_OBJECT_0 + 1:
        begin
          // Break on demand.
          Result := False;
        end;
    else
      {$IFDEF COMPILER_6_UP} RaiseLastOSError {$ELSE} RaiseLastWin32Error {$ENDIF COMPILER_6_UP};
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.WriteMultipleCoils(StartBit: Word; const BitValues: array of Boolean;
  UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command (broadcasting mode).
const
  // Calculation based on the query PDU:
  // [Command | StartBit | BitCount | ByteCount | N * Data]
  MaxBitCount = (MaxFramePDUSize - 2 * SizeOf(Byte) - 2 * SizeOf(Word)) * BitsPerByte;
var
  BitCount: Integer;
  Transaction: TModbusTransaction;
begin
  CheckOpened;

  // Acquire the number of coils to be written.
  BitCount := Length(BitValues);

  // BitCount must fall in range from 1 through MaxBitCount.
  if (BitCount < 1) or (BitCount > MaxBitCount) then
    ModLinkError(@RsInvalidBitCountArgs, [MaxBitCount]);

  // Entire range of bit references should fit into 16-bits.
  if (StartBit + BitCount - 1 > High(Word)) then
    ModLinkError(@RsInvalidStartBitArgs, [StartBit]);

  Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
  try
    with Transaction do
    begin
      // Acquire an unique ID for this transaction.
      Result := GetNextUniqueID;

      // Setup transaction info.
      ZeroMemory(@Info, SizeOf(Info));
      Info.ID := Result;
      Info.Address := BroadcastAddress;
      Info.UserData := UserData;

      // Modbus ADU header.
      EmitHeader(TModbusClient(nil), QueryBuffer);

      with QueryBuffer do
      begin
        // Modbus command code.
        PutByte(Cmd_WriteMultipleCoils);
        // The first coil to start the writing to.
        PutWordHiLo(StartBit);
        // The number of coils to be written.
        PutWordHiLo(BitCount);
        // The total number of bytes to be written.
        PutByte(DetermineEncodedSize(BitCount));
        // Coil values to be written.
        EncodeBits(BitValues, QueryBuffer);
      end;

      // Modbus error check field.
      EmitErrorCheck(QueryBuffer);
    end;

    // Enqueue this transaction for asynchronous execution.
    EnqueueTransaction(Transaction, nil);
  except
    Transaction.Free;
    raise;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.WriteMultipleRegisters(StartReg: Word; const RegValues: array of Word;
  UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command (broadcasting mode).
const
  // Calculation based on the query PDU:
  // [Command | StartReg | RegCount | ByteCount | N * Data]
  MaxRegCount = (MaxFramePDUSize - 2 * SizeOf(Byte) - 2 * SizeOf(Word)) div SizeOf(Word);
var
  RegCount, I: Integer;
  Transaction: TModbusTransaction;
begin
  CheckOpened;

  // Acquire the number of holding registers to be written.
  RegCount := Length(RegValues);

  // RegCount must fall in range from 1 through MaxRegCount.
  if (RegCount < 1) or (RegCount > MaxRegCount) then
    ModLinkError(@RsInvalidRegCountArgs, [MaxRegCount]);

  // Entire range of register references should fit into 16-bits.
  if (StartReg + RegCount - 1 > High(Word)) then
    ModLinkError(@RsInvalidStartRegArgs, [StartReg]);

  Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
  try
    with Transaction do
    begin
      // Acquire an unique ID for this transaction.
      Result := GetNextUniqueID;

      // Setup transaction info.
      ZeroMemory(@Info, SizeOf(Info));
      Info.ID := Result;
      Info.Address := BroadcastAddress;
      Info.UserData := UserData;

      // Modbus ADU header.
      EmitHeader(TModbusClient(nil), QueryBuffer);

      with QueryBuffer do
      begin
        // Modbus command code.
        PutByte(Cmd_WriteMultipleRegisters);
        // The first holding register to start the writing to.
        PutWordHiLo(StartReg);
        // The number of holding registers to be written.
        PutWordHiLo(RegCount);
        // The total number of bytes to be written.
        PutByte(RegCount * SizeOf(Word));
        // Register values to be written. Note that RegValues may be either static or dynamic array
        // (we are using an open array parameters) so be careful when determining the array bounds.
        for I := Low(RegValues) to High(RegValues) do
          PutWordHiLo(RegValues[I]);
      end;

      // Modbus error check field.
      EmitErrorCheck(QueryBuffer);
    end;

    // Enqueue this transaction for asynchronous execution.
    EnqueueTransaction(Transaction, nil);
  except
    Transaction.Free;
    raise;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.WriteSingleCoil(BitAddr: Word; BitValue: Boolean; UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command (broadcasting mode).
var
  Transaction: TModbusTransaction;
begin
  CheckOpened;

  Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
  try
    with Transaction do
    begin
      // Acquire an unique ID for this transaction.
      Result := GetNextUniqueID;

      // Setup transaction info.
      ZeroMemory(@Info, SizeOf(Info));
      Info.ID := Result;
      Info.Address := BroadcastAddress;
      Info.UserData := UserData;

      // Modbus ADU header.
      EmitHeader(TModbusClient(nil), QueryBuffer);

      with QueryBuffer do
      begin
        // Modbus command code.
        PutByte(Cmd_WriteSingleCoil);
        // The address of a coil to be preset.
        PutWordHiLo(BitAddr);
        // The requested preset value for a coil.
        if BitValue then
          PutWordHiLo(CoilOn)
        else
          PutWordHiLo(CoilOff);
      end;

      // Modbus error check field.
      EmitErrorCheck(QueryBuffer);
    end;

    // Enqueue this transaction for asynchronous execution.
    EnqueueTransaction(Transaction, nil);
  except
    Transaction.Free;
    raise;
  end;
end;

//--------------------------------------------------------------------------------------------------

function TModbusConnection.WriteSingleRegister(RegAddr: Word; RegValue: Word; UserData: Pointer = nil): Cardinal;
// Implementation of standard Modbus command (broadcasting mode).
var
  Transaction: TModbusTransaction;
begin
  CheckOpened;

  Transaction := TModbusTransaction.Create(DetermineMaximumFrameSize);
  try
    with Transaction do
    begin
      // Acquire an unique ID for this transaction.
      Result := GetNextUniqueID;

      // Setup transaction info.
      ZeroMemory(@Info, SizeOf(Info));
      Info.ID := Result;
      Info.Address := BroadcastAddress;
      Info.UserData := UserData;

      // Modbus ADU header.
      EmitHeader(TModbusClient(nil), QueryBuffer);

      with QueryBuffer do
      begin
        // Modbus command code.
        PutByte(Cmd_WriteSingleRegister);
        // The address of a holding register to be preset.
        PutWordHiLo(RegAddr);
        // The requested preset value for a holding register.
        PutWordHiLo(RegValue);
      end;

      // Modbus error check field.
      EmitErrorCheck(QueryBuffer);
    end;

    // Enqueue this transaction for asynchronous execution.
    EnqueueTransaction(Transaction, nil);
  except
    Transaction.Free;
    raise;
  end;
end;

//--------------------------------------------------------------------------------------------------
// TSystemClockResolutionEnhancer
//--------------------------------------------------------------------------------------------------

type
  TSystemClockResolutionEnhancer = class(TObject)
  private
    FTimerInterval: Cardinal;
  public
    constructor Create;
    destructor Destroy; override;
  end;

//--------------------------------------------------------------------------------------------------

resourcestring
  RsSystemClockResolutionEnhancerFailed = 'Failed to enhance system clock resolution';

//--------------------------------------------------------------------------------------------------

var
  GSystemClockResolutionEnhancer: TSystemClockResolutionEnhancer = nil;

//--------------------------------------------------------------------------------------------------

function Min(A, B: Cardinal): Cardinal;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

//--------------------------------------------------------------------------------------------------

constructor TSystemClockResolutionEnhancer.Create;
var
  LTimeCaps: TTimeCaps;
begin
  inherited;
  Assert(FTimerInterval = 0);
  ZeroMemory(@LTimeCaps, SizeOf(LTimeCaps));
  if timeGetDevCaps(@LTimeCaps, SizeOf(LTimeCaps)) = TIMERR_NOERROR then
  begin
    FTimerInterval := Min(LTimeCaps.wPeriodMin, LTimeCaps.wPeriodMax);
    Assert(FTimerInterval <> 0);
    if timeBeginPeriod(FTimerInterval) <> TIMERR_NOERROR then
      FTimerInterval := 0;
  end;
  if FTimerInterval = 0 then
    ModLinkError(@RsSystemClockResolutionEnhancerFailed);
end;

//--------------------------------------------------------------------------------------------------

destructor TSystemClockResolutionEnhancer.Destroy;
begin
  if FTimerInterval <> 0 then
  begin
    timeEndPeriod(FTimerInterval);
    FTimerInterval := 0;
  end;
  inherited;
end;

//--------------------------------------------------------------------------------------------------

procedure EnumSerialPorts(Dest: TStrings);
// Enumerates all installed serial ports on the PC.
var
  ValueNames: TStringList;
  I: Integer;
begin
  Dest.Clear;
  with TRegistry.Create {$IFDEF COMPILER_5_UP} (KEY_READ) {$ENDIF COMPILER_5_UP} do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM') then
    begin
      ValueNames := TStringList.Create;
      try
        GetValueNames(ValueNames);
        for I := 0 to ValueNames.Count - 1 do
          if GetDataType(ValueNames[I]) = rdString then
            Dest.Add(ReadString(ValueNames[I]));
      finally
        ValueNames.Free;
      end;
    end;
  finally
    Free;
  end;
end;

//--------------------------------------------------------------------------------------------------

resourcestring
  RsTrimModbusFrameDataSizeTooLarge = 'TrimModbusFrame: Data size exceeds buffer capacity';
  RsTrimModbusFrameInvalidParameters = 'TrimModbusFrame: Combination of DataSize, LeadingBytesStripped, and TrailingBytesStripped is invalid';

procedure TrimModbusFrame(
  var Buffer;
  Capacity: Integer;
  var DataSize: Integer;
  LeadingBytesTrimmed,
  TrailingBytesTrimmed: Integer);
// Strips a specific number of bytes off the start/end of the Modbus frame.
var
  NewSize: Integer;
begin
  if DataSize > Capacity then
    ModLinkError(@RsTrimModbusFrameDataSizeTooLarge);

  NewSize := DataSize - LeadingBytesTrimmed - TrailingBytesTrimmed;

  if (NewSize < 0) or (NewSize > Capacity) then
    ModLinkError(@RsTrimModbusFrameInvalidParameters);

  if (NewSize > 0) and (LeadingBytesTrimmed > 0) then
    System.Move(PByte(NativeInt(@Buffer) + LeadingBytesTrimmed)^, Buffer, NewSize);

  DataSize := NewSize;
end;

//--------------------------------------------------------------------------------------------------
// A helper routines used in a bidirectional conversion between a real world values,
// and a Modbus register's native storage format compliant values.
//--------------------------------------------------------------------------------------------------

procedure DecodeBigNumber32(const Buffer32; BigEndian: Boolean; var RegValue1, RegValue2: Word);
// Buffer32 must be a variable whose SizeOf is 32 bits! No type checking is performed here.
begin
  if BigEndian then
  begin
    RegValue1 := LongRec(Buffer32).Hi;
    RegValue2 := LongRec(Buffer32).Lo;
  end
  else
  begin
    RegValue1 := LongRec(Buffer32).Lo;
    RegValue2 := LongRec(Buffer32).Hi;
  end
end;

//--------------------------------------------------------------------------------------------------

procedure EncodeBigNumber32(RegValue1, RegValue2: Word; BigEndian: Boolean; var Buffer32);
// Buffer32 must be a variable whose SizeOf is 32 bits! No type checking is performed here.
begin
  if BigEndian then
  begin
    LongRec(Buffer32).Hi := RegValue1;
    LongRec(Buffer32).Lo := RegValue2;
  end
  else
  begin
    LongRec(Buffer32).Lo := RegValue1;
    LongRec(Buffer32).Hi := RegValue2;
  end
end;

//--------------------------------------------------------------------------------------------------

procedure DecodeBigNumber64(const Buffer64; BigEndian: Boolean; var RegValue1, RegValue2,
  RegValue3, RegValue4: Word);
// Buffer64 must be a variable whose SizeOf is 64 bits! No type checking is performed here.
begin
  if BigEndian then
  begin
    RegValue1 := LongRec(Int64Rec(Buffer64).Hi).Hi;
    RegValue2 := LongRec(Int64Rec(Buffer64).Hi).Lo;
    RegValue3 := LongRec(Int64Rec(Buffer64).Lo).Hi;
    RegValue4 := LongRec(Int64Rec(Buffer64).Lo).Lo;
  end
  else
  begin
    RegValue1 := LongRec(Int64Rec(Buffer64).Lo).Lo;
    RegValue2 := LongRec(Int64Rec(Buffer64).Lo).Hi;
    RegValue3 := LongRec(Int64Rec(Buffer64).Hi).Lo;
    RegValue4 := LongRec(Int64Rec(Buffer64).Hi).Hi;
  end
end;

//--------------------------------------------------------------------------------------------------

procedure EncodeBigNumber64(RegValue1, RegValue2, RegValue3, RegValue4: Word;
  BigEndian: Boolean; var Buffer64);
// Buffer64 must be a variable whose SizeOf is 64 bits! No type checking is performed here.
begin
  if BigEndian then
  begin
    LongRec(Int64Rec(Buffer64).Hi).Hi := RegValue1;
    LongRec(Int64Rec(Buffer64).Hi).Lo := RegValue2;
    LongRec(Int64Rec(Buffer64).Lo).Hi := RegValue3;
    LongRec(Int64Rec(Buffer64).Lo).Lo := RegValue4;
  end
  else
  begin
    LongRec(Int64Rec(Buffer64).Lo).Lo := RegValue1;
    LongRec(Int64Rec(Buffer64).Lo).Hi := RegValue2;
    LongRec(Int64Rec(Buffer64).Hi).Lo := RegValue3;
    LongRec(Int64Rec(Buffer64).Hi).Hi := RegValue4;
  end
end;

//--------------------------------------------------------------------------------------------------
// A set of utility routines intended for a bidirectional conversion between a real world values,
// and a Modbus register's native storage format compliant values.
//--------------------------------------------------------------------------------------------------

function SmallInt2Mod(Number: SmallInt): Word;
// Converts a small integer number given by Number to a Modbus register's
// native storage format.
begin
  Result := Word(Number); // Just a simple static typecast.
end;

//--------------------------------------------------------------------------------------------------

procedure LongInt2Mod(Number: LongInt; var RegValue1, RegValue2: Word;
  BigEndian: Boolean = False);
begin
  DecodeBigNumber32(Number, BigEndian, RegValue1, RegValue2);
end;

//--------------------------------------------------------------------------------------------------

procedure LongWord2Mod(Number: LongWord; var RegValue1, RegValue2: Word;
  BigEndian: Boolean = False);
begin
  DecodeBigNumber32(Number, BigEndian, RegValue1, RegValue2);
end;

//--------------------------------------------------------------------------------------------------

function ScaledFloat2Mod(const Number: Single; Decimals: Integer): Word;
// Converts a scaled floating point number denoted by Number to a single Modbus register's native
// format. Decimals specifies the number of decimal places which is used by a remote server
// when treating the contents of that single register as a scaled floating-point number.
begin
  if Decimals > 0 then
    Result := Word(SmallInt(Round(Number * IntPower(10.0, Decimals))))
  else
    Result := Word(SmallInt(Round(Number)));
end;

//--------------------------------------------------------------------------------------------------

procedure Single2Mod(const Number: Single; var RegValue1, RegValue2: Word;
  BigEndian: Boolean = False);
begin
  DecodeBigNumber32(Number, BigEndian, RegValue1, RegValue2);
end;

//--------------------------------------------------------------------------------------------------

procedure Double2Mod(const Number: Double; var RegValue1, RegValue2, RegValue3, RegValue4: Word;
  BigEndian: Boolean = False);
begin
  DecodeBigNumber64(Number, BigEndian, RegValue1, RegValue2, RegValue3, RegValue4);
end;

//--------------------------------------------------------------------------------------------------

function Mod2SmallInt(RegValue: Word): SmallInt;
// Converts RegValue expressed in a Modbus register's native storage format to
// a small integer number.
begin
  Result := SmallInt(RegValue); // Just a simple static typecast.
end;

//--------------------------------------------------------------------------------------------------

function Mod2LongInt(RegValue1, RegValue2: Word; BigEndian: Boolean = False): LongInt;
begin
  EncodeBigNumber32(RegValue1, RegValue2, BigEndian, Result);
end;

//--------------------------------------------------------------------------------------------------

function Mod2LongWord(RegValue1, RegValue2: Word; BigEndian: Boolean = False): LongWord;
begin
  EncodeBigNumber32(RegValue1, RegValue2, BigEndian, Result);
end;

//--------------------------------------------------------------------------------------------------

function Mod2ScaledFloat(RegValue: Word; Decimals: Integer): Single;
// Converts the value of a single Modbus register denoted by the RegValue to a scaled floating
// point number. Decimals specifies the number of decimal places which is used by a remote server
// when treating the contents of that single register as a scaled floating-point number.
begin
  if Decimals > 0 then
    Result := SmallInt(RegValue) / IntPower(10.0, Decimals)
  else
    Result := SmallInt(RegValue);
end;

//--------------------------------------------------------------------------------------------------

function Mod2Single(RegValue1, RegValue2: Word; BigEndian: Boolean = False): Single;
begin
  EncodeBigNumber32(RegValue1, RegValue2, BigEndian, Result);
end;

//--------------------------------------------------------------------------------------------------

function Mod2Double(RegValue1, RegValue2, RegValue3, RegValue4: Word;
  BigEndian: Boolean = False): Double;
begin
  EncodeBigNumber64(RegValue1, RegValue2, RegValue3, RegValue4, BigEndian, Result);
end;

//--------------------------------------------------------------------------------------------------
// CRC16 calculation support routine
//--------------------------------------------------------------------------------------------------

procedure InitializeCRC16LookupTable;
// Initializes the lookup table used in CRC16 method of TModbusBuffer class.
// Refer to the source of that method for more detailed information.
var
  I, J: Integer;
  TableEntry: Word;
begin
  for I := Low(CRC16LookupTable) to High(CRC16LookupTable) do
  begin
    TableEntry := I;
    for J := 0 to 7 do
      if (TableEntry and $0001) <> 0 then
        TableEntry := (TableEntry shr 1) xor $A001
      else
        TableEntry := TableEntry shr 1;
    CRC16LookupTable[I] := TableEntry;
  end;
end;

//--------------------------------------------------------------------------------------------------

initialization
  GSystemClockResolutionEnhancer := TSystemClockResolutionEnhancer.Create;
  InitializeCRC16LookupTable;

finalization
  FreeAndNil(GSystemClockResolutionEnhancer);

//--------------------------------------------------------------------------------------------------

end.
