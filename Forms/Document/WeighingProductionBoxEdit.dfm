object WeighingProductionBoxEditForm: TWeighingProductionBoxEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 310
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 387
    Top = 268
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 553
    Top = 268
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel12: TcxLabel
    Left = 28
    Top = 59
    Caption = '2.'#1058#1072#1088#1072
  end
  object edBox2: TcxButtonEdit
    Left = 28
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 182
  end
  object cxLabel1: TcxLabel
    Left = 28
    Top = 15
    Caption = '1.'#1058#1072#1088#1072
  end
  object edBox1: TcxButtonEdit
    Left = 28
    Top = 34
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 182
  end
  object cxLabel2: TcxLabel
    Left = 28
    Top = 102
    Caption = '3.'#1058#1072#1088#1072
  end
  object edBox3: TcxButtonEdit
    Left = 28
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 182
  end
  object cxLabel3: TcxLabel
    Left = 28
    Top = 145
    Caption = '4.'#1058#1072#1088#1072
  end
  object edBox4: TcxButtonEdit
    Left = 28
    Top = 165
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 182
  end
  object cxLabel4: TcxLabel
    Left = 28
    Top = 189
    Caption = '5.'#1058#1072#1088#1072
  end
  object edBox5: TcxButtonEdit
    Left = 28
    Top = 209
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 182
  end
  object cxLabel5: TcxLabel
    Left = 364
    Top = 59
    Caption = '7.'#1058#1072#1088#1072
  end
  object cxButtonEdit1: TcxButtonEdit
    Left = 364
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 182
  end
  object cxLabel6: TcxLabel
    Left = 364
    Top = 15
    Caption = '6.'#1058#1072#1088#1072
  end
  object cxButtonEdit2: TcxButtonEdit
    Left = 364
    Top = 34
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 182
  end
  object cxLabel7: TcxLabel
    Left = 364
    Top = 145
    Caption = '9.'#1058#1072#1088#1072
  end
  object cxButtonEdit3: TcxButtonEdit
    Left = 364
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 182
  end
  object cxLabel8: TcxLabel
    Left = 364
    Top = 102
    Caption = '8.'#1058#1072#1088#1072
  end
  object cxButtonEdit4: TcxButtonEdit
    Left = 364
    Top = 165
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 182
  end
  object cxLabel9: TcxLabel
    Left = 364
    Top = 190
    Caption = '10.'#1058#1072#1088#1072
  end
  object cxButtonEdit5: TcxButtonEdit
    Left = 364
    Top = 209
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 182
  end
  object cxLabel10: TcxLabel
    Left = 228
    Top = 15
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare1: TcxCurrencyEdit
    Left = 228
    Top = 34
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 23
    Width = 80
  end
  object cxLabel11: TcxLabel
    Left = 228
    Top = 58
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare2: TcxCurrencyEdit
    Left = 228
    Top = 77
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 25
    Width = 80
  end
  object cxLabel13: TcxLabel
    Left = 228
    Top = 102
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare3: TcxCurrencyEdit
    Left = 228
    Top = 119
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 27
    Width = 80
  end
  object cxLabel14: TcxLabel
    Left = 228
    Top = 146
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare4: TcxCurrencyEdit
    Left = 228
    Top = 165
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 29
    Width = 80
  end
  object cxLabel15: TcxLabel
    Left = 228
    Top = 190
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare5: TcxCurrencyEdit
    Left = 228
    Top = 209
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 31
    Width = 80
  end
  object cxLabel16: TcxLabel
    Left = 564
    Top = 15
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare6: TcxCurrencyEdit
    Left = 564
    Top = 34
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 33
    Width = 80
  end
  object cxLabel17: TcxLabel
    Left = 564
    Top = 58
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare7: TcxCurrencyEdit
    Left = 564
    Top = 77
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 35
    Width = 80
  end
  object cxLabel18: TcxLabel
    Left = 564
    Top = 102
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare8: TcxCurrencyEdit
    Left = 564
    Top = 121
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 37
    Width = 80
  end
  object cxLabel19: TcxLabel
    Left = 564
    Top = 146
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare9: TcxCurrencyEdit
    Left = 564
    Top = 165
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 39
    Width = 80
  end
  object cxLabel20: TcxLabel
    Left = 564
    Top = 190
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare10: TcxCurrencyEdit
    Left = 564
    Top = 209
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 41
    Width = 80
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 225
    Top = 266
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 296
    Top = 261
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 151
    Top = 266
  end
  object GuidesBox1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBox1
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 106
    Top = 17
  end
  object ActionList: TActionList
    Left = 360
    Top = 244
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
      Caption = 'dsdFormClose'
    end
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_WeighingProduction_Box'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId_1'
        Value = ''
        Component = GuidesBox1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_1'
        Value = 0.000000000000000000
        Component = GuidesBox1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId_2'
        Value = ''
        Component = GuidesBox2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_2'
        Value = 0.000000000000000000
        Component = GuidesBox2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId_3'
        Value = ''
        Component = GuidesBox3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_3'
        Value = 0.000000000000000000
        Component = GuidesBox3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId_4'
        Value = ''
        Component = GuidesBox4
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_4'
        Value = 0.000000000000000000
        Component = GuidesBox4
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId_5'
        Value = ''
        Component = GuidesBox5
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_5'
        Value = 0.000000000000000000
        Component = GuidesBox5
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId_6'
        Value = ''
        Component = GuidesBox6
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_6'
        Value = 0.000000000000000000
        Component = GuidesBox6
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId_7'
        Value = ''
        Component = GuidesBox7
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_7'
        Value = 0.000000000000000000
        Component = GuidesBox7
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId_8'
        Value = ''
        Component = GuidesBox8
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_8'
        Value = 0.000000000000000000
        Component = GuidesBox8
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId_9'
        Value = ''
        Component = GuidesBox9
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_9'
        Value = 0.000000000000000000
        Component = GuidesBox9
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxId_10'
        Value = ''
        Component = GuidesBox10
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName_10'
        Value = 0.000000000000000000
        Component = GuidesBox10
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare1'
        Value = Null
        Component = edCountTare1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare2'
        Value = Null
        Component = edCountTare2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare3'
        Value = Null
        Component = edCountTare3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare4'
        Value = Null
        Component = edCountTare4
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare5'
        Value = Null
        Component = edCountTare5
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare6'
        Value = Null
        Component = edCountTare6
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare7'
        Value = Null
        Component = edCountTare7
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare8'
        Value = Null
        Component = edCountTare8
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare9'
        Value = Null
        Component = edCountTare9
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountTare10'
        Value = Null
        Component = edCountTare10
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 16
    Top = 264
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_WeighingProduction_Box'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_1'
        Value = 0.000000000000000000
        Component = GuidesBox1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_2'
        Value = 0.000000000000000000
        Component = GuidesBox2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_3'
        Value = 0.000000000000000000
        Component = GuidesBox3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_4'
        Value = 0.000000000000000000
        Component = GuidesBox4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_5'
        Value = 0.000000000000000000
        Component = GuidesBox5
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_6'
        Value = 0.000000000000000000
        Component = GuidesBox6
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_7'
        Value = 0.000000000000000000
        Component = GuidesBox7
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_8'
        Value = 0.000000000000000000
        Component = GuidesBox8
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_9'
        Value = 0.000000000000000000
        Component = GuidesBox9
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxId_10'
        Value = 0.000000000000000000
        Component = GuidesBox1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare1'
        Value = ''
        Component = edCountTare1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare2'
        Value = ''
        Component = edCountTare2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare3'
        Value = ''
        Component = edCountTare3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare4'
        Value = ''
        Component = edCountTare4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare5'
        Value = ''
        Component = edCountTare5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare6'
        Value = ''
        Component = edCountTare6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare7'
        Value = ''
        Component = edCountTare7
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare8'
        Value = ''
        Component = edCountTare8
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare9'
        Value = ''
        Component = edCountTare9
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare10'
        Value = ''
        Component = edCountTare10
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
    Top = 264
  end
  object GuidesBox5: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBox5
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox5
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox5
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 114
    Top = 209
  end
  object GuidesBox2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBox2
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 98
    Top = 73
  end
  object GuidesBox3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBox3
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 66
    Top = 105
  end
  object GuidesBox4: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBox4
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 106
    Top = 153
  end
  object GuidesBox6: TdsdGuides
    KeyField = 'Id'
    LookupControl = cxButtonEdit2
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox6
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox6
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 434
    Top = 9
  end
  object GuidesBox10: TdsdGuides
    KeyField = 'Id'
    LookupControl = cxButtonEdit5
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox10
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox10
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 442
    Top = 201
  end
  object GuidesBox7: TdsdGuides
    KeyField = 'Id'
    LookupControl = cxButtonEdit1
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox7
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox7
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 426
    Top = 65
  end
  object GuidesBox8: TdsdGuides
    KeyField = 'Id'
    LookupControl = cxButtonEdit3
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox8
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox8
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 394
    Top = 97
  end
  object GuidesBox9: TdsdGuides
    KeyField = 'Id'
    LookupControl = cxButtonEdit4
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBoxForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBoxForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBox9
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBox9
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 434
    Top = 145
  end
end
