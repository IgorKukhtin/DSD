-- Function: gpInsertUpdate_MI_PersonalService_Message()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Message (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Message (Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Message(
 INOUT ioId                  Integer   , -- 
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   ,
    IN inIsQuestion          Boolean   ,
    IN inIsAnswer            Boolean   ,
    IN inIsQuestionRead      Boolean   ,
    IN inIsAnswerRead        Boolean   ,
    IN inComment             TVarChar  ,
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbIsInsert Boolean;
  DECLARE vbAmount   TFloat;
  DECLARE vbAmountOld TFloat;
  DECLARE vbIsQuestionRead   Boolean;
  DECLARE vbIsAnswerRead     Boolean;
BEGIN
     
     -- 
     -- �������� ���� ������������ �� ����� ���������
     --lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := inSession;
     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
 
     vbAmount := (CASE WHEN inIsQuestion     = TRUE THEN 1
                       WHEN inIsAnswer       = TRUE THEN 2
                       WHEN inIsQuestionRead = TRUE THEN 3
                       WHEN inIsAnswerRead   = TRUE THEN 4
                       ELSE 0
                  END);
     
     vbAmountOld := (SELECT MovementItem.Amount
                     FROM MovementItem
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.Id = ioId
                     );

     -- ��������� <������� ���������>
     ioId:= lpInsertUpdate_MovementItem (ioId, zc_MI_Message(), inUserId, inMovementId, vbAmount, NULL);
   
       -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, vbUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;

     IF (vbAmountOld <> vbAmount AND vbAmount IN (3, 4)
     THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, CURRENT_TIMESTAMP);
     END IF;


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.  ���������� �.�.
 20.09.17         *
*/

-- ����
--select * from gpInsertUpdate_MI_PersonalService_Message(ioId := 0 , inMovementId := 5285316 , inUserId := 0 , inisQuestion := 'False' , inisAnswer := 'False' , inisQuestionRead := 'False' , inisAnswerRead := 'False' , inComment := '������������' ,  inSession := '5');