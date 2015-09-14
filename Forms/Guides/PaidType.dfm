inherited PaidTypeForm: TPaidTypeForm
  Caption = #1058#1080#1087#1099' '#1086#1087#1083#1072#1090#1099
  ClientHeight = 310
  ClientWidth = 451
  ExplicitWidth = 467
  ExplicitHeight = 348
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 451
    Height = 284
    ExplicitWidth = 451
    ExplicitHeight = 284
    ClientRectBottom = 284
    ClientRectRight = 451
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 451
      ExplicitHeight = 284
      inherited cxGrid: TcxGrid
        Width = 451
        Height = 284
        ExplicitWidth = 451
        ExplicitHeight = 284
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
          end
          object colPaidTypeCode: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidTypeCode'
            PropertiesClassName = 'TcxRadioGroupProperties'
            Properties.Columns = 2
            Properties.Items = <
              item
                Caption = #1053#1072#1083#1080#1095#1085#1099#1081
                Value = 1
              end
              item
                Caption = #1050#1072#1088#1090#1072
                Value = 2
              end>
            Width = 202
          end
          object colPaidTypeName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'PaidTypeName'
            Width = 244
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidTypeName'
          DataType = ftString
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidTypeCode'
        end>
    end
  end
  inherited MasterDS: TDataSource
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PaidType'
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 96
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 184
  end
end
