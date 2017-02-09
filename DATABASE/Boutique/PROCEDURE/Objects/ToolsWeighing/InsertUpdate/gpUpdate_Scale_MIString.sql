-- Function: gpUpdate_Scale_MIString()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MIString (Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MIString(
    IN inMovementItemId        Integer   , -- ���� ������� <������� ���������>
    IN inDescCode              TVarChar  , -- 
    IN inValueData             TVarChar  , -- 
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
     PERFORM lpInsertUpdate_MovementItemString (MovementItemStringDesc.Id, inMovementItemId, inValueData)
     FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
          LEFT JOIN MovementItemStringDesc ON MovementItemStringDesc.Code = tmp.DescCode;


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
 17.05.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_MIString (inMovementItemId:= 29667832, inItemName:= 'zc_MIString_PartionGoods', inValueData:= '1', inSession:= '5')
