inherited PromoCodeMovementForm: TPromoCodeMovementForm
  Caption = #1055#1088#1086#1084#1086'-'#1082#1086#1076#1099
  ClientHeight = 564
  ClientWidth = 1023
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 1039
  ExplicitHeight = 603
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 123
    Width = 1023
    Height = 441
    ExplicitTop = 123
    ExplicitWidth = 1023
    ExplicitHeight = 441
    ClientRectBottom = 441
    ClientRectRight = 1023
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1023
      ExplicitHeight = 417
      inherited cxGrid: TcxGrid
        Top = 187
        Width = 1023
        Height = 121
        Align = alBottom
        ExplicitTop = 187
        ExplicitWidth = 1023
        ExplicitHeight = 121
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object IsChecked: TcxGridDBColumn
            Caption = #1054#1090#1084#1077#1095#1077#1085
            DataBinding.FieldName = 'IsChecked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1084#1077#1095#1077#1085' '#1076#1072'/'#1085#1077#1090
            Width = 60
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
            Width = 340
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
        end
      end
      object cxGrid2: TcxGrid
        Left = 0
        Top = 0
        Width = 1023
        Height = 179
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 2
        object cxGridDBTableView2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = SignDS
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
          OptionsData.Appending = True
          OptionsData.CancelOnExit = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object sgIsChecked: TcxGridDBColumn
            Caption = #1054#1090#1084#1077#1095#1077#1085
            DataBinding.FieldName = 'IsChecked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1084#1077#1095#1077#1085' '#1076#1072'/'#1085#1077#1090
            Width = 41
          end
          object GUID: TcxGridDBColumn
            Caption = #1055#1088#1086#1084#1086' '#1082#1086#1076
            DataBinding.FieldName = 'GUID'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1084#1086' '#1082#1086#1076
            Width = 48
          end
          object clBayerName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'BayerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 174
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 166
          end
          object clIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'IsErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object BayerPhone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085
            DataBinding.FieldName = 'BayerPhone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 62
          end
          object BayerEmail: TcxGridDBColumn
            Caption = 'E-mail'
            DataBinding.FieldName = 'BayerEmail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 49
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Insertdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
            DataBinding.FieldName = 'Insertdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object Count_Check: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074
            DataBinding.FieldName = 'Count_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1095#1077#1082#1086#1074
            Options.Editing = False
            Width = 51
          end
          object Invnumber_Check: TcxGridDBColumn
            Caption = #8470' '#1095#1077#1082#1072
            DataBinding.FieldName = 'Invnumber_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object OperDate_Check: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1095#1077#1082#1072
            DataBinding.FieldName = 'OperDate_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object UnitName_Check: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072' ('#1095#1077#1082')'
            DataBinding.FieldName = 'UnitName_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object JuridicalName_Check: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'JuridicalName_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 130
          end
          object RetailName_Check: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName_Check'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1072#1087#1090#1077#1082#1072')'
            Options.Editing = False
            Width = 94
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableView2
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 316
        Width = 1023
        Height = 101
        Align = alBottom
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
          OptionsData.Appending = True
          OptionsData.CancelOnExit = False
          OptionsData.DeletingConfirmation = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chIsChecked: TcxGridDBColumn
            Caption = #1054#1090#1084#1077#1095#1077#1085
            DataBinding.FieldName = 'IsChecked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1084#1077#1095#1077#1085' '#1076#1072'/'#1085#1077#1090
            Width = 59
          end
          object ObjectCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'ObjectlCode'
            Options.Editing = False
            Width = 42
          end
          object ObjectName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' / '#1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'ObjectName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = JuridicalChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 260
          end
          object DescName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'DescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 176
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object chComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 176
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'IsErased'
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
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 308
        Width = 1023
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
        Control = cxGrid1
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 179
        Width = 1023
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
        Control = cxGrid
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1023
    Height = 97
    TabOrder = 3
    ExplicitWidth = 1023
    ExplicitHeight = 97
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
    object lblUnit: TcxLabel
      Left = 223
      Top = 5
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1072#1082#1094#1080#1080
    end
    object edPromoCode: TcxButtonEdit
      Left = 223
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 216
    end
    object cxLabel7: TcxLabel
      Left = 447
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 447
      Top = 62
      Properties.ReadOnly = False
      TabOrder = 9
      Width = 314
    end
    object cbisElectron: TcxCheckBox
      Left = 565
      Top = 23
      Caption = #1076#1083#1103' '#1057#1072#1081#1090#1072
      TabOrder = 10
      Width = 78
    end
    object cbisOne: TcxCheckBox
      Left = 652
      Top = 23
      Caption = #1059#1085#1080#1082#1072#1083#1100#1085#1099#1081' '#1082#1086#1076
      TabOrder = 11
      Width = 117
    end
    object cxLabel10: TcxLabel
      Left = 775
      Top = 5
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
    end
    object edInsertName: TcxButtonEdit
      Left = 775
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 118
    end
    object cxLabel11: TcxLabel
      Left = 775
      Top = 45
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1082#1086#1088#1088'.'
    end
    object edUpdateName: TcxButtonEdit
      Left = 775
      Top = 62
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
      Left = 899
      Top = 45
      Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
    end
    object edUpdateDate: TcxDateEdit
      Left = 899
      Top = 62
      EditValue = 42485d
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 120
    end
  end
  object edStartPromo: TcxDateEdit [2]
    Left = 223
    Top = 62
    EditValue = 42485d
    TabOrder = 6
    Width = 100
  end
  object cxLabel3: TcxLabel [3]
    Left = 223
    Top = 45
    Caption = #1044#1072#1090#1072' '#1085#1072#1095'.'
  end
  object edEndPromo: TcxDateEdit [4]
    Left = 339
    Top = 62
    EditValue = 42485d
    TabOrder = 8
    Width = 100
  end
  object cxLabel6: TcxLabel [5]
    Left = 339
    Top = 45
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'.'
  end
  object cxLabel9: TcxLabel [6]
    Left = 447
    Top = 5
    Caption = '% '#1089#1082#1080#1076#1082#1080
  end
  object edChangePercent: TcxCurrencyEdit [7]
    Left = 447
    Top = 23
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    TabOrder = 11
    Width = 112
  end
  object cxLabel12: TcxLabel [8]
    Left = 899
    Top = 5
    Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
  end
  object edInsertdate: TcxDateEdit [9]
    Left = 899
    Top = 23
    EditValue = 42485d
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 120
  end
  inherited ActionList: TActionList
    Left = 207
    Top = 319
    object spUpdateSignIsCheckedNo: TdsdExecStoredProc [0]
      Category = 'Checked'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePromoCodeSign_Checked_No
      StoredProcList = <
        item
          StoredProc = spUpdatePromoCodeSign_Checked_No
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1053#1077#1090
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1053#1077#1090
    end
    object actRefreshPromoCodeChild: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_MovementItem_PromoCodeChild
      StoredProcList = <
        item
          StoredProc = spSelect_MovementItem_PromoCodeChild
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
      StoredProc = spUpdatePromoCodeSign_Checked_Yes
      StoredProcList = <
        item
          StoredProc = spUpdatePromoCodeSign_Checked_Yes
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1044#1072
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1044#1072
    end
    object actRefreshPromoCodeGoods: TdsdDataSetRefresh [3]
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
    object actRefreshPromoCodeSign: TdsdDataSetRefresh [4]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPromoCodeSign
      StoredProcList = <
        item
          StoredProc = spSelectPromoCodeSign
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
          StoredProc = spSelectPromoCodeSign
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_PromoCodeChild
        end
        item
        end>
    end
    object macUpdateSignIsCheckedYes_S: TMultiAction [6]
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateSignIsCheckedYes
        end>
      View = cxGridDBTableView2
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      ImageIndex = 76
    end
    object macUpdateSignIsCheckedNo_S: TMultiAction [7]
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateSignIsCheckedNo
        end>
      View = cxGridDBTableView2
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      ImageIndex = 77
    end
    object macUpdateSignIsCheckedYes: TMultiAction [8]
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateSignIsCheckedYes_S
        end
        item
          Action = actRefreshPromoCodeSign
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      ImageIndex = 76
    end
    object macUpdateSignIsCheckedNo: TMultiAction [9]
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateSignIsCheckedNo_S
        end
        item
          Action = actRefreshPromoCodeSign
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      ImageIndex = 77
    end
    object actSetErasedPromoCodeSign: TdsdUpdateErased [11]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMISign
      StoredProcList = <
        item
          StoredProc = spErasedMISign
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1050#1083#1080#1077#1085#1090#1072'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1050#1083#1080#1077#1085#1090#1072'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = SignDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetErasedChild: TdsdUpdateErased [12]
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
    object actSetUnErasedPromoCodeSign: TdsdUpdateErased [14]
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
    object actMISetUnErasedChild: TdsdUpdateErased [15]
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
          StoredProc = spSelectPromoCodeSign
        end>
    end
    object InsertRecordSign: TInsertRecord [19]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView2
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1083#1080#1077#1085#1090#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1083#1080#1077#1085#1090#1072'>'
      ImageIndex = 0
    end
    object InsertRecordChild: TInsertRecord [20]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView1
      Action = JuridicalChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' /'#1070#1088'. '#1083#1080#1094#1086'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' /'#1070#1088'. '#1083#1080#1094#1086'>'
      ShortCut = 45
      ImageIndex = 0
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_PromoCodeChild
        end>
    end
    object dsdUpdateSignDS: TdsdUpdateDataSet [22]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdatePromoCodeSign
      StoredProcList = <
        item
          StoredProc = spInsertUpdatePromoCodeSign
        end>
      Caption = 'actUpdateSignDS'
      DataSource = SignDS
    end
    object actUpdateChildDS: TdsdUpdateDataSet [23]
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
    object actDoLoad: TExecuteImportSettingsAction [24]
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
    object actOpenReporCheck: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1063#1077#1082#1080' '#1087#1086' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1063#1077#1082#1080' '#1087#1086' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1091'>'
      ImageIndex = 24
      FormName = 'TReport_Check_byPromoCodeForm'
      FormNameParam.Value = 'TReport_Check_byPromoCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementItemId'
          Value = '0'
          Component = SignDCS
          ComponentItem = 'Id'
          ParamType = ptInput
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
          Value = 'NULL'
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGUID'
          Value = Null
          Component = SignDCS
          ComponentItem = 'GUID'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportMinPriceForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1052#1080#1085'. '#1094#1077#1085#1072' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1077#1088#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075')>'
      Hint = #1054#1090#1095#1077#1090' <'#1052#1080#1085'. '#1094#1077#1085#1072' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1077#1088#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075')>'
      ImageIndex = 26
      FormName = 'TReport_MinPrice_byPromoForm'
      FormNameParam.Value = 'TReport_MinPrice_byPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
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
        end>
      isShowModal = False
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1080#1093#1086#1076#1072'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1080#1093#1086#1076#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072'>'
      ImageIndex = 25
      FormName = 'TReport_MovementIncome_byPromoForm'
      FormNameParam.Value = 'TReport_MovementIncome_byPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
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
        end>
      isShowModal = False
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
    object macInsertPromoCodeSign: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogPromoCodeSign
        end
        item
          Action = actInsertPromoCodeSign
        end
        item
          Action = actRefreshPromoCodeSign
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
      StoredProc = spInsertUpdate_MovementItem_Promo_Set_Zero
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_MovementItem_Promo_Set_Zero
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
    object actInsertPromoCodeSign: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spInsertPromoCodeSign
      StoredProcList = <
        item
          StoredProc = spInsertPromoCodeSign
        end>
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1099
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1099
      ImageIndex = 27
    end
    object ExecuteDialogPromoCodeSign: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      ImageIndex = 26
      FormName = 'TPromoCodeSignDialogForm'
      FormNameParam.Value = 'TPromoCodeSignDialogForm'
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
    object spUpdateGoodsIsCheckedNo: TdsdExecStoredProc
      Category = 'Checked'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIGoods_isChecked_No
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIGoods_isChecked_No
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1053#1077#1090
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1053#1077#1090
    end
    object spUpdateGoodsIsCheckedYes: TdsdExecStoredProc
      Category = 'Checked'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIGoods_isChecked_Yes
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIGoods_isChecked_Yes
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1044#1072
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1044#1072
    end
    object macUpdateGoodsIsCheckedYes: TMultiAction
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateGoodsIsCheckedYes_S
        end
        item
          Action = actRefreshPromoCodeGoods
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      ImageIndex = 76
    end
    object macUpdateGoodsIsCheckedYes_S: TMultiAction
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateGoodsIsCheckedYes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      ImageIndex = 76
    end
    object macUpdateGoodsIsCheckedNo: TMultiAction
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateGoodsIsCheckedNo_S
        end
        item
          Action = actRefreshPromoCodeGoods
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      ImageIndex = 77
    end
    object macUpdateGoodsIsCheckedNo_S: TMultiAction
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateGoodsIsCheckedNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      ImageIndex = 77
    end
    object spUpdateChildIsCheckedNo: TdsdExecStoredProc
      Category = 'Checked'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild_Cheked_No
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild_Cheked_No
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1053#1077#1090
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1053#1077#1090
    end
    object spUpdateChildIsCheckedYes: TdsdExecStoredProc
      Category = 'Checked'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild_Cheked_Yes
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild_Cheked_Yes
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1044#1072
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1044#1072
    end
    object macUpdateChildIsCheckedYes_S: TMultiAction
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateChildIsCheckedYes
        end>
      View = cxGridDBTableView1
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      ImageIndex = 76
    end
    object macUpdateChildIsCheckedNo_S: TMultiAction
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateChildIsCheckedNo
        end>
      View = cxGridDBTableView1
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      ImageIndex = 77
    end
    object macUpdateChildIsCheckedYes: TMultiAction
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateChildIsCheckedYes_S
        end
        item
          Action = actRefreshPromoCodeChild
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      ImageIndex = 76
    end
    object macUpdateChildIsCheckedNo: TMultiAction
      Category = 'Checked'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateChildIsCheckedNo_S
        end
        item
          Action = actRefreshPromoCodeChild
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      ImageIndex = 77
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoCode'
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
          ItemName = 'bbInsertRecordPartner'
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
          ItemName = 'bbSignIsCheckedYes'
        end
        item
          Visible = True
          ItemName = 'bbSignIsCheckedNo'
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
          ItemName = 'bbGoodsIsCheckedYes'
        end
        item
          Visible = True
          ItemName = 'bbGoodsIsCheckedNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordChild'
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
          ItemName = 'bbChildIsCheckedYes'
        end
        item
          Visible = True
          ItemName = 'bbChildIsCheckedNo'
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
          ItemName = 'bbInsertPromoCodeSign'
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
      Action = actStartLoad
      Category = 0
    end
    object bbInsertRecordChild: TdxBarButton
      Action = InsertRecordChild
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbInsertRecordPartner: TdxBarButton
      Action = InsertRecordSign
      Category = 0
    end
    object bbSetErasedPromoPartner: TdxBarButton
      Action = actSetErasedPromoCodeSign
      Category = 0
    end
    object bbSetUnErasedPromoPartner: TdxBarButton
      Action = actSetUnErasedPromoCodeSign
      Category = 0
    end
    object bbInsertPromoCodeSign: TdxBarButton
      Action = macInsertPromoCodeSign
      Category = 0
    end
    object bbReportMinPriceForm: TdxBarButton
      Action = actOpenReportMinPriceForm
      Category = 0
    end
    object bbOpenReportMinPrice_All: TdxBarButton
      Action = actOpenReporCheck
      Category = 0
    end
    object bbGoodsIsCheckedYes: TdxBarButton
      Action = macUpdateGoodsIsCheckedYes
      Category = 0
    end
    object bbGoodsIsCheckedNo: TdxBarButton
      Action = macUpdateGoodsIsCheckedNo
      Category = 0
    end
    object bbChildIsCheckedNo: TdxBarButton
      Action = macUpdateChildIsCheckedNo
      Category = 0
    end
    object bbChildIsCheckedYes: TdxBarButton
      Action = macUpdateChildIsCheckedYes
      Category = 0
    end
    object bbSignIsCheckedNo: TdxBarButton
      Action = macUpdateSignIsCheckedNo
      Category = 0
    end
    object bbSignIsCheckedYes: TdxBarButton
      Action = macUpdateSignIsCheckedYes
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
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_PromoCode'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PromoCode'
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
        Name = 'isElectron'
        Value = Null
        Component = cbisElectron
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOne'
        Value = Null
        Component = cbisOne
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeId'
        Value = Null
        Component = GuidesPromoCode
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeName'
        Value = Null
        Component = GuidesPromoCode
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
        Name = 'ChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
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
    StoredProcName = 'gpInsertUpdate_Movement_PromoCode'
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
        Name = 'inChangePercent'
        Value = Null
        Component = edChangePercent
        DataType = ftFloat
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
        Name = 'inisOne'
        Value = Null
        Component = cbisOne
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPromoCodeId'
        Value = Null
        Component = GuidesPromoCode
        ComponentItem = 'Key'
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
        Guides = GuidesPromoCode
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
        Control = edPromoCode
      end
      item
        Control = edPromoCode
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
        Control = cbisElectron
      end
      item
        Control = edChangePercent
      end
      item
        Control = cbisOne
      end>
    Left = 224
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 120
    Top = 336
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
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoCode'
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
        Name = 'inIsChecked'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsChecked'
        DataType = ftBoolean
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
  object GuidesPromoCode: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPromoCode
    FormNameParam.Value = 'TPromoCodeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPromoCodeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPromoCode
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPromoCode
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 8
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
    Left = 476
    Top = 206
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 444
    Top = 209
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
  object spSelect_MovementItem_PromoCodeChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoCodeChild'
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
    Left = 544
    Top = 408
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
    Left = 750
    Top = 489
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoCodeChild'
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
        Name = 'inJuridicalId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'ObjectId'
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
        Name = 'inComment'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 536
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
    Left = 766
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
  object spInsertUpdate_MovementItem_Promo_Set_Zero: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Promo_Set_Zero'
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
    NeedResetData = True
    Left = 730
    Top = 208
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
    Left = 758
    Top = 273
  end
  object spSelectPromoCodeSign: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoCodeSign'
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
  object spInsertUpdatePromoCodeSign: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoCodeSign'
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
    Left = 384
    Top = 512
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
    Left = 676
    Top = 504
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
    Left = 834
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
    Left = 810
    Top = 70
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
    Top = 480
  end
  object spInsertPromoCodeSign: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_PromoCodeSign'
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
        Name = 'inCount_GUID'
        Value = Null
        Component = FormParams
        ComponentItem = 'inCount_GUID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 320
    Top = 496
  end
  object spInsertUpdateMIGoods_isChecked_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoCode_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
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
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChecked'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 360
  end
  object spInsertUpdateMIGoods_isChecked_No: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoCode_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
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
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChecked'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 392
    Top = 360
  end
  object spUpdateMIChild_Cheked_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoCodeChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = DetailDCS
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
        Name = 'inJuridicalId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChecked'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 616
    Top = 352
  end
  object spUpdateMIChild_Cheked_No: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoCodeChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = DetailDCS
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
        Name = 'inJuridicalId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChecked'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 576
    Top = 352
  end
  object spUpdatePromoCodeSign_Checked_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PromoCodeSign_Checked'
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
        Name = 'inIsChecked'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 448
    Top = 488
  end
  object spUpdatePromoCodeSign_Checked_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PromoCodeSign_Checked'
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
        Name = 'inIsChecked'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 528
    Top = 504
  end
end
