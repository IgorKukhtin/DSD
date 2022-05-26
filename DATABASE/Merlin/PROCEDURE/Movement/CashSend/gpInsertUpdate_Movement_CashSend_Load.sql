--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CashSend_Load (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_CashSend_Load(
    IN inFromKassaCode        Integer,       -- ���
    IN inToKassaCode          Integer,
    IN inCommentMoveMoneyCode Integer,
    IN inUserId               Integer,       -- Id ������������
    IN inSummaFrom            TFloat,        --
    IN inSummaTo              TFloat,        --
    IN inKurs                 TFloat,        --
    IN inNominalKurs          TFloat,        --
    IN inInvNumber            TVarChar,      --  
    IN inOperDate             TDateTime,     -- 
    IN inProtocolDate         TDateTime,     -- ���� ���������
    IN inSession              TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbCommentMoveMoneyId Integer;
  DECLARE vbFromKassaId      Integer;
  DECLARE vbToKassaId        Integer;
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
   IF 1 < (SELECT COUNT(*) FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_CashSend() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
       RAISE EXCEPTION '������.������� ��������� inInvNumber = <%>', inInvNumber;
   END IF;

   -- �����
   vbMovementId:= (SELECT Movement.Id FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_CashSend() AND Movement.StatusId <> zc_Enum_Status_Erased());
   -- �����
   vbMovementItemId := (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = vbMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE);

   -- ���� ��������
   IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = vbMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
   THEN
       -- ����������
       PERFORM lpUnComplete_Movement (vbMovementId, vbUserId);
   END IF;
   
   -- ����������
   IF COALESCE (inInvNumber,'') <> '' -- AND NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_CashSend() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
       
       IF COALESCE (inCommentMoveMoneyCode,0) <> 0
       THEN
           -- ����� � ���. 
           vbCommentMoveMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CommentMoveMoney() AND Object.ObjectCode = inCommentMoveMoneyCode);
    
           -- E��� �� ����� ������
           IF COALESCE (vbCommentMoveMoneyId,0) = 0
           THEN
               RAISE EXCEPTION '������.�� ������ ������� ����������� ���������� �������� ����� � ����� <%>   .', inCommentMoveMoneyCode;
           END IF;
       END IF;
    
       IF COALESCE (inFromKassaCode,0) <> 0
       THEN
           -- ����� � ���.
           vbFromKassaId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND Object.ObjectCode = inFromKassaCode);
    
           -- E��� �� ����� ������
           IF COALESCE (vbFromKassaId,0) = 0
           THEN
               RAISE EXCEPTION '������.�� ������ ������� ����������� ����� � ����� <%>   .', inFromKassaCode;
           END IF;
       END IF;
    
       IF COALESCE (inToKassaCode,0) <> 0
       THEN
           -- ����� � ���.
           vbToKassaId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND Object.ObjectCode = inToKassaCode);
    
           -- E��� �� ����� ������
           IF COALESCE (vbToKassaId,0) = 0
           THEN
               RAISE EXCEPTION '������.�� ������ ������� ����������� ����� � ����� <%>   .', inToKassaCode;
           END IF;
       END IF; 
       
           -- ��������� <��������>
         vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_CashSend(), inInvNumber, inOperDate, Null, vbUserProtocolId);
    
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), vbMovementId, inKurs);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), vbMovementId, inNominalKurs);
    
         -- ��������� <������� ���������>
         vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbFromKassaId, vbMovementId, inSummaFrom, NULL);
    
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Cash(), vbMovementItemId, vbToKassaId);
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentMoveMoney(), vbMovementItemId, vbCommentMoveMoneyId);
          
          -- ��������� �������� <���� ��������>
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbMovementId, inProtocolDate ::TDateTime);
          -- ��������� �������� <������������ (��������)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), vbMovementId, vbUserProtocolId);

          -- ��������
          PERFORM lpComplete_Movement_CashSend (vbMovementId  -- ���� ���������
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
 04.02.21          *
*/

-- ����
--