-- Function: gpSelect_Object_PriceList (Boolean, TVarChar);

DROP FUNCTION IF EXISTS gpSelect_Object_PriceList (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceList(
    IN inIsShowAll   Boolean,            -- ������� �������� ��������� �� / ��� 
    IN inSession     TVarChar            -- ������ ������������
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , isErased boolean)
AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());   
      PERFORM lpGetUserBySession (inSession);

   -- ���������
   RETURN QUERY
       SELECT
             Object_PriceList.Id                      AS Id
           , Object_PriceList.ObjectCode              AS Code
           , Object_PriceList.ValueData               AS Name
           , Object_Currency.Id                       AS CurrencyId
           , Object_Currency.ValueData                AS CurrencyName
           , Object_PriceList.isErased                AS isErased
       FROM Object AS Object_PriceList

            LEFT JOIN ObjectLink AS Object_PriceList_Currency
                                 ON Object_PriceList_Currency.ObjectId = Object_PriceList.Id
                                AND Object_PriceList_Currency.DescId = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = Object_PriceList_Currency.ChildObjectId
      
       WHERE Object_PriceList.DescId = zc_Object_PriceList()
         AND (Object_PriceList.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
28.04.17          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_PriceList (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
