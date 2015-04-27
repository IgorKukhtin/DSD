inherited ChoiceGoodsFromPriceListForm: TChoiceGoodsFromPriceListForm
  ActiveControl = edGoodsSearch
  Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1093
  ClientWidth = 832
  ExplicitWidth = 840
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 832
    ExplicitWidth = 798
    ClientRectRight = 832
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 798
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Top = 27
        Width = 832
        Height = 255
        ExplicitTop = 27
        ExplicitWidth = 798
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
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colBarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = mactChoiceGoodsForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 39
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 154
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object colGoodsNDS: TcxGridDBColumn
            Caption = #1053#1044#1057' '#1080#1079' '#1087#1088#1072#1081#1089#1072
            DataBinding.FieldName = 'GoodsNDS'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object colNDS: TcxGridDBColumn
            Caption = #1053#1044#1057' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'NDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0 %; ; ;'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colMargin: TcxGridDBColumn
            Caption = #1053#1072#1094#1077#1085#1082#1072
            DataBinding.FieldName = 'MarginPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.## %'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colCashPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'NewPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object colContractName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colProducerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'ProducerName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object colExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object colMinimumLot: TcxGridDBColumn
            Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1087#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'MinimumLot'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
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
        ExplicitWidth = 798
        object edGoodsSearch: TcxTextEdit
          Left = 83
          Top = 3
          TabOrder = 1
          Width = 158
        end
        object cxLabel1: TcxLabel
          Left = 3
          Top = 4
          Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072
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
      StoredProc = spSetPriceListLink
      StoredProcList = <
        item
          StoredProc = spSetPriceListLink
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
    object actSetGoodsLink: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGoodsPriceListLink
      StoredProcList = <
        item
          StoredProc = spGoodsPriceListLink
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
      StoredProc = spDeleteLink
      StoredProcList = <
        item
          StoredProc = spDeleteLink
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
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
    StoredProcName = 'gpSelect_GoodsSearch'
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
          ItemName = 'bbGoodsPriceListLink'
        end
        item
          Visible = True
          ItemName = 'bbDeleteGoodsLink'
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
    object bbDeleteGoodsLink: TdxBarButton
      Action = mactGoodsLinkDelete
      Category = 0
    end
    object bbGoodsPriceListLink: TdxBarButton
      Action = actSetGoodsLink
      Category = 0
    end
  end
  object spSetPriceListLink: TdsdStoredProc
    StoredProcName = 'gpUpdate_LoadPriceList_GoodsId'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPriceListItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 176
    Top = 152
  end
  object spGoodsPriceListLink: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsPriceListLink'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPriceListItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 272
    Top = 152
  end
  object spDeleteLink: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LinkGoodsId'
        ParamType = ptInputOutput
      end>
    PackSize = 1
    Left = 344
    Top = 160
  end
end
