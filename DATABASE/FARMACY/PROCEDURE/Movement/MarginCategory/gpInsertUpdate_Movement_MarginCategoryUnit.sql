-- Function: gpInsertUpdate_Movement_MarginCategoryUnit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MarginCategoryUnit (Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_MarginCategoryUnit(
 INOUT ioId                    Integer    , -- ���� ������� <��������>
    IN inParentId              Integer    , -- ������ �������� �������� ������� ����
    IN inObjectId              Integer    , -- ������ / ��.����
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbIsInsert  Boolean;
   DECLARE vbOperdate  Tdatetime;
   DECLARE vbInvnumber Tvarchar;   
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
       
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    SELECT Movement.Operdate
         , Movement.Invnumber
         INTO vbOperdate, vbInvnumber
    FROM Movement
    WHERE Movement.Id = inParentId;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_MarginCategoryUnit(), vbInvnumber, vbOperdate, inParentId);
    
    -- ��������� ����� � <���������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Object(), ioId, inObjectId);
    
   
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.09.18         *
*/