object WeighingProductionBoxEditForm: TWeighingProductionBoxEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 403
  ClientWidth = 703
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
  object cxButtonOk: TcxButton
    Left = 380
    Top = 358
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 553
    Top = 358
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel12: TcxLabel
    Left = 28
    Top = 103
    Caption = '2.'#1058#1072#1088#1072
  end
  object edBox2: TcxButtonEdit
    Left = 28
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 170
  end
  object cxLabel1: TcxLabel
    Left = 28
    Top = 59
    Caption = '1.'#1058#1072#1088#1072
  end
  object edBox1: TcxButtonEdit
    Left = 28
    Top = 78
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 170
  end
  object cxLabel2: TcxLabel
    Left = 28
    Top = 146
    Caption = '3.'#1058#1072#1088#1072
  end
  object edBox3: TcxButtonEdit
    Left = 28
    Top = 165
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 170
  end
  object cxLabel3: TcxLabel
    Left = 28
    Top = 190
    Caption = '4.'#1058#1072#1088#1072
  end
  object edBox4: TcxButtonEdit
    Left = 28
    Top = 209
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 170
  end
  object cxLabel4: TcxLabel
    Left = 28
    Top = 234
    Caption = '5.'#1058#1072#1088#1072
  end
  object edBox5: TcxButtonEdit
    Left = 28
    Top = 253
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 170
  end
  object cxLabel5: TcxLabel
    Left = 368
    Top = 103
    Caption = '7.'#1058#1072#1088#1072
  end
  object cxButtonEdit1: TcxButtonEdit
    Left = 368
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 170
  end
  object cxLabel6: TcxLabel
    Left = 368
    Top = 59
    Caption = '6.'#1058#1072#1088#1072
  end
  object cxButtonEdit2: TcxButtonEdit
    Left = 368
    Top = 78
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 170
  end
  object cxLabel7: TcxLabel
    Left = 368
    Top = 190
    Caption = '9.'#1058#1072#1088#1072
  end
  object cxButtonEdit3: TcxButtonEdit
    Left = 368
    Top = 165
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 170
  end
  object cxLabel8: TcxLabel
    Left = 368
    Top = 146
    Caption = '8.'#1058#1072#1088#1072
  end
  object cxButtonEdit4: TcxButtonEdit
    Left = 368
    Top = 209
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 170
  end
  object cxLabel9: TcxLabel
    Left = 368
    Top = 234
    Caption = '10.'#1058#1072#1088#1072
  end
  object cxButtonEdit5: TcxButtonEdit
    Left = 368
    Top = 253
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 170
  end
  object cxLabel10: TcxLabel
    Left = 216
    Top = 59
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare1: TcxCurrencyEdit
    Left = 216
    Top = 78
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 23
    Width = 64
  end
  object cxLabel11: TcxLabel
    Left = 216
    Top = 103
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare2: TcxCurrencyEdit
    Left = 216
    Top = 121
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 25
    Width = 64
  end
  object cxLabel13: TcxLabel
    Left = 216
    Top = 146
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare3: TcxCurrencyEdit
    Left = 216
    Top = 165
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 27
    Width = 64
  end
  object cxLabel14: TcxLabel
    Left = 216
    Top = 190
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare4: TcxCurrencyEdit
    Left = 216
    Top = 209
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 29
    Width = 64
  end
  object cxLabel15: TcxLabel
    Left = 216
    Top = 234
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare5: TcxCurrencyEdit
    Left = 216
    Top = 253
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 31
    Width = 64
  end
  object cxLabel16: TcxLabel
    Left = 555
    Top = 59
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare6: TcxCurrencyEdit
    Left = 555
    Top = 78
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 33
    Width = 64
  end
  object cxLabel17: TcxLabel
    Left = 555
    Top = 103
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare7: TcxCurrencyEdit
    Left = 555
    Top = 121
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 35
    Width = 64
  end
  object cxLabel18: TcxLabel
    Left = 555
    Top = 146
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare8: TcxCurrencyEdit
    Left = 555
    Top = 165
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 37
    Width = 64
  end
  object cxLabel19: TcxLabel
    Left = 555
    Top = 190
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare9: TcxCurrencyEdit
    Left = 555
    Top = 209
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 39
    Width = 64
  end
  object cxLabel20: TcxLabel
    Left = 555
    Top = 234
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edCountTare10: TcxCurrencyEdit
    Left = 555
    Top = 253
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 41
    Width = 64
  end
  object cxLabel21: TcxLabel
    Left = 28
    Top = 7
    Caption = #1058#1086#1074#1072#1088':'
  end
  object edGoods: TcxButtonEdit
    Left = 28
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 43
    Width = 320
  end
  object cxLabel22: TcxLabel
    Left = 364
    Top = 7
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object сеGoodsKind: TcxButtonEdit
    Left = 365
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 45
    Width = 173
  end
  object cxLabel23: TcxLabel
    Left = 555
    Top = 8
    Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080':'
  end
  object dePartionGoodsDate: TcxDateEdit
    Left = 555
    Top = 30
    EditValue = 42005d
    Properties.ReadOnly = True
    Properties.ShowTime = False
    TabOrder = 47
    Width = 126
  end
  object cxLabel24: TcxLabel
    Left = 301
    Top = 54
    Caption = #1042#1077#1089
  end
  object edBoxWeight1_tare: TcxCurrencyEdit
    Left = 300
    Top = 78
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 49
    Width = 49
  end
  object cxLabel25: TcxLabel
    Left = 301
    Top = 103
    Caption = #1042#1077#1089
  end
  object edBoxWeight2_tare: TcxCurrencyEdit
    Left = 300
    Top = 121
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 51
    Width = 49
  end
  object cxLabel26: TcxLabel
    Left = 300
    Top = 146
    Caption = #1042#1077#1089
  end
  object edBoxWeight3_tare: TcxCurrencyEdit
    Left = 300
    Top = 165
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 53
    Width = 49
  end
  object cxLabel27: TcxLabel
    Left = 300
    Top = 190
    Caption = #1042#1077#1089
  end
  object edBoxWeight4_tare: TcxCurrencyEdit
    Left = 300
    Top = 209
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 55
    Width = 49
  end
  object cxLabel28: TcxLabel
    Left = 300
    Top = 234
    Caption = #1042#1077#1089
  end
  object edBoxWeight5_tare: TcxCurrencyEdit
    Left = 299
    Top = 253
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 57
    Width = 49
  end
  object cxLabel29: TcxLabel
    Left = 632
    Top = 59
    Caption = #1042#1077#1089
  end
  object edBoxWeight6_tare: TcxCurrencyEdit
    Left = 632
    Top = 78
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 59
    Width = 49
  end
  object cxLabel30: TcxLabel
    Left = 632
    Top = 103
    Caption = #1042#1077#1089
  end
  object edBoxWeight7_tare: TcxCurrencyEdit
    Left = 632
    Top = 121
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 61
    Width = 49
  end
  object cxLabel31: TcxLabel
    Left = 632
    Top = 146
    Caption = #1042#1077#1089
  end
  object edBoxWeight8_tare: TcxCurrencyEdit
    Left = 632
    Top = 165
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 63
    Width = 49
  end
  object cxLabel32: TcxLabel
    Left = 632
    Top = 190
    Caption = #1042#1077#1089
  end
  object edBoxWeight9_tare: TcxCurrencyEdit
    Left = 632
    Top = 209
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 65
    Width = 49
  end
  object cxLabel33: TcxLabel
    Left = 632
    Top = 234
    Caption = #1042#1077#1089
  end
  object edBoxWeight10_tare: TcxCurrencyEdit
    Left = 632
    Top = 253
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 67
    Width = 49
  end
  object cxLabel34: TcxLabel
    Left = 546
    Top = 294
    Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1090#1072#1088#1099
    Style.TextStyle = [fsBold]
  end
  object edBoxWeightTotal: TcxCurrencyEdit
    Left = 546
    Top = 317
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    Style.Color = clWindow
    TabOrder = 69
    Width = 121
  end
  object cxLabel35: TcxLabel
    Left = 28
    Top = 294
    Caption = #1056#1077#1072#1083#1100#1085#1099#1081' '#1074#1077#1089
    ParentFont = False
    Style.BorderStyle = ebsNone
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.HotTrack = False
    Style.Shadow = False
    Style.TextStyle = [fsBold]
    Style.IsFontAssigned = True
  end
  object edRealWeight: TcxCurrencyEdit
    Left = 28
    Top = 317
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    Style.Color = clWindow
    TabOrder = 71
    Width = 170
  end
  object cxLabel36: TcxLabel
    Left = 368
    Top = 294
    Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1085#1077#1090#1090#1086
    Style.TextStyle = [fsBold]
  end
  object edNettoWeight: TcxCurrencyEdit
    Left = 368
    Top = 317
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    Style.Color = clWindow
    TabOrder = 73
    Width = 170
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 225
    Top = 356
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
    Left = 240
    Top = 295
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindId'
        Value = Null
        Component = GuidesGoodsKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = Null
        Component = GuidesGoodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionGoodsDate'
        Value = Null
        Component = dePartionGoodsDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 151
    Top = 356
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
    Top = 61
  end
  object ActionList: TActionList
    Left = 312
    Top = 280
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
    object actUpdate_Calc_before: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_before
      StoredProcList = <
        item
          StoredProc = spUpdate_before
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
      end
      item
        Name = 'BoxWeight1'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight1'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight2'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight2'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight3'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight3'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight4'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight4'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight5'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight5'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight6'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight6'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight7'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight7'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight8'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight8'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight9'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight9'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight10'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight10'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight1_tare'
        Value = Null
        Component = FormParams
        ComponentItem = 'BoxWeight1_tare'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight2_tare'
        Value = Null
        Component = edBoxWeight2_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight3_tare'
        Value = Null
        Component = edBoxWeight3_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight4_tare'
        Value = Null
        Component = edBoxWeight4_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight5_tare'
        Value = Null
        Component = edBoxWeight5_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight6_tare'
        Value = Null
        Component = edBoxWeight6_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight7_tare'
        Value = Null
        Component = edBoxWeight7_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight8_tare'
        Value = Null
        Component = edBoxWeight8_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight9_tare'
        Value = Null
        Component = edBoxWeight9_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight10_tare'
        Value = Null
        Component = edBoxWeight10_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeightTotal'
        Value = Null
        Component = edBoxWeightTotal
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'NettoWeight'
        Value = Null
        Component = edNettoWeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RealWeight'
        Value = Null
        Component = edRealWeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 16
    Top = 354
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
        Component = GuidesBox10
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
    Top = 354
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
    Top = 253
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
    Top = 117
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
    Top = 149
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
    Top = 197
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
    Top = 53
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
    Top = 245
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
    Top = 109
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
    Top = 141
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
    Top = 189
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 115
    Top = 24
  end
  object GuidesGoodsKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = сеGoodsKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoodsKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 408
    Top = 20
  end
  object EnterMoveNext: TEnterMoveNext
    EnterMoveNextList = <
      item
        Control = edCountTare1
      end
      item
        Control = edCountTare2
      end
      item
        Control = edCountTare3
      end
      item
        Control = edCountTare4
      end
      item
        Control = edCountTare5
      end
      item
        Control = edCountTare6
      end
      item
        Control = edCountTare7
      end
      item
        Control = edCountTare8
      end
      item
        Control = edCountTare9
      end
      item
        Control = edCountTare10
      end
      item
        Control = cxButtonOk
      end>
    Left = 676
    Top = 197
  end
  object spUpdate_before: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_WeighingProduction_BoxCalc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare1'
        Value = Null
        Component = edCountTare1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare2'
        Value = Null
        Component = edCountTare2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare3'
        Value = Null
        Component = edCountTare3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare4'
        Value = Null
        Component = edCountTare4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare5'
        Value = Null
        Component = edCountTare5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare6'
        Value = Null
        Component = edCountTare6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare7'
        Value = Null
        Component = edCountTare7
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare8'
        Value = Null
        Component = edCountTare8
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare9'
        Value = Null
        Component = edCountTare9
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountTare10'
        Value = Null
        Component = edCountTare10
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight1'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'BoxWeight1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight2'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'BoxWeight2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight3'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'BoxWeight3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight4'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'BoxWeight4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight5'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'BoxWeight5'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight6'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'BoxWeight6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight7'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'BoxWeight7'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight8'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'BoxWeight8'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight9'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'BoxWeight9'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight10'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'BoxWeight10'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRealWeight'
        Value = 0.000000000000000000
        Component = edRealWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outNettoWeight'
        Value = Null
        Component = edNettoWeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeightTotal'
        Value = Null
        Component = edBoxWeightTotal
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeight1_tare'
        Value = Null
        Component = edBoxWeight1_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeight2_tare'
        Value = Null
        Component = edBoxWeight2_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeight3_tare'
        Value = Null
        Component = edBoxWeight3_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeight4_tare'
        Value = Null
        Component = edBoxWeight4_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeight5_tare'
        Value = Null
        Component = edBoxWeight5_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeight6_tare'
        Value = Null
        Component = edBoxWeight6_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeight7_tare'
        Value = Null
        Component = edBoxWeight7_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeight8_tare'
        Value = Null
        Component = edBoxWeight8_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeight9_tare'
        Value = Null
        Component = edBoxWeight9_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBoxWeight10_tare'
        Value = Null
        Component = edBoxWeight10_tare
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 674
    Top = 272
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = edCountTare1
      end
      item
        Control = edCountTare2
      end
      item
        Control = edCountTare3
      end
      item
        Control = edCountTare4
      end
      item
        Control = edCountTare5
      end
      item
        Control = edCountTare6
      end
      item
        Control = edCountTare7
      end
      item
        Control = edCountTare8
      end
      item
        Control = edCountTare9
      end
      item
        Control = edCountTare10
      end>
    Action = actUpdate_Calc_before
    Left = 676
    Top = 332
  end
end
