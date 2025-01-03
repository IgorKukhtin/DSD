-- View: Object_Unit_View

DROP VIEW IF EXISTS Object_Unit_View;

CREATE OR REPLACE VIEW Object_Unit_View AS 
    SELECT 
        Object_Unit.Id                                     AS Id
      , Object_Unit.DescId                                 AS DescId
      , Object_Unit.ObjectCode                             AS Code
      , Object_Unit.ValueData                              AS Name

      , COALESCE(ObjectLink_Unit_Parent.ChildObjectId,0)   AS ParentId
      , Object_Parent.ObjectCode                           AS ParentCode
      , Object_Parent.ValueData                            AS ParentName 

      , ObjectLink_Unit_Juridical.ChildObjectId            AS JuridicalId
      , Object_Juridical.ObjectCode                        AS JuridicalCode
      , Object_Juridical.ValueData                         AS JuridicalName

      , Object_Unit.AccessKeyId                            AS AccessKeyId
      , Object_Unit.isErased                               AS isErased
      , ObjectBoolean_isLeaf.ValueData                     AS isLeaf
      , 0                                                  AS BranchId
      , ObjectLink_Unit_Area.ChildObjectId                 AS AreaId
      
      , ObjectLink_Unit_MarginCategory.ChildObjectId       AS MarginCategoryId
      , Object_MarginCategory.ObjectCode                   AS MarginCategoryCode
      , Object_MarginCategory.ValueData                    AS MarginCategoryName

    FROM Object AS Object_Unit
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent 
                         ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_Juridical 
                         ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
         
        LEFT JOIN ObjectLink AS ObjectLink_Unit_MarginCategory
                             ON ObjectLink_Unit_MarginCategory.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_MarginCategory.DescId = zc_ObjectLink_Unit_MarginCategory()
        LEFT JOIN Object AS Object_MarginCategory
                         ON Object_MarginCategory.Id = ObjectLink_Unit_MarginCategory.ChildObjectId
        
        LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                             ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()

    WHERE 
        Object_Unit.DescId = zc_Object_Unit();

ALTER TABLE Object_Unit_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.11.13                                        * del ProfitLossDirection
 09.11.13                                        * add DescId
*/

-- ����
-- SELECT * FROM Object_Unit_View
