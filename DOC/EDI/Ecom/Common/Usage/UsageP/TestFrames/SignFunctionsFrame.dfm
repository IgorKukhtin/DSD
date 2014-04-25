object SignFrame: TSignFrame
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
  object SettingsPanel: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 101
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object SettingsLabel: TLabel
      Left = 16
      Top = 6
      Width = 470
      Height = 19
      AutoSize = False
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object SettingsUnderlineImage: TImage
      Left = 0
      Top = 100
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
    object UseInternalSignCheckBox: TCheckBox
      Left = 32
      Top = 31
      Width = 208
      Height = 17
      Caption = #1042#1080#1082#1086#1088#1080#1089#1090#1086#1074#1091#1074#1072#1090#1080' '#1074#1085#1091#1090#1088#1110#1096#1085#1110#1081' '#1087#1110#1076#1087#1080#1089
      TabOrder = 0
      OnClick = UseInternalSignCheckBoxClick
    end
    object SignHashCheckBox: TCheckBox
      Left = 32
      Top = 77
      Width = 208
      Height = 17
      Caption = #1055#1110#1076#1087#1080#1089#1091#1074#1072#1090#1080' '#1075#1077#1096
      TabOrder = 3
      OnClick = SignHashCheckBoxClick
    end
    object UseRawSignCheckBox: TCheckBox
      Left = 32
      Top = 54
      Width = 208
      Height = 17
      Caption = #1042#1080#1082#1086#1088#1080#1089#1090#1086#1074#1091#1074#1072#1090#1080' '#1089#1082#1086#1088#1086#1095#1077#1085#1080#1081' '#1087#1110#1076#1087#1080#1089
      TabOrder = 2
      OnClick = UseRawSignCheckBoxClick
    end
    object AddCertCheckBox: TCheckBox
      Left = 260
      Top = 31
      Width = 208
      Height = 17
      Caption = #1044#1086#1076#1072#1090#1080' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090
      Enabled = False
      TabOrder = 1
    end
    object HashParamsFromCertCheckBox: TCheckBox
      Left = 260
      Top = 77
      Width = 208
      Height = 17
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080' '#1075#1077#1096' '#1079' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090#1091
      Enabled = False
      TabOrder = 4
    end
  end
  object SignDataPanel: TPanel
    Left = 0
    Top = 101
    Width = 520
    Height = 192
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      520
      192)
    object SignDataUnderlineImage: TImage
      Left = 0
      Top = 191
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
    object DataLabel: TLabel
      Left = 32
      Top = 26
      Width = 89
      Height = 13
      Caption = #1044#1072#1085#1110' '#1076#1083#1103' '#1087#1110#1076#1087#1080#1089#1091':'
    end
    object SignDataLabel: TLabel
      Left = 32
      Top = 100
      Width = 81
      Height = 13
      Caption = #1045#1062#1055' '#1076#1083#1103' '#1076#1072#1085#1080#1093':'
    end
    object SignDataTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 470
      Height = 19
      AutoSize = False
      Caption = #1055#1110#1076#1087#1080#1089' '#1076#1072#1085#1080#1093
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object SignButton: TButton
      Left = 215
      Top = 70
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1055#1110#1076#1087#1080#1089#1072#1090#1080'...'
      Enabled = False
      TabOrder = 1
      OnClick = SignButtonClick
    end
    object SignAddButton: TButton
      Left = 364
      Top = 70
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1044#1086#1076#1072#1090#1080' '#1087#1110#1076#1087#1080#1089'...'
      Enabled = False
      TabOrder = 2
      OnClick = SignAddButtonClick
    end
    object CheckSignButton: TButton
      Left = 215
      Top = 163
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1055#1077#1088#1077#1074#1110#1088#1080#1090#1080'...'
      TabOrder = 4
      OnClick = VerifySignButtonClick
    end
    object SignedDataRichEdit: TRichEdit
      Left = 32
      Top = 117
      Width = 475
      Height = 40
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object VerifyDataSignNextButton: TButton
      Left = 364
      Top = 163
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1055#1077#1088#1077#1074#1110#1088#1080#1090#1080' '#1085#1072#1089#1090#1091#1087#1085#1080#1081'...'
      TabOrder = 5
      OnClick = VerifyDataSignNextButtonClick
    end
    object SignDataEdit: TEdit
      Left = 32
      Top = 43
      Width = 476
      Height = 21
      TabOrder = 0
    end
  end
  object SignFilePanel: TPanel
    Left = 0
    Top = 293
    Width = 520
    Height = 236
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      520
      236)
    object SignFileUnderlineImage: TImage
      Left = 0
      Top = 235
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
    object SignFileLabel: TLabel
      Left = 32
      Top = 26
      Width = 93
      Height = 13
      Caption = #1060#1072#1081#1083' '#1076#1083#1103' '#1087#1110#1076#1087#1080#1089#1091':'
    end
    object SignedFileDataLabel: TLabel
      Left = 32
      Top = 98
      Width = 239
      Height = 13
      Caption = #1045#1062#1055' '#1092#1072#1081#1083#1091' ('#1103#1082#1097#1086' '#1087#1110#1076#1087#1080#1089#1091#1108#1090#1100#1089#1103' '#1075#1077#1096' '#1079#1085#1072#1095#1077#1085#1085#1103'):'
    end
    object SignedFileLabel: TLabel
      Left = 32
      Top = 163
      Width = 391
      Height = 13
      Caption = 
        #1060#1072#1081#1083' '#1079' '#1087#1110#1076#1087#1080#1089#1086#1084'  ('#1103#1082#1097#1086' '#1087#1110#1076#1087#1080#1089#1091#1108#1090#1100#1089#1103' '#1075#1077#1096' '#1079#1085#1072#1095#1077#1085#1085#1103' - '#1092#1072#1081#1083' '#1097#1086' '#1087#1110#1076#1087#1080 +
        #1089#1091#1074#1072#1074#1089#1103'):'
    end
    object SignFileTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 470
      Height = 19
      AutoSize = False
      Caption = #1055#1110#1076#1087#1080#1089' '#1092#1072#1081#1083#1110#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object SignFileButton: TButton
      Left = 215
      Top = 70
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1055#1110#1076#1087#1080#1089#1072#1090#1080'...'
      Enabled = False
      TabOrder = 2
      OnClick = SignFileButtonClick
    end
    object SignFileAddButton: TButton
      Left = 364
      Top = 70
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1044#1086#1076#1072#1090#1080' '#1087#1110#1076#1087#1080#1089'...'
      Enabled = False
      TabOrder = 3
      OnClick = SignFileAddButtonClick
    end
    object CheckFileButton: TButton
      Left = 215
      Top = 207
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1055#1077#1088#1077#1074#1110#1088#1080#1090#1080'...'
      TabOrder = 7
      OnClick = VerifyFileButtonClick
    end
    object VerifyFileSignNextButton: TButton
      Left = 364
      Top = 208
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1055#1077#1088#1077#1074#1110#1088#1080#1090#1080' '#1085#1072#1089#1090#1091#1087#1085#1080#1081'...'
      TabOrder = 8
      OnClick = VerifyFileSignNextButtonClick
    end
    object SignFileEdit: TEdit
      Left = 32
      Top = 43
      Width = 376
      Height = 21
      Enabled = False
      TabOrder = 0
    end
    object ChooseSignFileButton: TButton
      Left = 414
      Top = 42
      Width = 93
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1088#1072#1090#1080'...'
      Enabled = False
      TabOrder = 1
      OnClick = ChooseSignFileButtonClick
    end
    object SignedFileRichEdit: TRichEdit
      Left = 32
      Top = 115
      Width = 475
      Height = 40
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnChange = SignedFileEditChange
    end
    object SignedFileEdit: TEdit
      Left = 32
      Top = 180
      Width = 376
      Height = 21
      TabOrder = 5
      OnChange = SignedFileEditChange
    end
    object ChooseSignedFileButton: TButton
      Left = 414
      Top = 180
      Width = 93
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1088#1072#1090#1080'...'
      TabOrder = 6
      OnClick = ChooseSignedFileButtonClick
    end
  end
  object TestPanel: TPanel
    Left = 0
    Top = 529
    Width = 520
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      520
      62)
    object TestSignLabel: TLabel
      Left = 16
      Top = 6
      Width = 479
      Height = 19
      AutoSize = False
      Caption = #1058#1077#1089#1090#1091#1074#1072#1085#1085#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object FullDataTestButton: TButton
      Left = 32
      Top = 31
      Width = 143
      Height = 22
      Anchors = [akTop]
      Caption = #1055#1110#1076#1087#1080#1089' '#1076#1072#1085#1080#1093'...'
      Enabled = False
      TabOrder = 0
      OnClick = FullDataTestButtonClick
    end
    object FullStreamTestButton: TButton
      Left = 330
      Top = 31
      Width = 143
      Height = 22
      Anchors = [akTop]
      Caption = #1055#1110#1076#1087#1080#1089' '#1076#1072#1085#1080#1093' '#1079' '#1087#1086#1090#1086#1082#1091'...'
      Enabled = False
      TabOrder = 2
      OnClick = FullStreamTestButtonClick
    end
    object FullFileTestButton: TButton
      Left = 181
      Top = 31
      Width = 143
      Height = 22
      Anchors = [akTop]
      Caption = #1055#1110#1076#1087#1080#1089' '#1092#1072#1081#1083#1110#1074'...'
      Enabled = False
      TabOrder = 1
      OnClick = FullFileTestButtonClick
    end
  end
  object TargetFileOpenDialog: TOpenDialog
    Left = 96
    Top = 358
  end
end
