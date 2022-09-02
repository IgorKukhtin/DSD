object WagesVIP_UserForm: TWagesVIP_UserForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1091#1084#1084#1099' '#1047'/'#1055
  ClientHeight = 295
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  PixelsPerInch = 96
  TextHeight = 13
  object edMemberName: TcxTextEdit
    Left = 20
    Top = 71
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 261
  end
  object cxLabel1: TcxLabel
    Left = 20
    Top = 51
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object cxButton1: TcxButton
    Left = 112
    Top = 254
    Width = 75
    Height = 25
    Action = FormClose
    Cancel = True
    Default = True
    ModalResult = 2
    TabOrder = 2
  end
  object edOperDate: TcxDateEdit
    Left = 72
    Top = 16
    EditValue = 42993d
    Properties.DisplayFormat = 'mmmm YYYY '#1075'.'
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 140
  end
  object cxLabel11: TcxLabel
    Left = 16
    Top = 17
    Caption = #1044#1072#1090#1072' '#1047'/'#1055
  end
  object edAmountAccrued: TcxCurrencyEdit
    Left = 160
    Top = 124
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 121
  end
  object cxLabel3: TcxLabel
    Left = 20
    Top = 125
    Caption = #1057#1091#1084#1084#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1086':'
  end
  object edHoursWork: TcxCurrencyEdit
    Left = 160
    Top = 209
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = '0.##'
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 121
  end
  object cxLabel4: TcxLabel
    Left = 20
    Top = 210
    Caption = #1054#1090#1088#1072#1073#1086#1090#1072#1085#1086' '#1095#1072#1089#1086#1074':'
  end
  object edApplicationAward: TcxCurrencyEdit
    Left = 160
    Top = 151
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 121
  end
  object cxLabel2: TcxLabel
    Left = 20
    Top = 152
    Caption = #1055#1088#1077#1084#1080#1103' '#1079#1072' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077':'
  end
  object edTotalSum: TcxCurrencyEdit
    Left = 160
    Top = 178
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 121
  end
  object cxLabel5: TcxLabel
    Left = 20
    Top = 179
    Caption = #1048#1090#1086#1075#1086':'
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_WagesVIP_User'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = 0.000000000000000000
        Component = edMemberName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountAccrued'
        Value = Null
        Component = edAmountAccrued
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ApplicationAward'
        Value = Null
        Component = edApplicationAward
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSum'
        Value = Null
        Component = edTotalSum
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HoursWork'
        Value = Null
        Component = edHoursWork
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 56
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 64
    Top = 55
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
      end
      item
        Component = edOperDate
        Properties.Strings = (
          'Date')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 120
    Top = 56
  end
  object ActionList1: TActionList
    Left = 40
    Top = 112
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42370d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object FormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Ok'
    end
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <>
    Left = 208
    Top = 112
  end
end
