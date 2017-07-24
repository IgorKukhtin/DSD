-- Function: gpComplete_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);
 
    -- ���������� ��������
    PERFORM lpComplete_Movement_ReturnIn(inMovementId, -- ���� ���������
                                         vbUserId);    -- ������������  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

    -- ����������� "��������" ����� �� ��������� �������
    PERFORM lpUpdate_MI_Sale_Total(Object_PartionMI.ObjectCode :: Integer)
    FROM MovementItem
         INNER JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                           ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
         LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE;
    
    -- ��������� ��������� ����� �� ����������
    PERFORM lpUpdate_Object_Client_Total (inMovementId, inIsComplete:=TRUE, vbUserId);
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 23.07.17         *
 14.05.17         *
 */