-- Function: gpUpdate_Movement_ServiceItem()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ServiceItem (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_ServiceItem(
    IN inId                  Integer   , -- ���� ������� <>  
    IN inMovementId          Integer   , --
    IN inUnitId              Integer   , -- ����� 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
    IN inDateEnd             TDateTime , --
    IN inAmount              TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inArea                TFloat    , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     --���� inId = 0 ���� ���. � ���. ���� � ��������� ������, ����� ������������ ������ inId � ��������� inMovementId
     IF COALESCE (inId,0) = 0
     THEN
         --���� ���. � ���. ����
         inMovementId := (SELECT Movement.Id
                          FROM Movement 
                          WHERE Movement.OperDate = CURRENT_DATE
                            AND Movement.DescId = zc_Movement_ServiceItem()
                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                          );
         --���� �� ����� �������
         IF COALESCE (inMovementId,0) = 0
         THEN
             inMovementId := lpInsertUpdate_Movement_ServiceItem (inId        := 0
                                                                , inInvNumber := CAST (NEXTVAL ('movement_serviceitem_seq') AS TVarChar)
                                                                , inOperDate  := CURRENT_DATE
                                                                , inUserId    := vbUserId
                                                                 );
         END IF;

         --������� ����� ������ �� ����� �����+������
         inId := (SELECT MovementItem.Id
                  FROM MovementItem
                       INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                    AND MovementItem.ObjectId = inUnitId
                  );

     END IF;
     
     --���� ��� �������� - �����������
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         vbStatusId := zc_Enum_Status_Complete();
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId:= inMovementId, inUserId:= vbUserId);
     END IF;

         
     PERFORM lpInsertUpdate_MovementItem_ServiceItem (ioId                 := COALESCE (inId,0)
                                                    , inMovementId         := inMovementId
                                                    , inUnitId             := inUnitId
                                                    , inInfoMoneyId        := inInfoMoneyId
                                                    , inCommentInfoMoneyId := inCommentInfoMoneyId
                                                    , inDateEnd            := inDateEnd
                                                    , inAmount             := inAmount
                                                    , inPrice              := inPrice
                                                    , inArea               := inArea
                                                    , inUserId             := vbUserId
                                                     );

     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         -- ��������
         PERFORM lpComplete_Movement_ServiceItem (inMovementId:= inMovementId, inUserId:= vbUserId);
     END IF; 
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.06.22         *
 */

-- ����
--