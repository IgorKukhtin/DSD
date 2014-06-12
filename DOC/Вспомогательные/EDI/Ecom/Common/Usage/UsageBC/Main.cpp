//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
#include <stdio.h>
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TTestForm *TestForm;
//---------------------------------------------------------------------------
__fastcall TTestForm::TTestForm(TComponent* Owner)
	: TForm(Owner), m_bInitialized(FALSE)
{
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::InitializeButtonClick(TObject *Sender)
{
	DWORD dwError;

	BOOL bEnabled;
	if(!m_bInitialized)
	{
		if(!EULoad())
		{
			MessageBoxA(this->Handle,
				"Виникла помилка при завантаженні "
				"криптографічної бібліотеки",
				"Повідомлення оператору",
				MB_ICONERROR);

			return;
		}

		m_pInterface = EUGetInterface();
		if(m_pInterface == NULL)
		{
			MessageBoxA(this->Handle,
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

		InitializeButton->Caption = "Завершити роботу...";

		bEnabled = TRUE;

		SexComboBoxEx->ItemIndex = 0;
	}
	else
	{
		m_pInterface->Finalize();
		EUUnload();

		m_bInitialized = FALSE;

		InitializeButton->Caption = "Ініціалізувати...";
		PrivateKeyButton->Caption = "Зчитати ключ...";

        bEnabled = FALSE;

		CertificateButton->Enabled = FALSE;
		SignButton->Enabled = FALSE;
		SignFileButton->Enabled = FALSE;
		SignTestButton->Enabled = FALSE;

		EncryptButton->Enabled = FALSE;
		DecryptButton->Enabled = FALSE;
		EncryptFileButton->Enabled = FALSE;
		DecryptFileButton->Enabled = FALSE;

		SexComboBoxEx->ItemIndex = -1;
	}

	ParametersButton->Enabled = bEnabled;
	CertificatesButton->Enabled = bEnabled;
	CRLsButton->Enabled = bEnabled;
	PrivateKeyButton->Enabled = bEnabled;

	UseInternalSignCheckBox->Enabled = bEnabled;
	SignHashCheckBox->Enabled = bEnabled;
	UseRawSignCheckBox->Enabled = bEnabled;
	AddSignCheckBox->Enabled = bEnabled;

	VerifyButton->Enabled = bEnabled;
	VerifyFileButton->Enabled = bEnabled;
	CheckCertificateButton->Enabled = bEnabled;

	if(bEnabled)
		UseRawSignCheckBoxClick(NULL);
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::ParametersButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	m_pInterface->SetSettings();
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::CertificatesButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	m_pInterface->ShowCertificates();
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::CRLsButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	m_pInterface->ShowCRLs();
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::PrivateKeyButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	BOOL bEnabled;
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

		PrivateKeyButton->Caption = "Зтерти ключ...";

		bEnabled = TRUE;
	}
	else
	{
		m_pInterface->ResetPrivateKey();

		PrivateKeyButton->Caption = "Зчитати ключ...";
		bEnabled = FALSE;
	}

	CertificateButton->Enabled = bEnabled;
	SignButton->Enabled = bEnabled;
	SignFileButton->Enabled = bEnabled;
	SignTestButton->Enabled = bEnabled;
	EncryptButton->Enabled = bEnabled;
	DecryptButton->Enabled = bEnabled;
	EncryptFileButton->Enabled = bEnabled;
	DecryptFileButton->Enabled = bEnabled;
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::CertificateButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		MessageBoxA(this->Handle,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	m_pInterface->ShowOwnCertificate();
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::SignButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		MessageBoxA(this->Handle,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	PWCHAR pszSex[] = {L"Male", L"Female"};
	UnicodeString Data;
	DWORD dwError;
	PAnsiChar pSign;
	PAnsiChar pHash;

	if(UseRawSignCheckBox->Checked)
	{
		Data = String(pszSex[SexComboBoxEx->ItemIndex]) +
			FirstNameEdit->Text + LastNameEdit->Text +
			MiddleNameEdit->Text + PassSeriesEdit->Text +
			PassNumberEdit->Text + DRFOEdit->Text +
			RoleEdit->Text;

		dwError = m_pInterface->RawSignData(
			(PBYTE) Data.w_str(), Data.Length() * 2,
			&pSign, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
			return;
	}
	else if(UseInternalSignCheckBox->Checked)
	{
		Data = String(pszSex[SexComboBoxEx->ItemIndex]) +
			FirstNameEdit->Text + LastNameEdit->Text +
			MiddleNameEdit->Text + PassSeriesEdit->Text +
			PassNumberEdit->Text + DRFOEdit->Text +
			RoleEdit->Text;

		dwError = m_pInterface->SignDataInternal(FALSE,
			(PBYTE) Data.w_str(), Data.Length() * 2,
			&pSign, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
			return;
	}
	else if(SignHashCheckBox->Enabled && SignHashCheckBox->Checked)
	{
		if(((dwError = m_pInterface->HashDataContinue(
				(PBYTE) pszSex[SexComboBoxEx->ItemIndex],
				wcslen(pszSex[SexComboBoxEx->ItemIndex]) * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) FirstNameEdit->Text.w_str(),
				FirstNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) LastNameEdit->Text.w_str(),
				LastNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) MiddleNameEdit->Text.w_str(),
				MiddleNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) PassSeriesEdit->Text.w_str(),
				PassSeriesEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) PassNumberEdit->Text.w_str(),
				PassNumberEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) DRFOEdit->Text.w_str(),
				DRFOEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) RoleEdit->Text.w_str(),
				RoleEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataEnd(
				&pHash, NULL, NULL)
			!= EU_ERROR_NONE)))
		{
			m_pInterface->ResetOperation();

			return;
		}

		dwError = m_pInterface->SignHash(pHash, NULL, 0,
			&pSign, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->FreeMemory(pHash);

			return;
		}

		m_pInterface->FreeMemory(pHash);
	}
	else
	{
		if(((dwError = m_pInterface->SignDataContinue(
				(PBYTE) pszSex[SexComboBoxEx->ItemIndex],
				wcslen(pszSex[SexComboBoxEx->ItemIndex]) * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) FirstNameEdit->Text.w_str(),
				FirstNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) LastNameEdit->Text.w_str(),
				LastNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) MiddleNameEdit->Text.w_str(),
				MiddleNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) PassSeriesEdit->Text.w_str(),
				PassSeriesEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) PassNumberEdit->Text.w_str(),
				PassNumberEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) DRFOEdit->Text.w_str(),
				DRFOEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->SignDataContinue(
				(PBYTE) RoleEdit->Text.w_str(),
				RoleEdit->Text.Length() * 2))
			!= EU_ERROR_NONE))
		{
			m_pInterface->ResetOperation();

			return;
		}

		dwError = m_pInterface->SignDataEnd(&pSign, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->ResetOperation();

			return;
		}
	}

	SignRichEdit->Lines->Clear();
	SignRichEdit->Lines->Add(pSign);

	m_pInterface->FreeMemory(pSign);
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::VerifyButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	PWCHAR pszSex[] = {L"Male", L"Female"};
	UnicodeString S = "";
	UnicodeString Data;
	DWORD dwError;
	EU_SIGN_INFO SignInfo;
	PBYTE pbData;
	DWORD dwDataLength;
	PAnsiChar pHash;

	for(INT i = 0; i < SignRichEdit->Lines->Count; i ++)
		S += SignRichEdit->Lines->Strings[i];

	if(UseRawSignCheckBox->Checked)
	{
		Data = String(pszSex[SexComboBoxEx->ItemIndex]) +
			FirstNameEdit->Text + LastNameEdit->Text +
			MiddleNameEdit->Text + PassSeriesEdit->Text +
			PassNumberEdit->Text + DRFOEdit->Text +
			RoleEdit->Text;

		dwError = m_pInterface->RawVerifyData(
			(PBYTE) Data.w_str(), Data.Length() * 2,
			AnsiString(S).c_str(), NULL, 0, &SignInfo);
		if(dwError != EU_ERROR_NONE)
			return;
	}
	else if(UseInternalSignCheckBox->Checked)
	{
		dwError = m_pInterface->VerifyDataInternal(
			AnsiString(S).c_str(), NULL, 0,
			&pbData, &dwDataLength,
			&SignInfo);
		if(dwError != EU_ERROR_NONE)
			return;

		m_pInterface->FreeMemory(pbData);
	}
	else if(SignHashCheckBox->Enabled && SignHashCheckBox->Checked)
	{
		if(((dwError = m_pInterface->HashDataContinue(
				(PBYTE) pszSex[SexComboBoxEx->ItemIndex],
				wcslen(pszSex[SexComboBoxEx->ItemIndex]) * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) FirstNameEdit->Text.w_str(),
				FirstNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) LastNameEdit->Text.w_str(),
				LastNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) MiddleNameEdit->Text.w_str(),
				MiddleNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) PassSeriesEdit->Text.w_str(),
				PassSeriesEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) PassNumberEdit->Text.w_str(),
				PassNumberEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) DRFOEdit->Text.w_str(),
				DRFOEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataContinue(
				(PBYTE) RoleEdit->Text.w_str(),
				RoleEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->HashDataEnd(
				&pHash, NULL, NULL)
			!= EU_ERROR_NONE)))
		{
			m_pInterface->ResetOperation();

			return;
		}

		dwError = m_pInterface->VerifyHash(pHash, NULL, 0,
			AnsiString(S).c_str(), NULL, 0, &SignInfo);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->FreeMemory(pHash);

			return;
		}

		m_pInterface->FreeMemory(pHash);
	}
	else
	{
		dwError = m_pInterface->VerifyDataBegin(
			AnsiString(S).c_str(), NULL, NULL);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->ResetOperation();

			return;
		}

		if(((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) pszSex[SexComboBoxEx->ItemIndex],
				wcslen(pszSex[SexComboBoxEx->ItemIndex]) * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) FirstNameEdit->Text.w_str(),
				FirstNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) LastNameEdit->Text.w_str(),
				LastNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) MiddleNameEdit->Text.w_str(),
				MiddleNameEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) PassSeriesEdit->Text.w_str(),
				PassSeriesEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) PassNumberEdit->Text.w_str(),
				PassNumberEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) DRFOEdit->Text.w_str(),
				DRFOEdit->Text.Length() * 2))
			!= EU_ERROR_NONE) ||
			((dwError = m_pInterface->VerifyDataContinue(
				(PBYTE) RoleEdit->Text.w_str(),
				RoleEdit->Text.Length() * 2))
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
//---------------------------------------------------------------------------
void __fastcall TTestForm::SelectTargetFileButtonClick(TObject *Sender)
{
	if(!TargetFileOpenDialog->Execute(this->Handle))
		return;

	TargetFileEdit->Text = TargetFileOpenDialog->FileName;
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::SignFileButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		MessageBoxA(this->Handle,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(TargetFileEdit->Text == "")
	{
		MessageBoxA(this->Handle,
			"Не вказано файл для підпису",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	DWORD dwError;
	PAnsiChar pHash;
	PAnsiChar pSign;

	if(SignHashCheckBox->Enabled && SignHashCheckBox->Checked)
	{
		dwError = m_pInterface->HashFile(
			AnsiString(TargetFileEdit->Text).c_str(),
			&pHash, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
			return;

		dwError = m_pInterface->SignHash(pHash, NULL, 0,
			&pSign, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->FreeMemory(pHash);

			return;
		}

		m_pInterface->FreeMemory(pHash);

		SignRichEdit->Lines->Clear();
		SignRichEdit->Lines->Add(pSign);

		m_pInterface->FreeMemory(pSign);
	}
	else if(UseInternalSignCheckBox->Enabled)
	{
		dwError = m_pInterface->SignFile(
			AnsiString(TargetFileEdit->Text).c_str(),
			AnsiString((TargetFileEdit->Text + ".p7s")).c_str(),
			!UseInternalSignCheckBox->Checked);
		if(dwError != EU_ERROR_NONE)
			return;
	}
	else
	{
		dwError = m_pInterface->RawSignFile(
			AnsiString(TargetFileEdit->Text).c_str(),
			AnsiString((TargetFileEdit->Text + ".raw.sig")).c_str());
		if(dwError != EU_ERROR_NONE)
			return;
	}

	MessageBoxA(this->Handle,
		"Файл підписано",
		"Повідомлення оператору",
		MB_ICONINFORMATION);
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::VerifyFileButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(TargetFileEdit->Text == "")
	{
		MessageBoxA(this->Handle,
			"Не вказано файл з підписаними даними (*.p7s)",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	DWORD dwError;
	EU_SIGN_INFO SignInfo;
	UnicodeString DataFileName;
	PAnsiChar pHash;
	UnicodeString S = "";

	if(UseInternalSignCheckBox->Checked)
	{
		DataFileName = TargetFileEdit->Text + ".new";
	}
	else if(UseInternalSignCheckBox->Enabled)
	{
		DataFileName = TargetFileEdit->Text.SubString(
			0, TargetFileEdit->Text.Length() - 4);
	}
	else
	{
		DataFileName = TargetFileEdit->Text.SubString(
			0, TargetFileEdit->Text.Length() - 8);
	}

	if(SignHashCheckBox->Enabled && SignHashCheckBox->Checked)
	{
		dwError = m_pInterface->HashFile(
			AnsiString(TargetFileEdit->Text).c_str(),
			&pHash, NULL, NULL);
		if(dwError != EU_ERROR_NONE)
			return;

		for(INT i = 0; i < SignRichEdit->Lines->Count; i ++)
			S += SignRichEdit->Lines->Strings[i];

		dwError = m_pInterface->VerifyHash(pHash, NULL, 0,
			AnsiString(S).c_str(), NULL, 0, &SignInfo);
		if(dwError != EU_ERROR_NONE)
		{
			m_pInterface->FreeMemory(pHash);

			return;
		}

		m_pInterface->FreeMemory(pHash);
	}
	else if(UseInternalSignCheckBox->Enabled)
	{
		dwError = m_pInterface->VerifyFile(
			AnsiString(TargetFileEdit->Text).c_str(),
			AnsiString(DataFileName).c_str(),
			&SignInfo);
		if(dwError != EU_ERROR_NONE)
			return;
	}
	else
	{
		dwError = m_pInterface->RawVerifyFile(
			AnsiString(TargetFileEdit->Text).c_str(),
			AnsiString(DataFileName).c_str(),
			&SignInfo);
		if(dwError != EU_ERROR_NONE)
			return;
	}

	m_pInterface->ShowSignInfo(&SignInfo);

	m_pInterface->FreeSignInfo(&SignInfo);
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::ResetButtonClick(TObject *Sender)
{
	if(m_bInitialized && m_pInterface->IsPrivateKeyReaded())
		m_pInterface->ResetOperation();

	FirstNameEdit->Text = "";
	LastNameEdit->Text = "";
	MiddleNameEdit->Text = "";
	PassSeriesEdit->Text = "";
	PassNumberEdit->Text = "";
	DRFOEdit->Text = "";
	RoleEdit->Text = "";
	TargetFileEdit->Text = "";
	SignRichEdit->Lines->Clear();
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::SignTestButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		MessageBoxA(this->Handle,
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
		MessageBoxA(this->Handle,
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
		m_pInterface->FreeMemory(pszSign);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory(pszSign);

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
		m_pInterface->FreeMemory(pszSign);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory(pszSign);

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

		MessageBoxA(this->Handle,
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
		m_pInterface->FreeMemory(pszSignedData);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory(pszSignedData);

	if(dwVerifiedDataSize != dwDataSize ||
		memcmp(pbData, pbVerifiedData, dwDataSize))
	{
		m_pInterface->FreeMemory(pbVerifiedData);
		delete [] pbData;

		MessageBoxA(this->Handle,
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
		m_pInterface->FreeMemory(pszSign);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory(pszSign);

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
		m_pInterface->FreeMemory(pszHash);
		delete [] pbData;

		return;
	}

	dwError = m_pInterface->RawVerifyHash(
		pszHash, NULL, 0,
		pszSign, NULL, 0, &SignInfo);
	if(dwError != EU_ERROR_NONE)
	{
		m_pInterface->FreeMemory(pszSign);
		m_pInterface->FreeMemory(pszHash);
		delete [] pbData;

		return;
	}

	m_pInterface->FreeMemory(pszSign);
	m_pInterface->FreeMemory(pszHash);

	m_pInterface->ShowSignInfo(&SignInfo);
	m_pInterface->FreeSignInfo(&SignInfo);

	delete [] pbData;

	MessageBoxA(this->Handle,
		"Тестування завершилося успішно",
		"Повідомлення оператору",
		MB_ICONINFORMATION);
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::UseInternalSignCheckBoxClick(TObject *Sender)
{
	SignHashCheckBox->Enabled = !UseRawSignCheckBox->Checked &&
		!UseInternalSignCheckBox->Checked;
	UseRawSignCheckBox->Enabled = !UseInternalSignCheckBox->Checked;
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::UseRawSignCheckBoxClick(TObject *Sender)
{
	UseInternalSignCheckBox->Enabled = !UseRawSignCheckBox->Checked;

	UseInternalSignCheckBoxClick(Sender);
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::EncryptButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		MessageBoxA(this->Handle,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	PWCHAR pszSex[] = {L"Male", L"Female"};
	UnicodeString Data;
	DWORD dwError;
	PEU_CERTIFICATES pReceiversCerts = NULL;
	PAnsiChar pEncryptedData;

	Data = String(pszSex[SexComboBoxEx->ItemIndex]) +
		FirstNameEdit->Text + LastNameEdit->Text +
		MiddleNameEdit->Text + PassSeriesEdit->Text +
		PassNumberEdit->Text + DRFOEdit->Text +
		RoleEdit->Text;

	dwError = m_pInterface->GetReceiversCertificates(&pReceiversCerts);

	if(dwError != EU_ERROR_NONE)
		return;

	dwError = m_pInterface->EnvelopData(
		pReceiversCerts->ppCertificates[0]->pszIssuer,
		pReceiversCerts->ppCertificates[0]->pszSerial,
		AddSignCheckBox->Checked,
		(PBYTE) Data.w_str(), Data.Length() * 2,
		&pEncryptedData, NULL, 0);

	m_pInterface->FreeReceiversCertificates(pReceiversCerts);

	if(dwError != EU_ERROR_NONE)
		  return;

	SignRichEdit->Lines->Clear();
	SignRichEdit->Lines->Add(pEncryptedData);

	m_pInterface->FreeMemory(pEncryptedData);
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::DecryptButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		MessageBoxA(this->Handle,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	PBYTE pDecryptedData;
	DWORD dwDecryptedData;
	DWORD dwError;
	EU_ENVELOP_INFO Info;
	UnicodeString S = "";

	for(INT i = 0; i < SignRichEdit->Lines->Count; i ++)
		S += SignRichEdit->Lines->Strings[i];

	dwError = m_pInterface->DevelopData(
		AnsiString(S).c_str(), NULL, 0,
		&pDecryptedData,
		&dwDecryptedData,
		&Info);

	if(dwError != EU_ERROR_NONE)
		return;

	m_pInterface->ShowSenderInfo(&Info);

	m_pInterface->FreeMemory(pDecryptedData);
	m_pInterface->FreeSenderInfo(&Info);
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::EncryptFileButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		MessageBoxA(this->Handle,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(TargetFileEdit->Text == "")
	{
		MessageBoxA(this->Handle,
			"Не вказано файл для зашифрування",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	DWORD dwError;
	PEU_CERTIFICATES pReceiversCerts = NULL;

	dwError = m_pInterface->GetReceiversCertificates(&pReceiversCerts);

	if(dwError != EU_ERROR_NONE)
		return;

	dwError = m_pInterface->EnvelopFile(
		pReceiversCerts->ppCertificates[0]->pszIssuer,
		pReceiversCerts->ppCertificates[0]->pszSerial,
		AddSignCheckBox->Checked,
		AnsiString(TargetFileEdit->Text).c_str(),
		AnsiString((TargetFileEdit->Text + ".p7e")).c_str());

	m_pInterface->FreeReceiversCertificates(pReceiversCerts);

	if(dwError != EU_ERROR_NONE)
		return;

	MessageBoxA(this->Handle,
		"Файл зашифровано",
		"Повідомлення оператору",
		MB_ICONINFORMATION);
}
//---------------------------------------------------------------------------
void __fastcall TTestForm::DecryptFileButtonClick(TObject *Sender)
{
	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(TargetFileEdit->Text == "")
	{
		MessageBoxA(this->Handle,
			"Не вказано файл з зашифрованими даними (*.p7e)",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(!m_pInterface->IsPrivateKeyReaded())
	{
		MessageBoxA(this->Handle,
			"Ключ не зчитано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	DWORD dwError;
	UnicodeString DevelopedFileName;
	EU_ENVELOP_INFO Info;

	DevelopedFileName = TargetFileEdit->Text.SubString(
			0, TargetFileEdit->Text.Length() - 8) + ".new" +
			TargetFileEdit->Text.SubString(TargetFileEdit->Text.Length() - 7, 4);

	m_pInterface->DevelopFile(
	   AnsiString(TargetFileEdit->Text).c_str(),
	   AnsiString(DevelopedFileName).c_str(),
	   &Info);

	if(dwError != EU_ERROR_NONE)
		return;

	m_pInterface->ShowSenderInfo(&Info);

	m_pInterface->FreeSenderInfo(&Info);
}
//---------------------------------------------------------------------------

void __fastcall TTestForm::CheckCertificateButtonClick(TObject *Sender)
{
  	if(!m_bInitialized)
	{
		MessageBoxA(this->Handle,
			"Криптографічну бібліотеку не ініціалізовано",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

	if(TargetFileEdit->Text == "")
	{
		MessageBoxA(this->Handle,
			"Не вказано файл з сертифікатом",
			"Повідомлення оператору",
			MB_ICONERROR);

		return;
	}

    	DWORD dwError;

	PBYTE pbCertificate;
	FILE *fCertificate;
	DWORD dwFileSize;

	fCertificate = fopen(AnsiString(TargetFileEdit->Text).c_str(),"rb+");
	if(!fCertificate)
	{
		MessageBoxA(this->Handle,
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
		MessageBoxA(this->Handle,
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
		MessageBoxA(this->Handle,
			"Сертифікат успішно перевірено",
			"Повідомлення оператору",
			MB_ICONINFORMATION);
	}
	delete pbCertificate;
}
//---------------------------------------------------------------------------

