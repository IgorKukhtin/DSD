inherited CashSummaForDeyForm: TCashSummaForDeyForm
  Caption = #1057#1091#1084#1084#1099' '#1087#1086' '#1082#1072#1089#1089#1077' '#1079#1072' '#1076#1077#1085#1100
  ClientHeight = 336
  ClientWidth = 374
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 390
  ExplicitHeight = 375
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 374
    Height = 277
    ExplicitTop = 59
    ExplicitWidth = 374
    ExplicitHeight = 277
    ClientRectBottom = 277
    ClientRectRight = 374
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 374
      ExplicitHeight = 277
      inherited cxGrid: TcxGrid
        Width = 374
        Height = 159
        ExplicitWidth = 374
        ExplicitHeight = 159
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCash
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCard
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object PaidTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidTypeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 116
          end
          object SummCash: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072#1083#1080#1095#1085#1099#1081' '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'SummCash'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 105
          end
          object SummCard: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1082#1072#1088#1090#1077
            DataBinding.FieldName = 'SummCard'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
        end
      end
      object cxGridNDS: TcxGrid
        Left = 0
        Top = 159
        Width = 374
        Height = 118
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountSumm
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
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
          object NDS: TcxGridDBColumn
            Caption = #1057#1090#1072#1074#1082#1072' '#1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentVert = vaCenter
            Width = 142
          end
          object AmountSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 374
    Height = 33
    Align = alTop
    ShowCaption = False
    TabOrder = 5
    object edOperDate: TcxDateEdit
      Left = 206
      Top = 3
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 100
    end
    object cxLabel2: TcxLabel
      Left = 170
      Top = 4
      Caption = #1044#1072#1090#1072
    end
    object edCashRegisterName: TcxTextEdit
      Left = 49
      Top = 3
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 104
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 4
      Caption = #1050#1072#1089#1089#1072
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 216
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_CashSummaForDey'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ClientDataSet
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inCashRegisterName'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashRegisterName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'Date'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 104
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbRefresh: TdxBarButton
      Left = 280
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 208
      Top = 65528
    end
    inherited bbGridToExcel: TdxBarButton
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 296
    Top = 248
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 216
    Top = 288
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 296
    Top = 288
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'CashRegisterName'
        Value = Null
        Component = edCashRegisterName
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Date'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 104
  end
end
