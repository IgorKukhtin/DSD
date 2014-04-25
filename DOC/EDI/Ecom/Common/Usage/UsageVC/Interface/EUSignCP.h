#ifndef EU_SIGN_CP_H
#define EU_SIGN_CP_H

//=============================================================================

#include <windows.h>

//-----------------------------------------------------------------------------

#include "EUError.h"

//=============================================================================

#pragma pack(push, 1)
typedef struct
{
	BOOL		bFilled;

	PSTR		pszIssuer;
	PSTR		pszIssuerCN;
	PSTR		pszSerial;

	PSTR		pszSubject;
	PSTR		pszSubjCN;
	PSTR		pszSubjOrg;
	PSTR		pszSubjOrgUnit;
	PSTR		pszSubjTitle;
	PSTR		pszSubjState;
	PSTR		pszSubjLocality;
	PSTR		pszSubjFullName;
	PSTR		pszSubjAddress;
	PSTR		pszSubjPhone;
	PSTR		pszSubjEMail;
	PSTR		pszSubjDNS;
	PSTR		pszSubjEDRPOUCode;
	PSTR		pszSubjDRFOCode;
} EU_CERT_OWNER_INFO, *PEU_CERT_OWNER_INFO;
#pragma pack(pop)

//-----------------------------------------------------------------------------

#pragma pack(push, 1)
typedef struct
{
	BOOL		bFilled;

	PSTR		pszIssuer;
	PSTR		pszIssuerCN;
	PSTR		pszSerial;

	PSTR		pszSubject;
	PSTR		pszSubjCN;
	PSTR		pszSubjOrg;
	PSTR		pszSubjOrgUnit;
	PSTR		pszSubjTitle;
	PSTR		pszSubjState;
	PSTR		pszSubjLocality;
	PSTR		pszSubjFullName;
	PSTR		pszSubjAddress;
	PSTR		pszSubjPhone;
	PSTR		pszSubjEMail;
	PSTR		pszSubjDNS;
	PSTR		pszSubjEDRPOUCode;
	PSTR		pszSubjDRFOCode;

	BOOL		bTimeAvail;
	BOOL		bTimeStamp;
	SYSTEMTIME	Time;
} EU_SIGN_INFO, *PEU_SIGN_INFO,
  EU_ENVELOP_INFO, *PEU_ENVELOP_INFO;
#pragma pack(pop)

//-----------------------------------------------------------------------------

#define EU_PASS_MAX_LENGTH		65

//-----------------------------------------------------------------------------

typedef struct
{
	DWORD		dwTypeIndex, dwDevIndex;
	CHAR		szPassword[EU_PASS_MAX_LENGTH];
} EU_KEY_MEDIA, *PEU_KEY_MEDIA;

//-----------------------------------------------------------------------------

#define EU_ERROR_MAX_LENGTH			1025
#define EU_SIGNER_INFO_MAX_LENGTH	1153

//-----------------------------------------------------------------------------

#define EU_KEY_MEDIA_NAME_MAX_LENGTH	257
#define EU_KEY_MEDIA_MAX_TYPES			32
#define EU_KEY_MEDIA_MAX_DEVICES		32

#define EU_KEY_MEDIA_SOURCE_TYPE_OPERATOR	1
#define EU_KEY_MEDIA_SOURCE_TYPE_FIXED		2

//-----------------------------------------------------------------------------

#define EU_PATH_MAX_LENGTH				1041
#define EU_COMMON_NAME_MAX_LENGTH		65
#define EU_ADDRESS_MAX_LENGTH			257
#define EU_PORT_MAX_LENGTH				6
#define EU_USER_NAME_MAX_LENGTH			65

//-----------------------------------------------------------------------------

#define EU_SUBJECT_TYPE_UNDIFFERENCED		0
#define EU_SUBJECT_TYPE_CA					1
#define EU_SUBJECT_TYPE_CA_SERVER			2
#define EU_SUBJECT_TYPE_RA_ADMINISTRATOR	3
#define EU_SUBJECT_TYPE_END_USER			4

#define EU_SUBJECT_CA_SERVER_SUB_TYPE_UNDIFFERENCED	0
#define EU_SUBJECT_CA_SERVER_SUB_TYPE_CMP			1
#define EU_SUBJECT_CA_SERVER_SUB_TYPE_TSP			2
#define EU_SUBJECT_CA_SERVER_SUB_TYPE_OCSP			3

//-----------------------------------------------------------------------------

#define EU_CERT_INFO_EX_VERSION		2

//-----------------------------------------------------------------------------

#define EU_CERT_KEY_TYPE_UNKNOWN		0x00
#define	EU_CERT_KEY_TYPE_DSTU4145		0x01
#define	EU_CERT_KEY_TYPE_RSA			0x02

//-----------------------------------------------------------------------------

#define EU_KEY_USAGE_UNKNOWN			0x0000
#define EU_KEY_USAGE_DIGITAL_SIGNATURE	0x0001
#define EU_KEY_USAGE_KEY_AGREEMENT		0x0010

//-----------------------------------------------------------------------------

#pragma pack(push, 1)
typedef struct
{
	BOOL		bFilled;

	PSTR		pszIssuer;
	PSTR		pszIssuerCN;

	DWORD		dwCRLNumber;
	SYSTEMTIME	stThisUpdate;
	SYSTEMTIME	stNextUpdate;
} EU_CRL_INFO, *PEU_CRL_INFO;
#pragma pack(pop)

//-----------------------------------------------------------------------------

#pragma pack(push, 1)
typedef struct
{
	BOOL		bFilled;

	DWORD		dwVersion;

	PSTR		pszIssuer;
	PSTR		pszIssuerCN;
	PSTR		pszSerial;

	PSTR		pszSubject;
	PSTR		pszSubjCN;
	PSTR		pszSubjOrg;
	PSTR		pszSubjOrgUnit;
	PSTR		pszSubjTitle;
	PSTR		pszSubjState;
	PSTR		pszSubjLocality;
	PSTR		pszSubjFullName;
	PSTR		pszSubjAddress;
	PSTR		pszSubjPhone;
	PSTR		pszSubjEMail;
	PSTR		pszSubjDNS;
	PSTR		pszSubjEDRPOUCode;
	PSTR		pszSubjDRFOCode;

	PSTR		pszSubjNBUCode;
	PSTR		pszSubjSPFMCode;
	PSTR		pszSubjOCode;
	PSTR		pszSubjOUCode;
	PSTR		pszSubjUserCode;

	SYSTEMTIME	stCertBeginTime;
	SYSTEMTIME	stCertEndTime;
	BOOL		bPrivKeyTimes;
	SYSTEMTIME	stPrivKeyBeginTime;
	SYSTEMTIME	stPrivKeyEndTime;

	DWORD		dwPublicKeyBits;
	PSTR		pszPublicKey;
	PSTR		pszPublicKeyID;

	BOOL		bECDHPublicKey;
	DWORD		dwECDHPublicKeyBits;
	PSTR		pszECDHPublicKey;
	PSTR		pszECDHPublicKeyID;

	PSTR		pszIssuerPublicKeyID;

	PSTR		pszKeyUsage;
	PSTR		pszExtKeyUsages;
	PSTR		pszPolicies;

	PSTR		pszCRLDistribPoint1;
	PSTR		pszCRLDistribPoint2;

	BOOL		bPowerCert;

	BOOL		bSubjType;
	BOOL		bSubjCA;
} EU_CERT_INFO, *PEU_CERT_INFO;
#pragma pack(pop)

//-----------------------------------------------------------------------------

#pragma pack(push, 1)
typedef struct
{
	BOOL		bFilled;

	DWORD		dwVersion;

	PSTR		pszIssuer;
	PSTR		pszIssuerCN;
	PSTR		pszSerial;

	PSTR		pszSubject;
	PSTR		pszSubjCN;
	PSTR		pszSubjOrg;
	PSTR		pszSubjOrgUnit;
	PSTR		pszSubjTitle;
	PSTR		pszSubjState;
	PSTR		pszSubjLocality;
	PSTR		pszSubjFullName;
	PSTR		pszSubjAddress;
	PSTR		pszSubjPhone;
	PSTR		pszSubjEMail;
	PSTR		pszSubjDNS;
	PSTR		pszSubjEDRPOUCode;
	PSTR		pszSubjDRFOCode;

	PSTR		pszSubjNBUCode;
	PSTR		pszSubjSPFMCode;
	PSTR		pszSubjOCode;
	PSTR		pszSubjOUCode;
	PSTR		pszSubjUserCode;

	SYSTEMTIME	stCertBeginTime;
	SYSTEMTIME	stCertEndTime;
	BOOL		bPrivKeyTimes;
	SYSTEMTIME	stPrivKeyBeginTime;
	SYSTEMTIME	stPrivKeyEndTime;

	DWORD		dwPublicKeyBits;
	PSTR		pszPublicKey;
	PSTR		pszPublicKeyID;

	PSTR		pszIssuerPublicKeyID;

	PSTR		pszKeyUsage;
	PSTR		pszExtKeyUsages;
	PSTR		pszPolicies;

	PSTR		pszCRLDistribPoint1;
	PSTR		pszCRLDistribPoint2;

	BOOL		bPowerCert;

	BOOL		bSubjType;
	BOOL		bSubjCA;

	INT			iChainLength;

	PSTR		pszUPN;

	DWORD		dwPublicKeyType;
	DWORD		dwKeyUsage;

	PSTR		pszRSAModul;
	PSTR		pszRSAExponent;

	PSTR		pszOCSPAccessInfo;
	PSTR		pszIssuerAccessInfo;
	PSTR		pszTSPAccessInfo;

	BOOL		bLimitValueAvailable;
	DWORD		dwLimitValue;
	PSTR		pszLimitValueCurrency;

} EU_CERT_INFO_EX, *PEU_CERT_INFO_EX, **PPEU_CERT_INFO_EX;
#pragma pack(pop)

//-----------------------------------------------------------------------------

#pragma pack(push, 1)
typedef struct
{
	BOOL		bFilled;

	DWORD		dwVersion;

	PSTR		pszIssuer;
	PSTR		pszIssuerCN;
	PSTR		pszIssuerPublicKeyID;

	DWORD		dwCRLNumber;
	SYSTEMTIME	stThisUpdate;
	SYSTEMTIME	stNextUpdate;

	DWORD		dwRevokedItemsCount;
} EU_CRL_DETAILED_INFO, *PEU_CRL_DETAILED_INFO;
#pragma pack(pop)

//-----------------------------------------------------------------------------

#pragma pack(push, 1)
typedef struct
{
	DWORD		dwCount;
	
	PEU_CERT_INFO_EX 
				*ppCertificates;

} EU_CERTIFICATES, *PEU_CERTIFICATES, **PPEU_CERTIFICATES;
#pragma pack(pop)

//=============================================================================

typedef DWORD (WINAPI *PEU_INITIALIZE)();

typedef BOOL (WINAPI *PEU_IS_INITIALIZED)();

typedef VOID (WINAPI *PEU_FINALIZE)();

//-----------------------------------------------------------------------------

typedef VOID (WINAPI *PEU_SET_SETTINGS)();

//-----------------------------------------------------------------------------

typedef VOID (WINAPI *PEU_SHOW_CERTIFICATES)();

typedef VOID (WINAPI *PEU_SHOW_CRLS)();

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_GET_PRIVATE_KEY_MEDIA)(
	PEU_KEY_MEDIA	pKeyMedia);

typedef DWORD (WINAPI *PEU_READ_PRIVATE_KEY)(
	PEU_KEY_MEDIA	pKeyMedia,
	PEU_CERT_OWNER_INFO	pInfo);

typedef BOOL (WINAPI *PEU_IS_PRIVATE_KEY_READED)();

typedef VOID (WINAPI *PEU_RESET_PRIVATE_KEY)();

typedef VOID (WINAPI *PEU_FREE_CERT_OWNER_INFO)(
	PEU_CERT_OWNER_INFO	pInfo);

//-----------------------------------------------------------------------------

typedef VOID (WINAPI *PEU_SHOW_OWN_CERTIFICATE)();

typedef VOID (WINAPI *PEU_SHOW_SIGN_INFO)(
	PEU_SIGN_INFO	pInfo);

typedef VOID (WINAPI *PEU_FREE_SIGN_INFO)(
	PEU_SIGN_INFO	pInfo);

//-----------------------------------------------------------------------------

typedef VOID (WINAPI *PEU_FREE_MEMORY)(
	PBYTE			pbMemory);

//-----------------------------------------------------------------------------

typedef PSTR (WINAPI *PEU_GET_ERROR_DESC)(
	DWORD			dwError);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_SIGN_DATA)(
	PBYTE			pbData,
	DWORD			dwDataLength,
	PSTR			*ppszSign,
	PBYTE			*ppbSign,
	PDWORD			pdwSignLength);

typedef DWORD (WINAPI *PEU_VERIFY_DATA)(
	PBYTE			pbData,
	DWORD			dwDataLength,
	PSTR			pszSign,
	PBYTE			pbSign,
	DWORD			dwSignLength,
	PEU_SIGN_INFO	pSignInfo);

typedef DWORD (WINAPI *PEU_SIGN_DATA_CONTINUE)(
	PBYTE			pbData,
	DWORD			dwDataLength);

typedef DWORD (WINAPI *PEU_SIGN_DATA_END)(
	PSTR			*ppszSign,
	PBYTE			*ppbSign,
	PDWORD			pdwSignLength);

typedef DWORD (WINAPI *PEU_VERIFY_DATA_BEGIN)(
	PSTR			pszSign,
	PBYTE			pbSign,
	DWORD			dwSignLength);

typedef DWORD (WINAPI *PEU_VERIFY_DATA_CONTINUE)(
	PBYTE			pbData,
	DWORD			dwDataLength);

typedef DWORD (WINAPI *PEU_VERIFY_DATA_END)(
	PEU_SIGN_INFO	pSignInfo);

typedef VOID (WINAPI *PEU_RESET_OPERATION)();

typedef DWORD (WINAPI *PEU_SIGN_FILE)(
	PSTR			pszFileName,
	PSTR			pszFileNameWithSign,
	BOOL			bExternalSign);

typedef DWORD (WINAPI *PEU_VERIFY_FILE)(
	PSTR			pszFileNameWithSign,
	PSTR			pszFileName,
	PEU_SIGN_INFO	pSignInfo);

typedef DWORD (WINAPI *PEU_SIGN_DATA_INTERNAL)(
	BOOL			bAppendCert,
	PBYTE			pbData,
	DWORD			dwDataLength,
	PSTR			*ppszSignedData,
	PBYTE			*ppbSignedData,
	PDWORD			pdwSignedDataLength);

typedef DWORD (WINAPI *PEU_VERIFY_DATA_INTERNAL)(
	PSTR			pszSignedData,
	PBYTE			pbSignedData,
	DWORD			dwSignedDataLength,
	PBYTE			*ppbData,
	PDWORD			pdwDataLength,
	PEU_SIGN_INFO	pSignInfo);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_SELECT_CERT_INFO)(
	PEU_CERT_OWNER_INFO	pInfo);

//-----------------------------------------------------------------------------

typedef VOID (WINAPI *PEU_SET_UI_MODE)(
	BOOL			bUIMode);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_HASH_DATA)(
	PBYTE			pbData,
	DWORD			dwDataLength,
	PSTR			*ppszHash,
	PBYTE			*ppbHash,
	PDWORD			pdwHashLength);

typedef DWORD (WINAPI *PEU_HASH_DATA_CONTINUE)(
	PBYTE			pbData,
	DWORD			dwDataLength);

typedef DWORD (WINAPI *PEU_HASH_DATA_END)(
	PSTR			*ppszHash,
	PBYTE			*ppbHash,
	PDWORD			pdwHashLength);

typedef DWORD (WINAPI *PEU_HASH_FILE)(
	PSTR			pszFileName,
	PSTR			*ppszHash,
	PBYTE			*ppbHash,
	PDWORD			pdwHashLength);

typedef DWORD (WINAPI *PEU_SIGN_HASH)(
	PSTR			pszHash,
	PBYTE			pbHash,
	DWORD			dwHashLength,
	PSTR			*ppszSign,
	PBYTE			*ppbSign,
	PDWORD			pdwSignLength);

typedef DWORD (WINAPI *PEU_VERIFY_HASH)(
	PSTR			pszHash,
	PBYTE			pbHash,
	DWORD			dwHashLength,
	PSTR			pszSign,
	PBYTE			pbSign,
	DWORD			dwSignLength,
	PEU_SIGN_INFO	pSignInfo);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_ENUM_KEY_MEDIA_TYPES)(
	DWORD			dwTypeIndex,
	PSTR			pszTypeDescription);

typedef DWORD (WINAPI *PEU_ENUM_KEY_MEDIA_DEVICES)(
	DWORD			dwTypeIndex,
	DWORD			dwDeviceIndex,
	PSTR			pszDeviceDescription);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_GET_FILE_STORE_SETTINGS)(
	PSTR			pszPath,
	PBOOL			pbCheckCRLs,
	PBOOL			pbAutoRefresh,
	PBOOL			pbOwnCRLsOnly,
	PBOOL			pbFullAndDeltaCRLs,
	PBOOL			pbAutoDownloadCRLs,
	PBOOL			pbSaveLoadedCerts,
	PDWORD			pdwExpireTime);

typedef DWORD (WINAPI *PEU_SET_FILE_STORE_SETTINGS)(
	PSTR			pszPath,
	BOOL			bCheckCRLs,
	BOOL			bAutoRefresh,
	BOOL			bOwnCRLsOnly,
	BOOL			bFullAndDeltaCRLs,
	BOOL			bAutoDownloadCRLs,
	BOOL			bSaveLoadedCerts,
	DWORD			dwExpireTime);

typedef DWORD (WINAPI *PEU_GET_PROXY_SETTINGS)(
	PBOOL			pbUseProxy,
	PBOOL			pbAnonymous,
	PSTR			pszAddress,
	PSTR			pszPort,
	PSTR			pszUser,
	PSTR			pszPassword,
	PBOOL			pbSavePassword);

typedef DWORD (WINAPI *PEU_SET_PROXY_SETTINGS)(
	BOOL			bUseProxy,
	BOOL			bAnonymous,
	PSTR			pszAddress,
	PSTR			pszPort,
	PSTR			pszUser,
	PSTR			pszPassword,
	BOOL			bSavePassword);

typedef DWORD (WINAPI *PEU_GET_OCSP_SETTINGS)(
	PBOOL			pbUseOCSP,
	PBOOL			pbBeforeStore,
	PSTR			pszAddress,
	PSTR			pszPort);

typedef DWORD (WINAPI *PEU_SET_OCSP_SETTINGS)(
	BOOL			bUseOCSP,
	BOOL			bBeforeStore,
	PSTR			pszAddress,
	PSTR			pszPort);

typedef DWORD (WINAPI *PEU_GET_TSP_SETTINGS)(
	PBOOL			pbGetStamps,
	PSTR			pszAddress,
	PSTR			pszPort);

typedef DWORD (WINAPI *PEU_SET_TSP_SETTINGS)(
	BOOL			bGetStamps,
	PSTR			pszAddress,
	PSTR			pszPort);

typedef DWORD (WINAPI *PEU_GET_LDAP_SETTINGS)(
	PBOOL			pbUseLDAP,
	PSTR			pszAddress,
	PSTR			pszPort,
	PBOOL			pbAnonymous,
	PSTR			pszUser,
	PSTR			pszPassword);

typedef DWORD (WINAPI *PEU_SET_LDAP_SETTINGS)(
	BOOL			bUseLDAP,
	PSTR			pszAddress,
	PSTR			pszPort,
	BOOL			bAnonymous,
	PSTR			pszUser,
	PSTR			pszPassword);

typedef DWORD (WINAPI *PEU_GET_CMP_SETTINGS)(
	PBOOL			pbUseCMP,
	PSTR			pszAddress,
	PSTR			pszPort,
	PSTR			pszCommonName);

typedef DWORD (WINAPI *PEU_SET_CMP_SETTINGS)(
	BOOL			bUseCMP,
	PSTR			pszAddress,
	PSTR			pszPort,
	PSTR			pszCommonName);

typedef BOOL (WINAPI *PEU_DOES_NEED_SET_SETTINGS)();

typedef DWORD (WINAPI *PEU_GET_CERTIFICATES_COUNT)(
	DWORD			dwSubjectType,
	DWORD			dwSubjectSubType,
	PDWORD			pdwCount);

typedef DWORD (WINAPI *PEU_ENUM_CERTIFICATES)(
	DWORD			dwSubjectType,
	DWORD			dwSubjectSubType,
	DWORD			dwIndex,
	PEU_CERT_OWNER_INFO	pInfo);

typedef DWORD (WINAPI *PEU_GET_CRLS_COUNT)(
	PDWORD			pdwCount);

typedef DWORD (WINAPI *PEU_ENUM_CRLS)(
	DWORD			dwIndex,
	PEU_CRL_INFO	pInfo);

typedef VOID (WINAPI *PEU_FREE_CRL_INFO)(
	PEU_CRL_INFO	pInfo);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_GET_CERTIFICATE_INFO)(
	PSTR			pszIssuer,
	PSTR			pszSerial,
	PEU_CERT_INFO	pInfo);

typedef VOID (WINAPI *PEU_FREE_CERTIFICATE_INFO)(
	PEU_CERT_INFO	pInfo);

typedef DWORD (WINAPI *PEU_GET_CRL_DETAILED_INFO)(
	PSTR			pszIssuer,
	DWORD			dwCRLNumber,
	PEU_CRL_DETAILED_INFO
					pInfo);

typedef VOID (WINAPI *PEU_FREE_CRL_DETAILED_INFO)(
	PEU_CRL_DETAILED_INFO
					pInfo);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_GET_PRIVATE_KEY_MEDIA_SETTINGS)(
	PDWORD			pdwSourceType,
	PBOOL			pbShowErrors,
	PDWORD			pdwTypeIndex,
	PDWORD			pdwDevIndex,
	PSTR			pszPassword);

typedef DWORD (WINAPI *PEU_SET_PRIVATE_KEY_MEDIA_SETTINGS)(
	DWORD			dwSourceType,
	BOOL			bShowErrors,
	DWORD			dwTypeIndex,
	DWORD			dwDevIndex,
	PSTR			pszPassword);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_SELECT_CMP_SERVER)(
	PSTR			pszCommonName,
	PSTR			pszDNS);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_RAW_SIGN_DATA)(
	PBYTE			pbData,
	DWORD			dwDataLength,
	PSTR			*ppszSign,
	PBYTE			*ppbSign,
	PDWORD			pdwSignLength);

typedef DWORD (WINAPI *PEU_RAW_VERIFY_DATA)(
	PBYTE			pbData,
	DWORD			dwDataLength,
	PSTR			pszSign,
	PBYTE			pbSign,
	DWORD			dwSignLength,
	PEU_SIGN_INFO	pSignInfo);

typedef DWORD (WINAPI *PEU_RAW_SIGN_HASH)(
	PSTR			pszHash,
	PBYTE			pbHash,
	DWORD			dwHashLength,
	PSTR			*ppszSign,
	PBYTE			*ppbSign,
	PDWORD			pdwSignLength);

typedef DWORD (WINAPI *PEU_RAW_VERIFY_HASH)(
	PSTR			pszHash,
	PBYTE			pbHash,
	DWORD			dwHashLength,
	PSTR			pszSign,
	PBYTE			pbSign,
	DWORD			dwSignLength,
	PEU_SIGN_INFO	pInfo);

typedef DWORD (WINAPI *PEU_RAW_SIGN_FILE)(
	PSTR			pszFileName,
	PSTR			pszFileNameWithSign);

typedef DWORD (WINAPI *PEU_RAW_VERIFY_FILE)(
	PSTR			pszFileNameWithSign,
	PSTR			pszFileName,
	PEU_SIGN_INFO	pSignInfo);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_BASE64_ENCODE)(
	PBYTE			pbData,
	DWORD			dwDataLength,
	PSTR			*ppszData);

typedef DWORD (WINAPI *PEU_BASE64_DECODE)(
	PSTR			pszData,
	PBYTE			*ppbData,
	PDWORD			pdwDataLength);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_ENVELOP_DATA)(
	PSTR			pszRecipientCertIssuer,
	PSTR			pszRecipientCertSerial,
	BOOL			bSignData,
	PBYTE			pbData,
	DWORD			dwDataLength,
	PSTR			*ppszEnvelopedData,
	PBYTE			*ppbEnvelopedData,
	PDWORD			pdwEnvelopedDataLength);

typedef DWORD (WINAPI *PEU_DEVELOP_DATA)(
	PSTR			pszEnvelopedData,
	PBYTE			pbEnvelopedData,
	DWORD			dwEnvelopedDataLength,
	PBYTE			*ppbData,
	PDWORD			pdwDataLength,
	PEU_ENVELOP_INFO
					pInfo);

typedef VOID (WINAPI *PEU_SHOW_SENDER_INFO)(
	PEU_ENVELOP_INFO
					pInfo);

typedef VOID (WINAPI *PEU_FREE_SENDER_INFO)(
	PEU_ENVELOP_INFO
					pInfo);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_PARSE_CERTIFICATE)(
	PBYTE			pbCertificate,
	DWORD			dwCertificateLength,
	PEU_CERT_INFO	pInfo);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_READ_PRIVATE_KEY_BINARY)(
	PBYTE			pbPrivateKey,
	DWORD			dwPrivateKeyLength,
	PSTR			pszPassword,
	PEU_CERT_OWNER_INFO	pInfo);

typedef DWORD (WINAPI *PEU_READ_PRIVATE_KEY_FILE)(
	PSTR			pszPrivateKeyFileName,
	PSTR			pszPassword,
	PEU_CERT_OWNER_INFO	pInfo);

//-----------------------------------------------------------------------------

typedef VOID (WINAPI *PEU_SESSION_DESTROY)(
	PVOID			pvSession);

typedef DWORD (WINAPI *PEU_CLIENT_SESSION_CREATE_STEP1)(
	DWORD			dwExpireTime,
	PVOID			*ppvClientSession,
	PBYTE			*ppbClientData,
	PDWORD			pdwClientDataLength);

typedef DWORD (WINAPI *PEU_SERVER_SESSION_CREATE_STEP1)(
	DWORD			dwExpireTime,
	PBYTE			pbClientData,
	DWORD			dwClientDataLength,
	PVOID			*ppvServerSession,
	PBYTE			*ppbServerData,
	PDWORD			pdwServerDataLength);

typedef DWORD (WINAPI *PEU_CLIENT_SESSION_CREATE_STEP2)(
	PVOID			pvClientSession,
	PBYTE			pbServerData,
	DWORD			dwServerDataLength,
	PBYTE			*ppbClientData,
	PDWORD			pdwClientDataLength);

typedef DWORD (WINAPI *PEU_SERVER_SESSION_CREATE_STEP2)(
	PVOID			pvServerSession,
	PBYTE			pbClientData,
	DWORD			dwClientDataLength);

typedef BOOL (WINAPI *PEU_SESSION_IS_INITIALIZED)(
	PVOID			pvSession);

typedef DWORD (WINAPI *PEU_SESSION_SAVE)(
	PVOID			pvSession,
	PBYTE			*ppbSessionData,
	PDWORD			pdwSessionDataLength);

typedef DWORD (WINAPI *PEU_SESSION_LOAD)(
	PBYTE			pbSessionData,
	DWORD			dwSessionDataLength,
	PVOID			*ppvSession);

typedef DWORD (WINAPI *PEU_SESSION_CHECK_CERTIFICATES)(
	PVOID			pvSession);

typedef DWORD (WINAPI *PEU_SESSION_ENCRYPT)(
	PVOID			pvSession,
	PBYTE			pbData,
	DWORD			dwDataLength,
	PBYTE			*ppbEncryptedData,
	PDWORD			pdwEncryptedDataLength);

typedef DWORD (WINAPI *PEU_SESSION_ENCRYPT_CONTINUE)(
	PVOID			pvSession,
	PBYTE			pbData,
	DWORD			dwDataLength);

typedef DWORD (WINAPI *PEU_SESSION_DECRYPT)(
	PVOID			pvSession,
	PBYTE			pbEncryptedData,
	DWORD			dwEncryptedDataLength,
	PBYTE			*ppbData,
	PDWORD			pdwDataLength);

typedef DWORD (WINAPI *PEU_SESSION_DECRYPT_CONTINUE)(
	PVOID			pvSession,
	PBYTE			pbEncryptedData,
	DWORD			dwEncryptedDataLength);

//-----------------------------------------------------------------------------

typedef BOOL (WINAPI *PEU_IS_SIGNED_DATA)(
	PBYTE			pbData,
	DWORD			dwDataLength);

typedef BOOL (WINAPI *PEU_IS_ENVELOPED_DATA)(
	PBYTE			pbData,
	DWORD			dwDataLength);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_SESSION_GET_PEER_CERTIFICATE_INFO)(
	PVOID			pvSession,
	PEU_CERT_INFO	pInfo);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_SAVE_CERTIFICATE)(
	PBYTE			pbCertificate,
	DWORD			dwCertificateLength);

typedef DWORD (WINAPI *PEU_REFRESH_FILE_STORE)(
	BOOL			bReload);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_GET_MODE_SETTINGS)(
	PBOOL			pbOfflineMode);

typedef DWORD (WINAPI *PEU_SET_MODE_SETTINGS)(
	BOOL			bOfflineMode);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_CHECK_CERTIFICATE)(
	PBYTE			pbCertificate,
	DWORD			dwCertificateLength);

//-----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_ENVELOP_FILE)(
	PSTR			pszRecipientCertIssuer,
	PSTR			pszRecipientCertSerial,
	BOOL			bSignData,
	PSTR			pszFileName,
	PSTR			pszEnvelopedFileName);

typedef DWORD (WINAPI *PEU_DEVELOP_FILE)(
	PSTR			pszEnvelopedFileName,
	PSTR			pszFileName,
	PEU_ENVELOP_INFO
					pInfo);

typedef BOOL (WINAPI *PEU_IS_SIGNED_FILE)(
	PSTR			pszFileName);

typedef BOOL (WINAPI *PEU_IS_ENVELOPED_FILE)(
	PSTR			pszFileName);

//----------------------------------------------------------------------------

typedef DWORD(WINAPI *PEU_GET_CERTIFICATE)(
	PSTR			pszIssuer,
	PSTR			pszSerial,
	PSTR			*ppszCertificate,
	PBYTE			*ppbCertificate,
	PDWORD			pdwCertificateLength);

typedef DWORD(WINAPI *PEU_GET_OWN_CERTIFICATE)(
	PSTR			*ppszCertificate,
	PBYTE			*ppbCertificate,
	PDWORD			pdwCertificateLength);

//----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_ENUM_OWN_CERTIFICATES)(
	DWORD			dwIndex,
	PPEU_CERT_INFO_EX 
					ppInfo);

typedef DWORD (WINAPI *PEU_GET_CERTIFICATE_INFO_EX)(
	PSTR			pszIssuer,
	PSTR			pszSerial,
	PPEU_CERT_INFO_EX	
					ppInfo);

typedef VOID (WINAPI *PEU_FREE_CERTIFICATE_INFO_EX)(
	PEU_CERT_INFO_EX
					pInfo);

//----------------------------------------------------------------------------

typedef DWORD (WINAPI *PEU_GET_RECEIVERS_CERTIFICATES)(
	PPEU_CERTIFICATES
					pCertificates);

typedef VOID (WINAPI *PEU_FREE_RECEIVERS_CERTIFICATES)(
	PEU_CERTIFICATES
					pCertificates);

//=============================================================================

typedef struct
{
	PEU_INITIALIZE				Initialize;
	PEU_IS_INITIALIZED			IsInitialized;
	PEU_FINALIZE				Finalize;

	PEU_SET_SETTINGS			SetSettings;

	PEU_SHOW_CERTIFICATES		ShowCertificates;
	PEU_SHOW_CRLS				ShowCRLs;

	PEU_GET_PRIVATE_KEY_MEDIA	GetPrivateKeyMedia;
	PEU_READ_PRIVATE_KEY		ReadPrivateKey;
	PEU_IS_PRIVATE_KEY_READED	IsPrivateKeyReaded;
	PEU_RESET_PRIVATE_KEY		ResetPrivateKey;
	PEU_FREE_CERT_OWNER_INFO	FreeCertOwnerInfo;

	PEU_SHOW_OWN_CERTIFICATE	ShowOwnCertificate;
	PEU_SHOW_SIGN_INFO			ShowSignInfo;
	PEU_FREE_SIGN_INFO			FreeSignInfo;

	PEU_FREE_MEMORY				FreeMemory;

	PEU_GET_ERROR_DESC			GetErrorDesc;

	PEU_SIGN_DATA				SignData;
	PEU_VERIFY_DATA				VerifyData;

	PEU_SIGN_DATA_CONTINUE		SignDataContinue;
	PEU_SIGN_DATA_END			SignDataEnd;
	PEU_VERIFY_DATA_BEGIN		VerifyDataBegin;
	PEU_VERIFY_DATA_CONTINUE	VerifyDataContinue;
	PEU_VERIFY_DATA_END			VerifyDataEnd;
	PEU_RESET_OPERATION			ResetOperation;

	PEU_SIGN_FILE				SignFile;
	PEU_VERIFY_FILE				VerifyFile;

	PEU_SIGN_DATA_INTERNAL		SignDataInternal;
	PEU_VERIFY_DATA_INTERNAL	VerifyDataInternal;

	PEU_SELECT_CERT_INFO		SelectCertInfo;

	PEU_SET_UI_MODE				SetUIMode;

	PEU_HASH_DATA				HashData;
	PEU_HASH_DATA_CONTINUE		HashDataContinue;
	PEU_HASH_DATA_END			HashDataEnd;
	PEU_HASH_FILE				HashFile;
	PEU_SIGN_HASH				SignHash;
	PEU_VERIFY_HASH				VerifyHash;

	PEU_ENUM_KEY_MEDIA_TYPES	EnumKeyMediaTypes;
	PEU_ENUM_KEY_MEDIA_DEVICES	EnumKeyMediaDevices;

	PEU_GET_FILE_STORE_SETTINGS	GetFileStoreSettings;
	PEU_SET_FILE_STORE_SETTINGS	SetFileStoreSettings;
	PEU_GET_PROXY_SETTINGS		GetProxySettings;
	PEU_SET_PROXY_SETTINGS		SetProxySettings;
	PEU_GET_OCSP_SETTINGS		GetOCSPSettings;
	PEU_SET_OCSP_SETTINGS		SetOCSPSettings;
	PEU_GET_TSP_SETTINGS		GetTSPSettings;
	PEU_SET_TSP_SETTINGS		SetTSPSettings;
	PEU_GET_LDAP_SETTINGS		GetLDAPSettings;
	PEU_SET_LDAP_SETTINGS		SetLDAPSettings;

	PEU_GET_CERTIFICATES_COUNT	GetCertificatesCount;
	PEU_ENUM_CERTIFICATES		EnumCertificates;
	PEU_GET_CRLS_COUNT			GetCRLsCount;
	PEU_ENUM_CRLS				EnumCRLs;
	PEU_FREE_CRL_INFO			FreeCRLInfo;

	PEU_GET_CERTIFICATE_INFO	GetCertificateInfo;
	PEU_FREE_CERTIFICATE_INFO	FreeCertificateInfo;
	PEU_GET_CRL_DETAILED_INFO	GetCRLDetailedInfo;
	PEU_FREE_CRL_DETAILED_INFO	FreeCRLDetailedInfo;

	PEU_GET_CMP_SETTINGS		GetCMPSettings;
	PEU_SET_CMP_SETTINGS		SetCMPSettings;
	PEU_DOES_NEED_SET_SETTINGS	DoesNeedSetSettings;

	PEU_GET_PRIVATE_KEY_MEDIA_SETTINGS
								GetPrivateKeyMediaSettings;
	PEU_SET_PRIVATE_KEY_MEDIA_SETTINGS
								SetPrivateKeyMediaSettings;

	PEU_SELECT_CMP_SERVER		SelectCMPServer;

	PEU_RAW_SIGN_DATA			RawSignData;
	PEU_RAW_VERIFY_DATA			RawVerifyData;
	PEU_RAW_SIGN_HASH			RawSignHash;
	PEU_RAW_VERIFY_HASH			RawVerifyHash;
	PEU_RAW_SIGN_FILE			RawSignFile;
	PEU_RAW_VERIFY_FILE			RawVerifyFile;

	PEU_BASE64_ENCODE			BASE64Encode;
	PEU_BASE64_DECODE			BASE64Decode;

	PEU_ENVELOP_DATA			EnvelopData;
	PEU_DEVELOP_DATA			DevelopData;
	PEU_SHOW_SENDER_INFO		ShowSenderInfo;
	PEU_FREE_SENDER_INFO		FreeSenderInfo;

	PEU_PARSE_CERTIFICATE		ParseCertificate;

	PEU_READ_PRIVATE_KEY_BINARY	ReadPrivateKeyBinary;
	PEU_READ_PRIVATE_KEY_FILE	ReadPrivateKeyFile;

	PEU_SESSION_DESTROY			SessionDestroy;
	PEU_CLIENT_SESSION_CREATE_STEP1
								ClientSessionCreateStep1;
	PEU_SERVER_SESSION_CREATE_STEP1
								ServerSessionCreateStep1;
	PEU_CLIENT_SESSION_CREATE_STEP2
								ClientSessionCreateStep2;
	PEU_SERVER_SESSION_CREATE_STEP2
								ServerSessionCreateStep2;
	PEU_SESSION_IS_INITIALIZED	SessionIsInitialized;
	PEU_SESSION_SAVE			SessionSave;
	PEU_SESSION_LOAD			SessionLoad;
	PEU_SESSION_CHECK_CERTIFICATES
								SessionCheckCertificates;
	PEU_SESSION_ENCRYPT			SessionEncrypt;
	PEU_SESSION_ENCRYPT_CONTINUE
								SessionEncryptContinue;
	PEU_SESSION_DECRYPT			SessionDecrypt;
	PEU_SESSION_DECRYPT_CONTINUE
								SessionDecryptContinue;

	PEU_IS_SIGNED_DATA			IsSignedData;
	PEU_IS_ENVELOPED_DATA		IsEnvelopedData;

	PEU_SESSION_GET_PEER_CERTIFICATE_INFO
								SessionGetPeerCertificateInfo;

	PEU_SAVE_CERTIFICATE		SaveCertificate;
	PEU_REFRESH_FILE_STORE		RefreshFileStore;

	PEU_GET_MODE_SETTINGS		GetModeSettings;
	PEU_SET_MODE_SETTINGS		SetModeSettings;

	PEU_CHECK_CERTIFICATE		CheckCertificate;

	PEU_ENVELOP_FILE			EnvelopFile;
	PEU_DEVELOP_FILE			DevelopFile;
	PEU_IS_SIGNED_FILE			IsSignedFile;
	PEU_IS_ENVELOPED_FILE		IsEnvelopedFile;

	PEU_GET_CERTIFICATE			GetCertificate;
	PEU_GET_OWN_CERTIFICATE		GetOwnCertificate;

	PEU_ENUM_OWN_CERTIFICATES	EnumOwnCertificates;
	PEU_GET_CERTIFICATE_INFO_EX GetCertificateInfoEx;
	PEU_FREE_CERTIFICATE_INFO_EX
								FreeCertificateInfoEx;

	PEU_GET_RECEIVERS_CERTIFICATES GetReceiversCertificates;
	PEU_FREE_RECEIVERS_CERTIFICATES FreeReceiversCertificates;
} EU_INTERFACE, *PEU_INTERFACE;

//=============================================================================

#define EU_LIBRARY_NAME		"EUSignCP.dll"

//=============================================================================

BOOL EULoad();

PEU_INTERFACE EUGetInterface();

VOID EUUnload();

//=============================================================================

#endif // EU_SIGN_CP_H
