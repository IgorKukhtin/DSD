object PartionCellEditForm: TPartionCellEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1071#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')>'
  ClientHeight = 290
  ClientWidth = 427
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
  object edName: TcxTextEdit
    Left = 111
    Top = 30
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 130
    Top = 12
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 107
    Top = 248
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 251
    Top = 248
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 94
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 63
    Hint = #1059#1088#1086#1074#1077#1085#1100' '#1089#1090#1077#1083#1072#1078#1072
    Caption = #1059#1088#1086#1074#1077#1085#1100
  end
  object cxLabel4: TcxLabel
    Left = 111
    Top = 63
    Caption = #1044#1083#1080#1085#1072' '#1103#1095'., '#1084#1084
  end
  object ceLevel: TcxCurrencyEdit
    Left = 10
    Top = 83
    Hint = #1059#1088#1086#1074#1077#1085#1100' '#1089#1090#1077#1083#1072#1078#1072
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    ShowHint = True
    TabOrder = 8
    Width = 94
  end
  object ceLength: TcxCurrencyEdit
    Left = 111
    Top = 83
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 9
    Width = 94
  end
  object ceComment: TcxTextEdit
    Left = 10
    Top = 191
    TabOrder = 10
    Width = 397
  end
  object cxLabel9: TcxLabel
    Left = 10
    Top = 168
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object cxLabel8: TcxLabel
    Left = 212
    Top = 63
    Caption = #1064#1080#1088#1080#1085#1072' '#1103#1095'., '#1084#1084
  end
  object ceWidth: TcxCurrencyEdit
    Left = 212
    Top = 83
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 13
    Width = 94
  end
  object cxLabel10: TcxLabel
    Left = 313
    Top = 63
    Caption = #1042#1099#1089#1086#1090#1072' '#1103#1095'., '#1084#1084
  end
  object ceHeight: TcxCurrencyEdit
    Left = 312
    Top = 86
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 15
    Width = 94
  end
  object cxLabel11: TcxLabel
    Left = 10
    Top = 116
    Hint = #1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
    Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097'. '#1045'2'
  end
  object ceBoxCount: TcxCurrencyEdit
    Left = 10
    Top = 136
    Hint = #1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074' '#1045'2 ('#1080#1090#1086#1075#1086' '#1074' '#1103#1095#1077#1081#1082#1077')'
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    ShowHint = True
    TabOrder = 17
    Width = 94
  end
  object ceRowBoxCount: TcxCurrencyEdit
    Left = 111
    Top = 136
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 18
    Width = 94
  end
  object cxLabel12: TcxLabel
    Left = 111
    Top = 116
    Caption = #1050#1086#1083'. '#1103#1097'. '#1074' '#1088#1103#1076#1091
  end
  object cxLabel13: TcxLabel
    Left = 212
    Top = 116
    Caption = #1056#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
  end
  object ceRowWidth: TcxCurrencyEdit
    Left = 212
    Top = 136
    Hint = #1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1075#1083#1091#1073#1080#1085#1072')'
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    ShowHint = True
    TabOrder = 21
    Width = 94
  end
  object ceRowHeight: TcxCurrencyEdit
    Left = 313
    Top = 136
    Hint = #1050#1086#1083'-'#1074#1086' '#1088#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    ShowHint = True
    TabOrder = 22
    Width = 94
  end
  object cxLabel14: TcxLabel
    Left = 313
    Top = 116
    Caption = #1056#1103#1076#1086#1074' ('#1074#1099#1089#1086#1090#1072')'
  end
  object ActionList: TActionList
    Left = 208
    Top = 224
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_PartionCell'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = edCode
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
        Name = 'inLevel'
        Value = Null
        Component = ceLevel
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLength'
        Value = Null
        Component = ceLength
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth'
        Value = Null
        Component = ceWidth
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeight'
        Value = Null
        Component = ceHeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxCount'
        Value = Null
        Component = ceBoxCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRowBoxCount'
        Value = Null
        Component = ceRowBoxCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRowWidth'
        Value = Null
        Component = ceRowWidth
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRowHeight'
        Value = Null
        Component = ceRowHeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 206
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 24
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_PartionCell'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
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
        Component = edCode
        DataType = ftUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Level'
        Value = Null
        Component = ceLevel
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Length'
        Value = Null
        Component = ceLength
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Width'
        Value = Null
        Component = ceWidth
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Height'
        Value = Null
        Component = ceHeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxCount'
        Value = Null
        Component = ceBoxCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RowBoxCount'
        Value = Null
        Component = ceRowBoxCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RowWidth'
        Value = Null
        Component = ceRowWidth
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RowHeight'
        Value = Null
        Component = ceRowHeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 224
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
    Left = 400
    Top = 70
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 24
    Top = 222
  end
end
