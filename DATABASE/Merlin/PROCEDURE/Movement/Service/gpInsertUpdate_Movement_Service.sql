-- Function: gpInsertUpdate_Movement_Service()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service(Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Service(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inServiceDate          TDateTime , -- ���� ����������
    IN inAmount               TFloat    , -- �����
    IN inUnitId               Integer   , -- ����� 
    IN inParent_InfoMoneyId   Integer   , -- ������  ������
    IN inInfoMoneyName        TVarChar  , -- ������ 
    IN inCommentInfoMoney     TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUser_isAll Boolean;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbCommentInfoMoneyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Service());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

     IF COALESCE (inInfoMoneyName,'') <> ''
     THEN
         --������� �����
         vbInfoMoneyId := (SELECT Object.Id 
                           FROM Object
                                LEFT JOIN ObjectLink AS ObjectLink_Parent
                                                     ON ObjectLink_Parent.ObjectId = Object.Id
                                                    AND ObjectLink_Parent.DescId = zc_ObjectLink_InfoMoney_Parent()
                           WHERE Object.ValueData = TRIM (inInfoMoneyName) AND Object.DescId = zc_Object_InfoMoney()
                             AND (ObjectLink_Parent.ChildObjectId = inParent_InfoMoneyId OR inParent_InfoMoneyId = 0)
                             AND Object.isErased = FALSE
                           ORDER BY 1 ASC
                           LIMIT 1
                          );

         IF COALESCE (vbInfoMoneyId,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ���������� ������.';
             --
             vbInfoMoneyId := gpInsertUpdate_Object_InfoMoney (ioId   := 0
                                                             , inCode := 0
                                                             , inName := TRIM (inInfoMoneyName)::TVarChar
                                                             , inInfoMoneyNameKindId := COALESCE ( (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inParent_InfoMoneyId AND OL.DescId = zc_ObjectLink_InfoMoney_InfoMoneyKind()), NULL) 
                                                             , inParentId := inParent_InfoMoneyId
                                                             , inSession := inSession
                                                             );
         END IF;
     END IF;

     IF COALESCE (inCommentInfoMoney,'') <> ''
     THEN
         -- ������� ����� CommentInfoMoneyId
         vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inCommentInfoMoney) AND Object.DescId = zc_Object_CommentInfoMoney() ORDER BY 1 ASC LIMIT 1);
         --
         IF COALESCE (vbCommentInfoMoneyId,0) = 0
         THEN
             vbCommentInfoMoneyId := gpInsertUpdate_Object_CommentInfoMoney (ioId   := 0
                                                                           , inCode := 0
                                                                           , inName := TRIM (inCommentInfoMoney)::TVarChar
                                                                           , inInfoMoneyNameKindId := 0
                                                                           , inSession := inSession
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
     ioId:= lpInsertUpdate_Movement_Service (ioId                   := ioId
                                           , inInvNumber            := inInvNumber
                                           , inOperDate             := inOperDate
                                           , inServiceDate          := DATE_TRUNC ('MONTH', inServiceDate) ::TDateTime   --inServiceDate
                                           , inAmount               := inAmount
                                           , inUnitId               := inUnitId
                                           , inInfoMoneyId          := vbInfoMoneyId
                                           , inCommentInfoMoneyId   := vbCommentInfoMoneyId
                                           , inUserId               := vbUserId
                                            );

     -- 5.3. �������� ��������
     IF 1=1 -- vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Service())
     THEN
          PERFORM lpComplete_Movement_Service (inMovementId := ioId
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