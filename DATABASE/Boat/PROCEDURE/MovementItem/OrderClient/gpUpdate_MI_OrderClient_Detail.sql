-- Function: gpUpdate_MI_OrderClient_Detail()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderClient_Detail(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inObjectId            Integer   , -- ������������� / ������/������ / Boat Structure
    IN inAmount              TFloat    , -- ���������� ��� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     --
     vbUserId := lpGetUserBySession (inSession);

      -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Detail(), inObjectId, NULL, inMovementId, inAmount, NULL, vbUserId);

 
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.08.25         * 
*/

-- ����
-- SELECT * FROM gpUpdate_MI_OrderClient_Detail (inId:= 0, inMovementId:= 10, inObjectId:= 1, inAmount:= 0, inSession:= '2')
