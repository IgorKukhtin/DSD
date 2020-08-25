object MapFrame: TMapFrame
  Left = 0
  Top = 0
  Width = 679
  Height = 479
  TabOrder = 0
  object GridPanel: TGridPanel
    Left = 0
    Top = 0
    Width = 679
    Height = 49
    Align = alTop
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = 'GridPanel'
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 1
        Control = lblSlave
        Row = 0
      end
      item
        Column = 0
        Control = lblMaster
        Row = 0
      end
      item
        Column = 0
        Control = edSlaveSearch
        Row = 1
      end
      item
        Column = 1
        Control = edMasterSeatch
        Row = 1
      end>
    RowCollection = <
      item
        SizeStyle = ssAuto
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 50.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 0
    object lblSlave: TLabel
      Left = 297
      Top = 0
      Width = 298
      Height = 22
      Align = alTop
      Alignment = taCenter
      Caption = 'Slave'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 337
      ExplicitWidth = 48
    end
    object lblMaster: TLabel
      Left = 0
      Top = 0
      Width = 297
      Height = 22
      Align = alTop
      Alignment = taCenter
      Caption = 'Master'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 62
    end
    object edSlaveSearch: TEdit
      Left = 0
      Top = 22
      Width = 297
      Height = 24
      Align = alClient
      TabOrder = 0
      TextHint = 'Type search ...'
      OnChange = edMasterSeatchChange
      ExplicitWidth = 337
    end
    object edMasterSeatch: TEdit
      Left = 297
      Top = 22
      Width = 298
      Height = 24
      Align = alClient
      TabOrder = 1
      TextHint = 'Type search ...'
      OnChange = edMasterSeatchChange
      ExplicitLeft = 337
      ExplicitWidth = 338
    end
  end
  object dgMaster: TDrawGrid
    Left = 0
    Top = 49
    Width = 679
    Height = 179
    Align = alClient
    ColCount = 6
    Ctl3D = True
    DefaultColWidth = 45
    DefaultRowHeight = 20
    DrawingStyle = gdsGradient
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goFixedColClick]
    ParentCtl3D = False
    ScrollBars = ssVertical
    TabOrder = 1
    ExplicitHeight = 184
    ColWidths = (
      45
      108
      167
      96
      93
      45)
  end
  object dgFields: TDrawGrid
    Left = 0
    Top = 228
    Width = 679
    Height = 251
    Align = alBottom
    ColCount = 6
    Ctl3D = True
    DefaultColWidth = 45
    DefaultRowHeight = 20
    DrawingStyle = gdsGradient
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goFixedColClick]
    ParentCtl3D = False
    ScrollBars = ssVertical
    TabOrder = 2
    ColWidths = (
      45
      108
      167
      96
      93
      45)
  end
end
