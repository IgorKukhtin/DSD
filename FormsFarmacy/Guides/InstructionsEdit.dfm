﻿object InstructionsEditForm: TInstructionsEditForm
  Left = 0
  Top = 0
  Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1103
  ClientHeight = 234
  ClientWidth = 353
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
    Left = 24
    Top = 103
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 24
    Top = 80
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 79
    Top = 197
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 205
    Top = 197
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 24
    Top = 35
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 24
    Top = 58
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 77
  end
  object ceInstructionsKind: TcxButtonEdit
    Left = 107
    Top = 58
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 213
  end
  object cxLabel5: TcxLabel
    Left = 107
    Top = 35
    Caption = #1056#1072#1079#1076#1077#1083' '#1080#1085#1089#1090#1088#1091#1082#1094#1080#1081
  end
  object edFileName: TcxTextEdit
    Left = 24
    Top = 159
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 296
  end
  object cxLabel2: TcxLabel
    Left = 24
    Top = 136
    Caption = #1048#1084#1103' '#1092#1072#1081#1083#1072
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 240
    Top = 12
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
    object actSendFile: TdsdFTP
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actUpdate_FileName
      BeforeAction = actOpenInstruction
      HostParam.Value = ''
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = 21
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'Port'
      PortParam.MultiSelectSeparator = ','
      UsernameParam.Value = ''
      UsernameParam.Component = FormParams
      UsernameParam.ComponentItem = 'Username'
      UsernameParam.DataType = ftString
      UsernameParam.MultiSelectSeparator = ','
      PasswordParam.Value = ''
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DirParam.Value = ''
      DirParam.Component = FormParams
      DirParam.ComponentItem = 'Dir'
      DirParam.DataType = ftString
      DirParam.MultiSelectSeparator = ','
      FullFileNameParam.Value = ''
      FullFileNameParam.Component = FormParams
      FullFileNameParam.ComponentItem = 'FullFileName'
      FullFileNameParam.DataType = ftString
      FullFileNameParam.MultiSelectSeparator = ','
      FileNameFTPParam.Value = ''
      FileNameFTPParam.Component = FormParams
      FileNameFTPParam.ComponentItem = 'FileNameFTP'
      FileNameFTPParam.DataType = ftString
      FileNameFTPParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.Component = edFileName
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      DownloadFolderParam.Value = ''
      DownloadFolderParam.DataType = ftString
      DownloadFolderParam.MultiSelectSeparator = ','
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1092#1072#1081#1083
      ImageIndex = 30
    end
    object actDownloadAndRunFile: TdsdFTP
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actInstructionsFTPParams
      HostParam.Value = ''
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = 21
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'Port'
      PortParam.MultiSelectSeparator = ','
      UsernameParam.Value = ''
      UsernameParam.Component = FormParams
      UsernameParam.ComponentItem = 'Username'
      UsernameParam.DataType = ftString
      UsernameParam.MultiSelectSeparator = ','
      PasswordParam.Value = ''
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DirParam.Value = ''
      DirParam.Component = FormParams
      DirParam.ComponentItem = 'Dir'
      DirParam.DataType = ftString
      DirParam.MultiSelectSeparator = ','
      FullFileNameParam.Value = ''
      FullFileNameParam.DataType = ftString
      FullFileNameParam.MultiSelectSeparator = ','
      FileNameFTPParam.Value = ''
      FileNameFTPParam.Component = FormParams
      FileNameFTPParam.ComponentItem = 'FileNameFTP'
      FileNameFTPParam.DataType = ftString
      FileNameFTPParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.Component = edFileName
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      DownloadFolderParam.Value = 'Instructions'
      DownloadFolderParam.DataType = ftString
      DownloadFolderParam.MultiSelectSeparator = ','
      FTPOperation = ftpDownloadAndRun
      Caption = 'actDownloadAndRunFile'
      ImageIndex = 28
    end
    object actDelFile: TdsdFTP
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actUpdate_FileName
      BeforeAction = actInstructionsFTPParams
      HostParam.Value = ''
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = 21
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'Port'
      PortParam.MultiSelectSeparator = ','
      UsernameParam.Value = ''
      UsernameParam.Component = FormParams
      UsernameParam.ComponentItem = 'Username'
      UsernameParam.DataType = ftString
      UsernameParam.MultiSelectSeparator = ','
      PasswordParam.Value = ''
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DirParam.Value = ''
      DirParam.Component = FormParams
      DirParam.ComponentItem = 'Dir'
      DirParam.DataType = ftString
      DirParam.MultiSelectSeparator = ','
      FullFileNameParam.Value = ''
      FullFileNameParam.DataType = ftString
      FullFileNameParam.MultiSelectSeparator = ','
      FileNameFTPParam.Value = ''
      FileNameFTPParam.Component = FormParams
      FileNameFTPParam.ComponentItem = 'FileNameFTP'
      FileNameFTPParam.DataType = ftString
      FileNameFTPParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.Component = edFileName
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      DownloadFolderParam.Value = 'Instructions'
      DownloadFolderParam.DataType = ftString
      DownloadFolderParam.MultiSelectSeparator = ','
      FTPOperation = ftpDelete
      Caption = 'actDelFile'
      ImageIndex = 52
    end
    object actOpenInstruction: TFileDialogAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actInstructionsFTPParams
      FileOpenDialog.FavoriteLinks = <>
      FileOpenDialog.FileTypes = <
        item
          DisplayName = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1080
          FileMask = '*.doc;*.docx'
        end>
      FileOpenDialog.OkButtonLabel = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1072#1081#1083
      FileOpenDialog.Options = []
      Param.Value = Null
      Param.Component = FormParams
      Param.ComponentItem = 'FullFileName'
      Param.DataType = ftString
      Param.MultiSelectSeparator = ','
    end
    object actInstructionsFTPParams: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInstructionsFTPParams
      StoredProcList = <
        item
          StoredProc = spInstructionsFTPParams
        end>
      Caption = 'actInstructionsFTPParams'
    end
    object actUpdate_FileName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_FileName
      StoredProcList = <
        item
          StoredProc = spUpdate_FileName
        end>
      Caption = 'actUpdate_FileName'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Instructions'
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
        Component = ceCode
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
        Name = 'inInstructionsKindId'
        Value = Null
        Component = InstructionsKindGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 120
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'FullFileName'
        Value = Null
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Host'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Username'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Dir'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FileNameFTP'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FileName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 176
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Instructions'
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
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'InstructionsKindId'
        Value = Null
        Component = InstructionsKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InstructionsKindName'
        Value = Null
        Component = InstructionsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FileName'
        Value = Null
        Component = edFileName
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 8
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 80
    Top = 103
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
    Left = 288
    Top = 64
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 136
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbInsert: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbEdit: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbErased: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbUnErased: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExcel: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbSetRelatedProduct: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1087#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099'>'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1087#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099'>'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbClearRelatedProduct: TdxBarButton
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' <'#1057#1086#1087#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099'>'
      Category = 0
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' <'#1057#1086#1087#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099'>'
      Visible = ivAlways
      ImageIndex = 76
    end
    object dxBarButton1: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton2: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton3: TdxBarButton
      Action = actSendFile
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actDownloadAndRunFile
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actDelFile
      Category = 0
    end
  end
  object InstructionsKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInstructionsKind
    FormNameParam.Value = 'TInstructionsKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInstructionsKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InstructionsKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InstructionsKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 47
  end
  object spInstructionsFTPParams: TdsdStoredProc
    StoredProcName = 'gpSelect_InstructionsFTPParams'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inID'
        Value = ''
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outHost'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Host'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPort'
        Value = ''
        Component = FormParams
        ComponentItem = 'Port'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUsername'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'Username'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPassword'
        Value = ''
        Component = FormParams
        ComponentItem = 'Password'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDir'
        Value = ''
        Component = FormParams
        ComponentItem = 'Dir'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileNameFTP'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileNameFTP'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 120
  end
  object spUpdate_FileName: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Instructions_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inID'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFileName'
        Value = Null
        Component = edFileName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 160
  end
end
