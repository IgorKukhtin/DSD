-- Function: gpUnComplete_Movement_OrderExternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderExternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderExternal (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_OrderExternal(
    IN inMovementId        Integer               , -- ���� ���������
   OUT outPrinted          Boolean               ,
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������

)
RETURNS Boolean
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO
                     JOIN Object ON Object.Id = MLO.ObjectId AND Object.DescId = zc_Object_Unit()
                WHERE MLO.MovementId = inMovementId 
                  AND MLO.DescId     = zc_MovementLinkObject_From()
               )
     THEN
         -- ��� ��� zc_Object_Unit
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_OrderExternalUnit());
     ELSE
         -- ��� ��������� 
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_OrderExternal());
     END IF;


     -- ������ ������ ��������� + ��������� ��������
     outPrinted := lpUnComplete_Movement_OrderExternal (inMovementId := inMovementId, inUserId := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.09.21         *
 21.04.17                                        *
 06.06.14                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_OrderExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())