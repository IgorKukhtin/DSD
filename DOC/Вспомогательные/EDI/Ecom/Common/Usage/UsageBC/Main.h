//---------------------------------------------------------------------------
#ifndef MainH
#define MainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Graphics.hpp>
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------
#include "EUSignCP.h"
#include <Dialogs.hpp>
//---------------------------------------------------------------------------
class TTestForm : public TForm
{
__published:
	TButton *InitializeButton;
	TButton *ParametersButton;
	TButton *CertificatesButton;
	TButton *CRLsButton;
	TButton *PrivateKeyButton;
	TButton *CertificateButton;
	TImage *SplitterImage1;
	TLabel *SexLabel;
	TLabel *FirstNameLabel;
	TLabel *LastNameLabel;
	TLabel *MiddleNameLabel;
	TLabel *PassportLabel;
	TLabel *DRFOLabel;
	TLabel *RoleLabel;
	TComboBoxEx *SexComboBoxEx;
	TEdit *FirstNameEdit;
	TEdit *LastNameEdit;
	TImage *SplitterImage2;
	TEdit *MiddleNameEdit;
	TEdit *PassNumberEdit;
	TEdit *DRFOEdit;
	TEdit *RoleEdit;
	TButton *SignButton;
	TButton *VerifyButton;
	TButton *ResetButton;
	TEdit *PassSeriesEdit;
	TLabel *TargetFileLabel;
	TEdit *TargetFileEdit;
	TButton *SelectTargetFileButton;
	TButton *SignFileButton;
	TButton *VerifyFileButton;
	TLabel *SignLabel;
	TRichEdit *SignRichEdit;
	TOpenDialog *TargetFileOpenDialog;
	TButton *SignTestButton;
	TImage *SplitterImage3;
	TCheckBox *UseInternalSignCheckBox;
	TCheckBox *SignHashCheckBox;
	TImage *Image1;
	TCheckBox *UseRawSignCheckBox;
	TCheckBox *AddSignCheckBox;
	TButton *EncryptButton;
	TButton *EncryptFileButton;
	TButton *DecryptButton;
	TButton *DecryptFileButton;
	TButton *CheckCertificateButton;
	void __fastcall InitializeButtonClick(TObject *Sender);
	void __fastcall ParametersButtonClick(TObject *Sender);
	void __fastcall CertificatesButtonClick(TObject *Sender);
	void __fastcall CRLsButtonClick(TObject *Sender);
	void __fastcall PrivateKeyButtonClick(TObject *Sender);
	void __fastcall CertificateButtonClick(TObject *Sender);
	void __fastcall SignButtonClick(TObject *Sender);
	void __fastcall VerifyButtonClick(TObject *Sender);
	void __fastcall SelectTargetFileButtonClick(TObject *Sender);
	void __fastcall SignFileButtonClick(TObject *Sender);
	void __fastcall VerifyFileButtonClick(TObject *Sender);
	void __fastcall ResetButtonClick(TObject *Sender);
	void __fastcall SignTestButtonClick(TObject *Sender);
	void __fastcall UseInternalSignCheckBoxClick(TObject *Sender);
	void __fastcall UseRawSignCheckBoxClick(TObject *Sender);
	void __fastcall EncryptButtonClick(TObject *Sender);
	void __fastcall DecryptButtonClick(TObject *Sender);
	void __fastcall EncryptFileButtonClick(TObject *Sender);
	void __fastcall DecryptFileButtonClick(TObject *Sender);
	void __fastcall CheckCertificateButtonClick(TObject *Sender);

private:
public:
	__fastcall TTestForm(TComponent* Owner);

	BOOL m_bInitialized;
	PEU_INTERFACE m_pInterface;
};
//---------------------------------------------------------------------------
extern PACKAGE TTestForm *TestForm;
//---------------------------------------------------------------------------
#endif
