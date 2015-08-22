-- Function: gpUpdate_MovementItem_Sale_Price()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_Price(
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPriceListId Integer;

 
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());


     -- ������������ ��������� ���������
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
          , MovementLinkObject_PriceList.ObjectId   AS PriceListId

            INTO vbStatusId, vbInvNumber, vbOperDate, vbPriceListId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                       ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
     WHERE Movement.Id = inMovementId;


     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- �������� - ����� ���� ������ ���� ����������
     IF COALESCE (vbPriceListId, 0) = 0 
     THEN
         RAISE EXCEPTION '������.�������� <����� ����> ������ ���� �����������.';
     END IF;
   

     -- ���������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price()
                                             , MovementItem.Id
                                             , lfObjectHistory_PriceListItem.ValuePrice
                                              )
                              
          FROM MovementItem
              LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate)
                     AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = MovementItem.ObjectId
          WHERE MovementId = inMovementId;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- ��������� ����� � <PriceList>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, vbPriceListId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.08.15         *

*/
