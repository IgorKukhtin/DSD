--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash_Load (Integer, Integer, Integer, Integer, Integer, Integer
                                                         , TFloat, TVarChar, TVarChar, TVarChar
                                                         , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash_Load (Integer, Integer, Integer, Integer, Integer, Integer
                                                         , TFloat, TVarChar, Integer, TVarChar, TVarChar
                                                         , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash_Load (Integer, Integer, Integer, Integer, Integer, Integer
                                                         , TFloat, TVarChar, TVarChar, TVarChar
                                                         , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Integer, TVarChar);
CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash_Load(
    IN inKassaCode            Integer,       -- ���
    IN inInfoMoneyCode        Integer,
    IN inInfoMoneyAddCode     Integer,
    IN inUnitCode             Integer,
    IN inCommentInfoMoneyCode Integer,
    IN inUserId               Integer,       -- Id ������������
    IN inSumma                TFloat,        --
    IN inInvNumber            TVarChar,      --  
    IN inisProtocolTim        TVarChar,      --  
    IN inisProtocolEvg        TVarChar,      --  
    IN inOperDate             TDateTime,     -- 
    IN inProtocolDate         TDateTime,     -- ���� ���������
    IN inDateAdditional       TDateTime,     -- 
    IN inProtocolTim          TDateTime,     -- 
    IN inProtocolEvg          TDateTime,     -- 
--    IN inInvNumber_ch         Integer,      --  
    IN inSession              TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbCommentInfoMoneyId Integer;
  DECLARE vbKassaId            Integer;
  DECLARE vbInfoMoneyId        Integer;
  DECLARE vbInfoMoneyDetailId  Integer;
  DECLARE vbUnitId             Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbMovementItemId_sign   Integer;
--  DECLARE inInvNumber_ch         Integer;
BEGIN

-- inInvNumber_ch:= inInvNumber;


   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   vbUserProtocolId := CASE WHEN inUserId = 1  THEN 5
                            WHEN inUserId = 6  THEN 139   -- zfCalc_UserMain_1() - Evg
                            WHEN inUserId = 7  THEN 2020  -- zfCalc_UserMain_2() - Tim
                            WHEN inUserId = 8  THEN 104840-- zfCalc_UserMain_3() - El
                            WHEN inUserId = 10 THEN 40561 -- Bushenko
                            WHEN inUserId = 11 THEN 40562 -- Filippova
                       END;

   -- ��������
   IF 1 < (SELECT COUNT(*) FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Cash() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
       RAISE EXCEPTION '������.������� ��������� inInvNumber = <%>', inInvNumber;
   END IF;

   -- �����
   vbMovementId:= (SELECT Movement.Id FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Cash() AND Movement.StatusId <> zc_Enum_Status_Erased());
   -- �����
   vbMovementItemId := 0/*(SELECT MI.Id
                        FROM MovementItem AS MI 
                             LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id
                                                               AND MIF.DescId         = zc_MIFloat_MovementId()
                        WHERE MI.MovementId = vbMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                          AND COALESCE (MIF.ValueData, 0) = CASE WHEN inInvNumber = inInvNumber_ch THEN 0 ELSE inInvNumber_ch END
                       )*/;

   -- ���� ��������
   IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = vbMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
   THEN
       -- ����������
       PERFORM lpUnComplete_Movement (vbMovementId, vbUserId);
   END IF;
   
   -- ����������
   IF COALESCE (inInvNumber,'') <> '' -- AND NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.InvNumber = TRIM (inInvNumber) AND Movement.DescId = zc_Movement_Cash() AND Movement.StatusId <> zc_Enum_Status_Erased())
   THEN
       
       IF COALESCE (inCommentInfoMoneyCode,0) <> 0
       THEN
           -- �����
           vbCommentInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CommentInfoMoney() AND Object.ObjectCode = inCommentInfoMoneyCode);
    
           -- E��� �� ����� ������
           IF COALESCE (vbCommentInfoMoneyId,0) = 0
           THEN
               RAISE EXCEPTION '������.�� ������ ������� ����������� ���������� ������ / ������ <%>   .', inCommentInfoMoneyCode;
           END IF;

       END IF;
    
       IF COALESCE (inKassaCode,0) <> 0
       THEN
           -- ����� � ���.
           vbKassaId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND Object.ObjectCode = inKassaCode);
    
           -- E��� �� ����� ������
           IF COALESCE (vbKassaId,0) = 0
           THEN
               RAISE EXCEPTION '������.�� ������ ������� ����������� ����� � ����� <%>   .', inKassaCode;
           END IF;
       END IF;
    
       IF COALESCE (inInfoMoneyCode,0) <> 0
       THEN
           -- ����� � ���.
           vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.ObjectCode = inInfoMoneyCode);
    
           -- E��� �� ����� ������
           IF COALESCE (vbInfoMoneyId,0) = 0
           THEN
               RAISE EXCEPTION '������.�� ������ ������� ����������� ������ � ����� <%>   .', inInfoMoneyCode;
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

       IF COALESCE (inInfoMoneyAddCode,0) <> 0
       THEN
           -- ����� � ���.
           vbInfoMoneyDetailId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoneyDetail() AND Object.ObjectCode = inInfoMoneyAddCode);
    
           -- E��� �� ����� ������
           IF COALESCE (vbInfoMoneyDetailId,0) = 0
           THEN
               RAISE EXCEPTION '������.�� ������ ������� ����������� �������� ������/������ � ����� <%>   .', inInfoMoneyAddCode;
           END IF;
       END IF; 

    
          -- ��������� <��������>
          vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_Cash(), inInvNumber, inOperDate, Null, vbUserProtocolId);
     
          -- ��������� <������� ���������>
          vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbKassaId, vbMovementId, inSumma, NULL);
     
          -- ��������� ��������
          /*IF inInvNumber_ch <> inInvNumber
          THEN
              PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), vbMovementItemId, inInvNumber_ch);
          END IF;*/

          -- ��������� ����� � <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, vbUnitId);
          -- ��������� ����� � <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, vbInfoMoneyId);
          -- ��������� ����� � <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoneyDetail(), vbMovementItemId, vbInfoMoneyDetailId);
          -- ��������� ����� � <>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), vbMovementItemId, vbCommentInfoMoneyId);
     
          -- ��������� �������� <���� ����������>
          PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, DATE_TRUNC ('MONTH', inDateAdditional));
          
          -- ��������� �������� <���� ��������>
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbMovementId, inProtocolDate ::TDateTime);
          -- ��������� �������� <������������ (��������)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), vbMovementId, vbUserProtocolId);


          -- Sign
          IF COALESCE (inisProtocolTim,'') = '��' AND COALESCE (inisProtocolEvg,'') = '��'
          THEN
              PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign(), vbMovementId, TRUE);
              PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Child(), vbMovementItemId, TRUE);
          ELSE
              PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Child(), vbMovementItemId, FALSE);
          END IF;    

           IF COALESCE (inisProtocolEvg,'') = '��' 
           THEN
               vbMovementItemId_sign := lpInsertUpdate_MovementItem (0, zc_MI_Sign(), 139, vbMovementId, inSumma, NULL); -- zfCalc_UserMain_1()
               -- ��������� �������� <���� ��������>
               PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMovementItemId_sign, inProtocolEvg);
           END IF;

           IF COALESCE (inisProtocolTim,'') = '��' 
           THEN
               vbMovementItemId_sign := lpInsertUpdate_MovementItem (0, zc_MI_Sign(), 2020, vbMovementId, inSumma, NULL); -- zfCalc_UserMain_2()
               -- ��������� �������� <���� ��������>
               PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMovementItemId_sign, inProtocolTim);
           END IF;

  
           -- ��������
           PERFORM lpComplete_Movement_Cash (vbMovementId  -- ���� ���������
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
 07.02.21          *
*/

-- ����
--