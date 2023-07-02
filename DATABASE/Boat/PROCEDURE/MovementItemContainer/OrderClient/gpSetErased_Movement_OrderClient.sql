-- Function: gpSetErased_Movement_OrderClient (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_OrderClient (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_OrderClient(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_OrderClient());

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- ������� �����
    PERFORM lpUpdate_Object_isErased (inObjectId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product())
                                    , inIsErased:= TRUE
                                    , inUserId  := vbUserId
                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
*/
