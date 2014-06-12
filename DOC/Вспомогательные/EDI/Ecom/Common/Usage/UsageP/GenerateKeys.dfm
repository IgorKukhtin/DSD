object GenerateKeysForm: TGenerateKeysForm
  Left = 0
  Top = 20
  BorderStyle = bsDialog
  Caption = #1043#1077#1085#1077#1088#1072#1094#1110#1103' '#1082#1083#1102#1095#1110#1074
  ClientHeight = 341
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FinalPanel: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 341
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object FinalTopLabel: TLabel
      Left = 24
      Top = 16
      Width = 288
      Height = 24
      Caption = #1043#1077#1085#1077#1088#1072#1094#1110#1102' '#1082#1083#1102#1095#1110#1074' '#1079#1072#1074#1077#1088#1096#1077#1085#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4793100
      Font.Height = -19
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object FinalHeaderImage: TImage
      Left = 24
      Top = 53
      Width = 289
      Height = 1
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
    object FinalNavigatorPanel: TPanel
      Left = 0
      Top = 296
      Width = 467
      Height = 45
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        467
        45)
      object FinalNavigatorBottomImage: TImage
        Left = 0
        Top = 0
        Width = 467
        Height = 1
        Align = alTop
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
      object FinalNavigatorNextButton: TButton
        Left = 380
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight, akBottom]
        Cancel = True
        Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1080
        Default = True
        TabOrder = 0
        OnClick = FinalNavigatorNextButtonClick
      end
    end
  end
  object Page1InternationalPanel: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 341
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      467
      341)
    object Page1InternationalTopLabel: TLabel
      Left = 24
      Top = 16
      Width = 169
      Height = 24
      Caption = #1043#1077#1085#1077#1088#1072#1094#1110#1103' '#1082#1083#1102#1095#1110#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4793100
      Font.Height = -19
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CAPTypeInternationalLabel: TLabel
      Left = 24
      Top = 53
      Width = 244
      Height = 13
      Caption = #1058#1080#1087' '#1082#1088#1080#1087#1090#1086#1075#1088#1072#1092#1110#1095#1085#1080#1093' '#1072#1083#1075#1086#1088#1080#1090#1084#1110#1074' '#1090#1072' '#1087#1088#1086#1090#1086#1082#1086#1083#1110#1074':'
    end
    object InternationalKeysSLabel: TLabel
      Left = 24
      Top = 100
      Width = 34
      Height = 13
      Caption = #1050#1083#1102#1095#1110':'
    end
    object InternationalCAPFilesLabel: TLabel
      Left = 24
      Top = 147
      Width = 339
      Height = 13
      Caption = #1052#1110#1089#1094#1077' '#1088#1086#1079#1084#1110#1097#1077#1085#1085#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1110#1074' ('#1082#1072#1090#1072#1083#1086#1075', '#1079#39#1108#1084#1085#1080#1081' '#1095#1080' '#1086#1087#1090#1080#1095#1085#1080#1081' '#1076#1080#1089#1082'):'
    end
    object Page1InternationalHeaderImage: TImage
      Left = 24
      Top = 204
      Width = 430
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
    object Page1InternationalNavigatorPanel: TPanel
      Left = 0
      Top = 296
      Width = 467
      Height = 45
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        467
        45)
      object Page1InternationalNavigatorBottomImage: TImage
        Left = 0
        Top = 0
        Width = 467
        Height = 1
        Align = alTop
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
      object Page1InternationalNextButton: TButton
        Left = 292
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #1044#1072#1083#1110' >'
        Default = True
        TabOrder = 0
        OnClick = Page1InternationalNextButtonClick
      end
      object Page1InternationalCancelButton: TButton
        Left = 380
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = #1042#1110#1076#1084#1110#1085#1072
        TabOrder = 1
        OnClick = Page1CancelButtonClick
      end
      object Page1InternationalBackButton: TButton
        Left = 212
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '< '#1053#1072#1079#1072#1076
        TabOrder = 2
        OnClick = Page1InternationalBackButtonClick
      end
    end
    object CAPTypeInternationalComboBox: TComboBox
      Left = 24
      Top = 69
      Width = 351
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      Color = clWhite
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'RSA')
    end
    object InternationalKeysSComboBox: TComboBox
      Left = 24
      Top = 116
      Width = 201
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        #1084#1110#1085#1110#1084#1072#1083#1100#1085#1072' (1024 '#1073#1110#1090#1072' '#1079' SHA-1)'
        #1073#1072#1079#1086#1074#1072' (2048 '#1073#1110#1090' '#1079' SHA-256)'
        #1074#1077#1083#1080#1082#1072' (3072 '#1073#1110#1090#1072' '#1079' SHA-256)'
        #1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072' (4096 '#1073#1110#1090' '#1079' SHA-256)'
        #1079' '#1092#1072#1081#1083#1091' '#1087#1072#1088#1072#1084#1077#1090#1088#1110#1074)
    end
    object InternationalCAPFilesComboBox: TComboBox
      Left = 24
      Top = 163
      Width = 353
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 0
      TabOrder = 3
    end
    object InternationalCAPFilesButton: TButton
      Left = 381
      Top = 162
      Width = 75
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1047#1084#1110#1085#1080#1090#1080
      TabOrder = 4
      OnClick = InternationalCAPFilesButtonClick
    end
  end
  object Page1KeyTypePanel: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 341
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Page1KeyTypeTopLabel: TLabel
      Left = 24
      Top = 16
      Width = 169
      Height = 24
      Caption = #1043#1077#1085#1077#1088#1072#1094#1110#1103' '#1082#1083#1102#1095#1110#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4793100
      Font.Height = -19
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object KeyTypeRadioGroup: TRadioGroup
      Left = 24
      Top = 52
      Width = 431
      Height = 105
      Caption = #1043#1077#1085#1077#1088#1091#1074#1072#1090#1080' '#1082#1083#1102#1095#1110
      ItemIndex = 0
      Items.Strings = (
        #1076#1083#1103' '#1076#1077#1088#1078#1072#1074#1085#1080#1093' '#1072#1083#1075#1086#1088#1080#1090#1084#1110#1074' '#1110' '#1087#1088#1086#1090#1086#1082#1086#1083#1110#1074
        #1076#1083#1103' '#1084#1110#1078#1085#1072#1088#1086#1076#1085#1080#1093' '#1072#1083#1075#1086#1088#1080#1090#1084#1110#1074' '#1110' '#1087#1088#1086#1090#1086#1082#1086#1083#1110#1074
        #1076#1083#1103' '#1076#1077#1088#1078#1072#1074#1085#1080#1093' '#1090#1072' '#1084#1110#1078#1085#1072#1088#1086#1076#1085#1080#1093' '#1072#1083#1075#1086#1088#1080#1090#1084#1110#1074' '#1110' '#1087#1088#1086#1090#1086#1082#1086#1083#1110#1074)
      TabOrder = 0
    end
    object Page1KeyTypeNavigatorPanel: TPanel
      Left = 0
      Top = 296
      Width = 467
      Height = 45
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      DesignSize = (
        467
        45)
      object Page1KeyTypeNavigatorBottomImage: TImage
        Left = 0
        Top = 0
        Width = 467
        Height = 1
        Align = alTop
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
      object Page1KeyTypeNextButton: TButton
        Left = 292
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #1044#1072#1083#1110' >'
        Default = True
        TabOrder = 0
        OnClick = Page1KeyTypeNextButtonClick
      end
      object Page1KeyTypeCancelButton: TButton
        Left = 380
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = #1042#1110#1076#1084#1110#1085#1072
        TabOrder = 1
        OnClick = Page1CancelButtonClick
      end
    end
    object SavePKCheckBox: TCheckBox
      Left = 24
      Top = 168
      Width = 217
      Height = 17
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080' '#1086#1089#1086#1073#1080#1089#1090#1080#1081' '#1082#1083#1102#1095' '#1076#1086' '#1092#1072#1081#1083#1091
      TabOrder = 2
      OnClick = SavePKCheckBoxClick
    end
    object PKPanel: TPanel
      Left = 0
      Top = 194
      Width = 467
      Height = 96
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 3
      Visible = False
      DesignSize = (
        467
        96)
      object PKLabel: TLabel
        Left = 24
        Top = 0
        Width = 239
        Height = 13
        Caption = #1030#1084#39#1103' '#1092#1072#1081#1083#1072' '#1076#1083#1103' '#1079#1073#1077#1088#1077#1078#1077#1085#1085#1103' '#1086#1089#1086#1073#1080#1089#1090#1086#1075#1086' '#1082#1083#1102#1095#1072':'
      end
      object PKPasswordLabel: TLabel
        Left = 23
        Top = 46
        Width = 198
        Height = 13
        Caption = #1055#1072#1088#1086#1083#1100' '#1076#1086#1089#1090#1091#1087#1091' '#1076#1086' '#1086#1089#1086#1073#1080#1089#1090#1086#1075#1086' '#1082#1083#1102#1095#1072':'
      end
      object PKEdit: TEdit
        Left = 24
        Top = 19
        Width = 351
        Height = 21
        TabOrder = 0
        Text = 'Key-6.dat'
      end
      object PKButton: TButton
        Left = 381
        Top = 19
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #1047#1084#1110#1085#1080#1090#1080
        TabOrder = 1
        OnClick = PKButtonClick
      end
      object PKPasswordEdit: TEdit
        Left = 23
        Top = 65
        Width = 351
        Height = 21
        PasswordChar = '*'
        TabOrder = 2
      end
    end
  end
  object Page1Panel: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 341
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 4
    DesignSize = (
      467
      341)
    object CAPTypeLabel: TLabel
      Left = 24
      Top = 53
      Width = 244
      Height = 13
      Caption = #1058#1080#1087' '#1082#1088#1080#1087#1090#1086#1075#1088#1072#1092#1110#1095#1085#1080#1093' '#1072#1083#1075#1086#1088#1080#1090#1084#1110#1074' '#1090#1072' '#1087#1088#1086#1090#1086#1082#1086#1083#1110#1074':'
    end
    object CAPFilesLabel: TLabel
      Left = 24
      Top = 172
      Width = 339
      Height = 13
      Caption = #1052#1110#1089#1094#1077' '#1088#1086#1079#1084#1110#1097#1077#1085#1085#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1110#1074' ('#1082#1072#1090#1072#1083#1086#1075', '#1079#39#1108#1084#1085#1080#1081' '#1095#1080' '#1086#1087#1090#1080#1095#1085#1080#1081' '#1076#1080#1089#1082'):'
    end
    object Page1TopLabel: TLabel
      Left = 24
      Top = 16
      Width = 169
      Height = 24
      Caption = #1043#1077#1085#1077#1088#1072#1094#1110#1103' '#1082#1083#1102#1095#1110#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4793100
      Font.Height = -19
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DSKeysSLabel: TLabel
      Left = 24
      Top = 125
      Width = 58
      Height = 13
      Caption = #1050#1083#1102#1095#1110' '#1045#1062#1055':'
    end
    object KEPKeysSLabel: TLabel
      Left = 180
      Top = 125
      Width = 144
      Height = 13
      Caption = #1050#1083#1102#1095#1110' '#1087#1088#1086#1090#1086#1082#1086#1083#1091' '#1088#1086#1079#1087#1086#1076#1110#1083#1091':'
    end
    object Page1HeaderImage: TImage
      Left = 24
      Top = 227
      Width = 430
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
    object Page1NavigatorPanel: TPanel
      Left = 0
      Top = 296
      Width = 467
      Height = 45
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 6
      DesignSize = (
        467
        45)
      object Page1NavigatorBottomImage: TImage
        Left = 0
        Top = 0
        Width = 467
        Height = 1
        Align = alTop
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
      object Page1NextButton: TButton
        Left = 292
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #1044#1072#1083#1110' >'
        Default = True
        TabOrder = 0
        OnClick = Page1NextButtonClick
      end
      object Page1CancelButton: TButton
        Left = 380
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = #1042#1110#1076#1084#1110#1085#1072
        TabOrder = 1
        OnClick = Page1CancelButtonClick
      end
      object Page1BackButton: TButton
        Left = 212
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '< '#1053#1072#1079#1072#1076
        TabOrder = 2
        OnClick = Page1BackButtonClick
      end
    end
    object CAPTypeComboBox: TComboBox
      Left = 24
      Top = 69
      Width = 351
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      Color = clWhite
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        #1044#1057#1058#1059' 4145-2002 '#1090#1072' '#1044#1080#1092#1092#1110'-'#1043#1077#1083#1084#1072#1085' '#1074' '#1075#1088'. '#1090#1086#1095#1086#1082' '#1045#1050)
    end
    object CAPFilesComboBox: TComboBox
      Left = 24
      Top = 188
      Width = 353
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 0
      TabOrder = 4
    end
    object CAPFilesButton: TButton
      Left = 381
      Top = 187
      Width = 75
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1047#1084#1110#1085#1080#1090#1080
      TabOrder = 5
      OnClick = CAPFilesButtonClick
    end
    object DSKeysSComboBox: TComboBox
      Left = 24
      Top = 141
      Width = 149
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        #1084#1110#1085#1110#1084#1072#1083#1100#1085#1072' (191 '#1073#1110#1090')'
        #1073#1072#1079#1086#1074#1072' (257 '#1073#1110#1090')'
        #1074#1077#1083#1080#1082#1072' (307 '#1073#1110#1090')'
        #1079' '#1092#1072#1081#1083#1091' '#1087#1072#1088#1072#1084#1077#1090#1088#1110#1074)
    end
    object KEPKeysSComboBox: TComboBox
      Left = 180
      Top = 141
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        #1073#1072#1079#1086#1074#1072' (257 '#1073#1110#1090')'
        #1074#1077#1083#1080#1082#1072' (431 '#1073#1110#1090')'
        #1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072' (571 '#1073#1110#1090')'
        #1079' '#1092#1072#1081#1083#1091' '#1087#1072#1088#1072#1084#1077#1090#1088#1110#1074)
    end
    object UseKEPCRCheckBox: TCheckBox
      Left = 24
      Top = 100
      Width = 325
      Height = 17
      Caption = #1042#1080#1082#1086#1088#1080#1089#1090#1086#1074#1091#1074#1072#1090#1080' '#1086#1082#1088#1077#1084#1080#1081' '#1082#1083#1102#1095' '#1076#1083#1103' '#1087#1088#1086#1090#1086#1082#1086#1083#1091' '#1088#1086#1079#1087#1086#1076#1110#1083#1091
      TabOrder = 1
      OnClick = UseKEPCRCheckBoxClick
    end
  end
  object Page3Panel: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 341
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 3
    object Page3NavigatorPanel: TPanel
      Left = 0
      Top = 296
      Width = 467
      Height = 45
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        467
        45)
      object Page3NavigatorBottomImage: TImage
        Left = 0
        Top = 0
        Width = 467
        Height = 1
        Align = alTop
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
      object Page3NextButton: TButton
        Left = 292
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #1044#1072#1083#1110' >'
        Default = True
        TabOrder = 0
        OnClick = Page3NextButtonClick
      end
      object Page3CancelButton: TButton
        Left = 380
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = #1042#1110#1076#1084#1110#1085#1072
        TabOrder = 1
        OnClick = Page1CancelButtonClick
      end
      object Page3BackButton: TButton
        Left = 212
        Top = 12
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '< '#1053#1072#1079#1072#1076
        TabOrder = 2
        OnClick = Page3BackButtonClick
      end
    end
    object Page3HeaderPanel: TPanel
      Left = 0
      Top = 0
      Width = 467
      Height = 53
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object Page3TopLabel: TLabel
        Left = 24
        Top = 16
        Width = 364
        Height = 24
        AutoSize = False
        Caption = #1047#1072#1087#1080#1090#1080' '#1085#1072' '#1092#1086#1088#1084#1091#1074#1072#1085#1085#1103' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090#1110#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 4793100
        Font.Height = -19
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
    end
    object DSCRPanel: TPanel
      Left = 0
      Top = 53
      Width = 467
      Height = 54
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        467
        54)
      object CRFileLabel: TLabel
        Left = 24
        Top = 0
        Width = 276
        Height = 13
        Caption = #1030#1084#39#1103' '#1092#1072#1081#1083#1091' '#1076#1083#1103' '#1079#1072#1087#1080#1089#1091' '#1079#1072#1087#1080#1090#1091' '#1079' '#1074#1110#1076#1082#1080#1090#1080#1084' '#1082#1083#1102#1095#1077#1084' '#1045#1062#1055':'
      end
      object CRFileEdit: TEdit
        Left = 24
        Top = 16
        Width = 350
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Color = clWhite
        MaxLength = 1023
        TabOrder = 0
      end
      object CRFileChangeButton: TButton
        Left = 380
        Top = 15
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #1047#1084#1110#1085#1080#1090#1080
        TabOrder = 1
        OnClick = CRFileChangeButtonClick
      end
    end
    object KEPCRPanel: TPanel
      Left = 0
      Top = 107
      Width = 467
      Height = 54
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      DesignSize = (
        467
        54)
      object KEPCRFileLabel: TLabel
        Left = 24
        Top = 0
        Width = 368
        Height = 13
        Caption = 
          #1030#1084#39#1103' '#1092#1072#1081#1083#1091' '#1076#1083#1103' '#1079#1072#1087#1080#1089#1091' '#1079#1072#1087#1080#1090#1091' '#1079' '#1074#1110#1076#1082#1088#1080#1090#1080#1084' '#1082#1083#1102#1095#1077#1084' '#1087#1088#1086#1090#1086#1082#1086#1083#1091' '#1088#1086#1079#1087#1086#1076 +
          #1110#1083#1091':'
      end
      object KEPCRFileEdit: TEdit
        Left = 24
        Top = 16
        Width = 350
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Color = clWhite
        MaxLength = 1023
        TabOrder = 0
      end
      object KEPCRFileChangeButton: TButton
        Left = 380
        Top = 15
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #1047#1084#1110#1085#1080#1090#1080
        TabOrder = 1
        OnClick = KEPCRFileChangeButtonClick
      end
    end
    object Page3SplitPanel: TPanel
      Left = 0
      Top = 215
      Width = 467
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
      DesignSize = (
        467
        16)
      object Page3HeaderImage: TImage
        Left = 24
        Top = 0
        Width = 430
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
    end
    object InternationalCRPanel: TPanel
      Left = 0
      Top = 161
      Width = 467
      Height = 54
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
      DesignSize = (
        467
        54)
      object InternationalCRFileLabel: TLabel
        Left = 24
        Top = 0
        Width = 281
        Height = 13
        Caption = #1030#1084#39#1103' '#1092#1072#1081#1083#1091' '#1076#1083#1103' '#1079#1072#1087#1080#1089#1091' '#1079#1072#1087#1080#1090#1091' '#1079' '#1074#1110#1076#1082#1088#1080#1090#1080#1084' '#1082#1083#1102#1095#1077#1084' RSA:'
      end
      object InternationalCRFileEdit: TEdit
        Left = 24
        Top = 16
        Width = 350
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Color = clWhite
        MaxLength = 1023
        TabOrder = 0
      end
      object InternationalCRFileChangeButton: TButton
        Left = 380
        Top = 15
        Width = 75
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #1047#1084#1110#1085#1080#1090#1080
        TabOrder = 1
        OnClick = InternationalCRFileChangeButtonClick
      end
    end
  end
  object CRSaveDialog: TSaveDialog
    DefaultExt = 'p10'
    Filter = #1060#1072#1081#1083#1080' '#1079' '#1079#1072#1087#1080#1090#1072#1084#1080' '#1085#1072' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090' (*.p10)|*.p10'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = #1047#1073#1077#1088#1077#1078#1077#1085#1085#1103' '#1079#1072#1087#1080#1090#1091' '#1085#1072' '#1092#1086#1088#1084#1091#1074#1072#1085#1085#1103' '#1089#1077#1088#1090#1080#1092#1110#1082#1072#1090#1072
    Left = 256
    Top = 8
  end
end
