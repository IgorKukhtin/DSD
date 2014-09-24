inherited PriceListLoadForm: TPriceListLoadForm
  Caption = #1060#1086#1088#1084#1072' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
  ClientHeight = 399
  ClientWidth = 616
  ExplicitWidth = 624
  ExplicitHeight = 426
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 616
    Height = 373
    ExplicitWidth = 597
    ExplicitHeight = 373
    ClientRectBottom = 373
    ClientRectRight = 616
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 597
      ExplicitHeight = 373
      inherited cxGrid: TcxGrid
        Width = 616
        Height = 373
        ExplicitWidth = 597
        ExplicitHeight = 373
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 116
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 199
          end
          object colContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentVert = vaCenter
            Width = 199
          end
          object colNDSinPrice: TcxGridDBColumn
            Caption = #1053#1044#1057' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'NDSinPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object actOpenPriceList: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100
      ShortCut = 13
      ImageIndex = 1
      FormName = 'TPriceListItemsLoadForm'
      FormNameParam.Value = 'TPriceListItemsLoadForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'Id'
        end>
      isShowModal = False
      ActionType = acUpdate
      IdFieldName = 'Id'
    end
    object actLoadPriceList: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdateGoods
      StoredProcList = <
        item
          StoredProc = spUpdateGoods
        end
        item
          StoredProc = spLoadPriceList
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' '#1087#1088#1072#1081#1089#1099
    end
  end
  inherited MasterDS: TDataSource
    Top = 56
  end
  inherited MasterCDS: TClientDataSet
    Top = 56
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_LoadPriceList'
    Top = 56
  end
  inherited BarManager: TdxBarManager
    Top = 56
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbOpen'
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
          ItemName = 'bbLoadPriceList'
        end>
    end
    object bbOpen: TdxBarButton
      Action = actOpenPriceList
      Category = 0
    end
    object bbLoadPriceList: TdxBarButton
      Action = actLoadPriceList
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenPriceList
      end>
  end
  object spLoadPriceList: TdsdStoredProc
    StoredProcName = 'gpLoadPriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 216
    Top = 152
  end
  object spUpdateGoods: TdsdStoredProc
    StoredProcName = 'gpUpdatePartnerGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 216
    Top = 120
  end
end
