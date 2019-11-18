-- Function: gpMovementItem_LoyaltySign_LinkCheck()

DROP FUNCTION IF EXISTS gpMovementItem_LoyaltySign_LinkCheck (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_LoyaltySign_LinkCheck(  
    IN inId                  Integer   , -- ID ���������
    IN inCheckID             Integer   , -- ID ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
   vbUserId:= lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '������� �������� � ����� ��� ���������, ���������� � ���������� ��������������';
   END IF;

   UPDATE movementitem SET parentid = inCheckID where ID = inId;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.11.19                                                       *
 */

-- zfCalc_FromHex

-- SELECT * FROM gpMovementItem_LoyaltySign_LinkCheck (0, 16406918, '3');