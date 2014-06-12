unit EUSignCP;
{$ALIGN OFF}
{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Classes, EncdDecd, SysUtils;

{ ------------------------------------------------------------------------------ }

const
  EU_PASS_MAX_LENGTH = 65;

  EU_ERROR_MAX_LENGTH = 1025;
  EU_SIGNER_INFO_MAX_LENGTH = 1153;

  EU_KEY_MEDIA_NAME_MAX_LENGTH = 257;
  EU_KEY_MEDIA_MAX_TYPES = 32;
  EU_KEY_MEDIA_MAX_DEVICES = 32;

  EU_KEY_MEDIA_SOURCE_TYPE_OPERATOR = 1;
  EU_KEY_MEDIA_SOURCE_TYPE_FIXED = 2;

  EU_PATH_MAX_LENGTH = 1041;
  EU_COMMON_NAME_MAX_LENGTH = 65;
  EU_ADDRESS_MAX_LENGTH = 257;
  EU_PORT_MAX_LENGTH = 6;
  EU_USER_NAME_MAX_LENGTH = 65;

  EU_TYPE_DESC_MAX_LENGTH = 256;
  EU_DEV_DESC_MAX_LENGTH = 256;
  EU_PASSWORD_MAX_LENGTH = 64;
  EU_ISSUER_MAX_LENGTH = 1024;
  EU_SUBJECT_MAX_LENGTH = 1024;
  EU_SERIAL_MAX_LENGTH = 41;
  EU_NAMES_MAX_LENGTH = 128;
  EU_SPECIAL_CODE_MAX_LENGTH = 13;
  EU_OID_MAX_LENGTH = 256;

  EU_SUBJECT_TYPE_UNDIFFERENCED = 0;
  EU_SUBJECT_TYPE_CA = 1;
  EU_SUBJECT_TYPE_CA_SERVER = 2;
  EU_SUBJECT_TYPE_RA_ADMINISTRATOR = 3;
  EU_SUBJECT_TYPE_END_USER = 4;

  EU_SUBJECT_CA_SERVER_SUB_TYPE_UNDIFFERENCED = 0;
  EU_SUBJECT_CA_SERVER_SUB_TYPE_CMP = 1;
  EU_SUBJECT_CA_SERVER_SUB_TYPE_TSP = 2;
  EU_SUBJECT_CA_SERVER_SUB_TYPE_OCSP = 3;

  EU_ERROR_NONE = $0000;
  EU_ERROR_UNKNOWN = $FFFF;
  EU_ERROR_NOT_SUPPORTED = $FFFE;
  EU_ERROR_NOT_INITIALIZED = $0001;
  EU_ERROR_BAD_PARAMETER = $0002;
  EU_ERROR_LIBRARY_LOAD = $0003;
  EU_ERROR_READ_SETTINGS = $0004;
  EU_ERROR_TRANSMIT_REQUEST = $0005;
  EU_ERROR_MEMORY_ALLOCATION = $0006;
  EU_WARNING_END_OF_ENUM = $0007;
  EU_ERROR_PROXY_NOT_AUTHORIZED = $0008;
  EU_ERROR_NO_GUI_DIALOGS = $0009;
  EU_ERROR_DOWNLOAD_FILE = $000A;
  EU_ERROR_WRITE_SETTINGS = $000B;
  EU_ERROR_CANCELED_BY_GUI = $000C;
  EU_ERROR_OFFLINE_MODE = $000D;
  EU_ERROR_KEY_MEDIAS_FAILED = $0011;
  EU_ERROR_KEY_MEDIAS_ACCESS_FAILED = $0012;
  EU_ERROR_KEY_MEDIAS_READ_FAILED = $0013;
  EU_ERROR_KEY_MEDIAS_WRITE_FAILED = $0014;
  EU_WARNING_KEY_MEDIAS_READ_ONLY = $0015;
  EU_ERROR_KEY_MEDIAS_DELETE = $0016;
  EU_ERROR_KEY_MEDIAS_CLEAR = $0017;
  EU_ERROR_BAD_PRIVATE_KEY = $0018;
  EU_ERROR_PKI_FORMATS_FAILED = $0021;
  EU_ERROR_CSP_FAILED = $0022;
  EU_ERROR_BAD_SIGNATURE = $0023;
  EU_ERROR_AUTH_FAILED = $0024;
  EU_ERROR_NOT_RECEIVER = $0025;
  EU_ERROR_STORAGE_FAILED = $0031;
  EU_ERROR_BAD_CERT = $0032;
  EU_ERROR_CERT_NOT_FOUND = $0033;
  EU_ERROR_INVALID_CERT_TIME = $0034;
  EU_ERROR_CERT_IN_CRL = $0035;
  EU_ERROR_BAD_CRL = $0036;
  EU_ERROR_NO_VALID_CRLS = $0037;
  EU_ERROR_GET_TIME_STAMP = $0041;
  EU_ERROR_BAD_TSP_RESPONSE = $0042;
  EU_ERROR_TSP_SERVER_CERT_NOT_FOUND = $0043;
  EU_ERROR_TSP_SERVER_CERT_INVALID = $0044;
  EU_ERROR_GET_OCSP_STATUS = $0051;
  EU_ERROR_BAD_OCSP_RESPONSE = $0052;
  EU_ERROR_CERT_BAD_BY_OCSP = $0053;
  EU_ERROR_OCSP_SERVER_CERT_NOT_FOUND = $0054;
  EU_ERROR_OCSP_SERVER_CERT_INVALID = $0055;
  EU_ERROR_LDAP_ERROR = $0061;

  EU_MAX_BUFFER_SIZE = 100;

  EU_CERT_INFO_EX_VERSION = 2;

  EU_CERT_KEY_TYPE_UNKNOWN  = 0;
  EU_CERT_KEY_TYPE_DSTU4145	= 1;
  EU_CERT_KEY_TYPE_RSA		  = 2;

  EU_KEY_USAGE_UNKNOWN            = $0000;
  EU_KEY_USAGE_DIGITAL_SIGNATURE	= $0001;
  EU_KEY_USAGE_KEY_AGREEMENT		  = $0010;

  EU_KEYS_TYPE_NONE						          = 0;
  EU_KEYS_TYPE_DSTU_AND_ECDH_WITH_GOSTS	= 1;
  EU_KEYS_TYPE_RSA_WITH_SHA				      = 2;

  EU_KEYS_LENGTH_DS_UA_191				= 1;
  EU_KEYS_LENGTH_DS_UA_257			 	= 2;
  EU_KEYS_LENGTH_DS_UA_307			 	= 3;
  EU_KEYS_LENGTH_DS_UA_FILE		 		= 4;

  EU_KEYS_LENGTH_KEP_UA_257				= 1;
  EU_KEYS_LENGTH_KEP_UA_431				= 2;
  EU_KEYS_LENGTH_KEP_UA_571				= 3;
  EU_KEYS_LENGTH_KEP_UA_FILE			= 4;

  EU_KEYS_LENGTH_DS_RSA_1024		  = 1;
  EU_KEYS_LENGTH_DS_RSA_2048		 	= 2;
  EU_KEYS_LENGTH_DS_RSA_3072		 	= 3;
  EU_KEYS_LENGTH_DS_RSA_4096		 	= 4;
  EU_KEYS_LENGTH_DS_RSA_FILE	 		= 5;

{ ------------------------------------------------------------------------------ }

type
  PPAnsiChar = ^PAnsiChar;
  PPByte = ^PByte;
  PPointer = array of Pointer;
  PLongBool = ^LongBool;
  PVOID = Pointer;
  PPVOID = ^PVOID;

type
  PEUKeyMedia = ^TEUKeyMedia;

  TEUKeyMedia = record
    TypeIndex, DeviceIndex: Cardinal;

    Password: array [0 .. EU_PASS_MAX_LENGTH - 1] of AnsiChar;
  end;

type
  PEUCertOwnerInfo = ^TEUCertOwnerInfo;

  TEUCertOwnerInfo = record
    Filled: LongBool;

    Issuer, IssuerCN, Serial: PAnsiChar;

    Subject, SubjectCN, SubjectOrg, SubjectOrgUnit, SubjectTitle, SubjectState,
      SubjectLocality, SubjectFullName, SubjectAddress, SubjectPhone,
      SubjectEMail, SubjectDNS, SubjectEDRPOUCode, SubjectDRFOCode: PAnsiChar;
  end;

type
  PEUSignInfo = ^TEUSignInfo;

  TEUSignInfo = record
    Filled: LongBool;

    Issuer, IssuerCN, Serial: PAnsiChar;

    Subject, SubjectCN, SubjectOrg, SubjectOrgUnit, SubjectTitle, SubjectState,
      SubjectLocality, SubjectFullName, SubjectAddress, SubjectPhone,
      SubjectEMail, SubjectDNS, SubjectEDRPOUCode, SubjectDRFOCode: PAnsiChar;

    bTime, bTimeStamp: LongBool;

    Time: TSystemTime;
  end;

type
 PEUEnvelopInfo = ^TEUSignInfo;
 TEUEnvelopInfo = TEUSignInfo;

type
  PEUCRLInfo = ^TEUCRLInfo;

  TEUCRLInfo = record
    Filled: LongBool;

    Issuer, IssuerCN: PAnsiChar;

    CRLNumber: Cardinal;

    ThisUpdate, NextUpdate: TSystemTime;
  end;

type
  PEUCertInfo = ^TEUCertInfo;

  TEUCertInfo = record
    Filled: LongBool;

    Version: Cardinal;

    Issuer, IssuerCN, Serial: PAnsiChar;

    Subject, SubjCN, SubjOrg, SubjOrgUnit, SubjTitle, SubjState, SubjLocality,
      SubjFullName, SubjAddress, SubjPhone, SubjEMail, SubjDNS, SubjEDRPOUCode,
      SubjDRFOCode: PAnsiChar;

    SubjNBUCode, SubjSPFMCode, SubjOCode, SubjOUCode, SubjUserCode: PAnsiChar;

    CertBeginTime, CertEndTime: TSystemTime;
    PrivKeyTimesExists: LongBool;
    PrivKeyBeginTime, PrivKeyEndTime: TSystemTime;

    PublicKeyBits: Cardinal;
    PublicKey, PublicKeyID: PAnsiChar;

    ECDHPublicKeyExists: LongBool;
    ECDHPublicKeyBits: Cardinal;
    ECDHPublicKey, ECDHPublicKeyID: PAnsiChar;

    IssuerPublicKeyID: PAnsiChar;

    KeyUsage, ExtKeyUsages, Policies: PAnsiChar;

    CRLDistribPoint1, CRLDistribPoint2: PAnsiChar;

    PowerCert: LongBool;

    SubjType, SubjCA: LongBool;
  end;

  PEUCertInfoEx = ^TEUCertInfoEx;
  TEUCertInfoEx = record
    Filled: LongBool;

    Version: Cardinal;

    Issuer, IssuerCN, Serial: PAnsiChar;

    Subject, SubjCN, SubjOrg, SubjOrgUnit, SubjTitle, SubjState, SubjLocality,
      SubjFullName, SubjAddress, SubjPhone, SubjEMail, SubjDNS, SubjEDRPOUCode,
      SubjDRFOCode: PAnsiChar;

    SubjNBUCode, SubjSPFMCode, SubjOCode, SubjOUCode, SubjUserCode: PAnsiChar;

    CertBeginTime, CertEndTime: TSystemTime;
    PrivKeyTimesExists: LongBool;
    PrivKeyBeginTime, PrivKeyEndTime: TSystemTime;

    PublicKeyBits: Cardinal;
    PublicKey, PublicKeyID: PAnsiChar;

    IssuerPublicKeyID: PAnsiChar;

    KeyUsage, ExtKeyUsages, Policies: PAnsiChar;

    CRLDistribPoint1, CRLDistribPoint2: PAnsiChar;

    PowerCert: LongBool;

    SubjType, SubjCA: LongBool;

    ChainLength: Integer;

    UPN:  PAnsiChar;

    PublicKeyType: Cardinal;
    KeyUsageType: Cardinal;
    RSAModul, RSAExponent: PAnsiChar;

	  OCSPAccessInfo,	IssuerAccessInfo, TSPAccessInfo: PAnsiChar;

	  LimitValueAvailable: LongBool;
	  LimitValue: Cardinal;
	  LimitValueCurrency: PAnsiChar;

  end;
  PPEUCertInfoEx = ^PEUCertInfoEx;

type
  PEUCRLDetailedInfo = ^TEUCRLDetailedInfo;

  TEUCRLDetailedInfo = record
    Filled: LongBool;

    Version: Cardinal;

    Issuer, IssuerCN, IssuerPublicKeyID: PAnsiChar;

    CRLNumber: Cardinal;
    ThisUpdate, NextUpdate: TSystemTime;

    RevokedItemsCount: Cardinal;
  end;

type
  PEUCertificates = ^TEUCertificates;
  TEUCertificates = record
    Count: Cardinal;

    Certificates: array of PEUCertInfoEx;
  end;
  PPEUCertificates = ^PEUCertificates;

type
  PEUCertificatesUniqueInfo = ^TEUCertificatesUniqueInfo;
  TEUCertificatesUniqueInfo = record
    Issuers: array of AnsiString;
    Serials: array of AnsiString;
  end;

type
  PEUSettingsFileStore = ^TEUSettingsFileStore;

  TEUSettingsFileStore = record
    Path: Array [0 .. (EU_PATH_MAX_LENGTH-1)] of AnsiChar;
    AutoRefresh: LongBool;
    SaveLoadedCerts: LongBool;
    CheckCRLs: LongBool;
    OwnCRLsOnly: LongBool;
    FullAndDeltaCRLs: LongBool;
    AutoDownloadCRLs: LongBool;
    ExpireTime: Cardinal;
  end;

  PEUSettingsProxy = ^TEUSettingsProxy;

  TEUSettingsProxy = record
    UseProxy, Anonymous: LongBool;
    Address: Array [0 .. (EU_ADDRESS_MAX_LENGTH-1)] of AnsiChar;
    Port: Array [0 .. (EU_PORT_MAX_LENGTH-1)] of AnsiChar;
    User: Array [0 .. (EU_USER_NAME_MAX_LENGTH-1)] of AnsiChar;
    Password: Array [0 .. (EU_PASSWORD_MAX_LENGTH-1)] of AnsiChar;
    SavePassword: LongBool;
  end;

  PEUSettingsTSP = ^TEUSettingsTSP;

  TEUSettingsTSP = record
    GetStamps: LongBool;
    Address: Array [0 .. (EU_ADDRESS_MAX_LENGTH-1)] of AnsiChar;
    Port: Array [0 .. (EU_PORT_MAX_LENGTH-1)] of AnsiChar;
  end;

  PEUSettingsOCSP = ^TEUSettingsOCSP;

  TEUSettingsOCSP = record
    UseOCSP: LongBool;
    BeforeStore: LongBool;
    Address: Array [0 .. (EU_ADDRESS_MAX_LENGTH-1)] of AnsiChar;
    Port: Array [0 .. (EU_PORT_MAX_LENGTH-1)] of AnsiChar;
  end;

  PEUSettingsLDAP = ^TEUSettingsLDAP;

  TEUSettingsLDAP = record
    UseLDAP: LongBool;
    Address: Array [0 .. (EU_ADDRESS_MAX_LENGTH-1)] of AnsiChar;
    Port: Array [0 .. (EU_PORT_MAX_LENGTH-1)] of AnsiChar;
    Anonymous: LongBool;
    User: Array [0 .. (EU_USER_NAME_MAX_LENGTH-1)] of AnsiChar;
    Password: Array [0 .. (EU_PASSWORD_MAX_LENGTH-1)] of AnsiChar;
  end;

  PEUSettingsCMP = ^TEUSettingsCMP;

  TEUSettingsCMP = record
    UseCMP: LongBool;
    Address: Array [0 ..( EU_ADDRESS_MAX_LENGTH-1)] of AnsiChar;
    Port: Array [0 .. (EU_PORT_MAX_LENGTH-1)] of AnsiChar;
    Name: Array [0 .. (EU_USER_NAME_MAX_LENGTH-1)] of AnsiChar;
  end;

  PEUCRInfo = ^TEUCRInfo;
  TEUCRInfo = record
    Filled: LongBool;

    Version: Cardinal;

    Simple: LongBool;

    Subject, SubjCN, SubjOrg, SubjOrgUnit, SubjTitle, SubjState, SubjLocality,
      SubjFullName, SubjAddress, SubjPhone, SubjEMail, SubjDNS, SubjEDRPOUCode,
      SubjDRFOCode: PAnsiChar;

    SubjNBUCode, SubjSPFMCode, SubjOCode, SubjOUCode, SubjUserCode: PAnsiChar;

    CertTimesExists: LongBool;
    CertBeginTime, CertEndTime: TSystemTime;
    PrivKeyTimesExists: LongBool;
    PrivKeyBeginTime, PrivKeyEndTime: TSystemTime;

    PublicKeyType: Cardinal;

    PublicKeyBits: Cardinal;
    PublicKey, RSAModul, RSAExponent: PAnsiChar;
    PublicKeyID: PAnsiChar;

    ExtKeyUsages: PAnsiChar;

    CRLDistribPoint1, CRLDistribPoint2: PAnsiChar;

    SubjTypeExists: LongBool;
    SubjType, SubjSubType: Cardinal;

    SelfSigned: LongBool;
    SignIssuer, SignSerial: PAnsiChar;
  end;
  PPEUCRInfo = ^PEUCRInfo;

type
  TEUInitialize = function(): Cardinal; stdcall;
  TEUIsInitialized = function(): LongBool; stdcall;
  TEUFinalize = procedure; stdcall;

  TEUSetSettings = procedure; stdcall;
  TEUShowCertificates = procedure; stdcall;
  TEUShowCRLs = procedure; stdcall;

  TEUGetPrivateKeyMedia = function(KeyMedia: PEUKeyMedia): Cardinal; stdcall;
  TEUReadPrivateKey = function(KeyMedia: PEUKeyMedia; Info: PEUCertOwnerInfo)
    : Cardinal; stdcall;
  TEUIsPrivateKeyReaded = function(): LongBool; stdcall;
  TEUResetPrivateKey = procedure; stdcall;
  TEUFreeCertOwnerInfo = procedure(Info: PEUCertOwnerInfo); stdcall;

  TEUShowOwnCertificate = procedure; stdcall;
  TEUShowSignInfo = procedure(Info: PEUSignInfo); stdcall;
  TEUFreeSignInfo = procedure(Info: PEUSignInfo); stdcall;

  TEUFreeMemory = procedure(Memory: PByte); stdcall;

  TEUGetErrorDesc = function(Error: Cardinal): PAnsiChar; stdcall;

  TEUSignData = function(Data: PByte; DataLength: Cardinal;
    SignString: PPAnsiChar; SignBinary: PPByte; SignBinaryLength: PCardinal)
    : Cardinal; stdcall;
  TEUVerifyData = function(Data: PByte; DataLength: Cardinal;
    SignString: PAnsiChar; SignBinary: PByte; SignBinaryLength: Cardinal;
    Info: PEUSignInfo): Cardinal; stdcall;

  TEUSignDataContinue = function(Data: PByte; DataLength: Cardinal)
    : Cardinal; stdcall;
  TEUSignDataEnd = function(SignString: PPAnsiChar; SignBinary: PPByte;
    SignBinaryLength: PCardinal): Cardinal; stdcall;
  TEUVerifyDataBegin = function(SignString: PAnsiChar; SignBinary: PByte;
    SignBinaryLength: Cardinal): Cardinal; stdcall;
  TEUVerifyDataContinue = function(Data: PByte; DataLength: Cardinal)
    : Cardinal; stdcall;
  TEUVerifyDataEnd = function(Info: PEUSignInfo): Cardinal; stdcall;
  TEUResetOperation = procedure; stdcall;

  TEUSignFile = function(FileName, FileNameWithSign: PAnsiChar;
    ExternalSign: LongBool): Cardinal; stdcall;
  TEUVerifyFile = function(FileNameWithSign, FileName: PAnsiChar;
    Info: PEUSignInfo): Cardinal; stdcall;

  TEUSignDataInternal = function(AppendCert: LongBool; Data: PByte;
    DataLength: Cardinal; SignedDataString: PPAnsiChar;
    SignedDataBinary: PPByte; SignedDataBinaryLength: PCardinal)
    : Cardinal; stdcall;
  TEUVerifyDataInternal = function(SignedDataString: PAnsiChar;
    SignedDataBinary: PByte; SignDataBinaryLength: Cardinal; Data: PPByte;
    DataLength: PCardinal; Info: PEUSignInfo): Cardinal; stdcall;

  TEUSelectCertInfo = function(Info: PEUCertOwnerInfo): Cardinal; stdcall;

  TEUSetUIMode = procedure(UIMode: LongBool); stdcall;

  TEUHashData = function(Data: PByte; DataLength: Cardinal;
    HashString: PPAnsiChar; HashBinary: PPByte; HashBinaryLength: PCardinal)
    : Cardinal; stdcall;
  TEUHashDataContinue = function(Data: PByte; DataLength: Cardinal)
    : Cardinal; stdcall;
  TEUHashDataEnd = function(HashString: PPAnsiChar; HashBinary: PPByte;
    HashBinaryLength: PCardinal): Cardinal; stdcall;
  TEUHashFile = function(FileName: PAnsiChar; HashString: PPAnsiChar;
    HashBinary: PPByte; HashBinaryLength: PCardinal): Cardinal; stdcall;
  TEUSignHash = function(HashString: PAnsiChar; HashBinary: PByte;
    HashBinaryLength: Cardinal; SignString: PPAnsiChar; SignBinary: PPByte;
    SignBinaryLength: PCardinal): Cardinal; stdcall;
  TEUVerifyHash = function(HashString: PAnsiChar; HashBinary: PByte;
    HashBinaryLength: Cardinal; SignString: PAnsiChar; SignBinary: PByte;
    SignBinaryLength: Cardinal; Info: PEUSignInfo): Cardinal; stdcall;

  TEUEnumKeyMediaTypes = function(TypeIndex: Cardinal;
    TypeDescription: PAnsiChar): Cardinal; stdcall;
  TEUEnumKeyMediaDevices = function(TypeIndex, DeviceIndex: Cardinal;
    DeviceDescription: PAnsiChar): Cardinal; stdcall;

  TEUGetFileStoreSettings = function(Path: PAnsiChar;
    CheckCRLs, AutoRefresh, OwnCRLsOnly, FullAndDeltaCRLs, AutoDownloadCRLs,
    SaveLoadedCerts: PLongBool; ExpireTime: PCardinal): Cardinal; stdcall;
  TEUSetFileStoreSettings = function(Path: PAnsiChar;
    CheckCRLs, AutoRefresh, OwnCRLsOnly, FullAndDeltaCRLs, AutoDownloadCRLs,
    SaveLoadedCerts: LongBool; ExpireTime: Cardinal): Cardinal; stdcall;
  TEUGetProxySettings = function(UseProxy, Anonymous: PLongBool;
    Address, Port, User, Password: PAnsiChar; SavePassword: PLongBool)
    : Cardinal; stdcall;
  TEUSetProxySettings = function(UseProxy, Anonymous: LongBool;
    Address, Port, User, Password: PAnsiChar; SavePassword: LongBool)
    : Cardinal; stdcall;
  TEUGetOCSPSettings = function(UseOCSP, BeforeStore: PLongBool;
    Address, Port: PAnsiChar): Cardinal; stdcall;
  TEUSetOCSPSettings = function(UseOCSP, BeforeStore: LongBool;
    Address, Port: PAnsiChar): Cardinal; stdcall;
  TEUGetTSPSettings = function(GetStamps: PLongBool; Address, Port: PAnsiChar)
    : Cardinal; stdcall;
  TEUSetTSPSettings = function(GetStamps: LongBool; Address, Port: PAnsiChar)
    : Cardinal; stdcall;
  TEUGetLDAPSettings = function(UseLDAP: PLongBool; Address, Port: PAnsiChar;
    Anonymous: PLongBool; User, Password: PAnsiChar): Cardinal; stdcall;
  TEUSetLDAPSettings = function(UseLDAP: LongBool; Address, Port: PAnsiChar;
    Anonymous: LongBool; User, Password: PAnsiChar): Cardinal; stdcall;
  TEUGetCMPSettings = function(UseCMP: PLongBool;
    Address, Port, CommonName: PAnsiChar): Cardinal; stdcall;
  TEUSetCMPSettings = function(UseCMP: LongBool;
    Address, Port, CommonName: PAnsiChar): Cardinal; stdcall;
  TEUDoesNeedSetSettings = function(): LongBool; stdcall;

  TEUGetCertificatesCount = function(SubjectType, SubjectSubType: Cardinal;
    Count: PCardinal): Cardinal; stdcall;
  TEUEnumCertificates = function(SubjectType, SubjectSubType, Index: Cardinal;
    Info: PEUCertOwnerInfo): Cardinal; stdcall;
  TEUGetCRLsCount = function(Count: PCardinal): Cardinal; stdcall;
  TEUEnumCRLs = function(Index: Cardinal; Info: PEUCRLInfo): Cardinal; stdcall;
  TEUFreeCRLInfo = procedure(Info: PEUCRLInfo); stdcall;

  TEUGetCertificateInfo = function(Issuer, Serial: PAnsiChar; Info: PEUCertInfo)
    : Cardinal; stdcall;
  TEUFreeCertificateInfo = procedure(Info: PEUCertInfo); stdcall;
  TEUGetCRLDetailedInfo = function(Issuer: PAnsiChar; CRLNumber: Cardinal;
    Info: PEUCRLDetailedInfo): Cardinal; stdcall;
  TEUFreeCRLDetailedInfo = procedure(Info: PEUCRLDetailedInfo); stdcall;

  TEUGetPrivateKeyMediaSettings = function(SourceType: PCardinal;
    ShowErrors: PLongBool; TypeIndex, DevIndex: PCardinal; Password: PAnsiChar)
    : Cardinal; stdcall;
  TEUSetPrivateKeyMediaSettings = function(SourceType: Cardinal;
    ShowErrors: LongBool; TypeIndex, DevIndex: Cardinal; Password: PAnsiChar)
    : Cardinal; stdcall;

  TEUSelectCMPServer = function(CommonName, DNS: PAnsiChar): Cardinal; stdcall;

  TEURawSignData = function(Data: PByte; DataLength: Cardinal;
    SignString: PPAnsiChar; SignBinary: PPByte; SignBinaryLength: PCardinal)
    : Cardinal; stdcall;
  TEURawVerifyData = function(Data: PByte; DataLength: Cardinal;
    SignString: PAnsiChar; SignBinary: PByte; SignBinaryLength: Cardinal;
    Info: PEUSignInfo): Cardinal; stdcall;
  TEURawSignHash = function(HashString: PAnsiChar; HashBinary: PByte;
    HashBinaryLength: Cardinal; SignString: PPAnsiChar; SignBinary: PPByte;
    SignBinaryLength: PCardinal): Cardinal; stdcall;
  TEURawVerifyHash = function(HashString: PAnsiChar; HashBinary: PByte;
    HashBinaryLength: Cardinal; SignString: PAnsiChar; SignBinary: PByte;
    SignBinaryLength: Cardinal; Info: PEUSignInfo): Cardinal; stdcall;
  TEURawSignFile = function(FileName, FileNameWithSign: PAnsiChar)
    : Cardinal; stdcall;
  TEURawVerifyFile = function(FileNameWithSign, FileName: PAnsiChar;
    Info: PEUSignInfo): Cardinal; stdcall;

  TEUBase64Encode = function(Data: PByte; DataLength: Cardinal;
    DataString: PPAnsiChar): Cardinal; stdcall;
  TEUBase64Decode = function(DataString: PAnsiChar; Data: PPByte;
    DataLength: PCardinal): Cardinal; stdcall;

  TEUEnvelopData = function(RecipientCertIssuer, RecipientCertSerial: PAnsiChar;
    SignData: LongBool; Data: PByte; DataLength: Cardinal;
    EnvelopedString: PPAnsiChar; EnvelopedBinary: PPByte;
    EnvelopedBinaryLength: PCardinal): Cardinal; stdcall;
  TEUDevelopData = function(EnvelopedString: PAnsiChar; EnvelopedBinary: PByte;
    EnvelopedBinaryLength: Cardinal; Data: PPByte; DataLength: PCardinal;
    Info: PEUEnvelopInfo): Cardinal; stdcall;
  TEUShowSenderInfo = procedure(Info: PEUEnvelopInfo); stdcall;
  TEUFreeSenderInfo = procedure(Info: PEUEnvelopInfo); stdcall;

  TEUParseCertificate = function(Certificate: PByte; CertificateLength: Cardinal;
    Info: PEUCertInfo): Cardinal; stdcall;

  TEUReadPrivateKeyBinary = function(PrivateKey: PByte; PrivateKeyLength: Cardinal;
    Password: PAnsiChar; Info: PEUCertOwnerInfo): Cardinal; stdcall;
  TEUReadPrivateKeyFile = function(PrivateKeyFileName, Password: PAnsiChar;
    Info: PEUCertOwnerInfo): Cardinal; stdcall;

  TEUSessionDestroy = procedure(Session: PVOID); stdcall;
  TEUClientSessionCreateStep1 = function(ExpireTime: Cardinal;
    ClientSession: PPVOID; ClientData: PPByte; ClientDataLength: PCardinal):
    Cardinal; stdcall;
  TEUServerSessionCreateStep1 = function(ExpireTime: Cardinal;
    ClientData: PByte; ClientDataLength: Cardinal; ServerSession: PPVOID;
    ServerData: PPByte; ServerDataLength: PCardinal): Cardinal; stdcall;
  TEUClientSessionCreateStep2 = function(ClientSession: PVOID;
    ServerData: PByte; ServerDataLength: Cardinal; ClientData: PPByte;
    ClientDataLength: PCardinal): Cardinal; stdcall;
  TEUServerSessionCreateStep2 = function(ServerSession: PVOID;
    ClientData: PByte; ClientDataLength: Cardinal): Cardinal; stdcall;
  TEUSessionIsInitialized = function(Session: PVOID): LongBool; stdcall;
  TEUSessionSave = function(Session: PVOID; SessionData: PPByte;
    SessionDataLength: PCardinal): Cardinal; stdcall;
  TEUSessionLoad = function(SessionData: PByte;
    SessionDataLength: Cardinal; Session: PPVOID): Cardinal; stdcall;
  TEUSessionCheckCertificates = function(Session: PVOID): LongBool; stdcall;

  TEUSessionEncrypt = function(Session: PVOID;
    Data: PByte; DataLength: Cardinal; EncryptedData: PPByte;
    EncryptedDataLength: PCardinal): Cardinal; stdcall;
  TEUSessionEncryptContinue = function(Session: PVOID;
    Data: PByte; DataLength: Cardinal): Cardinal; stdcall;
  TEUSessionDecrypt = function(Session: PVOID;
    EncryptedData: PByte; EncryptedDataLength: Cardinal; Data: PPByte;
    DataLength: PCardinal): Cardinal; stdcall;
  TEUSessionDecryptContinue = function(Session: PVOID;
    EncryptedData: PByte; EncryptedDataLength: Cardinal): Cardinal; stdcall;

  TEUIsSignedData = function(Data: PByte; DataLength: Cardinal): LongBool; stdcall;
  TEUIsEnvelopedData = function(Data: PByte; DataLength: Cardinal): LongBool; stdcall;

  TEUSessionGetPeerCertificateInfo = function(Session: PVOID; Info: PEUCertInfo)
    : Cardinal; stdcall;

  TEUSaveCertificate = function(Certificate: PByte; CertificateLength: Cardinal)
    : Cardinal; stdcall;
  TEURefreshFileStore = function(Reload: LongBool): Cardinal; stdcall;

  TEUGetModeSettings = function(OfflineMode: PLongBool): Cardinal; stdcall;
  TEUSetModeSettings = function(OfflineMode: LongBool): Cardinal; stdcall;

  TEUCheckCertificate = function(Certificate: PByte; CertificateLength: Cardinal) :
    Cardinal; stdcall;

  TEUEnvelopFile = function(RecipientCertIssuer, RecipientCertSerial: PAnsiChar;
    SignData: LongBool; FileName, EnvelopedFileName: PAnsiChar): Cardinal; stdcall;
  TEUDevelopFile = function(EnvelopedFileName, FileName: PAnsiChar;
    Info: PEUEnvelopInfo): Cardinal; stdcall;

  TEUIsSignedFile = function(FileName: PAnsiChar): LongBool; stdcall;
  TEUIsEnvelopedFile = function(FileName: PAnsiChar): LongBool; stdcall;

  TEUGetCertificate = function(Issuer, Serial: PAnsiChar;
    CertificateString: PPAnsiChar; CertificateBinary: PPByte;
    CertificateBinaryLength: PCardinal): Cardinal; stdcall;
  TEUGetOwnCertificate = function( CertificateString: PPAnsiChar;
    CertificateBinary: PPByte; CertificateBinaryLength: PCardinal)
    : Cardinal; stdcall;

  TEUEnumOwnCertificates = function(Index: Cardinal; Info: PPEUCertInfoEx):
    Cardinal; stdcall;
  TEUGetCertificateInfoEx = function(Issuer, Serial: PAnsiChar; Info: PPEUCertInfoEx)
    : Cardinal; stdcall;
  TEUFreeCertificateInfoEx =  procedure(Info: PEUCertInfoEx); stdcall;

  TEUGetReceiversCertificates = function(Certificates: PPEUCertificates)
    : Cardinal; stdcall;
  TEUFreeReceiversCertificates = procedure(Certificates: PEUCertificates); stdcall;

  TEUGeneratePrivateKey = function(KeyMedia: PEUKeyMedia;
    UAKeysType, UADSKeysSpec, UAKEPKeysSpec: Cardinal; UAParamsPath: PAnsiChar;
    InternationalKeysType, InternationalKeysSpec: Cardinal;
    InternationalParamsPath: PAnsiChar;
    PrivKey: PPByte; PrivKeyLength: PCardinal;
    PrivKeyInfo: PPByte; PrivKeyInfoLength: PCardinal;
    UARequest: PPByte; UARequestLength: PCardinal; UAReqFileName: PAnsiChar;
    UAKEPRequest: PPByte; UAKEPRequestLength: PCardinal;
    UAKEPReqFileName: PAnsiChar;
    InternationalRequest: PPByte; InternationalRequestLength: PCardinal;
    InternationalReqFileName: PAnsiChar)
    : Cardinal; stdcall;

    TEUChangePrivateKeyPassword = function(KeyMedia: PEUKeyMedia;
      NewPassword: PAnsiChar) : Cardinal; stdcall;

    TEUBackupPrivateKey = function(SourceKeyMedia, TargetKeyMedia: PEUKeyMedia)
      : Cardinal; stdcall;

    TEUDestroyPrivateKey = function(KeyMedia: PEUKeyMedia) : Cardinal; stdcall;

    TEUIsHardwareKeyMedia = function(KeyMedia: PEUKeyMedia; IsHardware: PLongBool)
      : Cardinal; stdcall;

    TEUIsPrivateKeyExists = function(KeyMedia: PEUKeyMedia; Exists: PLongBool)
      : Cardinal; stdcall;

    TEUGetCRInfo = function(Request: PByte; RequestLength: Cardinal;
      Info: PPEUCRInfo) : Cardinal; stdcall;

    TEUFreeCRInfo = procedure(Info: PEUCRInfo); stdcall;

    TEUSaveCertificates = function(Certificates: PByte;
      CertificatesLength: Cardinal) : Cardinal; stdcall;

    TEUSaveCRL = function(FullCRL: LongBool; CRL: PByte;
      CRLLength: Cardinal) : Cardinal; stdcall;

    TEUGetCertificateByEMail = function(Email: PAnsiChar;
      CertKeyType, KeyUsage: Cardinal; OnTime: PSystemTime;
      Issuer, Serial: PAnsiChar) : Cardinal; stdcall;

    TEUGetCertificateByNBUCode = function(NBUCode: PAnsiChar;
      CertKeyType, KeyUsage: Cardinal; OnTime: PSystemTime;
      Issuer, Serial: PAnsiChar) : Cardinal; stdcall;

    TEUAppendSign = function(Data: PByte; DataLength: Cardinal;
      PreviousSignString: PAnsiChar; PreviousSignBinary: PByte;
      PreviousSignBinaryLength: Cardinal;
      SignString: PPAnsiChar; SignBinary: PPByte; SignBinaryLength: PCardinal)
      : Cardinal; stdcall;
    TEUAppendSignInternal = function(AppendCert: LongBool;
      PreviousSignString: PAnsiChar; PreviousSignBinary: PByte;
      PreviousSignBinaryLength: Cardinal;
      SignedDataString: PPAnsiChar; SignedDataBinary: PPByte;
      SignedDataBinaryLength: PCardinal) : Cardinal; stdcall;
    TEUVerifyDataSpecific = function(Data: PByte; DataLength: Cardinal;
      SignIndex: Cardinal;
      SignString: PAnsiChar; SignBinary: PByte; SignBinaryLength: Cardinal;
      Info: PEUSignInfo): Cardinal; stdcall;
    TEUVerifyDataInternalSpecific = function(SignIndex: Cardinal;
      SignedDataString: PAnsiChar; SignedDataBinary: PByte;
      SignDataBinaryLength: Cardinal; Data: PPByte; DataLength: PCardinal;
      Info: PEUSignInfo): Cardinal; stdcall;
    TEUAppendSignBegin = function(PreviousSignString: PAnsiChar;
      PreviousSignBinary: PByte; PreviousSignBinaryLength: Cardinal)
      : Cardinal; stdcall;
    TEUVerifyDataSpecificBegin = function(SignIndex: Cardinal;
      SignString: PAnsiChar; SignBinary: PByte; SignBinaryLength: Cardinal)
      : Cardinal; stdcall;

    TEUAppendSignFile = function(FileName, FileNameWithPreviousSign,
      FileNameWithSign: PAnsiChar; ExternalSign: LongBool): Cardinal; stdcall;
    TEUVerifyFileSpecific = function(SignIndex: Cardinal;
      FileNameWithSign, FileName: PAnsiChar; Info: PEUSignInfo)
      : Cardinal; stdcall;

    TEUAppendSignHash = function(HashString: PAnsiChar; HashBinary: PByte;
      HashBinaryLength: Cardinal; PreviousSignString: PAnsiChar;
      PreviousSignBinary: PByte; PreviousSignBinaryLength: Cardinal;
      SignString: PPAnsiChar; SignBinary: PPByte; SignBinaryLength: PCardinal)
      : Cardinal; stdcall;
    TEUVerifyHashSpecific = function(HashString: PAnsiChar; HashBinary: PByte;
      HashBinaryLength: Cardinal; SignIndex: Cardinal; SignString: PAnsiChar;
      SignBinary: PByte; SignBinaryLength: Cardinal; Info: PEUSignInfo)
      : Cardinal; stdcall;

    TEUGetSignsCount = function(SignString: PAnsiChar; SignBinary: PByte;
      SignBinaryLength: Cardinal; Count: PCardinal): Cardinal; stdcall;
    TEUGetSignerInfo = function(SignIndex: Cardinal; SignString: PAnsiChar;
      SignBinary: PByte; SignBinaryLength: Cardinal;
      CertInfo: PPEUCertInfoEx; Certificate: PPByte;
      CertificateLength: Cardinal): Cardinal; stdcall;
    TEUGetFileSignsCount = function(FileNameWithSign: PAnsiChar;
      Count: PCardinal) : Cardinal; stdcall;
    TEUGetFileSignerInfo = function(SignIndex: Cardinal;
      FileNameWithSign: PAnsiChar; CertInfo: PPEUCertInfoEx; Certificate: PPByte;
      CertificateLength: Cardinal): Cardinal; stdcall;

    TEUIsAlreadySigned = function(SignString: PAnsiChar; SignBinary: PByte;
      SignBinaryLength: Cardinal; IsAlreadySigned: PLongBool): Cardinal; stdcall;
    TEUIsFileAlreadySigned = function(FileNameWithSign: PAnsiChar;
      IsAlreadySigned: PLongBool): Cardinal; stdcall;

    TEUHashDataWithParams = function(Certificate: PByte;
      CertificateLength: Cardinal; Data: PByte; DataLength: Cardinal;
      HashString: PPAnsiChar; HashBinary: PPByte; HashBinaryLength: PCardinal)
      : Cardinal; stdcall;
    TEUHashDataBeginWithParams = function(Certificate: PByte;
      CertificateLength: Cardinal): Cardinal; stdcall;
    TEUHashFileWithParams = function(Certificate: PByte;
      CertificateLength: Cardinal; FileName: PAnsiChar; HashString: PPAnsiChar;
      HashBinary: PPByte; HashBinaryLength: PCardinal): Cardinal; stdcall;

    TEUEnvelopDataEx = function(RecipientCertIssuers,
      RecipientCertSerials: PAnsiChar; SignData: LongBool;
      Data: PByte; DataLength: Cardinal;
      EnvelopedString: PPAnsiChar; EnvelopedBinary: PPByte;
      EnvelopedBinaryLength: PCardinal): Cardinal; stdcall;

    TEUSetSettingsFilePath = function(SettingsFilePath: PAnsiChar)
      : Cardinal; stdcall;

    TEUGetErrorLangDesc = function(Error, Lang: Cardinal): PAnsiChar;

    TEUEnvelopFileEx = function(RecipientCertIssuers,
      RecipientCertSerials: PAnsiChar; SignData: LongBool;
      FileName, EnvelopedFileName: PAnsiChar): Cardinal; stdcall;

    TEUIsCertificates = function(Certificates: PByte;
      CertificatesLength: Cardinal): Cardinal; stdcall;

    TEUIsCertificatesFile = function(FileName: PAnsiChar)
      : Cardinal; stdcall;

    TEUEnumCertificatesByOCode = function(OCode: PAnsiChar;
      CertKeyType, KeyUsage: Cardinal; OnTime: PSystemTime; Index: Cardinal;
      Issuer, Serial: PAnsiChar) : Cardinal; stdcall;

    TEUGetCertificatesByOCode = function(OCode: PAnsiChar;
      CertKeyType, KeyUsage: Cardinal; OnTime: PSystemTime;
      IssuersCount, SerialsCount: PCardinal;
      Issuers, Serials: PAnsiChar) : Cardinal; stdcall;

    TEUSetPrivateKeyMediaSettingsProtected = function(SourceType: Cardinal;
      ShowErrors: LongBool; TypeIndex, DevIndex: Cardinal; Password: PAnsiChar;
      Runtime: LongBool): Cardinal; stdcall;

    TEUEnvelopDataToRecipients = function(RecipientCertsCount: Cardinal;
      RecipientCerts: PPByte; RecipientCertsLength: PCardinal;
      SignData: LongBool;
      Data: PByte; DataLength: Cardinal;
      EnvelopedString: PPAnsiChar; EnvelopedBinary: PPByte;
      EnvelopedBinaryLength: PCardinal): Cardinal; stdcall;

    TEUEnvelopFileToRecipients = function(RecipientCertsCount: Cardinal;
      RecipientCerts: PPByte; RecipientCertsLength: PCardinal;
      SignData: LongBool;
      FileName, EnvelopedFileName: PAnsiChar): Cardinal; stdcall;

    TEUEnvelopDataExWithDynamicKey = function(
      RecipientCertIssuers, RecipientCertSerials: PAnsiChar;
      SignData, AppendCert: LongBool;
      Data: PByte; DataLength: Cardinal;
      EnvelopedString: PPAnsiChar; EnvelopedBinary: PPByte;
      EnvelopedBinaryLength: PCardinal): Cardinal; stdcall;

    TEUEnvelopDataToRecipientsWithDynamicKey = function(
      RecipientCertsCount: Cardinal; RecipientCerts: PPByte;
      RecipientCertsLength: PCardinal;
      SignData, AppendCert: LongBool;
      Data: PByte; DataLength: Cardinal;
      EnvelopedString: PPAnsiChar; EnvelopedBinary: PPByte;
      EnvelopedBinaryLength: PCardinal): Cardinal; stdcall;

    TEUEnvelopFileExWithDynamicKey = function(
      RecipientCertIssuers, RecipientCertSerials: PAnsiChar;
      SignData, AppendCert: LongBool;
      FileName, EnvelopedFileName: PAnsiChar): Cardinal; stdcall;

    TEUEnvelopFileToRecipientsWithDynamicKey = function(
      RecipientCertsCount: Cardinal;
      RecipientCerts: PPByte; RecipientCertsLength: PCardinal;
      SignData, AppendCert: LongBool;
      FileName, EnvelopedFileName: PAnsiChar): Cardinal; stdcall;

type
  PEUSignCP = ^TEUSignCP;

  TEUSignCP = record
    Initialize: TEUInitialize;
    IsInitialized: TEUIsInitialized;
    Finalize: TEUFinalize;

    SetSettings: TEUSetSettings;
    ShowCertificates: TEUShowCertificates;
    ShowCRLs: TEUShowCRLs;

    GetPrivateKeyMedia: TEUGetPrivateKeyMedia;
    ReadPrivateKey: TEUReadPrivateKey;
    IsPrivateKeyReaded: TEUIsPrivateKeyReaded;
    ResetPrivateKey: TEUResetPrivateKey;
    FreeCertOwnerInfo: TEUFreeCertOwnerInfo;

    ShowOwnCertificate: TEUShowOwnCertificate;
    ShowSignInfo: TEUShowSignInfo;
    FreeSignInfo: TEUFreeSignInfo;

    FreeMemory: TEUFreeMemory;

    GetErrorDesc: TEUGetErrorDesc;

    SignData: TEUSignData;
    VerifyData: TEUVerifyData;

    SignDataContinue: TEUSignDataContinue;
    SignDataEnd: TEUSignDataEnd;
    VerifyDataBegin: TEUVerifyDataBegin;
    VerifyDataContinue: TEUVerifyDataContinue;
    VerifyDataEnd: TEUVerifyDataEnd;
    ResetOperation: TEUResetOperation;

    SignFile: TEUSignFile;
    VerifyFile: TEUVerifyFile;

    SignDataInternal: TEUSignDataInternal;
    VerifyDataInternal: TEUVerifyDataInternal;

    SelectCertInfo: TEUSelectCertInfo;

    SetUIMode: TEUSetUIMode;

    HashData: TEUHashData;
    HashDataContinue: TEUHashDataContinue;
    HashDataEnd: TEUHashDataEnd;
    HashFile: TEUHashFile;
    SignHash: TEUSignHash;
    VerifyHash: TEUVerifyHash;

    EnumKeyMediaTypes: TEUEnumKeyMediaTypes;
    EnumKeyMediaDevices: TEUEnumKeyMediaDevices;

    GetFileStoreSettings: TEUGetFileStoreSettings;
    SetFileStoreSettings: TEUSetFileStoreSettings;
    GetProxySettings: TEUGetProxySettings;
    SetProxySettings: TEUSetProxySettings;
    GetOCSPSettings: TEUGetOCSPSettings;
    SetOCSPSettings: TEUSetOCSPSettings;
    GetTSPSettings: TEUGetTSPSettings;
    SetTSPSettings: TEUSetTSPSettings;
    GetLDAPSettings: TEUGetLDAPSettings;
    SetLDAPSettings: TEUSetLDAPSettings;
    GetCMPSettings: TEUGetCMPSettings;
    SetCMPSettings: TEUSetCMPSettings;
    DoesNeedSetSettings: TEUDoesNeedSetSettings;

    GetCertificatesCount: TEUGetCertificatesCount;
    EnumCertificates: TEUEnumCertificates;
    GetCRLsCount: TEUGetCRLsCount;
    EnumCRLs: TEUEnumCRLs;
    FreeCRLInfo: TEUFreeCRLInfo;

    GetCertificateInfo: TEUGetCertificateInfo;
    FreeCertificateInfo: TEUFreeCertificateInfo;
    GetCRLDetailedInfo: TEUGetCRLDetailedInfo;
    FreeCRLDetailedInfo: TEUFreeCRLDetailedInfo;

    GetPrivateKeyMediaSettings: TEUGetPrivateKeyMediaSettings;
    SetPrivateKeyMediaSettings: TEUSetPrivateKeyMediaSettings;

    SelectCMPServer: TEUSelectCMPServer;

    RawSignData: TEURawSignData;
    RawVerifyData: TEURawVerifyData;
    RawSignHash: TEURawSignHash;
    RawVerifyHash: TEURawVerifyHash;
    RawSignFile: TEURawSignFile;
    RawVerifyFile: TEURawVerifyFile;

    Base64Encode: TEUBase64Encode;
    Base64Decode: TEUBase64Decode;

    EnvelopData: TEUEnvelopData;
    DevelopData: TEUDevelopData;
    ShowSenderInfo: TEUShowSenderInfo;
    FreeSenderInfo: TEUFreeSenderInfo;

    ParseCertificate: TEUParseCertificate;

    ReadPrivateKeyBinary: TEUReadPrivateKeyBinary;
    ReadPrivateKeyFile: TEUReadPrivateKeyFile;

    SessionDestroy: TEUSessionDestroy;
    ClientSessionCreateStep1: TEUClientSessionCreateStep1;
    ServerSessionCreateStep1: TEUServerSessionCreateStep1;
    ClientSessionCreateStep2: TEUClientSessionCreateStep2;
    ServerSessionCreateStep2: TEUServerSessionCreateStep2;
    SessionIsInitialized: TEUSessionIsInitialized;
    SessionSave: TEUSessionSave;
    SessionLoad: TEUSessionLoad;
    SessionCheckCertificates: TEUSessionCheckCertificates;

    SessionEncrypt: TEUSessionEncrypt;
    SessionEncryptContinue: TEUSessionEncryptContinue;
    SessionDecrypt: TEUSessionDecrypt;
    SessionDecryptContinue: TEUSessionDecryptContinue;

    IsSignedData: TEUIsSignedData;
    IsEnvelopedData: TEUIsEnvelopedData;

    SessionGetPeerCertificateInfo: TEUSessionGetPeerCertificateInfo;

    SaveCertificate: TEUSaveCertificate;
    RefreshFileStore: TEURefreshFileStore;

    GetModeSettings: TEUGetModeSettings;
    SetModeSettings: TEUSetModeSettings;

    CheckCertificate: TEUCheckCertificate;

    EnvelopFile: TEUEnvelopFile;
    DevelopFile: TEUDevelopFile;

    IsSignedFile: TEUIsSignedFile;
    IsEnvelopedFile: TEUIsEnvelopedFile;

    GetCertificate: TEUGetCertificate;
    GetOwnCertificate: TEUGetOwnCertificate;

    EnumOwnCertificates: TEUEnumOwnCertificates;
    GetCertificateInfoEx: TEUGetCertificateInfoEx;
    FreeCertificateInfoEx: TEUFreeCertificateInfoEx;

    GetReceiversCertificates: TEUGetReceiversCertificates;
    FreeReceiversCertificates: TEUFreeReceiversCertificates;

    GeneratePrivateKey: TEUGeneratePrivateKey;

    ChangePrivateKeyPassword: TEUChangePrivateKeyPassword;
    BackupPrivateKey: TEUBackupPrivateKey;
    DestroyPrivateKey: TEUDestroyPrivateKey;
    IsHardwareKeyMedia: TEUIsHardwareKeyMedia;
    IsPrivateKeyExists: TEUIsPrivateKeyExists;

    GetCRInfo: TEUGetCRInfo;
    FreeCRInfo: TEUFreeCRInfo;

    SaveCertificates: TEUSaveCertificates;
    SaveCRL: TEUSaveCRL;

    GetCertificateByEMail: TEUGetCertificateByEMail;
    GetCertificateByNBUCode: TEUGetCertificateByNBUCode;

	  AppendSign: TEUAppendSign;
    AppendSignInternal: TEUAppendSignInternal;
    VerifyDataSpecific: TEUVerifyDataSpecific;
    VerifyDataInternalSpecific: TEUVerifyDataInternalSpecific;
    AppendSignBegin: TEUAppendSignBegin;
    VerifyDataSpecificBegin: TEUVerifyDataSpecificBegin;

    AppendSignFile: TEUAppendSignFile;
    VerifyFileSpecific: TEUVerifyFileSpecific;

    AppendSignHash: TEUAppendSignHash;
    VerifyHashSpecific: TEUVerifyHashSpecific;

    GetSignsCount: TEUGetSignsCount;
    GetSignerInfo: TEUGetSignerInfo;
    GetFileSignsCount: TEUGetFileSignsCount;
    GetFileSignerInfo: TEUGetFileSignerInfo;

    IsAlreadySigned: TEUIsAlreadySigned;
    IsFileAlreadySigned: TEUIsFileAlreadySigned;

    HashDataWithParams: TEUHashDataWithParams;
    HashDataBeginWithParams: TEUHashDataBeginWithParams;
    HashFileWithParams: TEUHashFileWithParams;

    EnvelopDataEx: TEUEnvelopDataEx;

    SetSettingsFilePath: TEUSetSettingsFilePath;

    GetErrorLangDesc: TEUGetErrorLangDesc;

    EnvelopFileEx: TEUEnvelopFileEx;

    IsCertificates: TEUIsCertificates;
    IsCertificatesFile: TEUIsCertificatesFile;

    EnumCertificatesByOCode: TEUEnumCertificatesByOCode;
    GetCertificatesByOCode: TEUGetCertificatesByOCode;

    SetPrivateKeyMediaSettingsProtected:
     TEUSetPrivateKeyMediaSettingsProtected;

    EnvelopDataToRecipients: TEUEnvelopDataToRecipients;
    EnvelopFileToRecipients: TEUEnvelopFileToRecipients;

    EnvelopDataExWithDynamicKey: TEUEnvelopDataExWithDynamicKey;
    EnvelopDataToRecipientsWithDynamicKey:
      TEUEnvelopDataToRecipientsWithDynamicKey;
    EnvelopFileExWithDynamicKey: TEUEnvelopFileExWithDynamicKey;
    EnvelopFileToRecipientsWithDynamicKey:
      TEUEnvelopFileToRecipientsWithDynamicKey;
  end;

const
  EUDLLName: PAnsiChar = 'EUSignCP.dll';

  EUInitializeName: PAnsiChar = 'EUInitialize';
  EUIsInitializedName: PAnsiChar = 'EUIsInitialized';
  EUFinalizeName: PAnsiChar = 'EUFinalize';

  EUSetSettingsName: PAnsiChar = 'EUSetSettings';
  EUShowCertificatesName: PAnsiChar = 'EUShowCertificates';
  EUShowCRLsName: PAnsiChar = 'EUShowCRLs';

  EUGetPrivateKeyMediaName: PAnsiChar = 'EUGetPrivateKeyMedia';
  EUReadPrivateKeyName: PAnsiChar = 'EUReadPrivateKey';
  EUIsPrivateKeyReadedName: PAnsiChar = 'EUIsPrivateKeyReaded';
  EUResetPrivateKeyName: PAnsiChar = 'EUResetPrivateKey';
  EUFreeCertOwnerInfoName: PAnsiChar = 'EUFreeCertOwnerInfo';

  EUShowOwnCertificateName: PAnsiChar = 'EUShowOwnCertificate';
  EUShowSignInfoName: PAnsiChar = 'EUShowSignInfo';
  EUFreeSignInfoName: PAnsiChar = 'EUFreeSignInfo';

  EUFreeMemoryName: PAnsiChar = 'EUFreeMemory';

  EUGetErrorDescName: PAnsiChar = 'EUGetErrorDesc';

  EUSignDataName: PAnsiChar = 'EUSignData';
  EUVerifyDataName: PAnsiChar = 'EUVerifyData';

  EUSignDataContinueName: PAnsiChar = 'EUSignDataContinue';
  EUSignDataEndName: PAnsiChar = 'EUSignDataEnd';
  EUVerifyDataBeginName: PAnsiChar = 'EUVerifyDataBegin';
  EUVerifyDataContinueName: PAnsiChar = 'EUVerifyDataContinue';
  EUVerifyDataEndName: PAnsiChar = 'EUVerifyDataEnd';
  EUResetOperationName: PAnsiChar = 'EUResetOperation';

  EUSignFileName: PAnsiChar = 'EUSignFile';
  EUVerifyFileName: PAnsiChar = 'EUVerifyFile';

  EUSignDataInternalName: PAnsiChar = 'EUSignDataInternal';
  EUVerifyDataInternalName: PAnsiChar = 'EUVerifyDataInternal';

  EUSelectCertInfoName: PAnsiChar = 'EUSelectCertificateInfo';

  EUSetUIModeName: PAnsiChar = 'EUSetUIMode';

  EUHashDataName: PAnsiChar = 'EUHashData';
  EUHashDataContinueName: PAnsiChar = 'EUHashDataContinue';
  EUHashDataEndName: PAnsiChar = 'EUHashDataEnd';
  EUHashFileName: PAnsiChar = 'EUHashFile';
  EUSignHashName: PAnsiChar = 'EUSignHash';
  EUVerifyHashName: PAnsiChar = 'EUVerifyHash';

  EUEnumKeyMediaTypesName: PAnsiChar = 'EUEnumKeyMediaTypes';
  EUEnumKeyMediaDevicesName: PAnsiChar = 'EUEnumKeyMediaDevices';

  EUGetFileStoreSettingsName: PAnsiChar = 'EUGetFileStoreSettings';
  EUSetFileStoreSettingsName: PAnsiChar = 'EUSetFileStoreSettings';
  EUGetProxySettingsName: PAnsiChar = 'EUGetProxySettings';
  EUSetProxySettingsName: PAnsiChar = 'EUSetProxySettings';
  EUGetOCSPSettingsName: PAnsiChar = 'EUGetOCSPSettings';
  EUSetOCSPSettingsName: PAnsiChar = 'EUSetOCSPSettings';
  EUGetTSPSettingsName: PAnsiChar = 'EUGetTSPSettings';
  EUSetTSPSettingsName: PAnsiChar = 'EUSetTSPSettings';
  EUGetLDAPSettingsName: PAnsiChar = 'EUGetLDAPSettings';
  EUSetLDAPSettingsName: PAnsiChar = 'EUSetLDAPSettings';
  EUGetCMPSettingsName: PAnsiChar = 'EUGetCMPSettings';
  EUSetCMPSettingsName: PAnsiChar = 'EUSetCMPSettings';
  EUDoesNeedSetSettingsName: PAnsiChar = 'EUDoesNeedSetSettings';

  EUGetCertificatesCountName: PAnsiChar = 'EUGetCertificatesCount';
  EUEnumCertificatesName: PAnsiChar = 'EUEnumCertificates';
  EUGetCRLsCountName: PAnsiChar = 'EUGetCRLsCount';
  EUEnumCRLsName: PAnsiChar = 'EUEnumCRLs';
  EUFreeCRLInfoName: PAnsiChar = 'EUFreeCRLInfo';

  EUGetCertificateInfoName: PAnsiChar = 'EUGetCertificateInfo';
  EUFreeCertificateInfoName: PAnsiChar = 'EUFreeCertificateInfo';
  EUGetCRLDetailedInfoName: PAnsiChar = 'EUGetCRLDetailedInfo';
  EUFreeCRLDetailedInfoName: PAnsiChar = 'EUFreeCRLDetailedInfo';

  EUGetPrivateKeyMediaSettingsName: PAnsiChar = 'EUGetPrivateKeyMediaSettings';
  EUSetPrivateKeyMediaSettingsName: PAnsiChar = 'EUSetPrivateKeyMediaSettings';

  EUSelectCMPServerName: PAnsiChar = 'EUSelectCMPServer';

  EURawSignDataName: PAnsiChar = 'EURawSignData';
  EURawVerifyDataName: PAnsiChar = 'EURawVerifyData';
  EURawSignHashName: PAnsiChar = 'EURawSignHash';
  EURawVerifyHashName: PAnsiChar = 'EURawVerifyHash';
  EURawSignFileName: PAnsiChar = 'EURawSignFile';
  EURawVerifyFileName: PAnsiChar = 'EURawVerifyFile';

  EUBASE64EncodeName: PAnsiChar = 'EUBASE64Encode';
  EUBASE64DecodeName: PAnsiChar = 'EUBASE64Decode';

  EUEnvelopDataName: PAnsiChar = 'EUEnvelopData';
  EUDevelopDataName: PAnsiChar = 'EUDevelopData';
  EUShowSenderInfoName: PAnsiChar = 'EUShowSenderInfo';
  EUFreeSenderInfoName: PAnsiChar = 'EUFreeSenderInfo';

  EUParseCertificateName: PAnsiChar = 'EUParseCertificate';

  EUReadPrivateKeyBinaryName: PAnsiChar = 'EUReadPrivateKeyBinary';
  EUReadPrivateKeyFileName: PAnsiChar = 'EUReadPrivateKeyFile';

  EUSessionDestroyName: PAnsiChar = 'EUSessionDestroy';
  EUClientSessionCreateStep1Name: PAnsiChar = 'EUClientSessionCreateStep1';
  EUServerSessionCreateStep1Name: PAnsiChar = 'EUServerSessionCreateStep1';
  EUClientSessionCreateStep2Name: PAnsiChar = 'EUClientSessionCreateStep2';
  EUServerSessionCreateStep2Name: PAnsiChar = 'EUServerSessionCreateStep2';
  EUSessionIsInitializedName: PAnsiChar = 'EUSessionIsInitialized';
  EUSessionSaveName: PAnsiChar = 'EUSessionSave';
  EUSessionLoadName: PAnsiChar = 'EUSessionLoad';
  EUSessionCheckCertificatesName: PAnsiChar = 'EUSessionCheckCertificates';

  EUSessionEncryptName: PAnsiChar = 'EUSessionEncrypt';
  EUSessionEncryptContinueName: PAnsiChar = 'EUSessionEncryptContinue';
  EUSessionDecryptName: PAnsiChar = 'EUSessionDecrypt';
  EUSessionDecryptContinueName: PAnsiChar = 'EUSessionDecryptContinue';

  EUIsSignedDataName: PAnsiChar = 'EUIsSignedData';
  EUIsEnvelopedDataName: PAnsiChar = 'EUIsEnvelopedData';

  EUSessionGetPeerCertificateInfoName: PAnsiChar = 'EUSessionGetPeerCertificateInfo';

  EUSaveCertificateName: PAnsiChar = 'EUSaveCertificate';
  EURefreshFileStoreName: PAnsiChar = 'EURefreshFileStore';

  EUGetModeSettingsName: PAnsiChar = 'EUGetModeSettings';
  EUSetModeSettingsName: PAnsiChar = 'EUSetModeSettings';

  EUCheckCertificateName: PAnsiChar = 'EUCheckCertificate';

  EUEnvelopFileName: PAnsiChar = 'EUEnvelopFile';
  EUDevelopFileName: PAnsiChar = 'EUDevelopFile';

  EUIsSignedFileName: PAnsiChar = 'EUIsSignedFile';
  EUIsEnvelopedFileName: PAnsiChar = 'EUIsEnvelopedFile';

  EUGetCertificateName: PAnsiChar = 'EUGetCertificate';
  EUGetOwnCertificateName: PAnsiChar = 'EUGetOwnCertificate';

  EUEnumOwnCertificatesName: PAnsiChar = 'EUEnumOwnCertificates';
  EUGetCertificateInfoExName: PAnsiChar = 'EUGetCertificateInfoEx';
  EUFreeCertificateInfoExName: PAnsiChar = 'EUFreeCertificateInfoEx';

  EUGetReceiversCertificatesName: PAnsiChar = 'EUGetReceiversCertificates';
  EUFreeReceiversCertificatesName: PAnsiChar = 'EUFreeReceiversCertificates';

  EUGeneratePrivateKeyName: PAnsiChar = 'EUGeneratePrivateKey';

  EUChangePrivateKeyPasswordName: PAnsiChar = 'EUChangePrivateKeyPassword';
  EUBackupPrivateKeyName: PAnsiChar = 'EUBackupPrivateKey';
  EUDestroyPrivateKeyName: PAnsiChar = 'EUDestroyPrivateKey';
  EUIsHardwareKeyMediaName: PAnsiChar = 'EUIsHardwareKeyMedia';
  EUIsPrivateKeyExistsName: PAnsiChar = 'EUIsPrivateKeyExists';

  EUGetCRInfoName: PAnsiChar = 'EUGetCRInfo';
  EUFreeCRInfoName: PAnsiChar = 'EUFreeCRInfo';

  EUSaveCertificatesName: PAnsiChar = 'EUSaveCertificates';
  EUSaveCRLName: PAnsiChar = 'EUSaveCRL';

  EUGetCertificateByEMailName: PAnsiChar = 'EUGetCertificateByEMail';
  EUGetCertificateByNBUCodeName: PAnsiChar = 'EUGetCertificateByNBUCode';

  EUAppendSignName: PAnsiChar = 'EUAppendSign';
  EUAppendSignInternalName: PAnsiChar = 'EUAppendSignInternal';
  EUVerifyDataSpecificName: PAnsiChar = 'EUVerifyDataSpecific';
  EUVerifyDataInternalSpecificName: PAnsiChar = 'EUVerifyDataInternalSpecific';
  EUAppendSignBeginName: PAnsiChar = 'EUAppendSignBegin';
  EUVerifyDataSpecificBeginName: PAnsiChar = 'EUVerifyDataSpecificBegin';

  EUAppendSignFileName: PAnsiChar = 'EUAppendSignFile';
  EUVerifyFileSpecificName: PAnsiChar = 'EUVerifyFileSpecific';

  EUAppendSignHashName: PAnsiChar = 'EUAppendSignHash';
  EUVerifyHashSpecificName: PAnsiChar = 'EUVerifyHashSpecific';

  EUGetSignsCountName: PAnsiChar = 'EUGetSignsCount';
  EUGetSignerInfoName: PAnsiChar = 'EUGetSignerInfo';
  EUGetFileSignsCountName: PAnsiChar = 'EUGetFileSignsCount';
  EUGetFileSignerInfoName: PAnsiChar = 'EUGetFileSignerInfo';

  EUIsAlreadySignedName: PAnsiChar = 'EUIsAlreadySigned';
  EUIsFileAlreadySignedName: PAnsiChar = 'EUIsFileAlreadySigned';

  EUHashDataWithParamsName: PAnsiChar = 'EUHashDataWithParams';
  EUHashDataBeginWithParamsName: PAnsiChar = 'EUHashDataBeginWithParams';
  EUHashFileWithParamsName: PAnsiChar = 'EUHashFileWithParams';

  EUEnvelopDataEx: PAnsiChar = 'EUEnvelopDataEx';

  EUSetSettingsFilePath: PAnsiChar = 'EUSetSettingsFilePath';

  EUGetErrorLangDesc: PAnsiChar = 'EUGetErrorLangDesc';

  EUEnvelopFileEx: PAnsiChar = 'EUEnvelopFileEx';

  EUIsCertificates: PAnsiChar = 'EUIsCertificates';
  EUIsCertificatesFile: PAnsiChar = 'EUIsCertificatesFile';

  EUEnumCertificatesByOCode: PAnsiChar = 'EUEnumCertificatesByOCode';
  EUGetCertificatesByOCode: PAnsiChar = 'EUGetCertificatesByOCode';

  EUSetPrivateKeyMediaSettingsProtected: PAnsiChar =
    'EUSetPrivateKeyMediaSettingsProtected';

  EUEnvelopDataToRecipients: PAnsiChar = 'EUEnvelopDataToRecipients';
  EUEnvelopFileToRecipients: PAnsiChar = 'EUEnvelopFileToRecipients';

  EUEnvelopDataExWithDynamicKey: PAnsiChar = 'EUEnvelopDataExWithDynamicKey';
  EUEnvelopDataToRecipientsWithDynamicKey: PAnsiChar =
    'EUEnvelopDataToRecipientsWithDynamicKey';
  EUEnvelopFileExWithDynamicKey: PAnsiChar = 'EUEnvelopFileExWithDynamicKey';
  EUEnvelopFileToRecipientsWithDynamicKey: PAnsiChar =
    'EUEnvelopFileToRecipientsWithDynamicKey';

  { ------------------------------------------------------------------------------ }

var
  EUDLLInterface: TEUSignCP;
  EUDLLHandle: HModule;
  EUDLLInitialized: Boolean = False;

function EULoadDLL: Boolean; forward;
function EUGetInterface: PEUSignCP; forward;
procedure EUUnloadDLL; forward;

function EUDataToStream(Data: PByte; DataLength: Cardinal;
  Stream: TStream): Boolean;

function EUStreamToData(Stream: TStream; pByteArray: PPByte): Cardinal;

function EUWriteToFile(FileName: AnsiString; Data: TMemoryStream): Boolean;

function EUHashStream(CPInterface: PEUSignCP; Stream: TStream; Hash: TStream)
  : Cardinal;

function EUSignStream(CPInterface: PEUSignCP; Stream: TStream;
  SignedData: TStream): Cardinal;
function EUVerifyStream(CPInterface: PEUSignCP; Stream: TStream;
  SignedData: TStream; Info: PEUSignInfo): Cardinal;

function EUSignStreamHash(CPInterface: PEUSignCP; Hash: TStream;
  SignedData: TStream): Cardinal;
function EUVerifyStreamHash(CPInterface: PEUSignCP; Hash: TStream;
  SignedData: TStream; Info: PEUSignInfo): Cardinal;

function EUStringArrayToPAnsiChar(StringArray: array of AnsiString;
  ResultString: PPAnsiChar): Boolean;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

function EULoadDLL: Boolean;
var
  I: Integer;

begin
  Result := EUDLLInitialized;
  if Result then
    Exit;

  EUDLLHandle := LoadLibraryA(EUDLLName);
  if EUDLLHandle = 0 then
    Exit;

  EUDLLInterface.Initialize := GetProcAddress(EUDLLHandle, EUInitializeName);
  EUDLLInterface.IsInitialized := GetProcAddress(EUDLLHandle,
    EUIsInitializedName);
  EUDLLInterface.Finalize := GetProcAddress(EUDLLHandle, EUFinalizeName);

  EUDLLInterface.SetSettings := GetProcAddress(EUDLLHandle, EUSetSettingsName);
  EUDLLInterface.ShowCertificates := GetProcAddress(EUDLLHandle,
    EUShowCertificatesName);
  EUDLLInterface.ShowCRLs := GetProcAddress(EUDLLHandle, EUShowCRLsName);

  EUDLLInterface.GetPrivateKeyMedia := GetProcAddress(EUDLLHandle,
    EUGetPrivateKeyMediaName);
  EUDLLInterface.ReadPrivateKey := GetProcAddress(EUDLLHandle,
    EUReadPrivateKeyName);
  EUDLLInterface.IsPrivateKeyReaded := GetProcAddress(EUDLLHandle,
    EUIsPrivateKeyReadedName);
  EUDLLInterface.ResetPrivateKey := GetProcAddress(EUDLLHandle,
    EUResetPrivateKeyName);
  EUDLLInterface.FreeCertOwnerInfo := GetProcAddress(EUDLLHandle,
    EUFreeCertOwnerInfoName);

  EUDLLInterface.ShowOwnCertificate := GetProcAddress(EUDLLHandle,
    EUShowOwnCertificateName);
  EUDLLInterface.ShowSignInfo := GetProcAddress(EUDLLHandle,
    EUShowSignInfoName);
  EUDLLInterface.FreeSignInfo := GetProcAddress(EUDLLHandle,
    EUFreeSignInfoName);

  EUDLLInterface.FreeMemory := GetProcAddress(EUDLLHandle, EUFreeMemoryName);

  EUDLLInterface.GetErrorDesc := GetProcAddress(EUDLLHandle,
    EUGetErrorDescName);

  EUDLLInterface.SignData := GetProcAddress(EUDLLHandle, EUSignDataName);
  EUDLLInterface.VerifyData := GetProcAddress(EUDLLHandle, EUVerifyDataName);

  EUDLLInterface.SignDataContinue := GetProcAddress(EUDLLHandle,
    EUSignDataContinueName);
  EUDLLInterface.SignDataEnd := GetProcAddress(EUDLLHandle, EUSignDataEndName);
  EUDLLInterface.VerifyDataBegin := GetProcAddress(EUDLLHandle,
    EUVerifyDataBeginName);
  EUDLLInterface.VerifyDataContinue := GetProcAddress(EUDLLHandle,
    EUVerifyDataContinueName);
  EUDLLInterface.VerifyDataEnd := GetProcAddress(EUDLLHandle,
    EUVerifyDataEndName);
  EUDLLInterface.ResetOperation := GetProcAddress(EUDLLHandle,
    EUResetOperationName);

  EUDLLInterface.SignFile := GetProcAddress(EUDLLHandle, EUSignFileName);
  EUDLLInterface.VerifyFile := GetProcAddress(EUDLLHandle, EUVerifyFileName);

  EUDLLInterface.SignDataInternal := GetProcAddress(EUDLLHandle,
    EUSignDataInternalName);
  EUDLLInterface.VerifyDataInternal := GetProcAddress(EUDLLHandle,
    EUVerifyDataInternalName);

  EUDLLInterface.SelectCertInfo := GetProcAddress(EUDLLHandle,
    EUSelectCertInfoName);

  EUDLLInterface.SetUIMode := GetProcAddress(EUDLLHandle, EUSetUIModeName);

  EUDLLInterface.HashData := GetProcAddress(EUDLLHandle, EUHashDataName);
  EUDLLInterface.HashDataContinue := GetProcAddress(EUDLLHandle,
    EUHashDataContinueName);
  EUDLLInterface.HashDataEnd := GetProcAddress(EUDLLHandle, EUHashDataEndName);
  EUDLLInterface.HashFile := GetProcAddress(EUDLLHandle, EUHashFileName);
  EUDLLInterface.SignHash := GetProcAddress(EUDLLHandle, EUSignHashName);
  EUDLLInterface.VerifyHash := GetProcAddress(EUDLLHandle, EUVerifyHashName);

  EUDLLInterface.EnumKeyMediaTypes := GetProcAddress(EUDLLHandle,
    EUEnumKeyMediaTypesName);
  EUDLLInterface.EnumKeyMediaDevices := GetProcAddress(EUDLLHandle,
    EUEnumKeyMediaDevicesName);

  EUDLLInterface.GetFileStoreSettings := GetProcAddress(EUDLLHandle,
    EUGetFileStoreSettingsName);
  EUDLLInterface.SetFileStoreSettings := GetProcAddress(EUDLLHandle,
    EUSetFileStoreSettingsName);
  EUDLLInterface.GetProxySettings := GetProcAddress(EUDLLHandle,
    EUGetProxySettingsName);
  EUDLLInterface.SetProxySettings := GetProcAddress(EUDLLHandle,
    EUSetProxySettingsName);
  EUDLLInterface.GetOCSPSettings := GetProcAddress(EUDLLHandle,
    EUGetOCSPSettingsName);
  EUDLLInterface.SetOCSPSettings := GetProcAddress(EUDLLHandle,
    EUSetOCSPSettingsName);
  EUDLLInterface.GetTSPSettings := GetProcAddress(EUDLLHandle,
    EUGetTSPSettingsName);
  EUDLLInterface.SetTSPSettings := GetProcAddress(EUDLLHandle,
    EUSetTSPSettingsName);
  EUDLLInterface.GetLDAPSettings := GetProcAddress(EUDLLHandle,
    EUGetLDAPSettingsName);
  EUDLLInterface.SetLDAPSettings := GetProcAddress(EUDLLHandle,
    EUSetLDAPSettingsName);
  EUDLLInterface.GetCMPSettings := GetProcAddress(EUDLLHandle,
    EUGetCMPSettingsName);
  EUDLLInterface.SetCMPSettings := GetProcAddress(EUDLLHandle,
    EUSetCMPSettingsName);
  EUDLLInterface.DoesNeedSetSettings := GetProcAddress(EUDLLHandle,
    EUDoesNeedSetSettingsName);

  EUDLLInterface.GetCertificatesCount := GetProcAddress(EUDLLHandle,
    EUGetCertificatesCountName);
  EUDLLInterface.EnumCertificates := GetProcAddress(EUDLLHandle,
    EUEnumCertificatesName);
  EUDLLInterface.GetCRLsCount := GetProcAddress(EUDLLHandle,
    EUGetCRLsCountName);
  EUDLLInterface.EnumCRLs := GetProcAddress(EUDLLHandle, EUEnumCRLsName);
  EUDLLInterface.FreeCRLInfo := GetProcAddress(EUDLLHandle, EUFreeCRLInfoName);

  EUDLLInterface.GetCertificateInfo := GetProcAddress(EUDLLHandle,
    EUGetCertificateInfoName);
  EUDLLInterface.FreeCertificateInfo := GetProcAddress(EUDLLHandle,
    EUFreeCertificateInfoName);
  EUDLLInterface.GetCRLDetailedInfo := GetProcAddress(EUDLLHandle,
    EUGetCRLDetailedInfoName);
  EUDLLInterface.FreeCRLDetailedInfo := GetProcAddress(EUDLLHandle,
    EUFreeCRLDetailedInfoName);

  EUDLLInterface.GetPrivateKeyMediaSettings := GetProcAddress(EUDLLHandle,
    EUGetPrivateKeyMediaSettingsName);
  EUDLLInterface.SetPrivateKeyMediaSettings := GetProcAddress(EUDLLHandle,
    EUSetPrivateKeyMediaSettingsName);

  EUDLLInterface.SelectCMPServer := GetProcAddress(EUDLLHandle,
    EUSelectCMPServerName);

  EUDLLInterface.RawSignData := GetProcAddress(EUDLLHandle, EURawSignDataName);
  EUDLLInterface.RawVerifyData := GetProcAddress(EUDLLHandle,
    EURawVerifyDataName);
  EUDLLInterface.RawSignHash := GetProcAddress(EUDLLHandle, EURawSignHashName);
  EUDLLInterface.RawVerifyHash := GetProcAddress(EUDLLHandle,
    EURawVerifyHashName);
  EUDLLInterface.RawSignFile := GetProcAddress(EUDLLHandle, EURawSignFileName);
  EUDLLInterface.RawVerifyFile := GetProcAddress(EUDLLHandle,
    EURawVerifyFileName);

  EUDLLInterface.Base64Encode := GetProcAddress(EUDLLHandle,
    EUBASE64EncodeName);
  EUDLLInterface.Base64Decode := GetProcAddress(EUDLLHandle,
    EUBASE64DecodeName);

  EUDLLInterface.EnvelopData := GetProcAddress(EUDLLHandle,
    EUEnvelopDataName);
  EUDLLInterface.DevelopData := GetProcAddress(EUDLLHandle,
    EUDevelopDataName);
  EUDLLInterface.ShowSenderInfo := GetProcAddress(EUDLLHandle,
    EUShowSenderInfoName);
  EUDLLInterface.FreeSenderInfo := GetProcAddress(EUDLLHandle,
    EUFreeSenderInfoName);

  EUDLLInterface.ParseCertificate := GetProcAddress(EUDLLHandle,
    EUParseCertificateName);

  EUDLLInterface.ReadPrivateKeyBinary := GetProcAddress(EUDLLHandle,
    EUReadPrivateKeyBinaryName);
  EUDLLInterface.ReadPrivateKeyFile := GetProcAddress(EUDLLHandle,
    EUReadPrivateKeyFileName);

  EUDLLInterface.SessionDestroy := GetProcAddress(EUDLLHandle,
    EUSessionDestroyName);
  EUDLLInterface.ClientSessionCreateStep1 := GetProcAddress(EUDLLHandle,
    EUClientSessionCreateStep1Name);
  EUDLLInterface.ServerSessionCreateStep1 := GetProcAddress(EUDLLHandle,
    EUServerSessionCreateStep1Name);
  EUDLLInterface.ClientSessionCreateStep2 := GetProcAddress(EUDLLHandle,
    EUClientSessionCreateStep2Name);
  EUDLLInterface.ServerSessionCreateStep2 := GetProcAddress(EUDLLHandle,
    EUServerSessionCreateStep2Name);
  EUDLLInterface.SessionIsInitialized := GetProcAddress(EUDLLHandle,
    EUSessionIsInitializedName);
  EUDLLInterface.SessionSave := GetProcAddress(EUDLLHandle,
    EUSessionSaveName);
  EUDLLInterface.SessionLoad := GetProcAddress(EUDLLHandle,
    EUSessionLoadName);
  EUDLLInterface.SessionCheckCertificates := GetProcAddress(EUDLLHandle,
    EUSessionCheckCertificatesName);

  EUDLLInterface.SessionEncrypt := GetProcAddress(EUDLLHandle,
    EUSessionEncryptName);
  EUDLLInterface.SessionEncryptContinue := GetProcAddress(EUDLLHandle,
    EUSessionEncryptContinueName);
  EUDLLInterface.SessionDecrypt := GetProcAddress(EUDLLHandle,
    EUSessionDecryptName);
  EUDLLInterface.SessionDecryptContinue := GetProcAddress(EUDLLHandle,
    EUSessionDecryptContinueName);

  EUDLLInterface.IsSignedData := GetProcAddress(EUDLLHandle,
    EUIsSignedDataName);
  EUDLLInterface.IsEnvelopedData := GetProcAddress(EUDLLHandle,
    EUIsEnvelopedDataName);

  EUDLLInterface.SessionGetPeerCertificateInfo := GetProcAddress(EUDLLHandle,
    EUSessionGetPeerCertificateInfoName);

  EUDLLInterface.SaveCertificate := GetProcAddress(EUDLLHandle,
    EUSaveCertificateName);
  EUDLLInterface.RefreshFileStore := GetProcAddress(EUDLLHandle,
    EURefreshFileStoreName);

  EUDLLInterface.GetModeSettings := GetProcAddress(EUDLLHandle,
    EUGetModeSettingsName);
  EUDLLInterface.SetModeSettings := GetProcAddress(EUDLLHandle,
    EUSetModeSettingsName);

  EUDLLInterface.CheckCertificate := GetProcAddress(EUDLLHandle,
    EUCheckCertificateName);

  EUDLLInterface.EnvelopFile := GetProcAddress(EUDLLHandle,
    EUEnvelopFileName);
  EUDLLInterface.DevelopFile := GetProcAddress(EUDLLHandle,
    EUDevelopFileName);

  EUDLLInterface.IsSignedFile := GetProcAddress(EUDLLHandle,
    EUIsSignedFileName);
  EUDLLInterface.IsEnvelopedFile := GetProcAddress(EUDLLHandle,
    EUIsEnvelopedFileName);

  EUDLLInterface.GetCertificate := GetProcAddress(EUDLLHandle,
    EUGetCertificateName);
  EUDLLInterface.GetOwnCertificate := GetProcAddress(EUDLLHandle,
    EUGetOwnCertificateName);

  EUDLLInterface.EnumOwnCertificates :=  GetProcAddress(EUDLLHandle,
    EUEnumOwnCertificatesName);
  EUDLLInterface.GetCertificateInfoEx := GetProcAddress(EUDLLHandle,
    EUGetCertificateInfoExName);
  EUDLLInterface.FreeCertificateInfoEx := GetProcAddress(EUDLLHandle,
    EUFreeCertificateInfoExName);

  EUDLLInterface.GetReceiversCertificates := GetProcAddress(EUDLLHandle,
    EUGetReceiversCertificatesName);
  EUDLLInterface.FreeReceiversCertificates := GetProcAddress(EUDLLHandle,
    EUFreeReceiversCertificatesName);

  EUDLLInterface.GeneratePrivateKey := GetProcAddress(EUDLLHandle,
    EUGeneratePrivateKeyName);

  EUDLLInterface.ChangePrivateKeyPassword := GetProcAddress(EUDLLHandle,
    EUChangePrivateKeyPasswordName);
  EUDLLInterface.BackupPrivateKey := GetProcAddress(EUDLLHandle,
    EUBackupPrivateKeyName);
  EUDLLInterface.DestroyPrivateKey := GetProcAddress(EUDLLHandle,
    EUDestroyPrivateKeyName);
  EUDLLInterface.IsHardwareKeyMedia := GetProcAddress(EUDLLHandle,
    EUIsHardwareKeyMediaName);
  EUDLLInterface.IsPrivateKeyExists := GetProcAddress(EUDLLHandle,
    EUIsPrivateKeyExistsName);

  EUDLLInterface.GetCRInfo := GetProcAddress(EUDLLHandle,
    EUGetCRInfoName);
  EUDLLInterface.FreeCRInfo := GetProcAddress(EUDLLHandle,
    EUFreeCRInfoName);

  EUDLLInterface.SaveCertificates := GetProcAddress(EUDLLHandle,
    EUSaveCertificatesName);
  EUDLLInterface.SaveCRL := GetProcAddress(EUDLLHandle,
    EUSaveCRLName);

  EUDLLInterface.GetCertificateByEMail := GetProcAddress(EUDLLHandle,
    EUGetCertificateByEMailName);
  EUDLLInterface.GetCertificateByNBUCode := GetProcAddress(EUDLLHandle,
    EUGetCertificateByNBUCodeName);

  EUDLLInterface.AppendSign := GetProcAddress(EUDLLHandle,EUAppendSignName);
  EUDLLInterface.AppendSignInternal := GetProcAddress(EUDLLHandle,
    EUAppendSignInternalName);
  EUDLLInterface.VerifyDataSpecific := GetProcAddress(EUDLLHandle,
    EUVerifyDataSpecificName);
  EUDLLInterface.VerifyDataInternalSpecific := GetProcAddress(EUDLLHandle,
    EUVerifyDataInternalSpecificName);
  EUDLLInterface.AppendSignBegin := GetProcAddress(EUDLLHandle,
    EUAppendSignBeginName);
  EUDLLInterface.VerifyDataSpecificBegin := GetProcAddress(EUDLLHandle,
    EUVerifyDataSpecificBeginName);

  EUDLLInterface.AppendSignFile := GetProcAddress(EUDLLHandle,
    EUAppendSignFileName);
  EUDLLInterface.VerifyFileSpecific := GetProcAddress(EUDLLHandle,
    EUVerifyFileSpecificName);

  EUDLLInterface.AppendSignHash := GetProcAddress(EUDLLHandle,
    EUAppendSignHashName);
  EUDLLInterface.VerifyHashSpecific := GetProcAddress(EUDLLHandle,
    EUVerifyHashSpecificName);

  EUDLLInterface.GetSignsCount := GetProcAddress(EUDLLHandle,
    EUGetSignsCountName);
  EUDLLInterface.GetSignerInfo := GetProcAddress(EUDLLHandle,
    EUGetSignerInfoName);
  EUDLLInterface.GetFileSignsCount := GetProcAddress(EUDLLHandle,
    EUGetFileSignsCountName);
  EUDLLInterface.GetFileSignerInfo := GetProcAddress(EUDLLHandle,
    EUGetFileSignerInfoName);

  EUDLLInterface.IsAlreadySigned := GetProcAddress(EUDLLHandle,
    EUIsAlreadySignedName);
  EUDLLInterface.IsFileAlreadySigned := GetProcAddress(EUDLLHandle,
    EUIsFileAlreadySignedName);

  EUDLLInterface.HashDataWithParams := GetProcAddress(EUDLLHandle,
    EUHashDataWithParamsName);
  EUDLLInterface.HashDataBeginWithParams := GetProcAddress(EUDLLHandle,
    EUHashDataBeginWithParamsName);
  EUDLLInterface.HashFileWithParams := GetProcAddress(EUDLLHandle,
    EUHashFileWithParamsName);

  EUDLLInterface.EnvelopDataEx := GetProcAddress(EUDLLHandle,
    EUEnvelopDataEx);

  EUDLLInterface.SetSettingsFilePath := GetProcAddress(EUDLLHandle,
   EUSetSettingsFilePath);

  EUDLLInterface.GetErrorLangDesc := GetProcAddress(EUDLLHandle,
    EUGetErrorLangDesc);

  EUDLLInterface.EnvelopFileEx := GetProcAddress(EUDLLHandle,
    EUEnvelopFileEx);

  EUDLLInterface.IsCertificates := GetProcAddress(EUDLLHandle,
   EUIsCertificates);
  EUDLLInterface.IsCertificatesFile := GetProcAddress(EUDLLHandle,
    EUIsCertificatesFile);

  EUDLLInterface.EnumCertificatesByOCode := GetProcAddress(EUDLLHandle,
    EUEnumCertificatesByOCode);
  EUDLLInterface.GetCertificatesByOCode := GetProcAddress(EUDLLHandle,
    EUGetCertificatesByOCode);

  EUDLLInterface.SetPrivateKeyMediaSettingsProtected :=
    GetProcAddress(EUDLLHandle, EUSetPrivateKeyMediaSettingsProtected);

  EUDLLInterface.EnvelopDataToRecipients := GetProcAddress(EUDLLHandle,
    EUEnvelopDataToRecipients);
  EUDLLInterface.EnvelopFileToRecipients := GetProcAddress(EUDLLHandle,
    EUEnvelopFileToRecipients);

  EUDLLInterface.EnvelopDataExWithDynamicKey := GetProcAddress(EUDLLHandle,
    EUEnvelopDataExWithDynamicKey);
  EUDLLInterface.EnvelopDataToRecipientsWithDynamicKey :=
    GetProcAddress(EUDLLHandle, EUEnvelopDataToRecipientsWithDynamicKey);
  EUDLLInterface.EnvelopFileExWithDynamicKey := GetProcAddress(EUDLLHandle,
    EUEnvelopFileExWithDynamicKey);
  EUDLLInterface.EnvelopFileToRecipientsWithDynamicKey :=
    GetProcAddress(EUDLLHandle, EUEnvelopFileToRecipientsWithDynamicKey);

  for I := 0 to (SizeOf(TEUSignCP) div SizeOf(Pointer) - 1) do
    if (PPointer(@EUDLLInterface))[I] = nil then
      Exit;

  EUDLLInitialized := True;
  Result := EUDLLInitialized;
end;

{ ------------------------------------------------------------------------------ }

function EUGetInterface: PEUSignCP;
begin
  Result := nil;

  if (not EUDLLInitialized) then
    Exit;

  Result := @EUDLLInterface;
end;

{ ------------------------------------------------------------------------------ }

procedure EUUnloadDLL;
begin
  if (not EUDLLInitialized) then
    Exit;

  FreeLibrary(EUDLLHandle);
  EUDLLInitialized := False;
end;

{ ============================================================================== }

function EUDataToStream(Data: PByte; DataLength: Cardinal;
  Stream: TStream): Boolean;
var
  BytesWrite: Cardinal;
  DataString: PAnsiChar;

begin
  EUDataToStream := False;

  if (Stream.ClassType = TStringStream) then
  begin
{$if CompilerVersion > 19}
    if (TStringStream(Stream).Encoding <> TEncoding.ASCII) then
      Exit;

    try
      TStringStream(Stream).WriteString(
        string(EncodeBase64(Data, DataLength)));
    except
      Exit;
    end;
{$else}
    if (not EUDLLInitialized) then
      Exit;

    if (EUDLLInterface.Base64Encode(
      Data, DataLength, @DataString) <> EU_ERROR_NONE) then
    begin
      Exit;
    end;
    
    try
      TStringStream(Stream).WriteString(
        string(DataString));
    except
      EUDLLInterface.FreeMemory(PByte(DataString));
      Exit;
    end;

    EUDLLInterface.FreeMemory(PByte(DataString));
{$ifend}
  end
  else
  begin

    try
      BytesWrite := Stream.Write(Data^, DataLength);
      if (BytesWrite <> DataLength) then
      begin
        Stream.Seek(BytesWrite, soFromEnd);
        Exit;
      end;
    except
      Exit;
    end;

  end;

  EUDataToStream := True;
end;

{ ------------------------------------------------------------------------------ }

function EUStreamToData(Stream: TStream; pByteArray: PPByte): Cardinal;
var
  ReadLength: Cardinal;
  ByteArray: PByte;
  RealSize: Int64;
{$if CompilerVersion > 19}
  DecodedData: TBytes;
{$else}
  DecodedArray: PByte;
{$ifend}

begin
  EUStreamToData := 0;

  RealSize := Stream.Size - Stream.Position;

  if (RealSize = 0) then
    Exit;

  if (Stream.ClassType = TStringStream) then
  begin
{$if CompilerVersion > 19}
    if (TStringStream(Stream).Encoding <> TEncoding.ASCII) then
      Exit;

    try
      DecodedData := DecodeBase64(
        AnsiString(TStringStream(Stream).ReadString(RealSize)));
    except
      Exit;
    end;

    ReadLength := Length(DecodedData);
    ByteArray := GetMemory(ReadLength);
    CopyMemory(ByteArray, DecodedData, ReadLength);
{$else}
    if (not EUDLLInitialized) then
      Exit;

    try
      if (EUDLLInterface.Base64Decode(
        PAnsiChar(AnsiString(TStringStream(Stream).ReadString(RealSize))),
        @DecodedArray, @ReadLength) <> EU_ERROR_NONE) then
      begin
        Exit;
      end;
    except
      Exit;
    end;
    
    ByteArray := GetMemory(ReadLength);
    CopyMemory(ByteArray, DecodedArray, ReadLength);

    EUDLLInterface.FreeMemory(DecodedArray);    
{$ifend}
  end
  else
  begin
    try
      ByteArray := nil;
      ByteArray := GetMemory(RealSize);
      ReadLength := Stream.Read(ByteArray^, RealSize);
      if (RealSize <> ReadLength) then
      begin
        FreeAndNil(ByteArray);
        Exit;
      end;
    except
      FreeAndNil(ByteArray);
      Exit;
    end;
  end;

  EUStreamToData := ReadLength;
  pByteArray^ := ByteArray;
end;

{ ------------------------------------------------------------------------------ }

function EUWriteToFile(FileName: AnsiString; Data: TMemoryStream): Boolean;
var
  FileStream: TFileStream;

begin
  EUWriteToFile := False;
  FileStream := nil;
  try
    FileStream := TFileStream.Create(string(FileName), fmOpenWrite or fmCreate);
    Data.Seek(0, soBeginning);
    FileStream.CopyFrom(Data, Data.Size);
    EUWriteToFile := True;
  finally
    if (FileStream <> nil) then
      FileStream.Destroy;
  end;
end;

{ ------------------------------------------------------------------------------ }

function EUHashStream(CPInterface: PEUSignCP; Stream: TStream;
  Hash: TStream): Cardinal;
var
  Buffer: Array [0 .. EU_MAX_BUFFER_SIZE] of Byte;
  ReadedDataLength: Integer;
  Error: Cardinal;
  HashBinary: PByte;
  HashBinaryLength: Cardinal;

begin
  try
    while (Stream.Position < Stream.Size) do
    begin
      ReadedDataLength := Stream.Read(Buffer, EU_MAX_BUFFER_SIZE);
      if (ReadedDataLength > 0) then
      begin
        Error := CPInterface.HashDataContinue(@Buffer, ReadedDataLength);
        if (Error <> EU_ERROR_NONE) then
        begin
          EUHashStream := Error;
          CPInterface.ResetOperation();
          Exit;
        end;
      end;
    end;
  except
    CPInterface.ResetOperation();
    EUHashStream := EU_ERROR_UNKNOWN;
    Exit;
  end;

  Error := CPInterface.HashDataEnd(nil, @HashBinary, @HashBinaryLength);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.ResetOperation();
    EUHashStream := Error;
    Exit;
  end;

  if EUDataToStream(HashBinary, HashBinaryLength, Hash) = False then
    Error := EU_ERROR_UNKNOWN;

  CPInterface.FreeMemory(PByte(HashBinary));
  EUHashStream := Error;
end;

{ ------------------------------------------------------------------------------ }

function EUSignStream(CPInterface: PEUSignCP; Stream: TStream;
  SignedData: TStream): Cardinal;
var
  Buffer: Array [0 .. EU_MAX_BUFFER_SIZE] of Byte;
  ReadedDataLength: Integer;
  Error: Cardinal;
  SignBinary: PByte;
  SignBinaryLength: Cardinal;

begin
  try
    while (Stream.Position < Stream.Size) do
    begin
      ReadedDataLength := Stream.Read(Buffer, EU_MAX_BUFFER_SIZE);
      if (ReadedDataLength > 0) then
      begin
        Error := CPInterface.SignDataContinue(@Buffer, ReadedDataLength);
        if (Error <> EU_ERROR_NONE) then
        begin
          EUSignStream := Error;
          CPInterface.ResetOperation();
          Exit;
        end;
      end;
    end;
  except
    CPInterface.ResetOperation();
    EUSignStream := EU_ERROR_UNKNOWN;
    Exit;
  end;

  Error := CPInterface.SignDataEnd(nil, @SignBinary, @SignBinaryLength);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(PByte(SignBinary));
    EUSignStream := Error;
    Exit;
  end;

  if (not EUDataToStream(SignBinary, SignBinaryLength, SignedData)) then
    Error := EU_ERROR_UNKNOWN;

  CPInterface.FreeMemory(PByte(SignBinary));
  EUSignStream := Error;
end;

{ ------------------------------------------------------------------------------ }

function EUVerifyStream(CPInterface: PEUSignCP; Stream: TStream;
  SignedData: TStream; Info: PEUSignInfo): Cardinal;
var
  Buffer: Array [0 .. EU_MAX_BUFFER_SIZE] of Byte;
  ReadedDataLength: Integer;
  SignedBinary: PByte;
  SignedBinaryLength: Cardinal;
  Error: Cardinal;

begin
  SignedBinary := nil;
  SignedBinaryLength := EUStreamToData(SignedData, @SignedBinary);

  if (SignedBinaryLength = 0) then
  begin
    if (SignedBinary <> nil) then
      FreeMemory(SignedBinary);
    EUVerifyStream := EU_ERROR_UNKNOWN;
    Exit;
  end;

  Error := CPInterface.VerifyDataBegin(nil, SignedBinary, SignedBinaryLength);

  if (SignedBinary <> nil) then
    FreeMemory(SignedBinary);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUVerifyStream := Error;
    Exit;
  end;

  try
    while (Stream.Position < Stream.Size) do
    begin
      ReadedDataLength := Stream.Read(Buffer, EU_MAX_BUFFER_SIZE);
      if (ReadedDataLength > 0) then
      begin
        Error := CPInterface.VerifyDataContinue(@Buffer, ReadedDataLength);
        if (Error <> EU_ERROR_NONE) then
        begin
          EUVerifyStream := Error;
          CPInterface.ResetOperation();
          Exit;
        end;
      end;
    end;
  except
    CPInterface.ResetOperation();
    EUVerifyStream := EU_ERROR_UNKNOWN;
    Exit;
  end;

  EUVerifyStream := CPInterface.VerifyDataEnd(Info);
end;

{ ------------------------------------------------------------------------------ }

function EUSignStreamHash(CPInterface: PEUSignCP; Hash: TStream;
  SignedData: TStream): Cardinal;
var
  HashBinary: PByte;
  HashBinaryLength: Cardinal;
  SignBinary: PByte;
  SignBinaryLength: Cardinal;
  Error: Cardinal;

begin
  HashBinary := nil;
  SignBinary := nil;

  HashBinaryLength := EUStreamToData(Hash, @HashBinary);

  Error := CPInterface.SignHash(nil, HashBinary, HashBinaryLength, nil,
    @SignBinary, @SignBinaryLength);

  FreeMemory(HashBinary);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUSignStreamHash := Error;
    Exit;
  end;

  if EUDataToStream(SignBinary, SignBinaryLength, SignedData) = False then
    Error := EU_ERROR_UNKNOWN;

  CPInterface.FreeMemory(SignBinary);
  EUSignStreamHash := Error;
end;

{ ------------------------------------------------------------------------------ }

function EUVerifyStreamHash(CPInterface: PEUSignCP; Hash: TStream;
  SignedData: TStream; Info: PEUSignInfo): Cardinal;
var
  HashBinary: PByte;
  HashBinaryLength: Cardinal;
  SignBinary: PByte;
  SignBinaryLength: Cardinal;

begin
  HashBinaryLength := EUStreamToData(Hash, @HashBinary);
  SignBinaryLength := EUStreamToData(SignedData, @SignBinary);

  if ((HashBinaryLength = 0) or (SignBinaryLength = 0)) then
  begin
    EUVerifyStreamHash := EU_ERROR_BAD_PARAMETER;
    Exit;
  end;

  EUVerifyStreamHash := CPInterface.VerifyHash(nil, HashBinary,
    HashBinaryLength, nil, SignBinary, SignBinaryLength, Info);

  FreeMemory(HashBinary);
  FreeMemory(SignBinary);
end;

{ ============================================================================== }

function EUStringArrayToPAnsiChar(StringArray: array of AnsiString;
  ResultString: PPAnsiChar): Boolean;
var
  CurString: PAnsiChar;
  Index: Integer;
  MaxSize: Integer;

begin
  EUStringArrayToPAnsiChar := False;
  MaxSize := 0;

  for Index := 0 to High(StringArray) do
    MaxSize := MaxSize + (Length(StringArray[Index]) + 1);
  MaxSize := MaxSize + 1;

  ResultString^ := PAnsiChar(System.AllocMem(MaxSize));
  if ResultString = nil then
    Exit;

  CurString := ResultString^;
  for Index := 0 to High(StringArray) do
  begin
    CopyMemory(CurString, PAnsiChar(StringArray[Index]),
      Length(StringArray[Index]));
    CurString := CurString + (Length(StringArray[Index]) + 1);
  end;

  EUStringArrayToPAnsiChar := True;
end;

{ ============================================================================== }

end.
