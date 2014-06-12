object TestForm: TTestForm
  Left = -73
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1030#1030#1058' '#1050#1086#1088#1080#1089#1090#1091#1074#1072#1095' '#1062#1057#1050'-1.3. '#1041#1110#1073#1083#1110#1086#1090#1077#1082#1072' '#1087#1110#1076#1087#1080#1089#1091
  ClientHeight = 782
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  DesignSize = (
    536
    782)
  PixelsPerInch = 96
  TextHeight = 13
  object MainFormUnderlineImage: TImage
    Left = 8
    Top = 111
    Width = 520
    Height = 1
    Anchors = [akLeft, akTop, akRight]
    Picture.Data = {
      07544269746D6170F6000000424DF60000000000000036000000280000004000
      0000010000000100180000000000C0000000C40E0000C40E0000000000000000
      00004A23034A23034A23034A23024A22034924044B24044B24044B24044B2404
      4B24044B24044B24044B24044B24034B24044A24044C24054C24054C24054C24
      054C23054C25054C25054C25054B25044D25054D25054D25054D25064D25064D
      25064C25064E24064E24054E26064E26064E26064E26064D26064F26074F2607
      4F26074F25074F27074E27075027075027075027075027074F27085127085126
      0851280851280850280852280852280852280852280851270853290853290853
      2908}
    Stretch = True
  end
  object InitButton: TButton
    Left = 8
    Top = 8
    Width = 147
    Height = 22
    Caption = #1030#1085#1110#1094#1110#1072#1083#1110#1079#1091#1074#1072#1090#1080'...'
    TabOrder = 0
    OnClick = InitButtonClick
  end
  object SettingsButton: TButton
    Left = 8
    Top = 36
    Width = 147
    Height = 22
    Anchors = [akTop, akRight]
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080'...'
    Enabled = False
    TabOrder = 1
    OnClick = SettingsButtonClick
  end
  object UseOwnUICheckBox: TCheckBox
    Left = 8
    Top = 64
    Width = 165
    Height = 17
    Caption = #1042#1110#1076#1086#1073#1088#1072#1078#1072#1090#1080' '#1074#1083#1072#1089#1085#1110' '#1076#1110#1072#1083#1086#1075#1080
    Checked = True
    State = cbChecked
    TabOrder = 2
    WordWrap = True
  end
  object UseCAServersCheckBox: TCheckBox
    Left = 8
    Top = 87
    Width = 122
    Height = 17
    Caption = #1042#1079#1072#1108#1084#1086#1076#1110#1103#1090#1080' '#1079' '#1062#1057#1050
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 3
    WordWrap = True
    OnClick = UseCAServersCheckBoxClick
  end
  object FunctionsPageControl: TPageControl
    Left = 8
    Top = 118
    Width = 520
    Height = 648
    ActivePage = EnvelopeTabSheet
    TabOrder = 4
    OnChange = FunctionsPageControlChange
    object CertAndCRLTabSheet: TTabSheet
      Caption = #1057#1077#1088#1090#1080#1092#1110#1082#1072#1090#1080' '#1090#1072' '#1057#1042#1057
      ImageIndex = 3
      DesignSize = (
        512
        620)
      inline CertAndCRLsFunctionsFrame: TCertAndCRLsFrame
        Left = 0
        Top = 0
        Width = 520
        Height = 620
        Anchors = [akLeft, akBottom]
        TabOrder = 0
        inherited ShowCertAndCRLPanel: TPanel
          Height = 90
          ExplicitHeight = 90
          inherited ShowCertAndCRLUnderlineImage: TImage
            Top = 89
            ExplicitLeft = 16
            ExplicitTop = 86
            ExplicitWidth = 504
          end
          inherited ShowCertificatesButton: TButton
            Left = 16
            ExplicitLeft = 16
          end
          inherited ShowCRLButton: TButton
            Left = 172
            ExplicitLeft = 172
          end
          inherited UpdateCertStorageButton: TButton
            Left = 16
            ExplicitLeft = 16
          end
        end
        inherited CheckCertPanel: TPanel
          Top = 90
          ExplicitTop = 90
          inherited CheckCertLabel: TLabel
            Left = 31
            Width = 114
            ExplicitLeft = 31
            ExplicitWidth = 114
          end
          inherited CheckCertFileEdit: TEdit
            Left = 31
            Width = 377
            ExplicitLeft = 31
            ExplicitWidth = 377
          end
        end
        inherited SearchCertPanel: TPanel
          Top = 189
          ExplicitTop = 189
          inherited SearchCertButtonByNBUCode: TButton
            Left = 31
            ExplicitLeft = 31
          end
          inherited SearchCertButtonByEmail: TButton
            Left = 186
            Width = 191
            Caption = #1047#1072' '#1087#1086#1096#1090#1086#1074#1086#1102' '#1072#1076#1088#1077#1089#1086#1102' (e-mail)...'
            ExplicitLeft = 186
            ExplicitWidth = 191
          end
        end
      end
    end
    object PKTabSheet: TTabSheet
      Caption = #1054#1089#1086#1073#1080#1089#1090#1080#1081' '#1082#1083#1102#1095
      inline PrivateKeyFunctionsFrame: TPKFunctionsFrame
        Left = 0
        Top = 0
        Width = 520
        Height = 620
        TabOrder = 0
        inherited PKParamsPanel: TPanel
          inherited PKFromFileCheckBox: TCheckBox
            Left = 32
            ExplicitLeft = 32
          end
          inherited PKFromFileGroupBox: TGroupBox
            Width = 476
            ExplicitWidth = 476
            inherited PKFileLabel: TLabel
              Width = 141
              ExplicitWidth = 141
            end
            inherited PKPasswordLabel: TLabel
              Width = 151
              ExplicitWidth = 151
            end
            inherited PKFileEdit: TEdit
              Width = 356
              ExplicitWidth = 356
            end
            inherited PKPasswordEdit: TEdit
              Width = 356
              ExplicitWidth = 356
            end
            inherited PKChangeFileButton: TButton
              Left = 375
              ExplicitLeft = 375
            end
          end
        end
      end
    end
    object DSTabSheet: TTabSheet
      Caption = #1045#1062#1055
      ImageIndex = 1
      inline SignFunctionsFrame: TSignFrame
        Left = 0
        Top = 0
        Width = 520
        Height = 620
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        inherited SignDataPanel: TPanel
          inherited SignDataEdit: TEdit
            Width = 475
            ExplicitWidth = 475
          end
        end
        inherited SignFilePanel: TPanel
          inherited SignFileEdit: TEdit
            Anchors = [akLeft, akTop, akRight]
          end
          inherited SignedFileRichEdit: TRichEdit
            Width = 469
            Anchors = [akLeft, akTop, akRight]
            ExplicitWidth = 469
          end
          inherited SignedFileEdit: TEdit
            Anchors = [akLeft, akTop, akRight]
          end
        end
        inherited TestPanel: TPanel
          inherited FullDataTestButton: TButton
            Left = 66
            Anchors = [akTop, akRight]
            ExplicitLeft = 66
          end
          inherited FullStreamTestButton: TButton
            Anchors = [akTop, akRight]
          end
          inherited FullFileTestButton: TButton
            Left = 215
            Anchors = [akTop, akRight]
            OnClick = SignFunctionsFrameFullFileTestButtonClick
            ExplicitLeft = 215
          end
        end
        inherited TargetFileOpenDialog: TOpenDialog
          Left = 104
          Top = 342
        end
      end
    end
    object EnvelopeTabSheet: TTabSheet
      Caption = #1064#1080#1092#1088#1091#1074#1072#1085#1085#1103
      ImageIndex = 2
      inline EnvelopeFunctionsFrame: TEnvelopeFunctionsFrame
        Left = 0
        Top = 0
        Width = 520
        Height = 620
        TabOrder = 0
        inherited EncryptDataPanel: TPanel
          inherited DataLabel: TLabel
            Width = 113
            ExplicitWidth = 113
          end
          inherited EncryptDataLabel: TLabel
            Width = 93
            ExplicitWidth = 93
          end
        end
        inherited EncryptFilePanel: TPanel
          inherited EncryptFileLabel: TLabel
            Width = 131
            ExplicitWidth = 131
          end
          inherited DecryptedFileLabel: TLabel
            Width = 115
            ExplicitWidth = 115
          end
          inherited EncryptFileButton: TButton
            OnClick = EnvelopeFunctionsFrameEncryptFileButtonClick
          end
        end
      end
    end
    object TestSessionTabSheet: TTabSheet
      Caption = #1058#1077#1089#1090#1091#1074#1072#1085#1085#1103' '#1089#1077#1089#1110#1111
      ImageIndex = 4
      inline TestSessionFrame: TTestSessionFrame
        Left = 0
        Top = 0
        Width = 520
        Height = 620
        TabOrder = 0
        inherited SessionParamsPanel: TPanel
          inherited SessionCertExpireTimeLabel: TLabel
            Width = 281
            ExplicitWidth = 281
          end
        end
        inherited SessionClientPanel: TPanel
          inherited ClientFileWithSessionLabel: TLabel
            Width = 78
            ExplicitWidth = 78
          end
          inherited DataToEncryptLabel: TLabel
            Width = 125
            ExplicitWidth = 125
          end
        end
        inherited SessionServerPanel: TPanel
          inherited ServerFileWithSessionLabel: TLabel
            Width = 78
            ExplicitWidth = 78
          end
          inherited EncryptedDataLabel: TLabel
            Width = 93
            ExplicitWidth = 93
          end
        end
      end
    end
  end
end
