-- Function: gpSetErased_Movement_Loss (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Loss (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Loss(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbUnitiD   Integer;
  DECLARE vbArticleLossId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Loss());

     SELECT
         Movement.OperDate,
         Movement_Unit.ObjectId AS Unit,
         MovementLinkObject_ArticleLoss.ObjectId 
     INTO
         vbOperDate,
         vbUnitiD,
         vbArticleLossId
     FROM Movement
         INNER JOIN MovementLinkObject AS Movement_Unit
                                       ON Movement_Unit.MovementId = Movement.Id
                                      AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                      ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                     AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
     WHERE Movement.Id = inMovementId;

     -- �������� - ���� <Master> ��������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- �������� - ���� ���� <Child> ��������, �� <������>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     --�������� ������� �������� � ��������
     IF COALESCE(vbArticleLossId, 0) = 13892113
     THEN
       PERFORM gpInsertUpdate_MovementItem_WagesFullCharge (vbUnitiD, vbOperDate, inSession); 
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
21.07.15                                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Loss (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
