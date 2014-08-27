inherited GoodsByGoodsKind1CLinkForm: TGoodsByGoodsKind1CLinkForm
  Caption = #1057#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1072#1084#1080' 1'#1057
  ClientHeight = 401
  ClientWidth = 1019
  ExplicitWidth = 1035
  ExplicitHeight = 436
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1019
    Height = 375
    ExplicitWidth = 835
    ExplicitHeight = 375
    ClientRectBottom = 375
    ClientRectRight = 1019
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 835
      ExplicitHeight = 375
      inherited cxGrid: TcxGrid
        Width = 1019
        Height = 375
        ExplicitWidth = 835
        ExplicitHeight = 375
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoodsForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoodsKindForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object colDetailCode: TcxGridDBColumn
            Caption = #1050#1086#1076' 1'#1057
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colDetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' 1'#1057
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colName_find1C: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' 1'#1057' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'Name_find1C'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colDetailBranch: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceBranchForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
        end
      end
      object edBranch: TcxButtonEdit
        Left = 192
        Top = 40
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 1
        Width = 250
      end
      object cxLabel1: TcxLabel
        Left = 224
        Top = 24
        Caption = #1060#1080#1083#1080#1072#1083
      end
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    object actInsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      View = cxGridDBTableView
      Params = <
        item
          Name = 'GoodsId'
          Component = MasterCDS
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'GoodsName'
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
        end
        item
          Name = 'GoodsCode'
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
        end
        item
          Name = 'GoodsKindId'
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'GoodsKindName'
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      ShortCut = 45
      ImageIndex = 0
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actChoiceBranchForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actChoiceBranchForm'
      FormName = 'TBranchLinkForm'
      FormNameParam.Value = 'TBranchLinkForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actChoiceGoodsForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actChoiceGoodsForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
        end
        item
          Name = 'Code'
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
        end>
      isShowModal = False
    end
    object actChoiceGoodsKindForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actChoiceGoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actInsertGoodsByGoodsKind1CLink: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGoodsByGoodsKind1CLink
      StoredProcList = <
        item
          StoredProc = spGoodsByGoodsKind1CLink
        end>
      Caption = 'actInsertGoodsByGoodsKind1CLink'
    end
    object actInsertGoodsByGoodsKind1CLinkAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertGoodsByGoodsKind1CLink
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1077' '#1090#1086#1074#1072#1088#1099' '#1080#1079' 1'#1057' ?'
      InfoAfterExecute = #1053#1086#1074#1099#1077' '#1090#1086#1074#1072#1088#1099' '#1080#1079' 1'#1057' '#1076#1086#1073#1072#1074#1083#1077#1085#1099'.'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1077' '#1090#1086#1074#1072#1088#1099' '#1080#1079' 1'#1057
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1077' '#1090#1086#1074#1072#1088#1099' '#1080#1079' 1'#1057
      ImageIndex = 41
    end
  end
  inherited MasterDS: TDataSource
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsByGoodsKind1CLink'
    Top = 48
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
          ItemName = 'bbInsertRecord'
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbJuridicalLabel'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem'
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
    object dxBarControlContainerItem: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edBranch
    end
    object bbInsertRecord: TdxBarButton
      Action = actInsertRecord
      Category = 0
    end
    object bbJuridicalLabel: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
    object dxBarButton1: TdxBarButton
      Action = actInsertGoodsByGoodsKind1CLinkAll
      Category = 0
    end
  end
  object BranchLinkGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranchLinkForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranchLinkForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 232
    Top = 120
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsByGoodsKind1CLink'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inCode'
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Component = MasterCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
      end
      item
        Name = 'inBranchTopId'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inIsSybase'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Component = MasterCDS
        ComponentItem = 'Id'
      end
      item
        Name = 'BranchId'
        Component = MasterCDS
        ComponentItem = 'BranchId'
      end
      item
        Name = 'BranchName'
        Component = MasterCDS
        ComponentItem = 'BranchName'
        DataType = ftString
      end>
    Left = 624
    Top = 216
  end
  object spGoodsByGoodsKind1CLink: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_GoodsByGoodsKind1CLink'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inBranchTopId'
        Value = ''
        Component = BranchLinkGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 296
    Top = 256
  end
end
