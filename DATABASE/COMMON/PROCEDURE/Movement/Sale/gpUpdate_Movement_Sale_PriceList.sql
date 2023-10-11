-- Function: gpUpdate_Movement_Sale_PriceList()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_PriceList (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_PriceList(
    IN inMovementId      Integer   , -- ���� ������� <��������>   
    IN inPriceListId     Integer   , -- �����
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer; 
   DECLARE vbStatusId  Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Sale_PriceList());

     IF COALESCE (inPriceListId,0) = 0 
     THEN 
          RAISE EXCEPTION '������.�������� <����� ����> ������ ���� �����������.';
     END IF;
     
     IF COALESCE (inMovementId,0) = 0 
     THEN 
          RAISE EXCEPTION '������.�������� �� ���������.';
     END IF;
     
     --���� �������� �������� �����������
     vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);  
     
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN 
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;
       
     -- ��������� ����� � <����� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, inPriceListId);  
     
     --����� ��������� ���������� ��� � ���������
     PERFORM gpUpdate_MovementItem_Sale_Price(inMovementId, inSession);

     --���� �������� ��� ��������  �������� �������
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN 
         PERFORM gpComplete_Movement_Sale (inMovementId := inMovementId);
     END IF;
     
     
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.10.23         *
*/
