inherited StaffListMovementForm: TStaffListMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1103#1074#1082#1072' '#1085#1072' '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
  ClientHeight = 564
  ClientWidth = 1153
  ExplicitWidth = 1169
  ExplicitHeight = 603
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 126
    Width = 1153
    Height = 438
    ExplicitTop = 126
    ExplicitWidth = 1153
    ExplicitHeight = 438
    ClientRectBottom = 438
    ClientRectRight = 1153
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1153
      ExplicitHeight = 414
      inherited cxGrid: TcxGrid
        Width = 1153
        Height = 414
        ExplicitWidth = 1153
        ExplicitHeight = 414
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
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
              Column = StaffCount_1
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
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
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PositionName
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = StaffCount_1
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object PositionName: TcxGridDBColumn [0]
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 222
          end
          object PositionLevelName: TcxGridDBColumn [1]
            Caption = #1056#1072#1079#1088#1103#1076
            DataBinding.FieldName = 'PositionLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object StaffPaidKindName: TcxGridDBColumn [2]
            Caption = #1042#1080#1076' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'StaffPaidKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPartnerChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 127
          end
          object StaffHoursDayName: TcxGridDBColumn [3]
            Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099
            DataBinding.FieldName = 'StaffHoursDayName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object StaffHoursName: TcxGridDBColumn [4]
            Caption = #1063#1072#1089#1099' '#1088#1072#1073#1086#1090#1099
            DataBinding.FieldName = 'StaffHoursName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object StaffHoursLengthName: TcxGridDBColumn [5]
            Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1089#1084#1077#1085#1099', '#1095#1072#1089#1099' '#9
            DataBinding.FieldName = 'StaffHoursLengthName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object PersonalName: TcxGridDBColumn [6]
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088' '#1087#1086' '#1087#1077#1088#1089#1086#1085#1072#1083#1091
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object Amount: TcxGridDBColumn [7]
            Caption = #1064#1056' '#1076#1083#1103' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100
            Width = 70
          end
          object AmountReport: TcxGridDBColumn [8]
            Caption = #1064#1056' '#1076#1083#1103' '#1086#1090#1095#1077#1090#1072
            DataBinding.FieldName = 'AmountReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object StaffCount_1: TcxGridDBColumn [9]
            Caption = '1.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1087#1085'.'
            Width = 70
          end
          object StaffCount_2: TcxGridDBColumn [10]
            Caption = '2.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1074#1090'.'
            Width = 70
          end
          object StaffCount_3: TcxGridDBColumn [11]
            Caption = '3.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1089#1088'.'
            Width = 70
          end
          object StaffCount_4: TcxGridDBColumn [12]
            Caption = '4.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1095#1090'.'
            Width = 70
          end
          object StaffCount_5: TcxGridDBColumn [13]
            Caption = '5.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_57'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1087#1090'.'
            Width = 70
          end
          object StaffCount_6: TcxGridDBColumn [14]
            Caption = '6.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_67'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1089#1073'.'
            Width = 70
          end
          object StaffCount_7: TcxGridDBColumn [15]
            Caption = '7.'#1087#1085'.'
            DataBinding.FieldName = 'StaffCount_7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1074#1089'.'
            Width = 70
          end
          object StaffCount_Invent: TcxGridDBColumn [16]
            Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
            DataBinding.FieldName = 'StaffCount_Invent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1096#1090#1072#1090#1085#1080#1093' '#1086#1076#1080#1085#1080#1094#1100' '#1074' '#1089#1084#1077#1085#1091' '#1048#1085#1072#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
            Width = 70
          end
          object Staff_Price: TcxGridDBColumn [17]
            Caption = #1058#1072#1088#1080#1092#1080#1082#1072#1094#1080#1103
            DataBinding.FieldName = 'Staff_Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Staff_Summ_MK: TcxGridDBColumn [18]
            Caption = #1052#1050
            DataBinding.FieldName = 'Staff_Summ_MK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Staff_Summ_real: TcxGridDBColumn [19]
            Caption = #1057#1076#1077#1083#1100#1085#1072#1103' '#1086#1087#1083#1072#1090#1072
            DataBinding.FieldName = 'Staff_Summ_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Staff_Summ_add: TcxGridDBColumn [20]
            Caption = #1055#1088#1077#1084#1080#1072#1083#1100#1085#1080#1081' '#1092#1086#1085#1076
            DataBinding.FieldName = 'Staff_Summ_add'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Comment: TcxGridDBColumn [21]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1153
    Height = 100
    TabOrder = 3
    ExplicitWidth = 1153
    ExplicitHeight = 100
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 89
      ExplicitWidth = 84
      Width = 84
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      ExplicitLeft = 89
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 165
      ExplicitHeight = 22
      Width = 165
    end
    object cxLabel3: TcxLabel
      Left = 348
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 348
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 209
    end
    object cxLabel22: TcxLabel
      Left = 570
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 570
      Top = 63
      TabOrder = 9
      Width = 243
    end
    object cxLabel8: TcxLabel
      Left = 186
      Top = 45
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 186
      Top = 63
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 148
    end
    object cxLabel7: TcxLabel
      Left = 831
      Top = 45
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 830
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 187
    end
    object cxLabel24: TcxLabel
      Left = 348
      Top = 45
      Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 1 '#1088#1110#1074#1085#1103
    end
    object edDepartment: TcxButtonEdit
      Left = 348
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 209
    end
    object cxLabel14: TcxLabel
      Left = 570
      Top = 5
      Caption = #1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
    end
    object cePersonalHead: TcxButtonEdit
      Left = 570
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 243
    end
  end
  object edUpdateName: TcxButtonEdit [2]
    Left = 830
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 187
  end
  object cxLabel4: TcxLabel [3]
    Left = 830
    Top = 5
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
  end
  object edUpdateDate: TcxDateEdit [4]
    Left = 186
    Top = 23
    EditValue = 42132d
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 148
  end
  object cxLabel5: TcxLabel [5]
    Left = 186
    Top = 5
    Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'./'#1087#1088#1086#1074#1077#1076'.)'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 187
    Top = 448
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object InsertRecord: TInsertRecord [2]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actGoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 0
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProc = nil
      StoredProcList = <
        item
        end
        item
          StoredProc = spInsertUpdateMovement
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderReturnTare'
      ReportNameParam.Value = 'PrintMovement_OrderReturnTare'
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actPartnerChoice: TOpenChoiceForm [14]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TPartner_ObjectForm'
      FormNameParam.Value = 'TPartner_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 24
    Top = 424
  end
  inherited MasterCDS: TClientDataSet
    Left = 80
    Top = 448
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_StaffList'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
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
    object bbPrintNoGroup: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Visible = ivAlways
      ImageIndex = 16
      ShortCut = 16464
    end
    object bbPrintSaleOrder: TdxBarButton
      Caption = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      Category = 0
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbPrintSaleOrderTax: TdxBarButton
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      Category = 0
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbPersonalGroupChoiceForm: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#8470' '#1073#1088#1080#1075#1072#1076#1099
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#8470' '#1073#1088#1080#1075#1072#1076#1099
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bb: TdxBarButton
      Caption = #1057#1087#1080#1089#1086#1082' '#1053#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1086' '#1074#1086#1079#1074#1088#1072#1090#1085#1086#1081' '#1090#1072#1088#1077
      Category = 0
      Hint = #1057#1087#1080#1089#1086#1082' '#1053#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1086' '#1074#1086#1079#1074#1088#1072#1090#1085#1086#1081' '#1090#1072#1088#1077
      Visible = ivAlways
      ImageIndex = 26
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 750
    Top = 225
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSend'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 440
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderReturnTare'
    Left = 80
    Top = 64
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_StaffList'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = 0.000000000000000000
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = 0d
        Component = edUpdateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = 'False'
        Component = edUpdateName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalHeadId'
        Value = Null
        Component = GuidesPersonalHead
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalHeadName'
        Value = Null
        Component = GuidesPersonalHead
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DepartmentName'
        Value = Null
        Component = edDepartment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_StaffList'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Transport'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inManagerId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSecurityId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = 'False'
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = ceComment
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 272
    Top = 201
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 800
    Top = 328
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderReturnTare_SetErased'
    Left = 710
    Top = 440
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderReturnTare_SetUnErased'
    Left = 718
    Top = 384
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_StaffList'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_StaffList_Print'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 367
    Top = 376
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = edUnit
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 640
    Top = 184
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 432
  end
  object GuidesPersonalHead: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalHead
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalHead
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalHead
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 655
    Top = 7
  end
end
