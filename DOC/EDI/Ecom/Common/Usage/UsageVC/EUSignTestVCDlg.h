//==============================================================================

#pragma once
#include "afxwin.h"

//==============================================================================

class CEUSignTestVCDlg : public CDialog
{
public:
	CEUSignTestVCDlg(CWnd* pParent = NULL);
	~CEUSignTestVCDlg();

	enum { IDD = IDD_EUSIGNTESTVC_DIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);

protected:
	HICON m_hIcon;

	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()

private:
	BOOL m_bInitialized;
	PEU_INTERFACE m_pInterface;
	BSTR m_bstrFirstName;
	BSTR m_bstrLastName;
	BSTR m_bstrMiddleName;
	BSTR m_bstrPassSeries;
	BSTR m_bstrPassNumber;
	BSTR m_bstrDRFO;
	BSTR m_bstrRole;
	BSTR m_bstrAll;

public:
	CButton m_InitializeButton;
	CButton m_ParametersButton;
	CButton m_CertificatesButton;
	CButton m_CRLsButton;
	CButton m_PrivateKeyButton;
	CButton m_CertificateButton;
	CButton m_SignButton;
	CButton m_FullTestButton;
	CButton m_VerifyButton;
	CButton m_SignFileButton;
	CButton m_VerifyFileButton;
	CButton m_EncryptButton;
	CButton m_DecrtypButton;
	CButton m_EncryptFileButton;
	CButton m_DecryptFileButton;
	CButton m_CheckCertificateButton;
	int m_ComboSex;
	CString m_FirstNameEdit;
	CString m_LastNameEdit;
	CString m_MiddleNameEdit;
	CString m_PassSeriesEdit;
	CString m_PassNumberEdit;
	CString m_DRFOEdit;
	CString m_RoleEdit;
	CString m_TargetFileEdit;
	CString m_SignEdit;
	CButton m_UseInternalSignCheckBox;
	CButton m_SignHashCheckBox;
	CButton m_UseRawSignCheckBox;
	CButton m_AddSignCheckBox;
	afx_msg void OnBnClickedButtonInitialize();
	afx_msg void OnBnClickedButtonParameters();
	afx_msg void OnBnClickedButtonCertificates();
	afx_msg void OnBnClickedButtonCrls();
	afx_msg void OnBnClickedButtonPrivateKey();
	afx_msg void OnBnClickedButtonCertificate();
	afx_msg void OnBnClickedButtonSign();
	afx_msg void OnBnClickedButtonVerify();
	afx_msg void OnBnClickedButtonSelectTargetFile();
	afx_msg void OnBnClickedButtonSignFile();
	afx_msg void OnBnClickedButtonVerifyFile();
	afx_msg void OnBnClickedButtonEncrypt();
	afx_msg void OnBnClickedButtonDecrypt();
	afx_msg void OnBnClickedButtonEncryptFile();
	afx_msg void OnBnClickedButtonDecryptFile();
	afx_msg void OnBnClickedButtonCheckCertificate();
	afx_msg void OnBnClickedButtonClear();
	afx_msg void OnBnClickedButtonFullTest();
	afx_msg void OnBnClickedCheckUseInternalSign();
	afx_msg void OnBnClickedCheckUseRawSign();
};

//==============================================================================
