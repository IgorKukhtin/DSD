-- Function: gpSelect_Object_CorrectMinAmount()

DROP FUNCTION IF EXISTS gpSelect_Object_CorrectMinAmount(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CorrectMinAmount(
    IN inPayrollTypeId Integer ,	  -- Типы расчета заработной платы
    IN inShowAll       Boolean ,	  -- Показать все
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               PayrollTypeId Integer, PayrollTypeName TVarChar,
               DateStart TDateTime, DateEnd TDateTime, 
               Amount TFloat,
               isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CorrectMinAmount());

   RETURN QUERY 
        WITH tmpObject_CorrectMinAmount AS (SELECT Object_CorrectMinAmount.Id
                                                 , Object_CorrectMinAmount.ObjectCode                     AS Code
                                                 , Object_CorrectMinAmount.ValueData                      AS Name
                                                 
                                                 , ObjectLink_CorrectMinAmount_PayrollType.ChildObjectId  AS PayrollTypeId
                                               
                                                 , ObjectDate_CorrectMinAmount_Date.ValueData             AS DateStart
                                                 
                                                 , ROW_NUMBER() OVER (PARTITION BY ObjectLink_CorrectMinAmount_PayrollType.ChildObjectId ORDER BY ObjectDate_CorrectMinAmount_Date.ValueData) :: Integer AS LineNum

                                                 , Object_CorrectMinAmount.isErased
                                                 
                                             FROM Object AS Object_CorrectMinAmount
                                             
                                                 LEFT JOIN ObjectLink AS ObjectLink_CorrectMinAmount_PayrollType
                                                                      ON ObjectLink_CorrectMinAmount_PayrollType.ObjectId = Object_CorrectMinAmount.Id
                                                                     AND ObjectLink_CorrectMinAmount_PayrollType.DescId = zc_ObjectLink_CorrectMinAmount_PayrollType()

                                                 LEFT JOIN ObjectDate AS ObjectDate_CorrectMinAmount_Date
                                                                      ON ObjectDate_CorrectMinAmount_Date.ObjectId = Object_CorrectMinAmount.Id
                                                                     AND ObjectDate_CorrectMinAmount_Date.DescId = zc_ObjectDate_CorrectMinAmount_Date()
                                             WHERE Object_CorrectMinAmount.DescId = zc_Object_CorrectMinAmount()
                                               AND (COALESCE(inPayrollTypeId, 0) = 0 AND inShowAll = True OR ObjectLink_CorrectMinAmount_PayrollType.ChildObjectId = inPayrollTypeId))
       SELECT 
             Object_CorrectMinAmount.Id
           , Object_CorrectMinAmount.Code
           , Object_CorrectMinAmount.Name
         
           , Object_PayrollType.ID                  AS PayrollTypeId
           , Object_PayrollType.ValueData           AS PayrollTypeName 
           
           , Object_CorrectMinAmount.DateStart
           , COALESCE(Object_CorrectMinAmount_Next.DateStart - INTERVAL '1 DAY', zc_DateEnd())::TDateTime AS DateEnd

           , ObjectFloat_Amount.ValueData           AS Amount         

           , Object_CorrectMinAmount.isErased
           
       FROM tmpObject_CorrectMinAmount AS Object_CorrectMinAmount
       
           LEFT JOIN tmpObject_CorrectMinAmount AS Object_CorrectMinAmount_Next 
                                                ON Object_CorrectMinAmount_Next.PayrollTypeId = Object_CorrectMinAmount.PayrollTypeId
                                               AND Object_CorrectMinAmount_Next.LineNum = Object_CorrectMinAmount.LineNum + 1
       
           LEFT JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = Object_CorrectMinAmount.PayrollTypeId   
           
           LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                 ON ObjectFloat_Amount.ObjectId = Object_CorrectMinAmount.Id 
                                AND ObjectFloat_Amount.DescId = zc_ObjectFloat_CorrectMinAmount_Amount()
       ORDER BY Object_PayrollType.ValueData, COALESCE(Object_CorrectMinAmount_Next.DateStart - INTERVAL '1 DAY', zc_DateEnd())
       ;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CorrectMinAmount (Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.06.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_CorrectMinAmount (0, True, '3')