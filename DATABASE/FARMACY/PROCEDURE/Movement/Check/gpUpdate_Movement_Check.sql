-- Function: gpUpdate_Movement_Check()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check(
    IN inId                  Integer   , -- ���� ������� <�������� ���>
    IN inPaidTypeId          Integer   , -- ��� ������ (��� / �����)
    IN inCashRegisterId      Integer   , -- �������� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());
    vbUserId := inSession;
    IF NOT EXISTS(SELECT 1 
                  FROM 
                      Movement
                  WHERE
                      ID = inId
                      AND
                      DescId = zc_Movement_Check()
                      AND
                      StatusId = zc_Enum_Status_Uncomplete()
                 )
    THEN
        RAISE EXCEPTION '������. �������� �� ��������, ���� �� ��������� � ��������� "�� ��������"!';
    END IF;
    -- ��������� ����� � <�������� �������>
    IF inCashRegisterId <> 0 
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(),inId,inCashRegisterId);
    END IF;
	-- ��������� ����� � <��� ������>
    IF inPaidTypeId <> 0
    THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inId,inPaidTypeId);
    END IF;
	 
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_Movement_Check (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 14.09.15                                                                         * 
*/
