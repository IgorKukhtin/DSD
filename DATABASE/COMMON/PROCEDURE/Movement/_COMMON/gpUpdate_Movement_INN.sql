-- Function: gpUpdate_Movement_INN()
DROP FUNCTION IF EXISTS gpUpdate_Movement_INN (Integer, TVarChar, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_INN(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inINN                 TVarChar  , -- 
   OUT outisINN              Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    vbDescId := (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);

    IF vbDescId = zc_Movement_Tax() 
    THEN
        -- ��������� <>
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_ToINN(), inMovementId, inINN);
    END IF;
    IF vbDescId = zc_Movement_TaxCorrective() 
    THEN
        -- ��������� <>
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_FromINN(), inMovementId, inINN);
    END IF;
    
    IF COALESCE (inINN, '') <> '' 
    THEN
        outisINN := TRUE;
    ELSE 
       outisINN := FALSE;
    END IF;
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.03.18         *
*/

-- ����
--