inherited GoodsPartnerCodeForm: TGoodsPartnerCodeForm
  Caption = #1050#1086#1076#1099' '#1087#1088#1086#1076#1072#1074#1094#1086#1074
  ClientHeight = 423
  ClientWidth = 763
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 771
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 763
    Height = 397
    ExplicitWidth = 763
    ExplicitHeight = 397
    ClientRectBottom = 397
    ClientRectRight = 763
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 763
      ExplicitHeight = 397
      inherited cxGrid: TcxGrid
        Width = 763
        Height = 397
        ExplicitWidth = 763
        ExplicitHeight = 397
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colGoodsMainCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsMainCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0; ; '
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colGoodsMainName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsMainName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 187
          end
          object clCodeInt: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1072#1088#1090#1085#1077#1088#1072
            DataBinding.FieldName = 'GoodsCodeInt'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1072#1088#1090#1085#1077#1088#1072' ('#1089#1090#1088#1086#1082')'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 107
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1072#1088#1090#1085#1077#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 205
          end
          object clMakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
        end
      end
      object edPartnerCode: TcxButtonEdit
        Left = 184
        Top = 63
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 1
        Width = 187
      end
      object cxLabel1: TcxLabel
        Left = 184
        Top = 40
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
      DataSource = nil
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
      isShowModal = True
      DataSource = nil
    end
    inherited dsdSetUnErased: TdsdUpdateErased
      Enabled = False
      DataSource = nil
    end
    inherited dsdSetErased: TdsdUpdateErased
      Category = 'Delete'
      ImageIndex = -1
      ShortCut = 0
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
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
        end>
    end
    object mactDelete: TMultiAction
      Category = 'Delete'
      MoveParams = <>
      ActionList = <
        item
          Action = actDeleteLink
        end
        item
          Action = DataSetPost
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1089#1074#1103#1079#1080'?'
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
    end
    object actDeleteLink: TdsdExecStoredProc
      Category = 'Delete'
      MoveParams = <>
      StoredProc = spDeleteLink
      StoredProcList = <
        item
          StoredProc = spDeleteLink
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
    object DataSetPost: TDataSetPost
      Category = 'DataSet'
      Caption = 'P&ost'
      Hint = 'Post'
      ImageIndex = 73
      DataSource = MasterDS
    end
    object mactSetLink: TMultiAction
      Category = 'Insert'
      MoveParams = <>
      ActionList = <
        item
          Action = DataSetEdit
        end
        item
          Action = OpenChoiceForm
        end
        item
          Action = actSetLink
        end
        item
          Action = DataSetPost
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100
      ImageIndex = 1
    end
    object DataSetEdit: TDataSetEdit
      Category = 'DataSet'
      Caption = '&Edit'
      Hint = 'Edit'
      ImageIndex = 74
    end
    object OpenChoiceForm: TOpenChoiceForm
      Category = 'Insert'
      MoveParams = <>
      Caption = 'OpenChoiceForm'
      FormName = 'TGoodsMainLiteForm'
      FormNameParam.Value = 'TGoodsMainLiteForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsMainId'
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsMainCode'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsMainName'
        end>
      isShowModal = True
    end
    object actSetLink: TdsdExecStoredProc
      Category = 'Insert'
      MoveParams = <>
      StoredProc = spInserUpdateGoodsLink
      StoredProcList = <
        item
          StoredProc = spInserUpdateGoodsLink
        end>
      Caption = 'actSetLink'
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_Juridical'
    Params = <
      item
        Name = 'inObjectId'
        Value = ''
        Component = PartnerCodeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 144
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSetLink'
        end
        item
          Visible = True
          ItemName = 'bbErased'
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
          ItemName = 'bbGridToExcel'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
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
    inherited bbInsert: TdxBarButton
      Visible = ivNever
    end
    inherited bbErased: TdxBarButton
      Action = mactDelete
    end
    inherited bbUnErased: TdxBarButton
      Visible = ivNever
    end
    object bbSetLink: TdxBarButton
      Action = mactSetLink
      Category = 0
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
      Control = edPartnerCode
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SearchAsFilter = False
    Left = 256
    Top = 216
  end
  inherited spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoods'
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        ParamType = ptInput
      end>
  end
  object PartnerCodeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartnerCode
    FormNameParam.Value = 'TPartnerCodeForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartnerCodeForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerCodeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerCodeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 288
    Top = 108
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PartnerCodeGuides
      end>
    Left = 216
    Top = 112
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
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'GoodsMainCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainCode'
      end
      item
        Name = 'GoodsMainName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainName'
        DataType = ftString
      end>
    PackSize = 1
    Left = 344
    Top = 160
  end
  object spInserUpdateGoodsLink: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_LinkGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
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
    Left = 344
    Top = 248
  end
end
