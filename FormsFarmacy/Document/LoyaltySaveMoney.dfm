inherited LoyaltySaveMoneyForm: TLoyaltySaveMoneyForm
  Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1072#1103
  ClientHeight = 658
  ClientWidth = 1123
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 1139
  ExplicitHeight = 697
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 1123
    Height = 543
    ExplicitTop = 115
    ExplicitWidth = 1123
    ExplicitHeight = 543
    ClientRectBottom = 543
    ClientRectRight = 1123
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1123
      ExplicitHeight = 519
      inherited cxGrid: TcxGrid
        Width = 1123
        Height = 352
        ExplicitWidth = 1123
        ExplicitHeight = 352
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00; -,0.00; ;'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.00; -,0.00; ;'
              Kind = skSum
              Column = SummaUse
            end
            item
              Format = ',0.00; -,0.00; ;'
              Kind = skSum
              Column = SummaRemainder
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object BuyerPhone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'BuyerPhone'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceBuyer
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object BuyerName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'BuyerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1084#1086' '#1082#1086#1076
            Options.Editing = False
            Width = 150
          end
          object Amount: TcxGridDBColumn
            Caption = #1053#1072#1082#1086#1087#1083#1077#1085#1085#1072#1103' '#1089#1091#1084#1084#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; -,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummaUse: TcxGridDBColumn
            Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086
            DataBinding.FieldName = 'SummaUse'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; -,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object SummaRemainder: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'SummaRemainder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; -,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object sgComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 166
          end
          object sgUnitName: TcxGridDBColumn
            Caption = #1057#1086#1079#1076#1072#1085#1086' '#1072#1087#1090#1077#1082#1086#1081
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 123
          end
          object sgInsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object sgInsertdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
            DataBinding.FieldName = 'Insertdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object sgUpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object sgUpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 352
        Width = 1123
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
        Control = Panel1
      end
      object Panel1: TPanel
        Left = 0
        Top = 360
        Width = 1123
        Height = 159
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 2
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 552
          Height = 159
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel2'
          ShowCaption = False
          TabOrder = 0
          object cxGrid2: TcxGrid
            Left = 0
            Top = 0
            Width = 552
            Height = 159
            Align = alClient
            PopupMenu = PopupMenu
            TabOrder = 0
            object cxGridDBTableView2: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = SignDS
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <>
              DataController.Summary.SummaryGroups = <>
              OptionsBehavior.IncSearch = True
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsView.ColumnAutoWidth = True
              OptionsView.GroupByBox = False
              Styles.Content = dmMain.cxContentStyle
              Styles.Inactive = dmMain.cxSelection
              Styles.Selection = dmMain.cxSelection
              Styles.Footer = dmMain.cxFooterStyle
              Styles.Header = dmMain.cxHeaderStyle
              Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
              object MasterErased: TcxGridDBColumn
                DataBinding.FieldName = 'isErased'
                Visible = False
              end
              object SignAmount: TcxGridDBColumn
                Caption = #1054#1090' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1072
                DataBinding.FieldName = 'Amount'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 255
              end
              object SignChangePercent: TcxGridDBColumn
                Caption = #1055#1088#1086#1094#1077#1085#1090' '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1077
                DataBinding.FieldName = 'ChangePercent'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 276
              end
            end
            object cxGridLevel2: TcxGridLevel
              GridView = cxGridDBTableView2
            end
          end
        end
        object Panel3: TPanel
          Left = 560
          Top = 0
          Width = 563
          Height = 159
          Align = alRight
          BevelOuter = bvNone
          Caption = 'Panel3'
          ShowCaption = False
          TabOrder = 1
          object cxGrid3: TcxGrid
            Left = 0
            Top = 0
            Width = 563
            Height = 159
            Align = alClient
            PopupMenu = PopupMenu
            TabOrder = 0
            object cxGridDBTableView3: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = InfoDS
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <>
              DataController.Summary.SummaryGroups = <>
              OptionsBehavior.IncSearch = True
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsData.Editing = False
              OptionsData.Inserting = False
              OptionsView.ColumnAutoWidth = True
              OptionsView.Footer = True
              OptionsView.GroupByBox = False
              OptionsView.HeaderAutoHeight = True
              Styles.Content = dmMain.cxContentStyle
              Styles.Inactive = dmMain.cxSelection
              Styles.Selection = dmMain.cxSelection
              Styles.Footer = dmMain.cxFooterStyle
              Styles.Header = dmMain.cxHeaderStyle
              Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            end
            object cxGridLevel3: TcxGridLevel
              GridView = cxGridDBTableView3
            end
          end
        end
        object cxSplitter3: TcxSplitter
          Left = 552
          Top = 0
          Width = 8
          Height = 159
          Touch.ParentTabletOptions = False
          Touch.TabletOptions = [toPressAndHold]
          AlignSplitter = salRight
          Control = Panel3
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1123
    Height = 89
    TabOrder = 3
    ExplicitWidth = 1123
    ExplicitHeight = 89
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 108
      EditValue = 43060d
      ExplicitLeft = 108
    end
    inherited cxLabel2: TcxLabel
      Left = 108
      ExplicitLeft = 108
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 62
      ExplicitTop = 62
      ExplicitWidth = 200
      ExplicitHeight = 22
      Width = 200
    end
    object cxLabel7: TcxLabel
      Left = 225
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 225
      Top = 62
      Properties.ReadOnly = False
      TabOrder = 7
      Width = 397
    end
    object cxLabel10: TcxLabel
      Left = 862
      Top = 5
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
    end
    object edInsertName: TcxButtonEdit
      Left = 862
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 118
    end
    object cxLabel11: TcxLabel
      Left = 862
      Top = 45
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1082#1086#1088#1088'.'
    end
    object edUpdateName: TcxButtonEdit
      Left = 862
      Top = 62
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 118
    end
    object cxLabel13: TcxLabel
      Left = 986
      Top = 45
      Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
    end
    object edUpdateDate: TcxDateEdit
      Left = 986
      Top = 62
      EditValue = 42485d
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 120
    end
    object edEndSale: TcxDateEdit
      Left = 753
      Top = 62
      EditValue = 42485d
      TabOrder = 14
      Width = 100
    end
    object cxLabel4: TcxLabel
      Left = 751
      Top = 6
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1085#1072#1095'.'
    end
    object edStartSale: TcxDateEdit
      Left = 641
      Top = 62
      EditValue = 42485d
      TabOrder = 16
      Width = 100
    end
    object cxLabel5: TcxLabel
      Left = 639
      Top = 6
      Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1085#1072#1095'.'
    end
    object edEndPromo: TcxDateEdit
      Left = 753
      Top = 23
      EditValue = 42485d
      TabOrder = 18
      Width = 100
    end
    object edInsertdate: TcxDateEdit
      Left = 986
      Top = 23
      EditValue = 42485d
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 120
    end
    object edStartPromo: TcxDateEdit
      Left = 641
      Top = 23
      EditValue = 42485d
      TabOrder = 20
      Width = 100
    end
    object cxLabel12: TcxLabel
      Left = 982
      Top = 5
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
    end
    object cxLabel3: TcxLabel
      Left = 641
      Top = 45
      Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1087#1086#1075
    end
    object cxLabel6: TcxLabel
      Left = 753
      Top = 45
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1087#1086#1075'.'
    end
    object cxLabel19: TcxLabel
      Left = 225
      Top = 5
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
    end
    object edRetail: TcxButtonEdit
      Left = 225
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 25
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1088#1075#1086#1074#1091#1102' '#1089#1077#1090#1100'>'
      Width = 196
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 272
  end
  inherited ActionList: TActionList
    Left = 207
    Top = 319
    object spUpdateSignIsCheckedNo: TdsdExecStoredProc [0]
      Category = 'Checked'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1053#1077#1090
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1053#1077#1090
    end
    object actRefreshLoyaltySaveMoneyChild: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object spUpdateSignIsCheckedYes: TdsdExecStoredProc [2]
      Category = 'Checked'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1044#1072
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1044#1072
    end
    object actRefreshLoyaltySaveMoneyGoods: TdsdDataSetRefresh [3]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshLoyaltySaveMoneySign: TdsdDataSetRefresh [4]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPromoLoyaltySaveMoneySign
      StoredProcList = <
        item
          StoredProc = spSelectPromoLoyaltySaveMoneySign
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectPromoLoyaltySaveMoneySign
        end
        item
          StoredProc = spSelectLoyaltySaveMoneyInfo
        end>
    end
    object actSetErasedLoyaltySaveMoneySign: TdsdUpdateErased [7]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMISign
      StoredProcList = <
        item
          StoredProc = spErasedMISign
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1086#1090#1089#1091#1084#1084#1099' >'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1086#1090#1089#1091#1084#1084#1099'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = SignDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetErasedChild: TdsdUpdateErased [8]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1070#1088'.'#1083#1080#1094#1086'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1070#1088'.'#1083#1080#1094#1086'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actSetUnErasedLoyaltySaveMoneySign: TdsdUpdateErased [10]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpErasedMISign
      StoredProcList = <
        item
          StoredProc = spUpErasedMISign
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = SignDS
    end
    object actMISetUnErasedChild: TdsdUpdateErased [11]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
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
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectPromoLoyaltySaveMoneySign
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
    object dsdUpdateSignDS: TdsdUpdateDataSet [16]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateLoyaltySaveMoneySign
      StoredProcList = <
        item
          StoredProc = spInsertUpdateLoyaltySaveMoneySign
        end>
      Caption = 'actUpdateSignDS'
      DataSource = SignDS
    end
    object actUpdateChildDS: TdsdUpdateDataSet [17]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateChildDS'
    end
    object actDoLoad: TExecuteImportSettingsAction [18]
      Category = 'Load'
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
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
        end>
      ReportName = #1055#1088#1086#1076#1072#1078#1072
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Component = MasterCDS
          ComponentItem = 'BuyerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object JuridicalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalChoiceForm'
      FormName = 'TJuridical_Unit_ObjectForm'
      FormNameParam.Value = 'TJuridical_Unit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macInsertLoyaltySaveMoneySign: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
        end
        item
        end
        item
          Action = actRefreshLoyaltySaveMoneySign
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099'?'
      InfoAfterExecute = #1055#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099
      ImageIndex = 27
    end
    object actInsertUpdate_MovementItem_Promo_Set_Zero: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actInsertUpdate_MovementItem_Promo_Set_Zero'
    end
    object actGetImportSettingId: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSettingId'
    end
    object actChoiceBuyer: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TBuyerForm'
      FormNameParam.Value = 'TBuyerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BuyerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BuyerPhone'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BuyerCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Name'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BuyerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actBuyerEdit: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actBuyerEdit'
      ImageIndex = 1
      FormName = 'TBuyerEditForm'
      FormNameParam.Value = 'TBuyerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BuyerId'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_LoyaltySaveMoney'
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbSetErasedPromoPartner'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedPromoPartner'
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
    inherited bbMovementItemProtocol: TdxBarButton
      UnclickAfterDoing = False
    end
    object bbMISetErasedChild: TdxBarButton
      Action = actMISetErasedChild
      Category = 0
    end
    object bbMISetUnErasedChild: TdxBarButton
      Action = actMISetUnErasedChild
      Category = 0
    end
    object bbactStartLoad: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbInsertRecordChild: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' /'#1070#1088'. '#1083#1080#1094#1086'>'
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' /'#1070#1088'. '#1083#1080#1094#1086'>'
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbOpenReportForm: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1080#1093#1086#1076#1072'>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1080#1093#1086#1076#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072'>'
      Visible = ivAlways
      ImageIndex = 25
    end
    object bbInsertRecordPartner: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080'>'
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080'>'
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbSetErasedPromoPartner: TdxBarButton
      Action = actSetErasedLoyaltySaveMoneySign
      Category = 0
    end
    object bbSetUnErasedPromoPartner: TdxBarButton
      Action = actSetUnErasedLoyaltySaveMoneySign
      Category = 0
    end
    object bbInsertLoyaltySaveMoneySign: TdxBarButton
      Action = macInsertLoyaltySaveMoneySign
      Category = 0
    end
    object bbReportMinPriceForm: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1052#1080#1085'. '#1094#1077#1085#1072' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1077#1088#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075')>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1052#1080#1085'. '#1094#1077#1085#1072' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1077#1088#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075')>'
      Visible = ivAlways
      ImageIndex = 26
    end
    object bbOpenReportMinPrice_All: TdxBarButton
      Caption = #1048#1090#1086#1075#1080' '#1087#1086' '#1076#1085#1103#1084' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1095#1090#1080
      Category = 0
      Hint = #1048#1090#1086#1075#1080' '#1087#1086' '#1076#1085#1103#1084' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1095#1090#1080
      Visible = ivAlways
      ImageIndex = 24
    end
    object bbGoodsIsCheckedYes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbGoodsIsCheckedNo: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbChildIsCheckedNo: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbChildIsCheckedYes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbSignIsCheckedNo: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbSignIsCheckedYes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Visible = ivAlways
      ImageIndex = 76
    end
    object dxBarButton1: TdxBarButton
      Caption = #1057#1074#1103#1079#1072#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1089' '#1095#1077#1082#1086#1084
      Category = 0
      Hint = #1057#1074#1103#1079#1072#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1089' '#1095#1077#1082#1086#1084
      Visible = ivAlways
      ImageIndex = 29
    end
    object dxBarButton2: TdxBarButton
      Caption = #1054#1090#1095#1105#1090' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      Category = 0
      Hint = #1054#1090#1095#1105#1090' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      Visible = ivAlways
      ImageIndex = 26
    end
    object dxBarButton3: TdxBarButton
      Caption = #1054#1090#1095#1105#1090' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      Category = 0
      Hint = #1054#1090#1095#1105#1090' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      Visible = ivAlways
      ImageIndex = 25
    end
    object dxBarButton4: TdxBarButton
      Caption = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
      Category = 0
      Hint = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
      Visible = ivAlways
      ImageIndex = 52
    end
    object dxBarButton5: TdxBarButton
      Action = actBuyerEdit
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    SearchAsFilter = False
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
        Name = 'TotalCount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckID'
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = 42370d
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 42400d
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentUsed'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_LoyaltySaveMoney'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_LoyaltySaveMoney'
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
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
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
        Name = 'RetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartPromo'
        Value = 'NULL'
        Component = edStartPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndPromo'
        Value = 'NULL'
        Component = edEndPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartSale'
        Value = 'NULL'
        Component = edStartSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndSale'
        Value = 'NULL'
        Component = edEndSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertId'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Insertdate'
        Value = 'NULL'
        Component = edInsertdate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateId'
        Value = Null
        Component = GuidesUpdate
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = Null
        Component = GuidesUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = 'NULL'
        Component = edUpdateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 224
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_LoyaltySaveMoney'
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
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailID'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartPromo'
        Value = 'NULL'
        Component = edStartPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndPromo'
        Value = 'NULL'
        Component = edEndPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartSale'
        Value = 'NULL'
        Component = edStartSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndSale'
        Value = 'NULL'
        Component = edEndSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 202
    Top = 248
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesRetail
      end
      item
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
      end>
    Left = 288
    Top = 216
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
      end
      item
      end
      item
        Control = edComment
      end
      item
        Control = edEndPromo
      end
      item
        Control = edStartPromo
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 224
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 120
    Top = 320
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 550
    Top = 224
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 654
    Top = 248
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_LoyaltySaveMoney'
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
        Name = 'inBuyerID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BuyerID'
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
      end
      item
        Name = 'inUnitID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 328
    Top = 360
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 944
    Top = 192
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_TotalSumm'
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
        Name = 'TotalCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalCount'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPrimeCost'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSummPrimeCost'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 628
    Top = 172
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_SaleExactly_Print'
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
    Left = 495
    Top = 288
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 396
    Top = 302
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 396
    Top = 249
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPromoForm;zc_Object_ImportSetting_Promo'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 192
  end
  object SignDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 48
    Top = 488
  end
  object SignDS: TDataSource
    DataSet = SignDCS
    Left = 120
    Top = 488
  end
  object dsdDBViewAddOn2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = 0.000000000000000000
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    SearchAsFilter = False
    Left = 758
    Top = 273
  end
  object spSelectPromoLoyaltySaveMoneySign: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_LoyaltySaveMoneySign'
    DataSet = SignDCS
    DataSets = <
      item
        DataSet = SignDCS
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 560
  end
  object spInsertUpdateLoyaltySaveMoneySign: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_LoyaltySaveMoneySign'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = SignDCS
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
        Component = SignDCS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercent'
        Value = Null
        Component = SignDCS
        ComponentItem = 'ChangePercent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 96
    Top = 560
  end
  object spUpErasedMISign: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = SignDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = SignDCS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 444
    Top = 520
  end
  object GuidesInsert: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertName
    Key = '0'
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInsert
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 890
    Top = 6
  end
  object GuidesUpdate: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUpdateName
    Key = '0'
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesUpdate
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 890
    Top = 46
  end
  object spErasedMISign: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = SignDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = SignDCS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 520
  end
  object InfoDS: TDataSource
    DataSet = InfoDSD
    Left = 976
    Top = 496
  end
  object InfoDSD: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 896
    Top = 496
  end
  object spSelectLoyaltySaveMoneyInfo: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_LoyaltySaveMoneyInfo'
    DataSet = InfoDSD
    DataSets = <
      item
        DataSet = InfoDSD
      end>
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
    Left = 1008
    Top = 288
  end
  object spSelectPrintLoyaltySaveMoneyDay: TdsdStoredProc
    StoredProcName = 'gpReport_MovementItem_LoyaltySaveMoneySecondDay'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
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
    Left = 863
    Top = 248
  end
  object spSetLoyaltySaveMoneyCheck: TdsdStoredProc
    StoredProcName = 'gpMovementItem_LoyaltySaveMoneySign_LinkCheck'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = SignDCS
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCheckID'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1038
    Top = 224
  end
  object PrintTitleCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 396
    Top = 201
  end
  object dsdDBViewAddOn3: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView3
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'PercentUsed'
        Param.DataType = ftFloat
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 392
    Top = 56
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 16
  end
end
