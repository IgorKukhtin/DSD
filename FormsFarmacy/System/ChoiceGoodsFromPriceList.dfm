inherited ChoiceGoodsFromPriceListForm: TChoiceGoodsFromPriceListForm
  ActiveControl = edGoodsSearch
  Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1093
  ClientHeight = 293
  ClientWidth = 902
  ShowHint = True
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 918
  ExplicitHeight = 332
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 902
    Height = 267
    ExplicitWidth = 902
    ExplicitHeight = 267
    ClientRectBottom = 267
    ClientRectRight = 902
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 902
      ExplicitHeight = 267
      inherited cxGrid: TcxGrid
        Top = 27
        Width = 902
        Height = 240
        ExplicitTop = 27
        ExplicitWidth = 902
        ExplicitHeight = 240
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
            HeaderAlignmentVert = vaCenter
          end
          object colBarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076
            DataBinding.FieldName = 'BarCode'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
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
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 154
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1082#1091#1087#1082#1080' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object colPriceWithNDS: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1082#1091#1087#1082#1080' c '#1053#1044#1057
            DataBinding.FieldName = 'PriceWithNDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object colGoodsNDS: TcxGridDBColumn
            Caption = #1053#1044#1057' '#1080#1079' '#1087#1088#1072#1081#1089#1072
            DataBinding.FieldName = 'GoodsNDS'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object colNDS: TcxGridDBColumn
            Caption = #1053#1044#1057' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'NDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0 %; ; ;'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colMargin: TcxGridDBColumn
            Caption = #1053#1072#1094#1077#1085#1082#1072
            DataBinding.FieldName = 'MarginPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.## %'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colCashPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'. '#1074' '#1072#1087#1090#1077#1082#1077
            DataBinding.FieldName = 'NewPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object colPriceSite: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1076#1083#1103' '#1089#1072#1081#1090#1072
            DataBinding.FieldName = 'PriceSite'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 113
          end
          object colContractName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colProducerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'ProducerName'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 105
          end
          object colExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ExpirationDate'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object colMinimumLot: TcxGridDBColumn
            Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1087#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'MinimumLot'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 902
        Height = 27
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object edGoodsSearch: TcxTextEdit
          Left = 76
          Top = 3
          Hint = #1053#1072#1078#1084#1080#1090#1077' Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
          TabOrder = 1
          Width = 139
        end
        object cxLabel1: TcxLabel
          Left = 3
          Top = 5
          Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072
        end
        object edProducerSearch: TcxTextEdit
          Left = 337
          Top = 3
          Hint = #1053#1072#1078#1084#1080#1090#1077' Ctrl+Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
          TabOrder = 2
          Width = 123
        end
        object cxLabel2: TcxLabel
          Left = 255
          Top = 5
          Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        end
        object cxLabel3: TcxLabel
          Left = 218
          Top = 5
          Caption = 'Enter'
          Style.TextColor = 6118749
        end
        object cxLabel4: TcxLabel
          Left = 459
          Top = 5
          Caption = 'Ctrl+Enter'
          Style.TextColor = 6118749
        end
        object btnClearFilter: TcxButton
          Left = 737
          Top = -4
          Width = 153
          Height = 25
          Action = actClearFilter
          TabOrder = 6
        end
        object cxLabel5: TcxLabel
          Left = 532
          Top = 5
          Caption = #1055#1086' '#1082#1086#1076#1091
        end
        object edCodeSearch: TcxTextEdit
          Left = 580
          Top = 3
          Hint = #1053#1072#1078#1084#1080#1090#1077'Alt+Enter '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072
          TabOrder = 8
          Width = 101
        end
        object cxLabel6: TcxLabel
          Left = 680
          Top = 5
          Caption = 'Alt+Enter'
          Style.TextColor = 6118749
        end
      end
      object cxLabel7: TcxLabel
        Left = 652
        Top = 100
        Caption = #1056#1077#1075#1080#1086#1085
      end
      object edArea: TcxButtonEdit
        Left = 652
        Top = 118
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 3
        Width = 164
      end
    end
  end
  inherited ActionList: TActionList
    object actRefreshStart: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_Area_byUser
      StoredProcList = <
        item
          StoredProc = spGet_Area_byUser
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object macGoodsLinkDeleteSimpl: TMultiAction [1]
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
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1080' '#1091' '#1042#1089#1077#1093' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1080' '#1091' '#1042#1089#1077#1093' '#1090#1086#1074#1072#1088#1086#1074
      ImageIndex = 2
    end
    object mactGoodsLinkDeleteList: TMultiAction
      Category = 'Delete'
      MoveParams = <>
      ActionList = <
        item
          Action = macGoodsLinkDeleteSimpl
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1089#1074#1103#1079#1077#1081'?'
      InfoAfterExecute = #1057#1074#1103#1079#1080' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1099'!'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1080' '#1042#1089#1077#1093' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1080' '#1042#1089#1077#1093' '#1090#1086#1074#1072#1088#1086#1074
      ImageIndex = 2
    end
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
    object spSetGoodsLink: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGoodsPriceListLink
      StoredProcList = <
        item
          StoredProc = spGoodsPriceListLink
        end>
      Caption = 'spSetGoodsLink'
    end
    object macSetGoodsLink: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spSetGoodsLink
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1089#1090#1072#1085#1086#1074#1082#1077' '#1089#1074#1103#1079#1077#1081'?'
      InfoAfterExecute = #1057#1074#1103#1079#1080' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1099'!'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1080' '#1042#1089#1077#1093' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1080' '#1042#1089#1077#1093' '#1090#1086#1074#1072#1088#1086#1074
      ImageIndex = 27
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
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'GoodsId'
          ToParam.MultiSelectSeparator = ','
        end>
      PostDataSetBeforeExecute = False
      StoredProc = spDeleteLink
      StoredProcList = <
        item
          StoredProc = spDeleteLink
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
    object actRefreshSearch2: TdsdExecStoredProc
      Category = 'DSDLib'
      ActiveControl = edProducerSearch
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
    object actRefreshSearch3: TdsdExecStoredProc
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
      ShortCut = 32781
    end
    object actClearFilter: TMultiAction
      Category = 'ClearFilter'
      MoveParams = <
        item
          FromParam.Value = ''
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = edGoodsSearch
          ToParam.DataType = ftString
          ToParam.ParamType = ptInput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = ''
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = edProducerSearch
          ToParam.DataType = ftString
          ToParam.ParamType = ptInput
          ToParam.MultiSelectSeparator = ','
        end
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
        Name = 'inAreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
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
        Name = 'inProducerSearch'
        Value = Null
        Component = edProducerSearch
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeSearch'
        Value = Null
        Component = edCodeSearch
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 104
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
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
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
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel7
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edArea
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 552
    Top = 200
  end
  inherited PopupMenu: TPopupMenu
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Action = macSetGoodsLink
    end
    object N4: TMenuItem
      Action = mactGoodsLinkDeleteList
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
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
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 200
  end
  object GuidesArea: TdsdGuides
    KeyField = 'Id'
    LookupControl = edArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 704
    Top = 128
  end
  object spGet_Area_byUser: TdsdStoredProc
    StoredProcName = 'gpGet_Area_byUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outAreaId'
        Value = '0'
        Component = GuidesArea
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAreaName'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 152
  end
end
