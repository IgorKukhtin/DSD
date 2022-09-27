-- Function: gpUpdate_Object_Price_MCS_ReportDay (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Price_MCS_ReportDay (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Price_MCS_ReportDay(
    IN inUnitId                   Integer   ,    -- �������������
    IN inGoodsId                  Integer   ,    -- �����
    IN inMCSValue                 TFloat    ,    -- ����������� �������� �����
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    IF COALESCE (inMCSValue, 0) > 0
    THEN
      
      PERFORM gpUpdate_Object_Price_MCS_byReport(inUnitId     := inUnitId     -- �������������
                                               , inGoodsId    := inGoodsId    -- �����
                                               , inMCSValue   := inMCSValue   -- ����������� �������� �����
                                               , inDays       := 7            -- ���-�� ���� ������� ���
                                               , inisMCSAuto  := True         -- ����� - ��� �������� ��������� �� ������
                                               , inSession    := inSession    -- ������ ������������
                                                );
                                                
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 27.09.22                                                      *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Price_MCS_ReportDay()
