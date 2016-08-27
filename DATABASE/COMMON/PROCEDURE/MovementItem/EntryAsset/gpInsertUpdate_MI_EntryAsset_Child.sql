-- Function: gpInsertUpdate_MI_EntryAsset_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_EntryAsset_Child (Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_EntryAsset_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inComment             TVarChar ,   -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbNameBeforeId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_EntryAsset());

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inObjectId, inMovementId, inAmount, inParentId);


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� �������� !!!����� ���������!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.08.16         *
*/

-- ����
-- 