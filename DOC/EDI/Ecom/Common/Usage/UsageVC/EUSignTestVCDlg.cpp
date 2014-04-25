//==============================================================================

#include "StdAfx.h"
#include "EUSignTestVC.h"
#include "EUSignTestVCDlg.h"

//==============================================================================

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

//==============================================================================

CEUSignTestVCDlg::CEUSignTestVCDlg(CWnd* pParent)
	: CDialog(CEUSignTestVCDlg::IDD, pParent), m_bInitialized(FALSE)
	, m_ComboSex(0)
	, m_FirstNameEdit(_T(""))
	, m_LastNameEdit(_T(""))
	, m_MiddleNameEdit(_T(""))
	, m_PassSeriesEdit(_T(""))
	, m_PassNumberEdit(_T(""))
	, m_DRFOEdit(_T(""))
	, m_RoleEdit(_T(""))
	, m_TargetFileEdit(_T(""))
	, m_SignEdit(_T(""))
{
	m_bstrFirstName = NULL;
	m_bstrLastName = NULL;
	m_bstrMiddleName = NULL;
	m_bstrPassSeries = NULL;
	m_bstrPassNumber = NULL;
	m_bstrDRFO = NULL;
	m_bstrRole = NULL;
	m_bstrAll = NULL;

	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

//==============================================================================

CEUSignTestVCDlg::~CEUSignTestVCDlg()
{
	SysFreeString(m_bstrFirstName);
	SysFreeString(m_bstrLastName);
	SysFreeString(m_bstrMiddleName);
	SysFreeString(m_bstrPassSeries);
	SysFreeString(m_bstrPassNumber);
	SysFreeString(m_bstrDRFO);
	SysFreeString(m_bstrRole);
	SysFreeString(m_bstrAll);
}

//==============================================================================

void CEUSignTestVCDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_BUTTON_INITIALIZE, m_InitializeButton);
	DDX_Control(pDX, IDC_BUTTON_PARAMETERS, m_ParametersButton);
	DDX_Control(pDX, IDC_BUTTON_CERTIFICATES, m_CertificatesButton);
	DDX_Control(pDX, IDC_BUTTON_CRLS, m_CRLsButton);
	DDX_Control(pDX, IDC_BUTTON_PRIVATE_KEY, m_PrivateKeyButton);
	DDX_Control(pDX, IDC_BUTTON_CERTIFICATE, m_CertificateButton);
	DDX_Control(pDX, IDC_BUTTON_SIGN, m_SignButton);
	DDX_Control(pDX, IDC_BUTTON_FULL_TEST, m_FullTestButton);
	DDX_Control(pDX, IDC_BUTTON_VERIFY, m_VerifyButton);
	DDX_Control(pDX, IDC_BUTTON_SIGN_FILE, m_SignFileButton);
	DDX_Control(pDX, IDC_BUTTON_VERIFY_FILE, m_VerifyFileButton);
	DDX_Control(pDX, IDC_BUTTON_ENCRYPT, m_EncryptButton);
	DDX_Control(pDX, IDC_BUTTON_DECRYPT, m_DecrtypButton);
	DDX_Control(pDX, IDC_BUTTON_ENCRYPT_FILE, m_EncryptFileButton);
	DDX_Control(pDX, IDC_BUTTON_DECRYPT_FILE, m_DecryptFileButton);
	DDX_Control(pDX, IDC_BUTTON_CHECK_CERTIFICATE, m_CheckCertificateButton);
	DDX_CBIndex(pDX, IDC_COMBO_SEX, m_ComboSex);
	DDX_Text(pDX, IDC_EDIT_FIRST_NAME, m_FirstNameEdit);
	DDX_Text(pDX, IDC_EDIT_LAST_NAME, m_LastNameEdit);
	DDX_Text(pDX, IDC_EDITMIDDLE_NAME, m_MiddleNameEdit);
	DDX_Text(pDX, IDC_EDIT_PASS_SERIES, m_PassSeriesEdit);
	DDX_Text(pDX, IDC_EDIT_PASS_NUMBER, m_PassNumberEdit);
	DDX_Text(pDX, IDC_EDIT_DRFO, m_DRFOEdit);
	DDX_Text(pDX, IDC_EDIT_ROLE, m_RoleEdit);
	DDX_Text(pDX, IDC_EDIT_TARGET_FILE, m_TargetFileEdit);
	DDX_Text(pDX, IDC_RICHEDIT_SIGN, m_SignEdit);
	DDX_Control(pDX, IDC_CHECK_USE_INTERNAL_SIGN, m_UseInternalSignCheckBox);
	DDX_Control(pDX, IDC_CHECK_SIGN_HASH, m_SignHashCheckBox);
	DDX_Control(pDX, IDC_CHECK_USE_RAW_SIGN, m_UseRawSignCheckBox);
	DDX_Control(pDX, IDC_CHECK_ADD_SIGN, m_AddSignCheckBox);
}

//==============================================================================

BEGIN_MESSAGE_MAP(CEUSignTestVCDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BUTTON_INITIALIZE, OnBnClickedButtonInitialize)
	ON_BN_CLICKED(IDC_BUTTON_PARAMETERS, OnBnClickedButtonParameters)
	ON_BN_CLICKED(IDC_BUTTON_CERTIFICATES, OnBnClickedButtonCertificates)
	ON_BN_CLICKED(IDC_BUTTON_CRLS, OnBnClickedButtonCrls)
	ON_BN_CLICKED(IDC_BUTTON_PRIVATE_KEY, OnBnClickedButtonPrivateKey)
	ON_BN_CLICKED(IDC_BUTTON_CERTIFICATE, OnBnClickedButtonCertificate)
	ON_BN_CLICKED(IDC_BUTTON_SIGN, OnBnClickedButtonSign)
	ON_BN_CLICKED(IDC_BUTTON_VERIFY, OnBnClickedButtonVerify)
	ON_BN_CLICKED(IDC_BUTTON_SELECT_TARGET_FILE, OnBnClickedButtonSelectTargetFile)
	ON_BN_CLICKED(IDC_BUTTON_SIGN_FILE, OnBnClickedButtonSignFile)
	ON_BN_CLICKED(IDC_BUTTON_VERIFY_FILE, OnBnClickedButtonVerifyFile)
	ON_BN_CLICKED(IDC_BUTTON_ENCRYPT, OnBnClickedButtonEncrypt)
	ON_BN_CLICKED(IDC_BUTTON_DECRYPT, OnBnClickedButtonDecrypt)
	ON_BN_CLICKED(IDC_BUTTON_ENCRYPT_FILE, OnBnClickedButtonEncryptFile)
	ON_BN_CLICKED(IDC_BUTTON_DECRYPT_FILE, OnBnClickedButtonDecryptFile)
	ON_BN_CLICKED(IDC_BUTTON_CHECK_CERTIFICATE, OnBnClickedButtonCheckCertificate)
	ON_BN_CLICKED(IDC_BUTTON_CLEAR, OnBnClickedButtonClear)
	ON_BN_CLICKED(IDC_BUTTON_FULL_TEST, OnBnClickedButtonFullTest)
	ON_BN_CLICKED(IDC_CHECK_USE_INTERNAL_SIGN, OnBnClickedCheckUseInternalSign)
	ON_BN_CLICKED(IDC_CHECK_USE_RAW_SIGN, OnBnClickedCheckUseRawSign)
END_MESSAGE_MAP()

//==============================================================================

BOOL CEUSignTestVCDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	SetIcon(m_hIcon, TRUE);
	SetIcon(m_hIcon, FALSE);

	return TRUE;
}

//==============================================================================

void CEUSignTestVCDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this);

		SendMessage(WM_ICONERASEBKGND,
			reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//==============================================================================

HCURSOR CEUSignTestVCDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonInitialize()
{
	DWORD dwError;
	BOOL bEnableWindow;

	if(!m_bInitialized)
	{
		if(!EULoad())
		{
			::MessageBoxA(this->m_hWnd,
				"Виникла помилка при завантаженні "
				"криптографічної бібліотеки",
				"Повідомлення оператору",
				MB_ICONERROR);

			return;
		}

		m_pInterface = EUGetInterface();
		if(m_pInterface == NULL)
		{
			::MessageBoxA(this->m_hWnd,
				"Виникла помилка при отриманні "
				"інтерфейса криптографічної бібліотеки",
				"Повідомлення оператору",
				MB_ICONERROR);

			return;
		}

		dwError = m_pInterface->Initialize();
		if(dwError != EU_ERROR_NONE)
			return;

		m_pInterface->SetUIMode(TRUE);

		m_bInitialized = TRUE;

		m_InitializeButton.SetWindowText("Завершити роботу...");

		m_ComboSex = 0;

		bEnableWindow = TRUE;
		
	}
	else
	{
		m_pInterface->Finalize();
		EUUnload();

		m_bInitialized = FALSE;

		m_InitializeButton.SetWindowText("Ініціалізувати...");
		m_PrivateKeyButton.SetWindowText("Зчитати ключ...");

		m_CertificateButton.EnableWindow(FALSE);
		m_SignButton.EnableWindow(FALSE);
		m_SignFileButton.EnableWindow(FALSE);
		m_FullTestButton.EnableWindow(FALSE);
	
		m_EncryptButton.EnableWindow(FALSE);
		m_DecrtypButton.EnableWindow(FALSE);
		m_EncryptFileButton.EnableWindow(FALSE);
		m_DecryptFileButton.EnableWindow(FALSE);
		
		m_ComboSex = -1;
		bEnableWindow = FALSE;
	}

	m_ParametersButton.EnableWindow(bEnableWindow);
	m_CertificatesButton.EnableWindow(bEnableWindow);
	m_CRLsButton.EnableWindow(bEnableWindow);
	m_PrivateKeyButton.EnableWindow(bEnableWindow);

	m_VerifyButton.EnableWindow(bEnableWindow);
	m_VerifyFileButton.EnableWindow(bEnableWindow);

	m_CheckCertificateButton.EnableWindow(bEnableWindow);

	m_UseInternalSignCheckBox.EnableWindow(bEnableWindow);
	m_SignHashCheckBox.EnableWindow(bEnableWindow);
	m_UseRawSignCheckBox.EnableWindow(bEnableWindow);

	m_AddSignCheckBox.EnableWindow(bEnableWindow);
	
	if(bEnableWindow)
		OnBnClickedCheckUseRawSign();
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonParameters()
{
	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	m_pInterface->SetSettings();
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonCertificates()
{
	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	m_pInterface->ShowCertificates();
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonCrls()
{
	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	m_pInterface->ShowCRLs();
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonPrivateKey()
{
	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	BOOL bEnableWindow;

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		EU_KEY_MEDIA KeyMedia;
		EU_CERT_OWNER_INFO CertOwnerInfo;
		DWORD dwError;

		dwError = m_pInterface->GetPrivateKeyMedia(&KeyMedia);
		if(dwError != EU_ERROR_NONE)
			return;

		dwError = m_pInterface->ReadPrivateKey(&KeyMedia,
			&CertOwnerInfo);
		if(dwError != EU_ERROR_NONE)
			return;

		m_pInterface->FreeCertOwnerInfo(&CertOwnerInfo);

		m_PrivateKeyButton.SetWindowText("Зтерти ключ...");

		bEnableWindow = TRUE;

	}
	else
	{
		m_pInterface->ResetOperation();
		m_pInterface->ResetPrivateKey();

		m_PrivateKeyButton.SetWindowText("Зчитати ключ...");
		
		bEnableWindow = FALSE;
	}

	m_CertificateButton.EnableWindow(bEnableWindow);
	m_SignButton.EnableWindow(bEnableWindow);
	m_SignFileButton.EnableWindow(bEnableWindow);
	m_FullTestButton.EnableWindow(bEnableWindow);

	m_EncryptButton.EnableWindow(bEnableWindow);
	m_DecrtypButton.EnableWindow(bEnableWindow);
	m_EncryptFileButton.EnableWindow(bEnableWindow);
	m_DecryptFileButton.EnableWindow(bEnableWindow);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonCertificate()
{
	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		::MessageBoxA(this->m_hWnd,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	m_pInterface->ShowOwnCertificate();
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonSign()
{
	UpdateData(TRUE);

	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		::MessageBoxA(this->m_hWnd,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	PWCHAR pszSex[] = {L"Male", L"Female"};
	DWORD dwError;
	PSTR pszHash;
	PSTR pszSign;
	CString All;

	if(m_UseRawSignCheckBox.GetCheck() == BST_CHECKED)
	{
		All = CString(pszSex[m_ComboSex]) +
			m_FirstNameEdit + m_LastNameEdit +
			m_MiddleNameEdit + m_PassSeriesEdit +
			m_PassNumberEdit + m_DRFOEdit +
			m_RoleEdit;

		dwError = m_pInterface->RawSignData(
			(PBYTE) All.SetSysString(&m_bstrAll),
			All.GetLength() * 2, &pszSign, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
			return;
	}
	else if(m_UseInternalSignCheckBox.GetCheck() == BST_CHECKED)
	{
		All = CString(pszSex[m_ComboSex]) +
			m_FirstNameEdit + m_LastNameEdit +
			m_MiddleNameEdit + m_PassSeriesEdit +
			m_PassNumberEdit + m_DRFOEdit +
			m_RoleEdit;

		dwError = m_pInterface->SignDataInternal(FALSE,
			(PBYTE) All.SetSysString(&m_bstrAll),
			All.GetLength() * 2, &pszSign, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
			return;
	}
	else if(m_SignHashCheckBox.IsWindowEnabled() &&
		m_SignHashCheckBox.GetCheck() == BST_CHECKED)
	{
		if(((dwError = m_pInterface->HashDataContinue(
				(PBYTE) pszSex[m_ComboSex],
				(DWORD) wcslen(pszSex[m_ComboSex]) * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_FirstNameEdit.SetSysString(&m_bstrFirstName),
				m_FirstNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_LastNameEdit.SetSysString(&m_bstrLastName),
				m_LastNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_MiddleNameEdit.SetSysString(&m_bstrMiddleName),
				m_MiddleNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_PassSeriesEdit.SetSysString(&m_bstrPassSeries),
				m_PassSeriesEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_PassNumberEdit.SetSysString(&m_bstrPassNumber),
				m_PassNumberEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_DRFOEdit.SetSysString(&m_bstrDRFO),
				m_DRFOEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_RoleEdit.SetSysString(&m_bstrRole),
				m_RoleEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataEnd(
				&pszHash, NULL, NULL))
			!= EU_ERROR_NONE))
		{
			m_pInterface->ResetOperation();

			return;
		}

		dwError = m_pInterface->SignHash(pszHash, NULL, 0,
			&pszSign, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->FreeMemory((PBYTE) pszHash);

			return;
		}

		m_pInterface->FreeMemory((PBYTE) pszHash);
	}
	else
	{
		if(((dwError = m_pInterface->SignDataContinue(
				(PBYTE) pszSex[m_ComboSex],
				(DWORD) wcslen(pszSex[m_ComboSex]) * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) m_FirstNameEdit.SetSysString(&m_bstrFirstName),
				m_FirstNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) m_LastNameEdit.SetSysString(&m_bstrLastName),
				m_LastNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) m_MiddleNameEdit.SetSysString(&m_bstrMiddleName),
				m_MiddleNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) m_PassSeriesEdit.SetSysString(&m_bstrPassSeries),
				m_PassSeriesEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) m_PassNumberEdit.SetSysString(&m_bstrPassNumber),
				m_PassNumberEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) m_DRFOEdit.SetSysString(&m_bstrDRFO),
				m_DRFOEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) m_RoleEdit.SetSysString(&m_bstrRole),
				m_RoleEdit.GetLength() * 2))
			!= EU_ERROR_NONE))
		{
			m_pInterface->ResetOperation();

			return;
		}

		dwError = m_pInterface->SignDataEnd(&pszSign, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->ResetOperation();

			return;
		}
	}

	m_SignEdit = pszSign;

	m_pInterface->FreeMemory((PBYTE) pszSign);

	UpdateData(FALSE);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonVerify()
{
	UpdateData(TRUE);

	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	PWCHAR pszSex[] = {L"Male", L"Female"};
	DWORD dwError;
	PBYTE pbData;
	DWORD dwDataLength;
	PSTR pszHash;
	EU_SIGN_INFO SignInfo;
	CString All;

	if(m_UseRawSignCheckBox.GetCheck() == BST_CHECKED)
	{
		All = CString(pszSex[m_ComboSex]) +
			m_FirstNameEdit + m_LastNameEdit +
			m_MiddleNameEdit + m_PassSeriesEdit +
			m_PassNumberEdit + m_DRFOEdit +
			m_RoleEdit;

		dwError = m_pInterface->RawVerifyData(
			(PBYTE) All.SetSysString(&m_bstrAll),
			All.GetLength() * 2, (PSTR) m_SignEdit.GetString(),
			NULL, NULL, &SignInfo);
		if(dwError != EU_ERROR_NONE)
			return;
	}
	else if(m_UseInternalSignCheckBox.GetCheck() == BST_CHECKED)
	{
		dwError = m_pInterface->VerifyDataInternal(
			(PSTR) m_SignEdit.GetString(), NULL, 0,
			&pbData, &dwDataLength, &SignInfo);
		if(dwError != EU_ERROR_NONE)
			return;

		m_pInterface->FreeMemory(pbData);
	}
	else if(m_SignHashCheckBox.IsWindowEnabled() &&
		m_SignHashCheckBox.GetCheck() == BST_CHECKED)
	{
		if(((dwError = m_pInterface->HashDataContinue(
				(PBYTE) pszSex[m_ComboSex],
				(DWORD) wcslen(pszSex[m_ComboSex]) * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_FirstNameEdit.SetSysString(&m_bstrFirstName),
				m_FirstNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_LastNameEdit.SetSysString(&m_bstrLastName),
				m_LastNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_MiddleNameEdit.SetSysString(&m_bstrMiddleName),
				m_MiddleNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_PassSeriesEdit.SetSysString(&m_bstrPassSeries),
				m_PassSeriesEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_PassNumberEdit.SetSysString(&m_bstrPassNumber),
				m_PassNumberEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_DRFOEdit.SetSysString(&m_bstrDRFO),
				m_DRFOEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) m_RoleEdit.SetSysString(&m_bstrRole),
				m_RoleEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataEnd(
				&pszHash, NULL, NULL))
			!= EU_ERROR_NONE))
		{
			m_pInterface->ResetOperation();

			return;
		}

		dwError = m_pInterface->VerifyHash(pszHash, NULL, 0,
			(PSTR) m_SignEdit.GetString(), NULL, NULL, &SignInfo);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->FreeMemory((PBYTE) pszHash);

			return;
		}

		m_pInterface->FreeMemory((PBYTE) pszHash);
	}
	else
	{
		dwError = m_pInterface->VerifyDataBegin(
			(PSTR) m_SignEdit.GetString(), NULL, NULL);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->ResetOperation();

			return;
		}

		if(((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) pszSex[m_ComboSex],
				(DWORD) wcslen(pszSex[m_ComboSex]) * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) m_FirstNameEdit.SetSysString(&m_bstrFirstName),
				m_FirstNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) m_LastNameEdit.SetSysString(&m_bstrLastName),
				m_LastNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) m_MiddleNameEdit.SetSysString(&m_bstrMiddleName),
				m_MiddleNameEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) m_PassSeriesEdit.SetSysString(&m_bstrPassSeries),
				m_PassSeriesEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) m_PassNumberEdit.SetSysString(&m_bstrPassNumber),
				m_PassNumberEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) m_DRFOEdit.SetSysString(&m_bstrDRFO),
				m_DRFOEdit.GetLength() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) m_RoleEdit.SetSysString(&m_bstrRole),
				m_RoleEdit.GetLength() * 2))
			!= EU_ERROR_NONE))
		{
			m_pInterface->ResetOperation();

			return;
		}

		dwError = m_pInterface->VerifyDataEnd(&SignInfo);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->ResetOperation();

			return;
		}
	}

	m_pInterface->ShowSignInfo(&SignInfo);

	m_pInterface->FreeSignInfo(&SignInfo);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonSelectTargetFile()
{
	CFileDialog TargetFileOpenDialog(TRUE);

	if(TargetFileOpenDialog.DoModal() != IDOK)
		return;

	m_TargetFileEdit = TargetFileOpenDialog.GetPathName();

	UpdateData(FALSE);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonSignFile()
{
	UpdateData(TRUE);

	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		::MessageBoxA(this->m_hWnd,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_TargetFileEdit.GetLength())
	{
		::MessageBoxA(this->m_hWnd,
			"Не вказано файл для підпису",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	PSTR pszHash;
	PSTR pszSign;
	DWORD dwError;

	if(m_SignHashCheckBox.IsWindowEnabled() &&
		m_SignHashCheckBox.GetCheck() == BST_CHECKED)
	{
		dwError = m_pInterface->HashFile(
			(PSTR) m_TargetFileEdit.GetString(),
			&pszHash, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
			return;

		dwError = m_pInterface->SignHash(pszHash, NULL, 0,
			&pszSign, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->FreeMemory((PBYTE) pszHash);

			return;
		}

		m_pInterface->FreeMemory((PBYTE) pszHash);

		m_SignEdit = pszSign;

		m_pInterface->FreeMemory((PBYTE) pszSign);

		UpdateData(FALSE);
	}
	else if(m_UseInternalSignCheckBox.IsWindowEnabled())
	{
		dwError = m_pInterface->SignFile(
			(PSTR) m_TargetFileEdit.GetString(),
			(PSTR) (m_TargetFileEdit + ".p7s").GetString(),
			m_UseInternalSignCheckBox.GetCheck() == BST_UNCHECKED);
		if(dwError != EU_ERROR_NONE)
			return;
	}
	else
	{
		dwError = m_pInterface->RawSignFile(
			(PSTR) m_TargetFileEdit.GetString(),
			(PSTR) (m_TargetFileEdit + ".raw.sig").GetString());
		if(dwError != EU_ERROR_NONE)
			return;
	}

	::MessageBoxA(this->m_hWnd,
		"Файл підписано",
		"Повідомлення оператору",
		MB_ICONINFORMATION);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonVerifyFile()
{
	UpdateData(TRUE);

	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_TargetFileEdit.GetLength())
	{
		::MessageBoxA(this->m_hWnd,
			"Не вказано файл з підписаними даними (*.p7s)",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	DWORD dwError;
	PSTR pszHash;
	CString DataFile;
	EU_SIGN_INFO SignInfo;

	if(m_UseInternalSignCheckBox.GetCheck() == BST_CHECKED)
		DataFile = m_TargetFileEdit + ".new";
	else if(m_UseInternalSignCheckBox.IsWindowEnabled())
		DataFile = m_TargetFileEdit.Left(
			m_TargetFileEdit.GetLength() - 4);
	else
		DataFile = m_TargetFileEdit.Left(
			m_TargetFileEdit.GetLength() - 8);

	if(m_SignHashCheckBox.IsWindowEnabled() &&
		m_SignHashCheckBox.GetCheck() == BST_CHECKED)
	{
		dwError = m_pInterface->HashFile(
			(PSTR) m_TargetFileEdit.GetString(),
			&pszHash, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
			return;

		dwError = m_pInterface->VerifyHash(pszHash, NULL, 0,
			(PSTR) m_SignEdit.GetString(), NULL, 0,
			&SignInfo);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->FreeMemory((PBYTE) pszHash);

			return;
		}

		m_pInterface->FreeMemory((PBYTE) pszHash);
	}
	else if(m_UseInternalSignCheckBox.IsWindowEnabled())
	{
		dwError = m_pInterface->VerifyFile(
			(PSTR) m_TargetFileEdit.GetString(),
			(PSTR) DataFile.GetString(), &SignInfo);
		if(dwError != EU_ERROR_NONE)
			return;
	}
	else
	{
		dwError = m_pInterface->RawVerifyFile(
			(PSTR) m_TargetFileEdit.GetString(),
			(PSTR) DataFile.GetString(), &SignInfo);
		if(dwError != EU_ERROR_NONE)
			return;
	}

	m_pInterface->ShowSignInfo(&SignInfo);

	m_pInterface->FreeSignInfo(&SignInfo);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonClear()
{
	if(m_bInitialized && m_pInterface->IsPrivateKeyReaded())
		m_pInterface->ResetOperation();

	m_FirstNameEdit = "";
	m_LastNameEdit = "";
	m_MiddleNameEdit = "";
	m_PassSeriesEdit = "";
	m_PassNumberEdit = "";
	m_DRFOEdit = "";
	m_RoleEdit = "";
	m_TargetFileEdit = "";
	m_SignEdit = "";

	UpdateData(FALSE);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonFullTest()
{
	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		::MessageBoxA(this->m_hWnd,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	DWORD dwTestSize = 0x00800000;
	PBYTE pbData;
	DWORD dwDataSize;
	PBYTE pbVerifiedData;
	DWORD dwVerifiedDataSize;
	PBYTE pbSign;
	DWORD dwSignSize;
	PSTR  pszSign;
	PBYTE pbSignedData;
	DWORD dwSignedDataSize;
	PSTR  pszSignedData;
	PBYTE pbHash;
	DWORD dwHashSize;
	PSTR  pszHash;
	DWORD dwError;
	EU_SIGN_INFO SignInfo;

	dwDataSize = dwTestSize;
	pbData = new BYTE [dwDataSize];
	if(pbData == NULL)
	{
		::MessageBoxA(this->m_hWnd,
			"Недостатньо ресурсів для завершення операції",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	dwError = m_pInterface->SignData(pbData, dwDataSize,
		NULL, &pbSign, &dwSignSize);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->VerifyData(pbData, dwDataSize,
		NULL, pbSign, dwSignSize, &SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory(pbSign);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory(pbSign);

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	dwError = m_pInterface->SignData(pbData, dwDataSize,
		&pszSign, NULL, NULL);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->VerifyData(pbData, dwDataSize,
		pszSign, NULL, 0, &SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory((PBYTE) pszSign);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory((PBYTE) pszSign);

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	dwError = m_pInterface->SignDataContinue(pbData, dwDataSize);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->SignDataEnd(NULL, &pbSign, &dwSignSize);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->VerifyDataBegin(NULL, pbSign, dwSignSize);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory(pbSign);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory(pbSign);

	dwError = m_pInterface->VerifyDataContinue(pbData, dwDataSize);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->VerifyDataEnd(&SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	dwError = m_pInterface->SignDataContinue(pbData, dwDataSize);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->SignDataEnd(&pszSign, NULL, NULL);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->VerifyDataBegin(pszSign, NULL, 0);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory((PBYTE) pszSign);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory((PBYTE) pszSign);

	dwError = m_pInterface->VerifyDataContinue(pbData, dwDataSize);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->VerifyDataEnd(&SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	dwError = m_pInterface->SignDataInternal(TRUE, pbData, dwDataSize,
		NULL, &pbSignedData, &dwSignedDataSize);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->VerifyDataInternal(NULL, pbSignedData,
		dwSignedDataSize, &pbVerifiedData, &dwVerifiedDataSize,
		&SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory(pbSignedData);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory(pbSignedData);

	if(dwVerifiedDataSize != dwDataSize ||
		memcmp(pbData, pbVerifiedData, dwDataSize))
	{
		m_pInterface->FreeMemory(pbVerifiedData);
		delete [] pbData;

		::MessageBoxA(this->m_hWnd,
			"Виникла помилка при перевірці підпису",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	m_pInterface->FreeMemory(pbVerifiedData);

	dwError = m_pInterface->SignDataInternal(TRUE, pbData, dwDataSize,
		&pszSignedData, NULL, NULL);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->VerifyDataInternal(pszSignedData, NULL,
		0, &pbVerifiedData, &dwVerifiedDataSize,
		&SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory((PBYTE) pszSignedData);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory((PBYTE) pszSignedData);

	if(dwVerifiedDataSize != dwDataSize ||
		memcmp(pbData, pbVerifiedData, dwDataSize))
	{
		m_pInterface->FreeMemory(pbVerifiedData);
		delete [] pbData;

		::MessageBoxA(this->m_hWnd,
			"Виникла помилка при перевірці підпису",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	m_pInterface->FreeMemory(pbVerifiedData);

	dwError = m_pInterface->RawSignData(pbData, dwDataSize,
		NULL, &pbSign, &dwSignSize);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->RawVerifyData(pbData, dwDataSize,
		NULL, pbSign, dwSignSize, &SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory(pbSign);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory(pbSign);

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	dwError = m_pInterface->RawSignData(pbData, dwDataSize,
		&pszSign, NULL, NULL);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->RawVerifyData(pbData, dwDataSize,
		pszSign, NULL, 0, &SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory((PBYTE) pszSign);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory((PBYTE) pszSign);

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	dwError = m_pInterface->HashData(pbData, dwDataSize,
		NULL, &pbHash, &dwHashSize);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->RawSignHash(
		NULL, pbHash, dwHashSize,
		NULL, &pbSign, &dwSignSize);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory(pbHash);
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->RawVerifyHash(
		NULL, pbHash, dwHashSize,
		NULL, pbSign, dwSignSize, &SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory(pbSign);
		m_pInterface->FreeMemory(pbHash);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory(pbSign);
	m_pInterface->FreeMemory(pbHash);

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	dwError = m_pInterface->HashData(pbData, dwDataSize,
		&pszHash, NULL, NULL);
	if(dwError != EU_ERROR_NONE)
	{
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->RawSignHash(
		pszHash, NULL, 0,
		&pszSign, NULL, NULL);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory((PBYTE) pszHash);
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->RawVerifyHash(
		pszHash, NULL, 0,
		pszSign, NULL, 0, &SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory((PBYTE) pszSign);
		m_pInterface->FreeMemory((PBYTE) pszHash);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory((PBYTE) pszSign);
	m_pInterface->FreeMemory((PBYTE) pszHash);

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	delete [] pbData;

	::MessageBoxA(this->m_hWnd,
		"Тестування завершилося успішно",
		"Повідомлення оператору",
		MB_ICONINFORMATION);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedCheckUseInternalSign()
{
	m_SignHashCheckBox.EnableWindow(
		(m_UseRawSignCheckBox.GetCheck() ==
			BST_UNCHECKED) &&
		(m_UseInternalSignCheckBox.GetCheck() ==
			BST_UNCHECKED));
	m_UseRawSignCheckBox.EnableWindow(
		m_UseInternalSignCheckBox.GetCheck() ==
			BST_UNCHECKED);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedCheckUseRawSign()
{
	m_UseInternalSignCheckBox.EnableWindow(
		m_UseRawSignCheckBox.GetCheck() ==
			BST_UNCHECKED);
	OnBnClickedCheckUseInternalSign();
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonEncrypt()
{
	UpdateData(TRUE);

	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		::MessageBoxA(this->m_hWnd,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	PWCHAR pszSex[] = {L"Male", L"Female"};
	DWORD dwError;
	PSTR psEnvelopedData = NULL;
	CString All;

	All = CString(pszSex[m_ComboSex]) +
			m_FirstNameEdit + m_LastNameEdit +
			m_MiddleNameEdit + m_PassSeriesEdit +
			m_PassNumberEdit + m_DRFOEdit +
			m_RoleEdit;

	BOOL bUseSign = m_UseRawSignCheckBox.GetCheck() == BST_CHECKED;
	
	PEU_CERTIFICATES pReceiversCerts;
	dwError = m_pInterface->GetReceiversCertificates(&pReceiversCerts);

	if(dwError != EU_ERROR_NONE)
		return;
	
	dwError = m_pInterface->EnvelopData(pReceiversCerts->ppCertificates[0]->pszIssuer,
		pReceiversCerts->ppCertificates[0]->pszSerial, bUseSign,
		(PBYTE) All.SetSysString(&m_bstrAll), All.GetLength() * 2,
		&psEnvelopedData, NULL, NULL);
	
	m_pInterface->FreeReceiversCertificates(pReceiversCerts);

	if(dwError != EU_ERROR_NONE)
		return;
	
	m_SignEdit = psEnvelopedData;

	m_pInterface->FreeMemory((PBYTE) psEnvelopedData);

	UpdateData(FALSE);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonDecrypt()
{
	UpdateData(TRUE);

	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		::MessageBoxA(this->m_hWnd,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}
	
	PBYTE pbDevelopedData;
	DWORD dwDevelopedData;
	EU_ENVELOP_INFO Info;

	DWORD dwError = m_pInterface->DevelopData((PSTR)m_SignEdit.GetString(),
		NULL, 0, &pbDevelopedData, &dwDevelopedData, &Info);
		
	if(dwError != EU_ERROR_NONE)
		return;
	
	m_pInterface->ShowSenderInfo(&Info);

	m_pInterface->FreeMemory((PBYTE) pbDevelopedData);
	m_pInterface->FreeSenderInfo(&Info);

	UpdateData(FALSE);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonEncryptFile()
{
	UpdateData(TRUE);

	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		::MessageBoxA(this->m_hWnd,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_TargetFileEdit.GetLength())
	{
		::MessageBoxA(this->m_hWnd,
			"Не вказано файл для зашифрування",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	BOOL bUseSign = m_UseRawSignCheckBox.GetCheck() == BST_CHECKED;
	
	PEU_CERTIFICATES pReceiversCerts;
	DWORD dwError = m_pInterface->GetReceiversCertificates(&pReceiversCerts);

	if(dwError != EU_ERROR_NONE)
		return;
	
	dwError = m_pInterface->EnvelopFile(pReceiversCerts->ppCertificates[0]->pszIssuer,
		pReceiversCerts->ppCertificates[0]->pszSerial, bUseSign,
		(PSTR) (m_TargetFileEdit).GetString(),
		(PSTR) (m_TargetFileEdit + ".p7e").GetString());
	
	m_pInterface->FreeReceiversCertificates(pReceiversCerts);

	if(dwError != EU_ERROR_NONE)
		return;
	
	::MessageBoxA(this->m_hWnd,
		"Файл зашифровано",
		"Повідомлення оператору",
		MB_ICONINFORMATION);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonDecryptFile()
{
	UpdateData(TRUE);

	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		::MessageBoxA(this->m_hWnd,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_TargetFileEdit.GetLength())
	{
		::MessageBoxA(this->m_hWnd,
			"Не вказано файл для розшифрування",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	EU_ENVELOP_INFO Info;
	CString DecryptedFileName = CString((m_TargetFileEdit));
	DecryptedFileName.Insert(DecryptedFileName.GetLength() - 8, ".new");
	DecryptedFileName.TrimRight(".p7e");
	DWORD dwError = m_pInterface->DevelopFile(
		(PSTR) (m_TargetFileEdit).GetString(),
		(PSTR) (DecryptedFileName).GetString(), 
		&Info);

	if(dwError != EU_ERROR_NONE)
		return;
	
	m_pInterface->ShowSenderInfo(&Info);
	
	m_pInterface->FreeSenderInfo(&Info);

	UpdateData(FALSE);
}

//==============================================================================

void CEUSignTestVCDlg::OnBnClickedButtonCheckCertificate()
{
	UpdateData(TRUE);

	if(!m_bInitialized)
	{
		::MessageBoxA(this->m_hWnd,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_TargetFileEdit.GetLength())
	{
		::MessageBoxA(this->m_hWnd,
			"Не вказано файл з сертифікатом",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	DWORD dwError;

	PBYTE pbCertificate = NULL;
	FILE *fCertificate = NULL;
	DWORD dwFileSize;

	fCertificate = fopen((const char *)m_TargetFileEdit.GetString(),"rb+");
	if(!fCertificate)
	{
		::MessageBoxA(this->m_hWnd,
			"Файл з сертифікатом не знайдено",
			"Повідомлення оператору",
			MB_ICONERROR);
		return;
	}

	fseek(fCertificate, 0L, SEEK_END);
	dwFileSize = (DWORD)ftell(fCertificate);
	pbCertificate = new BYTE[dwFileSize];

	if(pbCertificate == NULL)
	{
		::MessageBoxA(this->m_hWnd,
			"Виникла помилка при зчитуванні файлу з сертифікатом",
			"Повідомлення оператору",
			MB_ICONERROR);

		fclose(fCertificate);
		return;
	}

	fseek(fCertificate, 0L, SEEK_SET);
	fread(pbCertificate, sizeof(BYTE), dwFileSize, fCertificate);
	fclose(fCertificate);

	dwError = m_pInterface->CheckCertificate(pbCertificate, dwFileSize);
	if(dwError == EU_ERROR_NONE)
	{
		::MessageBoxA(this->m_hWnd,
			"Сертифікат успішно перевірено",
			"Повідомлення оператору",
			MB_ICONINFORMATION);
	}
	delete pbCertificate;
}

//==============================================================================
