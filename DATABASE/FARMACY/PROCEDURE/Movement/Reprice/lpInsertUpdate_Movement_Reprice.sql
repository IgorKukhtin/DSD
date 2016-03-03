-- Function: lpInsertUpdate_Movement_Reprice()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Reprice (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Reprice(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inUnitId                Integer    , -- �� ���� (�������������)
    IN inGUID                  TVarChar   , -- GUID ��� ����������� ������� ����������
    IN inUserId                Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Reprice(), inInvNumber, inOperDate, NULL, 0);
    
    -- ��������� ����� � <�������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    -- ��������� <GUID>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inGUID);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

   -- !!!�������� ����� �������� ����������� �������!!!
   IF vbIsInsert=True 
   THEN
       -- ��������� �������� <���� ��������>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
       -- ��������� �������� <������������ (��������)>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, inUserId);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 02.03.16         * add Protocol_Insert
 27.11.15                                                                        *
*/