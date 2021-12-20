inherited PretensionForm: TPretensionForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1077#1090#1077#1085#1079#1080#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'>'
  ClientHeight = 570
  ClientWidth = 1001
  ExplicitWidth = 1017
  ExplicitHeight = 609
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 108
    Width = 1001
    Height = 462
    ExplicitTop = 108
    ExplicitWidth = 1001
    ExplicitHeight = 462
    ClientRectBottom = 462
    ClientRectRight = 1001
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1001
      ExplicitHeight = 438
      inherited cxGrid: TcxGrid
        Width = 1001
        Height = 272
        ExplicitWidth = 1001
        ExplicitHeight = 272
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
              Format = ',0.00'
              Kind = skSum
              Column = Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountManual
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsAll
            end
            item
              Format = '+,0.###;-,0.###; ;'
              Kind = skSum
              Column = AmountDiff
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = AmountIncome
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
              Format = ',0.00'
              Kind = skSum
              Column = Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountManual
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsAll
            end
            item
              Format = '+,0.###;-,0.###; ;'
              Kind = skSum
              Column = AmountDiff
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = AmountIncome
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
          inherited colIsErased: TcxGridDBColumn
            VisibleForCustomization = False
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoods
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 222
          end
          object PartitionGoods: TcxGridDBColumn
            Caption = #1057#1077#1088#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartnerGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PartnerGoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object CheckedName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
            DataBinding.FieldName = 'CheckedName'
            PropertiesClassName = 'TcxComboBoxProperties'
            Properties.DropDownListStyle = lsFixedList
            Properties.Items.Strings = (
              #1040#1082#1090#1091#1072#1083#1100#1085#1072
              #1053#1077#1072#1082#1090#1091#1072#1083#1100#1085#1072)
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object ReasonDifferencesName: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103
            DataBinding.FieldName = 'ReasonDifferencesName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Summ: TcxGridDBColumn
            Caption = 'C'#1091#1084#1084#1072
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountIncome: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1090#1072#1074'.'
            DataBinding.FieldName = 'AmountIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object AmountManual: TcxGridDBColumn
            Caption = #1060#1072#1082#1090'. '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountManual'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object AmountDiff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = '+,0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object AmountInIncome: TcxGridDBColumn
            AlternateCaption = #1042' '#1087#1088#1080#1093#1086#1076#1077
            Caption = #1042' '#1087#1088#1080#1093#1086#1076#1077' '#1089#1077#1081#1095#1072#1089
            DataBinding.FieldName = 'AmountInIncome'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object WarningColor: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1086#1089#1090#1072#1090#1082#1072
            Caption = '!'
            DataBinding.FieldName = 'WarningColor'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1042#1086#1079#1074#1088#1072#1090' > '#1086#1089#1090#1072#1090#1082#1072
                ImageIndex = 59
                Value = 255
              end>
            Properties.ShowDescriptions = False
            Visible = False
            HeaderHint = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1086#1089#1090#1072#1090#1082#1072
            Options.Editing = False
            VisibleForCustomization = False
            Width = 20
          end
          object Remains: TcxGridDBColumn
            AlternateCaption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1072#1088#1090#1080#1080
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'Remains'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object RemainsAll: TcxGridDBColumn
            AlternateCaption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1072#1088#1090#1080#1080
            Caption = #1048#1090#1086#1075#1086' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'RemainsAll'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 272
        Width = 1001
        Height = 166
        Align = alBottom
        ShowCaption = False
        TabOrder = 1
        object Panel3: TPanel
          Left = 1
          Top = 1
          Width = 608
          Height = 164
          Align = alLeft
          ShowCaption = False
          TabOrder = 0
          object cxmComment: TcxMemo
            Left = 1
            Top = 22
            Align = alBottom
            TabOrder = 0
            Height = 141
            Width = 606
          end
          object cxLabel6: TcxLabel
            Left = 11
            Top = -1
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
          end
        end
        object Panel1: TPanel
          Left = 609
          Top = 1
          Width = 391
          Height = 164
          Align = alClient
          ShowCaption = False
          TabOrder = 1
          object cxGridFile: TcxGrid
            Left = 1
            Top = 22
            Width = 389
            Height = 141
            Align = alBottom
            PopupMenu = PopupMenu
            TabOrder = 0
            object cxGridDBTableViewFile: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = FileDS
              DataController.Filter.Options = [fcoCaseInsensitive]
              DataController.Summary.DefaultGroupSummaryItems = <
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
                  Format = ',0.00'
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
                  Format = '+,0.###;-,0.###; ;'
                  Kind = skSum
                end
                item
                  Format = ',0.####;-,0.####; ;'
                  Kind = skSum
                end>
              DataController.Summary.FooterSummaryItems = <
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
                  Kind = skSum
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
                  Format = ',0.####'
                  Kind = skSum
                end
                item
                  Format = ',0.####'
                  Kind = skSum
                end
                item
                  Format = '+,0.###;-,0.###; ;'
                  Kind = skSum
                end
                item
                  Format = ',0.####;-,0.####; ;'
                  Kind = skSum
                end>
              DataController.Summary.SummaryGroups = <>
              Images = dmMain.SortImageList
              OptionsBehavior.GoToNextCellOnEnter = True
              OptionsCustomize.ColumnHiding = True
              OptionsCustomize.ColumnsQuickCustomization = True
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsData.Inserting = False
              OptionsView.ColumnAutoWidth = True
              OptionsView.GroupByBox = False
              OptionsView.HeaderAutoHeight = True
              OptionsView.Indicator = True
              Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
              object chisErased: TcxGridDBColumn
                Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
                DataBinding.FieldName = 'isErased'
                Visible = False
                Options.Editing = False
                VisibleForCustomization = False
                Width = 50
              end
              object chNumber: TcxGridDBColumn
                Caption = #8470' '#1087'/'#1087
                DataBinding.FieldName = 'Number'
                PropertiesClassName = 'TcxButtonEditProperties'
                Properties.Buttons = <
                  item
                    Action = actChoiceGoods
                    Default = True
                    Kind = bkEllipsis
                  end>
                Properties.ReadOnly = True
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 56
              end
              object chisAct: TcxGridDBColumn
                Caption = #1040#1082#1090
                DataBinding.FieldName = 'isAct'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 43
              end
              object chFileName: TcxGridDBColumn
                Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1092#1072#1081#1083#1072
                DataBinding.FieldName = 'FileName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 276
              end
            end
            object cxGridLevelV: TcxGridLevel
              GridView = cxGridDBTableViewFile
            end
          end
          object cxLabel8: TcxLabel
            Left = 5
            Top = 0
            Caption = #1055#1088#1080#1082#1088#1077#1087#1083#1077#1085#1085#1099#1077' '#1092#1072#1081#1083#1099
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1001
    Height = 82
    TabOrder = 3
    ExplicitWidth = 1001
    ExplicitHeight = 82
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 22
      Properties.ReadOnly = False
      ExplicitLeft = 8
      ExplicitTop = 22
      ExplicitWidth = 105
      Width = 105
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 114
      Top = 22
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 114
      ExplicitTop = 22
    end
    inherited cxLabel2: TcxLabel
      Left = 114
      ExplicitLeft = 114
    end
    inherited cxLabel15: TcxLabel
      Top = 40
      ExplicitTop = 40
    end
    inherited ceStatus: TcxButtonEdit
      Top = 58
      TabOrder = 7
      ExplicitTop = 58
      ExplicitWidth = 136
      ExplicitHeight = 22
      Width = 136
    end
    object cxLabel3: TcxLabel
      Left = 226
      Top = 5
      Caption = #1070#1088'. '#1083#1080#1094#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082
    end
    object edFrom: TcxButtonEdit
      Left = 456
      Top = 22
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 246
    end
    object edTo: TcxButtonEdit
      Left = 228
      Top = 22
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 222
    end
    object cxLabel4: TcxLabel
      Left = 456
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 456
      Top = 42
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 130
    end
    object cxLabel10: TcxLabel
      Left = 364
      Top = 40
      Caption = #1058#1080#1087' '#1053#1044#1057
    end
    object edNDSKind: TcxButtonEdit
      Left = 364
      Top = 59
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 86
    end
    object cxLabel5: TcxLabel
      Left = 152
      Top = 40
      Caption = #8470' '#1087#1088#1080#1093#1086#1076#1072
    end
    object cxLabel12: TcxLabel
      Left = 708
      Top = 5
      Caption = #1070#1088#1083#1080#1094#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100
    end
    object edJuridical: TcxButtonEdit
      Left = 708
      Top = 22
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 154
    end
    object cxLabel13: TcxLabel
      Left = 263
      Top = 40
      Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072
    end
    object deIncomeOperDate: TcxDateEdit
      Left = 258
      Top = 59
      EditValue = 42363d
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 17
      Width = 100
    end
    object cbisDeferred: TcxCheckBox
      Left = 456
      Top = 61
      Caption = #1054#1090#1083#1086#1078#1077#1085
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 69
    end
    object edIncome: TcxTextEdit
      Left = 152
      Top = 59
      Enabled = False
      Properties.ReadOnly = False
      TabOrder = 19
      Width = 105
    end
    object deBranchDate: TcxDateEdit
      Left = 592
      Top = 59
      EditValue = 42363d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 20
      Width = 100
    end
    object cxLabel7: TcxLabel
      Left = 592
      Top = 42
      Caption = #1044#1072#1090#1072' '#1079#1072#1082#1088#1099#1090#1080#1103' ('#1088#1077#1096#1077#1085#1080#1103')'
    end
    object deGoodsReceiptsDate: TcxDateEdit
      Left = 735
      Top = 59
      EditValue = 42363d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 22
      Width = 100
    end
    object cxLabel9: TcxLabel
      Left = 735
      Top = 42
      Hint = #1044#1072#1090#1072' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103' '#1090#1086#1074#1072#1088#1072' '#1082' '#1085#1072#1084' '#1085#1072' '#1089#1082#1083#1072#1076
      Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103' '#1090#1086#1074#1072#1088#1072
    end
    object deSentDate: TcxDateEdit
      Left = 868
      Top = 22
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 24
      Width = 126
    end
    object cxLabel11: TcxLabel
      Left = 868
      Top = 5
      Caption = #1044#1072#1090#1072' '#1087#1086#1076#1072#1095#1080' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
    Top = 416
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
    Left = 32
    Top = 432
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      AfterAction = actSetEnabled
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
          StoredProc = spSelectFile
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1040#1082#1090#1072' '#1087#1086' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1040#1082#1090#1072' '#1087#1086' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = ''
      ReportNameParam.Value = nil
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ActName'
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
    object actChoiceGoods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoods'
      FormName = 'TGoodsLiteForm'
      FormNameParam.Value = 'TGoodsLiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    object actPartnerDataDialog: TExecuteDialog
      Category = 'PartnerData'
      MoveParams = <>
      Caption = 'actPartnerDataDialog'
      FormName = 'TPretensionPartnerDataDialogForm'
      FormNameParam.Value = 'TPretensionPartnerDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumberPartner'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumberPartner'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartner'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDatePartner'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AdjustingOurDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'AdjustingOurDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
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
    object spUpdateisDeferredYes: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_Yes
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      ImageIndex = 79
    end
    object spUpdateisDeferredNo: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_No
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      ImageIndex = 52
    end
    object actDataChoiceDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDataChoiceDialog'
      FormName = 'TDataChoiceDialogForm'
      FormNameParam.Value = 'TDataChoiceDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'OperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'BranchDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1044#1072#1090#1072' '#1079#1072#1082#1088#1099#1090#1080#1103' ('#1088#1077#1096#1077#1085#1080#1103') '#1087#1088#1077#1090#1077#1085#1079#1080#1080
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_BranchDate: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      BeforeAction = actDataChoiceDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_BranchDate
      StoredProcList = <
        item
          StoredProc = spUpdate_BranchDate
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091' '#1079#1072#1082#1088#1099#1090#1080#1103' ('#1088#1077#1096#1077#1085#1080#1103')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091' '#1079#1072#1082#1088#1099#1090#1080#1103' ('#1088#1077#1096#1077#1085#1080#1103')'
      ImageIndex = 35
    end
    object actUpdate_ClearBranchDate: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ClearBranchDate
      StoredProcList = <
        item
          StoredProc = spUpdate_ClearBranchDate
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1090#1091' '#1079#1072#1082#1088#1099#1090#1080#1103' ('#1088#1077#1096#1077#1085#1080#1103')'
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1090#1091' '#1079#1072#1082#1088#1099#1090#1080#1103' ('#1088#1077#1096#1077#1085#1080#1103')'
      ImageIndex = 77
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1090#1091' '#1079#1072#1082#1088#1099#1090#1080#1103' ('#1088#1077#1096#1077#1085#1080#1103')?'
    end
    object actRefreshFile: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectFile
      StoredProcList = <
        item
          StoredProc = spSelectFile
        end>
      Caption = 'actRefreshFile'
    end
    object actOpenFileDialog: TFileDialogAction
      Category = 'DSDLib'
      MoveParams = <>
      FileOpenDialog.FavoriteLinks = <>
      FileOpenDialog.FileTypes = <>
      FileOpenDialog.Options = []
      Param.Value = Null
      Param.Component = FormParams
      Param.ComponentItem = 'FileName'
      Param.DataType = ftString
      Param.MultiSelectSeparator = ','
    end
    object actGetFTPParams: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetFTPParams
      StoredProcList = <
        item
          StoredProc = spGetFTPParams
        end>
      Caption = 'actRefreshFile'
    end
    object actSendFTPFile: TdsdFTP
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshFile
      BeforeAction = actGetFTPParams
      HostParam.Value = ''
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'FtpHost'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = 21
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'FtpPort'
      PortParam.MultiSelectSeparator = ','
      UsernameParam.Value = ''
      UsernameParam.Component = FormParams
      UsernameParam.ComponentItem = 'FtpUsername'
      UsernameParam.DataType = ftString
      UsernameParam.MultiSelectSeparator = ','
      PasswordParam.Value = ''
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'FtpPassword'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DirParam.Value = ''
      DirParam.Component = FormParams
      DirParam.ComponentItem = 'FtpDir'
      DirParam.DataType = ftString
      DirParam.MultiSelectSeparator = ','
      FullFileNameParam.Value = ''
      FullFileNameParam.Component = FormParams
      FullFileNameParam.ComponentItem = 'FileName'
      FullFileNameParam.DataType = ftString
      FullFileNameParam.MultiSelectSeparator = ','
      FileNameFTPParam.Value = ''
      FileNameFTPParam.Component = FormParams
      FileNameFTPParam.ComponentItem = 'FtpFileName'
      FileNameFTPParam.DataType = ftString
      FileNameFTPParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      DownloadFolderParam.Value = ''
      DownloadFolderParam.Component = FormParams
      DownloadFolderParam.DataType = ftString
      DownloadFolderParam.MultiSelectSeparator = ','
      Caption = 'actSendFTPFile'
    end
    object actAddFile: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'FileId'
          ToParam.MultiSelectSeparator = ','
        end>
      AfterAction = actSendFTPFile
      BeforeAction = actOpenFileDialog
      PostDataSetBeforeExecute = False
      StoredProc = spAddFile
      StoredProcList = <
        item
          StoredProc = spAddFile
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1072#1081#1083' '#1074' '#1087#1088#1077#1090#1077#1085#1079#1080#1102
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1072#1081#1083' '#1074' '#1087#1088#1077#1090#1077#1085#1079#1080#1102
      ImageIndex = 54
    end
    object actUpdateFile: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actSendFTPFile
      BeforeAction = actOpenFileDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateFile
      StoredProcList = <
        item
          StoredProc = spUpdateFile
        end>
      Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1092#1072#1081#1083' '#1074' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
      Hint = #1047#1072#1084#1077#1085#1080#1090#1100' '#1092#1072#1081#1083' '#1074' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
      ImageIndex = 80
    end
    object actOpenFile: TdsdFTP
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshFile
      BeforeAction = actGetFTPParams
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'FtpHost'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'FtpPort'
      PortParam.MultiSelectSeparator = ','
      UsernameParam.Value = ''
      UsernameParam.Component = FormParams
      UsernameParam.ComponentItem = 'FtpUsername'
      UsernameParam.DataType = ftString
      UsernameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'FtpPassword'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DirParam.Value = Null
      DirParam.Component = FormParams
      DirParam.ComponentItem = 'FtpDir'
      DirParam.DataType = ftString
      DirParam.MultiSelectSeparator = ','
      FullFileNameParam.Value = Null
      FullFileNameParam.DataType = ftString
      FullFileNameParam.MultiSelectSeparator = ','
      FileNameFTPParam.Value = Null
      FileNameFTPParam.Component = FileCDS
      FileNameFTPParam.ComponentItem = 'FileNameFTP'
      FileNameFTPParam.DataType = ftString
      FileNameFTPParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.Component = FileCDS
      FileNameParam.ComponentItem = 'FileName'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      DownloadFolderParam.Value = ''
      DownloadFolderParam.Component = FileCDS
      DownloadFolderParam.ComponentItem = 'FolderTMP'
      DownloadFolderParam.DataType = ftString
      DownloadFolderParam.MultiSelectSeparator = ','
      FTPOperation = ftpDownloadAndRun
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1072#1081#1083' '#1080' '#1086#1090#1082#1088#1099#1090#1100' '#1076#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1072#1081#1083' '#1080' '#1086#1090#1082#1088#1099#1090#1100' '#1076#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
      ImageIndex = 60
    end
    object actErasedMIFile: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIFile
      StoredProcList = <
        item
          StoredProc = spErasedMIFile
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1060#1072#1081#1083' '#1080#1079' '#1087#1088#1077#1090#1077#1085#1079#1080#1080'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1060#1072#1081#1083' '#1080#1079' '#1087#1088#1077#1090#1077#1085#1079#1080#1080'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = FileDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actUnErasedMIFile: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIFile
      StoredProcList = <
        item
          StoredProc = spUnErasedMIFile
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
      DataSource = FileDS
    end
    object MovementItemProtocolFileOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1087#1088#1080#1082#1088#1077#1087#1083#1077#1085#1085#1099#1093' '#1092#1072#1081#1083#1086#1074'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1087#1088#1080#1082#1088#1077#1087#1083#1077#1085#1085#1099#1093' '#1092#1072#1081#1083#1086#1074'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FileCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = FileCDS
          ComponentItem = 'FileName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGetData: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetData
      StoredProcList = <
        item
          StoredProc = spGetData
        end>
      Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1092#1072#1081#1083' '#1074' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
      Hint = #1047#1072#1084#1077#1085#1080#1090#1100' '#1092#1072#1081#1083' '#1074' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
      ImageIndex = 80
    end
    object actSendClipboard: TdsdSendClipboardAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actGetData
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1072#1082#1090#1091' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1072#1082#1090#1091' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 31
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1072#1082#1090#1091' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
      TextParam.Value = ''
      TextParam.Component = FormParams
      TextParam.ComponentItem = 'TextClipbord'
      TextParam.DataType = ftWideString
      TextParam.MultiSelectSeparator = ','
    end
    object actInsert_ReturnOut: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actOpenReturnOut
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_ReturnOut
      StoredProcList = <
        item
          StoredProc = spInsert_ReturnOut
        end>
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1074#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1074#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      ImageIndex = 27
      QuestionBeforeExecute = #1057#1086#1079#1076#1072#1090#1100' '#1074#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'?'
    end
    object actOpenReturnOut: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actGet_ReturnOutId
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1074#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      ImageIndex = 29
      FormName = 'TReturnOutForm'
      FormNameParam.Value = 'TReturnOutForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'ReturnOutId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGet_ReturnOutId: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_ReturnOutId
      StoredProcList = <
        item
          StoredProc = spGet_ReturnOutId
        end>
      Caption = 'actGet_ReturnOutId'
      Hint = 'actGet_ReturnOutId'
    end
    object actGetFileFTP: TdsdFTP
      Category = 'DSDLib'
      MoveParams = <>
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'FtpHost'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'FtpPort'
      PortParam.MultiSelectSeparator = ','
      UsernameParam.Value = Null
      UsernameParam.Component = FormParams
      UsernameParam.ComponentItem = 'FtpUsername'
      UsernameParam.DataType = ftString
      UsernameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'FtpPassword'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DirParam.Value = Null
      DirParam.Component = FormParams
      DirParam.ComponentItem = 'FtpDir'
      DirParam.DataType = ftString
      DirParam.MultiSelectSeparator = ','
      FullFileNameParam.Value = Null
      FullFileNameParam.Component = FileCDS
      FullFileNameParam.ComponentItem = 'FileNameDownload'
      FullFileNameParam.DataType = ftString
      FullFileNameParam.MultiSelectSeparator = ','
      FileNameFTPParam.Value = ''
      FileNameFTPParam.Component = FileCDS
      FileNameFTPParam.ComponentItem = 'FileNameFTP'
      FileNameFTPParam.DataType = ftString
      FileNameFTPParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.Component = FileCDS
      FileNameParam.ComponentItem = 'FileName'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      DownloadFolderParam.Value = ''
      DownloadFolderParam.Component = FileCDS
      DownloadFolderParam.ComponentItem = 'FolderTMP'
      DownloadFolderParam.DataType = ftString
      DownloadFolderParam.MultiSelectSeparator = ','
      FTPOperation = ftpDownload
      Caption = 'actGetFileFTP'
    end
    object mactGetAllFileFTP: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actGetFTPParams
      ActionList = <
        item
          Action = actGetFileFTP
        end>
      View = cxGridDBTableViewFile
      Caption = 'mactGetAllFileFTP'
    end
    object actGetDocumentDataForEmail: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDocumentDataForEmail
      StoredProcList = <
        item
          StoredProc = spGetDocumentDataForEmail
        end>
      Caption = 'actGetDocumentDataForEmail'
    end
    object actSMTPMultipleFile: TdsdSMTPMultipleFileAction
      Category = 'DSDLib'
      MoveParams = <>
      Host.Value = Null
      Host.Component = FormParams
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.Component = FormParams
      Port.ComponentItem = 'Port'
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.Component = FormParams
      UserName.ComponentItem = 'UserName'
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.Component = FormParams
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.Component = FormParams
      Body.ComponentItem = 'Body'
      Body.DataType = ftWideString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.Component = FormParams
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.Component = FormParams
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.Component = FormParams
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.MultiSelectSeparator = ','
      FieldFileName.Value = 'FileNameDownload'
      FieldFileName.DataType = ftString
      FieldFileName.MultiSelectSeparator = ','
      DataSet = FileCDS
    end
    object mactSMTPSend: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetDocumentDataForEmail
        end
        item
          Action = mactGetAllFileFTP
        end
        item
          Action = actSMTPMultipleFile
        end
        item
          Action = actUpdate_SentDate
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1086#1090#1089#1083#1099#1082#1077' E-mail?'
      InfoAfterExecute = 'E-mail '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1086#1090#1087#1088#1072#1074#1083#1077#1085
      Caption = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail'
      Hint = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail'
      ImageIndex = 53
    end
    object actGoodsReceiptsDataChoiceDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actGoodsReceiptsDataChoiceDialog'
      FormName = 'TDataChoiceDialogForm'
      FormNameParam.Value = 'TDataChoiceDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'OperDate'
          Value = 44541d
          Component = FormParams
          ComponentItem = 'GoodsReceiptsDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1044#1072#1090#1072' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103' '#1090#1086#1074#1072#1088#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_GoodsReceiptsDate: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      BeforeAction = actGoodsReceiptsDataChoiceDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_GoodsReceiptsDate
      StoredProcList = <
        item
          StoredProc = spUpdate_GoodsReceiptsDate
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103' '#1090#1086#1074#1072#1088#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 67
    end
    object actPrintToFile: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1040#1082#1090#1072' '#1087#1086' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1040#1082#1090#1072' '#1087#1086' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'frxPDFExport_find'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'frxPDFExport1_ShowDialog'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'ExportDirectory'
          Value = Null
          Component = FormParams
          ComponentItem = 'ActExportDir'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FileNameExport'
          Value = Null
          Component = FormParams
          ComponentItem = 'ActExportName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ActName'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actInsertUpdateFileAct: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateFileAct
      StoredProcList = <
        item
          StoredProc = spInsertUpdateFileAct
        end>
      Caption = 'actInsertUpdateFileAct'
    end
    object actSendFTPFileAct: TdsdFTP
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actGetFTPParams
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'FtpHost'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'FtpPort'
      PortParam.MultiSelectSeparator = ','
      UsernameParam.Value = Null
      UsernameParam.Component = FormParams
      UsernameParam.ComponentItem = 'FtpUsername'
      UsernameParam.DataType = ftString
      UsernameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'FtpPassword'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DirParam.Value = Null
      DirParam.Component = FormParams
      DirParam.ComponentItem = 'FtpDir'
      DirParam.DataType = ftString
      DirParam.MultiSelectSeparator = ','
      FullFileNameParam.Value = Null
      FullFileNameParam.Component = FormParams
      FullFileNameParam.ComponentItem = 'ActFileName'
      FullFileNameParam.DataType = ftString
      FullFileNameParam.MultiSelectSeparator = ','
      FileNameFTPParam.Value = Null
      FileNameFTPParam.Component = FormParams
      FileNameFTPParam.ComponentItem = 'FtpFileName'
      FileNameFTPParam.DataType = ftString
      FileNameFTPParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      DownloadFolderParam.Value = ''
      DownloadFolderParam.Component = FormParams
      DownloadFolderParam.DataType = ftString
      DownloadFolderParam.MultiSelectSeparator = ','
      Caption = 'actSendFTPFileAct'
    end
    object actUpdate_SentDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SentDate
      StoredProcList = <
        item
          StoredProc = spUpdate_SentDate
        end>
      Caption = 'actUpdate_SentDate'
    end
    object mactPrintToFile: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrintToFile
        end
        item
          Action = actInsertUpdateFileAct
        end
        item
          Action = actSendFTPFileAct
        end
        item
          Action = actRefreshFile
        end>
      QuestionBeforeExecute = 'C'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1040#1082#1090' '#1087#1086' '#1087#1088#1077#1090#1077#1085#1079#1080#1080' '#1080' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077' '#1077#1075#1086' '#1082' '#1092#1072#1081#1083#1072#1084'?'
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1040#1082#1090#1072' '#1087#1086' '#1087#1088#1077#1090#1077#1085#1079#1080#1080' '#1080' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077' '#1077#1075#1086' '#1082' '#1092#1072#1081#1083#1072#1084
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1040#1082#1090#1072' '#1087#1086' '#1087#1088#1077#1090#1077#1085#1079#1080#1080' '#1080' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077' '#1077#1075#1086' '#1082' '#1092#1072#1081#1083#1072#1084
      ImageIndex = 30
    end
    object actSetEnabled: TdsdSetEnabledAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetEnabled'
      SetEnabledParams = <
        item
          Component = ceStatus
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actComplete
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = mactPrintToFile
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = deSentDate
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = edInvNumber
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = edOperDate
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actUpdate_BranchDate
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actUpdate_ClearBranchDate
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = spUpdateisDeferredYes
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = spUpdateisDeferredNo
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actSendClipboard
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actInsert_ReturnOut
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actOpenReturnOut
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = mactSMTPSend
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = cbisDeferred
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = deBranchDate
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isMeneger'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource
    Left = 280
    Top = 192
  end
  inherited MasterCDS: TClientDataSet
    Left = 344
    Top = 192
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Pretension'
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
    Left = 48
    Top = 191
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
          ItemName = 'dxBarButton2'
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
          ItemName = 'dxBarButton13'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_GoodsReceiptsDate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
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
          ItemName = 'dxBarButton3'
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
          ItemName = 'dxBarButton12'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert_ReturnOut'
        end
        item
          Visible = True
          ItemName = 'bbOpenReturnOut'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSMTPSend'
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
          BeginGroup = True
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
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Width = 15
    end
    object bbPrintTTN: TdxBarButton [5]
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Visible = ivAlways
      ImageIndex = 18
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
    inherited bbStatic: TdxBarStatic
      Width = 15
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
    object bbRefreshGoodsCode: TdxBarButton
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1082#1086#1076#1086#1074
      Category = 0
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton1: TdxBarButton
      Action = actUpdate_BranchDate
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = spUpdateisDeferredYes
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = spUpdateisDeferredNo
      Category = 0
    end
    object bbPrintOptima: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1087#1090#1080#1084#1072
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1087#1090#1080#1084#1072
      Visible = ivAlways
      ImageIndex = 17
    end
    object dxBarButton5: TdxBarButton
      Action = actUpdate_ClearBranchDate
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actAddFile
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actUpdateFile
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actOpenFile
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = actErasedMIFile
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = actUnErasedMIFile
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = MovementItemProtocolFileOpenForm
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = actSendClipboard
      Category = 0
    end
    object bbInsert_ReturnOut: TdxBarButton
      Action = actInsert_ReturnOut
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object bbOpenReturnOut: TdxBarButton
      Action = actOpenReturnOut
      Category = 0
    end
    object bbSMTPSend: TdxBarButton
      Action = mactSMTPSend
      Category = 0
    end
    object bbUpdate_GoodsReceiptsDate: TdxBarButton
      Action = actUpdate_GoodsReceiptsDate
      Category = 0
    end
    object dxBarButton13: TdxBarButton
      Action = mactPrintToFile
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ValueColumn = WarningColor
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 502
    Top = 385
  end
  inherited PopupMenu: TPopupMenu
    Left = 632
    Top = 432
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
        Name = 'ActName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FileName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FileId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextClipbord'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeMovementId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'FtpHost'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FtpPort'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'FtpUsername'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FtpPassword'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FtpDir'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FtpFileName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnOutId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Body'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressFrom'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressTo'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Subject'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Host'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsReceiptsDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ActExportDir'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ActExportName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMeneger'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 416
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 24
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Pretension'
    Left = 32
    Top = 24
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Pretension'
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
        Name = 'PriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDeferred'
        Value = Null
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeInvNumber'
        Value = Null
        Component = edIncome
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeMovementId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeOperDate'
        Value = Null
        Component = deIncomeOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = cxmComment
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchDate'
        Value = Null
        Component = deBranchDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsReceiptsDate'
        Value = Null
        Component = deGoodsReceiptsDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SentDate'
        Value = Null
        Component = deSentDate
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ActName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ActName'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ActExportDir'
        Value = Null
        Component = FormParams
        ComponentItem = 'ActExportDir'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ActExportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ActExportName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ActFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ActFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMeneger'
        Value = Null
        Component = FormParams
        ComponentItem = 'isMeneger'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Pretension'
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
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'IncomeMovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = cxmComment
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    Left = 120
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
        Control = edNDSKind
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = cxmComment
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 200
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 904
    Top = 384
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Pretension_SetErased'
    Left = 622
    Top = 336
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Pretension_SetUnErased'
    Left = 622
    Top = 280
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Pretension'
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
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ParentId'
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
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReasonDifferencesId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReasonDifferencesId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountIncome'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountIncome'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManual'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountManual'
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
        Name = 'inCheckedName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CheckedName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outRemains'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWarningColor'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WarningColor'
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
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
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 344
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Summ'
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
        Name = 'TotalSummMVAT'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPVAT'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 396
    Top = 276
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 368
    Top = 400
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 500
    Top = 281
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 500
    Top = 334
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Pretension_Print'
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
    Left = 295
    Top = 272
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    Key = '0'
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 32
  end
  object NDSKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edNDSKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TNDSKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TNDSKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 136
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 112
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Pretension'
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
        Value = 42951d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 352
  end
  object spUpdate_isDeferred_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Pretension_Deferred'
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
        Name = 'inisDeferred'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 888
    Top = 323
  end
  object spUpdate_isDeferred_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Pretension_Deferred'
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
        Name = 'inisDeferred'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = False
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 275
  end
  object spUpdate_BranchDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Pretension_BranchDate'
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
        Name = 'inBranchDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'BranchDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBranchDate'
        Value = Null
        Component = deBranchDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 347
  end
  object spUpdate_ClearBranchDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Pretension_ClearBranchDate'
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
        Name = 'outBranchDate'
        Value = Null
        Component = deBranchDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 387
  end
  object FileCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 848
    Top = 192
  end
  object FileDS: TDataSource
    DataSet = FileCDS
    Left = 768
    Top = 192
  end
  object DBViewAddOnFile: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewFile
    OnDblClickActionList = <
      item
        Action = actOpenFile
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
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
    PropertiesCellList = <>
    Left = 638
    Top = 497
  end
  object spSelectFile: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PretensionFile'
    DataSet = FileCDS
    DataSets = <
      item
        DataSet = FileCDS
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
    Left = 712
    Top = 184
  end
  object spAddFile: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Pretension_AddFile'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'FileId'
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
        Name = 'inFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileNameFTP'
        Value = Null
        Component = FormParams
        ComponentItem = 'FtpFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 187
  end
  object spUpdateFile: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Pretension_AddFile'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FileCDS
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
        Name = 'inFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileNameFTP'
        Value = Null
        Component = FormParams
        ComponentItem = 'FtpFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 243
  end
  object spErasedMIFile: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PretensionFile_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = FileCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = FileCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 622
    Top = 232
  end
  object spUnErasedMIFile: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PretensionFile_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = FileCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = FileCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 622
    Top = 176
  end
  object spGetData: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Pretension_Data'
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
        Name = 'outDataAct'
        Value = ''
        Component = FormParams
        ComponentItem = 'TextClipbord'
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 440
    Top = 192
  end
  object spGetFTPParams: TdsdStoredProc
    StoredProcName = 'gpSelect_PretensionFTPParams'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inInvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outHost'
        Value = Null
        Component = FormParams
        ComponentItem = 'FtpHost'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPort'
        Value = Null
        Component = FormParams
        ComponentItem = 'FtpPort'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUsername'
        Value = Null
        Component = FormParams
        ComponentItem = 'FtpUsername'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPassword'
        Value = Null
        Component = FormParams
        ComponentItem = 'FtpPassword'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDir'
        Value = Null
        Component = FormParams
        ComponentItem = 'FtpDir'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 192
  end
  object spInsert_ReturnOut: TdsdStoredProc
    StoredProcName = 'gpInsert_Pretension_ReturnOut'
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
      end>
    PackSize = 1
    Left = 712
    Top = 243
  end
  object spGet_ReturnOutId: TdsdStoredProc
    StoredProcName = 'gpGet_Pretension_ReturnOut'
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
        Name = 'outReturnOutId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnOutId'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 299
  end
  object spGetDocumentDataForEmail: TdsdStoredProc
    StoredProcName = 'gpGet_Pretension_DataForEmail'
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
        Name = 'Subject'
        Value = Null
        Component = FormParams
        ComponentItem = 'Subject'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Body'
        Value = Null
        Component = FormParams
        ComponentItem = 'Body'
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressFrom'
        Value = Null
        Component = FormParams
        ComponentItem = 'AddressFrom'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressTo'
        Value = Null
        Component = FormParams
        ComponentItem = 'AddressTo'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Host'
        Value = Null
        Component = FormParams
        ComponentItem = 'Host'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = Null
        Component = FormParams
        ComponentItem = 'Port'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'Password'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 456
  end
  object spUpdate_GoodsReceiptsDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Pretension_GoodsReceiptsDate'
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
        Name = 'inGoodsReceiptsDate'
        Value = 44541d
        Component = FormParams
        ComponentItem = 'GoodsReceiptsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsReceiptsDate'
        Value = 42363d
        Component = deGoodsReceiptsDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 467
  end
  object spInsertUpdateFileAct: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Pretension_AddFileAct'
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
        Name = 'inFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ActFileName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileNameFTP'
        Value = Null
        Component = FormParams
        ComponentItem = 'FtpFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 507
  end
  object spUpdate_SentDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Pretension_SentDate'
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
      end>
    PackSize = 1
    Left = 336
    Top = 483
  end
end
