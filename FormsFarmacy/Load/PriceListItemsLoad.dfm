inherited PriceListItemsLoadForm: TPriceListItemsLoadForm
  Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
  ClientHeight = 410
  ClientWidth = 908
  AddOnFormData.Params = FormParams
  ExplicitWidth = 924
  ExplicitHeight = 449
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
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.CellAutoHeight = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object CommonCode: TcxGridDBColumn
            Caption = #1082#1086#1076' '#1052#1086#1088#1080#1086#1085
            DataBinding.FieldName = 'CommonCode'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object BarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 136
          end
          object ProducerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'ProducerName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 124
          end
          object GoodsNDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'GoodsNDS'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object CodeUKTZED: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1050#1058' '#1047#1045#1044
            DataBinding.FieldName = 'CodeUKTZED'
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1091' '#1079#1075#1110#1076#1085#1086' '#1079' '#1059#1050#1058' '#1047#1045#1044' '
            Options.Editing = False
            Width = 70
          end
          object Code: TcxGridDBColumn
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
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 144
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 50
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsPromo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103
            DataBinding.FieldName = 'IsPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object isResolution_224: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224'
            DataBinding.FieldName = 'isResolution_224'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object IsClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'IsClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
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
      EditValue = 42608d
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
    object cxLabel5: TcxLabel
      Left = 388
      Top = 4
      Caption = #1056#1077#1075#1080#1086#1085
    end
    object edArea: TcxButtonEdit
      Left = 388
      Top = 22
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 164
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
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoods'
      FormName = 'TGoodsMainForm'
      FormNameParam.Value = 'TGoodsMainForm'
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
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
    object actGetMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetMovement
      StoredProcList = <
        item
          StoredProc = spGetMovement
        end>
      Caption = #1086#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 8
    end
    object actOpenMovementPriceList: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      ShortCut = 115
      ImageIndex = 8
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object MacGetMovement: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetMovement
        end
        item
          Action = actOpenMovementPriceList
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'>'
      ImageIndex = 28
    end
    object actUpdate_Goods_Promo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_Goods_Promo
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1040#1082#1094#1080#1103' '#1085#1072' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1040#1082#1094#1080#1103
      Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1040#1082#1094#1080#1103
      ImageIndex = 79
    end
    object actExecUpdate_Goods_Promo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_Promo
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_Promo
        end>
      Caption = 'actExecUpdate_Goods_Promo'
    end
    object actisResolution_224_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mainResolution_224_Yes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"? '
      InfoAfterExecute = #1059#1089#1090#1072#1085#1086#1074#1083#1077#1085' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      ImageIndex = 79
    end
    object mainResolution_224_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_inResolution_224_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1047#1072#1082#1088#1099#1090'"'
      Hint = 'maSetClose'
    end
    object actUpdate_inResolution_224_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inResolution_224_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_inResolution_224_Yes
        end>
      Caption = 'actUpdate_inResolution_224_Yes'
    end
    object actinResolution_224_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mainResolution_224_No
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"? '
      InfoAfterExecute = #1057#1085#1103#1090' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      ImageIndex = 58
    end
    object mainResolution_224_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_inResolution_224_No
        end>
      View = cxGridDBTableView
      Caption = #1057#1085#1103#1090#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1047#1072#1082#1088#1099#1090'"'
      Hint = 'maClearClose'
    end
    object actUpdate_inResolution_224_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inResolution_224_No
      StoredProcList = <
        item
          StoredProc = spUpdate_inResolution_224_No
        end>
      Caption = 'actUpdate_inResolution_224_No'
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
        MultiSelectSeparator = ','
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGetMovement'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbUpdate_Goods_Promo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbisResolution_224_Yes'
        end
        item
          Visible = True
          ItemName = 'bbtinResolution_224_No'
        end>
    end
    object bbDeleteGoodsLink: TdxBarButton
      Action = mactGoodsLinkDelete
      Category = 0
    end
    object bbGetMovement: TdxBarButton
      Action = MacGetMovement
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Action = actUpdate_Goods_Promo
      Category = 0
      ItemLinks = <>
    end
    object bbUpdate_Goods_Promo: TdxBarButton
      Action = actUpdate_Goods_Promo
      Category = 0
    end
    object bbisResolution_224_Yes: TdxBarButton
      Action = actisResolution_224_Yes
      Category = 0
    end
    object bbtinResolution_224_No: TdxBarButton
      Action = actinResolution_224_No
      Category = 0
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ContractId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaName'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 128
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 304
    Top = 8
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
    Left = 224
    Top = 248
  end
  object spGetMovement: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_by_LoadPriceList'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'outId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 152
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
    Left = 464
    Top = 24
  end
  object spUpdate_Goods_Promo: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Promo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerGoodsID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPromo'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 272
  end
  object spUpdate_inResolution_224_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inResolution_224'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioisResolution_224'
        Value = False
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 208
  end
  object spUpdate_inResolution_224_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inResolution_224'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioisResolution_224'
        Value = True
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 160
  end
end
