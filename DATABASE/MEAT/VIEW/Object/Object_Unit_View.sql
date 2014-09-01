-- View: Object_Unit_View

-- DROP VIEW IF EXISTS Object_Unit_View;

CREATE OR REPLACE VIEW Object_Unit_View AS 
       SELECT 
             Object_Unit.Id           AS Id
           , Object_Unit.DescId
           , Object_Unit.ObjectCode   AS Code
           , Object_Unit.ValueData    AS Name
         
           , ObjectLink_Unit_Parent.ChildObjectId  AS ParentId
           , Object_Parent.ObjectCode AS ParentCode
           , Object_Parent.ValueData  AS ParentName 

           , Object_Business.Id         AS BusinessId
           , Object_Business.ObjectCode AS BusinessCode
           , Object_Business.ValueData  AS BusinessName 
         
           , Object_Branch.Id         AS BranchId
           , Object_Branch.ObjectCode AS BranchCode
           , Object_Branch.ValueData  AS BranchName
         
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ObjectCode AS JuridicalCode
           , Object_Juridical.ValueData  AS JuridicalName

           , ObjectLink_Unit_AccountDirection.ChildObjectId AS AccountDirectionId

           , Object_Unit.AccessKeyId
           , Object_Unit.isErased AS isErased
           , ObjectBoolean_isLeaf.ValueData AS isLeaf
       FROM Object AS Object_Unit
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
           LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                ON ObjectLink_Unit_Business.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
           LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Unit_Business.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
         
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
         
           LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                ON ObjectLink_Unit_AccountDirection.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                   ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                                  AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()
               WHERE Object_Unit.DescId = zc_Object_Unit();

ALTER TABLE Object_Unit_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 09.11.13                                        * del ProfitLossDirection
 09.11.13                                        * add DescId
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Unit_View
