object IntegerDialogForm: TIntegerDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1094#1077#1083#1086#1075#1086' '#1095#1080#1089#1083#1072
  ClientHeight = 160
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 41
    Top = 114
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 215
    Top = 111
    Width = 75
    Height = 28
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object ceValues: TcxCurrencyEdit
    Left = 41
    Top = 61
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 0
    Width = 249
  end
  object edLabel: TcxTextEdit
    Left = 40
    Top = 24
    Enabled = False
    ParentColor = True
    StyleDisabled.BorderStyle = ebsNone
    StyleDisabled.TextColor = clWindowText
    TabOrder = 3
    Text = #1042#1074#1086#1076' '#1095#1080#1089#1083#1072
    Width = 250
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 158
    Top = 22
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
    Left = 231
    Top = 100
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Values'
        Value = 100.000000000000000000
        Component = ceValues
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Label'
        Value = Null
        Component = edLabel
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 38
    Top = 94
  end
  object ActionList: TActionList
    Left = 267
    Top = 23
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
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
