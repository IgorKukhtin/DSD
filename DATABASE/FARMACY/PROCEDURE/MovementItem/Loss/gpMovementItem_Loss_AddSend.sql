-- Function: gpMovementItem_Loss_AddSend

DROP FUNCTION IF EXISTS gpMovementItem_Loss_AddSend (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Loss_AddSend(
    IN inMovementId       Integer,   -- ��������
    IN inSendID          Integer,   -- �����������
    IN inSession          TVarChar  -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbComent TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '�������� �� ��������.';
    END IF;

    SELECT Format('����������� %s �� %s ���-�� %s ����� � ����� ����������� %s ���������� %s'      
           , Movement_Send.InvNumber
           , TO_CHAR (Movement_Send.OperDate, 'dd.mm.yyyy')
           , MovementFloat_TotalCount.ValueData
           , MovementFloat_TotalSummFrom.ValueData
           , COALESCE (MovementString_Comment.ValueData , ''))
    INTO  vbComent

    FROM Movement AS Movement_Send
              
         LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                 ON MovementFloat_TotalCount.MovementId = Movement_Send.Id
                                AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
   
         LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                 ON MovementFloat_TotalSummFrom.MovementId =  Movement_Send.Id
                                AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()

         LEFT JOIN MovementString AS MovementString_Comment
                                  ON MovementString_Comment.MovementId = Movement_Send.Id
                                 AND MovementString_Comment.DescId = zc_MovementString_Comment()
    WHERE Movement_Send.Id = inSendID;
      
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inMovementId, vbComent);

    PERFORM lpInsertUpdate_MovementItem_Loss (ioId                 := COALESCE(MovementItemLoos.Id,0)
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := MovementItemSend.ObjectId
                                            , inAmount             := MovementItemSend.Amount
                                            , inUserId             := vbUserId)
    FROM (SELECT MovementItemSend.ObjectId
               , SUM(MovementItemSend.Amount) AS Amount
          FROM MovementItem AS MovementItemSend
          WHERE MovementItemSend.MovementId = inSendID
            AND MovementItemSend.IsErased = False
            AND MovementItemSend.DescId = zc_MI_Master()
          GROUP BY MovementItemSend.ObjectId) AS MovementItemSend

         LEFT OUTER JOIN MovementItem AS MovementItemLoos
                                      ON MovementItemLoos.MovementId = inMovementId  
                                     AND MovementItemLoos.ObjectId = MovementItemSend.ObjectId 
                                     AND MovementItemLoos.DescId = zc_MI_Master();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.07.19                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_Loss_AddSend (inMovementId:= 1, inOperDate:= NULL);
