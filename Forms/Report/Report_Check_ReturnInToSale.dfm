inherited Report_Check_ReturnInToSaleForm: TReport_Check_ReturnInToSaleForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
  ClientHeight = 483
  ClientWidth = 1077
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1093
  ExplicitHeight = 521
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1077
    Height = 392
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1077
    ExplicitHeight = 392
    ClientRectBottom = 392
    ClientRectRight = 1077
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1077
      ExplicitHeight = 392
      inherited cxGrid: TcxGrid
        Width = 1077
        Height = 392
        ExplicitWidth = 1077
        ExplicitHeight = 392
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object isDiff: TcxGridDBColumn
            Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
            DataBinding.FieldName = 'isDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object StatusCode: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1056#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077') ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 221
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object clPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object StatusCode_Sale: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'StatusCode_Sale'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object OperDate_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'OperDate_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object InvNumber_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'InvNumber_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object PartnerName_Sale: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'PartnerName_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsCode_Sale: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'GoodsCode_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object GoodsName_Sale: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'GoodsName_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 205
          end
          object GoodsKindName_Sale: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'GoodsKindName_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object clPrice_Sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'Price_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1077
    Height = 65
    ExplicitWidth = 1077
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 42522d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 34
      EditValue = 42522d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 34
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      ExplicitLeft = 25
    end
    inherited cxLabel2: TcxLabel
      Left = 6
      Top = 35
      ExplicitLeft = 6
      ExplicitTop = 35
    end
    object cxLabel7: TcxLabel
      Left = 222
      Top = 6
      Caption = #1070#1088'. '#1083#1080#1094#1086':'
    end
    object edJuridical: TcxButtonEdit
      Left = 278
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 255
    end
    object cxLabel3: TcxLabel
      Left = 209
      Top = 35
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090':'
    end
    object edPartner: TcxButtonEdit
      Left = 278
      Top = 34
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 255
    end
    object edShowAll: TcxCheckBox
      Left = 554
      Top = 5
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 8
      Width = 223
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 320
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 48
  end
  inherited ActionList: TActionList
    Left = 623
    Top = 279
    inherited actRefresh: TdsdDataSetRefresh
      TabSheet = tsMain
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Check_ReturnInToSaleDialogForm'
      FormNameParam.Value = 'TReport_Check_ReturnInToSaleDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inShowAll'
          Value = 'False'
          Component = edShowAll
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 112
    Top = 200
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_ReturnInToSale'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
      end
      item
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = 'False'
        Component = edShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inMovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 408
    Top = 272
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
    object bbPrint: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'-'#1074#1089#1077')'
      Visible = ivAlways
      ImageIndex = 18
      ShortCut = 16464
    end
    object bbPrint_byPack: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080')'
      Visible = ivAlways
      ImageIndex = 19
      ShortCut = 16464
    end
    object bbPrint_byProduction: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1085#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1085#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      Visible = ivAlways
      ImageIndex = 20
      ShortCut = 16464
    end
    object bbPrint_byType: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1074#1080#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      Visible = ivAlways
      ImageIndex = 21
      ShortCut = 16464
    end
    object bbPrint_byRoute: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1076#1077#1090#1072#1083#1100#1085#1086')'
      Visible = ivAlways
      ImageIndex = 22
      ShortCut = 16464
    end
    object bbPrint_byRouteItog: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1087#1086' '#1052#1072#1088#1096#1088#1091#1090#1072#1084'-'#1080#1090#1086#1075#1086')'
      Visible = ivAlways
      ImageIndex = 16
      ShortCut = 16464
    end
    object bbPrint_byCross: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1082#1088#1086#1089#1089')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1082#1088#1086#1089#1089')'
      Visible = ivAlways
      ImageIndex = 18
      ShortCut = 16464
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint_Dozakaz: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1044#1086#1079#1072#1082#1072#1079')'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' - '#1079#1072#1103#1074#1082#1080' ('#1044#1086#1079#1072#1082#1072#1079')'
      Visible = ivAlways
      ImageIndex = 17
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 696
    Top = 136
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 56
    Top = 32
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
      end
      item
        Component = GuidesPartner
      end
      item
        Component = GuidesJuridical
      end
      item
      end
      item
      end
      item
        Component = edShowAll
      end>
    Left = 592
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inStartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 154
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    Key = '0'
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 432
    Top = 8
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 32
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 256
    Top = 208
  end
end
