//==============================================================================

#include "StdAfx.h"
#include "EUSignTestVC.h"
#include "EUSignTestVCDlg.h"

//==============================================================================

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

//==============================================================================

CEUSignTestVCApp::CEUSignTestVCApp()
{
}


//==============================================================================

CEUSignTestVCApp theApp;

//==============================================================================

BOOL CEUSignTestVCApp::InitInstance()
{
	InitCommonControls();
	AfxInitRichEdit2();

	CWinApp::InitInstance();

	CEUSignTestVCDlg dlg;
	m_pMainWnd = &dlg;
	dlg.DoModal();

	return FALSE;
}

//==============================================================================
