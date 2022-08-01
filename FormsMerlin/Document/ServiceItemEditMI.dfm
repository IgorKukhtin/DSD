object ServiceItemEditMIForm: TServiceItemEditMIForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1059#1089#1083#1086#1074#1080#1103' '#1072#1088#1077#1085#1076#1099' ('#1080#1089#1090#1086#1088#1080#1103')>'
  ClientHeight = 256
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 91
    Top = 210
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 224
    Top = 210
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object cxLabel2: TcxLabel
    Left = 24
    Top = 51
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object edEndDate: TcxDateEdit
    Left = 24
    Top = 71
    EditValue = 42236d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 0
    Width = 92
  end
  object Код: TcxLabel
    Left = 24
    Top = 4
    Caption = #1054#1090#1076#1077#1083':'
  end
  object edGoods: TcxButtonEdit
    Left = 24
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 374
  end
  object cxLabel1: TcxLabel
    Left = 125
    Top = 53
    Caption = #1055#1083#1086#1097#1072#1076#1100' :'
  end
  object ceArea: TcxCurrencyEdit
    Left = 125
    Top = 71
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 7
    Width = 69
  end
  object edInfoMoney: TcxButtonEdit
    Left = 24
    Top = 122
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 374
  end
  object cxLabel4: TcxLabel
    Left = 24
    Top = 104
    Caption = #1057#1090#1072#1090#1100#1103':'
  end
  object cxLabel5: TcxLabel
    Left = 24
    Top = 149
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
  end
  object edCommentInfoMoney: TcxButtonEdit
    Left = 24
    Top = 168
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 374
  end
  object cxLabel6: TcxLabel
    Left = 203
    Top = 53
    Caption = #1062#1077#1085#1072' '#1079#1072' '#1082#1074'.'#1084'. :'
  end
  object cePrice: TcxCurrencyEdit
    Left = 203
    Top = 71
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 13
    Width = 80
  end
  object cxLabel7: TcxLabel
    Left = 293
    Top = 53
    Caption = #1057#1091#1084#1084#1072' '#1079#1072' '#1087#1083#1086#1097#1072#1076#1100' :'
  end
  object ceAmount: TcxCurrencyEdit
    Left = 293
    Top = 71
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 15
    Width = 105
  end
  object ActionList: TActionList
    Left = 328
    Top = 200
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
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
      Category = 'DSDLib'
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
    StoredProcName = 'gpUpdate_Movement_ServiceItem'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentInfoMoneyId'
        Value = Null
        Component = GuidesCommentInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = edEndDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = cePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inArea'
        Value = Null
        Component = ceArea
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 275
    Top = 102
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 16
    Top = 184
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_ServiceItem'
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
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = FormParams
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptInput
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
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentInfoMoneyId'
        Value = Null
        Component = GuidesCommentInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentInfoMoneyName'
        Value = Null
        Component = GuidesCommentInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = edEndDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Area'
        Value = ''
        Component = ceArea
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = 0.000000000000000000
        Component = cePrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 198
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
    Left = 152
    Top = 144
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 296
    Top = 160
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    DisableGuidesOpen = True
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
    Left = 156
    Top = 9
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney
    Key = '0'
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKindName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsService'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 101
  end
  object GuidesCommentInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCommentInfoMoney
    FormNameParam.Value = 'TCommentInfoMoneyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCommentInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCommentInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCommentInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 147
  end
end
