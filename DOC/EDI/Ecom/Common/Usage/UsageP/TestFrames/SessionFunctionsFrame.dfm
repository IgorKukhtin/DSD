object TestSessionFrame: TTestSessionFrame
  Left = 0
  Top = 0
  Width = 520
  Height = 620
  TabOrder = 0
  object SessionParamsPanel: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      520
      56)
    object SessionParamsUnderlineImage: TImage
      Left = 0
      Top = 55
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
      ExplicitTop = 57
    end
    object SessionParamsTitleLabel: TLabel
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
    object SessionCertExpireTimeLabel: TLabel
      Left = 32
      Top = 31
      Width = 279
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = #1063#1072#1089' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103' '#1089#1090#1072#1085#1091' '#1087#1077#1088#1077#1074#1110#1088#1077#1085#1080#1093' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090#1110#1074' '#1089#1077#1089#1110#1111', '#1089':'
    end
    object SessionCertExpireTimeEdit: TEdit
      Left = 315
      Top = 28
      Width = 67
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = '3600'
    end
  end
  object SessionClientPanel: TPanel
    Left = 0
    Top = 116
    Width = 520
    Height = 202
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      520
      202)
    object ClientSessionUnderlineImage: TImage
      Left = 0
      Top = 201
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
      ExplicitTop = 162
    end
    object SessionClientTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 470
      Height = 19
      AutoSize = False
      Caption = #1050#1083#1110#1108#1085#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object ClientFileWithSessionLabel: TLabel
      Left = 32
      Top = 26
      Width = 73
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = #1060#1072#1081#1083' '#1079' '#1089#1077#1089#1110#1108#1102':'
    end
    object DataToEncryptLabel: TLabel
      Left = 32
      Top = 128
      Width = 126
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = #1044#1072#1085#1110' '#1076#1083#1103' '#1079#1072#1096#1080#1092#1088#1091#1074#1072#1085#1085#1103':'
    end
    object ShowServerCertButton: TButton
      Left = 357
      Top = 98
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1057#1077#1088#1090#1080#1092#1110#1082#1072#1090' '#1089#1077#1088#1074#1077#1088#1072'...'
      Enabled = False
      TabOrder = 5
      OnClick = ShowCertButtonClick
    end
    object LoadClientSessionButton: TButton
      Left = 201
      Top = 70
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1074#1072#1085#1090#1072#1078#1080#1090#1080' '#1089#1077#1089#1110#1102'...'
      TabOrder = 2
      OnClick = LoadSessionButtonClick
    end
    object SaveClientSessionButton: TButton
      Left = 357
      Top = 70
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080' '#1089#1077#1089#1110#1102'...'
      TabOrder = 3
      OnClick = SaveSessionButtonClick
    end
    object ClientFileWithSessionEdit: TEdit
      Left = 32
      Top = 43
      Width = 376
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object ChooseClientFileWithSessionButton: TButton
      Left = 414
      Top = 43
      Width = 93
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1088#1072#1090#1080'...'
      TabOrder = 1
      OnClick = ChooseSessionFileButtonClick
    end
    object DataToEncryptEdit: TEdit
      Left = 32
      Top = 145
      Width = 475
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 6
    end
    object EncryptButton: TButton
      Left = 357
      Top = 172
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1096#1080#1092#1088#1091#1074#1072#1090#1080'...'
      Enabled = False
      TabOrder = 8
      OnClick = EncryptButtonClick
    end
    object EncryptSyncButton: TButton
      Left = 201
      Top = 172
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1096#1080#1092#1088#1091#1074#1072#1090#1080'('#1089#1080#1085#1093#1088'.)...'
      Enabled = False
      TabOrder = 7
      OnClick = EncryptSyncButtonClick
    end
    object SessionClientCheckStateButton: TButton
      Left = 201
      Top = 98
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1055#1077#1088#1077#1074#1110#1088#1080#1090#1080' '#1089#1090#1072#1085' '#1089#1077#1089#1110#1111'...'
      TabOrder = 4
      OnClick = SessionCheckStateButtonClick
    end
  end
  object SessionServerPanel: TPanel
    Left = 0
    Top = 318
    Width = 520
    Height = 232
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      520
      232)
    object ServerSessionUnderlineImage: TImage
      Left = 0
      Top = 231
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
      ExplicitTop = 162
    end
    object SessionServerTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 470
      Height = 19
      AutoSize = False
      Caption = #1057#1077#1088#1074#1077#1088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object ServerFileWithSessionLabel: TLabel
      Left = 32
      Top = 26
      Width = 73
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = #1060#1072#1081#1083' '#1079' '#1089#1077#1089#1110#1108#1102':'
    end
    object EncryptedDataLabel: TLabel
      Left = 32
      Top = 128
      Width = 94
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1085#1110' '#1076#1072#1085#1110':'
    end
    object DecryptedDataLabel: TLabel
      Left = 32
      Top = 188
      Width = 99
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = #1056#1086#1079#1096#1080#1092#1088#1086#1074#1072#1085#1110' '#1076#1072#1085#1110':'
    end
    object ShowClientCertButton: TButton
      Left = 357
      Top = 98
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1057#1077#1088#1090#1080#1092#1110#1082#1072#1090' '#1082#1083#1110#1108#1085#1090#1072'...'
      Enabled = False
      TabOrder = 5
      OnClick = ShowCertButtonClick
    end
    object LoadServerButton: TButton
      Left = 201
      Top = 70
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1047#1072#1074#1072#1085#1090#1072#1078#1080#1090#1080' '#1089#1077#1089#1110#1102'...'
      TabOrder = 2
      OnClick = LoadSessionButtonClick
    end
    object SaveServerSessionButton: TButton
      Left = 357
      Top = 70
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080' '#1089#1077#1089#1110#1102'...'
      TabOrder = 3
      OnClick = SaveSessionButtonClick
    end
    object ServerFileWithSessionEdit: TEdit
      Left = 32
      Top = 43
      Width = 376
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object ChooseServerFileWithSessionButton: TButton
      Left = 414
      Top = 43
      Width = 93
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1088#1072#1090#1080'...'
      TabOrder = 1
      OnClick = ChooseSessionFileButtonClick
    end
    object EncryptedDataEdit: TEdit
      Left = 32
      Top = 145
      Width = 475
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 6
    end
    object DecryptButton: TButton
      Left = 357
      Top = 172
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1056#1086#1079#1096#1080#1092#1088#1091#1074#1072#1090#1080'...'
      Enabled = False
      TabOrder = 8
      OnClick = DecryptButtonClick
    end
    object DecryptSyncButton: TButton
      Left = 201
      Top = 172
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1056#1086#1079#1096#1080#1092#1088#1091#1074#1072#1090#1080'('#1089#1080#1085#1093#1088'.)...'
      Enabled = False
      TabOrder = 7
      OnClick = DecryptSyncButtonClick
    end
    object DecryptedDataEdit: TEdit
      Left = 32
      Top = 205
      Width = 475
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 9
    end
    object SessionServerCheckButton: TButton
      Left = 201
      Top = 98
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1055#1077#1088#1077#1074#1110#1088#1080#1090#1080' '#1089#1090#1072#1085' '#1089#1077#1089#1110#1111'...'
      TabOrder = 4
      OnClick = SessionCheckStateButtonClick
    end
  end
  object TestSessionPanel: TPanel
    Left = 0
    Top = 550
    Width = 520
    Height = 59
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      520
      59)
    object TestSessionTitleLabel: TLabel
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
    object TestSessionButton: TButton
      Left = 32
      Top = 31
      Width = 137
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1058#1077#1089#1090' '#1089#1077#1089#1110#1111'...'
      Enabled = False
      TabOrder = 0
      OnClick = SessionTestButtonClick
    end
  end
  object SessionInitPanel: TPanel
    Left = 0
    Top = 56
    Width = 520
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      520
      60)
    object SessionInitUnderlineImage: TImage
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
    object SessionInitTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 470
      Height = 19
      AutoSize = False
      Caption = #1030#1085#1110#1094#1110#1072#1083#1110#1079#1072#1094#1110#1103' '#1089#1077#1089#1110#1111
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object SessionInitButton: TButton
      Left = 32
      Top = 31
      Width = 145
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Caption = #1030#1085#1110#1094#1110#1072#1083#1110#1079#1091#1074#1072#1090#1080' '#1089#1077#1089#1110#1102'...'
      TabOrder = 0
      OnClick = SessionInitButtonClick
    end
    object SessionCheckCertsButton: TButton
      Left = 183
      Top = 31
      Width = 180
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Caption = #1055#1077#1088#1077#1074#1110#1088#1080#1090#1080' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090#1080' '#1089#1077#1089#1110#1111'...'
      Enabled = False
      TabOrder = 1
      OnClick = SessionCheckCertsButtonClick
    end
  end
  object TargetFileOpenDialog: TOpenDialog
    Left = 104
    Top = 134
  end
end
