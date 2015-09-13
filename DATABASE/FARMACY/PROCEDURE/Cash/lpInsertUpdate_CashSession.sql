-- Function: lpInsertUpdate_CashSession()

DROP FUNCTION IF EXISTS lpInsertUpdate_CashSession (TVarChar, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_CashSession(
    IN inCashSessionId       TVarChar  , -- �� ������
    IN inDateConnect         TDateTime   -- ���� ���������� ���������� �� �������
)
RETURNS Void AS
$BODY$
BEGIN
    
    IF EXISTS(SELECT 1
              FROM CashSession
              WHERE CashSession.Id = inCashSessionId)
    THEN
        UPDATE CashSession SET
            LastConnect = inDateConnect
        WHERE
            CashSession.Id = inCashSessionId;
    ELSE
        INSERT INTO CashSession(Id,LastConnect)
        VALUES(inCashSessionId,inDateConnect);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 10.09.15                                                         *
*/
