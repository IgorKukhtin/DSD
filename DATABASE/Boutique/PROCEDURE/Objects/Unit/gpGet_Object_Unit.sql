﻿-- Function: gpGet_Object_Unit(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Unit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Address TVarChar, Phone TVarChar, DiscountTax TFloat, JuridicalId Integer, JuridicalName TVarChar,  ParentId Integer, ParentName TVarChar,  ChildId Integer, ChildName  TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                          AS Id
           , lfGet_ObjectCode(0, zc_Object_Unit())  AS Code
           , '' :: TVarChar                         AS Name
           , '' :: TVarChar                         AS Address
           , '' :: TVarChar                         AS Phone
           ,  0 :: TFloat                           AS DiscountTax
           ,  0 :: Integer                          AS JuridicalId      
           , '' :: TVarChar                         AS JuridicalName    
           ,  0 :: Integer                          AS ParentId         
           , '' :: TVarChar                         AS ParentName       
           ,  0 :: Integer                          AS ChildId          
           , '' :: TVarChar                         AS ChildName        

       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_Unit.Id                  AS Id
           , Object_Unit.ObjectCode          AS Code
           , Object_Unit.ValueData           AS Name
           , OS_Unit_Address.ValueData       AS Address
           , OS_Unit_Phone.ValueData         As Phone
           , OS_Unit_DiscountTax.ValueData   AS DiscountTax
           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_Parent.Id                AS ParentId
           , Object_Parent.ValueData         AS ParentName
           , Object_Child.Id                 AS ChildId
           , Object_Child.ValueData          AS ChildName
       
       FROM Object AS Object_Unit
            LEFT JOIN ObjectString AS OS_Unit_Address
                                   ON OS_Unit_Address.ObjectId = Object_Unit.Id
                                  AND OS_Unit_Address.DescId = zc_ObjectString_Unit_Address()
            LEFT JOIN ObjectString AS OS_Unit_Phone
                                   ON OS_Unit_Phone.ObjectId = Object_Unit.Id
                                  AND OS_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()
            LEFT JOIN ObjectFloat AS OS_Unit_DiscountTax
                 ON OS_Unit_DiscountTax.ObjectId = Object_Unit.Id
                AND OS_Unit_DiscountTax.DescId = zc_ObjectFloat_Unit_DiscountTax()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Child
                                 ON ObjectLink_Unit_Child.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Child.DescId = zc_ObjectLink_Unit_Child()
            LEFT JOIN Object AS Object_Child ON Object_Child.Id = ObjectLink_Unit_Child.ChildObjectId

      WHERE Object_Unit.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
08.05.17                                                          *
06.03.17                                                          *
28.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Unit(1,'2')
