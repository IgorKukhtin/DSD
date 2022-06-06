-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash(Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inMI_Id                Integer   , -- ������������� ������
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inServiceDate          TDateTime , -- ���� ����������
    IN inAmount               TFloat    , -- �����
    IN inCashId               Integer   , -- ����� 
    IN inUnitId               Integer   , -- ����� 
    IN inParent_InfoMoneyId   Integer   , -- ������  ������
    IN inInfoMoneyName        TVarChar  , -- ������ 
    IN inInfoMoneyDetailName  TVarChar  , -- ������ 
    IN inCommentInfoMoney     TVarChar  , -- ����������
    IN inKindName             TVarChar  , -- ������� ������ / ������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUser_isAll Boolean;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbInfoMoneyDetailId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

     -- �������� - ���� ������������� ������������
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = ioId AND MI.DescId = zc_MI_Sign() AND MI.isErased = FALSE)
     THEN
        RAISE EXCEPTION '������.������������� ������������.��������� ����������.';
     END IF;



     IF COALESCE (inInfoMoneyName,'') <> ''
     THEN
         -- ��������
         IF 1 < (SELECT COUNT(*)
                 FROM Object
                      LEFT JOIN ObjectLink AS ObjectLink_Parent
                                           ON ObjectLink_Parent.ObjectId = Object.Id
                                          AND ObjectLink_Parent.DescId   = zc_ObjectLink_InfoMoney_Parent()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                              ON ObjectBoolean_UserAll.ObjectId = Object.Id
                                             AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_InfoMoney_UserAll()
                 WHERE Object.ValueData = TRIM (inInfoMoneyName)
                   AND Object.DescId    = zc_Object_InfoMoney()
                   AND (COALESCE (ObjectLink_Parent.ChildObjectId, 0) = COALESCE (inParent_InfoMoneyId, 0))
                   AND Object.isErased = FALSE
                   AND (ObjectBoolean_UserAll.ValueData = TRUE OR vbUser_isAll = TRUE)
                   AND 1=0
                )
         THEN
             RAISE EXCEPTION '������.������� ������ � ���������� ��������� <%> <%>.', inInfoMoneyName, lfGet_Object_ValueData_sh (inParent_InfoMoneyId);
         END IF;
         
         -- ������� �����
         vbInfoMoneyId := (SELECT Object.Id 
                           FROM Object
                                LEFT JOIN ObjectLink AS ObjectLink_Parent
                                                     ON ObjectLink_Parent.ObjectId = Object.Id
                                                    AND ObjectLink_Parent.DescId   = zc_ObjectLink_InfoMoney_Parent()
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                                        ON ObjectBoolean_UserAll.ObjectId = Object.Id
                                                       AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_InfoMoney_UserAll()
                           WHERE Object.ValueData = TRIM (inInfoMoneyName)
                             AND Object.DescId    = zc_Object_InfoMoney()
                             AND (COALESCE (ObjectLink_Parent.ChildObjectId, 0) = COALESCE (inParent_InfoMoneyId, 0))
                             AND Object.isErased = FALSE
                             AND (ObjectBoolean_UserAll.ValueData = TRUE OR vbUser_isAll = TRUE)
                           ORDER BY 1 ASC
                           LIMIT 1
                          );

         IF COALESCE (vbInfoMoneyId,0) = 0
         THEN
             vbInfoMoneyId := gpInsertUpdate_Object_InfoMoney (ioId             := 0
                                                             , inCode           := 0
                                                             , inName           := TRIM (inInfoMoneyName)::TVarChar
                                                             , inInfoMoneyKindId:= CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                             , inParentId       := inParent_InfoMoneyId
                                                             , inSession        := inSession
                                                             );
             -- ���������
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_Service(), vbInfoMoneyId, FALSE);
             -- ���������
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoney_UserAll(), vbInfoMoneyId, NOT vbUser_isAll);

         END IF;
     END IF;

     IF COALESCE (inInfoMoneyDetailName,'') <> ''
     THEN
         -- ��������
         IF 1 < (SELECT COUNT(*)
                 FROM Object
                 WHERE Object.ValueData = TRIM (inInfoMoneyDetailName) AND Object.DescId = zc_Object_InfoMoneyDetail()
                  AND Object.isErased = FALSE
                  AND 1=0
                )
         THEN
             RAISE EXCEPTION '������.������� ������ �������� � ���������� ��������� <%>.', inInfoMoneyDetailName;
         END IF;

         -- ������� ����� InfoMoneyDetailId
         vbInfoMoneyDetailId := (SELECT Object.Id
                                 FROM Object
                                 WHERE Object.ValueData = TRIM (inInfoMoneyDetailName)
                                   AND Object.DescId = zc_Object_InfoMoneyDetail()
                                   AND Object.isErased = FALSE
                                 ORDER BY 1 ASC
                                 LIMIT 1
                                );
         IF COALESCE (vbInfoMoneyDetailId,0) = 0
         THEN
             vbInfoMoneyDetailId := gpInsertUpdate_Object_InfoMoneyDetail (ioId   := 0
                                                                         , inCode := 0
                                                                         , inName := TRIM (inInfoMoneyDetailName)::TVarChar
                                                                         , inInfoMoneyKindId := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                                         , inSession := inSession
                                                                          );
             -- ���������
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_InfoMoneyDetail_UserAll(), vbInfoMoneyDetailId, NOT vbUser_isAll);

         END IF;

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
             vbCommentInfoMoneyId := gpInsertUpdate_Object_CommentInfoMoney (ioId             := 0
                                                                           , inCode           := 0
                                                                           , inName           := TRIM (inCommentInfoMoney)::TVarChar
                                                                           , inInfoMoneyKindId:= CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN zc_Enum_InfoMoney_In() ELSE zc_Enum_InfoMoney_Out() END
                                                                           , inSession        := inSession
                                                                           );
             -- ���������
             PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentInfoMoney_UserAll(), vbCommentInfoMoneyId, NOT vbUser_isAll);

         END IF;
     END IF;
                                                          
     
     -- ���� ��������
     IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- ����������
         PERFORM lpUnComplete_Movement (ioId, vbUserId);
     END IF;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_Cash (ioId                   := ioId
                                        , inMI_Id                := inMI_Id
                                        , inInvNumber            := inInvNumber
                                        , inOperDate             := inOperDate
                                        , inServiceDate          := inServiceDate
                                        , inAmount               := CASE WHEN inKindName = 'zc_Enum_InfoMoney_In' THEN inAmount ELSE -1 * inAmount END ::TFloat
                                        , inCashId               := inCashId
                                        , inUnitId               := inUnitId
                                        , inInfoMoneyId          := vbInfoMoneyId
                                        , inInfoMoneyDetailId    := vbInfoMoneyDetailId
                                        , inCommentInfoMoneyId   := vbCommentInfoMoneyId
                                        , inUserId               := vbUserId
                                         );
                                                
     -- �������� ��������
     IF 1=1 -- vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Service())
     THEN
         PERFORM lpComplete_Movement_Cash (inMovementId := ioId
                                         , inUserId     := vbUserId
                                          );
     END IF;

IF vbUserId = zfCalc_UserAdmin() :: Integer
THEN
    RAISE EXCEPTION '������.test summa = <%>', inAmount;
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