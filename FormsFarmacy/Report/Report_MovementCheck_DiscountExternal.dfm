inherited Report_MovementCheck_DiscountExternalForm: TReport_MovementCheck_DiscountExternalForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1087#1088#1086#1077#1082#1090#1099')'
  ClientHeight = 395
  ClientWidth = 1072
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1088
  ExplicitHeight = 434
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 1072
    Height = 318
    ExplicitTop = 77
    ExplicitWidth = 1072
    ExplicitHeight = 318
    ClientRectBottom = 318
    ClientRectRight = 1072
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1072
      ExplicitHeight = 318
      inherited cxGrid: TcxGrid
        Width = 1072
        Height = 318
        ExplicitWidth = 1072
        ExplicitHeight = 318
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Kind = skSum
              Position = spFooter
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = Name
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = SummChangePercent
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Summa
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'mactChoiceGoodsForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 224
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072', '#1074' '#1094#1077#1085#1072#1093' '#1088#1077#1072#1083#1080#1079'. '
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object ChangePercent: TcxGridDBColumn
            Caption = #1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object SummChangePercent: TcxGridDBColumn
            Caption = #1041#1091#1076#1091#1097#1072#1103' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object DiscountExternalName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1055#1088#1086#1077#1082#1090#1072
            DataBinding.FieldName = 'DiscountExternalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object DiscountCardName: TcxGridDBColumn
            Caption = #1044#1080#1089#1082#1086#1085#1090#1085#1072#1103' '#1082#1072#1088#1090#1072
            DataBinding.FieldName = 'DiscountCardName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object MainJuridicalName: TcxGridDBColumn
            Caption = #1053#1072#1096#1077' '#1102#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'MainJuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object FromName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 136
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1072
    Height = 51
    ExplicitWidth = 1072
    ExplicitHeight = 51
    inherited deStart: TcxDateEdit
      EditValue = 42491d
      TabOrder = 1
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42491d
      TabOrder = 0
    end
    object ceDiscountExternal: TcxButtonEdit
      Left = 520
      Top = 28
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 296
    end
    object cxLabel4: TcxLabel
      Left = 416
      Top = 29
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1055#1088#1086#1077#1082#1090#1072
    end
    object ceUnit: TcxButtonEdit
      Left = 101
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 6
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 288
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 232
  end
  inherited ActionList: TActionList
    Left = 87
    Top = 191
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpGetObjectGoods
      StoredProcList = <
        item
          StoredProc = gpGetObjectGoods
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 13
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
      ShortCut = 115
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_DiscountExternalDialogForm'
      FormNameParam.Value = 'TReport_DiscountExternalDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42491d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42491d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalId'
          Value = Null
          Component = GuidesDiscountExternal
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalName'
          Value = Null
          Component = GuidesDiscountExternal
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
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_MovementCheck_DiscountExternal'
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountExternalId'
        Value = Null
        Component = GuidesDiscountExternal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 88
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
        end
        item
          Visible = True
          ItemName = 'bbOpenDocument'
        end>
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenDocument
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 128
    Top = 216
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 128
    Top = 144
  end
  object gpGetObjectGoods: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsByCode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsCode'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 592
    Top = 120
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 120
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 176
  end
  object GuidesDiscountExternal: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceDiscountExternal
    FormNameParam.Value = 'TDiscountExternal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDiscountExternal_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDiscountExternal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDiscountExternal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 641
    Top = 27
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 24
  end
end
