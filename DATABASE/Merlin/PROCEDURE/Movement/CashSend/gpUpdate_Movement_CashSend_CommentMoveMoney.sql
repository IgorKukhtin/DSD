-- Function: gpUpdate_Movement_CashSend_CommentMoveMoney()

DROP FUNCTION IF EXISTS gpUpdate_Movement_CashSend_CommentMoveMoney(Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_CashSend_CommentMoveMoney(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inKindName             TVarChar  , -- ������� ������ / ������
    IN inCommentMoveMoney     TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbMovementItemId Integer;
   DECLARE vbCommentMoveMoneyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_CashSend_CommentMoveMoney());
     --vbUserId:= lpGetUserBySession (inSession);

     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();
     
     -- ������
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

     -- �������� -
     IF COALESCE (inMI_Id,0) = 0 
     THEN
        RAISE EXCEPTION '������.������������� �� ���������.';
     END IF;


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
     
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentMoveMoney(), vbMovementItemId, inCommentMoveMoneyId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, FALSE);

     
IF vbUserId = zfCalc_UserAdmin() :: Integer
THEN
    RAISE EXCEPTION '������.test summa = <%>', vbCommentMoveMoneyId;
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.06.22         *
 */

-- ����
--