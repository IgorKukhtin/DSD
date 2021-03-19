-- Function: gpGet_Object_Juridical()

DROP FUNCTION IF EXISTS gpGet_Object_Juridical(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Juridical(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               RetailId Integer, RetailName TVarChar,
               isCorporate boolean,
               Percent TFloat, 
               PayOrder TFloat,
               isLoadBarcode Boolean,
               isDeferred Boolean,
               isUseReprice Boolean, isPriorityReprice Boolean, ExpirationDateMonth Integer, 
               CBName TVarChar, CBMFO TVarChar, CBAccount TVarChar, CBAccountOld TVarChar, CBPurposePayment TVarChar,
               CodeRazom Integer, CodeMedicard Integer, CodeOrangeCard Integer,
               isErased boolean) AS
$BODY$
BEGIN 

  -- проверка прав пользователя на вызов процедуры
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
           , FALSE                   AS isUseReprice
           , FALSE                   AS isPriorityReprice
           , 0::Integer              AS ExpirationDateMonth
           
           , CAST ('' as TVarChar)   AS CBName 
           , CAST ('' as TVarChar)   AS CBMFO
           , CAST ('' as TVarChar)   AS CBAccount
           , CAST ('' as TVarChar)   AS CBAccountOld
           , CAST ('' as TVarChar)   AS CBPurposePayment
           , NULL::Integer           AS CodeRazom
           , NULL::Integer           AS CodeMedicard
           , NULL::Integer           AS CodeOrangeCard

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
           , COALESCE (ObjectBoolean_UseReprice.ValueData, FALSE)      AS isUseReprice
           , COALESCE (ObjectBoolean_PriorityReprice.ValueData, FALSE) AS isPriorityReprice
           , ObjectFloat_ExpirationDateMonth.ValueData::Integer        AS ExpirationDateMonth
           
           , ObjectString_CBName.ValueData             AS CBName 
           , ObjectString_CBMFO.ValueData              AS CBMFO
           , ObjectString_CBAccount.ValueData          AS CBAccount
           , ObjectString_CBAccountOld.ValueData       AS CBAccountOld
           , ObjectString_CBPurposePayment.ValueData   AS CBPurposePayment
           , ObjectFloat_CodeRazom.ValueData::Integer  AS CodeRazom
           , ObjectFloat_CodeMedicard.ValueData::Integer   AS CodeMedicard
           , ObjectFloat_CodeOrangeCard.ValueData::Integer AS CodeOrangeCard
           
           , Object_Juridical.isErased                 AS isErased
           
       FROM Object AS Object_Juridical

           LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                 ON ObjectFloat_Percent.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

           LEFT JOIN ObjectFloat AS ObjectFloat_PayOrder
                                 ON ObjectFloat_PayOrder.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_PayOrder.DescId = zc_ObjectFloat_Juridical_PayOrder()
           LEFT JOIN ObjectFloat AS ObjectFloat_ExpirationDateMonth
                                 ON ObjectFloat_ExpirationDateMonth.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_ExpirationDateMonth.DescId = zc_ObjectFloat_Juridical_ExpirationDateMonth()

           LEFT JOIN ObjectFloat AS ObjectFloat_CodeRazom
                                 ON ObjectFloat_CodeRazom.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_CodeRazom.DescId = zc_ObjectFloat_Juridical_CodeRazom()
           LEFT JOIN ObjectFloat AS ObjectFloat_CodeMedicard
                                 ON ObjectFloat_CodeMedicard.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_CodeMedicard.DescId = zc_ObjectFloat_Juridical_CodeMedicard()
           LEFT JOIN ObjectFloat AS ObjectFloat_CodeOrangeCard
                                 ON ObjectFloat_CodeOrangeCard.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_CodeOrangeCard.DescId = zc_ObjectFloat_Juridical_CodeOrangeCard()

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

           LEFT JOIN ObjectBoolean AS ObjectBoolean_UseReprice
                                   ON ObjectBoolean_UseReprice.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_UseReprice.DescId = zc_ObjectBoolean_Juridical_UseReprice()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PriorityReprice
                                   ON ObjectBoolean_PriorityReprice.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_PriorityReprice.DescId = zc_ObjectBoolean_Juridical_PriorityReprice()

           LEFT JOIN ObjectString AS ObjectString_CBName
                                  ON ObjectString_CBName.ObjectId = Object_Juridical.Id
                                 AND ObjectString_CBName.DescId = zc_ObjectString_Juridical_CBName()

           LEFT JOIN ObjectString AS ObjectString_CBMFO
                                  ON ObjectString_CBMFO.ObjectId = Object_Juridical.Id
                                 AND ObjectString_CBMFO.DescId = zc_ObjectString_Juridical_CBMFO()

           LEFT JOIN ObjectString AS ObjectString_CBAccount
                                  ON ObjectString_CBAccount.ObjectId = Object_Juridical.Id
                                 AND ObjectString_CBAccount.DescId = zc_ObjectString_Juridical_CBAccount()

           LEFT JOIN ObjectString AS ObjectString_CBAccountOld
                                  ON ObjectString_CBAccountOld.ObjectId = Object_Juridical.Id
                                 AND ObjectString_CBAccountOld.DescId = zc_ObjectString_Juridical_CBAccountOld()

           LEFT JOIN ObjectString AS ObjectString_CBPurposePayment
                                  ON ObjectString_CBPurposePayment.ObjectId = Object_Juridical.Id
                                 AND ObjectString_CBPurposePayment.DescId = zc_ObjectString_Juridical_CBPurposePayment()

      WHERE Object_Juridical.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Ярошенко Р.Ф.  Шаблий О.В.
 10.06.20                                                                                     * 
 06.09.19                                                                                     * 
 22.02.18         * dell OrderSumm, OrderSummComment, OrderTime
 17.08.17         * add isDeferred
 27.06.17                                                                       * isLoadBarcode
 14.01.17         * 
 02.12.15                                                         * PayOrder               
 01.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Juridical(0, '2')