inherited ChoiceGoodsSPSearch_1303Form: TChoiceGoodsSPSearch_1303Form
  ActiveControl = edCodeSearch
  Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1055#1086#1089#1090'. 1303 ('#1056#1054#1054#1062')'
  ClientHeight = 462
  ClientWidth = 743
  ShowHint = True
  AddOnFormData.isAlwaysRefresh = True
  ExplicitWidth = 761
  ExplicitHeight = 509
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 743
    Height = 435
    ExplicitTop = 27
    ExplicitWidth = 743
    ExplicitHeight = 435
    ClientRectBottom = 435
    ClientRectRight = 743
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 743
      ExplicitHeight = 435
      inherited cxGrid: TcxGrid
        Top = 27
        Width = 743
        Height = 408
        ExplicitTop = 27
        ExplicitWidth = 743
        ExplicitHeight = 408
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
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
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
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.CellAutoHeight = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object isOrder408: TcxGridDBColumn
            Caption = #1055#1088#1080#1082#1072#1079' 408'
            DataBinding.FieldName = 'isOrder408'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object MorionCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1084#1086#1088#1080#1086#1085#1072
            DataBinding.FieldName = 'MorionCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 263
          end
          object colIntenalSP_1303Name: TcxGridDBColumn
            Caption = 
              #9#1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1072#1073#1086' '#1079#1072#1075#1072#1083#1100#1085#1086#1087#1088#1080#1081#1085#1103#1090#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086 +
              ' '#1079#1072#1089#1086#1073#1091
            DataBinding.FieldName = 'IntenalSP_1303Name'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' '#1082#1086#1085#1090#1072#1082#1090#1085#1086#1075#1086' '#1083#1080#1094#1072
            Options.Editing = False
            Width = 220
          end
          object colBrandSPName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1077#1083#1100#1085#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
            DataBinding.FieldName = 'BrandSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 209
          end
          object colKindOutSP_1303Name: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
            DataBinding.FieldName = 'KindOutSP_1303Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 195
          end
          object colDosage_1303Name: TcxGridDBColumn
            Caption = #1044#1086#1079#1091#1074#1072#1085#1085#1103' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
            DataBinding.FieldName = 'Dosage_1303Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 136
          end
          object colCountSP_1303Name: TcxGridDBColumn
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1090#1072#1073#1083#1077#1090#1086#1082' '#1074' '#1091#1087#1072#1082#1086#1074#1094#1110' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
            DataBinding.FieldName = 'CountSP_1303Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object colMakerCountrySP_1303Name: TcxGridDBColumn
            Caption = #1053#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072', '#1082#1088#1072#1111#1085#1072' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
            DataBinding.FieldName = 'MakerCountrySP_1303Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 180
          end
          object colPriceOptSP: TcxGridDBColumn
            Caption = #1054#1087#1090#1086#1074#1086'-'#1074#1110#1076#1087#1091#1089#1082#1085#1072' '#1094#1110#1085#1072
            DataBinding.FieldName = 'PriceOptSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object colColor_Count: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object PriceOOC: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1087#1088#1080#1093#1086#1076' '#1094#1077#1085#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'  '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'PriceOOC'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 115
          end
          object PriceSale: TcxGridDBColumn
            Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 743
        Height = 27
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object edCodeSearch: TcxTextEdit
          Left = 235
          Top = 4
          Hint = #1053#1072#1078#1084#1080#1090#1077' Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
          TabOrder = 0
          Width = 276
        end
        object cxLabel3: TcxLabel
          Left = 517
          Top = 5
          Caption = 'Enter'
          Style.TextColor = 6118749
        end
        object btnClearFilter: TcxButton
          Left = 553
          Top = 1
          Width = 153
          Height = 25
          Action = actClearFilter
          TabOrder = 2
        end
      end
      object edOperDateEnd: TcxDateEdit
        Left = 424
        Top = 135
        EditValue = 43326d
        Enabled = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        StyleDisabled.Color = clWindow
        StyleDisabled.TextColor = clWindowText
        TabOrder = 2
        Width = 103
      end
      object cxLabel4: TcxLabel
        Left = 424
        Top = 117
        Caption = #1087#1086
      end
      object edOperDateStart: TcxDateEdit
        Left = 317
        Top = 135
        EditValue = 43326d
        Enabled = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        StyleDisabled.Color = clWindow
        StyleDisabled.TextColor = clWindowText
        TabOrder = 4
        Width = 93
      end
      object cxLabel1: TcxLabel
        Left = 317
        Top = 117
        Caption = #1055#1077#1088#1080#1086#1076' '#1076#1077#1081#1089#1090#1074#1080#1103'  '#1089
      end
    end
  end
  object cxLabel2: TcxLabel [1]
    Left = 12
    Top = 30
    Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1052#1053#1053'/'#1058#1086#1088#1075#1085#1072#1079#1074#1072#1085#1080#1102' '#1083#1077#1082#1089#1088#1077#1076#1089#1090#1074#1072
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      AfterAction = actSetEnabled
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
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
        end>
      ActionList = <
        item
          Action = actRefresh
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1092#1080#1083#1100#1090#1088#1099' [Esc]'
      ImageIndex = 58
      ShortCut = 27
    end
    object actGoodsMain: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TIntenalSPForm'
      FormName = 'TGoodsMainForm'
      FormNameParam.Value = 'TGoodsMainForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'GoodsID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actClearGoods: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spClearGoods
      StoredProcList = <
        item
          StoredProc = spClearGoods
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084
      ImageIndex = 52
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084'?'
    end
    object actSetGoods: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actGoodsMain
      PostDataSetBeforeExecute = False
      StoredProc = spSetGoods
      StoredProcList = <
        item
          StoredProc = spSetGoods
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084
      ImageIndex = 79
    end
    object actSetVisible: TdsdSetVisibleAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetVisible'
      SetVisibleParams = <
        item
          Component = bbClearGoods
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isVisibleEdit'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = bbSetGoods
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isVisibleEdit'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end>
    end
    object actSetEnabled: TdsdSetEnabledAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actSetVisible
      Caption = 'actSetEnabled'
      SetEnabledParams = <
        item
          Component = actSetGoods
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isEnableEdit'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end
        item
          Component = actClearGoods
          ValueParam.Value = Null
          ValueParam.Component = FormParams
          ValueParam.ComponentItem = 'isEnableEdit'
          ValueParam.DataType = ftBoolean
          ValueParam.MultiSelectSeparator = ','
        end>
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
    StoredProcName = 'gpSelect_GoodsSPSearch_1303'
    Params = <
      item
        Name = 'inText'
        Value = Null
        Component = edCodeSearch
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
      27
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
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSetGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbClearGoods'
        end>
    end
    object bbDeleteGoodsLink: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      Visible = ivAlways
      ImageIndex = 2
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
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edOperDateStart
    end
    object dxBarControlContainerItem3: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel4
    end
    object dxBarControlContainerItem4: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edOperDateEnd
    end
    object bbSetGoods: TdxBarButton
      Action = actSetGoods
      Category = 0
    end
    object bbClearGoods: TdxBarButton
      Action = actClearGoods
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        BackGroundValueColumn = colColor_Count
        ColorValueList = <>
      end>
    Left = 296
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
      end
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEnableEdit'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVisibleEdit'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 200
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_GoodsSPSearch_1303'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateStart'
        Value = Null
        Component = edOperDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEnableEdit'
        Value = Null
        Component = FormParams
        ComponentItem = 'isEnableEdit'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isVisibleEdit'
        Value = Null
        Component = FormParams
        ComponentItem = 'isVisibleEdit'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 208
  end
  object spSetGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_GoodsSPSearch_1303_Goods'
    DataSets = <
      item
      end>
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
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsID'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCol'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Col'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 280
  end
  object spClearGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_GoodsSPSearch_1303_ClearGoods'
    DataSets = <
      item
      end>
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
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCol'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Col'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 344
  end
end
