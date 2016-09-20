-- Function: gpSelect_Object_OrderShedule()

DROP FUNCTION IF EXISTS gpSelect_Object_OrderShedule(Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_OrderShedule(
    IN inisShowAll   Boolean,   
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer,
               Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, 
               Value5 TFloat, Value6 TFloat, Value7 TFloat, Value8 TVarChar,
               OurJuridicalName TVarChar,
               UnitId Integer, UnitName TVarChar,
               JuridicalName TVarChar,
               ContractId Integer, ContractName TVarChar,
               isErased boolean,
               Inf_Text1 TVarChar, Inf_Text2 TVarChar,
               Color_Calc1 Integer, Color_Calc2 Integer, Color_Calc3 Integer, Color_Calc4 Integer,
               Color_Calc5 Integer, Color_Calc6 Integer, Color_Calc7 Integer

               ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_OrderShedule());

   RETURN QUERY 
   WITH 
   tmpObject AS (SELECT Object_OrderShedule.Id           AS Id
                      , Object_OrderShedule.ObjectCode   AS Code
       
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 1) ::TFloat AS Value1
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 2) ::TFloat AS Value2
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 3) ::TFloat AS Value3
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 4) ::TFloat AS Value4
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 5) ::TFloat AS Value5
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 6) ::TFloat AS Value6
                      , zfCalc_Word_Split (inValue:= Object_OrderShedule.ValueData, inSep:= ';', inIndex:= 7) ::TFloat AS Value7

                      , Object_OrderShedule.ValueData ::TVarChar   AS Value8
         
                      , Object_OrderShedule.isErased     AS isErased
                 FROM Object AS Object_OrderShedule
                 WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule()
                  AND (Object_OrderShedule.isErased = inisShowAll OR inisShowAll = True)
                 )

       SELECT 
             Object_OrderShedule.Id
           , Object_OrderShedule.Code
       
           , Object_OrderShedule.Value1 
           , Object_OrderShedule.Value2 
           , Object_OrderShedule.Value3 
           , Object_OrderShedule.Value4 
           , Object_OrderShedule.Value5 
           , Object_OrderShedule.Value6 
           , Object_OrderShedule.Value7 

           , Object_OrderShedule.Value8 ::TVarChar   AS Value8
         
           , Object_Unit_Juridical.ValueData  AS OurJuridicalName
           , Object_Unit.Id                   AS UnitId
           , Object_Unit.ValueData            AS UnitName 

           , Object_Contract_Juridical.ValueData  AS JuridicalName
           , Object_Contract.Id                   AS ContractId
           , Object_Contract.ValueData            AS ContractName 
                     
           , Object_OrderShedule.isErased         AS isErased

           , CASE WHEN Object_OrderShedule.Value1 in (1,3) THEN 'Понедельник,' ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value2 in (1,3) THEN 'Вторник,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value3 in (1,3) THEN 'Среда,'       ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value4 in (1,3) THEN 'Четверг,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value5 in (1,3) THEN 'Пятница,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value6 in (1,3) THEN 'Суббота,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value7 in (1,3) THEN 'Воскресенье'  ELSE '' END         AS Inf_Text1
           , CASE WHEN Object_OrderShedule.Value1 in (2,3) THEN 'Понедельник,' ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value2 in (2,3) THEN 'Вторник,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value3 in (2,3) THEN 'Среда,'       ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value4 in (2,3) THEN 'Четверг,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value5 in (2,3) THEN 'Пятница,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value6 in (2,3) THEN 'Суббота,'     ELSE '' END ||
             CASE WHEN Object_OrderShedule.Value7 in (2,3) THEN 'Воскресенье'  ELSE '' END         AS Inf_Text2
           
           , CASE WHEN Object_OrderShedule.Value1 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value1 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value1 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc1
           , CASE WHEN Object_OrderShedule.Value2 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value2 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value2 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc2
           , CASE WHEN Object_OrderShedule.Value3 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value3 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value3 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc3
           , CASE WHEN Object_OrderShedule.Value4 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value4 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value4 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc4
           , CASE WHEN Object_OrderShedule.Value5 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value5 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value5 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc5
           , CASE WHEN Object_OrderShedule.Value6 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value6 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value6 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc6
           , CASE WHEN Object_OrderShedule.Value7 = 1 THEN zc_Color_Yelow() WHEN Object_OrderShedule.Value7 = 2 THEN zc_Color_Aqua() WHEN Object_OrderShedule.Value7 = 3 THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_Calc7

       FROM tmpObject AS Object_OrderShedule
           LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                               AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_OrderShedule_Contract.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                               AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderShedule_Unit.ChildObjectId    

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Unit_Juridical ON Object_Unit_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId       

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
           LEFT JOIN Object AS Object_Contract_Juridical ON Object_Contract_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId   
;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_OrderShedule ('2')