-- Function: lpDelete_CashSession()

DROP FUNCTION IF EXISTS gpDelete_CashSession (TVarChar);
DROP FUNCTION IF EXISTS gpDelete_CashSession (TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_CashSession(
    IN inCashSessionId       TVarChar, -- �� ������
    IN inSession             TVarChar  -- ������ ������������
)
RETURNS Void AS
$BODY$
BEGIN
    --�������� �������
    DELETE FROM CashSessionSnapShot
    WHERE CashSessionId = inCashSessionId;
    --������� ������
    DELETE FROM CashSession
    WHERE Id = inCashSessionId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_CashSession (TVarChar,TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 10.09.15                                                         *
*/
