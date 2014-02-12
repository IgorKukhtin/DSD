object JuridicalGroupEditForm: TJuridicalGroupEditForm
  Left = 0
  Top = 0
  Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
  ClientHeight = 198
  ClientWidth = 303
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
  object edName: TcxTextEdit
    Left = 15
    Top = 76
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 15
    Top = 53
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1075#1088#1091#1087#1087#1099
  end
  object cxButton1: TcxButton
    Left = 47
    Top = 160
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 191
    Top = 160
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 15
    Top = 98
    Caption = #1043#1088#1091#1087#1087#1072' '#1088#1086#1076#1080#1090#1077#1083#1100
  end
  object ceCode: TcxCurrencyEdit
    Left = 15
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 4
    Width = 273
  end
  object Код: TcxLabel
    Left = 15
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceParentGroup: TcxButtonEdit
    Left = 15
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 1
    Width = 273
  end
  object ActionList: TActionList
    Left = 224
    Top = 64
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
    object InsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_JuridicalGroup'
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
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalGroupId'
        Value = ''
        Component = JuridicalGroupGuides
        ParamType = ptInput
      end>
    Left = 128
    Top = 16
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 72
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_JuridicalGroup'
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
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'ParentId'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ParentName'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 184
    Top = 24
  end
  object JuridicalGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    FormNameParam.Value = 'TJuridicalGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 224
    Top = 120
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 216
    Top = 40
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
    Left = 224
    Top = 8
  end
end
