object UserPswDialogForm: TUserPswDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1086#1083#1100' '#1076#1083#1103' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1103' '#1074' Scale'
  ClientHeight = 179
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 45
    Top = 140
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 191
    Top = 140
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel2: TcxLabel
    Left = 14
    Top = 10
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object ceScalePSW: TcxCurrencyEdit
    Left = 14
    Top = 89
    Properties.DecimalPlaces = 10
    Properties.DisplayFormat = ',0.####'
    TabOrder = 3
    Width = 270
  end
  object cxLabel1: TcxLabel
    Left = 14
    Top = 66
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object edUser: TcxButtonEdit
    Left = 14
    Top = 33
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 270
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 200
    Top = 101
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
    Left = 272
    Top = 84
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UserName'
        Value = 0
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserId'
        Value = 42156d
        Component = GuidesUser
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ScalePSW'
        Value = 0
        Component = ceScalePSW
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 8
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_User_ScalePSW'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUserId'
        Value = 0.000000000000000000
        Component = GuidesUser
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inScalePSW'
        Value = 0
        Component = ceScalePSW
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 16
  end
  object ActionList: TActionList
    Left = 160
    Top = 64
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
      Caption = 'dsdFormClose'
    end
  end
  object GuidesUser: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    FormNameParam.Value = 'TUser_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUser_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 24
  end
end
