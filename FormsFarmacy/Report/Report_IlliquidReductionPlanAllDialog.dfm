object Report_IlliquidReductionPlanAllDialogForm: TReport_IlliquidReductionPlanAllDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
  ClientHeight = 225
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 33
    Top = 178
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 175
    Top = 177
    Width = 75
    Height = 28
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object ceNotSalePastDay: TcxCurrencyEdit
    Left = 175
    Top = 61
    EditValue = 60.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 2
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 11
    Top = 62
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078':'
  end
  object deOperDate: TcxDateEdit
    Left = 175
    Top = 21
    EditValue = 42705d
    Properties.ShowTime = False
    TabOrder = 4
    Width = 90
  end
  object cxLabel1: TcxLabel
    Left = 11
    Top = 22
    Caption = #1044#1072#1090#1072' '#1086#1090#1095#1077#1090#1072
  end
  object ceProcUnit: TcxCurrencyEdit
    Left = 175
    Top = 141
    EditValue = 20.000000000000000000
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 6
    Width = 90
  end
  object cxLabel4: TcxLabel
    Left = 11
    Top = 142
    Caption = '% '#1074#1099#1087'. '#1087#1086' '#1072#1087#1090#1077#1082#1077'.'
  end
  object ceProcGoods: TcxCurrencyEdit
    Left = 175
    Top = 101
    EditValue = 20.000000000000000000
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 8
    Width = 90
  end
  object cxLabel3: TcxLabel
    Left = 11
    Top = 102
    Caption = '% '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1074#1099#1087'.'
  end
  object PeriodChoice: TPeriodChoice
    Left = 143
    Top = 104
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 158
    Top = 22
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 247
    Top = 100
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inOperDate'
        Value = ''
        Component = deOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'NotSalePastDay'
        Value = Null
        Component = ceNotSalePastDay
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProcGoods'
        Value = 100.000000000000000000
        Component = ceProcGoods
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProcUnit'
        Value = Null
        Component = ceProcUnit
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 46
    Top = 102
  end
  object ActionList: TActionList
    Left = 267
    Top = 23
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
end
