-- Function: gpUpdate_MovementItem_ReturnIn_Price()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_ReturnIn_Price (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_ReturnIn_Price(
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inPriceListId             Integer   , -- ���� ����� �����
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
     
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());


     -- ������������ ��������� ���������
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
                  
            INTO vbStatusId, vbInvNumber, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;


     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- �������� - ����� ���� ������ ���� ����������
     IF COALESCE (inPriceListId, 0) = 0 
     THEN
         RAISE EXCEPTION '������.�������� <����� ����> ������ ���� �����������.';
     END IF;
   

     -- ���������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), MovementItem.Id, COALESCE (lfObjectHistory_PriceListItem.ValuePrice, 0))
     FROM MovementItem
          LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= vbOperDate)
                 AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = MovementItem.ObjectId
     WHERE MovementId = inMovementId;


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- ��������� ����� � <PriceList>
     -- PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, inPriceListId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.08.15         *  

*/
