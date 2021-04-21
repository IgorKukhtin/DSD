-- Function: gpInsertUpdate_Object_BuyerForSite()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BuyerForSite(Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BuyerForSite(Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BuyerForSite(
   OUT outId            Integer   ,     -- ���� ������� <����������> 
    IN inCode           Integer   ,     -- ���� ������� <ID �� �����> 
    IN inName           TVarChar  ,     -- ������� ��� ��������
    IN inPhone          TVarChar  ,     -- �������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_BuyerForSite());
      vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE(inCode, 0) = 0
   THEN
     RAISE EXCEPTION '�� ������� ID ���������� �� �����.';   
   END IF;
   
   -- ���� ���������� �� ID
   IF EXISTS (SELECT ValueData FROM Object WHERE DescId = zc_Object_BuyerForSite() AND ObjectCode = inCode) 
   THEN
      SELECT ID INTO outId FROM Object WHERE DescId = zc_Object_BuyerForSite() AND ObjectCode = inCode;
   ELSE
     outId := 0;
   END IF; 

   IF COALESCE (outId, 0) <> 0
   THEN
     IF EXISTS(SELECT Object_BuyerForSite.Id                        AS Id 
                    , Object_BuyerForSite.ObjectCode                AS Code
                    , Object_BuyerForSite.ValueData                 AS Name
                    , ObjectString_BuyerForSite_Phone.ValueData     AS Phone
                    , Object_BuyerForSite.isErased                  AS isErased
               FROM Object AS Object_BuyerForSite
                    LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                           ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                          AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()
               WHERE Object_BuyerForSite.Id = outId
                 AND Object_BuyerForSite.ValueData = inName
                 AND COALESCE(ObjectString_BuyerForSite_Phone.ValueData, '') = COALESCE (inPhone, ''))
     THEN
       RETURN;
     END IF;
   END IF;
         
   -- ��������� <������>
   outId := lpInsertUpdate_Object (outId, zc_Object_BuyerForSite(), inCode, inName);
      
   -- ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_BuyerForSite_Phone(), outId, inPhone);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (outId, vbUserId);
      
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.04.21                                                       *
*/

-- ����  SELECT * FROM gpSelect_Object_BuyerForSite('3')
-- select gpInsertUpdate_Object_BuyerForSite(234, '������� �.�.', '5645645745', '3');

