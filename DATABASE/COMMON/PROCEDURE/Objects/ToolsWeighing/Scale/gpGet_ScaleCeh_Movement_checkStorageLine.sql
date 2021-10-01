-- Function: gpGet_ScaleCeh_Movement_checkStorageLine()

DROP FUNCTION IF EXISTS gpGet_ScaleCeh_Movement_checkStorageLine (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ScaleCeh_Movement_checkStorageLine(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (isStorageLine_empty Boolean
             , MessageStr          TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� - ��� ��
     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId
                           , MovementItem.Amount
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                            ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_StorageLine.DescId         = zc_MILinkObject_StorageLine()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.isErased   = FALSE
                        AND MILinkObject_StorageLine.ObjectId IS NULL
                      LIMIT 1
                     )
       SELECT CASE WHEN EXISTS (SELECT 1 FROM tmpMI) THEN FALSE ELSE TRUE END :: Boolean AS isStorageLine_empty
            , ('��� ������ ' || lfGet_Object_ValueData ((SELECT tmpMI.ObjectId FROM tmpMI))
            || CHR(13) || '���-�� = <' || zfConvert_FloatToString ((SELECT tmpMI.Amount FROM tmpMI)) || '>'
            || CHR(13) || '�� ����������� �������� <����� ������������>.'
              ) :: TVarChar AS MessageStr
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 03.06.17                                        *
*/

-- ����
-- SELECT * FROM gpGet_ScaleCeh_Movement_checkStorageLine (inMovementId:= 0, inSession:= '5')
