-- Function: gpSelect_Object_Retail()

DROP FUNCTION IF EXISTS gpSelect_Object_Retail( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Retail(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , OperDateOrder Boolean
             , GLNCode TVarChar, GLNCodeCorporate TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , PersonalMarketingId Integer, PersonalMarketingName TVarChar
             , PersonalTradeId Integer, PersonalTradeName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

       RETURN QUERY 
       SELECT 
             Object_Retail.Id         AS Id
           , Object_Retail.ObjectCode AS Code
           , Object_Retail.ValueData  AS NAME

           , COALESCE (ObjectBoolean_OperDateOrder.ValueData, CAST (False AS Boolean)) AS OperDateOrder
 
           , GLNCode.ValueData               AS GLNCode
           , GLNCodeCorporate.ValueData      AS GLNCodeCorporate
           , Object_GoodsProperty.Id         AS GoodsPropertyId
           , Object_GoodsProperty.ValueData  AS GoodsPropertyName     
           , Object_PersonalMarketing.Id         AS PersonalMarketingId
           , Object_PersonalMarketing.ValueData  AS PersonalMarketingName       
           , Object_PersonalTrade.Id             AS PersonalTradeId
           , Object_PersonalTrade.ValueData      AS PersonalTradeName   
           , Object_Retail.isErased   AS isErased
       FROM OBJECT AS Object_Retail
        LEFT JOIN ObjectString AS GLNCode
                               ON GLNCode.ObjectId = Object_Retail.Id 
                              AND GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
        LEFT JOIN ObjectString AS GLNCodeCorporate
                               ON GLNCodeCorporate.ObjectId = Object_Retail.Id 
                              AND GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                 ON ObjectBoolean_OperDateOrder.ObjectId = Object_Retail.Id 
                                AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder() 
    
        LEFT JOIN ObjectLink AS ObjectLink_Retail_GoodsProperty
                             ON ObjectLink_Retail_GoodsProperty.ObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail_GoodsProperty.DescId = zc_ObjectLink_Retail_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Retail_GoodsProperty.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Retail_PersonalMarketing
                             ON ObjectLink_Retail_PersonalMarketing.ObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail_PersonalMarketing.DescId = zc_ObjectLink_Retail_PersonalMarketing()
        LEFT JOIN Object AS Object_PersonalMarketing ON Object_PersonalMarketing.Id = ObjectLink_Retail_PersonalMarketing.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Retail_PersonalTrade
                             ON ObjectLink_Retail_PersonalTrade.ObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail_PersonalTrade.DescId = zc_ObjectLink_Retail_PersonalTrade()
        LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Retail_PersonalTrade.ChildObjectId
                              
       WHERE Object_Retail.DescId = zc_Object_Retail();
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.11.15         * add PersonalMarketing
 20.05.15         *
 02.04.15         * add OperDateOrder
 19.02.15         * add GoodsProperty               
 10.11.14         * add GLNCode
 23.05.14         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Retail ( zfCalc_UserAdmin())
