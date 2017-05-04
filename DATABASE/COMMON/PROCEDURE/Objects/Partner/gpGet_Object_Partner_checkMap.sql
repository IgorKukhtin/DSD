-- Function: gpGet_Object_Partner_checkMap()

DROP FUNCTION IF EXISTS gpGet_Object_Partner_checkMap (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner_checkMap(
    IN inJuridicalId       Integer  , 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);

   -- ������������ 
   IF COALESCE (inJuridicalId, 0) = 0 THEN
     -- RAISE EXCEPTION '������. ������ �� ����� Google �������� ����� ���������� <%> ������������.���������� ���������� <�������� ����> ��� <����������� ����> ��� <��� ��������� (��)>.', (SELECT COUNT() FROM Object WHERE DescId = zc_Object_Partner()) :: Integer;
     RAISE EXCEPTION '������. ������ �� ����� Google �������� ����� ���������� <%> ������������.���������� ���������� ����������� � ������ <����������� ����>.', (SELECT COUNT(*) FROM Object WHERE DescId = zc_Object_Partner()) :: Integer;
   END IF;
   
   -- ������ ���   
   RETURN inJuridicalId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.05.17                                        *
*/

-- ����
-- SELECT * FROM gpGet_Object_Partner_checkMap (0, zfCalc_UserAdmin())
