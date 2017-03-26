-- Function: lpInsertUpdate_Movement_Visit()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Visit (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Visit (
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
      vbAccessKeyId := NULL; -- lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Visit());

      -- ���������� ������� ��������/�������������
      vbIsInsert := COALESCE(ioId, 0) = 0;

      -- ��������� <��������>
      ioId := lpInsertUpdate_Movement(ioId, zc_Movement_Visit(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

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
 26.03.17         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Visit (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inUserId:= 2, inPartnerId:= 17819, inGUID:= NULL, inComment:= '����');
