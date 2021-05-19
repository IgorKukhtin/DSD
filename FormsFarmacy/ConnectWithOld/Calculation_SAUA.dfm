object Calculation_SAUAForm: TCalculation_SAUAForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1080#1089#1090#1077#1084#1077' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1086#1084
  ClientHeight = 633
  ClientWidth = 1070
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = ParentFormClose
  OnCreate = ParentFormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1070
    Height = 217
    Align = alTop
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 1068
      Height = 151
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 0
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 537
        Height = 151
        Align = alLeft
        Caption = 'Panel4'
        ShowCaption = False
        TabOrder = 0
        DesignSize = (
          537
          151)
        object cxLabel3: TcxLabel
          Left = 1
          Top = 1
          Align = alTop
          Caption = #1040#1087#1090#1077#1082#1080' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1080
          Properties.Alignment.Horz = taCenter
          AnchorX = 269
        end
        object cxLabel9: TcxLabel
          Left = 1
          Top = 133
          Align = alBottom
          Caption = #1042#1099#1073#1088#1072#1085#1086' 0'
          Properties.Alignment.Horz = taLeftJustify
        end
        object cxTextEdit1: TcxTextEdit
          Left = 328
          Top = 0
          Anchors = [akTop, akRight]
          TabOrder = 2
          DesignSize = (
            209
            21)
          Width = 209
        end
        object cxGridRecipient: TcxGrid
          Left = 1
          Top = 18
          Width = 535
          Height = 115
          Align = alClient
          TabOrder = 3
          object cxGridDBTableView1: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            Navigator.Buttons.Insert.Visible = False
            Navigator.Buttons.Append.Visible = False
            Navigator.Buttons.Delete.Visible = False
            Navigator.Buttons.Edit.Visible = False
            Navigator.Buttons.Post.Visible = False
            Navigator.Buttons.Cancel.Visible = False
            Navigator.Buttons.Refresh.Visible = False
            DataController.DataSource = UnitsRecipientDS
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.GroupByBox = False
            OptionsView.Header = False
            OptionsView.Indicator = True
            object risChecked: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'isChecked'
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.OnEditValueChanged = risCheckedPropertiesEditValueChanged
              Width = 45
            end
            object rUnitName: TcxGridDBColumn
              Caption = #1053#1072#1079#1074#1072#1085#1080#1077
              DataBinding.FieldName = 'UnitName'
              Options.Editing = False
              Width = 399
            end
          end
          object cxGridLevel1: TcxGridLevel
            Caption = #1050#1086#1085#1090#1088#1072#1082#1090
            GridView = cxGridDBTableView1
          end
        end
      end
      object Panel5: TPanel
        Left = 537
        Top = 0
        Width = 531
        Height = 151
        Align = alClient
        Caption = 'Panel5'
        ShowCaption = False
        TabOrder = 1
        DesignSize = (
          531
          151)
        object cxLabel4: TcxLabel
          Left = 1
          Top = 1
          Align = alTop
          Caption = #1040#1087#1090#1077#1082#1080' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
          Properties.Alignment.Horz = taCenter
          AnchorX = 266
        end
        object cxLabel10: TcxLabel
          Left = 1
          Top = 133
          Align = alBottom
          Caption = #1042#1099#1073#1088#1072#1085#1086' 0'
          Properties.Alignment.Horz = taLeftJustify
        end
        object cxTextEdit2: TcxTextEdit
          Left = 336
          Top = 0
          Anchors = [akTop, akRight]
          TabOrder = 2
          DesignSize = (
            195
            21)
          Width = 195
        end
        object cxGridAssortment: TcxGrid
          Left = 1
          Top = 18
          Width = 529
          Height = 115
          Align = alClient
          TabOrder = 3
          object cxGridDBTableView2: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            Navigator.Buttons.Insert.Visible = False
            Navigator.Buttons.Append.Visible = False
            Navigator.Buttons.Delete.Visible = False
            Navigator.Buttons.Edit.Visible = False
            Navigator.Buttons.Post.Visible = False
            Navigator.Buttons.Cancel.Visible = False
            Navigator.Buttons.Refresh.Visible = False
            DataController.DataSource = UnitAssortmentDS
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.GroupByBox = False
            OptionsView.Header = False
            OptionsView.Indicator = True
            object aisChecked: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'isChecked'
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.OnEditValueChanged = aisCheckedPropertiesEditValueChanged
              Width = 45
            end
            object aUnitName: TcxGridDBColumn
              Caption = #1053#1072#1079#1074#1072#1085#1080#1077
              DataBinding.FieldName = 'UnitName'
              Options.Editing = False
              Width = 399
            end
          end
          object cxGridLevel2: TcxGridLevel
            Caption = #1050#1086#1085#1090#1088#1072#1082#1090
            GridView = cxGridDBTableView2
          end
        end
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 152
      Width = 1068
      Height = 64
      Align = alBottom
      Caption = 'Panel3'
      ShowCaption = False
      TabOrder = 1
      object cxLabel1: TcxLabel
        Left = 8
        Top = 3
        Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1086#1076#1072#1078':'
      end
      object cxLabel2: TcxLabel
        Left = 8
        Top = 23
        Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1086#1076#1072#1078':'
      end
      object deEnd: TcxDateEdit
        Left = 170
        Top = 22
        EditValue = 42370d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 2
        Width = 85
      end
      object deStart: TcxDateEdit
        Left = 170
        Top = 2
        EditValue = 42370d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 3
        Width = 85
      end
      object ceThreshold: TcxCurrencyEdit
        Left = 439
        Top = 2
        EditValue = 1.000000000000000000
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###'
        TabOrder = 4
        Width = 53
      end
      object cxLabel5: TcxLabel
        Left = 259
        Top = 3
        Caption = #1055#1086#1088#1086#1075' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1093' '#1087#1088#1086#1076#1072#1078':'
      end
      object ceDaysStock: TcxCurrencyEdit
        Left = 439
        Top = 22
        EditValue = 10.000000000000000000
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0'
        TabOrder = 6
        Width = 53
      end
      object cxLabel6: TcxLabel
        Left = 259
        Top = 23
        Caption = #1044#1085#1077#1081' '#1079#1072#1087#1072#1089#1072' '#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103':'
      end
      object ceCountPharmacies: TcxCurrencyEdit
        Left = 439
        Top = 42
        Hint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072' '#1080#1079' '#1074#1099#1073#1088#1072#1085#1085#1099#1093
        EditValue = 1.000000000000000000
        ParentShowHint = False
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0'
        ShowHint = True
        TabOrder = 8
        Width = 53
      end
      object cxLabel7: TcxLabel
        Left = 259
        Top = 43
        Hint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072' '#1080#1079' '#1074#1099#1073#1088#1072#1085#1085#1099#1093
        Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
        ParentShowHint = False
        ShowHint = True
      end
      object cbGoodsClose: TcxCheckBox
        Left = 511
        Top = 2
        Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1047#1072#1082#1088#1099#1090' '#1082#1086#1076
        State = cbsChecked
        TabOrder = 10
        Width = 167
      end
      object cbMCSIsClose: TcxCheckBox
        Left = 511
        Top = 16
        Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1059#1073#1080#1090' '#1082#1086#1076' '
        TabOrder = 11
        Width = 201
      end
      object cbNotCheckNoMCS: TcxCheckBox
        Left = 511
        Top = 30
        Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1055#1088#1086#1076#1072#1078#1080' '#1085#1077' '#1076#1083#1103' '#1053#1058#1047
        TabOrder = 12
        Width = 217
      end
      object cbNeedRound: TcxCheckBox
        Left = 751
        Top = 44
        Caption = #1055#1086#1090#1088#1077#1073#1085#1086#1089#1090#1100' '#1086#1082#1088#1091#1075#1083#1103#1090#1100' '#1087#1086' '#1084#1072#1090' '#1087#1088#1080#1085#1094#1080#1087#1091
        TabOrder = 13
        Width = 234
      end
      object cbAssortmentRound: TcxCheckBox
        Left = 511
        Top = 44
        Caption = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090' '#1086#1082#1088#1091#1075#1083#1103#1090#1100' '#1087#1086' '#1084#1072#1090' '#1087#1088#1080#1085#1094#1080#1087#1091
        TabOrder = 14
        Width = 234
      end
      object ceThresholdMCS: TcxCurrencyEdit
        Left = 919
        Top = 5
        EditValue = 0.000000000000000000
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###'
        TabOrder = 15
        Width = 53
      end
      object ceThresholdRemains: TcxCurrencyEdit
        Left = 919
        Top = 25
        EditValue = 0.000000000000000000
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###'
        TabOrder = 16
        Width = 53
      end
      object cbMCSValue: TcxCheckBox
        Left = 751
        Top = 6
        Caption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1089' '#1053#1058#1047' '#1089
        TabOrder = 17
        Width = 167
      end
      object cbRemains: TcxCheckBox
        Left = 751
        Top = 25
        Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' '#1089
        TabOrder = 18
        Width = 167
      end
      object ceThresholdRemainsLarge: TcxCurrencyEdit
        Left = 999
        Top = 25
        EditValue = 0.000000000000000000
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###'
        TabOrder = 19
        Width = 53
      end
      object ceThresholdMCSLarge: TcxCurrencyEdit
        Left = 999
        Top = 5
        EditValue = 0.000000000000000000
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###'
        TabOrder = 20
        Width = 53
      end
      object cxLabel8: TcxLabel
        Left = 977
        Top = 6
        Caption = #1087#1086
      end
      object cxLabel11: TcxLabel
        Left = 977
        Top = 26
        Caption = #1087#1086
      end
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 243
    Width = 1070
    Height = 390
    Align = alClient
    TabOrder = 5
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
    end
    object cxGridDBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      Navigator.Buttons.First.Visible = True
      Navigator.Buttons.PriorPage.Visible = True
      Navigator.Buttons.Prior.Visible = True
      Navigator.Buttons.Next.Visible = True
      Navigator.Buttons.NextPage.Visible = True
      Navigator.Buttons.Last.Visible = True
      Navigator.Buttons.Insert.Visible = True
      Navigator.Buttons.Append.Visible = False
      Navigator.Buttons.Delete.Visible = True
      Navigator.Buttons.Edit.Visible = True
      Navigator.Buttons.Post.Visible = True
      Navigator.Buttons.Cancel.Visible = True
      Navigator.Buttons.Refresh.Visible = True
      Navigator.Buttons.SaveBookmark.Visible = True
      Navigator.Buttons.GotoBookmark.Visible = True
      Navigator.Buttons.Filter.Visible = True
      DataController.DataSource = dsResult
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.####;-,0.####; ;'
          Kind = skSum
          Position = spFooter
          Column = Need
        end
        item
          Format = ',0.####;-,0.####; ;'
          Kind = skSum
          Column = Need
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
        end
        item
          Format = ',0.00;-,0.00; ;'
          Kind = skSum
        end
        item
          Format = ',0.####;-,0.####; ;'
          Kind = skSum
          Column = Need
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsView.Footer = True
      OptionsView.HeaderHeight = 50
      Bands = <
        item
          Caption = #1055#1088#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1080
          Width = 627
        end
        item
          Caption = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
          Width = 242
        end>
      object UnitName: TcxGridDBBandedColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 127
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object GoodsCode: TcxGridDBBandedColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 57
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object GoodsName: TcxGridDBBandedColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 137
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object Remains: TcxGridDBBandedColumn
        Caption = #1054#1089#1090#1072#1090#1086#1082
        DataBinding.FieldName = 'Remains'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1086#1076#1072#1078#1072' '#1079#1072' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
        Options.Editing = False
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object Need: TcxGridDBBandedColumn
        Caption = #1055#1086#1090#1088#1077#1073#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'Need'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1086#1094#1077#1085#1090' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1086#1076#1086#1074' '#1074' '#1095#1077#1082#1072#1093' '#1076#1083#1103' '#1057#1040#1059#1040
        Width = 66
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object Assortment: TcxGridDBBandedColumn
        Caption = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090
        DataBinding.FieldName = 'Assortment'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 79
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object AmountCheck: TcxGridDBBandedColumn
        Caption = #1055#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
        DataBinding.FieldName = 'AmountCheck'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object CountUnit: TcxGridDBBandedColumn
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1072#1087#1090#1077#1082
        DataBinding.FieldName = 'CountUnit'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 82
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBBandedTableView1
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = ceThreshold
        Properties.Strings = (
          'Value')
      end
      item
        Component = ceDaysStock
        Properties.Strings = (
          'Value')
      end
      item
        Component = ceCountPharmacies
        Properties.Strings = (
          'Value')
      end
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
    Left = 256
    Top = 90
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 40
    Top = 90
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actCalculation: TAction
      Category = 'DSDLib'
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100
      Hint = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100
      ImageIndex = 41
      OnExecute = actCalculationExecute
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLibExport'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actScheduleNearestSUN1: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actInsert_FinalSUAProtocol
      ActionList = <
        item
          Action = actExecactScheduleNearestSUN1
        end>
      View = cxGridDBBandedTableView1
      QuestionBeforeExecute = #1047#1072#1087#1083#1072#1085#1080#1088#1086#1074#1072#1090#1100' '#1085#1072' '#1073#1083#1080#1078#1072#1081#1096#1080#1081' '#1057#1059#1053'1?'
      Caption = #1047#1072#1087#1083#1072#1085#1080#1088#1086#1074#1072#1090#1100' '#1085#1072' '#1073#1083#1080#1078#1072#1081#1096#1080#1081' '#1057#1059#1053'1'
      Hint = #1047#1072#1087#1083#1072#1085#1080#1088#1086#1074#1072#1090#1100' '#1085#1072' '#1073#1083#1080#1078#1072#1081#1096#1080#1081' '#1057#1059#1053'1'
      ImageIndex = 30
    end
    object actExecactScheduleNearestSUN1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spScheduleNearestSUN1
      StoredProcList = <
        item
          StoredProc = spScheduleNearestSUN1
        end>
      Caption = 'actExecactScheduleNearestSUN1'
    end
    object actInsert_FinalSUAProtocol: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_FinalSUAProtocol
      StoredProcList = <
        item
          StoredProc = spInsert_FinalSUAProtocol
        end>
      Caption = 'actInsert_FinalSUAProtocol'
    end
    object actFinalSUAProtocol: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1081
      Hint = #1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1081
      ImageIndex = 34
      FormName = 'TReport_FinalSUAProtocolForm'
      FormNameParam.Value = 'TReport_FinalSUAProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGet_AutoCalculation_SAUA: TAction
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086' '#1076#1072#1085#1085#1099#1084' '#1076#1083#1103' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1088#1072#1089#1095#1077#1090#1072' '#1057#1059#1040
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086' '#1076#1072#1085#1085#1099#1084' '#1076#1083#1103' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1088#1072#1089#1095#1077#1090#1072' '#1057#1059#1040
      ImageIndex = 79
      OnExecute = actGet_AutoCalculation_SAUAExecute
    end
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
    Left = 160
    Top = 90
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
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbScheduleNearestSUN1'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbFinalSUAProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actCalculation
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object bbToExcel: TdxBarButton
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Category = 0
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Visible = ivAlways
      ImageIndex = 6
      ShortCut = 16472
    end
    object bbStaticText: TdxBarButton
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Visible = ivAlways
      ImageIndex = 35
    end
    object bbPrint: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bbPrint2: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Visible = ivAlways
      ImageIndex = 16
      ShortCut = 16464
    end
    object bb: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton1: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1089#1080#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1090#1086#1074#1072#1088#1072#1084' '#1085#1072' '#1087#1086#1074#1086#1076' '#1075#1088#1080#1076
      Visible = ivAlways
      ImageIndex = 33
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1085#1072' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099
      Category = 0
      Hint = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1085#1072' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1086#1084#1091' '#1082#1086 +
        #1085#1090#1088#1072#1082#1090#1091
      Visible = ivAlways
      ImageIndex = 34
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarButton4: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Category = 0
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Visible = ivAlways
      ImageIndex = 6
      ShortCut = 16472
    end
    object bbScheduleNearestSUN1: TdxBarButton
      Action = actScheduleNearestSUN1
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton6: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object bbFinalSUAProtocol: TdxBarButton
      Action = actFinalSUAProtocol
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actGet_AutoCalculation_SAUA
      Category = 0
    end
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 560
    Top = 82
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 408
    Top = 90
  end
  object GetUnitsRecipientList: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitForSAUA'
    DataSet = UnitsRecipientCDS
    DataSets = <
      item
        DataSet = UnitsRecipientCDS
      end>
    Params = <>
    PackSize = 1
    Left = 128
    Top = 26
  end
  object UnitsRecipientCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'UnitName'
    Params = <>
    AfterPost = UnitsRecipientCDSAfterPost
    Left = 240
    Top = 26
  end
  object dsResult: TDataSource
    DataSet = cdsResult
    Left = 248
    Top = 360
  end
  object cdsResult: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 168
    Top = 360
  end
  object spCalculation: TdsdStoredProc
    StoredProcName = 'gpSelect_Calculation_SAUA'
    DataSet = cdsResult
    DataSets = <
      item
        DataSet = cdsResult
      end>
    Params = <
      item
        Name = 'inDateStart'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateEnd'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRecipientList'
        Value = Null
        Component = FormParams
        ComponentItem = 'RecipientList'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssortmentList'
        Value = Null
        Component = FormParams
        ComponentItem = 'AssortmentList'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThreshold'
        Value = Null
        Component = ceThreshold
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaysStock'
        Value = Null
        Component = ceDaysStock
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountPharmacies'
        Value = Null
        Component = ceCountPharmacies
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsClose'
        Value = Null
        Component = cbGoodsClose
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMCSIsClose'
        Value = Null
        Component = cbMCSIsClose
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotCheckNoMCS'
        Value = Null
        Component = cbNotCheckNoMCS
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMCSValue'
        Value = Null
        Component = cbMCSValue
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdMCS'
        Value = Null
        Component = ceThresholdMCS
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdMCSLarge'
        Value = Null
        Component = ceThresholdMCSLarge
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRemains'
        Value = Null
        Component = cbRemains
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdRemains'
        Value = Null
        Component = ceThresholdRemains
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdRemainsLarge'
        Value = Null
        Component = ceThresholdRemainsLarge
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAssortmentRound'
        Value = Null
        Component = cbAssortmentRound
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNeedRound'
        Value = Null
        Component = cbNeedRound
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 360
  end
  object spScheduleNearestSUN1: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_AddFinalSUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = cdsResult
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = cdsResult
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNeed'
        Value = Null
        Component = cdsResult
        ComponentItem = 'Need'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 448
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'RecipientList'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssortmentList'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitRecipient'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitAssortment'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 448
  end
  object spInsert_FinalSUAProtocol: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_FinalSUAProtocol'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inDateStart'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateEnd'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRecipientList'
        Value = Null
        Component = FormParams
        ComponentItem = 'RecipientList'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssortmentList'
        Value = Null
        Component = FormParams
        ComponentItem = 'AssortmentList'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThreshold'
        Value = 1.000000000000000000
        Component = ceThreshold
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaysStock'
        Value = 10.000000000000000000
        Component = ceDaysStock
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountPharmacies'
        Value = 1.000000000000000000
        Component = ceCountPharmacies
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsClose'
        Value = True
        Component = cbGoodsClose
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMCSIsClose'
        Value = False
        Component = cbMCSIsClose
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotCheckNoMCS'
        Value = False
        Component = cbNotCheckNoMCS
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMCSValue'
        Value = Null
        Component = cbMCSValue
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdMCS'
        Value = Null
        Component = ceThresholdMCS
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdMCSLarge'
        Value = Null
        Component = ceThresholdMCSLarge
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRemains'
        Value = Null
        Component = cbRemains
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdRemains'
        Value = Null
        Component = ceThresholdRemains
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdRemainsLarge'
        Value = Null
        Component = ceThresholdRemainsLarge
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAssortmentRound'
        Value = Null
        Component = cbAssortmentRound
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNeedRound'
        Value = Null
        Component = cbNeedRound
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 520
  end
  object FieldFilterRecipient: TdsdFieldFilter
    TextEdit = cxTextEdit1
    DataSet = UnitsRecipientCDS
    Column = rUnitName
    CheckBoxList = <>
    Left = 464
    Top = 24
  end
  object FieldFilterAssortment: TdsdFieldFilter
    TextEdit = cxTextEdit2
    DataSet = UnitAssortmentCDS
    Column = aUnitName
    CheckBoxList = <>
    Left = 936
    Top = 32
  end
  object UnitAssortmentCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'UnitName'
    Params = <>
    AfterPost = UnitAssortmentCDSAfterPost
    Left = 696
    Top = 34
  end
  object GetUnitsAssortmentList: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitForSAUA'
    DataSet = UnitAssortmentCDS
    DataSets = <
      item
        DataSet = UnitAssortmentCDS
      end>
    Params = <>
    PackSize = 1
    Left = 608
    Top = 34
  end
  object UnitsRecipientDS: TDataSource
    DataSet = UnitsRecipientCDS
    Left = 352
    Top = 24
  end
  object UnitAssortmentDS: TDataSource
    DataSet = UnitAssortmentCDS
    Left = 792
    Top = 32
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_AutoCalculation_SAUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'DateStart'
        Value = 44197d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateEnd'
        Value = 44197d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitAssortmentName'
        Value = ''
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Threshold'
        Value = 1.000000000000000000
        Component = ceThreshold
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaysStock'
        Value = 10.000000000000000000
        Component = ceDaysStock
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountPharmacies'
        Value = 1.000000000000000000
        Component = ceCountPharmacies
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsClose'
        Value = True
        Component = cbGoodsClose
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMCSIsClose'
        Value = False
        Component = cbMCSIsClose
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotCheckNoMCS'
        Value = False
        Component = cbNotCheckNoMCS
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAssortmentRound'
        Value = False
        Component = cbAssortmentRound
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNeedRound'
        Value = False
        Component = cbNeedRound
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitRecipient'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitRecipient'
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitAssortment'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitAssortment'
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 360
  end
end
