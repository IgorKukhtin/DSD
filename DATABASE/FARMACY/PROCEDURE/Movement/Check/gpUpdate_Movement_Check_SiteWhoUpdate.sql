-- Function: gpUpdate_Movement_Check_SiteWhoUpdate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SiteWhoUpdate (Integer, TVarChar, TDateTime, TVarChar);
        
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SiteWhoUpdate(
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
    IN inSiteWhoUpdate     TVarChar  , -- ��� ������� �� �����
    IN inSiteDateUpdate    TDateTime , -- ���� ��������� �� �����
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    -- ��������� ����� � ����������
    IF EXISTS(SELECT 1
              FROM Movement 
                   INNER JOIN MovementString AS MovementString_InvNumberOrder
                                             ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                            AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                                            AND COALESCE(MovementString_InvNumberOrder.ValueData, '') <> ''
              WHERE Id = inMovementId)
    THEN
      -- ��������� ��� ������� �� �����
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_SiteWhoUpdate(), inMovementId, inSiteWhoUpdate);
      -- ��������� ���� ��������� �� �����
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SiteDateUpdate(), inMovementId, inSiteDateUpdate);

      -- ��������� ��������
      PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

      -- !!!�������� ��� �����!!!
      IF inSession = zfCalc_UserAdmin()
      THEN
          RAISE EXCEPTION '���� ������ ������� ��� <%>', inSession;
      END IF;
      
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 29.01.19                                                                                      *
 17.12.15                                                                       *
*/

-- ����
-- 
SELECT * FROM gpUpdate_Movement_Check_SiteWhoUpdate (29565513 , 'fgdsgdf', CURRENT_TIMESTAMP::TDateTime, '3'); 

