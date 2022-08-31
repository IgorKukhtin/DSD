-- Function: gpInsertUpdate_Movement_ServiceItemAdd()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ServiceItemAddAdd (Integer, TVarChar, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ServiceItemAddAdd (Integer, TVarChar, TDateTime, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ServiceItemAdd(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������  
    IN inComment              TVarChar  , --
    IN inUserId               Integer     -- ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ��������
     IF inOperDate > CURRENT_DATE
     THEN
        RAISE EXCEPTION '������.���� ��������� = <%> �� ����� ���� ����� <%>.', zfConvert_DateToString (inOperDate), zfConvert_DateToString (CURRENT_DATE);
     END IF;
     IF inOperDate < CURRENT_DATE
     THEN
        RAISE EXCEPTION '������.���� ��������� = <%> �� ����� ���� ������ <%>.', zfConvert_DateToString (inOperDate), zfConvert_DateToString (CURRENT_DATE);
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ServiceItemAdd(), inInvNumber, inOperDate, NULL, inUserId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.08.22         *
 10.06.22         *
 */

-- ����
--