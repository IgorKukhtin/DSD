-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash_Child(Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash_Child(
 INOUT ioId                   Integer   , -- ���� ������� <��������>+
    IN inMI_Id                Integer   , -- ������������� ������
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inServiceDate          TDateTime , -- ���� ����������
    IN inAmount               TFloat    , -- �����
    IN inCashId               Integer   , -- ����� 
    IN inUnitId               Integer   , -- ����� 
    IN inParent_InfoMoneyId   Integer   , -- ������  ������
    IN inInfoMoney            TVarChar   , -- ������ 
    IN inInfoMoneyDetail      TVarChar   , -- ������ 
    IN inCommentInfoMoney     TVarChar   , -- ����������
    IN inKindName             TVarChar   , --������� ������ / ������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbInfoMoneyDetailId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
   
   DECLARE vbAmount TFloat;
   DECLARE vbAmount_master TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inInfoMoney,'') <> ''
     THEN
         --������� �����
         vbInfoMoneyId := (SELECT Object.Id 
                           FROM Object
                                LEFT JOIN ObjectLink AS ObjectLink_Parent
                                                     ON ObjectLink_Parent.ObjectId = Object.Id
                                                    AND ObjectLink_Parent.DescId = zc_ObjectLink_InfoMoney_Parent()
                           WHERE Object.ValueData = TRIM (inInfoMoney) AND Object.DescId = zc_Object_InfoMoney()
                             AND (ObjectLink_Parent.ChildObjectId = inParent_InfoMoneyId OR inParent_InfoMoneyId = 0)
                           );

         IF COALESCE (vbInfoMoneyId,0) = 0
         THEN
             vbInfoMoneyId := gpInsertUpdate_Object_InfoMoney (ioId   := 0
                                                             , inCode := 0
                                                             , inName := TRIM (inInfoMoney)::TVarChar
                                                             , inisService := TRUE
                                                             , inisUserAll := COALESCE ( (SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = inParent_InfoMoneyId AND OB.DescId = zc_ObjectBoolean_InfoMoney_UserAll()), FALSE)
                                                             , inInfoMoneyKindId := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                             , inParentId := inParent_InfoMoneyId
                                                             , inSession := inSession
                                                             );
         END IF;
     END IF;

     IF COALESCE (inInfoMoneyDetail,'') <> ''
     THEN
         -- ������� ����� InfoMoneyDetailId
         vbInfoMoneyDetailId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inInfoMoneyDetail) AND Object.DescId = zc_Object_InfoMoneyDetail());
         IF COALESCE (vbInfoMoneyDetailId,0) = 0
         THEN
             vbInfoMoneyDetailId := gpInsertUpdate_Object_InfoMoneyDetail (ioId   := 0
                                                                         , inCode := 0
                                                                         , inName := TRIM (inInfoMoneyDetail)::TVarChar
                                                                         , inInfoMoneyKindId := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                                         , inSession := inSession
                                                                         );
         END IF;
     END IF;
     
     IF COALESCE (inCommentInfoMoney,'') <> ''
     THEN
         -- ������� ����� CommentInfoMoneyId
         vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inCommentInfoMoney) AND Object.DescId = zc_Object_CommentInfoMoney());
         IF COALESCE (vbCommentInfoMoneyId,0) = 0
         THEN
             vbCommentInfoMoneyId := gpInsertUpdate_Object_CommentInfoMoney (ioId   := 0
                                                                           , inCode := 0
                                                                           , inName := TRIM (inCommentInfoMoney)::TVarChar
                                                                           , inInfoMoneyKindId := 0
                                                                           , inSession := inSession
                                                                           );
         END IF;
     END IF;
                                                          
     
     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_Cash_Child (ioId                   := ioId
                                              , inMI_Id                := inMI_Id
                                              , inInvNumber            := inInvNumber
                                              , inOperDate             := inOperDate
                                              , inServiceDate          := inServiceDate
                                              , inAmount               := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN inAmount ELSE inAmount * (-1) END ::TFloat
                                              , inCashId               := inCashId
                                              , inUnitId               := inUnitId
                                              , inInfoMoneyId          := vbInfoMoneyId
                                              , inInfoMoneyDetailId    := vbInfoMoneyDetailId
                                              , inCommentInfoMoneyId   := vbCommentInfoMoneyId
                                              , inUserId               := vbUserId
                                               );
                                                
     -- �������� ����������� �� ���� ��������
     vbAmount_master := (SELECT SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 ELSE 1 END * MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE);
     vbAmount        := (SELECT SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 ELSE 1 END * MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE);
     
     --RAISE EXCEPTION '������. <%>  -  <%> .', vbAmount_master, vbAmount;
     
     IF vbAmount_master <> 0 AND vbAmount = vbAmount_master
     THEN
     
         PERFORM gpInsertUpdate_MI_Cash_Sign (inMovementId := ioId
                                            , inAmount     := vbAmount_master
                                            , inSession    := inSession
                                             );
     END IF;
     


     -- 5.3. �������� ��������
     /*IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash())
     THEN
          PERFORM lpComplete_Movement_Cash (inMovementId := ioId
                                             , inUserId     := vbUserId);
     END IF;
*/
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