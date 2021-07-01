-- Function: lpInsertUpdate_Movement_StoreReal()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, TFloat);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_StoreReal (
 INOUT ioId        Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber TVarChar  , -- ����� ���������
    IN inOperDate  TDateTime , -- ���� ���������
    IN inPartnerId Integer   , -- ����������
    IN inComment   TVarChar  , -- ����������
    IN inUserId    Integer    -- ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
      -- ��������
      IF inOperDate <> DATE_TRUNC('DAY', inOperDate)
      THEN
        RAISE EXCEPTION '������.�������� ������ ����.';
      END IF;

      -- ���������� ���� �������
      vbAccessKeyId := NULL; -- lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_StoreReal());

      -- ���������� ������� ��������/�������������
      vbIsInsert := COALESCE(ioId, 0) = 0;

-- ������ �.�.
IF inPartnerId = 1 OR COALESCE (inPartnerId, 0) = 0 -- OR inUserId = 6120598
THEN
    RAISE EXCEPTION '������.inPartnerId = <%>', inPartnerId;
END IF;

      -- ��������� <��������>
      ioId := lpInsertUpdate_Movement(ioId, zc_Movement_StoreReal(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

      IF vbIsInsert 
      THEN
           -- ��������� ����� � <������������>
           PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Insert(), ioId, inUserId);
           -- ��������� �������� <���� ��������>
           PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
      END IF;


      -- ��������� ����� � <����������>
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Partner(), ioId, inPartnerId);    

      -- �����������
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

      -- ��������� ��������
      PERFORM lpInsert_MovementProtocol(ioId, inUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 25.03.17         *
 16.02.17                                                        *                                          
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_StoreReal (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inUserId:= 2, inPartnerId:= 17819, inComment:= '����');
