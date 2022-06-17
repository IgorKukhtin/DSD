-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Cash_CommentInfoMoney(Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Cash_CommentInfoMoney(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inKindName             TVarChar  , -- ������� ������ / ������
    IN inCommentInfoMoney     TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbMovementItemId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Cash_CommentInfoMoney());
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


     IF COALESCE (inCommentInfoMoney,'') <> ''
     THEN
         -- ��������
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ValueData = TRIM (inCommentInfoMoney) AND Object.DescId = zc_Object_CommentInfoMoney() AND Object.isErased = FALSE AND 1=0)
         THEN
             RAISE EXCEPTION '������.������� ���������� � ���������� ��������� <%>.', inCommentInfoMoney;
         END IF;

         -- ������� ����� CommentInfoMoneyId
         vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inCommentInfoMoney) AND Object.DescId = zc_Object_CommentInfoMoney() AND Object.isErased = FALSE ORDER BY 1 ASC LIMIT 1);
         IF COALESCE (vbCommentInfoMoneyId,0) = 0
         THEN
             vbCommentInfoMoneyId := gpInsertUpdate_Object_CommentInfoMoney (inId             := 0
                                                                           , inCode           := 0
                                                                           , inName           := TRIM (inCommentInfoMoney)::TVarChar
                                                                           , inInfoMoneyKindId:= CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                                           , inSession        := inSession
                                                                           );
             -- ���������
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentInfoMoney_UserAll(), vbCommentInfoMoneyId, NOT vbUser_isAll);

         END IF;
     END IF;
                                                          
     
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), vbMovementItemId, vbCommentInfoMoneyId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, FALSE);

     
IF vbUserId = zfCalc_UserAdmin() :: Integer
THEN
    RAISE EXCEPTION '������.test summa = <%>', vbCommentInfoMoneyId;
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