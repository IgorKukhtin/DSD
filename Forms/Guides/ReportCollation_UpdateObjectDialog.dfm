object ReportCollation_UpdateObjectDialogForm: TReportCollation_UpdateObjectDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
  ClientHeight = 162
  ClientWidth = 276
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
    Left = 20
    Top = 124
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 166
    Top = 124
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edIsBuh: TcxCheckBox
    Left = 27
    Top = 22
    Caption = #1057#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102
    State = cbsChecked
    TabOrder = 2
    Width = 186
  end
  object cxLabel1: TcxLabel
    Left = 27
    Top = 52
    Caption = #1044#1072#1090#1072' ('#1089#1076#1072#1083#1080' '#1074' '#1073#1091#1093#1075'.):'
  end
  object deBuhDate: TcxDateEdit
    Left = 27
    Top = 70
    EditValue = 43101.000000000000000000
    Properties.Kind = ckDateTime
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 4
    Width = 186
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 136
    Top = 29
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = dsdInsertUpdateGuides1
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 216
    Top = 92
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'BuhDate'
        Value = 0
        Component = deBuhDate
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsBuh'
        Value = 42156d
        Component = edIsBuh
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 104
  end
  object ActionList: TActionList
    Left = 184
    Top = 8
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'dsdFormClose'
    end
    object dsdInsertUpdateGuides1: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ReportCollation_Buh'
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
        Name = 'inBuhDate'
        Value = ''
        Component = deBuhDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsBuh'
        Value = 0
        Component = edIsBuh
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 32
  end
end
