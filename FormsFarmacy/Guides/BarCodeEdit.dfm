object BarCodeEditForm: TBarCodeEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' '#1064#1090#1088#1080#1093'-'#1082#1086#1076' '#1090#1086#1074#1072#1088#1072
  ClientHeight = 396
  ClientWidth = 386
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
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 316
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 51
    Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076
  end
  object cxButton1: TcxButton
    Left = 87
    Top = 357
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 221
    Top = 357
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
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
    TabOrder = 5
    Width = 90
  end
  object ceGoods: TcxButtonEdit
    Left = 40
    Top = 120
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 316
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 100
    Caption = #1058#1086#1074#1072#1088
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 152
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1055#1088#1086#1077#1082#1090#1072
  end
  object ceDiscountExternal: TcxButtonEdit
    Left = 40
    Top = 173
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 316
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 201
    Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1094#1077#1085#1072
  end
  object ceMaxPrice: TcxCurrencyEdit
    Left = 266
    Top = 200
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 11
    Width = 90
  end
  object ceDiscountProcent: TcxCurrencyEdit
    Left = 266
    Top = 227
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 12
    Width = 90
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 228
    Caption = #1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080' '#1087#1086' '#1076#1080#1089#1082#1086#1085#1090#1085#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  end
  object cbDiscountSite: TcxCheckBox
    Left = 40
    Top = 299
    Hint = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1094#1077#1085#1091' '#1085#1072' '#1089#1072#1081#1090#1077
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1094#1077#1085#1091' '#1085#1072' '#1089#1072#1081#1090#1077
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    Width = 182
  end
  object ceDiscountWithVAT: TcxCurrencyEdit
    Left = 266
    Top = 251
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 15
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 252
    Caption = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1089' '#1053#1044#1057
  end
  object ceDiscountWithoutVAT: TcxCurrencyEdit
    Left = 266
    Top = 275
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 17
    Width = 90
  end
  object cxLabel7: TcxLabel
    Left = 40
    Top = 276
    Caption = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1073#1077#1079' '#1053#1044#1057
  end
  object cbStealthBonuses: TcxCheckBox
    Left = 40
    Top = 320
    Hint = #1057#1090#1077#1083#1089' '#1076#1083#1103' '#1073#1086#1085#1091#1089#1086#1074' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
    Caption = #1057#1090#1077#1083#1089' '#1076#1083#1103' '#1073#1086#1085#1091#1089#1086#1074' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
    ParentShowHint = False
    ShowHint = True
    TabOrder = 19
    Width = 281
  end
  object ActionList: TActionList
    Left = 272
    Top = 20
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
    StoredProcName = 'gpInsertUpdate_Object_BarCode'
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
        Name = 'inBarCodeName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = GuidesDiscountExternal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaxPrice'
        Value = Null
        Component = ceMaxPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountProcent'
        Value = Null
        Component = ceDiscountProcent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountWithVAT'
        Value = Null
        Component = ceDiscountWithVAT
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountWithoutVAT'
        Value = Null
        Component = ceDiscountWithoutVAT
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscountSite'
        Value = Null
        Component = cbDiscountSite
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisStealthBonuses'
        Value = Null
        Component = cbStealthBonuses
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 120
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 72
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_BarCode'
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
        Name = 'BarCodeName'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectId'
        Value = Null
        Component = GuidesDiscountExternal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectName'
        Value = Null
        Component = GuidesDiscountExternal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaxPrice'
        Value = Null
        Component = ceMaxPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountProcent'
        Value = Null
        Component = ceDiscountProcent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountWithVAT'
        Value = Null
        Component = ceDiscountWithVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountWithoutVAT'
        Value = Null
        Component = ceDiscountWithoutVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDiscountSite'
        Value = Null
        Component = cbDiscountSite
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isStealthBonuses'
        Value = Null
        Component = cbStealthBonuses
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 160
    Top = 23
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
    Left = 328
    Top = 64
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoods
    FormNameParam.Value = 'TGoodsLiteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsLiteForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
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
    Left = 121
    Top = 99
  end
  object GuidesDiscountExternal: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceDiscountExternal
    FormNameParam.Value = 'TDiscountExternal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDiscountExternal_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDiscountExternal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDiscountExternal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 257
    Top = 147
  end
end
