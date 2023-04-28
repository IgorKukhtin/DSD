inherited MainInventoryForm: TMainInventoryForm
  Action = actExit
  Caption = #1042#1099#1093#1086#1076
  ClientHeight = 397
  ClientWidth = 841
  Menu = MainMenu
  OnClick = actExitExecute
  OnClose = nil
  OnCreate = FormCreate
  OnDestroy = ParentFormDestroy
  ExplicitWidth = 857
  ExplicitHeight = 456
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel [0]
    Left = 0
    Top = 0
    Width = 841
    Height = 397
    Align = alClient
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 0
    object PageControl: TcxPageControl
      Left = 1
      Top = 1
      Width = 839
      Height = 395
      Align = alClient
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 0
      Properties.ActivePage = tsInventory
      Properties.CustomButtons.Buttons = <>
      ClientRectBottom = 391
      ClientRectLeft = 4
      ClientRectRight = 835
      ClientRectTop = 24
      object tsStart: TcxTabSheet
        Caption = #1057#1090#1072#1088#1090#1086#1074#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072
        ImageIndex = 0
      end
      object tsInventory: TcxTabSheet
        Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
        ImageIndex = 1
        object cxGridChild: TcxGrid
          Left = 0
          Top = 65
          Width = 831
          Height = 302
          Align = alClient
          TabOrder = 0
          object cxGridChildDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = MasterDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = #1057#1090#1088#1086#1082': ,0'
                Kind = skCount
                Column = ChildGoodsName
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = ChildAmount
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.Content = dmMain.cxContentStyle
            Styles.Footer = dmMain.cxFooterStyle
            Styles.Header = dmMain.cxHeaderStyle
            Styles.Inactive = dmMain.cxSelection
            object ChildIsSend: TcxGridDBColumn
              Caption = #1054#1090#1087#1088'.'
              DataBinding.FieldName = 'IsSend'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 46
            end
            object ChildisLast: TcxGridDBColumn
              Caption = #1055#1086#1089#1083#1077#1076#1085#1080#1081
              DataBinding.FieldName = 'isLast'
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.DisplayChecked = '1'
              Properties.DisplayUnchecked = '0'
              Properties.ValueChecked = '1'
              Properties.ValueUnchecked = '0'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 64
            end
            object ChildNum: TcxGridDBColumn
              Caption = #8470' '#1087'.'#1087'.'
              DataBinding.FieldName = 'Num'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 44
            end
            object ChildGoodsCode: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'GoodsCode'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 63
            end
            object ChildGoodsName: TcxGridDBColumn
              Caption = #1058#1086#1074#1072#1088
              DataBinding.FieldName = 'GoodsName'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 158
            end
            object ChildAmount: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086
              DataBinding.FieldName = 'Amount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 134
            end
            object ChildUserName: TcxGridDBColumn
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
              DataBinding.FieldName = 'UserName'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 205
            end
            object ChildDate_Insert: TcxGridDBColumn
              Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103
              DataBinding.FieldName = 'Date_Insert'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 104
            end
          end
          object cxGridChildLevel: TcxGridLevel
            GridView = cxGridChildDBTableView
          end
        end
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 831
          Height = 65
          Align = alTop
          ShowCaption = False
          TabOrder = 1
          object edBarCode: TcxTextEdit
            Left = 14
            Top = 38
            TabOrder = 1
            OnDblClick = edBarCodeDblClick
            OnKeyDown = edBarCodeKeyDown
            Width = 161
          end
          object ceAmount: TcxCurrencyEdit
            Left = 220
            Top = 38
            EditValue = 1.000000000000000000
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            TabOrder = 0
            OnKeyDown = edBarCodeKeyDown
            Width = 90
          end
          object cxLabel4: TcxLabel
            Left = 16
            Top = 25
            Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
          end
          object cxLabel5: TcxLabel
            Left = 220
            Top = 25
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          end
          object ceAmountAdd: TcxCurrencyEdit
            Left = 727
            Top = 40
            TabStop = False
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            Properties.ReadOnly = True
            TabOrder = 4
            Width = 90
          end
          object cxLabel6: TcxLabel
            Left = 735
            Top = 26
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
          end
          object edGoodsCode: TcxTextEdit
            Left = 335
            Top = 38
            TabStop = False
            Properties.ReadOnly = True
            TabOrder = 6
            Width = 66
          end
          object cxLabel7: TcxLabel
            Left = 335
            Top = 25
            Caption = #1055#1086#1089#1083#1077#1076#1085#1080#1081' '#1076#1086#1073#1072#1074#1083#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088
          end
          object edGoodsName: TcxTextEdit
            Left = 407
            Top = 38
            TabStop = False
            Properties.ReadOnly = True
            TabOrder = 8
            Width = 314
          end
          object cxLabel1: TcxLabel
            Left = 16
            Top = 6
            Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1086#1090
          end
          object edOperDate: TcxDateEdit
            Left = 125
            Top = 5
            TabStop = False
            EditValue = 45033d
            Properties.ReadOnly = True
            TabOrder = 10
            Width = 121
          end
          object edUnitName: TcxTextEdit
            Left = 252
            Top = 5
            TabStop = False
            Properties.ReadOnly = True
            TabOrder = 11
            Width = 565
          end
          object cxButton1: TcxButton
            Left = 181
            Top = 35
            Width = 33
            Height = 25
            Action = actGoodsInventory
            PaintStyle = bpsGlyph
            ParentShowHint = False
            ShowHint = True
            TabOrder = 12
            TabStop = False
          end
        end
      end
      object tsInfo: TcxTabSheet
        Caption = #1048#1090#1086#1075#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
        ImageIndex = 2
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 831
          Height = 41
          Align = alTop
          ShowCaption = False
          TabOrder = 0
          object cxLabel10: TcxLabel
            Left = 16
            Top = 6
            Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1086#1090
          end
          object edOperDateInfo: TcxDateEdit
            Left = 125
            Top = 5
            TabStop = False
            EditValue = 45033d
            Properties.ReadOnly = True
            TabOrder = 1
            Width = 121
          end
          object edUnitNameInfo: TcxTextEdit
            Left = 252
            Top = 5
            TabStop = False
            Properties.ReadOnly = True
            TabOrder = 2
            Width = 565
          end
        end
        object cxGrid1: TcxGrid
          Left = 0
          Top = 41
          Width = 831
          Height = 326
          Align = alClient
          TabOrder = 1
          object cxGridDBTableView1: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = InfoDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = #1057#1090#1088#1086#1082': ,0'
                Kind = skCount
                Column = InfoGoodsName
              end
              item
                Format = ',0.####;-,0.####; ;'
                Kind = skSum
                Column = InfoRemains
              end
              item
                Format = ',0.####;-,0.####; ;'
                Kind = skSum
                Column = InfoAmount
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.Content = dmMain.cxContentStyle
            Styles.Footer = dmMain.cxFooterStyle
            Styles.Header = dmMain.cxHeaderStyle
            Styles.Inactive = dmMain.cxSelection
            object InfoGoodsCode: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'GoodsCode'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 92
            end
            object InfoGoodsName: TcxGridDBColumn
              Caption = #1058#1086#1074#1072#1088
              DataBinding.FieldName = 'GoodsName'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 444
            end
            object InfoRemains: TcxGridDBColumn
              Caption = #1054#1089#1090#1072#1090#1086#1082
              DataBinding.FieldName = 'Remains'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 140
            end
            object InfoAmount: TcxGridDBColumn
              Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
              DataBinding.FieldName = 'Amount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              Options.Editing = False
              Width = 140
            end
          end
          object cxGridLevel1: TcxGridLevel
            GridView = cxGridDBTableView1
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 19
    Top = 136
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Top = 192
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 15
    Top = 63
    object actDoLoadData: TAction
      Category = 'DSDLib'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      OnExecute = actDoLoadDataExecute
    end
    object actUnitChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actUnitChoice'
      FormName = 'TUnitLocalForm'
      FormNameParam.Value = 'TUnitLocalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actLoadData: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actDoLoadData
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
    end
    object actReCreteInventDate: TAction
      Category = 'DSDLib'
      Caption = 'actReCreteInventDate'
      OnExecute = actReCreteInventDateExecute
    end
    object actDataDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDataDialog'
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDate'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actDoCreateInventory: TAction
      Category = 'DSDLib'
      Caption = 'actDoCreateInventory'
      OnExecute = actDoCreateInventoryExecute
    end
    object mactCreteNewInvent: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actReCreteInventDate
        end
        item
          Action = actDataDialog
        end
        item
          Action = actUnitChoice
        end
        item
          Action = actDoCreateInventory
        end>
      Caption = #1053#1072#1095#1072#1090#1100' '#1085#1086#1074#1091#1102' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1102
    end
    object actContinueInvent: TAction
      Category = 'DSDLib'
      Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      OnExecute = actContinueInventExecute
    end
    object actExit: TAction
      Category = 'DSDLib'
      Caption = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actInfoInvent: TAction
      Category = 'DSDLib'
      Caption = #1048#1090#1086#1075#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      OnExecute = actInfoInventExecute
    end
    object actGoodsInventory: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actSetFocusededBarCode
      AfterAction = actSetFocusededBarCode
      PostDataSetBeforeExecute = False
      Caption = #1053#1072#1081#1090#1080' '#1090#1086#1074#1072#1088' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102
      Hint = #1053#1072#1081#1090#1080' '#1090#1086#1074#1072#1088' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102
      ImageIndex = 27
      FormName = 'TGoodsInventoryForm'
      FormNameParam.Value = 'TGoodsInventoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BarCode'
          Value = Null
          Component = edBarCode
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actSetFocusededBarCode: TdsdSetFocusedAction
      Category = 'DSDLib'
      MoveParams = <>
      ControlName.Value = 'edBarCode'
      ControlName.DataType = ftString
      ControlName.MultiSelectSeparator = ','
    end
    object actSendInventChild: TAction
      Category = 'DSDLib'
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      OnExecute = actSendInventChildExecute
    end
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 336
    Top = 169
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 336
    Top = 241
  end
  object MainMenu: TMainMenu
    Images = dmMain.ImageList
    Left = 144
    Top = 72
    object N3: TMenuItem
      Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      object N4: TMenuItem
        Action = mactCreteNewInvent
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object N5: TMenuItem
        Action = actContinueInvent
      end
      object N11: TMenuItem
        Action = actInfoInvent
      end
    end
    object N1: TMenuItem
      Caption = #1054#1073#1084#1077#1085' '#1076#1072#1085#1085#1099#1084#1080
      object N2: TMenuItem
        Action = actLoadData
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object N8: TMenuItem
        Action = actSendInventChild
      end
    end
    object N10: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = actExitExecute
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = edUnitName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 16
    Top = 248
  end
  object spGet_User_IsAdmin: TdsdStoredProc
    StoredProcName = 'gpGet_User_IsAdmin'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'gpGet_User_IsAdmin'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 142
  end
  object spSelectChilg: TdsdStoredProcSQLite
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    SQLList = <
      item
        SQL.Strings = (
          'SELECT IC.Id            AS Id'
          '     , IC.GoodsId       AS GoodsId'
          '     , G.Code           AS GoodsCode'
          '     , G.Name           AS GoodsName'
          '     , IC.Amount        AS Amount'
          '     , IC.DateInput     AS Date_Insert'
          '     , us.Name          AS UserName'
          '     , IC.IsSend       AS IsSend'
          
            '     , CAST (ROW_NUMBER() OVER (PARTITION BY IC.UserInputId ORDE' +
            'R BY IC.Id) AS Integer) AS Num'
          
            '    , CASE WHEN CAST (ROW_NUMBER() OVER (PARTITION BY IC.GoodsId' +
            ' ORDER BY IC.GoodsId, IC.Id DESC) AS Integer) = 1 THEN 1 ELSE 0 ' +
            'END  AS isLast'
          'FROM InventoryChild AS IC'
          '     LEFT JOIN Goods AS G ON G.Id = IC.GoodsId'
          '     LEFT JOIN UserSettings AS us ON us.Id = IC.UserInputId'
          'WHERE IC.Inventory = :inId'
          'ORDER BY IC.DateInput DESC')
      end>
    Left = 341
    Top = 105
  end
  object InfoDS: TDataSource
    DataSet = InfoCDS
    Left = 456
    Top = 249
  end
  object InfoCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 456
    Top = 177
  end
  object spSelectInfo: TdsdStoredProcSQLite
    DataSet = InfoCDS
    DataSets = <
      item
        DataSet = InfoCDS
      end>
    Params = <
      item
        Name = 'inInventory'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    SQLList = <
      item
        SQL.Strings = (
          'SELECT G.Id             AS GoodsId'
          '     , G.Code           AS GoodsCode'
          '     , G.Name           AS GoodsName'
          '     , R.Remains        AS Remains'
          '     , CAST(COALESCE (SUM(IC.Amount), 0.0) as Float)  AS Amount'
          'FROM  Goods AS G'
          
            '     LEFT JOIN InventoryChild AS IC ON IC.Inventory = :inInvento' +
            'ry'
          '                                   AND IC.GoodsId = G.Id '
          '     LEFT JOIN Remains AS R ON R.GoodsId = G.id'
          '                           AND R.UnitId =  :inUnitId '
          'WHERE COALESCE  (R.Remains, IC.Amount) <> 0'
          'GROUP BY G.Id'
          '       , G.Code'
          '       , G.Name '
          '       , R.Remains'
          'ORDER BY G.Name')
      end>
    Left = 461
    Top = 113
  end
  object DBViewAddOnInfo: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 701
    Top = 249
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridChildDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 549
    Top = 241
  end
end
