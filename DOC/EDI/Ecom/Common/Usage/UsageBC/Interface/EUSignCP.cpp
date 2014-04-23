//=============================================================================

#include "EUSignCP.h"

//=============================================================================

static	HMODULE			s_hLibrary = NULL;
static	EU_INTERFACE	s_Iface;

//=============================================================================

BOOL EULoad()
{
	if (s_hLibrary != NULL)
		return TRUE;

#ifdef PC_LIBS_IN_CURRENT
	CHAR szLibFile[MAX_PATH * 4 + 1];

	GetCurrentDirectory(MAX_PATH * 4, szLibFile);

	if (szLibFile[strlen(szLibFile) - 1] != '\\')
		strcat(szLibFile, "\\");

	strcat(szLibFile, EU_LIBRARY_NAME);

	s_hLibrary = LoadLibrary(szLibFile);
#else // PC_LIBS_IN_CURRENT
	s_hLibrary = LoadLibrary(EU_LIBRARY_NAME);
#endif // PC_LIBS_IN_CURRENT
	if(!s_hLibrary)
		return FALSE;

	s_Iface.Initialize = (PEU_INITIALIZE) 
		GetProcAddress(s_hLibrary, "EUInitialize");
	s_Iface.IsInitialized = (PEU_IS_INITIALIZED) 
		GetProcAddress(s_hLibrary, "EUIsInitialized");
	s_Iface.Finalize = (PEU_FINALIZE) 
		GetProcAddress(s_hLibrary, "EUFinalize");

	s_Iface.SetSettings = (PEU_SET_SETTINGS) 
		GetProcAddress(s_hLibrary, "EUSetSettings");

	s_Iface.ShowCertificates = (PEU_SHOW_CERTIFICATES) 
		GetProcAddress(s_hLibrary, "EUShowCertificates");
	s_Iface.ShowCRLs = (PEU_SHOW_CRLS) 
		GetProcAddress(s_hLibrary, "EUShowCRLs");

	s_Iface.GetPrivateKeyMedia = (PEU_GET_PRIVATE_KEY_MEDIA) 
		GetProcAddress(s_hLibrary, "EUGetPrivateKeyMedia");
	s_Iface.ReadPrivateKey = (PEU_READ_PRIVATE_KEY) 
		GetProcAddress(s_hLibrary, "EUReadPrivateKey");
	s_Iface.IsPrivateKeyReaded = (PEU_IS_PRIVATE_KEY_READED) 
		GetProcAddress(s_hLibrary, "EUIsPrivateKeyReaded");
	s_Iface.ResetPrivateKey = (PEU_RESET_PRIVATE_KEY) 
		GetProcAddress(s_hLibrary, "EUResetPrivateKey");
	s_Iface.FreeCertOwnerInfo = (PEU_FREE_CERT_OWNER_INFO) 
		GetProcAddress(s_hLibrary, "EUFreeCertOwnerInfo");

	s_Iface.ShowOwnCertificate = (PEU_SHOW_OWN_CERTIFICATE) 
		GetProcAddress(s_hLibrary, "EUShowOwnCertificate");
	s_Iface.ShowSignInfo = (PEU_SHOW_SIGN_INFO) 
		GetProcAddress(s_hLibrary, "EUShowSignInfo");
	s_Iface.FreeSignInfo = (PEU_FREE_SIGN_INFO) 
		GetProcAddress(s_hLibrary, "EUFreeSignInfo");

	s_Iface.FreeMemory = (PEU_FREE_MEMORY) 
		GetProcAddress(s_hLibrary, "EUFreeMemory");

	s_Iface.GetErrorDesc = (PEU_GET_ERROR_DESC) 
		GetProcAddress(s_hLibrary, "EUGetErrorDesc");

	s_Iface.SignData = (PEU_SIGN_DATA) 
		GetProcAddress(s_hLibrary, "EUSignData");
	s_Iface.VerifyData = (PEU_VERIFY_DATA) 
		GetProcAddress(s_hLibrary, "EUVerifyData");

	s_Iface.SignDataContinue = (PEU_SIGN_DATA_CONTINUE) 
		GetProcAddress(s_hLibrary, "EUSignDataContinue");
	s_Iface.SignDataEnd = (PEU_SIGN_DATA_END) 
		GetProcAddress(s_hLibrary, "EUSignDataEnd");
	s_Iface.VerifyDataBegin = (PEU_VERIFY_DATA_BEGIN) 
		GetProcAddress(s_hLibrary, "EUVerifyDataBegin");
	s_Iface.VerifyDataContinue = (PEU_VERIFY_DATA_CONTINUE) 
		GetProcAddress(s_hLibrary, "EUVerifyDataContinue");
	s_Iface.VerifyDataEnd = (PEU_VERIFY_DATA_END) 
		GetProcAddress(s_hLibrary, "EUVerifyDataEnd");
	s_Iface.ResetOperation = (PEU_RESET_OPERATION)
		GetProcAddress(s_hLibrary, "EUResetOperation");

	s_Iface.SignFile = (PEU_SIGN_FILE)
		GetProcAddress(s_hLibrary, "EUSignFile");
	s_Iface.VerifyFile = (PEU_VERIFY_FILE)
		GetProcAddress(s_hLibrary, "EUVerifyFile");

	s_Iface.SignDataInternal = (PEU_SIGN_DATA_INTERNAL) 
		GetProcAddress(s_hLibrary, "EUSignDataInternal");
	s_Iface.VerifyDataInternal = (PEU_VERIFY_DATA_INTERNAL) 
		GetProcAddress(s_hLibrary, "EUVerifyDataInternal");

	s_Iface.SelectCertInfo = (PEU_SELECT_CERT_INFO) 
		GetProcAddress(s_hLibrary, "EUSelectCertificateInfo");

	s_Iface.SetUIMode = (PEU_SET_UI_MODE)
		GetProcAddress(s_hLibrary, "EUSetUIMode");

	s_Iface.HashData = (PEU_HASH_DATA)
		GetProcAddress(s_hLibrary, "EUHashData");
	s_Iface.HashDataContinue = (PEU_HASH_DATA_CONTINUE)
		GetProcAddress(s_hLibrary, "EUHashDataContinue");
	s_Iface.HashDataEnd = (PEU_HASH_DATA_END)
		GetProcAddress(s_hLibrary, "EUHashDataEnd");
	s_Iface.HashFile = (PEU_HASH_FILE)
		GetProcAddress(s_hLibrary, "EUHashFile");
	s_Iface.SignHash = (PEU_SIGN_HASH)
		GetProcAddress(s_hLibrary, "EUSignHash");
	s_Iface.VerifyHash = (PEU_VERIFY_HASH)
		GetProcAddress(s_hLibrary, "EUVerifyHash");

	s_Iface.EnumKeyMediaTypes = (PEU_ENUM_KEY_MEDIA_TYPES)
		GetProcAddress(s_hLibrary, "EUEnumKeyMediaTypes");
	s_Iface.EnumKeyMediaDevices = (PEU_ENUM_KEY_MEDIA_DEVICES)
		GetProcAddress(s_hLibrary, "EUEnumKeyMediaDevices");

	s_Iface.GetFileStoreSettings = (PEU_GET_FILE_STORE_SETTINGS)
		GetProcAddress(s_hLibrary, "EUGetFileStoreSettings");
	s_Iface.SetFileStoreSettings = (PEU_SET_FILE_STORE_SETTINGS)
		GetProcAddress(s_hLibrary, "EUSetFileStoreSettings");
	s_Iface.GetProxySettings = (PEU_GET_PROXY_SETTINGS)
		GetProcAddress(s_hLibrary, "EUGetProxySettings");
	s_Iface.SetProxySettings = (PEU_SET_PROXY_SETTINGS)
		GetProcAddress(s_hLibrary, "EUSetProxySettings");
	s_Iface.GetOCSPSettings = (PEU_GET_OCSP_SETTINGS)
		GetProcAddress(s_hLibrary, "EUGetOCSPSettings");
	s_Iface.SetOCSPSettings = (PEU_SET_OCSP_SETTINGS)
		GetProcAddress(s_hLibrary, "EUSetOCSPSettings");
	s_Iface.GetTSPSettings = (PEU_GET_TSP_SETTINGS)
		GetProcAddress(s_hLibrary, "EUGetTSPSettings");
	s_Iface.SetTSPSettings = (PEU_SET_TSP_SETTINGS)
		GetProcAddress(s_hLibrary, "EUSetTSPSettings");
	s_Iface.GetLDAPSettings = (PEU_GET_LDAP_SETTINGS)
		GetProcAddress(s_hLibrary, "EUGetLDAPSettings");
	s_Iface.SetLDAPSettings = (PEU_SET_LDAP_SETTINGS)
		GetProcAddress(s_hLibrary, "EUSetLDAPSettings");

	s_Iface.GetCertificatesCount = (PEU_GET_CERTIFICATES_COUNT)
		GetProcAddress(s_hLibrary, "EUGetCertificatesCount");
	s_Iface.EnumCertificates = (PEU_ENUM_CERTIFICATES)
		GetProcAddress(s_hLibrary, "EUEnumCertificates");
	s_Iface.GetCRLsCount = (PEU_GET_CRLS_COUNT)
		GetProcAddress(s_hLibrary, "EUGetCRLsCount");
	s_Iface.EnumCRLs = (PEU_ENUM_CRLS)
		GetProcAddress(s_hLibrary, "EUEnumCRLs");
	s_Iface.FreeCRLInfo = (PEU_FREE_CRL_INFO)
		GetProcAddress(s_hLibrary, "EUFreeCRLInfo");

	s_Iface.GetCertificateInfo = (PEU_GET_CERTIFICATE_INFO)
		GetProcAddress(s_hLibrary, "EUGetCertificateInfo");
	s_Iface.FreeCertificateInfo = (PEU_FREE_CERTIFICATE_INFO)
		GetProcAddress(s_hLibrary, "EUFreeCertificateInfo");
	s_Iface.GetCRLDetailedInfo = (PEU_GET_CRL_DETAILED_INFO)
		GetProcAddress(s_hLibrary, "EUGetCRLDetailedInfo");
	s_Iface.FreeCRLDetailedInfo = (PEU_FREE_CRL_DETAILED_INFO)
		GetProcAddress(s_hLibrary, "EUFreeCRLDetailedInfo");

	s_Iface.GetCMPSettings = (PEU_GET_CMP_SETTINGS)
		GetProcAddress(s_hLibrary, "EUGetCMPSettings");
	s_Iface.SetCMPSettings = (PEU_SET_CMP_SETTINGS)
		GetProcAddress(s_hLibrary, "EUSetCMPSettings");
	s_Iface.DoesNeedSetSettings = (PEU_DOES_NEED_SET_SETTINGS)
		GetProcAddress(s_hLibrary, "EUDoesNeedSetSettings");

	s_Iface.GetPrivateKeyMediaSettings =
		(PEU_GET_PRIVATE_KEY_MEDIA_SETTINGS)
		GetProcAddress(s_hLibrary, "EUGetPrivateKeyMediaSettings");
	s_Iface.SetPrivateKeyMediaSettings =
		(PEU_SET_PRIVATE_KEY_MEDIA_SETTINGS)
		GetProcAddress(s_hLibrary, "EUSetPrivateKeyMediaSettings");

	s_Iface.SelectCMPServer = (PEU_SELECT_CMP_SERVER)
		GetProcAddress(s_hLibrary, "EUSelectCMPServer");

	s_Iface.RawSignData = (PEU_RAW_SIGN_DATA)
		GetProcAddress(s_hLibrary, "EURawSignData");
	s_Iface.RawVerifyData = (PEU_RAW_VERIFY_DATA)
		GetProcAddress(s_hLibrary, "EURawVerifyData");
	s_Iface.RawSignHash = (PEU_RAW_SIGN_HASH)
		GetProcAddress(s_hLibrary, "EURawSignHash");
	s_Iface.RawVerifyHash = (PEU_RAW_VERIFY_HASH)
		GetProcAddress(s_hLibrary, "EURawVerifyHash");
	s_Iface.RawSignFile = (PEU_RAW_SIGN_FILE)
		GetProcAddress(s_hLibrary, "EURawSignFile");
	s_Iface.RawVerifyFile = (PEU_RAW_VERIFY_FILE)
		GetProcAddress(s_hLibrary, "EURawVerifyFile");

	s_Iface.BASE64Encode = (PEU_BASE64_ENCODE)
		GetProcAddress(s_hLibrary, "EUBASE64Encode");
	s_Iface.BASE64Decode = (PEU_BASE64_DECODE)
		GetProcAddress(s_hLibrary, "EUBASE64Decode");

	s_Iface.EnvelopData = (PEU_ENVELOP_DATA)
		GetProcAddress(s_hLibrary, "EUEnvelopData");
	s_Iface.DevelopData = (PEU_DEVELOP_DATA)
		GetProcAddress(s_hLibrary, "EUDevelopData");
	s_Iface.ShowSenderInfo = (PEU_SHOW_SENDER_INFO)
		GetProcAddress(s_hLibrary, "EUShowSenderInfo");
	s_Iface.FreeSenderInfo = (PEU_FREE_SENDER_INFO)
		GetProcAddress(s_hLibrary, "EUFreeSenderInfo");

	s_Iface.ParseCertificate = (PEU_PARSE_CERTIFICATE)
		GetProcAddress(s_hLibrary, "EUParseCertificate");

	s_Iface.ReadPrivateKeyBinary = (PEU_READ_PRIVATE_KEY_BINARY) 
		GetProcAddress(s_hLibrary, "EUReadPrivateKeyBinary");
	s_Iface.ReadPrivateKeyFile = (PEU_READ_PRIVATE_KEY_FILE) 
		GetProcAddress(s_hLibrary, "EUReadPrivateKeyFile");

	s_Iface.SessionDestroy = (PEU_SESSION_DESTROY)
		GetProcAddress(s_hLibrary, "EUSessionDestroy");
	s_Iface.ClientSessionCreateStep1 =
		(PEU_CLIENT_SESSION_CREATE_STEP1)
		GetProcAddress(s_hLibrary, "EUClientSessionCreateStep1");
	s_Iface.ServerSessionCreateStep1 =
		(PEU_SERVER_SESSION_CREATE_STEP1)
		GetProcAddress(s_hLibrary, "EUServerSessionCreateStep1");
	s_Iface.ClientSessionCreateStep2 =
		(PEU_CLIENT_SESSION_CREATE_STEP2)
		GetProcAddress(s_hLibrary, "EUClientSessionCreateStep2");
	s_Iface.ServerSessionCreateStep2 =
		(PEU_SERVER_SESSION_CREATE_STEP2)
		GetProcAddress(s_hLibrary, "EUServerSessionCreateStep2");
	s_Iface.SessionIsInitialized = (PEU_SESSION_IS_INITIALIZED)
		GetProcAddress(s_hLibrary, "EUSessionIsInitialized");
	s_Iface.SessionSave = (PEU_SESSION_SAVE)
		GetProcAddress(s_hLibrary, "EUSessionSave");
	s_Iface.SessionLoad = (PEU_SESSION_LOAD)
		GetProcAddress(s_hLibrary, "EUSessionLoad");
	s_Iface.SessionCheckCertificates =
		(PEU_SESSION_CHECK_CERTIFICATES)
		GetProcAddress(s_hLibrary, "EUSessionCheckCertificates");
	s_Iface.SessionEncrypt = (PEU_SESSION_ENCRYPT)
		GetProcAddress(s_hLibrary, "EUSessionEncrypt");
	s_Iface.SessionEncryptContinue = (PEU_SESSION_ENCRYPT_CONTINUE)
		GetProcAddress(s_hLibrary, "EUSessionEncryptContinue");
	s_Iface.SessionDecrypt = (PEU_SESSION_DECRYPT)
		GetProcAddress(s_hLibrary, "EUSessionDecrypt");
	s_Iface.SessionDecryptContinue = (PEU_SESSION_DECRYPT_CONTINUE)
		GetProcAddress(s_hLibrary, "EUSessionDecryptContinue");

	s_Iface.IsSignedData = (PEU_IS_SIGNED_DATA)
		GetProcAddress(s_hLibrary, "EUIsSignedData");
	s_Iface.IsEnvelopedData = (PEU_IS_ENVELOPED_DATA)
		GetProcAddress(s_hLibrary, "EUIsEnvelopedData");

	s_Iface.SessionGetPeerCertificateInfo =
		(PEU_SESSION_GET_PEER_CERTIFICATE_INFO)
		GetProcAddress(s_hLibrary, "EUSessionGetPeerCertificateInfo");

	s_Iface.SaveCertificate = (PEU_SAVE_CERTIFICATE)
		GetProcAddress(s_hLibrary, "EUSaveCertificate");
	s_Iface.RefreshFileStore = (PEU_REFRESH_FILE_STORE)
		GetProcAddress(s_hLibrary, "EURefreshFileStore");

	s_Iface.GetModeSettings = (PEU_GET_MODE_SETTINGS)
		GetProcAddress(s_hLibrary, "EUGetModeSettings");
	s_Iface.SetModeSettings = (PEU_SET_MODE_SETTINGS)
		GetProcAddress(s_hLibrary, "EUSetModeSettings");

	s_Iface.CheckCertificate = (PEU_CHECK_CERTIFICATE)
		GetProcAddress(s_hLibrary, "EUCheckCertificate");

	s_Iface.EnvelopFile = (PEU_ENVELOP_FILE)
		GetProcAddress(s_hLibrary, "EUEnvelopFile");
	s_Iface.DevelopFile = (PEU_DEVELOP_FILE)
		GetProcAddress(s_hLibrary, "EUDevelopFile");
	s_Iface.IsSignedFile = (PEU_IS_SIGNED_FILE)
		GetProcAddress(s_hLibrary, "EUIsSignedFile");
	s_Iface.IsEnvelopedFile = (PEU_IS_ENVELOPED_FILE)
		GetProcAddress(s_hLibrary, "EUIsEnvelopedFile");

	s_Iface.GetCertificate = (PEU_GET_CERTIFICATE)
		GetProcAddress(s_hLibrary, "EUGetCertificate");
	s_Iface.GetOwnCertificate = (PEU_GET_OWN_CERTIFICATE)
		GetProcAddress(s_hLibrary, "EUGetOwnCertificate");

	s_Iface.EnumOwnCertificates = (PEU_ENUM_OWN_CERTIFICATES)
		GetProcAddress(s_hLibrary, "EUEnumOwnCertificates");
	s_Iface.GetCertificateInfoEx = (PEU_GET_CERTIFICATE_INFO_EX)
		GetProcAddress(s_hLibrary, "EUGetCertificateInfoEx");
	s_Iface.FreeCertificateInfoEx = (PEU_FREE_CERTIFICATE_INFO_EX)
		GetProcAddress(s_hLibrary, "EUFreeCertificateInfoEx");

	s_Iface.GetReceiversCertificates = (PEU_GET_RECEIVERS_CERTIFICATES)
		GetProcAddress(s_hLibrary, "EUGetReceiversCertificates");
	s_Iface.FreeReceiversCertificates = (PEU_FREE_RECEIVERS_CERTIFICATES)
		GetProcAddress(s_hLibrary, "EUFreeReceiversCertificates");

	for (DWORD dw = 0; dw < sizeof(EU_INTERFACE) / 
		sizeof(PVOID); dw++)
	{
		if (((PVOID *) &s_Iface)[dw] == NULL)
		{
			FreeLibrary(s_hLibrary);
			s_hLibrary = NULL;

			return FALSE;
		}
	}

	return TRUE;
}

//-----------------------------------------------------------------------------

PEU_INTERFACE EUGetInterface()
{
	if (s_hLibrary == NULL)
		return NULL;

	return &s_Iface;
}

//-----------------------------------------------------------------------------

VOID EUUnload()
{
	if (s_hLibrary != NULL)
	{
		FreeLibrary(s_hLibrary);
		s_hLibrary = NULL;
	}
}

//=============================================================================
