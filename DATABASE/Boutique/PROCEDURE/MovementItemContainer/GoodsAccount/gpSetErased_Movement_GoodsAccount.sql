-- Function: gpSetErased_Movement_GoodsAccount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_GoodsAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_GoodsAccount(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);


     -- ��� ��� ���� + ������������: � ��������� ���� = ������
     IF EXISTS (SELECT 1
                FROM Object_RoleAccessKey_View
                WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_Check()
                  AND Object_RoleAccessKey_View.UserId      = vbUserId
               )
     THEN
         -- �������� ���� ������������ �� ����� ��������� - ��������, �.�. ����� "�������"
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_GoodsAccount());
     END IF;


    -- �������� - ���� ���������
    PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inUserId:= vbUserId);

    -- ���.������ ���������
    vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- ����������� "��������" ����� �� ��������� ������ ������� / ��������
    PERFORM lpUpdate_MI_Partion_Total_byMovement (inMovementId);

    -- ���� ��� ������ ��������
    IF vbStatusId = zc_Enum_Status_Complete()
    THEN
         -- �������� �������� ����� �� ����������
         PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= FALSE, inUserId:= vbUserId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 23.07.17         *
 18.05.17         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_GoodsAccount (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
