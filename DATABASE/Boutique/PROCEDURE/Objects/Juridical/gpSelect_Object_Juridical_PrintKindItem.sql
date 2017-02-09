-- Function: gpSelect_Object_Juridical_PrintKindItem()

DROP FUNCTION IF EXISTS gpSelect_Object_Juridical_PrintKindItem (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Juridical_PrintKindItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical_PrintKindItem(
    IN inBranchId       Integer,       --
    IN inSession        TVarChar       -- сессия пользователя

)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               BranchId Integer, BranchName TVarChar,
               JuridicalGroupId Integer, JuridicalGroupName TVarChar,
               RetailId Integer, RetailName TVarChar,
               OKPO TVarChar,
               
               isMovement boolean, isAccount boolean, isTransport boolean,
               isQuality boolean, isPack boolean, isSpec boolean, isTax boolean, isTransportBill boolean,  


               CountMovement Tfloat, CountAccount Tfloat, CountTransport Tfloat,
               CountQuality Tfloat, CountPack Tfloat, CountSpec Tfloat, CountTax Tfloat, CountTransportBill Tfloat,  

               isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbObjectId_Branch_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Juridical());
   vbUserId:= lpGetUserBySession (inSession);


   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId);
   vbObjectId_Branch_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0 OR COALESCE (vbObjectId_Branch_Constraint, 0) > 0;


   -- Результат
   RETURN QUERY
   WITH tmpListBranch_Constraint AS (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Unit_Branch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                                ON ObjectLink_Partner_PersonalTrade.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Branch_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                     GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                                    UNION
                                     SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Unit_Branch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                                ON ObjectLink_Contract_Personal.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                               AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                                ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_Personal.ObjectId
                                                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Branch_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                     GROUP BY ObjectLink_Contract_Juridical.ChildObjectId
                                    )

  , tmpPrintKindItem AS( SELECT tmp.Id
                              , tmp.isMovement, tmp.isAccount, tmp.isTransport
                              , tmp.isQuality, tmp.isPack, tmp.isSpec, tmp.isTax, tmp.isTransportBill
                              , tmp.CountMovement, tmp.CountAccount, tmp.CountTransport
                              , tmp.CountQuality, tmp.CountPack, tmp.CountSpec, tmp.CountTax, tmp.CountTransportBill
                         FROM lpSelect_Object_PrintKindItem() AS tmp
                                )

    , tmpJuridicalBranch AS (
                                SELECT ObjectLink_Branch.ObjectId            AS Id 
                                      , ObjectLink_Juridical.ChildObjectId   AS JuridicalId
                                      , ObjectLink_Branch.ChildObjectId      AS BranchId
                                      , ObjectLink_PrintKindItem.ChildObjectId AS PrintKindItemId
                                 FROM ObjectLink AS ObjectLink_Branch
                                     INNER JOIN ObjectLink AS ObjectLink_Juridical
                                                           ON ObjectLink_Juridical.ObjectId = ObjectLink_Branch.ObjectId 
                                                          AND ObjectLink_Juridical.DescId = zc_ObjectLink_BranchPrintKindItem_Juridical()
                                     LEFT JOIN ObjectLink AS ObjectLink_PrintKindItem
                                                          ON ObjectLink_PrintKindItem.ObjectId = ObjectLink_Juridical.ObjectId
                                                         AND ObjectLink_PrintKindItem.DescId = zc_ObjectLink_BranchPrintKindItem_PrintKindItem()
                                 WHERE ObjectLink_Branch.ChildObjectId in (inBranchId,zc_Branch_Basis())
                                   AND ObjectLink_Branch.DescId = zc_ObjectLink_BranchPrintKindItem_Branch()
                                 )

           , tmpRetailBranch AS (SELECT ObjectLink_Branch.ObjectId        AS Id 
                                      , ObjectLink_Retail.ChildObjectId   AS RetailId
                                      , ObjectLink_Juridical_Retail.ObjectId AS JuridicalId
                                      , ObjectLink_Branch.ChildObjectId   AS BranchId
                                      , ObjectLink_PrintKindItem.ChildObjectId AS PrintKindItemId
                                 FROM ObjectLink AS ObjectLink_Branch
                                     INNER JOIN ObjectLink AS ObjectLink_Retail
                                                           ON ObjectLink_Retail.ObjectId = ObjectLink_Branch.ObjectId 
                                                          AND ObjectLink_Retail.DescId = zc_ObjectLink_BranchPrintKindItem_Retail()
                                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                           ON ObjectLink_Juridical_Retail.ChildObjectId = ObjectLink_Retail.ChildObjectId      --ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                     LEFT JOIN ObjectLink AS ObjectLink_PrintKindItem
                                                          ON ObjectLink_PrintKindItem.ObjectId = ObjectLink_Retail.ObjectId
                                                         AND ObjectLink_PrintKindItem.DescId = zc_ObjectLink_BranchPrintKindItem_PrintKindItem()
                                 WHERE ObjectLink_Branch.ChildObjectId in (inBranchId,zc_Branch_Basis())
                                   AND ObjectLink_Branch.DescId = zc_ObjectLink_BranchPrintKindItem_Branch()
                                 )
     , tmpListJuridical AS (SELECT tmpRetailBranch.Id, tmpRetailBranch.RetailId, tmpRetailBranch.JuridicalId , tmpRetailBranch.BranchId, tmpRetailBranch.PrintKindItemId
                            FROM tmpRetailBranch
                            WHERE tmpRetailBranch.BranchId = inBranchId
                           UNION 
                            SELECT tmpJuridicalBranch.Id, 0 AS RetailId, tmpJuridicalBranch.JuridicalId , tmpJuridicalBranch.BranchId, tmpJuridicalBranch.PrintKindItemId
                            FROM tmpJuridicalBranch
                            WHERE tmpJuridicalBranch.BranchId = inBranchId
                            --LEFT JOIN tmpRetailBranch ON tmpRetailBranch.JuridicalId = tmpJuridicalBranch.JuridicalId
                            --WHERE tmpJuridicalBranch  is null
                           )
      
          , tmpListMain AS (SELECT tmpRetailBranch.Id, tmpRetailBranch.RetailId, tmpRetailBranch.JuridicalId , tmpRetailBranch.BranchId, tmpRetailBranch.PrintKindItemId
                            FROM tmpRetailBranch
                            WHERE tmpRetailBranch.BranchId = zc_Branch_Basis()
                           UNION 
                            SELECT tmpJuridicalBranch.Id, 0 AS RetailId, tmpJuridicalBranch.JuridicalId , tmpJuridicalBranch.BranchId, tmpJuridicalBranch.PrintKindItemId
                            FROM tmpJuridicalBranch
                            WHERE tmpJuridicalBranch.BranchId = zc_Branch_Basis()
                           )
      


   SELECT 
         Object_Juridical.Id             AS Id 
       , Object_Juridical.ObjectCode     AS Code
       , Object_Juridical.ValueData      AS Name


       --, 0        AS BranchId
       --, 'Филиал'::TVarChar AS BranchName
       , Object_Branch.Id         AS BranchId
       , Object_Branch.ValueData  AS BranchName

       , COALESCE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId, 0)  AS JuridicalGroupId
       , Object_JuridicalGroup.ValueData  AS JuridicalGroupName

       , Object_Retail.Id                AS RetailId
       , Object_Retail.ValueData         AS RetailName

       , ObjectHistory_JuridicalDetails_View.OKPO

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

       , Object_Juridical.isErased AS isErased

   FROM tmpListJuridical
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpListJuridical.JuridicalId
                                            AND Object_Juridical.DescId = zc_Object_Juridical()
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
        LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

        LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.JuridicalId = Object_Juridical.Id

        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpListJuridical.RetailId
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpListJuridical.BranchId
	LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id = tmpListJuridical.PrintKindItemId

    WHERE Object_Juridical.DescId = zc_Object_Juridical()
      AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
           OR tmpListBranch_Constraint.JuridicalId > 0
           OR vbIsConstraint = FALSE)

   UNION 
   SELECT 
         Object_Juridical.Id             AS Id 
       , Object_Juridical.ObjectCode     AS Code
       , Object_Juridical.ValueData      AS Name


       --, 0        AS BranchId
       --, 'Филиал'::TVarChar AS BranchName
       , Object_Branch.Id         AS BranchId
       , Object_Branch.ValueData  AS BranchName

       , COALESCE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId, 0)  AS JuridicalGroupId
       , Object_JuridicalGroup.ValueData  AS JuridicalGroupName

       , Object_Retail.Id                AS RetailId
       , Object_Retail.ValueData         AS RetailName

       , ObjectHistory_JuridicalDetails_View.OKPO

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

       , Object_Juridical.isErased AS isErased   	
       FROM Object AS Object_Juridical
           LEFT JOIN tmpListMain ON tmpListMain.JuridicalId = Object_Juridical.Id
 
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
           LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId
           LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.JuridicalId = Object_Juridical.Id

           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpListMain.BranchId
           LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id = tmpListMain.PrintKindItemId

            LEFT JOIN tmpListJuridical on tmpListJuridical.JuridicalId = tmpListMain.JuridicalId
            
       WHERE Object_Juridical.DescId = zc_Object_Juridical()
         AND tmpListJuridical.PrintKindItemId IS NULL
         AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
           OR tmpListBranch_Constraint.JuridicalId > 0
           OR vbIsConstraint = FALSE)
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.01.16         * add кол-во накладных
 21.05.15         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Juridical_PrintKindItem (0, '2')
