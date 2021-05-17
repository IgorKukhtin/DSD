inherited Report_KilledCodeRecoveryForm: TReport_KilledCodeRecoveryForm
  Caption = 'C'#1080#1089#1090#1077#1084#1072' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103' '#1091#1073#1080#1090#1086#1075#1086' '#1082#1086#1076#1072
  ClientHeight = 567
  ClientWidth = 734
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 750
  ExplicitHeight = 606
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 79
    Width = 734
    Height = 488
    TabOrder = 3
    ExplicitTop = 79
    ExplicitWidth = 734
    ExplicitHeight = 488
    ClientRectBottom = 488
    ClientRectRight = 734
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 734
      ExplicitHeight = 488
      inherited cxGrid: TcxGrid
        Width = 734
        Height = 488
        ExplicitWidth = 734
        ExplicitHeight = 488
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
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
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaOrder
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = AmountOrder
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Remains
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 219
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 184
          end
          object MCSIsCloseDateChange: TcxGridDBColumn
            Caption = #1059#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
            DataBinding.FieldName = 'MCSIsCloseDateChange'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object CountUnit: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082' '#1089' '#1079#1072#1087#1088#1077#1090#1086#1084
            DataBinding.FieldName = 'CountUnit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object CountSelling: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082' '#1089' '#1087#1088#1086#1076#1072#1078#1072#1084#1080
            DataBinding.FieldName = 'CountSelling'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object Price_min: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1082#1091#1087#1082#1080' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'Price_min'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object AmountOrder: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object SummaOrder: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'SummaOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 116
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 734
    Height = 53
    ExplicitWidth = 734
    ExplicitHeight = 53
    inherited deStart: TcxDateEdit
      Left = 129
      Top = 51
      Visible = False
      ExplicitLeft = 129
      ExplicitTop = 51
    end
    inherited deEnd: TcxDateEdit
      Left = 337
      Top = 52
      Visible = False
      ExplicitLeft = 337
      ExplicitTop = 52
    end
    inherited cxLabel1: TcxLabel
      Left = 14
      Top = 52
      Visible = False
      ExplicitLeft = 14
      ExplicitTop = 52
    end
    inherited cxLabel2: TcxLabel
      Left = 222
      Top = 52
      Visible = False
      ExplicitLeft = 222
      ExplicitTop = 52
    end
    object edSalesThreshold: TcxCurrencyEdit
      Left = 632
      Top = 8
      EditValue = 1.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 4
      Width = 90
    end
    object cxLabel3: TcxLabel
      Left = 547
      Top = 9
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
      Caption = #1055#1086#1088#1086#1075' '#1087#1088#1086#1076#1072#1078' '
    end
    object edPercePharmaciesd: TcxCurrencyEdit
      Left = 451
      Top = 8
      EditValue = 60.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 6
      Width = 90
    end
    object cxLabel4: TcxLabel
      Left = 292
      Top = 9
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
      Caption = #1055#1088#1086#1094#1077#1085#1090' '#1088#1072#1089#1089#1084#1086#1090#1088#1077#1085#1080#1103' '#1072#1087#1090#1077#1082
    end
    object edRangeOfDays: TcxCurrencyEdit
      Left = 200
      Top = 8
      EditValue = 200.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 8
      Width = 90
    end
    object cxLabel5: TcxLabel
      Left = 19
      Top = 9
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
      Caption = #1044#1080#1072#1087#1072#1079#1086#1085' '#1088#1072#1089#1089#1084#1086#1090#1088#1077#1085#1080#1103' '#1076#1085#1077#1081
    end
    object cxLabel6: TcxLabel
      Left = 19
      Top = 30
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1072#1087#1090#1077#1082
    end
    object cxDBTextEdit1: TcxDBTextEdit
      Left = 200
      Top = 29
      DataBinding.DataField = 'CountUnitAll'
      DataBinding.DataSource = MasterDS
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 57
    end
    object cxDBTextEdit2: TcxDBTextEdit
      Left = 451
      Top = 29
      DataBinding.DataField = 'GoodsCount'
      DataBinding.DataSource = MasterDS
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 57
    end
    object cxLabel7: TcxLabel
      Left = 292
      Top = 30
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1086#1074#1072#1088#1086#1074
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
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
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_KilledCodeRecoveryDialogForm'
      FormNameParam.Value = 'TReport_KilledCodeRecoveryDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'RangeOfDays'
          Value = Null
          Component = edRangeOfDays
          MultiSelectSeparator = ','
        end
        item
          Name = 'PercePharmaciesd'
          Value = ''
          Component = edPercePharmaciesd
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'SalesThreshold'
          Value = ''
          Component = edSalesThreshold
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenSalesOfTermDrugsUnit: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1072#1087#1090#1077#1082#1077
      ImageIndex = 1
      FormName = 'TReport_KilledCodeRecoveryUnitForm'
      FormNameParam.Value = 'TReport_KilledCodeRecoveryUnitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          MultiSelectSeparator = ','
        end
        item
          Name = 'DaysBeforeDelay'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      CheckIDRecords = True
      ActionType = acUpdate
      DataSource = MasterDS
      IdFieldName = 'UnitId'
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 208
    Top = 168
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_KilledCodeRecovery'
    Params = <
      item
        Name = 'inRangeOfDays'
        Value = Null
        Component = edRangeOfDays
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercePharmaciesd'
        Value = 41395d
        Component = edPercePharmaciesd
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSalesThreshold'
        Value = Null
        Component = edSalesThreshold
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 144
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbGoodsPartyReport: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Visible = ivAlways
      ImageIndex = 39
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actOpenSalesOfTermDrugsUnit
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenSalesOfTermDrugsUnit
      end>
    Left = 424
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 272
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
      end
      item
        Component = deStart
      end
      item
      end>
    Left = 96
    Top = 144
  end
end
