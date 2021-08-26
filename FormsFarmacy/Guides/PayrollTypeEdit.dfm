object PayrollTypeEditForm: TPayrollTypeEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' <'#1058#1080#1087' '#1088#1072#1089#1095#1077#1090#1072' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099'>'
  ClientHeight = 347
  ClientWidth = 638
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
    Left = 84
    Top = 298
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 234
    Top = 298
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
  object cePercent: TcxCurrencyEdit
    Left = 23
    Top = 215
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 6
    Width = 186
  end
  object cxLabel6: TcxLabel
    Left = 23
    Top = 192
    Caption = ' '#1055#1088#1086#1094#1077#1085#1090' '#1086#1090' '#1073#1072#1079#1099' '
  end
  object ceMinAccrualAmount: TcxCurrencyEdit
    Left = 234
    Top = 215
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 8
    Width = 186
  end
  object cxLabel2: TcxLabel
    Left = 234
    Top = 196
    Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
  end
  object edPayrollGroup: TcxButtonEdit
    Left = 20
    Top = 163
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 217
  end
  object cxLabel3: TcxLabel
    Left = 23
    Top = 144
    Caption = #1043#1088#1091#1087#1087#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099
  end
  object edShortName: TcxTextEdit
    Left = 20
    Top = 122
    TabOrder = 12
    Width = 400
  end
  object cxLabel4: TcxLabel
    Left = 20
    Top = 99
    Caption = ' '#1050#1086#1088#1086#1090#1082#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '
  end
  object Panel1: TPanel
    Left = 435
    Top = 0
    Width = 203
    Height = 347
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 14
    ExplicitHeight = 300
    object CorrectMinAmountGrid: TcxGrid
      Left = 1
      Top = 18
      Width = 201
      Height = 328
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 281
      object CorrectMinAmountGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = CorrectMinAmountDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.Appending = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object DateStart: TcxGridDBColumn
          Caption = #1057' '#1076#1072#1090#1099
          DataBinding.FieldName = 'DateStart'
          PropertiesClassName = 'TcxDateEditProperties'
          Properties.InputKind = ikRegExpr
          Properties.SaveTime = False
          Properties.ShowTime = False
          Properties.WeekNumbers = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 101
        end
        object Amount: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072
          DataBinding.FieldName = 'Amount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 81
        end
      end
      object CorrectMinAmountGridLevel: TcxGridLevel
        GridView = CorrectMinAmountGridDBTableView
      end
    end
    object cxLabel5: TcxLabel
      Left = 1
      Top = 1
      Align = alTop
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1084#1080#1085'. '#1089#1091#1084#1084#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
    end
  end
  object edPayrollType: TcxButtonEdit
    Left = 23
    Top = 264
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 15
    Width = 397
  end
  object cxLabel7: TcxLabel
    Left = 26
    Top = 245
    Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081' '#1088#1072#1089#1095#1077#1090' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099
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
        end
        item
          StoredProc = spSelectCorrectMinAmount
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
    object dsdUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshCorrectMinAmount
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateCorrectMinAmount
      StoredProcList = <
        item
          StoredProc = spInsertUpdateCorrectMinAmount
        end>
      Caption = 'dsdUpdateDataSet'
      DataSource = CorrectMinAmountDS
    end
    object actRefreshCorrectMinAmount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectCorrectMinAmount
      StoredProcList = <
        item
          StoredProc = spSelectCorrectMinAmount
        end>
      Caption = 'actRefreshCorrectMinAmount'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_PayrollType'
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
        Name = 'inShortName'
        Value = Null
        Component = edShortName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPayrollGroupID'
        Value = Null
        Component = PayrollGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent'
        Value = Null
        Component = cePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinAccrualAmount'
        Value = Null
        Component = ceMinAccrualAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPayrollTypeId'
        Value = Null
        Component = PayrollTypeGuides
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
    Left = 36
    Top = 24
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_PayrollType'
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
        Name = 'ShortName'
        Value = Null
        Component = edShortName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PayrollGroupID'
        Value = Null
        Component = PayrollGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PayrollGroupName'
        Value = Null
        Component = PayrollGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Percent'
        Value = Null
        Component = cePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinAccrualAmount'
        Value = Null
        Component = ceMinAccrualAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PayrollTypeId'
        Value = Null
        Component = PayrollTypeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PayrollTypeName'
        Value = Null
        Component = PayrollTypeGuides
        ComponentItem = 'TextValue'
        DataType = ftFloat
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
  object PayrollGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPayrollGroup
    FormNameParam.Value = 'TPayrollGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPayrollGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PayrollGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PayrollGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 112
  end
  object spSelectCorrectMinAmount: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_CorrectMinAmount'
    DataSet = CorrectMinAmountCDS
    DataSets = <
      item
        DataSet = CorrectMinAmountCDS
      end>
    Params = <
      item
        Name = 'inPayrollTypeId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 136
  end
  object CorrectMinAmountDS: TDataSource
    DataSet = CorrectMinAmountCDS
    Left = 496
    Top = 88
  end
  object CorrectMinAmountCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 496
    Top = 32
  end
  object spInsertUpdateCorrectMinAmount: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_CorrectMinAmount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = CorrectMinAmountCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPayrollTypeId'
        Value = 0.000000000000000000
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = Null
        Component = CorrectMinAmountCDS
        ComponentItem = 'DateStart'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = ''
        Component = CorrectMinAmountCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 500
    Top = 192
  end
  object PayrollTypeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPayrollType
    FormNameParam.Value = 'TPayrollTypeChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPayrollTypeChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PayrollTypeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PayrollTypeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 248
  end
end
