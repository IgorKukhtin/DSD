inherited GlobalConstForm: TGlobalConstForm
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1080#1089#1090#1077#1084#1099
  ClientHeight = 323
  ClientWidth = 550
  ExplicitWidth = 566
  ExplicitHeight = 361
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 550
    Height = 297
    ExplicitWidth = 373
    ClientRectBottom = 297
    ClientRectRight = 550
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 373
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 550
        Height = 297
        ExplicitWidth = 373
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 161
          end
          object EnumName: TcxGridDBColumn
            Caption = 'Enum'
            DataBinding.FieldName = 'EnumName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ActualBankStatementDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'ActualBankStatementDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object SiteDiscount: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080' '#1076#1083#1103' '#1089#1072#1081#1090#1072
            DataBinding.FieldName = 'SiteDiscount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object isSiteDiscount: TcxGridDBColumn
            Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1072' '#1089#1082#1080#1076#1082#1072' '#1076#1083#1103' '#1089#1072#1081#1090#1072
            DataBinding.FieldName = 'isSiteDiscount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1072' '#1089#1082#1080#1076#1082#1072' '#1076#1083#1103' '#1089#1072#1081#1090#1072
            Width = 119
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateGlobalConst
      StoredProcList = <
        item
          StoredProc = spUpdateGlobalConst
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object ProtocolOpenForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ValueText'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    Top = 64
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GlobalConst_user'
    Top = 64
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbProtocolOpenForm'
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
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
  end
  object spUpdateGlobalConst: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GlobalConst'
    DataSets = <>
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
        Name = 'inSiteDiscount'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'SiteDiscount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSiteDiscount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSiteDiscount'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 112
  end
end
