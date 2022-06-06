-- Function: gpInsertUpdate_Movement_CashSend()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CashSend(Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CashSend(Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_CashSend(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inCurrencyValue        TFloat    , -- ����
    IN inParValue             TFloat    , -- �������
    IN inAmountOut            TFloat    , -- ����� (������)
    IN inAmountIn             TFloat    , -- ����� (������)
    IN inCashId_from          Integer   , -- ����� (������) 
    IN inCashId_to            Integer   , -- ����� (������) 
    IN inCommentMoveMoney     TVarChar  , -- ���������� �������� �����
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUser_isAll Boolean;
   DECLARE vbCommentMoveMoneyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CashSend());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);
     
     IF COALESCE (inCommentMoveMoney,'') <> ''
     THEN
         -- ������� ����� CommentMoveMoneyId
         vbCommentMoveMoneyId := (SELECT Object.Id
                                  FROM Object
                                       LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                                               ON ObjectBoolean_UserAll.ObjectId = Object.Id
                                                              AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_InfoMoney_UserAll()
                                  WHERE Object.ValueData = TRIM (inCommentMoveMoney)
                                    AND Object.DescId = zc_Object_CommentMoveMoney()
                                    AND (ObjectBoolean_UserAll.ValueData = TRUE OR vbUser_isAll = TRUE)
                                  ORDER BY 1 ASC
                                  LIMIT 1
                                 );
         IF COALESCE (vbCommentMoveMoneyId,0) = 0
         THEN
             vbCommentMoveMoneyId := gpInsertUpdate_Object_CommentMoveMoney (ioId   := 0
                                                                           , inCode := 0
                                                                           , inName := TRIM (inCommentMoveMoney)::TVarChar
                                                                           , inSession := inSession
                                                                           );
             -- ���������
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentMoveMoney_UserAll(), vbCommentMoveMoneyId, NOT vbUser_isAll);
         END IF;
     END IF;
                                                          
     
       -- ���� ��������
     IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- ����������
         PERFORM lpUnComplete_Movement (ioId, vbUserId);
     END IF;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_CashSend (ioId                   := ioId
                                            , inInvNumber            := inInvNumber
                                            , inOperDate             := inOperDate
                                            , inCurrencyValue        := inCurrencyValue
                                            , inParValue             := inParValue
                                            , inAmountOut            := inAmountOut
                                            , inAmountIn             := inAmountIn
                                            , inCashId_from          := inCashId_from
                                            , inCashId_to            := inCashId_to
                                            , inCommentMoveMoneyId   := vbCommentMoveMoneyId
                                            , inUserId               := vbUserId
                                             );
                                                

     -- 5.3. �������� ��������
     IF 1=1 -- vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Service())
     THEN
         PERFORM lpComplete_Movement_CashSend (inMovementId := ioId
                                             , inUserId     := vbUserId
                                              );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.01.22         *
 */

-- ����
--