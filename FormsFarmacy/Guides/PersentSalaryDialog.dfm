object PersentSalaryDialogForm: TPersentSalaryDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' %  '#1092#1086#1085#1076#1072' '#1047#1055
  ClientHeight = 190
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 26
    Top = 146
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 156
    Top = 146
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel5: TcxLabel
    Left = 135
    Top = 8
    Caption = '% '#1092#1086#1085#1076#1072' '#1079#1087
  end
  object edPersentSalary: TcxCurrencyEdit
    Left = 135
    Top = 31
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 3
    Width = 96
  end
  object cxLabel6: TcxLabel
    Left = 23
    Top = 8
    Caption = #1053#1072' '#1076#1072#1090#1091':'
  end
  object deOperDate: TcxDateEdit
    Left = 23
    Top = 31
    EditValue = 43938d
    Properties.DateButtons = [btnClear, btnToday]
    Properties.ShowTime = False
    TabOrder = 5
    Width = 90
  end
  object cxLabel3: TcxLabel
    Left = 23
    Top = 78
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
  end
  object edRetail: TcxButtonEdit
    Left = 23
    Top = 101
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 7
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1088#1075#1086#1074#1091#1102' '#1089#1077#1090#1100'>'
    Width = 208
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 217
    Top = 74
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
    Left = 176
    Top = 117
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MaterRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterRetailName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersentSalary'
        Value = Null
        Component = edPersentSalary
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Component = deOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
    Left = 119
    Top = 138
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    Key = '0'
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
    Left = 96
    Top = 80
  end
  object spGet_Current_Date: TdsdStoredProc
    StoredProcName = 'gpGet_Current_Date'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'gpGet_Current_Date'
        Value = 43101d
        Component = deOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 8
  end
  object ActionList: TActionList
    Left = 155
    Top = 49
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_Current_Date
      StoredProcList = <
        item
          StoredProc = spGet_Current_Date
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
end
