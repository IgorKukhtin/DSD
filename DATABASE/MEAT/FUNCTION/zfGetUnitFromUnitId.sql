-- Function: zfGetUnitFromUnitId

DROP FUNCTION IF EXISTS zfGetUnitFromUnitId (Integer);

CREATE OR REPLACE FUNCTION zfGetUnitFromUnitId(inUnitId Integer)
RETURNS Integer AS
$BODY$
BEGIN
  CASE inUnitId 
    WHEN 1389 THEN Return(8421);  -- ������
    WHEN  719 THEN Return(8411);  -- ����
    WHEN 4481 THEN Return(8413);  -- ������ ���
    WHEN 2994 THEN Return(8419);  -- ����
    -- WHEN  999 THEN Return(18341); -- ��������
    WHEN  999 THEN Return(256624); -- �������� - "����������� �.�. ��� �. ͳ������ ���. ������� 6"
    -- WHEN 1048 THEN Return(8423);  -- ������
    WHEN 1048 THEN Return(346093);  -- ����� �� �.������
    -- WHEN 1048 THEN Return(298605);  -- ������ - "�������� ����� ������������"
    WHEN 5271 THEN Return(8425);  -- �������
    WHEN 2991 THEN Return(8417);  -- ������-��������
    WHEN 2780 THEN Return(8415);  -- ��������
  END CASE;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfGetUnitFromUnitId (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.02.14                        *  
*/

-- ����
-- SELECT * FROM zfGetUnitFromUnitId (10)
