-- Function: gpInsertUpdate_MI_IncomeFuel_Sign()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_IncomeFuel_Sign (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_IncomeFuel_Sign(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inIsSign              Boolean   ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeFuel_Sign());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     PERFORM gpInsertUpdate_MI_Sign (inMovementId, inIsSign, inSession);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.  ���������� �.�.
 03.08.17         *
 23.08.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '12894') -- ���������� �.�.
-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '12894') -- ���������� �.�.

-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '9463') -- ������ �.�.
-- SELECT * FROM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '9463') -- ������ �.�.
