inherited PartnerEditForm: TPartnerEditForm
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
  ClientHeight = 333
  ClientWidth = 418
  ExplicitWidth = 426
  ExplicitHeight = 367
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 300
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 104
    Top = 301
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 265
    Top = 301
    Width = 75
    Height = 25
    Action = dsdFormClose1
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
    Width = 148
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 104
    Caption = #1070#1088'. '#1083#1080#1094#1086
  end
  object ceJuridical: TcxLookupComboBox
    Left = 104
    Top = 98
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = JuridicalDS
    TabOrder = 9
    Width = 236
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 138
    Caption = #1047#1072' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1085#1080#1084#1072#1077#1090#1089#1103' '#1079#1072#1082#1072#1079
  end
  object edPrepareDayCount: TcxTextEdit
    Left = 252
    Top = 137
    TabOrder = 11
    Width = 65
  end
  object edDocumentDayCount: TcxTextEdit
    Left = 252
    Top = 164
    TabOrder = 12
    Width = 65
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 164
    Caption = #1063#1077#1088#1077#1079' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1086#1092#1086#1088#1084#1083#1103#1077#1090#1089#1103' '#1076#1086#1082'-'#1085#1086
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 200
    Caption = #1052#1072#1088#1096#1088#1091#1090
  end
  object ceRoute: TcxLookupComboBox
    Left = 116
    Top = 199
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = JuridicalDS
    TabOrder = 15
    Width = 236
  end
  object cxLabel7: TcxLabel
    Left = 40
    Top = 232
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
  end
  object ceRouteSorting: TcxLookupComboBox
    Left = 176
    Top = 226
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = JuridicalDS
    TabOrder = 17
    Width = 176
  end
  object cxLabel8: TcxLabel
    Left = 40
    Top = 255
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
  end
  object cePersonalTake: TcxLookupComboBox
    Left = 176
    Top = 253
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = JuridicalDS
    TabOrder = 19
    Width = 176
  end
  object ActionList: TActionList
    Left = 296
    Top = 72
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetJuridical
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object dsdFormClose1: TdsdFormClose
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
    StoredProcName = 'gpInsertUpdate_Object_Juridical'
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
        Value = ''
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
        Component = edPrepareDayCount
        DataType = ftFloat
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inDocumentDayCount'
        Component = edDocumentDayCount
        DataType = ftFloat
        ParamType = ptInput
        Value = ''
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
        Component = dsdPersonalTakeGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end>
    Left = 240
    Top = 64
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
    StoredProcName = 'gpGet_Object_Juridical'
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
        Value = ''
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
        Component = edPrepareDayCount
        DataType = ftFloat
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'DocumentDayCount'
        Component = edDocumentDayCount
        DataType = ftFloat
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'JuridicalId'
        Component = dsdJuridicalGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'JuridicalName'
        Component = dsdJuridicalGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'RouteId'
        Component = dsdRouteGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'RouteName'
        Component = dsdRouteGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'RouteSortingId'
        Component = dsdRouteSortingGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'RouteSortingName'
        Component = dsdRouteSortingGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'PersonalTakeId'
        Component = dsdPersonalTakeGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'PersonalTakeName'
        Component = dsdPersonalTakeGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end>
    Left = 192
    Top = 72
  end
  object JuridicalDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 176
  end
  object spGetJuridical: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Juridical'
    DataSet = JuridicalDataSet
    DataSets = <
      item
        DataSet = JuridicalDataSet
      end>
    Params = <>
    Left = 216
    Top = 176
  end
  object JuridicalDS: TDataSource
    DataSet = JuridicalDataSet
    Left = 256
    Top = 176
  end
  object dsdJuridicalGuides: TdsdGuides
    Key = '0'
    LookupControl = ceJuridical
    PositionDataSet = 'ClientDataSet'
    Left = 344
    Top = 152
  end
  object dsdPersonalTakeGuides: TdsdGuides
    Key = '0'
    LookupControl = cePersonalTake
    PositionDataSet = 'ClientDataSet'
    Left = 368
    Top = 248
  end
  object dsdRouteSortingGuides: TdsdGuides
    Key = '0'
    LookupControl = ceRouteSorting
    PositionDataSet = 'ClientDataSet'
    Left = 368
    Top = 224
  end
  object dsdRouteGuides: TdsdGuides
    Key = '0'
    LookupControl = ceRoute
    PositionDataSet = 'ClientDataSet'
    Left = 368
    Top = 200
  end
end
