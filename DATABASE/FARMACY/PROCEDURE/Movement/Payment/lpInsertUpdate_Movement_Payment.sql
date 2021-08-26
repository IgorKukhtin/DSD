-- Function: lpInsertUpdate_Movement_Payment()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Payment (Integer, TVarChar, TDateTime, integer, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Payment(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inJuridicalId           Integer    , -- ������
    IN inisPaymentFormed       Boolean    , -- ������ ����������� 
    IN inComment               TVarChar   , -- �����������
    IN inUserId                Integer      -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ��������
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION '������.�������� ������ ����.';
    END IF;
    
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Payment(), inInvNumber, inOperDate, NULL, 0);
    
    -- ��������� ����� � �������
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
    
    -- ��������� <������ ����������� >
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PaymentFormed(), ioId, inisPaymentFormed);

    -- ��������� <�����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 29.10.15                                                                       *
*/