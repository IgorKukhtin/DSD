-- Function: gpUpdate_Scale_MILinkObject()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MILinkObject (Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MILinkObject(
    IN inMovementItemId        Integer   , -- ���� ������� <������� ���������>
    IN inDescCode              TVarChar  , -- 
    IN inObjectId              Integer   , -- 
    IN inSession               TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (MovementItemLinkObjectDesc.Id, inMovementItemId, inObjectId)
     FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
          LEFT JOIN MovementItemLinkObjectDesc ON MovementItemLinkObjectDesc.Code = tmp.DescCode;


     -- ��������� �������� <����/�����>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inMovementItemId, CURRENT_TIMESTAMP);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 25.05.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_MILinkObject (inMovementItemId:= 0, inItemName:= 'zc_MILinkObject_BoxNumber', inValueData:= 1, inSession:= '5')
