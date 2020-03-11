-- Function: lpInsertUpdate_Movement_TechnicalRediscount()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TechnicalRediscount (Integer, TVarChar, TDateTime, Integer, TVarChar, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TechnicalRediscount(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inComment             TVarChar  , -- ����������
    IN inisRedCheck          Boolean  ,  -- ������� ���
    IN inisAdjustment        Boolean  ,  -- ������������� ��������� ���������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TechnicalRediscount(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � <������������� � ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� <������� ���>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RedCheck(), ioId, inisRedCheck);
     -- ��������� <������������� ��������� ���������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Adjustment(), ioId, inisAdjustment);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.02.20                                                       *
 */
