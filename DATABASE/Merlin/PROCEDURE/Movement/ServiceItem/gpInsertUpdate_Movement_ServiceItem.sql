-- Function: gpInsertUpdate_Movement_ServiceItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ServiceItem(Integer, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ServiceItem(Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ServiceItem(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inUnitId               Integer   , -- �����
    IN inInfoMoneyId          Integer   , -- ������  
    IN inAmount               TFloat    , -- �����
    IN inPrice                TFloat    , -- ����
    IN inArea                 TFloat    , -- �������
    IN inCommentInfoMoney     TVarChar   , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCommentInfoMoneyId Integer; 
   DECLARE vbUser_isAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������
     vbUser_isAll:= lpCheckUser_isAll (vbUserId);

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
         PERFORM gpUnComplete_Movement_ServiceItem (ioId, inSession);
     END IF;

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_ServiceItem (ioId                 := ioId
                                               , inInvNumber          := inInvNumber
                                               , inOperDate           := inOperDate
                                               , inUnitId             := inUnitId
                                               , inInfoMoneyId        := inInfoMoneyId
                                               , inCommentInfoMoneyId := vbCommentInfoMoneyId
                                               , inAmount             := inAmount
                                               , inPrice              := inPrice
                                               , inArea               := inArea
                                               , inUserId             := vbUserId
                                                );
                                                

     -- 5.3. �������� ��������
     IF 1=1 -- vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_ServiceItem())
     THEN
          PERFORM lpComplete_Movement_ServiceItem (inMovementId := ioId
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