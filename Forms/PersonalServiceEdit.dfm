object PersonalServiceEditForm: TPersonalServiceEditForm
  Left = 0
  Top = 0
  Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077
  ClientHeight = 328
  ClientWidth = 654
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
  object cxLabel1: TcxLabel
    Left = 40
    Top = 53
    Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxButton1: TcxButton
    Left = 186
    Top = 276
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 446
    Top = 276
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object ceInvNumber: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 4
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 344
    Top = 101
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 151
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 205
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel
    Left = 344
    Top = 151
    Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object cePersonal: TcxButtonEdit
    Left = 344
    Top = 124
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 273
  end
  object cePaidKind: TcxButtonEdit
    Left = 40
    Top = 174
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 273
  end
  object ceUnit: TcxButtonEdit
    Left = 40
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 273
  end
  object ceInfoMoney: TcxButtonEdit
    Left = 344
    Top = 174
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 12
    Width = 273
  end
  object ceOperDate: TcxDateEdit
    Left = 40
    Top = 76
    TabOrder = 13
    Width = 273
  end
  object ceServiceDate: TcxDateEdit
    Left = 40
    Top = 124
    TabOrder = 14
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 101
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
  end
  object cxCurrencyEdit1: TcxCurrencyEdit
    Left = 344
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 16
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 344
    Top = 3
    Caption = #1057#1091#1084#1084#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
  end
  object cxLabel8: TcxLabel
    Left = 344
    Top = 51
    Caption = #1057#1090#1072#1090#1091#1089
  end
  object ceStatusKind: TcxButtonEdit
    Left = 344
    Top = 74
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 19
    Width = 273
  end
  object cePosition: TcxButtonEdit
    Left = 344
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 20
    Width = 273
  end
  object cxLabel9: TcxLabel
    Left = 344
    Top = 205
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object ActionList: TActionList
    Left = 240
    Top = 168
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
      RefreshOnTabSetChanges = False
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
    StoredProcName = 'gpInsertUpdate_Object_PersonalService'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceInvNumber
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Component = cxLabel6
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inProfitLossGroupId '
        Value = ''
        Component = PersonalGuides
        ParamType = ptInput
      end
      item
        Name = 'inProfitLossDirectionId'
        Value = ''
        Component = PaidKindGuides
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyDestinationId'
        Value = ''
        Component = UnitGuides
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId '
        Value = ''
        Component = InfoMoneyGuides
      end>
    Left = 264
    Top = 64
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 312
    Top = 16
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProfitLoss'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Name'
        Component = cxLabel6
        DataType = ftString
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceInvNumber
      end
      item
        Name = 'ProfitLossGroupId'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ProfitLossDirectionId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ProfitLossGroupName'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'ProfitLossDirectionName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'InfoMoneyDestinationId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyDestinationName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
      end>
    Left = 192
    Top = 72
  end
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonal
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 488
    Top = 117
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TPaidKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 192
    Top = 165
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
    Left = 240
    Top = 224
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 256
    Top = 24
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 208
    Top = 229
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 488
    Top = 165
  end
  object StatusKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatusKind
    FormNameParam.Value = 'TStatusKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TStatusKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 480
    Top = 57
  end
  object PositionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 504
    Top = 221
  end
end
