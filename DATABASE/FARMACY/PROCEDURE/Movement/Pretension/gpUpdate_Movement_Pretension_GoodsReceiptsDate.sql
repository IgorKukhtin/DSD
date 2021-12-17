-- Function: gpUpdate_Movement_Pretension_GoodsReceiptsDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Pretension_GoodsReceiptsDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Pretension_GoodsReceiptsDate(
    IN inMovementId          Integer   , -- ���� ������� <�������� �����������>
    IN inGoodsReceiptsDate   TDateTime , -- ���� ����������� ������
   OUT outGoodsReceiptsDate  TDateTime , -- ���� ����������� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TDateTime AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := inSession;
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Pretension_BranchDate());
    
    IF COALESCE (inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '������. �������� �� ��������!';
    END IF;
    
    -- ��������� ���������
    SELECT
        Movement.StatusId
    INTO
        vbStatusId
    FROM Movement
    WHERE Movement.Id = inMovementId;

    -- �������� ������ � �� ����������� ����������
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
    THEN
       RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);   
    END IF;
    
    outGoodsReceiptsDate := inGoodsReceiptsDate;
    
    --��������� ���� ����������� ������
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_GoodsReceipts(), inMovementId, inGoodsReceiptsDate);
    
/*    -- ��������� ����� � <��� ���������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), inMovementId, vbUserId);
*/
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.21                                                       *
*/

select * from gpUpdate_Movement_Pretension_GoodsReceiptsDate(inMovementId := 26008006 , inGoodsReceiptsDate := ('16.12.2021')::TDateTime ,  inSession := '3');