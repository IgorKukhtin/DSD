-- Function: lpInsertUpdate_Movement_CompetitorMarkups()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_CompetitorMarkups (Integer, TVarChar, TDateTime, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_CompetitorMarkups(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inUserId                Integer      -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ��������
    inOperDate:= DATE_TRUNC ('DAY', inOperDate);
    
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_CompetitorMarkups(), inInvNumber, inOperDate, NULL, 0);
        
    
    -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
         
         IF NOT EXISTS(SELECT MovementItem.Id
                       FROM MovementItem
                       WHERE MovementItem.MovementId = ioId
                         AND MovementItem.DescId = zc_MI_Second()
                         AND MovementItem.isErased = False)
         THEN
           PERFORM gpInsertUpdate_MovementItem_PriceSubgroups(ioId := 0, inMovementId := ioId, inPrice := MovementItem.Amount,  inSession := inUserId::TVarChar)
           FROM MovementItem
           WHERE MovementItem.MovementId = (SELECT MAX(Movement.Id)
                                            FROM Movement
                                            WHERE Movement.Id <> ioId
                                              AND Movement.StatusId <> zc_Enum_Status_Erased() 
                                              AND Movement.DescId = zc_Movement_CompetitorMarkups())
             AND MovementItem.DescId = zc_MI_Second()
             AND MovementItem.isErased = False;
         END IF;
     END IF;
     
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.22                                                        *
*/
--
