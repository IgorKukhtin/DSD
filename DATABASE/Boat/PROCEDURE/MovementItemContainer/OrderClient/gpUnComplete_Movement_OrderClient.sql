-- Function: gpUnComplete_Movement_OrderClient (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderClient (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_OrderClient(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbProductId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_OrderClient());

    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId
                                  );

    -- ����� �����
    vbProductId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product());

    --
    IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbProductId AND Object.isErased = TRUE)
    THEN
        -- ������������ �����
        PERFORM lpUpdate_Object_isErased (inObjectId:= vbProductId
                                        , inIsErased:= FALSE
                                        , inUserId  := vbUserId
                                         );
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
*/