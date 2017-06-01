-- Function: lfGet_User_BillNumberMobile (Integer)

DROP FUNCTION IF EXISTS lfGet_User_BillNumberMobile (Integer);

CREATE OR REPLACE FUNCTION lfGet_User_BillNumberMobile(
    IN inUserId       Integer
)
RETURNS Integer
AS
$BODY$
BEGIN

     -- ���� ��������� ����������
     RETURN COALESCE ((SELECT ObjectFloat.ValueData
                       FROM ObjectFloat
                       WHERE ObjectFloat.DescId   = zc_ObjectFloat_User_BillNumberMobile()
                         AND ObjectFloat.ObjectId = inUserId), 0) :: Integer;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_User_BillNumberMobile (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.04.17                                        *
*/

-- ����
-- SELECT * FROM lfGet_User_BillNumberMobile (5)
