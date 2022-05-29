--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service_Load (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Service_Load(
    IN inCommentInfoMoneyCode Integer,       -- ���
    IN inInfoMoneyCode        Integer,
    IN inUnitCode             Integer,
    IN inUserId               Integer,       -- Id ������������
    IN inSumma                TFloat,        --
    IN inInvNumber            TVarChar,      --  
    IN inisAuto               TVarChar,      -- 
    IN inOperDate             TDateTime,     -- 
    IN inServiceDate          TDateTime,     -- 
    IN inProtocolDate         TDateTime,     -- ���� ���������
    IN inSession              TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbCommentInfoMoneyId Integer;
  DECLARE vbInfoMoneyId      Integer;
  DECLARE vbUnitId           Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   vbUserProtocolId := CASE WHEN inUserId = 1 THEN 5
                            WHEN inUserId = 6 THEN 139  -- zfCalc_UserMain_1()
                            WHEN inUserId = 7 THEN 2020 -- zfCalc_UserMain_2()
                            WHEN inUserId = 10 THEN 40561
                            WHEN inUserId = 11 THEN 40562
                       END;


   -- ��������
   IF 1 < (SELECT COUNT(*) FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Service() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
       RAISE EXCEPTION '������.������� ��������� inInvNumber = <%>', inInvNumber;
   END IF;

   -- �����
   vbMovementId:= (SELECT Movement.Id FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Service() AND Movement.StatusId <> zc_Enum_Status_Erased());
   -- �����
   vbMovementItemId := (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = vbMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE);

   -- ���� ��������
   IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = vbMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
   THEN
       -- ����������
       PERFORM lpUnComplete_Movement (vbMovementId, vbUserId);
   END IF;
   
   -- ����������
   IF COALESCE (inInvNumber,'') <> '' --AND NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Service() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
       
       IF COALESCE (inCommentInfoMoneyCode,0) <> 0
       THEN
           -- ����� � ���. 
           vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CommentInfoMoney() AND Object.ObjectCode = inCommentInfoMoneyCode);
    
           -- E��� �� ����� ������
           IF COALESCE (vbCommentInfoMoneyId,0) = 0
           THEN
               RAISE EXCEPTION '������.�� ������ ������� ����������� ���������� ������/������ � ����� <%>   .', inCommentInfoMoneyCode;
           END IF;
       END IF;
    
       IF COALESCE (inInfoMoneyCode,0) <> 0
       THEN
           -- ����� � ���.
           vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.ObjectCode = inInfoMoneyCode);
    
           -- E��� �� ����� ������
           IF COALESCE (vbInfoMoneyId,0) = 0
           THEN
               RAISE EXCEPTION '������.�� ������ ������� ����������� ������ ������/������ � ����� <%>   .', inInfoMoneyCode;
           END IF;
       END IF;
    
       IF COALESCE (inUnitCode,0) <> 0
       THEN
           -- ����� � ���.
           vbUnitId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.ObjectCode = inUnitCode);
    
           -- E��� �� ����� ������
           IF COALESCE (vbUnitId,0) = 0
           THEN
               RAISE EXCEPTION '������.�� ������ ������� ����������� ������ � ����� <%>   .', inUnitCode;
           END IF;
       END IF;
          -- ��������� <��������>
          vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_Service(), inInvNumber, inOperDate, Null, vbUserProtocolId);
     
          ---
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, CASE WHEN inisAuto = '��' THEN TRUE ELSE FALSE END);

          -- ��������� <������� ���������>
          vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbUnitId, vbMovementId, inSumma, NULL);
     
          -- ��������� ����� � <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, vbInfoMoneyId);
          -- ��������� ����� � <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), vbMovementItemId, vbCommentInfoMoneyId);
     
          -- ��������� �������� <���� ����������>
          PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, inServiceDate);
     
          -- ��������� �������� <���� ��������>
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbMovementId, inProtocolDate ::TDateTime);
          -- ��������� �������� <������������ (��������)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), vbMovementId, vbUserProtocolId);

          -- ��������
          PERFORM lpComplete_Movement_Service (vbMovementId  -- ���� ���������
                                             , vbUserId      -- ������������
                                              );
 END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.02.21          *
*/

-- ����
--