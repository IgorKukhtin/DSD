inherited PriceListItemsLoadForm: TPriceListItemsLoadForm
  Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
  ClientHeight = 410
  ClientWidth = 908
  AddOnFormData.Params = FormParams
  ExplicitLeft = -126
  ExplicitWidth = 916
  ExplicitHeight = 437
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 908
    Height = 335
    ExplicitTop = 75
    ExplicitWidth = 908
    ExplicitHeight = 335
    ClientRectBottom = 335
    ClientRectRight = 908
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 908
      ExplicitHeight = 335
      inherited cxGrid: TcxGrid
        Width = 908
        Height = 335
        ExplicitWidth = 908
        ExplicitHeight = 335
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCommonCode: TcxGridDBColumn
            Caption = #1054#1073#1097#1080#1081' '#1082#1086#1076
            DataBinding.FieldName = 'CommonCode'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object colBarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 136
          end
          object colProducerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'ProducerName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 124
          end
          object colGoodsNDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'GoodsNDS'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoods
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 144
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
        end
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 908
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object cxLabel2: TcxLabel
      Left = 1
      Top = 4
      Caption = #1044#1072#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 1
      Top = 22
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 100
    end
    object cxLabel3: TcxLabel
      Left = 107
      Top = 4
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
    end
    object edFrom: TcxButtonEdit
      Left = 107
      Top = 22
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 270
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGet
        end>
    end
    object actChoiceGoods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actChoiceGoods'
      FormName = 'TGoodsMainForm'
      FormNameParam.Value = 'TGoodsMainForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          ParamType = ptInput
        end>
      isShowModal = False
    end
    object actUpdate: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdatePriceListItem
      StoredProcList = <
        item
          StoredProc = spUpdatePriceListItem
        end>
      Caption = 'actUpdate'
      DataSource = MasterDS
    end
    object mactGoodsLinkDelete: TMultiAction
      Category = 'GoodsLinkDelete'
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
          Action = DataSetPost
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      ImageIndex = 2
    end
    object DataSetPost: TDataSetPost
      Category = 'GoodsLinkDelete'
      Caption = 'P&ost'
      Hint = 'Post'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_LoadPriceListItem'
    Params = <
      item
        Name = 'inLoadPriceListId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Top = 104
  end
  inherited BarManager: TdxBarManager
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
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
      end>
    Left = 160
    Top = 104
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_LoadPriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 232
    Top = 104
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 352
    Top = 32
  end
  object spUpdatePriceListItem: TdsdStoredProc
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
    Left = 224
    Top = 248
  end
end
