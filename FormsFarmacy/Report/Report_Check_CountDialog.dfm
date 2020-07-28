object Report_Check_CountDialogForm: TReport_Check_CountDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1050#1072#1089#1089#1086#1074#1099#1077' '#1095#1077#1082#1080' '#1087#1086' '#1091#1089#1083#1086#1074#1080#1102'>'
  ClientHeight = 166
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 67
    Top = 129
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 241
    Top = 129
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 124
    Top = 27
    EditValue = 42400d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 13
    Top = 27
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 11
    Top = 8
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 124
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel19: TcxLabel
    Left = 241
    Top = 64
    Caption = #1052#1080#1085'. '#1089#1091#1084#1084#1072' '#1095#1077#1082#1072
  end
  object edMinSumma: TcxCurrencyEdit
    Left = 241
    Top = 83
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.####'
    TabOrder = 7
    Width = 95
  end
  object cxLabel1: TcxLabel
    Left = 13
    Top = 64
    Caption = #1042#1088#1077#1084#1103' '#1089' :'
  end
  object deStartTime: TcxDateEdit
    Left = 13
    Top = 83
    EditValue = 42370d
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    Properties.ShowTime = False
    TabOrder = 9
    Width = 90
  end
  object cxLabel2: TcxLabel
    Left = 124
    Top = 63
    Caption = #1042#1088#1077#1084#1103' '#1087#1086' :'
  end
  object deEndTime: TcxDateEdit
    Left = 124
    Top = 83
    EditValue = 42400d
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    Properties.ShowTime = False
    TabOrder = 11
    Width = 90
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 205
    Top = 11
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 318
    Top = 9
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
    Left = 277
    Top = 15
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartTime'
        Value = 'NULL'
        Component = deStartTime
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndTime'
        Value = 'NULL'
        Component = deEndTime
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinSumma'
        Value = Null
        Component = edMinSumma
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 20
    Top = 113
  end
  object ActionList: TActionList
    Left = 177
    Top = 130
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
  end
end
