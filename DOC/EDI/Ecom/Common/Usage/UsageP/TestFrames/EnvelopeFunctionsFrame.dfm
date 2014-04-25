object EnvelopeFunctionsFrame: TEnvelopeFunctionsFrame
  Left = 0
  Top = 0
  Width = 520
  Height = 620
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
    object AddSignCheckBox: TCheckBox
      Left = 32
      Top = 31
      Width = 208
      Height = 17
      Caption = #1044#1086#1076#1072#1074#1072#1090#1080' '#1087#1110#1076#1087#1080#1089
      TabOrder = 0
      OnClick = AddSignCheckBoxClick
    end
    object MultiEnvelopCheckBox: TCheckBox
      Left = 32
      Top = 54
      Width = 208
      Height = 17
      Caption = #1064#1080#1092#1088#1091#1074#1072#1090#1080' '#1085#1072' '#1076#1077#1082#1110#1083#1100#1082#1086#1093' '#1072#1073#1086#1085#1077#1090#1110#1074
      TabOrder = 1
    end
    object UseDynamycKeysCheckBox: TCheckBox
      Left = 32
      Top = 77
      Width = 208
      Height = 17
      Caption = #1042#1080#1082#1086#1088#1080#1089#1090#1086#1074#1091#1074#1072#1090#1080' '#1076#1080#1085#1072#1084#1110#1095#1085#1110' '#1082#1083#1102#1095#1110
      TabOrder = 2
      OnClick = UseDynamycKeysCheckBoxClick
    end
    object AppendCertCheckBox: TCheckBox
      Left = 246
      Top = 31
      Width = 187
      Height = 17
      Caption = #1044#1086#1076#1072#1074#1072#1090#1080' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090' '#1076#1086' '#1087#1110#1076#1087#1080#1089#1091
      TabOrder = 3
      OnClick = UseDynamycKeysCheckBoxClick
    end
    object RecipientsCertsFromFileCheckBox: TCheckBox
      Left = 246
      Top = 54
      Width = 203
      Height = 17
      Caption = #1057#1077#1088#1090#1080#1092#1110#1082#1072#1090#1080' '#1086#1076#1077#1088#1078#1091#1074#1072#1095#1110#1074' '#1079' '#1092#1072#1081#1083#1091
      TabOrder = 4
      OnClick = UseDynamycKeysCheckBoxClick
    end
  end
  object EncryptDataPanel: TPanel
    Left = 0
    Top = 101
    Width = 520
    Height = 238
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      520
      238)
    object SignDataUnderlineImage: TImage
      Left = 0
      Top = 237
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
      Width = 115
      Height = 13
      Caption = #1044#1072#1085#1110' '#1076#1083#1103' '#1096#1080#1092#1088#1091#1074#1072#1085#1085#1103':'
    end
    object EncryptDataLabel: TLabel
      Left = 32
      Top = 100
      Width = 94
      Height = 13
      Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1085#1110' '#1076#1072#1085#1110':'
    end
    object EncryptDataTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 96
      Height = 13
      Caption = #1064#1080#1092#1088#1091#1074#1072#1085#1085#1103' '#1076#1072#1085#1080#1093
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object DecryptedDataLabel: TLabel
      Left = 32
      Top = 193
      Width = 99
      Height = 13
      Caption = #1056#1086#1079#1096#1080#1092#1088#1086#1074#1072#1085#1110' '#1076#1072#1085#1110':'
    end
    object EncryptDataButton: TButton
      Left = 364
      Top = 70
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1096#1080#1092#1088#1091#1074#1072#1090#1080'...'
      Enabled = False
      TabOrder = 1
      OnClick = EncryptDataButtonClick
    end
    object DecryptDataButton: TButton
      Left = 364
      Top = 163
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1056#1086#1079#1096#1080#1092#1088#1091#1074#1072#1090#1080'...'
      TabOrder = 3
      OnClick = DecryptDataButtonClick
    end
    object EncryptedDataRichEdit: TRichEdit
      Left = 32
      Top = 117
      Width = 475
      Height = 40
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object EncryptDataEdit: TEdit
      Left = 32
      Top = 43
      Width = 475
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 0
    end
    object DecryptedDataEdit: TEdit
      Left = 32
      Top = 210
      Width = 475
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 4
    end
  end
  object EncryptFilePanel: TPanel
    Left = 0
    Top = 339
    Width = 520
    Height = 220
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      520
      220)
    object SignFileUnderlineImage: TImage
      Left = 0
      Top = 219
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
      ExplicitTop = 230
    end
    object EncryptFileLabel: TLabel
      Left = 32
      Top = 26
      Width = 130
      Height = 13
      Caption = #1060#1072#1081#1083' '#1076#1083#1103' '#1079#1072#1096#1080#1092#1088#1091#1074#1072#1085#1085#1103':'
    end
    object EncryptedFileLabel: TLabel
      Left = 32
      Top = 100
      Width = 109
      Height = 13
      Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1085#1080#1081' '#1092#1072#1081#1083':'
    end
    object EncryptFileTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 101
      Height = 13
      Caption = #1064#1080#1092#1088#1091#1074#1072#1085#1085#1103' '#1092#1072#1081#1083#1110#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object DecryptedFileLabel: TLabel
      Left = 32
      Top = 174
      Width = 114
      Height = 13
      Caption = #1056#1086#1079#1096#1080#1092#1088#1086#1074#1072#1085#1080#1081' '#1092#1072#1081#1083':'
    end
    object EncryptFileButton: TButton
      Left = 364
      Top = 70
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1096#1080#1092#1088#1091#1074#1072#1090#1080'...'
      Enabled = False
      TabOrder = 2
      OnClick = EncryptFileButtonClick
    end
    object DecryptFileButton: TButton
      Left = 364
      Top = 144
      Width = 143
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1056#1086#1079#1096#1080#1092#1088#1091#1074#1072#1090#1080'...'
      TabOrder = 5
      OnClick = DecryptFileButtonClick
    end
    object EncryptFileEdit: TEdit
      Left = 32
      Top = 43
      Width = 376
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 0
    end
    object ChooseEncryptFileButton: TButton
      Left = 414
      Top = 43
      Width = 93
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1088#1072#1090#1080'...'
      Enabled = False
      TabOrder = 1
      OnClick = ChooseEncryptFileButtonClick
    end
    object EncryptedFileEdit: TEdit
      Left = 32
      Top = 117
      Width = 376
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object ChooseEncryptedFileButton: TButton
      Left = 414
      Top = 117
      Width = 93
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1088#1072#1090#1080'...'
      TabOrder = 4
      OnClick = ChooseEncryptedFileButtonClick
    end
    object DecryptedFileEdit: TEdit
      Left = 32
      Top = 191
      Width = 376
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
    end
    object ChooseDecryptedFileButton: TButton
      Left = 414
      Top = 191
      Width = 93
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1088#1072#1090#1080'...'
      TabOrder = 7
      OnClick = ChooseDecryptedFileButtonClick
    end
  end
  object TestPanel: TPanel
    Left = 0
    Top = 559
    Width = 520
    Height = 61
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      520
      61)
    object TestEncryptionLabel: TLabel
      Left = 16
      Top = 6
      Width = 59
      Height = 13
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
      Width = 137
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1064#1080#1092#1088#1091#1074#1072#1085#1085#1103' '#1076#1072#1085#1080#1093'..'
      Enabled = False
      TabOrder = 0
      OnClick = FullDataTestButtonClick
    end
    object FullFileTestButton: TButton
      Left = 175
      Top = 31
      Width = 137
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1064#1080#1092#1088#1091#1074#1072#1085#1085#1103' '#1092#1072#1081#1083#1110#1074'...'
      Enabled = False
      TabOrder = 1
      OnClick = FullFileTestButtonClick
    end
  end
  object TargetFileOpenDialog: TOpenDialog
    Left = 328
    Top = 334
  end
end
