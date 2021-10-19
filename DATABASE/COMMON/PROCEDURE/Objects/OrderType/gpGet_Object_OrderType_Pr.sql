-- Function: gpGet_Object_OrderType_Pr()

DROP FUNCTION IF EXISTS gpGet_Object_OrderType_Pr (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Object_OrderType_Pr(
    IN inId          Integer  , 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , isOrderPr1 Boolean, isOrderPr2 Boolean, isOrderPr3 Boolean, isOrderPr4 Boolean, isOrderPr5 Boolean, isOrderPr6 Boolean, isOrderPr7 Boolean
             , isInPr1 Boolean, isInPr2 Boolean, isInPr3 Boolean, isInPr4 Boolean, isInPr5 Boolean, isInPr6 Boolean, isInPr7 Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_OrderType());
   vbUserId:= lpGetUserBySession (inSession);

   
    RETURN QUERY 
       SELECT 
             Object_OrderType.Id          AS Id

           , COALESCE (ObjectBoolean_OrderPr1.ValueData, FALSE) ::Boolean AS isOrderPr1
           , COALESCE (ObjectBoolean_OrderPr2.ValueData, FALSE) ::Boolean AS isOrderPr2 
           , COALESCE (ObjectBoolean_OrderPr3.ValueData, FALSE) ::Boolean AS isOrderPr3
           , COALESCE (ObjectBoolean_OrderPr4.ValueData, FALSE) ::Boolean AS isOrderPr4
           , COALESCE (ObjectBoolean_OrderPr5.ValueData, FALSE) ::Boolean AS isOrderPr5
           , COALESCE (ObjectBoolean_OrderPr6.ValueData, FALSE) ::Boolean AS isOrderPr6
           , COALESCE (ObjectBoolean_OrderPr7.ValueData, FALSE) ::Boolean AS isOrderPr7

           , COALESCE (ObjectBoolean_InPr1.ValueData, FALSE) ::Boolean AS isInPr1
           , COALESCE (ObjectBoolean_InPr2.ValueData, FALSE) ::Boolean AS isInPr2 
           , COALESCE (ObjectBoolean_InPr3.ValueData, FALSE) ::Boolean AS isInPr3
           , COALESCE (ObjectBoolean_InPr4.ValueData, FALSE) ::Boolean AS isInPr4
           , COALESCE (ObjectBoolean_InPr5.ValueData, FALSE) ::Boolean AS isInPr5
           , COALESCE (ObjectBoolean_InPr6.ValueData, FALSE) ::Boolean AS isInPr6
           , COALESCE (ObjectBoolean_InPr7.ValueData, FALSE) ::Boolean AS isInPr7
       FROM Object AS Object_OrderType

             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr1
                                     ON ObjectBoolean_OrderPr1.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr1.DescId = zc_ObjectBoolean_OrderType_OrderPr1()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr2
                                     ON ObjectBoolean_OrderPr2.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr2.DescId = zc_ObjectBoolean_OrderType_OrderPr2()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr3
                                     ON ObjectBoolean_OrderPr3.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr3.DescId = zc_ObjectBoolean_OrderType_OrderPr3()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr4
                                     ON ObjectBoolean_OrderPr4.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr4.DescId = zc_ObjectBoolean_OrderType_OrderPr4()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr5
                                     ON ObjectBoolean_OrderPr5.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr5.DescId = zc_ObjectBoolean_OrderType_OrderPr5()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr6
                                     ON ObjectBoolean_OrderPr6.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr6.DescId = zc_ObjectBoolean_OrderType_OrderPr6()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_OrderPr7
                                     ON ObjectBoolean_OrderPr7.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_OrderPr7.DescId = zc_ObjectBoolean_OrderType_OrderPr7()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr1
                                     ON ObjectBoolean_InPr1.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr1.DescId = zc_ObjectBoolean_OrderType_InPr1()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr2
                                     ON ObjectBoolean_InPr2.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr2.DescId = zc_ObjectBoolean_OrderType_InPr2()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr3
                                     ON ObjectBoolean_InPr3.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr3.DescId = zc_ObjectBoolean_OrderType_InPr3()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr4
                                     ON ObjectBoolean_InPr4.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr4.DescId = zc_ObjectBoolean_OrderType_InPr4()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr5
                                     ON ObjectBoolean_InPr5.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr5.DescId = zc_ObjectBoolean_OrderType_InPr5()                             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr6
                                     ON ObjectBoolean_InPr6.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr6.DescId = zc_ObjectBoolean_OrderType_InPr6()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_InPr7
                                     ON ObjectBoolean_InPr7.ObjectId = Object_OrderType.Id 
                                    AND ObjectBoolean_InPr7.DescId = zc_ObjectBoolean_OrderType_InPr7()
       WHERE Object_OrderType.DescId = zc_Object_OrderType()
         AND Object_OrderType.Id = inId;

  
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.10.21         *
*/

-- тест
--