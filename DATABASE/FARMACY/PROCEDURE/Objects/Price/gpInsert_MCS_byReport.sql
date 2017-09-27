-- Function: gpInsert_MCS_byReport (TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_MCS_byReport (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MCS_byReport(
    IN inMCSValue                 TFloat    ,    -- ����������� �������� �����
   OUT outMCSValue                TFloat    ,    -- 
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
    DECLARE vbUserId       Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    IF COALESCE (inMCSValue, 0 ) = 0
    THEN
        RAISE EXCEPTION '������. �������� ��� ������ ���� ������ 0';
    END IF;
    
    outMCSValue := inMCSValue;
    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 27.09.17         *
*/

-- ����
-- SELECT * FROM gpInsert_MCS_byReport()
