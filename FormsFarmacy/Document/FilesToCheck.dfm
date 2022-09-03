inherited FilesToCheckForm: TFilesToCheckForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1060#1072#1081#1083#1099' '#1074#1099#1082#1083#1072#1076#1082#1080' '#1076#1083#1103' '#1072#1087#1090#1077#1082'>'
  ClientHeight = 516
  ClientWidth = 627
  ExplicitWidth = 643
  ExplicitHeight = 555
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 119
    Width = 627
    Height = 397
    ExplicitTop = 119
    ExplicitWidth = 627
    ExplicitHeight = 397
    ClientRectBottom = 397
    ClientRectRight = 627
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 627
      ExplicitHeight = 373
      inherited cxGrid: TcxGrid
        Width = 627
        Height = 373
        ExplicitWidth = 627
        ExplicitHeight = 373
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Amount: TcxGridDBColumn [0]
            Caption = #1054#1090#1084#1077#1095#1077#1085
            DataBinding.FieldName = 'IsChecked'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object UnitCode: TcxGridDBColumn [1]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object UnitName: TcxGridDBColumn [2]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1072#1087#1090#1077#1082#1080
            DataBinding.FieldName = 'UnitName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 451
          end
          inherited colIsErased: TcxGridDBColumn
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 627
    Height = 93
    TabOrder = 3
    ExplicitWidth = 627
    ExplicitHeight = 93
    inherited edInvNumber: TcxTextEdit
      Left = 182
      ExplicitLeft = 182
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 182
      ExplicitLeft = 182
    end
    inherited edOperDate: TcxDateEdit
      Left = 266
      EditValue = 42951d
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 266
      ExplicitWidth = 86
      Width = 86
    end
    inherited cxLabel2: TcxLabel
      Left = 266
      ExplicitLeft = 266
    end
    inherited ceStatus: TcxButtonEdit
      ExplicitWidth = 166
      ExplicitHeight = 22
      Width = 166
    end
    object edComment: TcxTextEdit
      Left = 8
      Top = 67
      Properties.ReadOnly = False
      TabOrder = 6
      Width = 362
    end
    object cxLabel7: TcxLabel
      Left = 8
      Top = 48
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edStartPromo: TcxDateEdit
      Left = 358
      Top = 23
      EditValue = 42951d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 8
      Width = 86
    end
    object cxLabel3: TcxLabel
      Left = 358
      Top = 5
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1089
    end
    object edEndPromo: TcxDateEdit
      Left = 450
      Top = 23
      EditValue = 42951d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 10
      Width = 86
    end
    object cxLabel4: TcxLabel
      Left = 450
      Top = 5
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1076#1086
    end
    object edFileName: TcxTextEdit
      Left = 376
      Top = 67
      Properties.ReadOnly = False
      TabOrder = 12
      Width = 233
    end
    object cxLabel5: TcxLabel
      Left = 376
      Top = 51
      Caption = #1055#1088#1080#1082#1088#1077#1087#1083#1077#1085#1085#1099#1081' '#1092#1072#1081#1083
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 283
    Top = 424
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 248
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      Enabled = False
      StoredProcList = <
        item
        end>
      DataSets = <
        item
          UserName = 'frxDBDHeader'
        end
        item
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1057#1087#1080#1089#1072#1085#1080#1077
      ReportNameParam.Value = #1057#1087#1080#1089#1072#1085#1080#1077
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spGet
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [13]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      ImageIndex = 12
    end
    object actSendFile: TdsdFTP
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actUpdate_FileName
      BeforeAction = actOpenFilesToCheck
      HostParam.Value = ''
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = '0'
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
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1092#1072#1081#1083
      ImageIndex = 30
    end
    object actDownloadAndRunFile: TdsdFTP
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actFilesToCheckFTPParams
      HostParam.Value = ''
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = '0'
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
      DownloadFolderParam.Value = 'FilesToCheck'
      DownloadFolderParam.DataType = ftString
      DownloadFolderParam.MultiSelectSeparator = ','
      FTPOperation = ftpDownloadAndRun
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080' '#1086#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080' '#1086#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
      ImageIndex = 28
    end
    object actDelFile: TdsdFTP
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actUpdate_FileName
      BeforeAction = actFilesToCheckFTPParams
      HostParam.Value = ''
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = '0'
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
      DownloadFolderParam.Value = 'FilesToCheck'
      DownloadFolderParam.DataType = ftString
      DownloadFolderParam.MultiSelectSeparator = ','
      FTPOperation = ftpDelete
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1092#1072#1081#1083
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1092#1072#1081#1083
      ImageIndex = 52
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1080#1082#1088#1077#1087#1083#1077#1085#1085#1099#1081' '#1092#1072#1081#1083'?'
    end
    object actFilesToCheckFTPParams: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spFilesToCheckFTPParams
      StoredProcList = <
        item
          StoredProc = spFilesToCheckFTPParams
        end>
      Caption = 'actFilesToCheckFTPParams'
    end
    object actOpenFilesToCheck: TFileDialogAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actFilesToCheckFTPParams
      FileOpenDialog.FavoriteLinks = <>
      FileOpenDialog.FileTypes = <
        item
          DisplayName = #1060#1072#1083#1099' '#1074#1099#1082#1083#1072#1076#1086#1082
          FileMask = '*.xls;*.xlsx*.doc;*.docx;*.odt;*.jpg;*.png'
        end>
      FileOpenDialog.OkButtonLabel = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1072#1081#1083
      FileOpenDialog.Options = []
      Param.Value = Null
      Param.Component = FormParams
      Param.ComponentItem = 'FullFileName'
      Param.DataType = ftString
      Param.MultiSelectSeparator = ','
    end
    object actUpdate_FileName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_FileName
      StoredProcList = <
        item
          StoredProc = spUpdate_FileName
        end>
      Caption = 'actUpdate_FileName'
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 440
  end
  inherited MasterCDS: TClientDataSet
    Left = 64
    Top = 440
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_FilesToCheck'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    object bbComplete: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1095#1077#1082
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1095#1077#1082
      Visible = ivAlways
      ImageIndex = 29
    end
    object dxBarButton2: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1072#1085#1080#1103
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1072#1085#1080#1103
      Visible = ivAlways
      ImageIndex = 24
    end
    object dxBarButton3: TdxBarButton
      Caption = #1057#1087#1080#1089#1072#1090#1100' '#1074#1077#1089#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1089' '#1090#1086#1095#1082#1080
      Category = 0
      Hint = #1057#1087#1080#1089#1072#1090#1100' '#1074#1077#1089#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1089' '#1090#1086#1095#1082#1080
      Visible = ivAlways
      ImageIndex = 30
    end
    object bbUpdateSummaFund: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1080#1079' '#1092#1086#1085#1076#1072
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1080#1079' '#1092#1086#1085#1076#1072
      Visible = ivAlways
      ImageIndex = 75
    end
    object bbInsertByLayout: TdxBarButton
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1042#1099#1082#1083#1072#1076#1082#1080
      Category = 0
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1042#1099#1082#1083#1072#1076#1082#1080
      Visible = ivAlways
      ImageIndex = 27
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarButton4: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object dxBarButton5: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 46
    end
    object dxBarButton6: TdxBarButton
      Action = actSendFile
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actDownloadAndRunFile
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actDelFile
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    SearchAsFilter = False
    Left = 518
    Top = 265
  end
  inherited PopupMenu: TPopupMenu
    Left = 264
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
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
    Left = 280
    Top = 352
  end
  inherited StatusGuides: TdsdGuides
    Left = 40
    Top = 16
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_FilesToCheck'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 112
    Top = 16
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_FilesToCheck'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartPromo'
        Value = Null
        Component = edStartPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndPromo'
        Value = Null
        Component = edEndPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
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
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_FilesToCheck'
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
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartPromo'
        Value = Null
        Component = edStartPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndPromo'
        Value = Null
        Component = edEndPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 170
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end
      item
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edStartPromo
      end
      item
        Control = edEndPromo
      end
      item
        Control = edComment
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 400
    Top = 336
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_FilesToCheck_SetErased'
    Left = 382
    Top = 400
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_FilesToCheck_SetUnErased'
    Left = 518
    Top = 200
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_FilesToCheck'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChecked'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsChecked'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_FilesToCheck'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = '0'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = '0'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TotalSummLoss'
    Left = 332
    Top = 196
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 424
    Top = 184
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_FilesToCheck'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCurrentData'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 376
  end
  object spFilesToCheckFTPParams: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_FilesToCheckFTPParams'
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
        Name = 'outHost'
        Value = Null
        Component = FormParams
        ComponentItem = 'Host'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPort'
        Value = Null
        Component = FormParams
        ComponentItem = 'Port'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUsername'
        Value = Null
        Component = FormParams
        ComponentItem = 'Username'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPassword'
        Value = Null
        Component = FormParams
        ComponentItem = 'Password'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDir'
        Value = Null
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
    Left = 520
    Top = 320
  end
  object spUpdate_FileName: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_FilesToCheck_FileName'
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
        Value = ''
        Component = edFileName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 376
  end
end
