object RecalcMCSShedulerMainDialogForm: TRecalcMCSShedulerMainDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1044#1083#1103' '#1086#1089#1085#1086#1074#1085#1086#1075#1086' '#1087#1077#1088#1089#1095#1077#1090#1072
  ClientHeight = 277
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 78
    Top = 237
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 189
    Top = 237
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object ceDay7: TcxCurrencyEdit
    Left = 236
    Top = 186
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 2
    Width = 84
  end
  object cePeriod7: TcxCurrencyEdit
    Left = 118
    Top = 186
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 84
  end
  object ceDay6: TcxCurrencyEdit
    Left = 236
    Top = 166
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 4
    Width = 84
  end
  object cePeriod6: TcxCurrencyEdit
    Left = 118
    Top = 166
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 84
  end
  object ceDay5: TcxCurrencyEdit
    Left = 236
    Top = 146
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 6
    Width = 84
  end
  object cePeriod5: TcxCurrencyEdit
    Left = 118
    Top = 146
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 7
    Width = 84
  end
  object ceDay4: TcxCurrencyEdit
    Left = 236
    Top = 126
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 8
    Width = 84
  end
  object cePeriod4: TcxCurrencyEdit
    Left = 118
    Top = 126
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 9
    Width = 84
  end
  object ceDay3: TcxCurrencyEdit
    Left = 236
    Top = 106
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 10
    Width = 84
  end
  object cePeriod3: TcxCurrencyEdit
    Left = 118
    Top = 106
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 11
    Width = 84
  end
  object ceDay2: TcxCurrencyEdit
    Left = 236
    Top = 86
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 12
    Width = 84
  end
  object cePeriod2: TcxCurrencyEdit
    Left = 118
    Top = 86
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 13
    Width = 84
  end
  object ceDay1: TcxCurrencyEdit
    Left = 236
    Top = 66
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 14
    Width = 84
  end
  object cePeriod1: TcxCurrencyEdit
    Left = 118
    Top = 66
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 15
    Width = 84
  end
  object cxLabel13: TcxLabel
    Left = 220
    Top = 23
    Caption = #1057#1090#1088#1072#1093#1086#1074#1086#1081' '#1079#1072#1087#1072#1089' '#1053#1058#1047
  end
  object cxLabel14: TcxLabel
    Left = 109
    Top = 23
    Caption = #1044#1085#1077#1081' '#1076#1083#1103' '#1072#1085#1072#1083#1080#1079#1072
  end
  object cxLabel12: TcxLabel
    Left = 25
    Top = 187
    Caption = #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
  end
  object cxLabel11: TcxLabel
    Left = 25
    Top = 167
    Caption = #1057#1091#1073#1073#1086#1090#1072
  end
  object cxLabel10: TcxLabel
    Left = 25
    Top = 147
    Caption = #1055#1103#1090#1085#1080#1094#1072
  end
  object cxLabel9: TcxLabel
    Left = 25
    Top = 127
    Caption = #1063#1077#1090#1074#1077#1088#1075
  end
  object cxLabel8: TcxLabel
    Left = 25
    Top = 107
    Caption = #1057#1088#1077#1076#1072
  end
  object cxLabel7: TcxLabel
    Left = 25
    Top = 87
    Caption = #1042#1090#1086#1088#1085#1080#1082
  end
  object cxLabel6: TcxLabel
    Left = 25
    Top = 67
    Caption = #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 215
    Top = 170
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
    Left = 216
    Top = 213
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period1'
        Value = Null
        Component = cePeriod1
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period2'
        Value = Null
        Component = cePeriod2
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period3'
        Value = Null
        Component = cePeriod3
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period4'
        Value = Null
        Component = cePeriod4
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period5'
        Value = Null
        Component = cePeriod5
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period6'
        Value = Null
        Component = cePeriod6
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period7'
        Value = Null
        Component = cePeriod7
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day1'
        Value = Null
        Component = ceDay1
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day2'
        Value = Null
        Component = ceDay2
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day3'
        Value = Null
        Component = ceDay3
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day4'
        Value = Null
        Component = ceDay4
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day5'
        Value = Null
        Component = ceDay5
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day6'
        Value = Null
        Component = ceDay6
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day7'
        Value = Null
        Component = ceDay7
        MultiSelectSeparator = ','
      end>
    Left = 29
    Top = 202
  end
  object PeriodChoice: TPeriodChoice
    Left = 128
    Top = 204
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_RecalcMCSSheduler'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inID'
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
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period1'
        Value = 0.000000000000000000
        Component = cePeriod1
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period2'
        Value = 0.000000000000000000
        Component = cePeriod2
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period3'
        Value = 0.000000000000000000
        Component = cePeriod3
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period4'
        Value = 0.000000000000000000
        Component = cePeriod4
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period5'
        Value = 0.000000000000000000
        Component = cePeriod5
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period6'
        Value = 0.000000000000000000
        Component = cePeriod6
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period7'
        Value = 0.000000000000000000
        Component = cePeriod7
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day1'
        Value = 0.000000000000000000
        Component = ceDay1
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day2'
        Value = 0.000000000000000000
        Component = ceDay2
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day3'
        Value = 0.000000000000000000
        Component = ceDay3
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day4'
        Value = 0.000000000000000000
        Component = ceDay4
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day5'
        Value = 0.000000000000000000
        Component = ceDay5
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day6'
        Value = 0.000000000000000000
        Component = ceDay6
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day7'
        Value = 0.000000000000000000
        Component = ceDay7
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 104
    Top = 104
  end
  object ActionList: TActionList
    Left = 112
    Top = 32
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
  end
end
