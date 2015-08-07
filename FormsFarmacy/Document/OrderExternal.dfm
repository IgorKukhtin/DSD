inherited OrderExternalForm: TOrderExternalForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1103#1074#1082#1072' '#1074#1085#1077#1096#1085#1103#1103'>'
  ClientHeight = 668
  ClientWidth = 844
  ExplicitWidth = 852
  ExplicitHeight = 695
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 73
    Width = 844
    Height = 595
    ExplicitTop = 73
    ExplicitWidth = 846
    ExplicitHeight = 595
    ClientRectBottom = 595
    ClientRectRight = 844
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 846
      ExplicitHeight = 571
      inherited cxGrid: TcxGrid
        Width = 844
        Height = 571
        ExplicitWidth = 846
        ExplicitHeight = 571
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSumm
            end>
          OptionsBehavior.CellHints = True
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colClientCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'PartnerGoodsCode'
            Options.Editing = False
            Width = 96
          end
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 53
          end
          object colName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 271
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            Width = 44
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00'
            Width = 71
          end
          object colSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 115
          end
          object colPartionGoodsDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            Width = 87
          end
          object colComment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            Options.Editing = False
            Width = 93
          end
        end
      end
      object cxGridExport: TcxGrid
        Left = 532
        Top = 40
        Width = 250
        Height = 200
        TabOrder = 1
        Visible = False
        object cxGridExportDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ExportDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
        end
        object cxGridExportLevel1: TcxGridLevel
          GridView = cxGridExportDBTableView
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 844
    Height = 47
    TabOrder = 3
    ExplicitWidth = 846
    ExplicitHeight = 47
    inherited edInvNumber: TcxTextEdit
      Left = 153
      ExplicitLeft = 153
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 153
      ExplicitLeft = 153
    end
    inherited edOperDate: TcxDateEdit
      Left = 234
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 234
    end
    inherited cxLabel2: TcxLabel
      Left = 234
      ExplicitLeft = 234
    end
    inherited ceStatus: TcxButtonEdit
      ExplicitWidth = 139
      ExplicitHeight = 22
      Width = 139
    end
    object cxLabel3: TcxLabel
      Left = 338
      Top = 5
      Caption = #1070#1088' '#1083#1080#1094#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082
    end
    object edFrom: TcxButtonEdit
      Left = 338
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 190
    end
    object edTo: TcxButtonEdit
      Left = 532
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 160
    end
    object cxLabel4: TcxLabel
      Left = 532
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 699
    Top = 5
    Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1086#1089#1090'-'#1082#1072' '
  end
  object edContract: TcxButtonEdit [3]
    Left = 698
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 140
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 552
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object actExportStoredproc: TdsdExecStoredProc [0]
      Category = 'SendEMail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetExportParam
      StoredProcList = <
        item
          StoredProc = spGetExportParam
        end
        item
          StoredProc = spSelectExport
        end>
      Caption = 'actExportStoredproc'
    end
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object actExportToPartner: TExportGrid [3]
      Category = 'SendEMail'
      TabSheet = tsMain
      MoveParams = <>
      ColumnNameDataSet = PrintHeaderCDS
      Grid = cxGridExport
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080
      OpenAfterCreate = False
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end>
      ReportName = 'PrintMovement_Sale2'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_Sale2'
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
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [15]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
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
    object actGetDocumentDataForEmail: TdsdExecStoredProc
      Category = 'SendEMail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDocumentDataForEmail
      StoredProcList = <
        item
          StoredProc = spGetDocumentDataForEmail
        end>
      Caption = 'actGetDocumentDataForEmail'
    end
    object SMTPFileAction: TdsdSMTPFileAction
      Category = 'SendEMail'
      MoveParams = <>
      Host.Value = Null
      Host.Component = FormParams
      Host.ComponentItem = 'Host'
      Port.Value = 25
      Port.Component = FormParams
      Port.ComponentItem = 'Port'
      UserName.Value = Null
      UserName.Component = FormParams
      UserName.ComponentItem = 'UserName'
      Password.Value = Null
      Password.Component = FormParams
      Password.ComponentItem = 'Password'
      Body.Value = Null
      Body.Component = FormParams
      Body.ComponentItem = 'Body'
      Subject.Value = Null
      Subject.Component = FormParams
      Subject.ComponentItem = 'Subject'
      FromAddress.Value = Null
      FromAddress.Component = FormParams
      FromAddress.ComponentItem = 'AddressFrom'
      ToAddress.Value = Null
      ToAddress.Component = FormParams
      ToAddress.ComponentItem = 'AddressTo'
    end
    object mactSMTPSend: TMultiAction
      Category = 'SendEMail'
      MoveParams = <>
      ActionList = <
        item
          Action = actExportStoredproc
        end
        item
          Action = actExportToPartner
        end
        item
          Action = actGetDocumentDataForEmail
        end
        item
          Action = SMTPFileAction
        end
        item
          Action = actCompleteMovement
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1086#1090#1089#1083#1099#1082#1077' E-mail?'
      InfoAfterExecute = 'E-mail '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1086#1090#1087#1088#1072#1074#1083#1077#1085
      Caption = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail'
      Hint = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail'
      ImageIndex = 53
      ShortCut = 16467
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderExternal'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
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
          ItemName = 'bbStatic'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSendEMail'
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
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    object bbPrint_Bill: TdxBarButton [5]
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbPrintTax: TdxBarButton [6]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton [7]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbSendEMail: TdxBarButton
      Action = mactSMTPSend
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
        DataSummaryItemIndex = 5
      end>
    Left = 798
    Top = 273
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
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
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ReportNameOrderExternal'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ReportNameOrderExternalTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ReportNameOrderExternalBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'Body'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'AddressFrom'
        Value = Null
      end
      item
        Name = 'AddressTo'
        Value = Null
      end
      item
        Name = 'Subject'
        Value = Null
      end
      item
        Name = 'Host'
        Value = Null
      end
      item
        Name = 'Port'
        Value = Null
      end
      item
        Name = 'UserName'
        Value = Null
      end
      item
        Name = 'Password'
        Value = Null
      end>
    Left = 280
    Top = 552
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderExternal'
    Left = 136
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderExternal'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderExternal'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
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
      end
      item
      end
      item
        Control = edOperDate
      end
      item
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    FormName = 'OrderExternalJournalForm'
    DataSet = 'MasterCDS'
    Left = 73
    Top = 105
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderExternal_SetErased'
    Left = 718
    Top = 512
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderExternal_SetUnErased'
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderExternal'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMainGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerGoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'outSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 319
    Top = 208
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 360
    Top = 8
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientGridDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 536
    Top = 40
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractForm'
    PositionDataSet = 'MasterDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 664
    Top = 40
  end
  object spGetDocumentDataForEmail: TdsdStoredProc
    StoredProcName = 'gpGet_DocumentDataForEmail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Subject'
        Value = Null
        Component = FormParams
        ComponentItem = 'Subject'
      end
      item
        Name = 'Body'
        Value = Null
        Component = FormParams
        ComponentItem = 'Body'
      end
      item
        Name = 'AddressFrom'
        Value = Null
        Component = FormParams
        ComponentItem = 'AddressFrom'
      end
      item
        Name = 'AddressTo'
        Value = Null
        Component = FormParams
        ComponentItem = 'AddressTo'
      end
      item
        Name = 'Host'
        Value = Null
        Component = FormParams
        ComponentItem = 'Host'
      end
      item
        Name = 'Port'
        Value = Null
        Component = FormParams
        ComponentItem = 'Port'
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'Password'
      end>
    PackSize = 1
    Left = 80
    Top = 160
  end
  object spSelectExport: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderExternal_Export'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 607
    Top = 192
  end
  object ExportDS: TDataSource
    DataSet = PrintItemsCDS
    Left = 688
    Top = 192
  end
  object spGetExportParam: TdsdStoredProc
    StoredProcName = 'gpGet_OrderExternal_ExportParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'DefaultFileName'
        Value = Null
        Component = actExportToPartner
        ComponentItem = 'DefaultFileName'
      end
      item
        Name = 'ExportType'
        Value = Null
        Component = actExportToPartner
        ComponentItem = 'ExportType'
      end
      item
        Name = 'DefaultFileName'
        Value = Null
        Component = SMTPFileAction
      end>
    PackSize = 1
    Left = 608
    Top = 232
  end
end
