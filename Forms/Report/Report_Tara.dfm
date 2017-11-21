inherited Report_TaraForm: TReport_TaraForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1072#1088#1077' ('#1082#1086#1083'-'#1074#1086')'
  ClientHeight = 490
  ClientWidth = 975
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitLeft = -202
  ExplicitTop = -68
  ExplicitWidth = 991
  ExplicitHeight = 525
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 90
    Width = 975
    Height = 400
    TabOrder = 3
    ExplicitTop = 90
    ExplicitWidth = 975
    ExplicitHeight = 400
    ClientRectBottom = 400
    ClientRectRight = 975
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 975
      ExplicitHeight = 400
      inherited cxGrid: TcxGrid
        Width = 975
        Height = 400
        ExplicitWidth = 975
        ExplicitHeight = 400
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsInActive
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsInPassive
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsIn
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountInventory
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsOutActive
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsOutPassive
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsOut
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountInBay
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountOutSale
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountLoss
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountPartner_out
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountPartner_in
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsInActive
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsInPassive
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsIn
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountInventory
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsOutActive
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsOutPassive
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsOut
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountInBay
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountOutSale
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountLoss
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountPartner_out
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountPartner_in
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object AccountGroupCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1075#1088'. '#1089#1095'.'
            DataBinding.FieldName = 'AccountGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AccountGroupName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1075#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'AccountGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsGroupCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1075#1088'.'
            DataBinding.FieldName = 'GoodsGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 29
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object ObjectType: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1084'.'#1091#1095'.'
            DataBinding.FieldName = 'ObjectType'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object ObjectCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1084'. '#1091#1095'.'
            DataBinding.FieldName = 'ObjectCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object ObjectName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object ObjectDescName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ObjectDescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1084#1077#1089#1090#1086' '#1091#1095#1077#1090#1072')'
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object RemainsInActive: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1072#1082#1090#1080#1074
            DataBinding.FieldName = 'RemainsInActive'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object RemainsInPassive: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1087#1072#1089#1089#1080#1074
            DataBinding.FieldName = 'RemainsInPassive'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object RemainsIn: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'RemainsIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1074#1085#1091#1090#1088'.'
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1074#1085#1091#1090#1088'.'
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountInBay: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1074#1085#1077#1096#1085'.'
            DataBinding.FieldName = 'AmountInBay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountOutSale: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1074#1085#1077#1096#1085'.'
            DataBinding.FieldName = 'AmountOutSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object AmountInventory: TcxGridDBColumn
            Caption = #1048#1085#1074#1077#1085#1090'. (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
            DataBinding.FieldName = 'AmountInventory'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object AmountLoss: TcxGridDBColumn
            Caption = #1057#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'AmountLoss'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RemainsOutActive: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085'. '#1072#1082#1090#1080#1074
            DataBinding.FieldName = 'RemainsOutActive'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object RemainsOutPassive: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085'. '#1087#1072#1089#1089#1080#1074
            DataBinding.FieldName = 'RemainsOutPassive'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object RemainsOut: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085'. ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'RemainsOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPartner_out: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1074#1080#1088#1090' ('#1089' '#1060#1080#1083#1080#1072#1083#1072')'
            DataBinding.FieldName = 'AmountPartner_out'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object AmountPartner_in: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1074#1080#1088#1090' ('#1089' '#1060#1080#1083#1080#1072#1083#1072')'
            DataBinding.FieldName = 'AmountPartner_in'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 975
    Height = 64
    ExplicitWidth = 975
    ExplicitHeight = 64
    object chkWithSupplier: TcxCheckBox
      Left = 408
      Top = 6
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080
      TabOrder = 4
      Width = 97
    end
    object chbWithBayer: TcxCheckBox
      Left = 511
      Top = 6
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1080
      TabOrder = 5
      Width = 90
    end
    object chbWithPlace: TcxCheckBox
      Left = 607
      Top = 5
      Caption = #1057#1082#1083#1072#1076#1099
      TabOrder = 6
      Width = 75
    end
    object chbWithBranch: TcxCheckBox
      Left = 688
      Top = 6
      Caption = #1060#1080#1083#1080#1072#1083#1099
      TabOrder = 7
      Width = 84
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 25
      Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072' :'
    end
    object edObject: TcxButtonEdit
      Left = 10
      Top = 41
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 332
    end
    object cxLabel4: TcxLabel
      Left = 348
      Top = 25
      Caption = #1058#1086#1074#1072#1088' / '#1043#1088#1091#1087#1087#1072':'
    end
    object edGoods: TcxButtonEdit
      Left = 348
      Top = 41
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 253
    end
    object chkWithMember: TcxCheckBox
      Left = 778
      Top = 5
      Caption = #1052#1054#1051
      TabOrder = 12
      Width = 53
    end
    object ceAccountGroup: TcxButtonEdit
      Left = 607
      Top = 41
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 218
    end
    object cxLabel5: TcxLabel
      Left = 607
      Top = 25
      Caption = #1057#1095#1077#1090' '#1075#1088#1091#1087#1087#1072':'
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = AccountGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = chbWithBayer
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chbWithBranch
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chbWithPlace
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chkWithMember
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chkWithSupplier
        Properties.Strings = (
          'Checked')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ObjectGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGetTaraMovementDescSets
        end>
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_TaraDialogForm'
      FormNameParam.Value = 'TReport_TaraDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 'NULL'
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = ObjectGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = ObjectGuides
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
        end
        item
          Name = 'WithSupplier'
          Value = Null
          Component = chkWithSupplier
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'WithBayer'
          Value = Null
          Component = chbWithBayer
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'WithPlace'
          Value = Null
          Component = chbWithPlace
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'WithBranch'
          Value = Null
          Component = chbWithBranch
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'WithMember'
          Value = Null
          Component = chkWithMember
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = AccountGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = AccountGroupGuides
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object MovementTara_In_Form: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'IncomeJournal'
      FormName = 'TReport_TaraMovementForm'
      FormNameParam.Value = 'TReport_TaraMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'InDesc'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MLODesc'
          Value = Null
          Component = FormParams
          ComponentItem = 'InMLODesc'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementTara_InBay_Form: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'IncomeJournal'
      FormName = 'TReport_TaraMovementForm'
      FormNameParam.Value = 'TReport_TaraMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'InBayDesc'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MLODesc'
          Value = Null
          Component = FormParams
          ComponentItem = 'InMLODesc'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementTara_Out_Form: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'IncomeJournal'
      FormName = 'TReport_TaraMovementForm'
      FormNameParam.Value = 'TReport_TaraMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'OutDesc'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MLODesc'
          Value = Null
          Component = FormParams
          ComponentItem = 'OutMLODesc'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementTara_OutSale_Form: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'IncomeJournal'
      FormName = 'TReport_TaraMovementForm'
      FormNameParam.Value = 'TReport_TaraMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'OutSaleDesc'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MLODesc'
          Value = Null
          Component = FormParams
          ComponentItem = 'OutMLODesc'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementTara_Inventory_Form: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'IncomeJournal'
      FormName = 'TReport_TaraMovementForm'
      FormNameParam.Value = 'TReport_TaraMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'InventoryDesc'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MLODesc'
          Value = Null
          Component = FormParams
          ComponentItem = 'InventoryMLODesc'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementTara_Loss_Form: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'IncomeJournal'
      FormName = 'TReport_TaraMovementForm'
      FormNameParam.Value = 'TReport_TaraMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = FormParams
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'LossDesc'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MLODesc'
          Value = Null
          Component = FormParams
          ComponentItem = 'LossMLODesc'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrintJuridical: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintJuridical
      StoredProcList = <
        item
          StoredProc = spSelectPrintJuridical
        end>
      Caption = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1091
      Hint = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1091
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'operdate;UnitName;MovementDescName;InvNumber'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = 'FALSE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091' ('#1090#1072#1088#1072')'
      ReportNameParam.Name = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091
      ReportNameParam.Value = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091' ('#1090#1072#1088#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091
      Hint = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'operdate;UnitName;MovementDescName;InvNumber'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = 'FALSE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091' ('#1090#1072#1088#1072')'
      ReportNameParam.Name = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091
      ReportNameParam.Value = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091' ('#1090#1072#1088#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actPrintJuridicalGoods: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintJuridicalGoods
      StoredProcList = <
        item
          StoredProc = spSelectPrintJuridicalGoods
        end>
      Caption = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1091' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      Hint = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1091' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 'GoodsOrGroupName'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName;operdate;UnitName;MovementDescName;InvNumber'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = 'TRUE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091' ('#1090#1072#1088#1072')'
      ReportNameParam.Name = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091
      ReportNameParam.Value = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091' ('#1090#1072#1088#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actPrintGoods: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintGoods
      StoredProcList = <
        item
          StoredProc = spSelectPrintGoods
        end>
      Caption = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      Hint = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 'GoodsOrGroupName'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName;operdate;UnitName;MovementDescName;InvNumber'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = 'TRUE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091' ('#1090#1072#1088#1072')'
      ReportNameParam.Name = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091
      ReportNameParam.Value = 'A'#1082#1090' '#1089#1074#1077#1088#1082#1080' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1091' ('#1090#1072#1088#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Top = 144
  end
  inherited MasterCDS: TClientDataSet
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_Tara'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWithSupplier'
        Value = Null
        Component = chkWithSupplier
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWithBayer'
        Value = Null
        Component = chbWithBayer
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWithPlace'
        Value = Null
        Component = chbWithPlace
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWithBranch'
        Value = Null
        Component = chbWithBranch
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWithMember'
        Value = Null
        Component = chkWithMember
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWhereObjectId'
        Value = Null
        Component = ObjectGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsOrGroupId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountGroup'
        Value = Null
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 144
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 208
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintJuridical'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
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
    object dxBarButton1: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
      ImageIndex = 3
    end
    object bbPrintJuridical: TdxBarButton
      Action = actPrintJuridical
      Category = 0
      ImageIndex = 16
    end
    object bbPrint1: TdxBarButton
      Action = actPrintGoods
      Category = 0
      ImageIndex = 19
    end
    object bb: TdxBarButton
      Action = actPrintJuridicalGoods
      Category = 0
      ImageIndex = 22
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColumnAddOnList = <
      item
        Column = AmountIn
        Action = MovementTara_In_Form
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = AmountInBay
        Action = MovementTara_InBay_Form
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = AmountOut
        Action = MovementTara_Out_Form
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = AmountOutSale
        Action = MovementTara_OutSale_Form
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = AmountInventory
        Action = MovementTara_Inventory_Form
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = AmountLoss
        Action = MovementTara_Loss_Form
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = ObjectGuides
      end
      item
        Component = GoodsGuides
      end
      item
        Component = chbWithBayer
      end
      item
        Component = chbWithBranch
      end
      item
        Component = chbWithPlace
      end
      item
        Component = chkWithSupplier
      end
      item
        Component = chkWithMember
      end
      item
        Component = AccountGroupGuides
      end>
    Top = 184
  end
  object ObjectGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edObject
    FormNameParam.Value = 'TPartnerAndUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerAndUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = Null
        Component = ObjectGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = ObjectGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 8
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsTree_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsTree_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 32
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ObjectId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ObjectName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InBayDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OutDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OutSaleDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InventoryDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LossDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InMLODesc'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'OutMLODesc'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'InventoryMLODesc'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'LossMLODesc'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AccountGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AccountGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 24
    Top = 328
  end
  object spGetTaraMovementDescSets: TdsdStoredProc
    StoredProcName = 'gpGetTaraMovementDescSets'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'InDesc'
        Value = 42370d
        Component = FormParams
        ComponentItem = 'InDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InBayDesc'
        Value = 42370d
        Component = FormParams
        ComponentItem = 'InBayDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OutDesc'
        Value = 'False'
        Component = FormParams
        ComponentItem = 'OutDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OutSaleDesc'
        Value = 'False'
        Component = FormParams
        ComponentItem = 'OutSaleDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InventoryDesc'
        Value = 'False'
        Component = FormParams
        ComponentItem = 'InventoryDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LossDesc'
        Value = 'False'
        Component = FormParams
        ComponentItem = 'LossDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InMLODesc'
        Value = 'False'
        Component = FormParams
        ComponentItem = 'InMLODesc'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OutMLODesc'
        Value = ''
        Component = FormParams
        ComponentItem = 'OutMLODesc'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InventoryMLODesc'
        Value = ''
        Component = FormParams
        ComponentItem = 'InventoryMLODesc'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LossMLODesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'LossMLODesc'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 264
  end
  object AccountGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountGroup
    FormNameParam.Value = 'TAccountGroup_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAccountGroup_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Goods'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 728
    Top = 37
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 716
    Top = 217
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 270
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_Tara_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
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
        Name = 'inWhereObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsOrGroupId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountGroup'
        Value = Null
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoods'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 439
    Top = 328
  end
  object spSelectPrintJuridical: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_Tara_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWhereObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsOrGroupId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountGroup'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoods'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 439
    Top = 376
  end
  object spSelectPrintGoods: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_Tara_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWhereObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsOrGroupId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountGroup'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoods'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 551
    Top = 328
  end
  object spSelectPrintJuridicalGoods: TdsdStoredProc
    StoredProcName = 'gpSelect_Report_Tara_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWhereObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsOrGroupId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountGroup'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoods'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 551
    Top = 384
  end
end
