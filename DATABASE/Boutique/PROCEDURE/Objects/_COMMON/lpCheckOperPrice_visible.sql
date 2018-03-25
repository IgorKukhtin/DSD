-- Function: lpCheckOperPrice_visible (Integer)

DROP FUNCTION IF EXISTS lpCheckOperPrice_visible (Integer);

CREATE OR REPLACE FUNCTION lpCheckOperPrice_visible (
    IN inUserId    Integer   -- ������������
)
RETURNS Boolean
AS
$BODY$
BEGIN
     -- �������� ��� ������������ - � ������ ������������� �� ��������
     IF lpGetUnit_byUser (inUserId) > 0
     THEN
         -- ������ ���������� ���� ��.
         RETURN FALSE;
     ELSE
         -- ����� ���������� ���� ��.
         RETURN TRUE;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.03.18                                        *
*/

-- ����
-- SELECT * FROM lpCheckOperPrice_visible (inUserId:= zfCalc_UserAdmin() :: Integer)
