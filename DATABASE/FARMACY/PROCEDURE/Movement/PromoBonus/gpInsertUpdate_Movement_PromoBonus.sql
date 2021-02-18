-- Function: gpInsertUpdate_Movement_PromoBonus()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoBonus (Integer, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoBonus(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoBonus());
     vbUserId := inSession;
     
     inOperDate := DATE_TRUNC ('DAY', inOperDate);
       
     
     IF COALESCE (ioId, 0) = 0
        AND EXISTS(SELECT Movement.id
                   FROM Movement 
                   WHERE Movement.OperDate = inOperDate  
                     AND Movement.DescId = zc_Movement_PromoBonus() 
                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                      )
     THEN 
       SELECT Movement.id, CASE WHEN COALESCE(inComment, '') <> '' THEN inComment ELSE COALESCE (MovementString_Comment.ValueData,'') END
       INTO ioId, inComment
       FROM Movement 

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

       WHERE Movement.OperDate = inOperDate  
         AND Movement.DescId = zc_Movement_PromoBonus() 
         AND Movement.StatusId <> zc_Enum_Status_Erased();   
     END IF;     
     
         -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_PromoBonus (ioId               := ioId
                                             , inInvNumber        := inInvNumber
                                             , inOperDate         := inOperDate
                                             , inComment          := inComment
                                             , inUserId           := vbUserId
                                              );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.02.21                                                       *
*/

-- ����
-- 