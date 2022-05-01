-- Function: lpInsertUpdate_Movement_OrderReturnTare()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderReturnTare (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderReturnTare(
 INOUT ioId                    Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber             TVarChar  , -- ����� ���������
    IN inOperDate              TDateTime , -- ���� ���������
    IN inMovementId_Transport  Integer   , -- ������� ���� 
    IN inManagerId             Integer   , -- ����������� ���.������
    IN inSecurityId            Integer   , -- ����� ������������
    IN inComment               TVarChar  , --
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderReturnTare(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � ���������� <���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), ioId, inMovementId_Transport);
     -- ��������� ����� � ���������� <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Manager(), ioId, inManagerId);
     -- ��������� ����� � ���������� <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Security(), ioId, inSecurityId);


      -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� ����� � <������������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� ����� � <������������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId); 
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.01.22         *
*/

-- ����