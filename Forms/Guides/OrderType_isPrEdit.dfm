object OrderType_isPrEditForm: TOrderType_isPrEditForm
  Left = 0
  Top = 0
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 341
  ClientWidth = 394
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
    Left = 88
    Top = 298
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 7
  end
  object cxButton2: TcxButton
    Left = 232
    Top = 298
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 8
  end
  object cxLabel1: TcxLabel
    Left = 22
    Top = 12
    Caption = #1058#1086#1074#1072#1088
  end
  object edName: TcxTextEdit
    Left = 62
    Top = 11
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 291
  end
  object cxLabel2: TcxLabel
    Left = 232
    Top = 55
    Caption = #1042#1099#1093#1086#1076' '#1089' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
  end
  object cxLabel3: TcxLabel
    Left = 22
    Top = 55
    Caption = #1047#1072#1082#1072#1079' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
  end
  object cbOrderPr1: TcxCheckBox
    Left = 22
    Top = 78
    Caption = #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 13
    Width = 96
  end
  object cbOrderPr2: TcxCheckBox
    Left = 22
    Top = 108
    Caption = #1042#1090#1086#1088#1085#1080#1082
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 14
    Width = 73
  end
  object cbOrderPr3: TcxCheckBox
    Left = 22
    Top = 138
    Caption = #1057#1088#1077#1076#1072
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 15
    Width = 73
  end
  object cbOrderPr4: TcxCheckBox
    Left = 22
    Top = 168
    Caption = #1063#1077#1090#1074#1077#1088#1075
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 16
    Width = 73
  end
  object cbOrderPr5: TcxCheckBox
    Left = 22
    Top = 198
    Caption = #1055#1103#1090#1085#1080#1094#1072
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 17
    Width = 73
  end
  object cbOrderPr6: TcxCheckBox
    Left = 22
    Top = 228
    Caption = #1057#1091#1073#1073#1086#1090#1072
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 18
    Width = 73
  end
  object cbOrderPr7: TcxCheckBox
    Left = 22
    Top = 258
    Caption = #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 19
    Width = 96
  end
  object cbInPr1: TcxCheckBox
    Left = 232
    Top = 78
    Caption = #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 1
    Width = 97
  end
  object cbInPr2: TcxCheckBox
    Left = 232
    Top = 108
    Caption = #1042#1090#1086#1088#1085#1080#1082
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 2
    Width = 73
  end
  object cbInPr3: TcxCheckBox
    Left = 232
    Top = 138
    Caption = #1057#1088#1077#1076#1072
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 3
    Width = 73
  end
  object cbInPr4: TcxCheckBox
    Left = 232
    Top = 168
    Caption = #1063#1077#1090#1074#1077#1088
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 4
    Width = 73
  end
  object cbInPr5: TcxCheckBox
    Left = 232
    Top = 198
    Caption = #1055#1103#1090#1085#1080#1094#1072
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 6
    Width = 73
  end
  object cbInPr6: TcxCheckBox
    Left = 232
    Top = 228
    Caption = #1057#1091#1073#1073#1086#1090#1072
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 5
    Width = 73
  end
  object cbInPr7: TcxCheckBox
    Left = 232
    Top = 258
    Caption = #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 0
    Width = 97
  end
  object ActionList: TActionList
    Left = 128
    Top = 91
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
      StoredProc = spUpdate
      StoredProcList = <
        item
          StoredProc = spUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_OrderType_Pr'
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
        Name = 'inisOrderPr1'
        Value = False
        Component = cbOrderPr1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrderPr2'
        Value = ''
        Component = cbOrderPr2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrderPr3'
        Value = Null
        Component = cbOrderPr3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrderPr4'
        Value = Null
        Component = cbOrderPr4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrderPr5'
        Value = Null
        Component = cbOrderPr5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrderPr6'
        Value = Null
        Component = cbOrderPr6
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOrderPr7'
        Value = Null
        Component = cbOrderPr7
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInPr1'
        Value = Null
        Component = cbInPr1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInPr2'
        Value = Null
        Component = cbInPr2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInPr3'
        Value = Null
        Component = cbInPr3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInPr4'
        Value = Null
        Component = cbInPr4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInPr5'
        Value = Null
        Component = cbInPr5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInPr6'
        Value = Null
        Component = cbInPr6
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInPr7'
        Value = Null
        Component = cbInPr7
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 107
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 240
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_OrderType_Pr'
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
        Name = 'isOrderPr1'
        Value = False
        Component = cbOrderPr1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOrderPr2'
        Value = ''
        Component = cbOrderPr2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOrderPr3'
        Value = Null
        Component = cbOrderPr3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOrderPr4'
        Value = Null
        Component = cbOrderPr4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOrderPr5'
        Value = Null
        Component = cbOrderPr5
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOrderPr6'
        Value = Null
        Component = cbOrderPr6
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOrderPr7'
        Value = Null
        Component = cbOrderPr7
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isInPr1'
        Value = Null
        Component = cbInPr1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isInPr2'
        Value = Null
        Component = cbInPr2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isInPr3'
        Value = Null
        Component = cbInPr3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isInPr4'
        Value = Null
        Component = cbInPr4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isInPr5'
        Value = Null
        Component = cbInPr5
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isInPr6'
        Value = Null
        Component = cbInPr6
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isInPr7'
        Value = Null
        Component = cbInPr7
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 336
    Top = 179
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
    Left = 183
    Top = 286
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 152
    Top = 168
  end
end
