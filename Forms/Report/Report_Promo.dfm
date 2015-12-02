inherited Report_PromoForm: TReport_PromoForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1072#1082#1094#1080#1103#1084
  ClientHeight = 434
  ClientWidth = 833
  AddOnFormData.ExecuteDialogAction = actReport_PromoDialog
  ExplicitLeft = -60
  ExplicitWidth = 849
  ExplicitHeight = 469
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 833
    Height = 377
    TabOrder = 3
    ExplicitTop = 57
    ExplicitWidth = 833
    ExplicitHeight = 377
    ClientRectBottom = 377
    ClientRectRight = 833
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 833
      ExplicitHeight = 377
      inherited cxGrid: TcxGrid
        Width = 833
        Height = 377
        ExplicitWidth = 833
        ExplicitHeight = 377
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.###'
              Kind = skSum
              Column = colAmountPlanMinWeight
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = colAmountPlanMaxWeight
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = colAmountRealWeight
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = colAmountOrderWeight
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = colAmountOutWeight
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = colAmountInWeight
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 41
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object colPersonalTradeName: TcxGridDBColumn
            Caption = #1050#1086#1084'. '#1086#1090#1076#1077#1083
            DataBinding.FieldName = 'PersonalTradeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object colPersonalName: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090'. '#1086#1090#1076#1077#1083
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object colDateStartSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DateStartSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colDeteFinalSale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DeteFinalSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colDateStartPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'DateStartPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object colDateFinalPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'DateFinalPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object colRetailName: TcxGridDBColumn
            Caption = #1057#1077#1090#1100', '#1074' '#1082#1086#1090#1086#1088#1086#1081' '#1087#1088#1086#1093#1086#1076#1080#1090' '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 114
          end
          object colAreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1055#1086#1079#1080#1094#1080#1103
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1079#1080#1094#1080#1080
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object colMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object colTradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colAmountPlanMin: TcxGridDBColumn
            Caption = #1052#1080#1085#1080#1084#1091#1084' '#1087#1083#1072#1085#1080#1088#1091#1077#1084#1086#1075#1086' '#1086#1073#1098#1077#1084#1072' '#1087#1088#1086#1076#1072#1078' '#1074' '#1072#1082#1094#1080#1086#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076', '#1082#1075','#1096#1090
            DataBinding.FieldName = 'AmountPlanMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 117
          end
          object colAmountPlanMinWeight: TcxGridDBColumn
            Caption = #1052#1080#1085#1080#1084#1091#1084' '#1087#1083#1072#1085#1080#1088#1091#1077#1084#1086#1075#1086' '#1086#1073#1098#1077#1084#1072' '#1087#1088#1086#1076#1072#1078' '#1074' '#1072#1082#1094#1080#1086#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076', ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountPlanMinWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 111
          end
          object colAmountPlanMax: TcxGridDBColumn
            Caption = #1052#1072#1082#1089#1080#1084#1091#1084' '#1087#1083#1072#1085#1080#1088#1091#1077#1084#1086#1075#1086' '#1086#1073#1098#1077#1084#1072' '#1087#1088#1086#1076#1072#1078' '#1074' '#1072#1082#1094#1080#1086#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076', '#1082#1075','#1096#1090
            DataBinding.FieldName = 'AmountPlanMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 99
          end
          object colAmountPlanMaxWeight: TcxGridDBColumn
            Caption = #1052#1072#1082#1089#1080#1084#1091#1084' '#1087#1083#1072#1085#1080#1088#1091#1077#1084#1086#1075#1086' '#1086#1073#1098#1077#1084#1072' '#1087#1088#1086#1076#1072#1078' '#1074' '#1072#1082#1094#1080#1086#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076', ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountPlanMaxWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 104
          end
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object colGoodsWeight: TcxGridDBColumn
            Caption = #1042#1077#1089
            DataBinding.FieldName = 'GoodsWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 43
          end
          object colDiscount: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072', %'
            DataBinding.FieldName = 'Discount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 59
          end
          object colPriceWithOutVAT: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1086#1095#1085#1072#1103' '#1072#1082#1094#1080#1086#1085#1085#1072#1103' '#1094#1077#1085#1072' '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1053#1044#1057', '#1075#1088#1085
            DataBinding.FieldName = 'PriceWithOutVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colPriceWithVAT: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1086#1095#1085#1072#1103' '#1072#1082#1094#1080#1086#1085#1085#1072#1103' '#1094#1077#1085#1072' '#1089' '#1091#1095#1077#1090#1086#1084' '#1053#1044#1057', '#1075#1088#1085
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080' '#1089' '#1053#1044#1057', '#1075#1088#1085
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object colCostPromo: TcxGridDBColumn
            Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103
            DataBinding.FieldName = 'CostPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colAdvertisingName: TcxGridDBColumn
            Caption = #1056#1077#1082#1083#1072#1084#1085'. '#1087#1086#1076#1076#1077#1088#1078#1082#1072
            DataBinding.FieldName = 'AdvertisingName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1074#1085#1077#1089#1077#1085#1080#1103' '#1074' '#1073#1072#1079#1091
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colPriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1085#1072' '#1087#1086#1083#1082#1077'/'#1089#1082#1080#1076#1082#1072' '#1076#1083#1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object colAmountReal: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountReal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object colAmountRealWeight: TcxGridDBColumn
            Caption = #1055#1088#1086#1076'. '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountRealWeight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object colAmountOrder: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1082#1072' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object colAmountOrderWeight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1082#1072' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountOrderWeight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 64
          end
          object colAmountOut: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 67
          end
          object colAmountOutWeight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountOutWeight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object colAmountIn: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088#1072#1090' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object colAmountInWeight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088#1072#1090' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountInWeight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 164
          end
          object colShowAll: TcxGridDBColumn
            DataBinding.FieldName = 'ShowAll'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 833
    ExplicitWidth = 833
    inherited deStart: TcxDateEdit
      EditValue = 42309d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42309d
    end
    object cxLabel17: TcxLabel
      Left = 417
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 507
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
          Value = Null
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'DateEnd'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1072#1082#1094#1080#1103#1084
      ReportNameParam.DataType = ftString
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
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenPromo: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1072#1082#1094#1080#1080
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1072#1082#1094#1080#1080
      ImageIndex = 1
      FormName = 'TPromoForm'
      FormNameParam.Value = 'TPromoForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
        end
        item
          Name = 'ShowAll'
          Value = 'False'
          DataType = ftBoolean
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 144
  end
  inherited MasterCDS: TClientDataSet
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_Promo'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Top = 144
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'dxBarButton2'
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
          ItemName = 'dxBarButton3'
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
    Left = 136
    Top = 64
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Top = 184
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 700
  end
end
