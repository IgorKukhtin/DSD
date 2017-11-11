inherited Report_PromoPlanForm: TReport_PromoPlanForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1072#1082#1094#1080#1103#1084
  ClientHeight = 434
  ClientWidth = 885
  AddOnFormData.ExecuteDialogAction = actReport_PromoDialog
  ExplicitWidth = 901
  ExplicitHeight = 472
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 885
    Height = 351
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 833
    ExplicitHeight = 351
    ClientRectBottom = 351
    ClientRectRight = 885
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 833
      ExplicitHeight = 351
      inherited cxGrid: TcxGrid
        Width = 885
        Height = 351
        ExplicitWidth = 833
        ExplicitHeight = 351
        inherited cxGridDBTableView: TcxGridDBTableView
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
              Format = ',0.####'
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
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 41
          end
          object UnitName: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object DateStartSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DateStartSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DeteFinalSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DeteFinalSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DateStartPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'DateStartPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object DateFinalPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'DateFinalPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object MonthPromo: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'MonthPromo'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
            DataBinding.FieldName = 'PartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1079#1080#1094#1080#1080
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1055#1086#1079#1080#1094#1080#1103
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
          end
          object TradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'GoodsKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object GoodsWeight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'GoodsWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 43
          end
          object Checked: TcxGridDBColumn
            Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086
            DataBinding.FieldName = 'Checked'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object isPromo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103
            DataBinding.FieldName = 'isPromo'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1083#1080' '#1044#1072' - '#1101#1090#1086' '#1040#1082#1094#1080#1103', '#1053#1077#1090' - '#1058#1077#1085#1076#1077#1088#1099
            Options.Editing = False
            Width = 45
          end
          object AmountPlan1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088'. '#1079#1072' '#1087#1085'.'
            DataBinding.FieldName = 'AmountPlan1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1079#1072' '#1087#1085'.'
            Options.Editing = False
            Width = 80
          end
          object AmountPlan2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088'. '#1079#1072' '#1074#1090'.'
            DataBinding.FieldName = 'AmountPlan2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPlan3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088'. '#1079#1072' '#1089#1088'.'
            DataBinding.FieldName = 'AmountPlan3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPlan4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088'. '#1079#1072' '#1095#1090'.'
            DataBinding.FieldName = 'AmountPlan4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPlan5: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088'. '#1079#1072' '#1087#1090'.'
            DataBinding.FieldName = 'AmountPlan5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPlan6: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088'. '#1079#1072' '#1089#1073'.'
            DataBinding.FieldName = 'AmountPlan66'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPlan7: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088'. '#1079#1072' '#1074#1089'.'
            DataBinding.FieldName = 'AmountPlan7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 885
    Height = 57
    ExplicitWidth = 833
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 114
      EditValue = 42736d
      ExplicitLeft = 114
    end
    inherited deEnd: TcxDateEdit
      Left = 114
      Top = 32
      EditValue = 42736d
      ExplicitLeft = 114
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 22
      ExplicitLeft = 22
    end
    inherited cxLabel2: TcxLabel
      Left = 3
      Top = 33
      ExplicitLeft = 3
      ExplicitTop = 33
    end
    object cxLabel17: TcxLabel
      Left = 211
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 301
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 286
    end
    object cbPromo: TcxCheckBox
      Left = 211
      Top = 32
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080
      State = cbsChecked
      TabOrder = 6
      Width = 144
    end
    object cbTender: TcxCheckBox
      Left = 368
      Top = 32
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1058#1077#1085#1076#1077#1088#1099
      TabOrder = 7
      Width = 165
    end
  end
  inherited ActionList: TActionList
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxMasterDS'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'DateStart'
          Value = 'NULL'
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateEnd'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actReport_PromoDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PromoDialogForm'
      FormNameParam.Value = 'TReport_PromoDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 'NULL'
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPromo'
          Value = Null
          Component = cbPromo
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTender'
          Value = Null
          Component = cbTender
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenPromo: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1040#1082#1094#1080#1103'>'
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1040#1082#1094#1080#1103'>'
      ImageIndex = 1
      FormName = 'TPromoForm'
      FormNameParam.Value = 'TPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
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
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_Promo_Plan'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPromo'
        Value = Null
        Component = cbPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTender'
        Value = Null
        Component = cbTender
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 256
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
          ItemName = 'dxBarButton2'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actReport_PromoDialog
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actOpenPromo
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenPromo
      end>
    ActionItemList = <
      item
        Action = actOpenPromo
        ShortCut = 13
      end>
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 176
    Top = 184
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = UnitGuides
      end>
    Top = 184
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 604
    Top = 8
  end
end
