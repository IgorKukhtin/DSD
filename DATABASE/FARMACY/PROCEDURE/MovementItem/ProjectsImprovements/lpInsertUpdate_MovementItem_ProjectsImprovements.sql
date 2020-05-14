-- Function: lpInsertUpdate_MovementItem_ProjectsImprovements()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProjectsImprovements(Integer, Integer, TDateTime, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ProjectsImprovements(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ����
    IN inTitle               TVarChar  , -- ��������
    IN inDescription         TVarChar  , -- �������� ������� 
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
 DECLARE vbIsInsert Boolean;
 DECLARE vbAmount TFloat;
BEGIN

     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     if vbIsInsert = TRUE
     THEN
       vbAmount := 0;
     ELSE
       vbAmount := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId);
     END IF;
     
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), Null, inMovementId, vbAmount, Null);

     -- ��������� <���������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

     -- ��������� <�������� �������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inTitle);
     -- ��������� < �������� ������� >
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Description(), ioId, inDescription);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (��������)>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.12.19                                                       *
*/

-- ����

