inherited LoadSaleFrom1CForm: TLoadSaleFrom1CForm
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1088#1086#1076#1072#1078' '#1080#1079' 1'#1057
  ClientHeight = 408
  ClientWidth = 901
  ExplicitWidth = 909
  ExplicitHeight = 435
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 901
    Height = 351
    TabOrder = 3
    ExplicitWidth = 901
    ExplicitHeight = 351
    ClientRectBottom = 351
    ClientRectRight = 901
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 901
      ExplicitHeight = 351
      inherited cxGrid: TcxGrid
        Width = 901
        Height = 351
        ExplicitWidth = 901
        ExplicitHeight = 351
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object colBranch: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colDocType: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1086#1082
            DataBinding.FieldName = 'DocType'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object colClientCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'ClientCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colClientName: TcxGridDBColumn
            Caption = #1048#1084#1103' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'ClientName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object colDeliveryPoint: TcxGridDBColumn
            Caption = #1058#1086#1095#1082#1080' '#1076#1086#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'DeliveryPointName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object colGoodsGoodsKind: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1099#1081
            DataBinding.FieldName = 'GoodsGoodsKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 139
          end
          object colOperCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'OperCount'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object colOperPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'OperPrice'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
          end
          object colClientINN: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'ClientINN'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 38
          end
          object colClientOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'ClientOKPO'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object colSuma: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Suma'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 901
    ExplicitWidth = 901
    inherited deStart: TcxDateEdit
      EditValue = 41640d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 41640d
    end
  end
  inherited ActionList: TActionList
    object actMoveToDoc: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spMoveSale
      StoredProcList = <
        item
          StoredProc = spMoveSale
        end>
      Caption = #1055#1077#1088#1077#1085#1086#1089#1080#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1074' '#1087#1088#1086#1076#1072#1078#1080
      Hint = #1055#1077#1088#1077#1085#1086#1089#1080#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1074' '#1087#1088#1086#1076#1072#1078#1080
      ImageIndex = 30
      QuestionBeforeExecute = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080'? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
    end
    object actTrancateTable: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = 'actTrancateTable'
    end
    object actSale1CLoadAction: TSale1CLoadAction
      Category = 'DSDLib'
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
    end
    object actLoad1C: TMultiAction
      Category = 'DSDLib'
      ActionList = <
        item
          Action = actTrancateTable
        end
        item
          Action = actSale1CLoadAction
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1088#1072#1089#1093#1086#1076#1086#1074' '#1080#1079' 1'#1057
      ImageIndex = 50
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 64
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_1CSaleLoad'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 104
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 136
    Top = 64
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
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
          ItemName = 'bbLoad1c'
        end
        item
          Visible = True
          ItemName = 'bbMoveSale'
        end>
    end
    object bbMoveSale: TdxBarButton
      Action = actMoveToDoc
      Category = 0
    end
    object bbLoad1c: TdxBarButton
      Action = actLoad1C
      Category = 0
    end
  end
  object spMoveSale: TdsdStoredProc
    StoredProcName = 'gpLoadSaleFrom1C'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 176
    Top = 136
  end
  object spDelete1CLoad: TdsdStoredProc
    StoredProcName = 'gpDelete_1CSale'
    DataSets = <>
    OutputType = otResult
    Params = <>
    Left = 176
    Top = 192
  end
end
