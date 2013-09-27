inherited PartnerEditForm: TPartnerEditForm
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
  ClientHeight = 333
  ClientWidth = 371
  ExplicitWidth = 379
  ExplicitHeight = 367
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 312
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 77
    Top = 301
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 238
    Top = 301
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
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 107
  end
  object cxLabel2: TcxLabel
    Left = 192
    Top = 3
    Caption = #1050#1086#1076' GLN'
  end
  object edGLNCode: TcxTextEdit
    Left = 192
    Top = 26
    TabOrder = 7
    Width = 160
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 104
    Caption = #1070#1088'. '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 97
    Top = 101
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 255
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 138
    Caption = #1047#1072' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1085#1080#1084#1072#1077#1090#1089#1103' '#1079#1072#1082#1072#1079
  end
  object cxLabel5: TcxLabel
    Left = 13
    Top = 164
    Caption = #1063#1077#1088#1077#1079' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1086#1092#1086#1088#1084#1083#1103#1077#1090#1089#1103' '#1076#1086#1082'-'#1085#1086
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 200
    Caption = #1052#1072#1088#1096#1088#1091#1090
  end
  object ceRoute: TcxButtonEdit
    Left = 116
    Top = 199
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 13
    Width = 236
  end
  object cxLabel7: TcxLabel
    Left = 40
    Top = 228
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
  end
  object ceRouteSorting: TcxButtonEdit
    Left = 176
    Top = 226
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 15
    Width = 176
  end
  object cxLabel8: TcxLabel
    Left = 40
    Top = 255
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
  end
  object cePersonalTake: TcxButtonEdit
    Left = 176
    Top = 253
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 17
    Width = 176
  end
  object cePrepareDayCount: TcxCurrencyEdit
    Left = 233
    Top = 137
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.EditFormat = '0'
    TabOrder = 18
    Width = 121
  end
  object ceDocumentDayCount: TcxCurrencyEdit
    Left = 233
    Top = 164
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.EditFormat = '0'
    TabOrder = 19
    Width = 121
  end
  object ActionList: TActionList
    Left = 336
    Top = 24
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object dsdFormClose: TdsdFormClose
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Partner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end
      item
        Name = 'inCode'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptInput
        Value = 0.000000000000000000
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inGLNCode'
        Component = edGLNCode
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inPrepareDayCount'
        Component = cePrepareDayCount
        DataType = ftFloat
        ParamType = ptInput
        Value = 0.000000000000000000
      end
      item
        Name = 'inDocumentDayCount'
        Component = ceDocumentDayCount
        DataType = ftFloat
        ParamType = ptInput
        Value = 0.000000000000000000
      end
      item
        Name = 'inJuridicalId'
        Component = dsdJuridicalGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inRouteId'
        Component = dsdRouteGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inRouteSortingId'
        Component = dsdRouteSortingGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inPersonalTakeId'
        Component = dsdPersonalGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end>
    Left = 168
    Top = 24
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 240
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Partner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'Name'
        Component = edName
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'Code'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'GLNCode'
        Component = edGLNCode
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PrepareDayCount'
        Component = cePrepareDayCount
        DataType = ftFloat
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'DocumentDayCount'
        Component = ceDocumentDayCount
        DataType = ftFloat
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'JuridicalId'
        Component = dsdJuridicalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'JuridicalName'
        Component = dsdJuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'RouteId'
        Component = dsdRouteGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'RouteName'
        Component = dsdRouteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'RouteSortingId'
        Component = dsdRouteSortingGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'RouteSortingName'
        Component = dsdRouteSortingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PersonalTakeId'
        Component = dsdPersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'PersonalTakeName'
        Component = dsdPersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end>
    Left = 288
    Top = 8
  end
  object dsdJuridicalGuides: TdsdGuides
    Key = '0'
    LookupControl = ceJuridical
    FormName = 'TJuridicalForm'
    PositionDataSet = 'GridDataSet'
    Params = <
      item
        Name = 'Key'
        Component = dsdJuridicalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = dsdJuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 240
    Top = 80
  end
  object dsdPersonalGuides: TdsdGuides
    Key = '0'
    LookupControl = cePersonalTake
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = dsdPersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = dsdPersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 336
    Top = 256
  end
  object dsdRouteSortingGuides: TdsdGuides
    Key = '0'
    LookupControl = ceRouteSorting
    FormName = 'TRouteSortingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = dsdRouteSortingGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = dsdRouteSortingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 312
    Top = 216
  end
  object dsdRouteGuides: TdsdGuides
    Key = '0'
    LookupControl = ceRoute
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = dsdRouteGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'TextValue'
        Component = dsdRouteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 280
    Top = 176
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 32
    Top = 280
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
    Left = 24
    Top = 224
  end
end
