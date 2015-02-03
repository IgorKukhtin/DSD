object AssetEditForm: TAssetEditForm
  Left = 0
  Top = 0
  Caption = #1053#1086#1074#1086#1077' '#1089#1088#1077#1076#1089#1090#1074#1086
  ClientHeight = 463
  ClientWidth = 380
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
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 71
    Top = 426
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 221
    Top = 426
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 296
  end
  object ceInvNumber: TcxTextEdit
    Left = 40
    Top = 167
    TabOrder = 6
    Width = 138
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 144
    Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1085#1099#1081' '#1085#1086#1084#1077#1088
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 274
    Caption = #1043#1088#1091#1087#1087#1099' '#1086#1089#1085#1086#1074#1085#1099#1093' '#1089#1088#1077#1076#1089#1090#1074
  end
  object ceAssetGroup: TcxButtonEdit
    Left = 40
    Top = 297
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 296
  end
  object cxLabel3: TcxLabel
    Left = 43
    Top = 192
    Caption = #1047#1072#1074#1086#1076#1089#1082#1086#1081' '#1085#1086#1084#1077#1088
  end
  object ceSerialNumber: TcxTextEdit
    Left = 40
    Top = 211
    TabOrder = 11
    Width = 138
  end
  object cxLabel5: TcxLabel
    Left = 212
    Top = 147
    Caption = #1044#1072#1090#1072' '#1074#1099#1087#1091#1089#1082#1072
  end
  object edRelease: TcxDateEdit
    Left = 212
    Top = 167
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 13
    Width = 100
  end
  object cxLabel6: TcxLabel
    Left = 211
    Top = 192
    Caption = #1053#1086#1084#1077#1088' '#1087#1072#1089#1087#1086#1088#1090#1072
  end
  object cePassportNumber: TcxTextEdit
    Left = 198
    Top = 211
    TabOrder = 15
    Width = 138
  end
  object cxLabel7: TcxLabel
    Left = 43
    Top = 99
    Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1054#1057
  end
  object ceFullName: TcxTextEdit
    Left = 40
    Top = 118
    TabOrder = 17
    Width = 296
  end
  object cxLabel8: TcxLabel
    Left = 40
    Top = 234
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 40
    Top = 251
    TabOrder = 19
    Width = 296
  end
  object cxLabel9: TcxLabel
    Left = 41
    Top = 320
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
  end
  object ceJuridical: TcxButtonEdit
    Left = 40
    Top = 338
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 21
    Width = 296
  end
  object ceMaker: TcxButtonEdit
    Left = 40
    Top = 378
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 22
    Width = 296
  end
  object cxLabel10: TcxLabel
    Left = 43
    Top = 361
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' ('#1054#1057')'
  end
  object ActionList: TActionList
    Left = 344
    Top = 204
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
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Asset'
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
        Name = 'inRelease'
        Value = 0d
        Component = edRelease
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = ceInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inFullName'
        Value = ''
        Component = ceFullName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inSerialNumber'
        Value = ''
        Component = ceSerialNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inPassportNumber'
        Value = ''
        Component = cePassportNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inAssetGroupId'
        Value = ''
        Component = AssetGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMakerId'
        Value = ''
        Component = MakerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 344
    Top = 112
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 344
    Top = 160
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Asset'
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
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'Release'
        Value = 0d
        Component = edRelease
        DataType = ftDateTime
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = ceInvNumber
        DataType = ftString
      end
      item
        Name = 'FullName'
        Value = ''
        Component = ceFullName
        DataType = ftString
      end
      item
        Name = 'SerialNumber'
        Value = ''
        Component = ceSerialNumber
        DataType = ftString
      end
      item
        Name = 'PassportNumber'
        Value = ''
        Component = cePassportNumber
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'AssetGroupId'
        Value = ''
        Component = AssetGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'AssetGroupName'
        Value = ''
        Component = AssetGroupGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MakerId'
        Value = ''
        Component = MakerGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MakerName'
        Value = ''
        Component = MakerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 344
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 344
    Top = 255
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
    Left = 344
    Top = 64
  end
  object AssetGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAssetGroup
    FormNameParam.Value = 'TAssetGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TAssetGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AssetGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AssetGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 128
    Top = 292
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 96
    Top = 332
  end
  object MakerGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMaker
    FormNameParam.Value = 'TMakerForm'
    FormNameParam.DataType = ftString
    FormName = 'TMakerForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MakerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MakerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 176
    Top = 372
  end
end
