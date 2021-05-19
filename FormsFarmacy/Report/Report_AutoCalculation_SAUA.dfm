inherited Report_AutoCalculation_SAUAForm: TReport_AutoCalculation_SAUAForm
  Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080#1081' '#1088#1072#1089#1095#1077#1090' '#1057#1059#1040
  ClientHeight = 567
  ClientWidth = 809
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 825
  ExplicitHeight = 606
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 196
    Width = 809
    Height = 371
    TabOrder = 3
    ExplicitTop = 196
    ExplicitWidth = 788
    ExplicitHeight = 371
    ClientRectBottom = 371
    ClientRectRight = 809
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 788
      ExplicitHeight = 371
      inherited cxGrid: TcxGrid
        Width = 809
        Height = 371
        ExplicitWidth = 788
        ExplicitHeight = 371
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DataSource = nil
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
            end
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
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Need
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          Styles.Content = dmMain.cxContentStyle
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Footer = dmMain.cxFooterStyle
          Styles.Header = dmMain.cxHeaderStyle
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Caption = #1055#1088#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1100
              Width = 525
            end
            item
              Caption = #1056#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
              Width = 259
            end>
          object GoodsCode: TcxGridDBBandedColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object GoodsName: TcxGridDBBandedColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 320
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Remains: TcxGridDBBandedColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object Need: TcxGridDBBandedColumn
            Caption = #1055#1086#1090#1088#1077#1073#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'Need'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object AmountCheck: TcxGridDBBandedColumn
            Caption = #1055#1088#1086#1076#1072#1078#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object CountUnit: TcxGridDBBandedColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1072#1087#1090#1077#1082
            DataBinding.FieldName = 'CountUnit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Assortment: TcxGridDBBandedColumn
            Caption = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090
            DataBinding.FieldName = 'Assortment'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 809
    Height = 170
    ExplicitWidth = 788
    ExplicitHeight = 170
    inherited deStart: TcxDateEdit
      Left = 172
      Top = 11
      EditValue = 44197d
      Properties.ReadOnly = True
      ExplicitLeft = 172
      ExplicitTop = 11
    end
    inherited deEnd: TcxDateEdit
      Left = 172
      Top = 32
      EditValue = 44197d
      Properties.ReadOnly = True
      ExplicitLeft = 172
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 14
      Top = 12
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1086#1076#1072#1078':'
      ExplicitLeft = 14
      ExplicitTop = 12
      ExplicitWidth = 133
    end
    inherited cxLabel2: TcxLabel
      Left = 14
      Top = 33
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1086#1076#1072#1078':'
      ExplicitLeft = 14
      ExplicitTop = 33
      ExplicitWidth = 152
    end
    object cxLabel3: TcxLabel
      Left = 14
      Top = 91
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
      Caption = #1040#1087#1090#1077#1082#1080' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
    end
    object edRecipient: TcxTextEdit
      Left = 14
      Top = 70
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 338
    end
    object cxLabel6: TcxLabel
      Left = 14
      Top = 51
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
      Caption = #1040#1087#1090#1077#1082#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1100
    end
    object edAssortment: TcxMemo
      Left = 14
      Top = 110
      Properties.ReadOnly = True
      TabOrder = 7
      Height = 54
      Width = 338
    end
    object ceDaysStock: TcxCurrencyEdit
      Left = 546
      Top = 31
      EditValue = 10.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 60
    end
    object cxLabel5: TcxLabel
      Left = 364
      Top = 12
      Caption = #1055#1086#1088#1086#1075' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1093' '#1087#1088#1086#1076#1072#1078':'
    end
    object cxLabel4: TcxLabel
      Left = 365
      Top = 32
      Caption = #1044#1085#1077#1081' '#1079#1072#1087#1072#1089#1072' '#1091' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103':'
    end
    object cxLabel7: TcxLabel
      Left = 365
      Top = 52
      Hint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072' '#1080#1079' '#1074#1099#1073#1088#1072#1085#1085#1099#1093
      Caption = #1052#1080#1085'. '#1082#1086#1083'-'#1074#1086' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
      ParentShowHint = False
      ShowHint = True
    end
    object ceThreshold: TcxCurrencyEdit
      Left = 546
      Top = 11
      EditValue = 1.000000000000000000
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 60
    end
    object ceCountPharmacies: TcxCurrencyEdit
      Left = 546
      Top = 51
      Hint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072' '#1080#1079' '#1074#1099#1073#1088#1072#1085#1085#1099#1093
      EditValue = 1.000000000000000000
      ParentShowHint = False
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 13
      Width = 60
    end
    object cbAssortmentRound: TcxCheckBox
      Left = 364
      Top = 143
      Caption = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090' '#1086#1082#1088#1091#1075#1083#1103#1090#1100' '#1087#1086' '#1084#1072#1090' '#1087#1088#1080#1085#1094#1080#1087#1091
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 234
    end
    object cbNeedRound: TcxCheckBox
      Left = 364
      Top = 126
      Caption = #1055#1086#1090#1088#1077#1073#1085#1086#1089#1090#1100' '#1086#1082#1088#1091#1075#1083#1103#1090#1100' '#1087#1086' '#1084#1072#1090' '#1087#1088#1080#1085#1094#1080#1087#1091
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 234
    end
    object cbNotCheckNoMCS: TcxCheckBox
      Left = 364
      Top = 108
      Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1055#1088#1086#1076#1072#1078#1080' '#1085#1077' '#1076#1083#1103' '#1053#1058#1047
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 217
    end
    object cbMCSIsClose: TcxCheckBox
      Left = 364
      Top = 91
      Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1059#1073#1080#1090' '#1082#1086#1076' '
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 201
    end
    object cbGoodsClose: TcxCheckBox
      Left = 364
      Top = 74
      Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1047#1072#1082#1088#1099#1090' '#1082#1086#1076
      Properties.ReadOnly = True
      State = cbsChecked
      TabOrder = 18
      Width = 167
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 83
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
  end
  inherited ActionList: TActionList
    Left = 119
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_AutoCalculation_SAUADialogForm'
      FormNameParam.Value = 'TReport_AutoCalculation_SAUADialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = edRecipient
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitAssortmentName'
          Value = ''
          Component = edAssortment
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
      FormName = 'TReport_AutoCalculation_SAUAUnitForm'
      FormNameParam.Value = 'TReport_AutoCalculation_SAUAUnitForm'
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
    Left = 24
    Top = 144
  end
  inherited MasterCDS: TClientDataSet
    Left = 208
    Top = 168
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Calculation_SAUA'
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
        ComponentItem = 'UnitRecipient'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssortmentList'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitAssortment'
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdMCS'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdMCSLarge'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRemains'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdRemains'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inThresholdRemainsLarge'
        Value = 0.000000000000000000
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
    Left = 16
    Top = 328
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
    Left = 272
    Top = 272
  end
  inherited PopupMenu: TPopupMenu
    Left = 184
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
  object FormParams: TdsdFormParams
    Params = <
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
    Left = 638
    Top = 84
  end
end
