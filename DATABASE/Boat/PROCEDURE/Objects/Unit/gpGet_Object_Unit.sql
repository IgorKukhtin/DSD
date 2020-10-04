-- Function: gpGet_Object_Unit(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Unit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделения
    IN inSession     TVarChar       -- сессия пользователя
) 
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Address TVarChar, Phone TVarChar
             , Printer TVarChar, PrintName TVarChar
             , DiscountTax TFloat
             , JuridicalId Integer, JuridicalName TVarChar
             , ParentId Integer, ParentName TVarChar
             , ChildId Integer, ChildName  TVarChar
             , BankAccountId Integer, BankAccountName  TVarChar
             , AccountDirectionId Integer, AccountDirectionName TVarChar
             , GoodsGroupId Integer, GoodsGroupName  TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , isPartnerBarCode Boolean
) 
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
           , '' :: TVarChar                         AS Printer
           , '' :: TVarChar                         AS PrintName
           ,  0 :: TFloat                           AS DiscountTax
           ,  0 :: Integer                          AS JuridicalId      
           , '' :: TVarChar                         AS JuridicalName    
           ,  0 :: Integer                          AS ParentId         
           , '' :: TVarChar                         AS ParentName       
           ,  0 :: Integer                          AS ChildId          
           , '' :: TVarChar                         AS ChildName        
           ,  0 :: Integer                          AS BankAccountId          
           , '' :: TVarChar                         AS BankAccountName        
           ,  0 :: Integer                          AS AccountDirectionId
           , '' :: TVarChar                         AS AccountDirectionName 
           ,  0 :: Integer                          AS GoodsGroupId          
           , '' :: TVarChar                         AS GoodsGroupName
           ,  0 :: Integer                          AS PriceListId
           , '' :: TVarChar                         AS PriceListName
           , FALSE :: Boolean                       AS isPartnerBarCode
       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_Unit.Id                  AS Id
           , Object_Unit.ObjectCode          AS Code
           , Object_Unit.ValueData           AS Name
           , OS_Unit_Address.ValueData       AS Address
           , OS_Unit_Phone.ValueData         AS Phone
           , OS_Unit_Printer.ValueData       AS Printer
           , OS_Unit_Print.ValueData         AS PrintName
           , OS_Unit_DiscountTax.ValueData   AS DiscountTax
           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_Parent.Id                AS ParentId
           , Object_Parent.ValueData         AS ParentName
           , Object_Child.Id                 AS ChildId
           , Object_Child.ValueData          AS ChildName
           , Object_BankAccount.Id           AS BankAccountId
           , Object_BankAccount.ValueData    AS BankAccountName

           , Object_AccountDirection.Id         AS AccountDirectionId
           , Object_AccountDirection.ValueData  AS AccountDirectionName  

           , Object_GoodsGroup.Id           AS GoodsGroupId
           , Object_GoodsGroup.ValueData    AS GoodsGroupName

           , Object_PriceList.Id            AS PriceListId
           , Object_PriceList.ValueData     AS PriceListName

           , COALESCE (ObjectBoolean_PartnerBarCode.ValueData, FALSE) :: Boolean  AS isPartnerBarCode     
       FROM Object AS Object_Unit
            LEFT JOIN ObjectString AS OS_Unit_Address
                                   ON OS_Unit_Address.ObjectId = Object_Unit.Id
                                  AND OS_Unit_Address.DescId = zc_ObjectString_Unit_Address()
            LEFT JOIN ObjectString AS OS_Unit_Phone
                                   ON OS_Unit_Phone.ObjectId = Object_Unit.Id
                                  AND OS_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()
            LEFT JOIN ObjectString AS OS_Unit_Printer
                                   ON OS_Unit_Printer.ObjectId = Object_Unit.Id
                                  AND OS_Unit_Printer.DescId = zc_ObjectString_Unit_Printer()
            LEFT JOIN ObjectString AS OS_Unit_Print
                                   ON OS_Unit_Print.ObjectId = Object_Unit.Id
                                  AND OS_Unit_Print.DescId = zc_ObjectString_Unit_Print()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartnerBarCode 
                                    ON ObjectBoolean_PartnerBarCode.ObjectId = Object_Unit.Id 
                                   AND ObjectBoolean_PartnerBarCode.DescId = zc_ObjectBoolean_Unit_PartnerBarCode()

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

            LEFT JOIN ObjectLink AS ObjectLink_Unit_BankAccount
                                 ON ObjectLink_Unit_BankAccount.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_BankAccount.DescId = zc_ObjectLink_Unit_BankAccount()
            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Unit_BankAccount.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                 ON ObjectLink_Unit_AccountDirection.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
            LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Unit_AccountDirection.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_GoodsGroup
                                 ON ObjectLink_Unit_GoodsGroup.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_GoodsGroup.DescId = zc_ObjectLink_Unit_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Unit_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList
                                 ON ObjectLink_Unit_PriceList.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_PriceList.DescId = zc_ObjectLink_Unit_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Unit_PriceList.ChildObjectId

      WHERE Object_Unit.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
28.01.20          *
22.03.18          *
05.03.18          *
27.02.18          * Printer
07.06.17          * add AccountDirection
10.05.17                                                          *
08.05.17                                                          *
06.03.17                                                          *
28.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpGet_Object_Unit(1,'2')