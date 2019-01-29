object RouteEditForm: TRouteEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'>'
  ClientHeight = 534
  ClientWidth = 361
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
  object edRouteName: TcxTextEdit
    Left = 32
    Top = 88
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 68
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 62
    Top = 498
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 206
    Top = 498
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 32
    Top = 19
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 32
    Top = 42
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object ceUnit: TcxButtonEdit
    Left = 32
    Top = 182
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 32
    Top = 160
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel2: TcxLabel
    Left = 32
    Top = 207
    Caption = #1058#1080#1087' '#1084#1072#1088#1096#1088#1091#1090#1072
  end
  object ceRouteKind: TcxButtonEdit
    Left = 32
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 32
    Top = 254
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1075#1088#1091#1079#1072
  end
  object ceFreight: TcxButtonEdit
    Left = 32
    Top = 274
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 32
    Top = 114
    Caption = #1060#1080#1083#1080#1072#1083
  end
  object ceBranch: TcxButtonEdit
    Left = 32
    Top = 134
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 32
    Top = 303
    Caption = #1043#1088#1091#1087#1087#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
  end
  object ceRouteGroup: TcxButtonEdit
    Left = 32
    Top = 323
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 273
  end
  object cxLabel29: TcxLabel
    Left = 32
    Top = 353
    Caption = #1057#1091#1084#1084#1072' '#1082#1086#1084#1084#1072#1085#1076#1080#1088'.'
  end
  object edRateSumma: TcxCurrencyEdit
    Left = 32
    Top = 372
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 17
    Width = 135
  end
  object cxLabel6: TcxLabel
    Left = 32
    Top = 398
    Hint = #1057#1090#1072#1074#1082#1072' '#1075#1088#1085'/'#1082#1084' ('#1076#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077')'
    Caption = #1057#1090#1072#1074#1082#1072' '#1075#1088#1085'/'#1082#1084' ('#1076#1072#1083#1100#1085#1086#1073'.)'
  end
  object edRatePrice: TcxCurrencyEdit
    Left = 32
    Top = 416
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 19
    Width = 135
  end
  object cxLabel8: TcxLabel
    Left = 173
    Top = 353
    Hint = #1057#1090#1072#1074#1082#1072' '#1075#1088#1085'/'#1095' ('#1082#1086#1084#1084#1072#1085#1076'.)'
    Caption = #1057#1090#1072#1074#1082#1072' '#1075#1088#1085'/'#1095' ('#1082#1086#1084#1084#1072#1085#1076'.)'
  end
  object edTimePrice: TcxCurrencyEdit
    Left = 173
    Top = 372
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 21
    Width = 132
  end
  object cxLabel9: TcxLabel
    Left = 173
    Top = 398
    Hint = #1057#1091#1084#1084#1072' '#1076#1086#1087#1083#1072#1090#1072' ('#1076#1072#1083#1100#1085#1086#1073'.)'
    Caption = #1057#1091#1084#1084#1072' '#1076#1086#1087'. ('#1076#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077')'
  end
  object edRateSummaAdd: TcxCurrencyEdit
    Left = 173
    Top = 416
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 23
    Width = 132
  end
  object cxLabel10: TcxLabel
    Left = 32
    Top = 444
    Hint = #1057#1091#1084#1084#1072' '#1082#1086#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1093' '#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088#1091
    Caption = #1057#1091#1084#1084#1072' '#1082#1086#1084#1072#1085#1076'. '#1101#1082#1089#1087'.'
    ParentShowHint = False
    ShowHint = True
  end
  object edRateSummaExp: TcxCurrencyEdit
    Left = 32
    Top = 463
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 25
    Width = 132
  end
  object ActionList: TActionList
    Left = 328
    Top = 10
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
    object dsdFormClose1: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Route'
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
        Component = edRouteName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRateSumma'
        Value = Null
        Component = edRateSumma
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRatePrice'
        Value = Null
        Component = edRatePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTimePrice'
        Value = Null
        Component = edTimePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRateSummaAdd'
        Value = Null
        Component = edRateSummaAdd
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRateSummaExp'
        Value = Null
        Component = edRateSummaExp
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnit'
        Value = ''
        Component = UnitGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranch'
        Value = ''
        Component = BranchGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteKind'
        Value = ''
        Component = RouteKindGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFreight'
        Value = ''
        Component = FreightGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteGroupId'
        Value = Null
        Component = RouteGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 72
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 104
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Route'
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
        Component = edRouteName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteKindId'
        Value = ''
        Component = RouteKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteKindName'
        Value = ''
        Component = RouteKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FreightId'
        Value = ''
        Component = FreightGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FreightName'
        Value = ''
        Component = FreightGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteGroupId'
        Value = Null
        Component = RouteGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteGroupName'
        Value = Null
        Component = RouteGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RateSumma'
        Value = Null
        Component = edRateSumma
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RatePrice'
        Value = Null
        Component = edRatePrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TimePrice'
        Value = Null
        Component = edTimePrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RateSummaAdd'
        Value = Null
        Component = edRateSummaAdd
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RateSummaExp'
        Value = Null
        Component = edRateSummaExp
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 130
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
    Left = 96
    Top = 72
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Left = 128
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 191
    Top = 161
  end
  object RouteKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRouteKind
    FormNameParam.Value = 'TRouteKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RouteKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RouteKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 127
    Top = 209
  end
  object FreightGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceFreight
    FormNameParam.Value = 'TFreightForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TFreightForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FreightGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FreightGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 207
    Top = 257
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBranch
    FormNameParam.Value = 'TBranchForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranchForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 138
    Top = 116
  end
  object RouteGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRouteGroup
    FormNameParam.Value = 'TRouteGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RouteGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RouteGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 159
    Top = 305
  end
end
