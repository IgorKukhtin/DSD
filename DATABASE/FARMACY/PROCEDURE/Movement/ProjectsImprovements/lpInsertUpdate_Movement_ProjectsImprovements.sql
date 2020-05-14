-- Function: lpInsertUpdate_Movement_ProjectsImprovements()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProjectsImprovements (Integer, TVarChar, TDateTime, TVarChar, Text, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ProjectsImprovements(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inTitle               TVarChar  , -- ��������
    IN inDescription         Text      , -- ������� �������� 
    IN inComment             TVarChar  , -- ���������� 
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProjectsImprovements(), inInvNumber, inOperDate, NULL, 0);

     -- ��������� <��������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Title(), ioId, inTitle);

     -- ��������� <������ �������� >
     PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Description(), ioId, inDescription);

     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (��������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.05.20                                                       *
 */
