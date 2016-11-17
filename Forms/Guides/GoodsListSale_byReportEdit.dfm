object GoodsListSale_byReportEditForm: TGoodsListSale_byReportEditForm
  Left = 0
  Top = 0
  Hint = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'>'
  Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080'>'
  ClientHeight = 386
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 98
    Top = 352
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 258
    Top = 352
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 1
  end
  object cxGroupBox1: TcxGroupBox
    Left = 8
    Top = 94
    TabOrder = 9
    Height = 126
    Width = 425
  end
  object edInfoMoneyDestination: TcxButtonEdit
    Left = 146
    Top = 182
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 275
  end
  object cxLabel11: TcxLabel
    Left = 146
    Top = 163
    Caption = #1080#1083#1080' '#1076#1083#1103' '#1090#1086#1074#1072#1088#1086#1074' '#1089' '#1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077':'
  end
  object edInfoMoney: TcxButtonEdit
    Left = 146
    Top = 132
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Text = '(30102) '#1044#1086#1093#1086#1076#1099' '#1055#1088#1086#1076#1091#1082#1094#1080#1103' '#1058#1091#1096#1077#1085#1082#1072
    Width = 275
  end
  object cxLabel5: TcxLabel
    Left = 146
    Top = 110
    Caption = #1076#1083#1103' '#1090#1086#1074#1072#1088#1086#1074' '#1089' '#1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
  end
  object cxLabel3: TcxLabel
    Left = 18
    Top = 110
    Caption = #1055#1077#1088#1080#1086#1076', '#1084#1077#1089#1103#1094#1077#1074':'
  end
  object cxGroupBox2: TcxGroupBox
    Left = 8
    Top = 213
    TabOrder = 12
    Height = 126
    Width = 425
  end
  object cxLabel1: TcxLabel
    Left = 146
    Top = 226
    Caption = #1076#1083#1103' '#1090#1086#1074#1072#1088#1086#1074' '#1089' '#1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
  end
  object edInfoMoney2: TcxButtonEdit
    Left = 146
    Top = 248
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 275
  end
  object cxLabel2: TcxLabel
    Left = 146
    Top = 282
    Caption = #1080#1083#1080' '#1076#1083#1103' '#1090#1086#1074#1072#1088#1086#1074' '#1089' '#1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077':'
  end
  object edInfoMoneyDestination2: TcxButtonEdit
    Left = 146
    Top = 301
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Text = '(30200) '#1052#1103#1089#1085#1086#1077' '#1089#1099#1088#1100#1077
    Width = 275
  end
  object cxGroupBox3: TcxGroupBox
    Left = 8
    Top = 8
    TabOrder = 13
    Height = 70
    Width = 425
  end
  object cePeriod1: TcxCurrencyEdit
    Left = 18
    Top = 133
    EditValue = 12
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 14
    Width = 94
  end
  object cxLabel4: TcxLabel
    Left = 18
    Top = 226
    Caption = #1055#1077#1088#1080#1086#1076', '#1084#1077#1089#1103#1094#1077#1074':'
  end
  object cePeriod2: TcxCurrencyEdit
    Left = 18
    Top = 248
    EditValue = 3
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 16
    Width = 94
  end
  object cxLabel6: TcxLabel
    Left = 18
    Top = 27
    Caption = #1055#1077#1088#1080#1086#1076', '#1084#1077#1089#1103#1094#1077#1074':'
  end
  object cePeriod3: TcxCurrencyEdit
    Left = 18
    Top = 48
    EditValue = 3
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 18
    Width = 94
  end
  object cxLabel7: TcxLabel
    Left = 146
    Top = 49
    Caption = #1076#1083#1103' '#1086#1089#1090#1072#1083#1100#1085#1099#1093' '#1058#1086#1074#1072#1088#1086#1074
  end
  object ActionList: TActionList
    Left = 16
    Top = 158
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1054#1082
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsListSale_byReport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPeriod_1'
        Value = ''
        Component = cePeriod1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod_2'
        Value = 'NULL'
        Component = cePeriod2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod_3'
        Value = 'NULL'
        Component = cePeriod3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId_1'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyDestinationId_1'
        Value = Null
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId_2'
        Value = Null
        Component = GuidesInfoMoney2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyDestinationId_2'
        Value = Null
        Component = GuidesInfoMoneyDestination2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 264
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate1'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate1'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 168
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
      end
      item
        Component = GuidesInfoMoneyDestination
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesInfoMoneyDestination2
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesInfoMoney
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesInfoMoney2
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 40
    Top = 280
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney
    Key = '8963'
    TextValue = '(30102) '#1044#1086#1093#1086#1076#1099' '#1055#1088#1086#1076#1091#1082#1094#1080#1103' '#1058#1091#1096#1077#1085#1082#1072
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '8963'
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = '(30102) '#1044#1086#1093#1086#1076#1099' '#1055#1088#1086#1076#1091#1082#1094#1080#1103' '#1058#1091#1096#1077#1085#1082#1072
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 362
    Top = 128
  end
  object GuidesInfoMoneyDestination: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoneyDestination
    FormNameParam.Value = 'TInfoMoneyDestination_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyDestination_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 163
  end
  object GuidesInfoMoney2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney2
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Juridical'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 322
    Top = 232
  end
  object GuidesInfoMoneyDestination2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoneyDestination2
    Key = '8879'
    TextValue = '(30200) '#1052#1103#1089#1085#1086#1077' '#1089#1099#1088#1100#1077
    FormNameParam.Value = 'TInfoMoneyDestination_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyDestination_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '8879'
        Component = GuidesInfoMoneyDestination2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = '(30200) '#1052#1103#1089#1085#1086#1077' '#1089#1099#1088#1100#1077
        Component = GuidesInfoMoneyDestination2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Juridical'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 283
  end
end
