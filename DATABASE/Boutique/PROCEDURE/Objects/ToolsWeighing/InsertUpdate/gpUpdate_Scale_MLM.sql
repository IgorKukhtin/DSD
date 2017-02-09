-- Function: gpUpdate_Scale_MLM()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MLM (Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MLM(
    IN inMovementId        Integer   , -- ���� ������� <��������>
    IN inDescCode          TVarChar  , -- 
    IN inMovementChildId   Integer   , -- 
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
         PERFORM lpInsertUpdate_MovementLinkMovement (MovementLinkMovementDesc.Id, inMovementId, inMovementChildId)
         FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
              LEFT JOIN MovementLinkMovementDesc ON MovementLinkMovementDesc.Code = tmp.DescCode;

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
-- SELECT * FROM gpUpdate_Scale_MLM (inMovementItemId:= 0, inItemName:= 'zc_MILinkObject_BoxNumber', inValueData:= 1, inSession:= '5')
