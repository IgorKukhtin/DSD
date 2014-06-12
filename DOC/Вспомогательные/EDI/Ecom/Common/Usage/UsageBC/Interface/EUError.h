#pragma once

//==============================================================================

const DWORD	EU_ERROR_NONE							= 0x0000;
const DWORD	EU_ERROR_UNKNOWN						= 0xFFFF;
const DWORD	EU_ERROR_NOT_SUPPORTED					= 0xFFFE;

const DWORD	EU_ERROR_NOT_INITIALIZED				= 0x0001;
const DWORD	EU_ERROR_BAD_PARAMETER					= 0x0002;
const DWORD	EU_ERROR_LIBRARY_LOAD					= 0x0003;
const DWORD	EU_ERROR_READ_SETTINGS					= 0x0004;
const DWORD	EU_ERROR_TRANSMIT_REQUEST				= 0x0005;
const DWORD	EU_ERROR_MEMORY_ALLOCATION				= 0x0006;
const DWORD	EU_WARNING_END_OF_ENUM					= 0x0007;
const DWORD	EU_ERROR_PROXY_NOT_AUTHORIZED			= 0x0008;
const DWORD	EU_ERROR_NO_GUI_DIALOGS					= 0x0009;
const DWORD	EU_ERROR_DOWNLOAD_FILE					= 0x000A;
const DWORD EU_ERROR_WRITE_SETTINGS					= 0x000B;
const DWORD EU_ERROR_CANCELED_BY_GUI				= 0x000C;
const DWORD EU_ERROR_OFFLINE_MODE					= 0x000D;

//==============================================================================

const DWORD	EU_ERROR_KEY_MEDIAS_FAILED				= 0x0011;
const DWORD	EU_ERROR_KEY_MEDIAS_ACCESS_FAILED		= 0x0012;
const DWORD	EU_ERROR_KEY_MEDIAS_READ_FAILED			= 0x0013;
const DWORD	EU_ERROR_KEY_MEDIAS_WRITE_FAILED		= 0x0014;
const DWORD	EU_WARNING_KEY_MEDIAS_READ_ONLY			= 0x0015;
const DWORD	EU_ERROR_KEY_MEDIAS_DELETE				= 0x0016;
const DWORD	EU_ERROR_KEY_MEDIAS_CLEAR				= 0x0017;
const DWORD	EU_ERROR_BAD_PRIVATE_KEY				= 0x0018;

//==============================================================================

const DWORD	EU_ERROR_PKI_FORMATS_FAILED				= 0x0021;
const DWORD	EU_ERROR_CSP_FAILED						= 0x0022;
const DWORD	EU_ERROR_BAD_SIGNATURE					= 0x0023;
const DWORD EU_ERROR_AUTH_FAILED					= 0x0024;
const DWORD EU_ERROR_NOT_RECEIVER					= 0x0025;

//==============================================================================

const DWORD EU_ERROR_STORAGE_FAILED					= 0x0031;
const DWORD	EU_ERROR_BAD_CERT						= 0x0032;
const DWORD	EU_ERROR_CERT_NOT_FOUND					= 0x0033;
const DWORD	EU_ERROR_INVALID_CERT_TIME				= 0x0034;
const DWORD	EU_ERROR_CERT_IN_CRL					= 0x0035;
const DWORD	EU_ERROR_BAD_CRL						= 0x0036;
const DWORD	EU_ERROR_NO_VALID_CRLS					= 0x0037;

//==============================================================================

const DWORD	EU_ERROR_GET_TIME_STAMP					= 0x0041;
const DWORD	EU_ERROR_BAD_TSP_RESPONSE				= 0x0042;
const DWORD	EU_ERROR_TSP_SERVER_CERT_NOT_FOUND		= 0x0043;
const DWORD	EU_ERROR_TSP_SERVER_CERT_INVALID		= 0x0044;

//==============================================================================

const DWORD	EU_ERROR_GET_OCSP_STATUS				= 0x0051;
const DWORD EU_ERROR_BAD_OCSP_RESPONSE				= 0x0052;
const DWORD	EU_ERROR_CERT_BAD_BY_OCSP				= 0x0053;
const DWORD	EU_ERROR_OCSP_SERVER_CERT_NOT_FOUND		= 0x0054;
const DWORD	EU_ERROR_OCSP_SERVER_CERT_INVALID		= 0x0055;

//==============================================================================

const DWORD	EU_ERROR_LDAP_ERROR						= 0x0061;

//==============================================================================
