inherited ChoiceGoodsFromRemains_1303Form: TChoiceGoodsFromRemains_1303Form
  ActiveControl = edCodeSearch
  Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1102' 1303 '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084'-'#1091#1095#1072#1089#1090#1085#1080#1082#1072#1084
  ClientHeight = 420
  ClientWidth = 885
  ShowHint = True
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 901
  ExplicitHeight = 459
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 885
    Height = 394
    ExplicitWidth = 885
    ExplicitHeight = 394
    ClientRectBottom = 394
    ClientRectRight = 885
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 885
      ExplicitHeight = 394
      inherited cxGrid: TcxGrid
        Top = 49
        Width = 885
        Height = 345
        ExplicitTop = 49
        ExplicitWidth = 885
        ExplicitHeight = 345
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colAmountIncome
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReserve
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colAmountIncome
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountReserve
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 185
          end
          object colPartnerMedicalName: TcxGridDBColumn
            Caption = #1052#1077#1076'. '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1082#1084#1091' 1303'
            DataBinding.FieldName = 'PartnerMedicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 145
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 244
          end
          object colNDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0 %; ; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object colPriceOptSP_1303: TcxGridDBColumn
            Caption = #1054#1054#1062' ('#1056#1054#1054#1062')'
            DataBinding.FieldName = 'PriceOptSP_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colPriceSale_1303: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1076#1086#1087#1091#1089#1090'. '#1056#1086#1079#1085' '#1094#1077#1085#1072' ('#1056#1054#1054#1062')'
            DataBinding.FieldName = 'PriceSale_1303'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object colPriceSale: TcxGridDBColumn
            Caption = #1056#1086#1079#1085' '#1094#1077#1085#1072' ('#1082#1072#1089#1089#1072')'
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object DateChange: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1094#1077#1085#1099
            DataBinding.FieldName = 'DateChange'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object colPriceSaleIncome: TcxGridDBColumn
            Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072' ('#1095#1077#1082' '#1055#1050#1052#1059' 1303)'
            DataBinding.FieldName = 'PriceSaleIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colPrice_min: TcxGridDBColumn
            Caption = #1055#1088#1080#1084'. '#1056#1086#1079#1085'. '#1094#1077#1085#1072' '#1087#1088#1080' '#1079#1072#1082#1091#1087#1082#1077' '#1089#1077#1075#1086#1076#1085#1103' ('#1095#1077#1082' '#1087#1086' '#1055#1050#1052#1059' 1303)'
            DataBinding.FieldName = 'Price_min'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 121
          end
          object colPrice_min_NDS: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1094#1077#1085#1072' '#1087#1086#1089#1090'. '#1087#1088#1080' '#1079#1072#1082#1091#1087#1082#1077' '#1089#1077#1075#1086#1076#1085#1103' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'Price_min_NDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object colAmount: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object AmountReserve: TcxGridDBColumn
            Caption = #1054#1090#1083'. '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'AmountReserve'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088
            Options.Editing = False
            Width = 73
          end
          object colAmountIncome: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072') '#1074' '#1087#1091#1090#1080
            DataBinding.FieldName = 'AmountIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' '#1074' '#1087#1091#1090#1080' ('#1087#1088#1080#1093#1086#1076' '#1089#1077#1075#1086#1076#1085#1103') '
            Options.Editing = False
            Width = 98
          end
          object colMinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object JuridicalName_Unit: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName_Unit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object ProvinceCityName_Unit: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085
            DataBinding.FieldName = 'ProvinceCityName_Unit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Address_Unit: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089
            DataBinding.FieldName = 'Address_Unit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Phone_Unit: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1087#1086#1076#1088#1072#1079#1076'.)'
            DataBinding.FieldName = 'Phone_Unit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
            Options.Editing = False
            Width = 71
          end
          object colColor_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
          end
          object celIntenalSPName: TcxGridDBColumn
            Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072
            DataBinding.FieldName = 'IntenalSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 168
          end
          object celBrandSPName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1077#1083#1100#1085#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
            DataBinding.FieldName = 'BrandSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 144
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 885
        Height = 49
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object edCodeSearch: TcxTextEdit
          Left = 94
          Top = 3
          Hint = #1053#1072#1078#1084#1080#1090#1077' Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
          TabOrder = 1
          Width = 101
        end
        object cxLabel1: TcxLabel
          Left = 245
          Top = 4
          Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072
        end
        object cxLabel3: TcxLabel
          Left = 201
          Top = 4
          Caption = 'Enter'
          Style.TextColor = 6118749
        end
        object btnClearFilter: TcxButton
          Left = 620
          Top = 1
          Width = 153
          Height = 25
          Action = actClearFilter
          TabOrder = 3
        end
        object edPartnerMedical: TcxButtonEdit
          Left = 192
          Top = 26
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 4
          Width = 354
        end
        object cxLabel19: TcxLabel
          Left = 12
          Top = 26
          Caption = #1052#1077#1076'. '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1082#1084#1091' 1303'
        end
      end
    end
  end
  object cxLabel2: TcxLabel [1]
    Left = 12
    Top = 30
    Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1082#1086#1076#1091
  end
  object edGoodsSearch: TcxTextEdit [2]
    Left = 322
    Top = 29
    Hint = #1053#1072#1078#1084#1080#1090#1077' Ctrl+Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
    TabOrder = 6
    Width = 224
  end
  object cxLabel4: TcxLabel [3]
    Left = 552
    Top = 30
    Caption = 'Ctrl+Enter'
    Style.TextColor = 6118749
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object mactGoodsLinkDelete: TMultiAction
      Category = 'Delete'
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'GoodsId'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = Null
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'Code'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = Null
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'Name'
          ToParam.MultiSelectSeparator = ','
        end>
      ActionList = <
        item
          Action = actDeleteLink
        end
        item
          Action = DataSetPost
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      ImageIndex = 2
    end
    object DataSetPost: TDataSetPost
      Category = 'Delete'
      Caption = 'P&ost'
      Hint = 'Post'
      DataSource = MasterDS
    end
    object ChoiceGoodsForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ChoiceGoodsForm'
      FormName = 'TGoodsMainLiteForm'
      FormNameParam.Value = 'TGoodsMainLiteForm'
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
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
    object actSetGoodsLink: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actSetGoodsLink'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 27
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1089#1090#1072#1085#1086#1074#1082#1077' '#1089#1074#1103#1079#1077#1081'?'
    end
    object mactChoiceGoodsForm: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ChoiceGoodsForm
        end
        item
          Action = DataSetPost
        end>
      Caption = 'mactChoiceGoodsForm'
    end
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      ActiveControl = edCodeSearch
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 13
    end
    object actDeleteLink: TdsdExecStoredProc
      Category = 'Delete'
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'GoodsId'
          ToParam.MultiSelectSeparator = ','
        end>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
    object actRefreshSearch2: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 16397
    end
    object actClearFilter: TMultiAction
      Category = 'ClearFilter'
      MoveParams = <
        item
          FromParam.Value = ''
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = edCodeSearch
          ToParam.DataType = ftString
          ToParam.ParamType = ptInput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = ''
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = edGoodsSearch
          ToParam.DataType = ftString
          ToParam.ParamType = ptInput
          ToParam.MultiSelectSeparator = ','
        end>
      ActionList = <
        item
          Action = actRefresh
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1092#1080#1083#1100#1090#1088#1099' [Esc]'
      ImageIndex = 58
      ShortCut = 27
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsSearchRemains_1303'
    Params = <
      item
        Name = 'inCodeSearch'
        Value = Null
        Component = edCodeSearch
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSearch'
        Value = Null
        Component = edGoodsSearch
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalID'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 88
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
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbDeleteGoodsLink: TdxBarButton
      Action = mactGoodsLinkDelete
      Category = 0
    end
    object bbGoodsPriceListLink: TdxBarButton
      Action = actSetGoodsLink
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1090#1087#1091#1089#1082#1085#1091#1102' '#1094#1077#1085#1091' '#1076#1083#1103' '#1074#1089#1077#1093' '#1074#1080#1076#1080#1084#1099#1093' '#1089#1090#1088#1086#1082' '
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1090#1087#1091#1089#1082#1085#1091#1102' '#1094#1077#1085#1091' '#1076#1083#1103' '#1074#1089#1077#1093' '#1074#1080#1076#1080#1084#1099#1093' '#1089#1090#1088#1086#1082' '
      Visible = ivAlways
      ImageIndex = 56
    end
    object bbUpdate_PriceSale: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1090#1087#1091#1089#1082#1085#1091#1102' '#1094#1077#1085#1091' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1086#1090#1087#1091#1089#1082#1085#1091#1102' '#1094#1077#1085#1091' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      Visible = ivAlways
      ImageIndex = 75
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        BackGroundValueColumn = colColor_calc
        ColorValueList = <>
      end>
    Left = 536
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Price'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceSite'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelPriceSale'
        Value = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1074#1081#1102' '#1094#1077#1085#1091' '#1076#1083#1103' '#1089#1072#1081#1090#1072
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 200
  end
  object GuidesPartnerMedical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartnerMedical
    FormNameParam.Value = 'TPartnerMedicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerMedicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 401
    Top = 39
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsSearchRemains_1303'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'GuidesPartnerMedicalId'
        Value = ''
        Component = GuidesPartnerMedical
        MultiSelectSeparator = ','
      end
      item
        Name = 'GuidesPartnerMedicalName'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDisableGuides'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'DisableGuidesOpen'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 264
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesPartnerMedical
      end>
    Left = 192
    Top = 144
  end
end
