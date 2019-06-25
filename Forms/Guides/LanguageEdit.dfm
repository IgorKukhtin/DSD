object LanguageEditForm: TLanguageEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1071#1079#1099#1082'>'
  ClientHeight = 596
  ClientWidth = 453
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
  object cxGroupBox1: TcxGroupBox
    Left = 20
    Top = 101
    Caption = #1055#1077#1088#1077#1074#1086#1076' :'
    TabOrder = 18
    Height = 444
    Width = 409
  end
  object edName: TcxTextEdit
    Left = 134
    Top = 26
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 134
    Top = 5
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 88
    Top = 563
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 232
    Top = 563
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object Код: TcxLabel
    Left = 40
    Top = 5
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 81
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 54
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 40
    Top = 74
    TabOrder = 4
    Width = 367
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 133
    Caption = #1057#1082#1083#1072#1076
  end
  object edValue1: TcxTextEdit
    Left = 40
    Top = 155
    TabOrder = 5
    Width = 174
  end
  object cxLabel4: TcxLabel
    Left = 226
    Top = 133
    Caption = #1059#1084#1086#1074#1080' '#1090#1072' '#1090#1077#1088#1084#1110#1085' '#1079#1073#1077#1088#1110#1075#1072#1085#1085#1103
  end
  object edValue2: TcxTextEdit
    Left = 226
    Top = 155
    TabOrder = 6
    Width = 181
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 181
    Caption = #1079#1072' '#1074#1110#1076#1085#1086#1089#1085#1086#1111' '#1074#1086#1083#1086#1075#1086#1089#1090#1110' '#1087#1086#1074#1110#1090#1088#1103' '#1074#1110#1076
  end
  object edValue3: TcxTextEdit
    Left = 40
    Top = 202
    TabOrder = 7
    Width = 174
  end
  object cxLabel6: TcxLabel
    Left = 232
    Top = 181
    Caption = #1076#1086
  end
  object edValue4: TcxTextEdit
    Left = 226
    Top = 202
    TabOrder = 8
    Width = 181
  end
  object cxLabel7: TcxLabel
    Left = 232
    Top = 232
    Caption = #1076#1086
  end
  object edValue6: TcxTextEdit
    Left = 226
    Top = 253
    TabOrder = 9
    Width = 181
  end
  object cxLabel8: TcxLabel
    Left = 40
    Top = 232
    Caption = #1079#1072' '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1080' '#1074#1110#1076
  end
  object edValue5: TcxTextEdit
    Left = 40
    Top = 253
    TabOrder = 20
    Width = 174
  end
  object cxLabel9: TcxLabel
    Left = 40
    Top = 280
    Caption = #1085#1077' '#1073#1110#1083#1100#1096' '#1085#1110#1078
  end
  object edValue7: TcxTextEdit
    Left = 40
    Top = 300
    TabOrder = 22
    Width = 174
  end
  object cxLabel10: TcxLabel
    Left = 40
    Top = 323
    Caption = #1055#1086#1078#1080#1074#1085#1072' '#1094#1110#1085#1085#1110#1089#1090#1100' '#1090#1072' '#1082#1072#1083#1086#1088#1110#1081#1085#1110#1089#1090#1100' '#1042' 100'#1075#1088'.'#1087#1088#1086#1076#1091#1082#1090#1072
  end
  object edValue8: TcxTextEdit
    Left = 40
    Top = 342
    TabOrder = 24
    Width = 367
  end
  object cxLabel11: TcxLabel
    Left = 40
    Top = 410
    Caption = #1073#1110#1083#1082#1080' '#1085#1077' '#1084#1077#1085#1096#1077
  end
  object edValue9: TcxTextEdit
    Left = 40
    Top = 428
    TabOrder = 26
    Width = 174
  end
  object cxLabel12: TcxLabel
    Left = 226
    Top = 410
    Caption = #1075#1088
  end
  object edValue10: TcxTextEdit
    Left = 226
    Top = 428
    TabOrder = 28
    Width = 181
  end
  object cxLabel13: TcxLabel
    Left = 40
    Top = 455
    Caption = #1078#1080#1088#1080' '#1085#1077' '#1073#1110#1083#1100#1096#1077
  end
  object edValue11: TcxTextEdit
    Left = 40
    Top = 473
    TabOrder = 30
    Width = 174
  end
  object cxLabel14: TcxLabel
    Left = 226
    Top = 455
    Caption = #1075#1088
  end
  object edValue12: TcxTextEdit
    Left = 226
    Top = 473
    TabOrder = 32
    Width = 181
  end
  object edValue13: TcxTextEdit
    Left = 40
    Top = 515
    TabOrder = 33
    Width = 174
  end
  object cxLabel15: TcxLabel
    Left = 40
    Top = 497
    Caption = #1082#1050#1072#1083
  end
  object cxLabel16: TcxLabel
    Left = 226
    Top = 282
    Caption = #1076#1110#1073
  end
  object edValue14: TcxTextEdit
    Left = 226
    Top = 300
    TabOrder = 36
    Width = 181
  end
  object cxLabel17: TcxLabel
    Left = 40
    Top = 369
    Caption = #1074#1091#1075#1083#1077#1074#1086#1076#1080' '#1085#1077' '#1073#1110#1083#1100#1096#1077
  end
  object edValue15: TcxTextEdit
    Left = 40
    Top = 387
    TabOrder = 38
    Width = 181
  end
  object cxLabel18: TcxLabel
    Left = 226
    Top = 369
    Caption = #1075#1088
  end
  object edValue16: TcxTextEdit
    Left = 226
    Top = 387
    TabOrder = 40
    Width = 181
  end
  object cxLabel19: TcxLabel
    Left = 226
    Top = 497
    Caption = #1082#1044#1078
  end
  object edValue17: TcxTextEdit
    Left = 226
    Top = 515
    TabOrder = 42
    Width = 181
  end
  object ActionList: TActionList
    Left = 336
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
    StoredProcName = 'gpInsertUpdate_Object_Language'
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
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
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
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue1'
        Value = Null
        Component = edValue1
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = Null
        Component = edValue2
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = Null
        Component = edValue3
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = edValue4
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue5'
        Value = Null
        Component = edValue5
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue6'
        Value = Null
        Component = edValue6
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue7'
        Value = Null
        Component = edValue7
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue8'
        Value = Null
        Component = edValue8
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue9'
        Value = Null
        Component = edValue9
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue10'
        Value = Null
        Component = edValue10
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue11'
        Value = Null
        Component = edValue11
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue12'
        Value = Null
        Component = edValue12
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue13'
        Value = Null
        Component = edValue13
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue14'
        Value = Null
        Component = edValue14
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue15'
        Value = Null
        Component = edValue15
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue16'
        Value = Null
        Component = edValue16
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue17'
        Value = Null
        Component = edValue17
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 168
    Top = 40
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Language'
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
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
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
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value1'
        Value = Null
        Component = edValue1
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value2'
        Value = Null
        Component = edValue2
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value3'
        Value = Null
        Component = edValue3
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value4'
        Value = Null
        Component = edValue4
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value5'
        Value = Null
        Component = edValue5
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value1'
        Value = Null
        Component = edValue1
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value6'
        Value = Null
        Component = edValue6
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value7'
        Value = Null
        Component = edValue7
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value8'
        Value = Null
        Component = edValue8
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value9'
        Value = Null
        Component = edValue9
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value10'
        Value = Null
        Component = edValue10
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value11'
        Value = Null
        Component = edValue11
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value12'
        Value = Null
        Component = edValue12
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value13'
        Value = Null
        Component = edValue13
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value14'
        Value = Null
        Component = edValue14
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value15'
        Value = Null
        Component = edValue15
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value16'
        Value = Null
        Component = edValue16
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value17'
        Value = Null
        Component = edValue17
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 464
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 360
    Top = 464
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
    Left = 424
    Top = 40
  end
end
