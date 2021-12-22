object MemberMinusEditForm: TMemberMinusEditForm
  Left = 0
  Top = 0
  Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
  ClientHeight = 570
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 43
    Top = 504
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 43
    Top = 486
    Caption = #1055#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 78
    Top = 537
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 228
    Top = 537
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object cxLabel4: TcxLabel
    Left = 43
    Top = 9
    Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object edFrom: TcxButtonEdit
    Left = 43
    Top = 28
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 296
  end
  object cxLabel3: TcxLabel
    Left = 43
    Top = 266
    Caption = #1057#1091#1084#1084#1072' '#1048#1090#1086#1075#1086
  end
  object cxLabel6: TcxLabel
    Left = 43
    Top = 310
    Caption = #1057#1091#1084#1084#1072' '#1082' '#1091#1076#1077#1088#1078#1072#1085#1080#1102' '#1077#1078#1077#1084#1077#1089#1103#1095#1085#1086
  end
  object cxLabel9: TcxLabel
    Left = 43
    Top = 53
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072' / '#1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1089#1090#1086#1088#1086#1085#1085#1080#1077')'
  end
  object edTo: TcxButtonEdit
    Left = 43
    Top = 71
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 296
  end
  object edBankAccountFrom: TcxButtonEdit
    Left = 43
    Top = 199
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 296
  end
  object cxLabel10: TcxLabel
    Left = 43
    Top = 225
    Caption = 'IBAN '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' '#1087#1083#1072#1090#1077#1078#1072
  end
  object cxLabel11: TcxLabel
    Left = 43
    Top = 354
    Hint = #8470' '#1089#1095#1077#1090#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' '#1087#1083#1072#1090#1077#1078#1072
    Caption = #8470' '#1089#1095#1077#1090#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' '#1087#1083#1072#1090#1077#1078#1072
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel12: TcxLabel
    Left = 43
    Top = 182
    Caption = 'IBAN '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072' '#1087#1083#1072#1090#1077#1078#1072
  end
  object edBankAccountTo: TcxButtonEdit
    Left = 43
    Top = 241
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 296
  end
  object edBankAccountTo_str: TcxTextEdit
    Left = 43
    Top = 372
    TabOrder = 15
    Width = 296
  end
  object cxLabel2: TcxLabel
    Left = 43
    Top = 397
    Hint = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
    Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
    ParentShowHint = False
    ShowHint = True
  end
  object edDetailPayment: TcxTextEdit
    Left = 43
    Top = 415
    TabOrder = 17
    Width = 296
  end
  object edTotalSumm: TcxCurrencyEdit
    Left = 43
    Top = 283
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 18
    Width = 171
  end
  object edSumm: TcxCurrencyEdit
    Left = 43
    Top = 327
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 19
    Width = 171
  end
  object cxLabel5: TcxLabel
    Left = 43
    Top = 137
    Hint = #8470' '#1089#1095#1077#1090#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' '#1087#1083#1072#1090#1077#1078#1072
    Caption = #1054#1050#1055#1054' / '#1048#1053#1053' ('#1087#1086#1083#1091#1095'.)'
    ParentShowHint = False
    ShowHint = True
  end
  object edINN_to: TcxTextEdit
    Left = 43
    Top = 155
    TabOrder = 21
    Width = 296
  end
  object cxLabel7: TcxLabel
    Left = 43
    Top = 93
    Hint = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
    Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1089#1086#1082#1088#1072#1097#1077#1085#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077') '#9
    ParentShowHint = False
    ShowHint = True
  end
  object edToShort: TcxTextEdit
    Left = 43
    Top = 111
    TabOrder = 23
    Width = 296
  end
  object cbisChild: TcxCheckBox
    Left = 226
    Top = 327
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1040#1083#1080#1084#1077#1085#1090#1099' ('#1076#1072'/'#1085#1077#1090')'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 24
    Width = 122
  end
  object edTax: TcxCurrencyEdit
    Left = 228
    Top = 283
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 25
    Width = 111
  end
  object cxLabel8: TcxLabel
    Left = 228
    Top = 266
    Caption = ' '#9'% '#1091#1076#1077#1088#1078#1072#1085#1080#1103
  end
  object cxLabel13: TcxLabel
    Left = 43
    Top = 440
    Hint = #8470' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1075#1086' '#1083#1080#1089#1090#1072
    Caption = #8470' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1075#1086' '#1083#1080#1089#1090#1072
    ParentShowHint = False
    ShowHint = True
  end
  object edNumber: TcxTextEdit
    Left = 43
    Top = 458
    TabOrder = 28
    Width = 296
  end
  object ActionList: TActionList
    Left = 344
    Top = 204
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MemberMinus'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountTo'
        Value = ''
        Component = edBankAccountTo_str
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDetailPayment'
        Value = ''
        Component = edDetailPayment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inINN_to'
        Value = Null
        Component = edINN_to
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToShort'
        Value = Null
        Component = edToShort
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumber'
        Value = Null
        Component = edNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTolId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBankAccountFromId'
        Value = ''
        Component = GuidesBankAccountFrom
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountToId'
        Value = Null
        Component = GuidesBankAccountTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId_Main'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'BankAccountId_Main'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBankAccountFromName'
        Value = Null
        Component = GuidesBankAccountFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSumm'
        Value = Null
        Component = edTotalSumm
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSumm'
        Value = Null
        Component = edSumm
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTax'
        Value = Null
        Component = edTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChild'
        Value = Null
        Component = cbisChild
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 112
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaskId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId_Main'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 160
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MemberMinus'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaskId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'MaskId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToShort'
        Value = Null
        Component = edToShort
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'INN_to'
        Value = Null
        Component = edINN_to
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountFromId'
        Value = ''
        Component = GuidesBankAccountFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountFromName'
        Value = ''
        Component = GuidesBankAccountFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountToId'
        Value = Null
        Component = GuidesBankAccountTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountToName'
        Value = Null
        Component = GuidesBankAccountTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountTo'
        Value = Null
        Component = edBankAccountTo_str
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DetailPayment'
        Value = Null
        Component = edDetailPayment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = ''
        Component = edTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Summ'
        Value = ''
        Component = edSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isChild'
        Value = Null
        Component = cbisChild
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Number'
        Value = Null
        Component = edNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Tax'
        Value = Null
        Component = edTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 20
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 344
    Top = 255
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 344
    Top = 64
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 251
    Top = 15
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TMemberExternal_Juridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberExternal_Juridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'INN'
        Value = Null
        Component = edINN_to
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 267
    Top = 71
  end
  object GuidesBankAccountFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankAccountFrom
    FormNameParam.Value = 'TBankAccount_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccount_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankAccountFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankAccountFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 179
    Top = 197
  end
  object GuidesBankAccountTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankAccountTo
    FormNameParam.Value = 'TBankAccountForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccountForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankAccountTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankAccountTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 115
    Top = 255
  end
end
