unit Main;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, StrUtils, ActiveX, EUSignCP,
  Certificates, ReadPK, CRLs, Settings, Certificate, CMSInfo, EUSignCPOwnUI,
  CertAndCRLFunctionsFrame, PrivateKeyFunctionsFrame,
  SignFunctionsFrame, EnvelopeFunctionsFrame, SessionFunctionsFrame;

{ ------------------------------------------------------------------------------ }

type
  TTestForm = class(TForm)
    InitButton: TButton;
    SettingsButton: TButton;
    UseOwnUICheckBox: TCheckBox;
    UseCAServersCheckBox: TCheckBox;
    MainFormUnderlineImage: TImage;
    FunctionsPageControl: TPageControl;
    PKTabSheet: TTabSheet;
    DSTabSheet: TTabSheet;
    EnvelopeTabSheet: TTabSheet;
    CertAndCRLTabSheet: TTabSheet;
    TestSessionTabSheet: TTabSheet;
    CertAndCRLsFunctionsFrame: TCertAndCRLsFrame;
    PrivateKeyFunctionsFrame: TPKFunctionsFrame;
    SignFunctionsFrame: TSignFrame;
    TestSessionFrame: TTestSessionFrame;
    EnvelopeFunctionsFrame: TEnvelopeFunctionsFrame;
    procedure InitButtonClick(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
    procedure UseCAServersCheckBoxClick(Sender: TObject);

    procedure FunctionsPageControlChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SignFunctionsFrameFullFileTestButtonClick(Sender: TObject);

  public
    CPInitialized: Boolean;
    CPInterface: PEUSignCP;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

{ ------------------------------------------------------------------------------ }

var
  TestForm: TTestForm;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

constructor TTestForm.Create(AOwner: TComponent);
begin
  inherited;
  OleInitialize(nil);
  CPInitialized := False;
end;

{ ------------------------------------------------------------------------------ }

destructor TTestForm.Destroy;
begin
  inherited;
  OleUninitialize;
end;

{ ------------------------------------------------------------------------------ }

procedure TTestForm.FormShow(Sender: TObject);
begin
  FunctionsPageControlChange(nil);
end;

{ ============================================================================== }

procedure TTestForm.InitButtonClick(Sender: TObject);
var
  Error: Cardinal;
  Offline: LongBool;

begin

  if (not CPInitialized) then
  begin
    if (not EULoadDLL()) then
    begin
      MessageBoxA(Handle,
        'Виникла помилка при завантаженні криптографічної бібліотеки',
        'Повідомлення оператору', MB_ICONERROR);

      Exit;
    end;

    CPInterface := EUGetInterface();
    if (CPInterface = nil) then
    begin
      MessageBoxA(Handle,
        'Виникла помилка при завантаженні криптографічної бібліотеки',
        'Повідомлення оператору', MB_ICONERROR);

      EUUnloadDLL();

      Exit;
    end;

    Error := CPInterface.Initialize();
    if (Error <> EU_ERROR_NONE) then
    begin
      MessageBoxA(Handle,
        'Виникла помилка при завантаженні криптографічної бібліотеки',
        'Повідомлення оператору', MB_ICONERROR);
      EUUnloadDLL();

      Exit;
    end;

    Error := CPInterface.GetModeSettings(@Offline);
    if (Error <> EU_ERROR_NONE) then
    begin
      MessageBoxA(Handle,
        'Виникла помилка при завантаженні криптографічної бібліотеки',
        'Повідомлення оператору', MB_ICONERROR);
      CPInterface.Finalize();
      EUUnloadDLL();

      Exit;
    end;

    UseCAServersCheckBox.Checked := not Offline;

    CPInterface.SetUIMode(not UseOwnUICheckBox.Checked);
    EUInitializeOwnUI(CPInterface, UseOwnUICheckBox.Checked);

    InitButton.Caption := 'Завершити роботу...';

    CertAndCRLsFunctionsFrame.Initialize(CPInterface, UseOwnUICheckBox.Checked);
    PrivateKeyFunctionsFrame.Initialize(CPInterface, UseOwnUICheckBox.Checked);
    SignFunctionsFrame.Initialize(CPInterface, UseOwnUICheckBox.Checked);
    EnvelopeFunctionsFrame.Initialize(CPInterface, UseOwnUICheckBox.Checked);
    TestSessionFrame.Initialize(CPInterface, UseOwnUICheckBox.Checked);

    CPInitialized := True;

  end
  else
  begin
    CertAndCRLsFunctionsFrame.Deinitialize();
    EnvelopeFunctionsFrame.Deinitialize();
    SignFunctionsFrame.Deinitialize();
    PrivateKeyFunctionsFrame.Deinitialize();
    TestSessionFrame.Deinitialize();

    CPInterface.Finalize();
    EUUnloadDLL();

    EUDeinitializeOwnUI();
    InitButton.Caption := 'Ініціалізувати...';

    CPInitialized := False;
  end;

  UseOwnUICheckBox.Enabled := (not CPInitialized);
  UseCAServersCheckBox.Enabled := CPInitialized;
  SettingsButton.Enabled := CPInitialized;
end;

{ ------------------------------------------------------------------------------ }

procedure TTestForm.SettingsButtonClick(Sender: TObject);
begin
  if (not CPInitialized) then
  begin
    MessageBoxA(Handle, 'Криптографічну бібліотеку не ініціалізовано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if UseOwnUICheckBox.Checked then
  begin
    EUShowSettings(WindowHandle, '', CPInterface, False);
  end
  else
    CPInterface.SetSettings();
end;

procedure TTestForm.SignFunctionsFrameFullFileTestButtonClick(Sender: TObject);
begin
  SignFunctionsFrame.FullFileTestButtonClick(Sender);

end;

{ ============================================================================== }

procedure TTestForm.FunctionsPageControlChange(Sender: TObject);
begin
  case FunctionsPageControl.ActivePageIndex of
    0: CertAndCRLsFunctionsFrame.WillShow();
    1: PrivateKeyFunctionsFrame.WillShow();
    2: SignFunctionsFrame.WillShow();
    3: EnvelopeFunctionsFrame.WillShow();
    4: TestSessionFrame.WillShow();
  end;
end;

{ ============================================================================== }

procedure TTestForm.UseCAServersCheckBoxClick(Sender: TObject);
var
  Offline: LongBool;

begin
  if (CPInterface.IsInitialized) then
  begin
    Offline := not UseCAServersCheckBox.Checked;
    CPInterface.SetModeSettings(Offline);
  end;
end;

{ ============================================================================== }

end.
