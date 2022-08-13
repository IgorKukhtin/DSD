-- Function: gpSelect_Object_TradeMark (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_TradeMark (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TradeMark(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ColorReport Integer, ColorBgReport Integer, Text1 TVarChar, Text2 TVarChar
             , RetailId Integer, RetailName TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_TradeMark());

   RETURN QUERY 
   SELECT
         Object.Id         AS Id 
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
      
       , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())    ::Integer  AS ColorReport
       , COALESCE (ObjectFloat_ColorBgReport.ValueData,zc_Color_White())   ::Integer  AS ColorBgReport
       , CASE WHEN COALESCE (ObjectFloat_ColorReport.ValueData,-1)   = -1 THEN '' ELSE '�����' END ::TVarChar  AS Text1
       , CASE WHEN COALESCE (ObjectFloat_ColorBgReport.ValueData,-1) = -1 THEN '' ELSE '���'   END ::TVarChar  AS Text2

       , Object_Retail.Id         AS RetailId
       , Object_Retail.ValueData  AS RetailName

       , Object.isErased   AS isErased
   FROM Object
          LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                ON ObjectFloat_ColorReport.ObjectId = Object.Id 
                               AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_TradeMark_ColorReport()
          LEFT JOIN ObjectFloat AS ObjectFloat_ColorBgReport
                                ON ObjectFloat_ColorBgReport.ObjectId = Object.Id 
                               AND ObjectFloat_ColorBgReport.DescId = zc_ObjectFloat_TradeMark_ColorBgReport()

          LEFT JOIN ObjectLink AS ObjectLink_Retail
                               ON ObjectLink_Retail.ObjectId = Object.Id
                              AND ObjectLink_Retail.DescId = zc_ObjectLink_TradeMark_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Retail.ChildObjectId
   WHERE Object.DescId = zc_Object_TradeMark();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_TradeMark (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.12.16         * 
 06.09.13                         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_TradeMark('2')
