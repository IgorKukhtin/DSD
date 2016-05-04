inherited Report_GoodsOnUnit_ForSiteForm: TReport_GoodsOnUnit_ForSiteForm
  Caption = #1058#1086#1074#1072#1088#1099' '#1076#1083#1103' '#1089#1072#1081#1090#1072
  ClientHeight = 366
  ClientWidth = 965
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 981
  ExplicitHeight = 401
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 56
    Width = 965
    Height = 310
    TabOrder = 3
    ExplicitTop = 56
    ExplicitWidth = 965
    ExplicitHeight = 310
    ClientRectBottom = 310
    ClientRectRight = 965
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 965
      ExplicitHeight = 310
      inherited cxGrid: TcxGrid
        Width = 965
        Height = 310
        ExplicitWidth = 965
        ExplicitHeight = 310
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = RemainsAll
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountDeferred
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = RemainsAll
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountDeferred
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Id: TcxGridDBColumn
            Caption = #1050#1083#1102#1095' '#1090#1086#1074#1072#1088#1072' ('#1089#1077#1090#1080')'
            DataBinding.FieldName = 'Id'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Id_Site: TcxGridDBColumn
            Caption = #1050#1083#1102#1095' '#1090#1086#1074#1072#1088#1072' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'Id_Site'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Article: TcxGridDBColumn
            Caption = #1040#1088#1090#1080#1082#1091#1083
            DataBinding.FieldName = 'Article'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Name_Site: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'Name_Site'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1084#1080#1085'. '#1094#1077#1085')'
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1089' '#1091#1095'. '#1088#1077#1079#1077#1088#1074')'
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountDeferred: TcxGridDBColumn
            Caption = #1056#1077#1079#1077#1088#1074
            DataBinding.FieldName = 'AmountDeferred'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object RemainsAll: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1073#1077#1079' '#1091#1095'. '#1088#1077#1079#1077#1088#1074')'
            DataBinding.FieldName = 'RemainsAll'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object NDSKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object NDS: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price_unit: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1072#1087#1090#1077#1082#1080
            DataBinding.FieldName = 'Price_unit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object Price_minNoNds: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1084#1080#1085'. '#1073#1077#1079' '#1053#1044#1057' ('#1073#1077#1079' '#1085#1072#1094'., '#1080#1085#1092#1086#1088#1084'.)'
            DataBinding.FieldName = 'Price_minNoNds'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Price_minO: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1084#1080#1085'. '#1089' '#1053#1044#1057' ('#1073#1077#1079' '#1085#1072#1094'., '#1080#1085#1092#1086#1088#1084'.)'
            DataBinding.FieldName = 'Price_minO'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1094#1077#1085#1072' '#1084#1080#1085#1080#1084' ('#1073#1077#1079' '#1085#1072#1094#1077#1085#1086#1082', '#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1072#1103')'
            Width = 93
          end
          object Price_min: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1084#1080#1085'. '#1089' '#1053#1044#1057' '#1089' '#1085#1072#1094'. ('#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
            DataBinding.FieldName = 'Price_min'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Price_minD: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1084#1080#1085'. '#1089' '#1053#1044#1057' '#1089' '#1085#1072#1094'. ('#1076#1086#1089#1090#1072#1074#1082#1072')'
            DataBinding.FieldName = 'Price_minD'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 86
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 91
          end
          object MarginPercent: TcxGridDBColumn
            Caption = '% '#1085#1072#1094'. ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'MarginPercent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MarginPercent_site: TcxGridDBColumn
            Caption = '% '#1085#1072#1094'. ('#1076#1086#1089#1090#1072#1074#1082#1072')'
            DataBinding.FieldName = 'MarginPercent_site'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MarginCategoryName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'MarginCategoryName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object MarginCategoryName_site: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080' ('#1076#1086#1089#1090#1072#1074#1082#1072')'
            DataBinding.FieldName = 'MarginCategoryName_site'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object Name_category: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'Name_category'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object Manufacturer: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'Manufacturer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object description: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'description'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 146
          end
          object ObjectName: TcxGridDBColumn
            Caption = #1058#1086#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object foto: TcxGridDBColumn
            Caption = #1060#1086#1090#1086
            DataBinding.FieldName = 'foto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object thumb: TcxGridDBColumn
            Caption = #1052#1077#1083#1082#1080#1077' '#1092#1086#1090#1086
            DataBinding.FieldName = 'thumb'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object published: TcxGridDBColumn
            Caption = #1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'published'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object deleted: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'deleted'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 965
    Height = 30
    ExplicitWidth = 965
    ExplicitHeight = 30
    inherited deStart: TcxDateEdit
      Left = 27
      Top = 6
      Visible = False
      ExplicitLeft = 27
      ExplicitTop = 6
      ExplicitWidth = 6
      Width = 6
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 32
      Visible = False
      ExplicitLeft = 118
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 20
      Top = 9
      Caption = ''
      Visible = False
      ExplicitLeft = 20
      ExplicitTop = 9
      ExplicitWidth = 7
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 33
      Visible = False
      ExplicitLeft = 8
      ExplicitTop = 33
    end
    object cxLabel4: TcxLabel
      Left = 88
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 177
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 299
    end
    object cxLabel3: TcxLabel
      Left = 502
      Top = 6
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 540
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 325
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsOnUnit_ForSiteDialogForm'
      FormNameParam.Value = 'TReport_GoodsOnUnit_ForSiteDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = GoodsGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 208
    Top = 168
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsOnUnit_ForSite'
    Params = <
      item
        Name = 'inUnitId_list'
        Value = 41395d
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId_list'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 48
    Top = 152
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 144
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
          ItemName = 'bbExecuteDialog'
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
    object bbGoodsPartyReport: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Visible = ivAlways
      ImageIndex = 39
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 424
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 592
    Top = 192
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
        Component = GoodsGuides
      end>
    Left = 136
    Top = 208
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 376
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
  end
end
