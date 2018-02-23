-- Function: gpGet_Object_Juridical()

DROP FUNCTION IF EXISTS gpGet_Object_Juridical(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Juridical(
    IN inId          Integer,       -- ������������� 
    IN inSession     TVarChar       -- ������ ������������ 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               RetailId Integer, RetailName TVarChar,
               isCorporate boolean,
               Percent TFloat, 
               PayOrder TFloat,
               isLoadBarcode Boolean,
               isDeferred Boolean,
               isErased boolean) AS
$BODY$
BEGIN 

  -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Juridical());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_Juridical()) AS Code
           , CAST ('' as TVarChar)   AS Name
           
           , CAST (0 as Integer)     AS RetailId
           , CAST ('' as TVarChar)   AS RetailName 

           , CAST (False AS Boolean) AS isCorporate 
           , 0::TFloat               AS Percent    
           , NULL::TFloat            AS PayOrder
       
           , FALSE                   AS isLoadBarcode  
           , FALSE                   AS isDeferred

           , CAST (NULL AS Boolean)  AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Juridical.Id                 AS Id
           , Object_Juridical.ObjectCode         AS Code
           , Object_Juridical.ValueData          AS Name
         
           , Object_Retail.Id                    AS RetailId
           , Object_Retail.ValueData             AS RetailName 

           , ObjectBoolean_isCorporate.ValueData AS isCorporate
           , ObjectFloat_Percent.ValueData       AS Percent
           , ObjectFloat_PayOrder.ValueData      AS PayOrder

           , COALESCE (ObjectBoolean_LoadBarcode.ValueData, FALSE)     AS isLoadBarcode
           , COALESCE (ObjectBoolean_Deferred.ValueData, FALSE)        AS isDeferred
           
           , Object_Juridical.isErased           AS isErased
           
       FROM Object AS Object_Juridical

           LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                 ON ObjectFloat_Percent.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

           LEFT JOIN ObjectFloat AS ObjectFloat_PayOrder
                                 ON ObjectFloat_PayOrder.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_PayOrder.DescId = zc_ObjectFloat_Juridical_PayOrder()

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                   ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_LoadBarcode 
                                   ON ObjectBoolean_LoadBarcode.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_LoadBarcode.DescId = zc_ObjectBoolean_Juridical_LoadBarcode()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Deferred
                                   ON ObjectBoolean_Deferred.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_Deferred.DescId = zc_ObjectBoolean_Juridical_Deferred()
      WHERE Object_Juridical.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  �������� �.�.
 22.02.18         * dell OrderSumm, OrderSummComment, OrderTime
 17.08.17         * add isDeferred
 27.06.17                                                                       * isLoadBarcode
 14.01.17         * 
 02.12.15                                                         * PayOrder               
 01.07.14         *

*/

-- ����
-- SELECT * FROM gpGet_Object_Juridical(0, '2')
