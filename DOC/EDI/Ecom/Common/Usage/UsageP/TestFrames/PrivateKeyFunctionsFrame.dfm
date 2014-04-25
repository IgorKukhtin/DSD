object PKFunctionsFrame: TPKFunctionsFrame
  Left = 0
  Top = 0
  Width = 520
  Height = 620
  TabOrder = 0
  object PKParamsPanel: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 177
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object PKParamsUnderlineImage: TImage
      Left = 0
      Top = 176
      Width = 520
      Height = 1
      Align = alBottom
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
      ExplicitTop = 50
      ExplicitWidth = 519
    end
    object PKParamsTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 57
      Height = 13
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object PKFromFileCheckBox: TCheckBox
      Left = 25
      Top = 31
      Width = 208
      Height = 17
      Caption = #1054#1089#1086#1073#1080#1089#1090#1080#1081' '#1082#1083#1102#1095' '#1079' '#1092#1072#1081#1083#1091
      TabOrder = 0
      OnClick = PKFromFileCheckBoxClick
    end
    object PKFromFileGroupBox: TGroupBox
      Left = 32
      Top = 54
      Width = 475
      Height = 114
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080' '#1076#1086#1089#1090#1091#1087#1091' '#1076#1086' '#1086#1089#1086#1073#1080#1089#1090#1086#1075#1086' '#1082#1083#1102#1095#1072
      TabOrder = 1
      DesignSize = (
        475
        114)
      object PKFileLabel: TLabel
        Left = 13
        Top = 20
        Width = 135
        Height = 13
        Caption = #1060#1072#1081#1083' '#1079' '#1086#1089#1086#1073#1080#1089#1090#1080#1084' '#1082#1083#1102#1095#1077#1084':'
      end
      object PKPasswordLabel: TLabel
        Left = 13
        Top = 66
        Width = 153
        Height = 13
        Caption = #1055#1072#1088#1086#1083#1100' '#1076#1086' '#1086#1089#1086#1073#1080#1089#1090#1086#1075#1086' '#1082#1083#1102#1095#1072':'
      end
      object PKFileEdit: TEdit
        Left = 12
        Top = 37
        Width = 354
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        ExplicitWidth = 377
      end
      object PKPasswordEdit: TEdit
        Left = 12
        Top = 83
        Width = 354
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        PasswordChar = '*'
        TabOrder = 2
        ExplicitWidth = 377
      end
      object PKChangeFileButton: TButton
        Left = 373
        Top = 37
        Width = 93
        Height = 21
        Anchors = [akTop, akRight]
        Caption = #1047#1084#1110#1085#1080#1090#1080'...'
        TabOrder = 1
        OnClick = PKChangeFileButtonClick
        ExplicitLeft = 396
      end
    end
  end
  object PKReadPanel: TPanel
    Left = 0
    Top = 177
    Width = 520
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object PKReadUnderlineImage: TImage
      Left = 0
      Top = 59
      Width = 520
      Height = 1
      Align = alBottom
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
      ExplicitTop = 50
      ExplicitWidth = 519
    end
    object PKReadTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 153
      Height = 13
      Caption = #1047#1095#1080#1090#1091#1074#1072#1085#1085#1103' '#1086#1089#1086#1073#1080#1089#1090#1086#1075#1086' '#1082#1083#1102#1095#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object PKCertificateButton: TButton
      Left = 188
      Top = 31
      Width = 200
      Height = 22
      Caption = #1055#1077#1088#1077#1075#1083#1103#1085#1091#1090#1080' '#1074#1083#1072#1089#1085#1080#1081' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090'...'
      Enabled = False
      TabOrder = 1
      OnClick = PKCertificateButtonClick
    end
    object PKReadButton: TButton
      Left = 32
      Top = 31
      Width = 150
      Height = 22
      Caption = #1047#1095#1080#1090#1072#1090#1080' '#1086#1089#1086#1073#1080#1089#1090#1080#1081' '#1082#1083#1102#1095'...'
      TabOrder = 0
      OnClick = PKReadButtonClick
    end
  end
  object PKFunctionsPanel: TPanel
    Left = 0
    Top = 237
    Width = 520
    Height = 116
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object PKFunctionsUnderlineImage: TImage
      Left = 0
      Top = 115
      Width = 520
      Height = 1
      Align = alBottom
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
      Visible = False
      ExplicitTop = 50
      ExplicitWidth = 519
    end
    object PKFunctionsTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 79
      Height = 13
      Caption = #1054#1089#1085#1086#1074#1085#1110' '#1092#1091#1085#1082#1094#1110#1111
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object PKChangePasswordButton: TButton
      Left = 32
      Top = 31
      Width = 150
      Height = 22
      Caption = #1047#1084#1110#1085#1080#1090#1080' '#1087#1072#1088#1086#1083#1100'...'
      TabOrder = 0
      OnClick = PKChangePasswordButtonClick
    end
    object PKBackupButton: TButton
      Left = 32
      Top = 59
      Width = 150
      Height = 22
      Caption = #1056#1077#1079#1077#1088#1074#1085#1072' '#1082#1086#1087#1110#1103' '#1082#1083#1102#1095#1072'...'
      TabOrder = 1
      OnClick = PKBackupButtonClick
    end
    object PKGenButton: TButton
      Left = 32
      Top = 87
      Width = 150
      Height = 22
      Caption = #1047#1075#1077#1085#1077#1088#1091#1074#1072#1090#1080' '#1082#1083#1102#1095#1110'...'
      TabOrder = 2
      OnClick = PKGenButtonClick
    end
    object PKDestroyButton: TButton
      Left = 188
      Top = 87
      Width = 150
      Height = 22
      Caption = #1047#1085#1080#1097#1080#1090#1080' '#1082#1083#1102#1095'...'
      TabOrder = 3
      OnClick = PKDestroyButtonClick
    end
  end
  object PKOpenDialog: TOpenDialog
    DefaultExt = 'dat'
    Filter = #1060#1072#1081#1083#1080' '#1079' '#1082#1083#1102#1095#1072#1084#1080' (*.dat)|*.dat'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = #1054#1073#1088#1072#1090#1080' '#1092#1072#1081#1083' '#1079' '#1086#1089#1086#1073#1080#1089#1090#1080#1084' '#1082#1083#1102#1095#1077#1084
    Left = 320
    Top = 46
  end
end
