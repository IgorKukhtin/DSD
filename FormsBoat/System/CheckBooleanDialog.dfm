object CheckBooleanDialogForm: TCheckBooleanDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1079#1085#1072#1095#1077#1085#1080#1103
  ClientHeight = 130
  ClientWidth = 303
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
    Left = 24
    Top = 85
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 198
    Top = 82
    Width = 75
    Height = 28
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxMemo1: TcxMemo
    AlignWithMargins = True
    Left = 33
    Top = 27
    TabStop = False
    Enabled = False
    Lines.Strings = (
      #1055#1077#1095#1072#1090#1072#1090#1100' '#1094#1077#1085#1091' ('#1044#1072'/ '#1053#1077#1090')')
    Properties.ReadOnly = True
    Style.BorderStyle = ebsNone
    Style.Color = clBtnFace
    Style.Edges = [bLeft, bTop, bRight, bBottom]
    Style.Shadow = False
    StyleDisabled.BorderStyle = ebsNone
    StyleDisabled.TextColor = clWindowText
    TabOrder = 2
    Height = 18
    Width = 144
  end
  object cbPrice: TcxCheckBox
    Left = 183
    Top = 27
    Hint = #1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093
    TabOrder = 3
    Width = 32
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 158
    Top = 57
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
    Top = 87
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'isPrice'
        Value = True
        Component = cbPrice
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Label'
        Value = #1055#1077#1095#1072#1090#1072#1090#1100' '#1094#1077#1085#1091' ('#1044#1072'/ '#1053#1077#1090')'
        Component = cxMemo1
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 150
    Top = 81
  end
  object ActionList: TActionList
    Left = 235
    Top = 2
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
