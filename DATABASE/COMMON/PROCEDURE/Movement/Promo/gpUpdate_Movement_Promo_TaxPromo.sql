-- Function: gpUpdate_Movement_Promo_TaxPromo()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_TaxPromo(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_TaxPromo(
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inisTaxPromo             Boolean   ,
   OUT outisTaxPromo            Boolean   ,
   OUT outisTaxPromo_Condition  Boolean   ,
    IN inSession                TVarChar     -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());


     -- �������� - ���� ���� �������, �������������� ������
     PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inMovementId
                                        , inIsComplete:= FALSE
                                        , inIsUpdate  := TRUE
                                        , inUserId    := vbUserId
                                         );

     -- ���������� �������
     inisTaxPromo:= NOT inisTaxPromo;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_TaxPromo(), inMovementId, inisTaxPromo);
     
     outisTaxPromo := inisTaxPromo;
     outisTaxPromo_Condition := NOT inisTaxPromo;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.04.20         *
*/

-- ����
--