-- Function: gpSelect_Object_PriceList (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PriceList (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceList(
    IN inShowAll        Boolean,   
    IN inSession        TVarChar         -- ������ ������������
)
  RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, PriceWithVAT Boolean, isErased Boolean)
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());

     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
     
       SELECT 
             Object_PriceList.Id                  AS Id
           , Object_PriceList.ObjectCode          AS Code
           , Object_PriceList.ValueData           AS Name
           , ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , Object_PriceList.isErased            AS isErased
       FROM Object AS Object_PriceList
            JOIN tmpIsErased on tmpIsErased.isErased= Object_PriceList.isErased
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                    ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
       WHERE Object_PriceList.DescId = zc_Object_PriceList()
      UNION ALL
       SELECT 
             0                                AS Id
           , NULL                 :: Integer  AS Code
           , '�������� ��������'  :: TVarChar AS Name
           , FALSE                :: Boolean  AS PriceWithVAT
           , TRUE                 :: Boolean  AS isErased
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_PriceList (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.11.20         *
 23.02.15         * add inShowAll
 16.11.14                                        * add Currency...
 07.09.13                                        * add PriceWithVAT and VATPercent
*/

-- ����
-- SELECT * FROM gpSelect_Object_PriceList ( false , '5')
