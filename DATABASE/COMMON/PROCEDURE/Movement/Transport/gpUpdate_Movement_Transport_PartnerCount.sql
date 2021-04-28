-- Function: gpUpdate_Movement_Transport_PartnerCount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_Transport_PartnerCount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Transport_PartnerCount(
    IN inMovementId   Integer   , -- ���� ������� <��������>
    IN inSession      TVarChar    -- ������ ������������

)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������������
     PERFORM lpUpdate_Movement_Transport_PartnerCount (inMovementId_trasport:= inMovementId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.04.21         *
*/

-- ����
--
