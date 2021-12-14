-- Function: gpGet_Pretension_ReturnOut()

DROP FUNCTION IF EXISTS gpGet_Pretension_ReturnOut(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Pretension_ReturnOut(
    IN inMovementId          Integer   ,    -- ���� ���������
   OUT outReturnOutId        TVarChar  ,    -- ������� ����������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());

   
   IF EXISTS(SELECT 1
             FROM MovementLinkMovement 
             WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Pretension()
               AND MovementLinkMovement.MovementChildId = inMovementId)
   THEN
     SELECT MovementLinkMovement.MovementId
     INTO outReturnOutId
     FROM MovementLinkMovement 
     WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Pretension()
       AND MovementLinkMovement.MovementChildId = inMovementId;
   ELSE
     RAISE EXCEPTION '������� ���������� �� ��������� �� ������.';
   END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.12.21                                                       *
*/

select * from gpGet_Pretension_ReturnOut(inMovementId := 26087688 ,  inSession := '3');