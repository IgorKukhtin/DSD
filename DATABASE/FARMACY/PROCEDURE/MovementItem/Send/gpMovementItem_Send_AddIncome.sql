-- Function: gpMovementItem_Send_AddIncome

DROP FUNCTION IF EXISTS gpMovementItem_Send_AddIncome (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Send_AddIncome(
    IN inMovementId       Integer,  -- �����������
    IN inIncomeId         Integer,  -- ������
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

    SELECT Format('������ %s �� %s ���-�� %s ����� %s ���������� %s'      
           , Movement_Income.InvNumber
           , TO_CHAR (Movement_Income.OperDate, 'dd.mm.yyyy')
           , MovementFloat_TotalCount.ValueData
           , MovementFloat_TotalSumm.ValueData
           , COALESCE (MovementString_Comment.ValueData , ''))
    INTO  vbComent

    FROM Movement AS Movement_Income
              
         LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                 ON MovementFloat_TotalCount.MovementId = Movement_Income.Id
                                AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
   
         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

         LEFT JOIN MovementString AS MovementString_Comment
                                  ON MovementString_Comment.MovementId = Movement_Income.Id
                                 AND MovementString_Comment.DescId = zc_MovementString_Comment()
    WHERE Movement_Income.Id = inIncomeID;
      
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inMovementId, vbComent);

    PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := COALESCE(MovementItemSend.Id,0)
                                            , inMovementId          := inMovementId
                                            , inGoodsId             := MovementItemIncome.ObjectId
                                            , inAmount              := MovementItemIncome.Amount
                                            , inAmountManual        := MovementItemIncome.Amount
                                            , inAmountStorage       := MovementItemIncome.Amount
                                            , inReasonDifferencesId := 0
                                            , inCommentSendID       := 0
                                            , inUserId              := vbUserId)
    FROM (SELECT MovementItemIncome.ObjectId
               , SUM(MovementItemIncome.Amount) AS Amount
          FROM MovementItem AS MovementItemIncome
          WHERE MovementItemIncome.MovementId = inIncomeID
            AND MovementItemIncome.IsErased = False
            AND MovementItemIncome.DescId = zc_MI_Master()
          GROUP BY MovementItemIncome.ObjectId) AS MovementItemIncome

         LEFT OUTER JOIN MovementItem AS MovementItemSend
                                      ON MovementItemSend.MovementId = inMovementId  
                                     AND MovementItemSend.ObjectId = MovementItemIncome.ObjectId 
                                     AND MovementItemSend.DescId = zc_MI_Master();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.11.20                                                       *
*/

-- ����
-- select * from gpMovementItem_Send_AddIncome(inMovementId := 20962126 , inIncomeId := 20948692 ,  inSession := '3');
