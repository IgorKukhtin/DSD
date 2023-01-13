-- Function: gpSetUnErased_MovementItem (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetUnErased_MovementItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetUnErased_MovementItem(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_???());
     vbUserId:= lpGetUserBySession (inSession);


     -- �����
     vbMovementId:= (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId);

     -- ���� ��������
     /*IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = vbMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- ����������
         PERFORM lpUnComplete_Movement (vbMovementId, vbUserId);
     END IF;*/


     -- ������������� ����� ��������
     outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);


     -- �������� ��������
     /*IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId AND Movement.DescId = zc_Movement_Cash())
     THEN
          PERFORM lpComplete_Movement_Cash (inMovementId := vbMovementId
                                          , inUserId     := vbUserId
                                           );
     ELSE
         RAISE EXCEPTION '������.';
     END IF;*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.10.14                                        *
*/

-- ����
-- SELECT * FROM gpSetUnErased_MovementItem (inMovementItemId:= 0, inSession:= '2')
