inherited Layout_MovementForm: TLayout_MovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1099#1082#1083#1072#1076#1082#1072'>'
  ClientHeight = 516
  ClientWidth = 855
  ExplicitWidth = 871
  ExplicitHeight = 555
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 119
    Width = 855
    Height = 397
    ExplicitTop = 119
    ExplicitWidth = 855
    ExplicitHeight = 397
    ClientRectBottom = 397
    ClientRectRight = 855
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 855
      ExplicitHeight = 373
      inherited cxGrid: TcxGrid
        Width = 448
        Height = 373
        ExplicitWidth = 448
        ExplicitHeight = 373
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
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
              Column = Amount
            end
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
          object GoodsCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName: TcxGridDBColumn [1]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 253
          end
          object Amount: TcxGridDBColumn [2]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          inherited colIsErased: TcxGridDBColumn
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
          end
        end
      end
      object cxGridChild: TcxGrid
        Left = 456
        Top = 0
        Width = 399
        Height = 373
        Align = alRight
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object chIsChecked: TcxGridDBColumn
            Caption = #1054#1090#1084#1077#1095#1077#1085
            DataBinding.FieldName = 'IsChecked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          object chUnitCode: TcxGridDBColumn
            AlternateCaption = 'chUnitCode'
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object chUnitName: TcxGridDBColumn
            AlternateCaption = 'UserName'
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 236
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter3: TcxSplitter
        Left = 448
        Top = 0
        Width = 8
        Height = 373
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salRight
        Control = cxGridChild
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 855
    Height = 93
    TabOrder = 3
    ExplicitWidth = 855
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
    object cxLabel5: TcxLabel
      Left = 367
      Top = 5
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1074#1099#1082#1083#1072#1076#1082#1080
    end
    object edLayout: TcxButtonEdit
      Left = 367
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 314
    end
    object edComment: TcxTextEdit
      Left = 8
      Top = 67
      Properties.ReadOnly = False
      TabOrder = 8
      Width = 673
    end
    object cxLabel7: TcxLabel
      Left = 8
      Top = 48
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object cbPharmacyItem: TcxCheckBox
      Left = 110
      Top = 46
      Hint = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1100#1089#1103' '#1080' '#1076#1083#1103' '#1072#1087#1090#1077#1095#1085#1099#1093' '#1087#1091#1085#1082#1090#1086#1074
      Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1100#1089#1103' '#1080' '#1076#1083#1103' '#1072#1087#1090#1077#1095#1085#1099#1093' '#1087#1091#1085#1082#1090#1086#1074
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      Width = 235
    end
    object cbNotMoveRemainder6: TcxCheckBox
      Left = 342
      Top = 46
      Hint = #1053#1077' '#1087#1077#1088#1077#1084#1077#1097#1072#1090#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1084#1077#1085#1077#1077' 6'
      Caption = #1053#1077' '#1087#1077#1088#1077#1084#1077#1097#1072#1090#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1084#1077#1085#1077#1077' 6 '#1084#1077#1089'.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      Width = 235
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
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_Child
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_Child
        end>
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_Child
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint_Loss
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Loss
        end>
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
    object actLoadDeferredCheck: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenChoiceDeferredCheck
        end
        item
          Action = actExecSPAddDeferredCheck
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1095#1077#1082
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1095#1077#1082
      ImageIndex = 29
    end
    object actOpenChoiceDeferredCheck: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenChoiceDeferredCheck'
      FormName = 'TChoiceDeferredCheckForm'
      FormNameParam.Value = 'TChoiceDeferredCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitID'
          Value = Null
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'CheckID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecSPAddDeferredCheck: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actExecSPAddDeferredCheck'
    end
    object actLoadSend: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenChoiceSend
        end
        item
          Action = actExecSPAddSend
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1072#1085#1080#1103
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1072#1085#1080#1103
      ImageIndex = 24
    end
    object actOpenChoiceSend: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenChoiceSend'
      FormName = 'TChoiceSendForm'
      FormNameParam.Value = 'TChoiceSendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitID'
          Value = Null
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'CheckID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecSPAddSend: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actExecSPAddSend'
    end
    object actInsertMaskMIMaster: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1057#1087#1080#1089#1072#1090#1100' '#1074#1077#1089#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1089' '#1090#1086#1095#1082#1080
      Hint = #1057#1087#1080#1089#1072#1090#1100' '#1074#1077#1089#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1089' '#1090#1086#1095#1082#1080
      ImageIndex = 30
      QuestionBeforeExecute = #1057#1087#1080#1089#1072#1090#1100' '#1074#1077#1089#1100' '#1086#1089#1090#1072#1090#1086#1082' '#1089' '#1090#1086#1095#1082#1080'?'
    end
    object macInsertByLayout: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actLayoutJournalChoiceForm
        end
        item
          Action = actInsertMaster
        end>
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1042#1099#1082#1083#1072#1076#1082#1080'?'
      InfoAfterExecute = #1058#1086#1074#1072#1088#1099' '#1079#1072#1087#1086#1083#1085#1077#1085#1099
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1042#1099#1082#1083#1072#1076#1082#1080
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1042#1099#1082#1083#1072#1076#1082#1080
      ImageIndex = 27
    end
    object actInsertMaster: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertByLayout
      StoredProcList = <
        item
          StoredProc = spInsertByLayout
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1042#1099#1082#1083#1072#1076#1082#1080
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1042#1099#1082#1083#1072#1076#1082#1080
      ImageIndex = 27
    end
    object actLayoutJournalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'LayoutJournalForm'
      ImageIndex = 27
      FormName = 'TLayoutJournalChoiceForm'
      FormNameParam.Value = 'TLayoutJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MovementId_mask'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumber_mask'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateChildDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = DetailDS
    end
    object actMISetErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetUnErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS
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
    StoredProcName = 'gpSelect_MovementItem_Layout'
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
          ItemName = 'bbInsertByLayout'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
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
    object bbComplete: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actLoadDeferredCheck
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actLoadSend
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actInsertMaskMIMaster
      Category = 0
    end
    object bbUpdateSummaFund: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1080#1079' '#1092#1086#1085#1076#1072
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1080#1079' '#1092#1086#1085#1076#1072
      Visible = ivAlways
      ImageIndex = 75
    end
    object bbInsertByLayout: TdxBarButton
      Action = macInsertByLayout
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarButton4: TdxBarButton
      Action = actMISetErasedChild
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actMISetUnErasedChild
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
    Left = 430
    Top = 249
  end
  inherited PopupMenu: TPopupMenu
    Left = 608
    Top = 216
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
        Name = 'ReportNameLoss'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLossTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLossBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaFundAvailable'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 352
  end
  inherited StatusGuides: TdsdGuides
    Left = 56
    Top = 24
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Layout'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 104
    Top = 8
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Layout'
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
        Name = 'LayoutId'
        Value = ''
        Component = GuidesLayout
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LayoutName'
        Value = ''
        Component = GuidesLayout
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'isPharmacyItem'
        Value = Null
        Component = cbPharmacyItem
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotMoveRemainder6'
        Value = Null
        Component = cbNotMoveRemainder6
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Layout'
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
        Name = 'inLayoutId'
        Value = ''
        Component = GuidesLayout
        ComponentItem = 'Key'
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
      end
      item
        Name = 'inisPharmacyItem'
        Value = Null
        Component = cbPharmacyItem
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotMoveRemainder6'
        Value = Null
        Component = cbNotMoveRemainder6
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
        Guides = GuidesLayout
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
        Control = edLayout
      end
      item
        Control = edComment
      end
      item
        Control = cbPharmacyItem
      end
      item
        Control = cbNotMoveRemainder6
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
    StoredProcName = 'gpMovementItem_Loss_SetErased'
    Left = 454
    Top = 360
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Loss_SetUnErased'
    Left = 462
    Top = 416
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Layout'
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Loss'
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
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
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
  object spSelectPrint_Loss: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Loss_Print'
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
    Left = 319
    Top = 208
  end
  object GuidesLayout: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLayout
    FormNameParam.Value = 'TLayoutForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLayoutForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLayout
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLayout
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 544
    Top = 16
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Layout'
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
  object spInsertByLayout: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_Layout_byLayout'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inMovementId_mask'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_mask'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 160
    Top = 448
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 760
    Top = 216
  end
  object DetailDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 712
    Top = 200
  end
  object spSelect_MovementItem_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_LayoutChild'
    DataSet = DetailDCS
    DataSets = <
      item
        DataSet = DetailDCS
      end>
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
      end>
    PackSize = 1
    Left = 720
    Top = 288
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_LayoutChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = DetailDCS
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
        Component = DetailDCS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChecked'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'IsChecked'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 712
    Top = 352
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 622
    Top = 384
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 534
    Top = 384
  end
  object DBViewAddOnChild: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 614
    Top = 273
  end
end
