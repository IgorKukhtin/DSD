inherited ChoiceGoodsFromRemainsForm: TChoiceGoodsFromRemainsForm
  ActiveControl = edCodeSearch
  Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
  ClientWidth = 832
  ShowHint = True
  ExplicitWidth = 848
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 832
    ExplicitWidth = 832
    ClientRectRight = 832
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 832
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Top = 27
        Width = 832
        Height = 255
        ExplicitTop = 27
        ExplicitWidth = 832
        ExplicitHeight = 255
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
              Column = colAmountAll
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
              Column = colAmountAll
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object c0lPhone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1082#1086#1085#1090'.'#1083#1080#1094#1086')'
            DataBinding.FieldName = 'Phone'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' '#1082#1086#1085#1090#1072#1082#1090#1085#1086#1075#1086' '#1083#1080#1094#1072
            Options.Editing = False
            Width = 109
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
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
            Width = 101
          end
          object colPriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
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
          object colPriceSaleIncome: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' ('#1090#1086#1074#1072#1088' '#1074' '#1087#1091#1090#1080')'
            DataBinding.FieldName = 'PriceSaleIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object colAmountIncome: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' '#1074' '#1087#1091#1090#1080
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
          object colAmountAll: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1089' '#1091#1095'. '#1090#1086#1074'. '#1074' '#1087#1091#1090#1080
            DataBinding.FieldName = 'AmountAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090#1072#1090#1086#1082' ('#1089' '#1091#1095#1077#1090#1086#1084' '#1090#1086#1074#1072#1088#1072' '#1074' '#1087#1091#1090#1080') '
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
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 217
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
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
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 832
        Height = 27
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
          Left = 258
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
          Left = 656
          Top = 0
          Width = 153
          Height = 25
          Action = actClearFilter
          TabOrder = 3
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
    Left = 334
    Top = 29
    Hint = #1053#1072#1078#1084#1080#1090#1077' Ctrl+Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
    TabOrder = 6
    Width = 224
  end
  object cxLabel4: TcxLabel [3]
    Left = 559
    Top = 30
    Caption = 'Ctrl+Enter'
    Style.TextColor = 6118749
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
    StoredProcName = 'gpSelect_GoodsSearchRemains'
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 536
    Top = 208
  end
end
