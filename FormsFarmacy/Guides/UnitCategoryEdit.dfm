object UnitCategoryEditForm: TUnitCategoryEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' <'#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1072#1087#1090#1077#1082#1080'>'
  ClientHeight = 347
  ClientWidth = 436
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
    Left = 20
    Top = 71
    TabOrder = 0
    Width = 400
  end
  object cxLabel1: TcxLabel
    Left = 20
    Top = 48
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 111
    Top = 306
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 261
    Top = 306
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 20
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 20
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 400
  end
  object cePremiumImplPlan: TcxCurrencyEdit
    Left = 23
    Top = 177
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 6
    Width = 186
  end
  object cxLabel6: TcxLabel
    Left = 23
    Top = 154
    Caption = '% '#1087#1088#1077#1084#1080#1080' '#1079#1072' '#1074#1099#1087#1086#1083#1085'. '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078
  end
  object cePenaltyNonMinPlan: TcxCurrencyEdit
    Left = 23
    Top = 127
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 8
    Width = 186
  end
  object cxLabel4: TcxLabel
    Left = 23
    Top = 108
    Caption = '% '#1096#1090#1088#1072#1092#1072' '#1079#1072' '#1085#1077#1074#1099#1087'. '#1084#1080#1085'. '#1087#1083#1072#1085#1072
  end
  object ceMinLineByLineImplPlan: TcxCurrencyEdit
    Left = 23
    Top = 223
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 10
    Width = 186
  end
  object cxLabel2: TcxLabel
    Left = 23
    Top = 204
    Caption = ' '#1052#1080#1085'. % '#1087#1086#1089#1090#1088#1086#1095#1085#1086#1075#1086' '#1074#1099#1087#1086#1083#1085'. '#1084#1080#1085'. '#1087#1083#1072#1085#1072' '#1076#1083#1103' '#1087#1086#1083#1091#1095'. '#1087#1088#1077#1084#1080#1080
  end
  object ceScaleCalcMarketingPlan: TcxButtonEdit
    Left = 23
    Top = 272
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 12
    Width = 186
  end
  object cxLabel15: TcxLabel
    Left = 23
    Top = 250
    Caption = #1064#1082#1072#1083#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1087#1088#1077#1084#1080#1080'/'#1096#1090#1088#1072#1092#1099' '#1074' '#1087#1083#1072#1085' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091
  end
  object ActionList: TActionList
    Left = 252
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
    StoredProcName = 'gpInsertUpdate_Object_UnitCategory'
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
        Name = 'inPenaltyNonMinPlan'
        Value = Null
        Component = cePenaltyNonMinPlan
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPremiumImplPlan'
        Value = Null
        Component = cePremiumImplPlan
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinLineByLineImplPlan'
        Value = Null
        Component = ceMinLineByLineImplPlan
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inScaleCalcMarketingPlanId'
        Value = Null
        Component = GuidesScaleCalcMarketingPlan
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 188
    Top = 56
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 4
    Top = 32
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_UnitCategory'
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
        Name = 'Name'
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
        Name = 'PenaltyNonMinPlan'
        Value = Null
        Component = cePenaltyNonMinPlan
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PremiumImplPlan'
        Value = Null
        Component = cePremiumImplPlan
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinLineByLineImplPlan'
        Value = Null
        Component = ceMinLineByLineImplPlan
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ScaleCalcMarketingPlanId'
        Value = Null
        Component = GuidesScaleCalcMarketingPlan
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ScaleCalcMarketingPlanName'
        Value = Null
        Component = GuidesScaleCalcMarketingPlan
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 324
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 188
    Top = 7
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
    Left = 324
    Top = 64
  end
  object GuidesScaleCalcMarketingPlan: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceScaleCalcMarketingPlan
    FormNameParam.Value = 'TScaleCalcMarketingPlanForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TScaleCalcMarketingPlanForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesScaleCalcMarketingPlan
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesScaleCalcMarketingPlan
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 247
  end
end
