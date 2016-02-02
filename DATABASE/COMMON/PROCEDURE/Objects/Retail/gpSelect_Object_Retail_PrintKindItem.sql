-- Function: gpSelect_Object_Retail_PrintKindItem

DROP FUNCTION IF EXISTS gpSelect_Object_Retail_PrintKindItem ( TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Retail_PrintKindItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Retail_PrintKindItem(
    IN inBranchId    Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , BranchId Integer, BranchName TVarChar
             , isMovement boolean, isAccount boolean, isTransport boolean
             , isQuality boolean, isPack boolean, isSpec boolean, isTax boolean , isTransportBill boolean
             , CountMovement Tfloat, CountAccount Tfloat, CountTransport Tfloat
             , CountQuality Tfloat, CountPack Tfloat, CountSpec Tfloat, CountTax Tfloat, CountTransportBill Tfloat
             , isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());


       RETURN QUERY 
       WITH tmpPrintKindItem AS( SELECT tmp.Id
                                      , tmp.isMovement, tmp.isAccount, tmp.isTransport
                                      , tmp.isQuality, tmp.isPack, tmp.isSpec, tmp.isTax, tmp.isTransportBill
                                      , tmp.CountMovement, tmp.CountAccount, tmp.CountTransport
                                      , tmp.CountQuality, tmp.CountPack, tmp.CountSpec, tmp.CountTax, tmp.CountTransportBill
                                 FROM lpSelect_Object_PrintKindItem() AS tmp
                                )
           , tmpRetailBranch AS (SELECT ObjectLink_Branch.ObjectId        AS Id 
                                      , ObjectLink_Retail.ChildObjectId   AS RetailId
                                      , ObjectLink_Branch.ChildObjectId   AS BranchId
                                      , ObjectLink_PrintKindItem.ChildObjectId AS PrintKindItemId
                                 FROM ObjectLink AS ObjectLink_Branch
                                     INNER JOIN ObjectLink AS ObjectLink_Retail
                                                           ON ObjectLink_Retail.ObjectId = ObjectLink_Branch.ObjectId 
                                                          AND ObjectLink_Retail.DescId = zc_ObjectLink_BranchPrintKindItem_Retail()
                                     LEFT JOIN ObjectLink AS ObjectLink_PrintKindItem
                                                          ON ObjectLink_PrintKindItem.ObjectId = ObjectLink_Retail.ObjectId
                                                         AND ObjectLink_PrintKindItem.DescId = zc_ObjectLink_BranchPrintKindItem_PrintKindItem()
                                 WHERE ObjectLink_Branch.ChildObjectId = inBranchId
                                   AND ObjectLink_Branch.DescId = zc_ObjectLink_BranchPrintKindItem_Branch()
                                 )


       SELECT 
             Object_Retail.Id         AS Id
           , Object_Retail.ObjectCode AS Code
           , Object_Retail.ValueData  AS NAME

           , Object_Branch.Id         AS BranchId
           , Object_Branch.ValueData  AS BranchName

           , COALESCE (tmpPrintKindItem.isMovement, CAST (False AS Boolean))   AS isMovement
           , COALESCE (tmpPrintKindItem.isAccount, CAST (False AS Boolean))    AS isAccount
           , COALESCE (tmpPrintKindItem.isTransport, CAST (False AS Boolean))  AS isTransport
           , COALESCE (tmpPrintKindItem.isQuality, CAST (False AS Boolean))    AS isQuality
           , COALESCE (tmpPrintKindItem.isPack, CAST (False AS Boolean))       AS isPack
           , COALESCE (tmpPrintKindItem.isSpec, CAST (False AS Boolean))       AS isSpec
           , COALESCE (tmpPrintKindItem.isTax, CAST (False AS Boolean))        AS isTax
           , COALESCE (tmpPrintKindItem.isTransportBill, CAST (False AS Boolean))  AS isTransportBill

           , COALESCE (tmpPrintKindItem.CountMovement, CAST (0 AS TFloat))   AS CountMovement
           , COALESCE (tmpPrintKindItem.CountAccount, CAST (0 AS TFloat))    AS CountAccount
           , COALESCE (tmpPrintKindItem.CountTransport, CAST (0 AS TFloat))  AS CountTransport
           , COALESCE (tmpPrintKindItem.CountQuality, CAST (0 AS TFloat))    AS CountQuality
           , COALESCE (tmpPrintKindItem.CountPack, CAST (0 AS TFloat))       AS CountPack
           , COALESCE (tmpPrintKindItem.CountSpec, CAST (0 AS TFloat))       AS CountSpec
           , COALESCE (tmpPrintKindItem.CountTax, CAST (0 AS TFloat))        AS CountTax
           , COALESCE (tmpPrintKindItem.CountTransportBill, CAST (0 AS TFloat))  AS CountTransportBill

           , Object_Retail.isErased   AS isErased
       FROM tmpRetailBranch
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpRetailBranch.RetailId
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpRetailBranch.BranchId
	LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id =  tmpRetailBranch.PrintKindItemId
     
     UNION
       SELECT 
             Object_Retail.Id         AS Id
           , Object_Retail.ObjectCode AS Code
           , Object_Retail.ValueData  AS NAME

           , Object_Branch.Id         AS BranchId
           , Object_Branch.ValueData  AS BranchName

           , COALESCE (tmpPrintKindItem.isMovement, CAST (False AS Boolean))   AS isMovement
           , COALESCE (tmpPrintKindItem.isAccount, CAST (False AS Boolean))    AS isAccount
           , COALESCE (tmpPrintKindItem.isTransport, CAST (False AS Boolean))  AS isTransport
           , COALESCE (tmpPrintKindItem.isQuality, CAST (False AS Boolean))    AS isQuality
           , COALESCE (tmpPrintKindItem.isPack, CAST (False AS Boolean))       AS isPack
           , COALESCE (tmpPrintKindItem.isSpec, CAST (False AS Boolean))       AS isSpec
           , COALESCE (tmpPrintKindItem.isTax, CAST (False AS Boolean))        AS isTax
           , COALESCE (tmpPrintKindItem.isTransportBill, CAST (False AS Boolean))  AS isTransportBill

           , COALESCE (tmpPrintKindItem.CountMovement, CAST (0 AS TFloat))   AS CountMovement
           , COALESCE (tmpPrintKindItem.CountAccount, CAST (0 AS TFloat))    AS CountAccount
           , COALESCE (tmpPrintKindItem.CountTransport, CAST (0 AS TFloat))  AS CountTransport
           , COALESCE (tmpPrintKindItem.CountQuality, CAST (0 AS TFloat))    AS CountQuality
           , COALESCE (tmpPrintKindItem.CountPack, CAST (0 AS TFloat))       AS CountPack
           , COALESCE (tmpPrintKindItem.CountSpec, CAST (0 AS TFloat))       AS CountSpec
           , COALESCE (tmpPrintKindItem.CountTax, CAST (0 AS TFloat))        AS CountTax
           , COALESCE (tmpPrintKindItem.CountTransportBill, CAST (0 AS TFloat))  AS CountTransportBill
          
           , Object_Retail.isErased   AS isErased

      FROM OBJECT AS Object_Retail
        LEFT JOIN ObjectLink AS ObjectLink_Retail
                             ON ObjectLink_Retail.ChildObjectId = Object_Retail.Id 
                            AND ObjectLink_Retail.DescId = zc_ObjectLink_BranchPrintKindItem_Retail()
        LEFT JOIN ObjectLink AS ObjectLink_Branch
                             ON ObjectLink_Branch.ObjectId = ObjectLink_Retail.ObjectId
                            AND ObjectLink_Branch.ChildObjectId = zc_Branch_Basis() --zc_Main_Branch()
                            AND ObjectLink_Branch.DescId = zc_ObjectLink_BranchPrintKindItem_Branch()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Branch.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_PrintKindItem
                             ON ObjectLink_PrintKindItem.ObjectId = ObjectLink_Branch.ObjectId
                            AND ObjectLink_PrintKindItem.DescId = zc_ObjectLink_BranchPrintKindItem_PrintKindItem()
	LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id =  ObjectLink_PrintKindItem.ChildObjectId

        LEFT JOIN tmpRetailBranch on tmpRetailBranch.RetailId = ObjectLink_Retail.ChildObjectId
  
      WHERE Object_Retail.DescId = Zc_Object_Retail()
        AND tmpRetailBranch.BranchId is null;
--      AND Object_Retail.Id not in (select tmp.RetailId from tmpRetailBranch as tmp );

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.02.16         *
 19.01.16         * add кол-ва накладных
 20.05.15         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Retail_PrintKindItem ( zfCalc_UserAdmin())
