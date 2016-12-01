object ReestrUpdateDialogForm: TReestrUpdateDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100
  ClientHeight = 128
  ClientWidth = 333
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
    Left = 53
    Top = 84
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 199
    Top = 84
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edDriver: TcxTextEdit
    Left = 14
    Top = 29
    TabOrder = 2
    Width = 302
  end
  object cxLabel2: TcxLabel
    Left = 14
    Top = 10
    Caption = #1060#1048#1054' '#1074#1086#1076#1080#1090#1077#1083#1100
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 208
    Top = 45
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
        Name = 'DriverName'
        Value = 42156d
        Component = edDriver
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DriverId'
        Value = 0
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 56
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Reestr_ReestrUpdate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'DriverName'
        Value = 0.000000000000000000
        Component = edDriver
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDriverId'
        Value = 0
        Component = FormParams
        ComponentItem = 'DriverId'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 16
  end
  object ActionList: TActionList
    Left = 216
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
end
