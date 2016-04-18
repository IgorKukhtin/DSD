inherited ChoiceGoodsFromRemainsForm: TChoiceGoodsFromRemainsForm
  ActiveControl = edGoodsSearch
  Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
  ClientWidth = 832
  ShowHint = True
  ExplicitWidth = 848
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
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCommonCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1052#1072#1088#1080#1086#1085#1072
            DataBinding.FieldName = 'CommonCode'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 244
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
          object colNDSkindName: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDSkindName'
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
            Properties.DisplayFormat = ',0.00'
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
            Properties.DisplayFormat = ',0.00'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
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
        object edGoodsSearch: TcxTextEdit
          Left = 83
          Top = 3
          Hint = #1053#1072#1078#1084#1080#1090#1077' Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
          TabOrder = 1
          Width = 279
        end
        object cxLabel1: TcxLabel
          Left = 3
          Top = 4
          Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072
        end
        object cxLabel3: TcxLabel
          Left = 368
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
  inherited ActionList: TActionList
    object mactGoodsLinkDelete: TMultiAction
      Category = 'Delete'
      MoveParams = <
        item
          FromParam.Value = '0'
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'GoodsId'
        end
        item
          FromParam.Value = Null
          FromParam.DataType = ftString
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'Code'
        end
        item
          FromParam.Value = Null
          FromParam.DataType = ftString
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'Name'
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
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
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
      ActiveControl = edGoodsSearch
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
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'GoodsId'
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
          ToParam.Value = Null
          ToParam.Component = edGoodsSearch
          ToParam.DataType = ftString
          ToParam.ParamType = ptInput
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
        Name = 'inGoodsSearch'
        Value = Null
        Component = edGoodsSearch
        DataType = ftString
        ParamType = ptInput
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
