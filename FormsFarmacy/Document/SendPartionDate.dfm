inherited SendPartionDateForm: TSendPartionDateForm
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1088#1086#1082'/ '#1085#1077' '#1089#1088#1086#1082
  ClientHeight = 546
  ClientWidth = 1048
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 1064
  ExplicitHeight = 585
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 133
    Width = 1048
    Height = 413
    ExplicitTop = 133
    ExplicitWidth = 1048
    ExplicitHeight = 413
    ClientRectBottom = 413
    ClientRectRight = 1048
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1048
      ExplicitHeight = 389
      inherited cxGrid: TcxGrid
        Width = 1048
        Height = 210
        ExplicitWidth = 1048
        ExplicitHeight = 210
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
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_0
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_all
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
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_0
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_all
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
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 217
          end
          object minExpirationDate: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_0: TcxGridDBColumn
            Caption = #1055#1088#1086#1089#1088#1086#1095#1077#1085#1086
            DataBinding.FieldName = 'Amount_0'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object Amount_1: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1084#1077#1085#1100#1096#1077' 50 '#1076#1085'..'
            DataBinding.FieldName = 'Amount_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object Amount_2: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1084#1077#1085#1100#1096#1077' 200 '#1076#1085'..'
            DataBinding.FieldName = 'Amount_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object Amount_all: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1073#1086#1083#1077#1077' 200 '#1076#1085'.'
            DataBinding.FieldName = 'Amount_all'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1090' 50 '#1076#1086' 200 '#1076#1085'.)'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object ChangePercentMin: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1084#1077#1085#1100#1096#1077' 50 '#1076#1085'.)'
            DataBinding.FieldName = 'ChangePercentMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 104
          end
          object isExpirationDateDiff: TcxGridDBColumn
            Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'isExpirationDateDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1080
            Options.Editing = False
            Width = 82
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 218
        Width = 1048
        Height = 171
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartionDate
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartionDate
            end>
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
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chAmount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object chAmountPartionDate: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082')'
            DataBinding.FieldName = 'AmountPartionDate'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ContainerId: TcxGridDBColumn
            Caption = #1048#1076#1080#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'ContainerId'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 125
          end
          object PartionDateKindName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 174
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 125
          end
          object ExpirationDate_in: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ExpirationDate_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 125
          end
          object chisExpirationDateDiff: TcxGridDBColumn
            Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'isExpirationDateDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1080
            Options.Editing = False
            Width = 82
          end
          object OperDate_Income: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1072#1087#1090#1077#1082#1080' ('#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'OperDate_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 90
          end
          object Invnumber_Income: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Invnumber_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 80
          end
          object FromName_Income: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'FromName_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 80
          end
          object ContractName_Income: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName_Income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 80
          end
          object chisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MovementId_Income: TcxGridDBColumn
            DataBinding.FieldName = 'MovementId_Income'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object cxGridDBTableView1Column1: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1082#1091#1087#1082#1080' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'PriceWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 210
        Width = 1048
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1048
    Height = 107
    TabOrder = 3
    ExplicitWidth = 1048
    ExplicitHeight = 107
    inherited edInvNumber: TcxTextEdit
      Left = 9
      Top = 22
      ExplicitLeft = 9
      ExplicitTop = 22
    end
    inherited cxLabel1: TcxLabel
      Left = 9
      Top = 4
      ExplicitLeft = 9
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Left = 109
      Top = 22
      ExplicitLeft = 109
      ExplicitTop = 22
    end
    inherited cxLabel2: TcxLabel
      Left = 109
      Top = 4
      ExplicitLeft = 109
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Left = 9
      Top = 46
      ExplicitLeft = 9
      ExplicitTop = 46
    end
    inherited ceStatus: TcxButtonEdit
      Left = 9
      Top = 64
      ExplicitLeft = 9
      ExplicitTop = 64
      ExplicitWidth = 200
      ExplicitHeight = 22
      Width = 200
    end
    object lblUnit: TcxLabel
      Left = 221
      Top = 4
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 221
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 315
    end
    object cxLabel7: TcxLabel
      Left = 546
      Top = 46
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 546
      Top = 64
      Properties.ReadOnly = False
      TabOrder = 9
      Width = 498
    end
    object cxLabel10: TcxLabel
      Left = 546
      Top = 4
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
    end
    object edInsertName: TcxButtonEdit
      Left = 546
      Top = 22
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
    object cxLabel12: TcxLabel
      Left = 670
      Top = 4
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
    end
    object edInsertdate: TcxDateEdit
      Left = 670
      Top = 22
      EditValue = 42485d
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 120
    end
    object cxLabel11: TcxLabel
      Left = 799
      Top = 4
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1082#1086#1088#1088'.'
    end
    object edUpdateName: TcxButtonEdit
      Left = 799
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 118
    end
    object cxLabel13: TcxLabel
      Left = 924
      Top = 4
      Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
    end
    object edUpdateDate: TcxDateEdit
      Left = 924
      Top = 22
      EditValue = 42485d
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 120
    end
    object cxLabel9: TcxLabel
      Left = 221
      Top = 46
      Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1090' 50 '#1076#1086' 200 '#1076#1085'.)'
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 221
      Top = 64
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = False
      TabOrder = 19
      Width = 164
    end
    object cxLabel4: TcxLabel
      Left = 9
      Top = 91
      Caption = 
        #1056#1072#1089#1095#1077#1090' '#1094#1077#1085#1099' ('#1086#1090' 50 '#1076#1086' 200 '#1076#1085'.) '#1079#1072' 100% '#1073#1077#1088#1077#1090#1089#1103' '#1090#1086#1074#1072#1088#1085#1072#1103' '#1085#1072#1094#1077#1085#1082#1072'.' +
        ' '#1054#1090' '#1085#1077#1077' '#1088#1072#1089#1089#1095#1080#1090#1099#1074#1072#1077#1090#1089#1103' '#1087#1088#1086#1094#1077#1085#1090' '#1080' '#1074#1099#1095#1080#1090#1072#1077#1090#1089#1103' '#1080#1079' '#1086#1090#1087#1091#1089#1082#1085#1086#1081' '#1094#1077#1085#1099'.  ' +
        ' '#1044#1083#1103' '#1090#1086#1074#1072#1088#1086#1074' '#1084#1077#1085#1100#1096#1077' 50 '#1076#1085'. '#1087#1088#1086#1094#1077#1085#1090' '#1086#1090' '#1086#1090#1087#1091#1089#1082#1085#1086#1081' '#1094#1077#1085#1099'.'
    end
    object cbTransfer: TcxCheckBox
      Left = 72
      Top = 44
      Hint = 
        #1063#1077#1082' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1091#1076#1072#1083#1077#1085' '#1087#1086' '#1080#1089#1090#1077#1095#1077#1085#1080#1080' 2 '#1076#1085#1077#1081', '#1076#1083#1103' '#1089#1072#1081#1090#1072' 2 '#1076#1085#1103' '#1087#1086 +
        #1089#1083#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1103
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1088#1086#1082#1072
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 21
      Width = 143
    end
  end
  object cxLabel3: TcxLabel [2]
    Left = 391
    Top = 46
    Caption = '% '#1089#1082#1080#1076#1082#1080' ('#1084#1077#1085#1100#1096#1077' 50 '#1076#1085'.)'
  end
  object edChangePercentMin: TcxCurrencyEdit [3]
    Left = 391
    Top = 64
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 7
    Width = 149
  end
  inherited ActionList: TActionList
    object actRefreshUnit: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
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
    object actUpdateDetailDS: TdsdUpdateDataSet [8]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateMainDS'
      DataSource = DetailDS
    end
    object actInsertMI: TdsdExecStoredProc [9]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMI
      StoredProcList = <
        item
          StoredProc = spInsertMI
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084
      ImageIndex = 74
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1089#1088#1086#1082#1072#1084' '#1075#1086#1076#1085#1086#1089#1090#1080'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1087#1086#1083#1085#1077#1085#1099
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
          StoredProc = spSelect
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProcList = <
        item
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
    object actPrintCheck: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
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
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBayer'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFiscalCheckNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1050#1086#1087#1080#1103' '#1095#1077#1082#1072' '#1082#1083#1080#1077#1085#1090#1091'('#1087#1088#1086#1076#1072#1078#1072')'
      ReportNameParam.Value = #1050#1086#1087#1080#1103' '#1095#1077#1082#1072' '#1082#1083#1080#1077#1085#1090#1091'('#1087#1088#1086#1076#1072#1078#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object PrintDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'actCheckPrintDialog'
      ImageIndex = 3
      FormName = 'TCheckPrintDialogForm'
      FormNameParam.Value = 'TCheckPrintDialogForm'
      FormNameParam.DataType = ftDateTime
      FormNameParam.ParamType = ptInputOutput
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFiscalCheckNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBayer'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFiscalCheckNumber'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macPrintCheck: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = PrintDialog
        end
        item
          Action = actPrintCheck
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      ImageIndex = 3
    end
    object actGet_SP_Prior: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end>
      Caption = #1040#1042#1058#1054#1047#1040#1055#1054#1051#1053#1048#1058#1068' '#1057#1055
      ImageIndex = 74
    end
    object actOpenFormIncome: TdsdOpenForm
      Category = 'OpenIncome'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1080#1093#1086#1076'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1080#1093#1086#1076'>'
      ImageIndex = 28
      FormName = 'TIncomeForm'
      FormNameParam.Value = 'TIncomeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'MovementId_Income'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = 'False'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenPartionDateKind: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082'>'
      ImageIndex = 24
      FormName = 'TPartionDateKindForm'
      FormNameParam.Value = 'TPartionDateKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 224
  end
  inherited MasterCDS: TClientDataSet
    Top = 224
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_SendPartionDate'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = DetailDCS
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
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 328
  end
  inherited BarManager: TdxBarManager
    Left = 96
    Top = 223
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
          ItemName = 'bbOpenFormIncome'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertMI'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenPartionDateKind'
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
    object bbOpenPartionDateKind: TdxBarButton
      Action = actOpenPartionDateKind
      Category = 0
    end
    object bbInsertMI: TdxBarButton
      Action = actInsertMI
      Category = 0
    end
    object bbOpenFormIncome: TdxBarButton
      Action = actOpenFormIncome
      Category = 0
    end
    object bbMIChildProtocolOpenForm: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1087#1072#1088#1090#1080#1080'>'
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1087#1072#1088#1090#1080#1080'>'
      Visible = ivAlways
      ImageIndex = 34
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
    Top = 241
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
        Name = 'TotalSummPrimeCost'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited StatusGuides: TdsdGuides
    Top = 232
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_SendPartionDate'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 176
    Top = 256
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SendPartionDate'
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
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
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
        Name = 'InsertDate'
        Value = 'NULL'
        Component = edInsertdate
        DataType = ftDateTime
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
        Name = 'ChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercentMin'
        Value = Null
        Component = edChangePercentMin
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Transfer'
        Value = Null
        Component = cbTransfer
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 432
    Top = 200
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SendPartionDate'
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
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
        Name = 'inChangePercentMin'
        Value = Null
        Component = edChangePercentMin
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
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 346
    Top = 200
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesUnit
      end
      item
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
        Action = actRefresh
      end>
    Left = 248
    Top = 240
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
        Control = edChangePercent
      end
      item
        Control = edChangePercentMin
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
    Left = 224
    Top = 201
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 72
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 758
    Top = 200
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 654
    Top = 208
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_SendPartionDate_Master'
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
        Name = 'inAmountRemains'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountRemains'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ChangePercent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercentMin'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ChangePercentMin'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 408
    Top = 272
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 448
    Top = 320
  end
  inherited spGetTotalSumm: TdsdStoredProc
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
      end>
    Left = 732
    Top = 268
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 424
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 500
    Top = 238
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 516
    Top = 321
  end
  object DetailDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'GoodsId'
    MasterFields = 'GoodsId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 112
    Top = 440
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 176
    Top = 440
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
    Left = 318
    Top = 409
  end
  object GuidesGroupMemberSP: TdsdGuides
    KeyField = 'Id'
    FormNameParam.Value = 'TGroupMemberSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGroupMemberSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGroupMemberSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGroupMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 848
    Top = 88
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
    Left = 722
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
    Left = 986
    Top = 14
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_SendPartionDate_Child'
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
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
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
        Component = DetailDCS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inExpirationDate'
        Value = 'NULL'
        Component = DetailDCS
        ComponentItem = 'ExpirationDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inExpirationDate_in'
        Value = 'NULL'
        Component = DetailDCS
        ComponentItem = 'ExpirationDate_in'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisExpirationDateDiff'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isExpirationDateDiff'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContainerId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'ContainerId'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Income'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'MovementId_Income'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 432
    Top = 440
  end
  object spInsertMI: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_SendPartionDate'
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
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 568
    Top = 408
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshUnit
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
      end>
    Left = 536
    Top = 200
  end
end
