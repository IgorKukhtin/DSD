object MarginCategoryItemEditForm: TMarginCategoryItemEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' '#1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1102' '#1085#1072#1094#1077#1085#1086#1082
  ClientHeight = 187
  ClientWidth = 366
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
  object cxButton1: TcxButton
    Left = 71
    Top = 144
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 221
    Top = 144
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object ceMinPrice: TcxCurrencyEdit
    Left = 21
    Top = 105
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 0
    Width = 109
  end
  object cxLabel4: TcxLabel
    Left = 21
    Top = 82
    Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1094#1077#1085#1072
  end
  object ceMarginPercent: TcxCurrencyEdit
    Left = 205
    Top = 105
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 4
    Width = 131
  end
  object cxLabel2: TcxLabel
    Left = 205
    Top = 82
    Caption = '% '#1085#1072#1094#1077#1085#1082#1080
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 24
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080
  end
  object ceMarginCategory: TcxButtonEdit
    Left = 21
    Top = 47
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    StyleDisabled.BorderColor = clWindowFrame
    StyleDisabled.Color = clWindow
    StyleDisabled.TextColor = clWindowText
    TabOrder = 7
    Width = 315
  end
  object ActionList: TActionList
    Left = 144
    Top = 4
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
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MarginCategoryId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MarginCategoryName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 80
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MarginCategoryItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMarginCategoryId'
        Value = ''
        Component = dsdFormParams
        ComponentItem = 'MarginCategoryId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MarginCategoryId'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MarginCategoryName'
        Value = 0.000000000000000000
        Component = MarginCategoryGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinPrice'
        Value = Null
        Component = ceMinPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MarginPercent'
        Value = Null
        Component = ceMarginPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 8
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 280
    Top = 23
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
    Left = 312
    Top = 72
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MarginCategoryItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMarginCategoryId'
        Value = ''
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinPrice'
        Value = Null
        Component = ceMinPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMarginPercent'
        Value = Null
        Component = ceMarginPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 80
  end
  object MarginCategoryGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMarginCategory
    DisableGuidesOpen = True
    FormNameParam.Value = 'TMarginCategoryForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMarginCategoryForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MarginCategoryGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 24
  end
end
