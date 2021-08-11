inherited SheetWorkTimeCloseForm: TSheetWorkTimeCloseForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072', '#1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080'>'
  ClientHeight = 436
  ClientWidth = 870
  ExplicitWidth = 886
  ExplicitHeight = 474
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 117
    Width = 870
    Height = 319
    ExplicitTop = 117
    ExplicitWidth = 870
    ExplicitHeight = 319
    ClientRectBottom = 319
    ClientRectRight = 870
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 870
      ExplicitHeight = 295
      inherited cxGrid: TcxGrid
        Width = 870
        Height = 295
        ExplicitWidth = 870
        ExplicitHeight = 295
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = isAmount
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
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = isAmount
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = MemberName
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
            end>
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
          object MemberCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076' ('#1092#1080#1079'. '#1083#1080#1094#1086')'
            DataBinding.FieldName = 'MemberCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MemberName: TcxGridDBColumn [1]
            Caption = #1060#1080#1079'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'MemberName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actMember_ChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 311
          end
          object isAmount: TcxGridDBColumn [2]
            Caption = #1054#1090#1082#1088#1099#1090' / '#1079#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'isAmount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 116
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object msInsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' / '#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 253
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 870
    Height = 91
    TabOrder = 3
    ExplicitWidth = 870
    ExplicitHeight = 91
    inherited edInvNumber: TcxTextEdit
      Left = 9
      ExplicitLeft = 9
      ExplicitWidth = 118
      Width = 118
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 135
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 135
      ExplicitWidth = 84
      Width = 84
    end
    inherited cxLabel2: TcxLabel
      Left = 135
      Caption = #1044#1072#1090#1072' '#1089' ...'
      ExplicitLeft = 135
      ExplicitWidth = 53
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      Enabled = False
      Properties.Buttons = <
        item
          Action = actCompleteMovement
          Default = True
          Kind = bkGlyph
        end
        item
          Action = actUnCompleteMovement
          Enabled = False
          Kind = bkGlyph
        end
        item
          Action = actDeleteMovement
          Enabled = False
          Kind = bkGlyph
        end>
      ExplicitTop = 63
      ExplicitWidth = 165
      ExplicitHeight = 22
      Width = 165
    end
    object cxLabel8: TcxLabel
      Left = 519
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 519
      Top = 23
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 146
    end
    object cxLabel7: TcxLabel
      Left = 519
      Top = 45
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 519
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 146
    end
    object cbisClosed: TcxCheckBox
      Left = 319
      Top = 23
      Caption = #1055#1077#1088#1080#1086#1076' '#1079#1072#1082#1088#1099#1090
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 166
    end
    object cbisClosedAuto: TcxCheckBox
      Left = 319
      Top = 63
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1072#1074#1090#1086' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1055#1077#1088#1080#1086#1076#1072
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 194
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 226
    Top = 5
    Caption = #1044#1072#1090#1072' '#1087#1086' ...'
  end
  object edOperDateEnd: TcxDateEdit [3]
    Left = 226
    Top = 23
    EditValue = 42132d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 84
  end
  object cxLabel6: TcxLabel [4]
    Left = 179
    Top = 45
    Caption = #1042#1088#1077#1084#1103' '#1072#1074#1090#1086' '#1079#1072#1082#1088#1099#1090#1080#1103
  end
  object edTimeClose: TcxDateEdit [5]
    Left = 179
    Top = 63
    EditValue = 42132d
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 9
    Width = 131
  end
  object cxLabel9: TcxLabel [6]
    Left = 680
    Top = 5
    Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
  end
  object edUpdateDate: TcxDateEdit [7]
    Left = 680
    Top = 23
    EditValue = 42132d
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 146
  end
  object cxLabel10: TcxLabel [8]
    Left = 680
    Top = 45
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
  end
  object edUpdateName: TcxButtonEdit [9]
    Left = 680
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 146
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 427
    Top = 360
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 87
    Top = 255
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      ShortCut = 0
    end
    inherited actMISetUnErased: TdsdUpdateErased
      ShortCut = 0
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProc = nil
      StoredProcList = <
        item
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'UnitName;GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderGoods'
      ReportNameParam.Value = 'PrintMovement_OrderGoods'
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
      Enabled = False
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actMember_ChoiceForm: TOpenChoiceForm [13]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Member_ChoiceForm'
      FormName = 'TMember_ChoiceForm'
      FormNameParam.Value = 'TMember_ChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPrintSaleOrder: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      ImageIndex = 21
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintSaleOrderTax: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 320
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 368
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_SheetWorkTimeClose'
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
        Value = Null
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
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbPrintNoGroup: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Visible = ivAlways
      ImageIndex = 16
      ShortCut = 16464
    end
    object bbPrintSaleOrder: TdxBarButton
      Action = actPrintSaleOrder
      Category = 0
    end
    object bbPrintSaleOrderTax: TdxBarButton
      Action = actPrintSaleOrderTax
      Category = 0
    end
    object bbPersonalGroupChoiceForm: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#8470' '#1073#1088#1080#1075#1072#1076#1099
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#8470' '#1073#1088#1080#1075#1072#1076#1099
      Visible = ivAlways
      ImageIndex = 76
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
    Left = 750
    Top = 225
  end
  inherited PopupMenu: TPopupMenu
    Left = 600
    Top = 360
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
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSend'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 360
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_SheetWorkTimeClose'
    Left = 24
    Top = 24
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SheetWorkTimeClose'
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
        Name = 'OperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TimeClose'
        Value = 0d
        Component = edTimeClose
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
        Name = 'isClosed'
        Value = False
        Component = cbisClosed
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isClosedAuto'
        Value = False
        Component = cbisClosedAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = Null
        Component = edUpdateName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = Null
        Component = edUpdateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SheetWorkTimeClose'
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
        Name = 'ininOperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTimeClose'
        Value = 0d
        Component = edTimeClose
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisClosed'
        Value = False
        Component = cbisClosed
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
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
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 272
    Top = 201
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 800
    Top = 328
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_SheetWorkTimeClose_SetErased'
    Left = 646
    Top = 304
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_SheetWorkTimeClose_SetUnErased'
    Left = 646
    Top = 240
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SheetWorkTimeClose'
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
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SheetWorkTimeClose'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <
      item
      end
      item
      end
      item
      end
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
    StoredProcName = 'gpSelect_Movement_SheetWorkTimeClose_Print'
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
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 359
    Top = 328
  end
end
