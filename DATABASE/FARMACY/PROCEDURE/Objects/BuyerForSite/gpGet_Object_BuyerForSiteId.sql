-- Function: gpGet_Object_BuyerForSiteId()

DROP FUNCTION IF EXISTS gpGet_Object_BuyerForSiteId(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BuyerForSiteId(
    IN inCode        Integer   ,    -- ���
   OUT outId         Integer   ,    -- Id
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

  
   outId := COALESCE(
    (SELECT Object_BuyerForSite.Id                        AS Id 
     FROM Object AS Object_BuyerForSite
          LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                 ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()
     WHERE Object_BuyerForSite.DescId = zc_Object_BuyerForSite()
       AND Object_BuyerForSite.ObjectCode = inCode), 0);
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_BuyerForSiteId(Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.04.22                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_BuyerForSite('3')

SELECT * FROM gpGet_Object_BuyerForSiteId(72798, '3')