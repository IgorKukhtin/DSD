-- Function: gpInsertUpdate_Movement_InfoMoney()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_InfoMoney (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_InfoMoney(
 INOUT ioId                     Integer    , -- ���� ������� <������� ��� ��������� �����>
    IN inParentId               Integer    , -- ���� ������������� ������� <�������� �����>
    IN inInfoMoneyId            Integer    , 
    IN inDescId                 Integer    , -- 
    IN inSession                TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := lpGetUserBySession (inSession);


    -- �������� - ���� ���� �������, �������������� ������
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inParentId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );
    --�������� ����� ��� ������ ���.
    ioId := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_InfoMoney());
    
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    --��������� �������� �� �������� 
    IF NOT EXISTS(SELECT 1 FROM Movement 
                  WHERE Movement.Id = inParentId
                    AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
        RAISE EXCEPTION '������. �������� �� �������� ��� �� ��������� � ��������� <�� ��������>.';
    END IF;
        
    
    -- ��������� <��������>
    SELECT
        lpInsertUpdate_Movement (ioId, zc_Movement_InfoMoney(), Movement_Promo.InvNumber, Movement_Promo.OperDate, inParentId, 0)
    INTO
        ioId
    FROM
        Movement AS Movement_Promo
    WHERE
        Movement_Promo.Id = inParentId;
    
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (inDescId, ioId, inInfoMoneyId);
    -- ��������� ����� � <>
    --PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney_Market(), ioId, inInfoMoneyId_Market);
        
   
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.10.24         *
*/
