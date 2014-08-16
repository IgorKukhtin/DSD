-- View: Object_Unit_View

DROP VIEW IF EXISTS Object_BranchLink_View;

CREATE OR REPLACE VIEW Object_BranchLink_View AS 
SELECT BranchLink.id,
       BranchLink.objectcode,
       BranchLink.valuedata,
       BranchLink_Branch.childobjectid AS BranchId,
       Branch.valuedata AS BranchName,
       BranchLink_PaidKind.childobjectid AS PaidKindId,
       PaidKind.valuedata AS PaidKindName,
       (Branch.valuedata||' '||COALESCE(PaidKind.valuedata, ''))::TVarChar AS BranchLinkName
 FROM Object AS BranchLink
      LEFT JOIN ObjectLink AS BranchLink_Branch ON BranchLink_Branch.ObjectId = BranchLink.Id
                          AND BranchLink_Branch.descid = zc_ObjectLink_BranchLink_Branch()
      LEFT JOIN OBJECT AS Branch ON Branch.Id = BranchLink_Branch.ChildObjectId                    
      
      LEFT JOIN ObjectLink AS BranchLink_PaidKind ON BranchLink_PaidKind.ObjectId = BranchLink.Id
                          AND BranchLink_PaidKind.descid = zc_ObjectLink_BranchLink_PaidKind()
      LEFT JOIN OBJECT AS PaidKind ON PaidKind.Id = BranchLink_PaidKind.ChildObjectId                    

WHERE BranchLink.descid = zc_Object_BranchLink();

ALTER TABLE Object_BranchLink_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.06.14                        * 
*/

-- тест
-- SELECT * FROM Object_Unit_View
