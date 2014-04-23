object CertAndCRLsFrame: TCertAndCRLsFrame
  Left = 0
  Top = 0
  Width = 520
  Height = 620
  Anchors = [akLeft, akBottom]
  TabOrder = 0
  object ShowCertAndCRLPanel: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 87
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      520
      87)
    object ShowCertAndCRLUnderlineImage: TImage
      Left = 0
      Top = 86
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
    object EncryptFileTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 206
      Height = 13
      Caption = #1055#1077#1088#1077#1075#1083#1103#1076' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090#1110#1074' '#1090#1072' '#1057#1042#1057' '#1074' '#1089#1093#1086#1074#1080#1097#1110
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object ShowCertificatesButton: TButton
      Left = 25
      Top = 59
      Width = 150
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Caption = #1057#1077#1088#1090#1080#1092#1110#1082#1072#1090#1080'...'
      TabOrder = 1
      OnClick = ShowCertificatesButtonClick
    end
    object ShowCRLButton: TButton
      Left = 181
      Top = 59
      Width = 150
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Caption = #1057#1042#1057'...'
      TabOrder = 2
      OnClick = ShowCRLButtonClick
    end
    object UpdateCertStorageButton: TButton
      Left = 25
      Top = 31
      Width = 150
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Caption = #1055#1086#1085#1086#1074#1080#1090#1080' '#1089#1093#1086#1074#1080#1097#1077'...'
      TabOrder = 0
      OnClick = UpdateCertStorageButtonClick
    end
  end
  object CheckCertPanel: TPanel
    Left = 0
    Top = 87
    Width = 520
    Height = 99
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      520
      99)
    object CheckCertUnderlineImage: TImage
      Left = 0
      Top = 98
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
    object CheckCertLabel: TLabel
      Left = 32
      Top = 26
      Width = 110
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = #1060#1072#1081#1083' '#1079' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090#1086#1084':'
    end
    object CheckCertTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 117
      Height = 13
      Caption = #1055#1077#1088#1077#1074#1110#1088#1082#1072' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object CheckCertFileButton: TButton
      Left = 357
      Top = 70
      Width = 150
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1055#1077#1088#1077#1074#1110#1088#1080#1090#1080'...'
      TabOrder = 2
      OnClick = CheckCertFileButtonClick
    end
    object CheckCertFileEdit: TEdit
      Left = 32
      Top = 43
      Width = 376
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object ChooseCheckCertFileButton: TButton
      Left = 414
      Top = 43
      Width = 93
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1088#1072#1090#1080'...'
      TabOrder = 1
      OnClick = ChooseCheckCertFileButtonClick
    end
  end
  object SearchCertPanel: TPanel
    Left = 0
    Top = 186
    Width = 520
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      520
      60)
    object SearchCertUnderlineImage: TImage
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
      Visible = False
      ExplicitTop = 50
      ExplicitWidth = 519
    end
    object SearchCertTitleLabel: TLabel
      Left = 16
      Top = 6
      Width = 98
      Height = 13
      Caption = #1055#1086#1096#1091#1082' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object SearchCertButtonByNBUCode: TButton
      Left = 32
      Top = 31
      Width = 150
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Caption = #1047#1072' '#1082#1086#1076#1086#1084' '#1053#1041#1059'...'
      TabOrder = 0
      OnClick = SearchCertButtonByNBUCodeClick
    end
    object SearchCertButtonByEmail: TButton
      Left = 188
      Top = 31
      Width = 150
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Caption = #1047#1072' '#1087#1086#1096#1090#1086#1074#1086#1102' '#1072#1076#1088#1077#1089#1086#1102'...'
      TabOrder = 1
      OnClick = SearchCertButtonByEmailClick
    end
  end
  object TargetFileOpenDialog: TOpenDialog
    Left = 160
    Top = 118
  end
end
