object OrderCarInfoEditForm: TOrderCarInfoEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1043#1088#1072#1092#1080#1082' '#1086#1090#1075#1088#1091#1079#1082#1080'>'
  ClientHeight = 359
  ClientWidth = 357
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
  object cxButton1: TcxButton
    Left = 48
    Top = 315
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 222
    Top = 315
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 1
  end
  object cxLabel5: TcxLabel
    Left = 34
    Top = 46
    Caption = #1052#1072#1088#1096#1088#1091#1090
  end
  object edRoute: TcxButtonEdit
    Left = 34
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 273
  end
  object cxLabel8: TcxLabel
    Left = 34
    Top = 93
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'('#1089#1090#1086#1088#1086#1085#1085#1077#1077')'
  end
  object edRetail: TcxButtonEdit
    Left = 34
    Top = 109
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 273
  end
  object edOperDate: TcxCurrencyEdit
    Left = 177
    Top = 140
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 6
    Width = 130
  end
  object cxLabel12: TcxLabel
    Left = 34
    Top = 141
    Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1079#1072#1082#1072#1079
  end
  object cxLabel13: TcxLabel
    Left = 34
    Top = 205
    Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1076#1083#1103' '#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080
    Caption = #1048#1079#1084'. '#1074' '#1076#1085#1103#1093' ('#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080')'
    ParentShowHint = False
    ShowHint = True
  end
  object edOperDatePartner: TcxCurrencyEdit
    Left = 177
    Top = 172
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 130
  end
  object cxLabel14: TcxLabel
    Left = 34
    Top = 173
    Hint = #1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1072' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091
    Caption = #1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1072' '#1082#1086#1085#1090#1088'.'
  end
  object edDays: TcxCurrencyEdit
    Left = 222
    Top = 204
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 11
    Width = 85
  end
  object cxLabel15: TcxLabel
    Left = 34
    Top = 240
    Caption = #1063#1072#1089#1099', '#1042#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080
  end
  object edHour: TcxCurrencyEdit
    Left = 177
    Top = 239
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 13
    Width = 130
  end
  object cxLabel16: TcxLabel
    Left = 34
    Top = 276
    Caption = #1052#1080#1085#1091#1090#1099', '#1042#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080
  end
  object edMin: TcxCurrencyEdit
    Left = 177
    Top = 275
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 15
    Width = 130
  end
  object cxLabel1: TcxLabel
    Left = 34
    Top = 2
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object edUnit: TcxButtonEdit
    Left = 34
    Top = 19
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 273
  end
  object ActionList: TActionList
    Left = 34
    Top = 184
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
    object InsertUpdateGuides: TdsdInsertUpdateGuides
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_OrderCarInfo'
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
        Name = 'inRouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = edOperDatePartner
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDays'
        Value = Null
        Component = edDays
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHour'
        Value = Null
        Component = edHour
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMin'
        Value = Null
        Component = edMin
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 322
    Top = 88
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
        Name = 'inMaskId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 322
    Top = 200
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_OrderCarInfo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
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
        Name = 'RouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteName'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = Null
        Component = edOperDatePartner
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Days'
        Value = Null
        Component = edDays
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Hour'
        Value = Null
        Component = edHour
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Min'
        Value = Null
        Component = edMin
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 322
    Top = 136
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
    Left = 282
    Top = 48
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Left = 210
    Top = 32
  end
  object GuidesRoute: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute
    FormNameParam.Value = 'TRoute_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRoute_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 89
    Top = 39
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 177
    Top = 100
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 129
    Top = 3
  end
end
