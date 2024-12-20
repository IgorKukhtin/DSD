-- Function: gpUpdate_Object_Partner_Delivery()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Delivery (Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Delivery(
    IN inId                  Integer  ,  -- ���� ������� <����������> 
    IN inValue1              Boolean  ,  -- ����������� ��������
    IN inValue2              Boolean  ,  -- �������
    IN inValue3              Boolean  ,  -- �����
    IN inValue4              Boolean  ,  -- �������
    IN inValue5              Boolean  ,  -- �������
    IN inValue6              Boolean  ,  -- �������
    IN inValue7              Boolean  ,  -- �����������
    IN inSession             TVarChar    -- ������ ������������
)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbDelivery TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Schedule());
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!���� ��� ����� ���������� ����� ��������� ��������� �������������!!!)
   IF COALESCE (inId, 0) = 0
   THEN 
       RETURN;
   END IF;

   vbDelivery:= (inValue1||';'||inValue2||';'||inValue3||';'||inValue4||';'||inValue5||';'||inValue6||';'||inValue7) :: TVarChar;
   vbDelivery:= replace( replace (vbDelivery, 'true', 't'), 'false', 'f');

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Delivery(), inId, vbDelivery);  

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.03.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_Delivery()
