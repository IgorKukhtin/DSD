inherited FormsForm: TFormsForm
  Caption = #1060#1086#1088#1084#1099' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
  ExplicitWidth = 591
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1092#1086#1088#1084
            DataBinding.FieldName = 'Name'
            Options.Editing = False
            Width = 267
          end
          object colHelpFile: TcxGridDBColumn
            Caption = #1055#1091#1090#1100' '#1082' '#1089#1087#1088#1072#1074#1082#1077
            DataBinding.FieldName = 'HelpFile'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ShellExecuteAction1
                Default = True
                Kind = bkEllipsis
              end>
            Width = 263
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object actUpdate_Object_Form_HelpFile: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Object_Form_HelpFile
      StoredProcList = <
        item
          StoredProc = spUpdate_Object_Form_HelpFile
        end>
      Caption = 'actUpdate_Object_Form_HelpFile'
      DataSource = MasterDS
    end
    object ShellExecuteAction1: TShellExecuteAction
      Category = 'DSDLib'
      MoveParams = <>
      Param.Value = Null
      Param.Component = MasterCDS
      Param.ComponentItem = 'HelpFile'
      Param.DataType = ftString
      Param.ParamType = ptInput
      Caption = 'ShellExecuteAction1'
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 136
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 136
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Form'
    Left = 104
    Top = 136
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 136
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object spUpdate_Object_Form_HelpFile: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Form_HelpFile'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inFormName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inHelpFile'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'HelpFile'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 216
    Top = 136
  end
end
