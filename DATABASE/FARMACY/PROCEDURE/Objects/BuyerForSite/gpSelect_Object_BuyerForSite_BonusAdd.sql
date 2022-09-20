-- Function: gpSelect_Object_BuyerForSite_BonusAdd()

DROP FUNCTION IF EXISTS gpSelect_Object_BuyerForSite_BonusAdd(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BuyerForSite_BonusAdd(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Code Integer, BonusAdd TFloat) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_BuyerForSite.ObjectCode                AS Code
        , ObjectFloat_BuyerForSite_BonusAdd.ValueData   AS BonusAdd
   FROM Object AS Object_BuyerForSite
        LEFT JOIN ObjectFloat AS ObjectFloat_BuyerForSite_BonusAdd
                              ON ObjectFloat_BuyerForSite_BonusAdd.ObjectId = Object_BuyerForSite.Id 
                             AND ObjectFloat_BuyerForSite_BonusAdd.DescId = zc_ObjectFloat_BuyerForSite_BonusAdd()
   WHERE Object_BuyerForSite.DescId = zc_Object_BuyerForSite()
     AND Object_BuyerForSite.isErased = False
     AND COALESCE (ObjectFloat_BuyerForSite_BonusAdd.ValueData, 0) <> 0;
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_BuyerForSite_BonusAdd(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.09.22                                                       *
*/

-- ����
-- 
SELECT * FROM gpSelect_Object_BuyerForSite_BonusAdd('3')