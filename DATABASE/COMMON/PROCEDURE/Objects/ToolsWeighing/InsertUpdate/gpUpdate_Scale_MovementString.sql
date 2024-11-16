-- Function: gpUpdate_Scale_MovementString()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MovementString (Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MovementString(
    IN inMovementId        Integer   , -- ���� ������� <��������>
    IN inDescCode          TVarChar  , -- 
    IN inValueData         TVarChar  , -- 
    IN inSession           TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);


     IF inMovementId <> 0
     THEN
         -- ������������ ����� 
         PERFORM lpInsertUpdate_MovementString (MovementStringDesc.Id, inMovementId, inValueData)
         FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
              LEFT JOIN MovementStringDesc ON MovementStringDesc.Code ILIKE tmp.DescCode;

         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 30.08.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_MovementString (inMovementItemId:= 0, inItemName:= 'zc_MILinkObject_BoxNumber', inValueData:= 1, inSession:= '5')
