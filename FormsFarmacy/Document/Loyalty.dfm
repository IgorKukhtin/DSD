inherited LoyaltyForm: TLoyaltyForm
  Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080
  ClientHeight = 658
  ClientWidth = 1125
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 1141
  ExplicitHeight = 697
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 153
    Width = 1125
    Height = 505
    ExplicitTop = 153
    ExplicitWidth = 1125
    ExplicitHeight = 505
    ClientRectBottom = 505
    ClientRectRight = 1125
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1125
      ExplicitHeight = 481
      inherited cxGrid: TcxGrid
        Width = 1125
        Height = 263
        ExplicitWidth = 1125
        ExplicitHeight = 263
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DataSource = SignDS
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00; -,0.00; ;'
              Kind = skSum
              Column = sqTotalSumm_CheckSale
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object sgGUID: TcxGridDBColumn
            Caption = #1055#1088#1086#1084#1086' '#1082#1086#1076
            DataBinding.FieldName = 'GUID'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1084#1086' '#1082#1086#1076
            Options.Editing = False
            Width = 150
          end
          object sgOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object sgAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object sgUnitName: TcxGridDBColumn
            Caption = #1057#1086#1079#1076#1072#1085#1086' '#1072#1087#1090#1077#1082#1086#1081
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 144
          end
          object sgInvnumber_Check: TcxGridDBColumn
            Caption = #8470' '#1095#1077#1082#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'Invnumber_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object sgOperDate_Check: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1095#1077#1082#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'OperDate_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object sgUnitName_Check: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072' ('#1095#1077#1082' '#1089#1086#1079#1076#1072#1085#1080#1103')'
            DataBinding.FieldName = 'UnitName_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object sqInvnumber_CheckSale: TcxGridDBColumn
            Caption = #8470' '#1095#1077#1082#1072' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
            DataBinding.FieldName = 'Invnumber_CheckSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object sqOperDate_CheckSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1095#1077#1082#1072' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
            DataBinding.FieldName = 'OperDate_CheckSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object sqTotalSumm_CheckSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1095#1077#1082' '#1087#1086#1075#1072#1096#1077#1085#1080#1103')'
            DataBinding.FieldName = 'TotalSumm_CheckSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; -,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object sqUnitName_CheckSale: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072' ('#1095#1077#1082' '#1087#1086#1075#1072#1096#1077#1085#1080#1103')'
            DataBinding.FieldName = 'UnitName_CheckSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 192
          end
          object sgComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 166
          end
          object sgInsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object sgInsertdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
            DataBinding.FieldName = 'Insertdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object sgUpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object sgUpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 263
        Width = 1125
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
        Control = Panel1
      end
      object Panel1: TPanel
        Left = 0
        Top = 271
        Width = 1125
        Height = 210
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 2
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 656
          Height = 210
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel2'
          ShowCaption = False
          TabOrder = 0
          object cxGrid1: TcxGrid
            Left = 0
            Top = 109
            Width = 656
            Height = 101
            Align = alBottom
            PopupMenu = PopupMenu
            TabOrder = 0
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
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsData.Inserting = False
              OptionsView.ColumnAutoWidth = True
              OptionsView.GroupByBox = False
              OptionsView.GroupSummaryLayout = gslAlignWithColumns
              OptionsView.HeaderAutoHeight = True
              OptionsView.Indicator = True
              Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
              object chIsChecked: TcxGridDBColumn
                Caption = #1054#1090#1084'.'
                DataBinding.FieldName = 'IsChecked'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1054#1090#1084#1077#1095#1077#1085' '#1076#1072'/'#1085#1077#1090
                Width = 43
              end
              object chUnitCode: TcxGridDBColumn
                Caption = #1050#1086#1076
                DataBinding.FieldName = 'UnitCode'
                Options.Editing = False
                Width = 32
              end
              object chUnitName: TcxGridDBColumn
                Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
                DataBinding.FieldName = 'UnitName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 197
              end
              object chDayCount: TcxGridDBColumn
                Caption = #1055#1088#1086#1084#1086#1082#1086#1076#1086#1074' '#1074' '#1076#1077#1085#1100
                DataBinding.FieldName = 'DayCount'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 84
              end
              object chSummLimit: TcxGridDBColumn
                Caption = #1051#1080#1084#1080#1090' '#1089#1091#1084#1084#1099' '#1089#1082#1080#1076#1082#1080
                DataBinding.FieldName = 'SummLimit'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 97
              end
              object chJuridicalName: TcxGridDBColumn
                Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1072#1087#1090#1077#1082#1080')'
                DataBinding.FieldName = 'JuridicalName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 80
              end
              object chRetailName: TcxGridDBColumn
                Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
                DataBinding.FieldName = 'RetailName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 99
              end
              object IsErased: TcxGridDBColumn
                Caption = #1059#1076#1072#1083#1077#1085
                DataBinding.FieldName = 'IsErased'
                Visible = False
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 70
              end
            end
            object cxGridLevel1: TcxGridLevel
              GridView = cxGridDBTableView1
            end
          end
          object cxGrid2: TcxGrid
            Left = 0
            Top = 0
            Width = 656
            Height = 101
            Align = alClient
            PopupMenu = PopupMenu
            TabOrder = 1
            object cxGridDBTableView2: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = MasterDS
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
              object MasterAmount: TcxGridDBColumn
                Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080
                DataBinding.FieldName = 'Amount'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 255
              end
              object MasterCount: TcxGridDBColumn
                Caption = #1055#1086#1074#1090#1086#1088#1086#1074
                DataBinding.FieldName = 'Count'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 276
              end
            end
            object cxGridLevel2: TcxGridLevel
              GridView = cxGridDBTableView2
            end
          end
          object cxSplitter2: TcxSplitter
            Left = 0
            Top = 101
            Width = 656
            Height = 8
            Touch.ParentTabletOptions = False
            Touch.TabletOptions = [toPressAndHold]
            AlignSplitter = salBottom
            Control = cxGrid1
          end
        end
        object Panel3: TPanel
          Left = 664
          Top = 0
          Width = 461
          Height = 210
          Align = alRight
          BevelOuter = bvNone
          Caption = 'Panel3'
          ShowCaption = False
          TabOrder = 1
          object cxGrid3: TcxGrid
            Left = 0
            Top = 0
            Width = 461
            Height = 210
            Align = alClient
            PopupMenu = PopupMenu
            TabOrder = 0
            object cxGridDBTableView3: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = InfoDS
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <
                item
                  Format = ',0.##'
                  Kind = skSum
                  Column = InfoAmount
                end
                item
                  Format = ',0.##'
                  Kind = skSum
                  Column = InfoAccrued
                end
                item
                  Format = ',0.##'
                  Kind = skSum
                  Column = InfoSummChange
                end
                item
                  Format = ',0'
                  Kind = skSum
                  Column = InfoAccruedCount
                end
                item
                  Format = ',0'
                  Kind = skSum
                  Column = InfoChangeCount
                end
                item
                  Format = ',0.####'
                  Kind = skSum
                  Column = InfoPercentUsed
                end>
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
              object InfoOperDate: TcxGridDBColumn
                Caption = #1052#1077#1089#1103#1094
                DataBinding.FieldName = 'OperDate'
                PropertiesClassName = 'TcxDateEditProperties'
                Properties.DisplayFormat = 'mmmm yyyy'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 87
              end
              object InfoAmount: TcxGridDBColumn
                Caption = #1051#1080#1084#1080#1090
                DataBinding.FieldName = 'Amount'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.##;-,0.##; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 62
              end
              object InfoAccrued: TcxGridDBColumn
                Caption = #1053#1072#1095#1080#1089#1083'. '#1089#1091#1084#1084#1072
                DataBinding.FieldName = 'Accrued'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.##;-,0.##; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 62
              end
              object InfoAccruedCount: TcxGridDBColumn
                Caption = #1053#1072#1095#1080#1089#1083'. '#1082#1086#1083'-'#1074#1086
                DataBinding.FieldName = 'AccruedCount'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 0
                Properties.DisplayFormat = ',0;-,0; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 63
              end
              object InfoSummChange: TcxGridDBColumn
                Caption = #1048#1089#1087#1086#1083#1100#1079'. '#1089#1091#1084#1084#1072
                DataBinding.FieldName = 'SummChange'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.##;-,0.##; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 61
              end
              object InfoChangeCount: TcxGridDBColumn
                Caption = #1048#1089#1087#1086#1083#1100#1079'. '#1082#1086#1083'-'#1074#1086
                DataBinding.FieldName = 'ChangeCount'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 0
                Properties.DisplayFormat = ',0;-,0 ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 62
              end
              object InfoPercentUsed: TcxGridDBColumn
                Caption = #1055#1088#1086#1094'. '#1074#1077#1088#1085#1091#1074'.'
                DataBinding.FieldName = 'PercentUsed'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 4
                Properties.DisplayFormat = ',0.####;-,0.####; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 62
              end
            end
            object cxGridLevel3: TcxGridLevel
              GridView = cxGridDBTableView3
            end
          end
        end
        object cxSplitter3: TcxSplitter
          Left = 656
          Top = 0
          Width = 8
          Height = 210
          Touch.ParentTabletOptions = False
          Touch.TabletOptions = [toPressAndHold]
          AlignSplitter = salRight
          Control = Panel3
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1125
    Height = 127
    TabOrder = 3
    ExplicitWidth = 1125
    ExplicitHeight = 127
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
      Width = 301
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
      Left = 561
      Top = 102
      EditValue = 42485d
      TabOrder = 14
      Width = 100
    end
    object cxLabel4: TcxLabel
      Left = 335
      Top = 85
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1085#1072#1095'.'
    end
    object edStartSale: TcxDateEdit
      Left = 449
      Top = 102
      EditValue = 42485d
      TabOrder = 16
      Width = 100
    end
    object cxLabel5: TcxLabel
      Left = 223
      Top = 85
      Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1085#1072#1095'.'
    end
    object edStartSummCash: TcxCurrencyEdit
      Left = 447
      Top = 23
      Properties.DisplayFormat = ',0.00'
      Properties.ReadOnly = False
      TabOrder = 18
      Width = 79
    end
    object cxLabel8: TcxLabel
      Left = 447
      Top = 5
      Caption = #1054#1090' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1072
    end
    object edMonthCount: TcxCurrencyEdit
      Left = 535
      Top = 23
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = False
      TabOrder = 20
      Width = 87
    end
    object cxLabel14: TcxLabel
      Left = 535
      Top = 5
      Caption = #1052#1077#1089'. '#1076#1083#1103' '#1087#1086#1075#1072#1096'.'
    end
    object edDayCount: TcxCurrencyEdit
      Left = 631
      Top = 23
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = False
      TabOrder = 22
      Width = 113
    end
    object edEndPromo: TcxDateEdit
      Left = 337
      Top = 102
      EditValue = 42485d
      TabOrder = 23
      Width = 100
    end
    object edInsertdate: TcxDateEdit
      Left = 986
      Top = 23
      EditValue = 42485d
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 24
      Width = 120
    end
    object edStartPromo: TcxDateEdit
      Left = 225
      Top = 102
      EditValue = 42485d
      TabOrder = 25
      Width = 100
    end
    object cxLabel12: TcxLabel
      Left = 982
      Top = 5
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
    end
    object cxLabel3: TcxLabel
      Left = 449
      Top = 85
      Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1087#1086#1075
    end
    object cxLabel6: TcxLabel
      Left = 561
      Top = 85
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1087#1086#1075'.'
    end
    object cxLabel9: TcxLabel
      Left = 631
      Top = 5
      Caption = #1050#1086#1076#1086#1074' '#1074' '#1076#1077#1085#1100' '#1087#1086' '#1072#1087#1090'.'
    end
    object edSummLimit: TcxCurrencyEdit
      Left = 631
      Top = 62
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00'
      Properties.ReadOnly = False
      TabOrder = 30
      Width = 112
    end
    object cxLabel16: TcxLabel
      Left = 631
      Top = 45
      Caption = #1051#1080#1084#1080#1090' '#1074' '#1076#1077#1085#1100' '#1087#1086' '#1072#1087#1090'.'
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 754
      Top = 23
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####; ;'
      Properties.ReadOnly = False
      TabOrder = 32
      Width = 100
    end
    object cxLabel17: TcxLabel
      Left = 754
      Top = 5
      Caption = #1054#1090' '#1087#1088#1086#1094'. '#1088#1077#1072#1083
    end
    object edServiceDate: TcxDateEdit
      Left = 754
      Top = 62
      EditValue = 42485d
      TabOrder = 34
      Width = 100
    end
    object cxLabel18: TcxLabel
      Left = 754
      Top = 45
      Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1089#1095#1077#1090#1072
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
      TabOrder = 37
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1088#1075#1086#1074#1091#1102' '#1089#1077#1090#1100'>'
      Width = 196
    end
    object cbBeginning: TcxCheckBox
      Left = 8
      Top = 85
      Hint = 
        #1063#1077#1082' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1091#1076#1072#1083#1077#1085' '#1087#1086' '#1080#1089#1090#1077#1095#1077#1085#1080#1080' 2 '#1076#1085#1077#1081', '#1076#1083#1103' '#1089#1072#1081#1090#1072' 2 '#1076#1085#1103' '#1087#1086 +
        #1089#1083#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1103
      Caption = #1043#1077#1085#1077#1088#1072#1094#1080#1103' '#1089#1082#1080#1076#1072#1082' '#1089' '#1085#1072#1095#1072#1083#1086' '#1072#1082#1094#1080#1080
      ParentShowHint = False
      ShowHint = True
      TabOrder = 38
      Width = 200
    end
    object cbisElectron: TcxCheckBox
      Left = 8
      Top = 102
      Caption = #1076#1083#1103' '#1057#1072#1081#1090#1072
      TabOrder = 39
      Width = 78
    end
    object edSummRepay: TcxCurrencyEdit
      Left = 535
      Top = 62
      Hint = #1055#1086#1075#1072#1096#1072#1090#1100' '#1086#1090' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1072
      ParentShowHint = False
      Properties.DisplayFormat = ',0.00'
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 40
      Width = 87
    end
    object cxLabel20: TcxLabel
      Left = 532
      Top = 44
      Hint = #1055#1086#1075#1072#1096#1072#1090#1100' '#1086#1090' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1072
      Caption = #1055#1086#1075#1072#1096#1072#1090#1100' '#1086#1090' '#1089#1091#1084'.'
      ParentShowHint = False
      ShowHint = True
    end
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
    object actRefreshLoyaltyChild: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_MovementItem_LoyaltyChild
      StoredProcList = <
        item
          StoredProc = spSelect_MovementItem_LoyaltyChild
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
    object actRefreshLoyaltyGoods: TdsdDataSetRefresh [3]
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
    object actRefreshLoyaltySign: TdsdDataSetRefresh [4]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPromoLoyaltySign
      StoredProcList = <
        item
          StoredProc = spSelectPromoLoyaltySign
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
          StoredProc = spSelectPromoLoyaltySign
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_LoyaltyChild
        end
        item
          StoredProc = spSelectLoyaltyInfo
        end>
    end
    object actSetErasedLoyaltySign: TdsdUpdateErased [7]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMISign
      StoredProcList = <
        item
          StoredProc = spErasedMISign
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = SignDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetErasedChild: TdsdUpdateErased [8]
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
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1070#1088'.'#1083#1080#1094#1086'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1070#1088'.'#1083#1080#1094#1086'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actSetUnErasedLoyaltySign: TdsdUpdateErased [10]
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
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectPromoLoyaltySign
        end>
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_LoyaltyChild
        end>
    end
    object dsdUpdateSignDS: TdsdUpdateDataSet [16]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateLoyaltySign
      StoredProcList = <
        item
          StoredProc = spInsertUpdateLoyaltySign
        end>
      Caption = 'actUpdateSignDS'
      DataSource = SignDS
    end
    object actUpdateChildDS: TdsdUpdateDataSet [17]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateChildDS'
      DataSource = DetailDS
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
          Component = DetailDCS
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'DescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macInsertLoyaltySign: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogLoyaltySign
        end
        item
        end
        item
          Action = actRefreshLoyaltySign
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
    object actStartLoad: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId
        end
        item
          Action = actInsertUpdate_MovementItem_Promo_Set_Zero
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1072#1085#1085#1099#1093' '#1074' '#1090#1077#1082#1091#1097#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      ImageIndex = 41
    end
    object ExecuteDialogLoyaltySign: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      ImageIndex = 26
      FormName = 'TLoyaltySignDialogForm'
      FormNameParam.Value = 'TLoyaltySignDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inCount_GUID'
          Value = '0'
          Component = FormParams
          ComponentItem = 'inCount_GUID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actExportToXLSLoyaltyDay: TdsdExportToXLS
      Category = 'DSDLibExport'
      MoveParams = <>
      BeforeAction = actExecLoyaltyDay
      ItemsDataSet = PrintItemsCDS
      Title = #1048#1090#1086#1075#1080' '#1087#1086' '#1076#1085#1103#1084' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1095#1090#1080
      FileName = 'LoyaltyDay'
      FileNameParam.Value = 'LoyaltyDay'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      ColumnParams = <
        item
          Caption = #1044#1072#1090#1072
          FieldName = 'OperDate'
          DataType = ftDateTime
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1051#1080#1084#1080#1090
          FieldName = 'Amount'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
        end
        item
          Caption = #1053#1072#1095#1080#1089#1083'. '#1089#1091#1084#1084#1072
          FieldName = 'Accrued'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
        end
        item
          Caption = #1053#1072#1095#1080#1089#1083'. '#1082#1086#1083'-'#1074#1086
          FieldName = 'CountAccrued'
          DataType = ftInteger
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
        end
        item
          Caption = #1055#1086#1089#1083'. '#1074#1099#1076#1072#1095#1072
          FieldName = 'MaxTime'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1048#1089#1087#1086#1083#1100#1079'. '#1089#1091#1084#1084#1072
          FieldName = 'SummChange'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
        end
        item
          Caption = #1048#1089#1087#1086#1083#1100#1079'. '#1089#1091#1084#1084#1072
          FieldName = 'CountChange'
          DataType = ftInteger
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
        end
        item
          Caption = #1055#1088#1086#1094'. '#1074#1077#1088#1085#1091#1074'.'
          FieldName = 'PercentUsed'
          DataType = ftCurrency
          DecimalPlace = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1055#1088#1086#1076#1072#1078' '#1087#1086' '#1087#1088#1086#1084#1086#1082#1086#1076#1091' '#1089#1091#1084#1084#1072
          FieldName = 'SummSale'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
        end
        item
          Caption = #1055#1088#1086#1076#1072#1078' '#1087#1086' '#1087#1088#1086#1084#1086#1082#1086#1076#1091' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086
          FieldName = 'CountSale'
          DataType = ftInteger
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
        end>
      Caption = #1048#1090#1086#1075#1080' '#1087#1086' '#1076#1085#1103#1084' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1095#1090#1080
      Hint = #1048#1090#1086#1075#1080' '#1087#1086' '#1076#1085#1103#1084' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1095#1090#1080
      ImageIndex = 24
    end
    object actExecLoyaltyDay: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrintLoyaltyDay
      StoredProcList = <
        item
          StoredProc = spSelectPrintLoyaltyDay
        end>
      Caption = 'actExecLoyaltyDay'
    end
    object actLinkWithChecks: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceLoyaltyCheck
        end
        item
          Action = actExecLoyaltyCheck
        end
        item
          Action = actRefresh
        end>
      Caption = #1057#1074#1103#1079#1072#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1089' '#1095#1077#1082#1086#1084
      Hint = #1057#1074#1103#1079#1072#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1089' '#1095#1077#1082#1086#1084
      ImageIndex = 29
    end
    object actChoiceLoyaltyCheck: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceLoyaltyCheck'
      FormName = 'TChoiceLoyaltyCheckForm'
      FormNameParam.Value = 'TChoiceLoyaltyCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitID'
          Value = ''
          Component = SignDCS
          ComponentItem = 'UnitID'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 'NULL'
          Component = SignDCS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartSummCash'
          Value = Null
          Component = edStartSummCash
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = SignDCS
          ComponentItem = 'ID_Check'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'CheckID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecLoyaltyCheck: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSetLoyaltyCheck
      StoredProcList = <
        item
          StoredProc = spSetLoyaltyCheck
        end>
      Caption = 'actExecLoyaltyCheck'
    end
    object actExportCreaturesPromocode: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1105#1090' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      Hint = #1054#1090#1095#1105#1090' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      ImageIndex = 26
      FormName = 'TReport_Loyalty_CreaturesPromocodeForm'
      FormNameParam.Value = 'TReport_Loyalty_CreaturesPromocodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actExportUsedPromocode: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1105#1090' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      Hint = #1054#1090#1095#1105#1090' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      ImageIndex = 25
      FormName = 'TReport_Loyalty_UsedPromocodeForm'
      FormNameParam.Value = 'TReport_Loyalty_UsedPromocodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUnhook_MovementItem: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUnhook_MovementItem
      StoredProcList = <
        item
          StoredProc = spUnhook_MovementItem
        end>
      Caption = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
      Hint = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
      ImageIndex = 52
      QuestionBeforeExecute = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086'.'
    end
    object actUnhook_Movement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUnhook_Movement
      StoredProcList = <
        item
          StoredProc = spUnhook_Movement
        end>
      Caption = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1095#1077#1082#1072' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
      Hint = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1095#1077#1082#1072' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
      ImageIndex = 76
      QuestionBeforeExecute = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1095#1077#1082#1072' '#1087#1086#1075#1072#1096#1077#1085#1080#1103'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086'.'
    end
    object actInsertPromoCode: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDialogPromoCode
        end
        item
          Action = actExecSPInsertPromoCode
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089' '#1091#1082#1072#1079#1072#1085#1085#1086#1081' '#1089#1091#1084#1084#1086#1081'?'
      InfoAfterExecute = #1055#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089' '#1091#1082#1072#1079#1072#1085#1085#1086#1081' '#1089#1091#1084#1084#1086#1081
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089' '#1091#1082#1072#1079#1072#1085#1085#1086#1081' '#1089#1091#1084#1084#1086#1081
      ImageIndex = 27
    end
    object actExecSPInsertPromoCode: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spInsertPromoCode
      StoredProcList = <
        item
          StoredProc = spInsertPromoCode
        end>
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1099
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1099
    end
    object actExecuteDialogPromoCode: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      FormName = 'TLoyaltyInsertPromoCodeDialogForm'
      FormNameParam.Value = 'TLoyaltyInsertPromoCodeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Count'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Count'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount'
          Value = Null
          Component = FormParams
          ComponentItem = 'Amount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actPrintSticker: TdsdExportToXLS
      Category = 'DSDLibExport'
      MoveParams = <>
      BeforeAction = ExecSPPrintSticker
      ItemsDataSet = PrintItemsCDS
      FileName = 'PrintSticker'
      FileNameParam.Value = 'PrintSticker'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      Footer = False
      ColumnParams = <
        item
          FieldName = 'Column1'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 25
          WrapText = True
          CalcColumnLists = <>
          DetailedTexts = <
            item
              FieldName = 'GUID1'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end
            item
              FieldName = 'SITE1'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end>
        end
        item
          FieldName = 'Column2'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 25
          WrapText = True
          CalcColumnLists = <>
          DetailedTexts = <
            item
              FieldName = 'GUID2'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end
            item
              FieldName = 'SITE2'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end>
        end
        item
          FieldName = 'Column3'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 25
          WrapText = True
          CalcColumnLists = <>
          DetailedTexts = <
            item
              FieldName = 'GUID3'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end
            item
              FieldName = 'SITE3'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end>
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1086#1074' '#1076#1083#1103' '#1088#1072#1079#1076#1072#1095#1080' '#1087#1088#1086#1084#1086#1082#1086#1076#1086#1074
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1086#1074' '#1076#1083#1103' '#1088#1072#1079#1076#1072#1095#1080' '#1087#1088#1086#1084#1086#1082#1086#1076#1086#1074
      ImageIndex = 29
    end
    object ExecSPPrintSticker: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = ExecutePromoCodeSignUnitName
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrintSticker
      StoredProcList = <
        item
          StoredProc = spSelectPrintSticker
        end>
      Caption = 'ExecSPPrintSticker'
    end
    object ExecutePromoCodeSignUnitName: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ExecutePromoCodeSignUnitName'
      FormName = 'TPromoCodeSignUnitNameDialogForm'
      FormNameParam.Value = 'TPromoCodeSignUnitNameDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitName'
          Value = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1089#1072#1081#1090#1077
          Component = FormParams
          ComponentItem = 'UnitName'
          DataType = ftWideString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actInsertPromoCodeScales: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDialogPromoCodeScales
        end
        item
          Action = actExecSPInsertPromoCodeScales
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099'  '#1089#1086#1075#1083#1072#1089#1085#1086' '#1096#1082#1072#1083#1099'?'
      InfoAfterExecute = #1055#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1096#1082#1072#1083#1099
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1096#1082#1072#1083#1099
      ImageIndex = 54
    end
    object actExecSPInsertPromoCodeScales: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spInsertPromoCodeScales
      StoredProcList = <
        item
          StoredProc = spInsertPromoCodeScales
        end>
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1099
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1099
    end
    object actExecuteDialogPromoCodeScales: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      FormName = 'TPromoCodeSignDialogForm'
      FormNameParam.Value = 'TPromoCodeSignDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inCount_GUID'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Count'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actOpenCheckCreate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1089#1086#1079#1076#1072#1085#1080#1103
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1089#1086#1079#1076#1072#1085#1080#1103
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = SignDCS
          ComponentItem = 'ID_Check'
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
          Value = 42370d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      CheckIDRecords = True
      ActionType = acUpdate
      DataSource = SignDS
      DataSetRefresh = actRefresh
      IdFieldName = 'ID_Check'
    end
    object actOpenCheckSale: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = SignDCS
          ComponentItem = 'ID_CheckSale'
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
          Value = 42370d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      CheckIDRecords = True
      ActionType = acUpdate
      DataSource = SignDS
      DataSetRefresh = actRefresh
      IdFieldName = 'ID_CheckSale'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Loyalty'
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
          ItemName = 'bbMISetErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbMISetUnErasedChild'
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
          ItemName = 'dxBarButton1'
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
          ItemName = 'bbOpenReportMinPrice_All'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
          ItemName = 'bbOpenCheckCreate'
        end
        item
          Visible = True
          ItemName = 'bbOpenCheckSale'
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
          ItemName = 'bbInsertPromoCode'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
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
      Action = actStartLoad
      Category = 0
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
      Action = actSetErasedLoyaltySign
      Category = 0
    end
    object bbSetUnErasedPromoPartner: TdxBarButton
      Action = actSetUnErasedLoyaltySign
      Category = 0
    end
    object bbInsertLoyaltySign: TdxBarButton
      Action = macInsertLoyaltySign
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
      Action = actExportToXLSLoyaltyDay
      Category = 0
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
      Action = actLinkWithChecks
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actExportCreaturesPromocode
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actExportUsedPromocode
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUnhook_MovementItem
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actUnhook_Movement
      Category = 0
    end
    object bbInsertPromoCode: TdxBarButton
      Action = actInsertPromoCode
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actPrintSticker
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actInsertPromoCodeScales
      Category = 0
    end
    object bbOpenCheckCreate: TdxBarButton
      Action = actOpenCheckCreate
      Category = 0
    end
    object bbOpenCheckSale: TdxBarButton
      Action = actOpenCheckSale
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
        DataSummaryItemIndex = 10
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
      end
      item
        Name = 'Count'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = '0'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1089#1072#1081#1090#1077
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Loyalty'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Loyalty'
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
        Name = 'StartSummCash'
        Value = Null
        Component = edStartSummCash
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MonthCount'
        Value = Null
        Component = edMonthCount
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayCount'
        Value = Null
        Component = edDayCount
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummLimit'
        Value = Null
        Component = edSummLimit
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDate'
        Value = 'NULL'
        Component = edServiceDate
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
      end
      item
        Name = 'PercentUsed'
        Value = Null
        Component = FormParams
        ComponentItem = 'PercentUsed'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBeginning'
        Value = Null
        Component = cbBeginning
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isElectron'
        Value = Null
        Component = cbisElectron
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummRepay'
        Value = Null
        Component = edSummRepay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 224
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Loyalty'
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
        Name = 'inStartSummCash'
        Value = Null
        Component = edStartSummCash
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMonthCount'
        Value = Null
        Component = edMonthCount
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayCount'
        Value = Null
        Component = edDayCount
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummLimit'
        Value = Null
        Component = edSummLimit
        DataType = ftFloat
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
      end
      item
        Name = 'inChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBeginning'
        Value = Null
        Component = cbBeginning
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisElectron'
        Value = Null
        Component = cbisElectron
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummRepay'
        Value = Null
        Component = edSummRepay
        DataType = ftFloat
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
        Control = edComment
      end
      item
        Control = edEndPromo
      end
      item
        Control = edStartPromo
      end
      item
        Control = edStartSale
      end
      item
        Control = edEndSale
      end
      item
        Control = cbBeginning
      end
      item
        Control = edDayCount
      end
      item
        Control = cbisElectron
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
    Params = <
      item
        Name = 'inMovementItemId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 550
    Top = 224
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementItemId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 654
    Top = 248
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Loyalty'
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
      end
      item
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
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
  object DetailDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 32
    Top = 408
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 80
    Top = 424
  end
  object spSelect_MovementItem_LoyaltyChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_LoyaltyChild'
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
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 432
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
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
    PropertiesCellList = <>
    Left = 278
    Top = 497
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_LoyaltyChild'
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
      end
      item
        Name = 'inDayCount'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'DayCount'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummLimit'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'SummLimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 520
    Top = 496
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
    Left = 822
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
    Left = 734
    Top = 384
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
    Left = 736
    Top = 216
  end
  object SignDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 56
    Top = 496
  end
  object SignDS: TDataSource
    DataSet = SignDCS
    Left = 104
    Top = 512
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
    PropertiesCellList = <>
    Left = 758
    Top = 273
  end
  object spSelectPromoLoyaltySign: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_LoyaltySign'
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
    Left = 192
    Top = 496
  end
  object spInsertUpdateLoyaltySign: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_LoyaltySign'
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
        Name = 'inBayerName'
        Value = Null
        Component = SignDCS
        ComponentItem = 'BayerName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBayerPhone'
        Value = Null
        Component = SignDCS
        ComponentItem = 'BayerPhone'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBayerEmail'
        Value = Null
        Component = SignDCS
        ComponentItem = 'BayerEmail'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGUID'
        Value = Null
        Component = SignDCS
        ComponentItem = 'GUID'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = SignDCS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChecked'
        Value = Null
        Component = SignDCS
        ComponentItem = 'IsChecked'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 344
    Top = 496
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
    Left = 788
    Top = 480
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
    Left = 680
    Top = 448
  end
  object InfoDS: TDataSource
    DataSet = InfoDSD
    Left = 944
    Top = 432
  end
  object InfoDSD: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 896
    Top = 416
  end
  object spSelectLoyaltyInfo: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_LoyaltySecond'
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
    Left = 976
    Top = 368
  end
  object dsdStoredProc1: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_LoyaltySecond'
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
    Top = 416
  end
  object spSelectPrintLoyaltyDay: TdsdStoredProc
    StoredProcName = 'gpReport_MovementItem_LoyaltySecondDay'
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
    Left = 831
    Top = 208
  end
  object spSetLoyaltyCheck: TdsdStoredProc
    StoredProcName = 'gpMovementItem_LoyaltySign_LinkCheck'
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
    Left = 1046
    Top = 200
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
    PropertiesCellList = <>
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
  object spUnhook_MovementItem: TdsdStoredProc
    StoredProcName = 'gpUnhook_MovementItem_Loyalty_Parent'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = SignDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 488
    Top = 360
  end
  object spUnhook_Movement: TdsdStoredProc
    StoredProcName = 'gpUnhook_Movement_Loyalty_CheckSale'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = SignDCS
        ComponentItem = 'ID_CheckSale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 632
    Top = 360
  end
  object spInsertPromoCode: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_Loyalty_PromoCode'
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
        Name = 'inCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'Count'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 888
    Top = 272
  end
  object spSelectPrintSticker: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PrintLoyaltyPromoCodeSticker'
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
      end
      item
        Name = 'inUnitName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitName'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = SignDCS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1007
    Top = 272
  end
  object spInsertPromoCodeScales: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_Loyalty_PromoCodeScales'
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
        Name = 'inCount'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Count'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 888
    Top = 328
  end
end
