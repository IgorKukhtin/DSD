-- Function: gpDelete_Object_Hardware()

DROP FUNCTION IF EXISTS gpDelete_Object_Hardware(integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_Hardware(
    IN inId            Integer,       -- ���� ������� <������>
    IN isCashRegister  Boolean,       -- �����
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF isCashRegister = True
   THEN
      RAISE EXCEPTION '������. ��������� ������ �� ������ ���������...';
   END IF;

    -- ��������� ������ ����������� � ������� ������    
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '�������� ���������, ���������� � ���������� ��������������';
   END IF;
    
   IF COALESCE (inId, 0) <> 0
   THEN
     PERFORM lpDelete_Object(inId, inSession);
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_Hardware(integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 13.04.20                                                                      *  
*/

-- ����
-- SELECT * FROM gpDelete_Object_Hardware (0, True, '3')