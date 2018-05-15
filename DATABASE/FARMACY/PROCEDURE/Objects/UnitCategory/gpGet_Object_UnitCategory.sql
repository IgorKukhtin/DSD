-- Function: gpGet_Object_UnitCategory()

DROP FUNCTION IF EXISTS gpGet_Object_UnitCategory(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_UnitCategory(
    IN inId          Integer,       -- ���� ������� <������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PenaltyNonMinPlan TFloat
             , PremiumImplPlan TFloat
             , MinLineByLineImplPlan TFloat
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_UnitCategory()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS TFloat)  AS PenaltyNonMinPlan
           , CAST (NULL AS TFloat)  AS PremiumImplPlan
           , CAST (NULL AS TFloat)  AS MinLineByLineImplPlan
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_UnitCategory.Id                       AS Id
           , Object_UnitCategory.ObjectCode               AS Code
           , Object_UnitCategory.ValueData                AS Name
           , ObjectFloat_PenaltyNonMinPlan.ValueData      AS PenaltyNonMinPlan
           , ObjectFloat_PremiumImplPlan.ValueData        AS PremiumImplPlan
           , ObjectFloat_MinLineByLineImplPlan.ValueData  AS MinLineByLineImplPlan
           , Object_UnitCategory.isErased                 AS isErased

       FROM Object AS Object_UnitCategory

         LEFT JOIN ObjectFloat AS ObjectFloat_PenaltyNonMinPlan
                               ON ObjectFloat_PenaltyNonMinPlan.ObjectId = Object_UnitCategory.Id
                              AND ObjectFloat_PenaltyNonMinPlan.DescId = zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan()

         LEFT JOIN ObjectFloat AS ObjectFloat_PremiumImplPlan
                               ON ObjectFloat_PremiumImplPlan.ObjectId = Object_UnitCategory.Id
                              AND ObjectFloat_PremiumImplPlan.DescId = zc_ObjectFloat_UnitCategory_PremiumImplPlan()

         LEFT JOIN ObjectFloat AS ObjectFloat_MinLineByLineImplPlan
                               ON ObjectFloat_MinLineByLineImplPlan.ObjectId = Object_UnitCategory.Id
                              AND ObjectFloat_MinLineByLineImplPlan.DescId = zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan()

       WHERE Object_UnitCategory.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������ �.�.
 15.05.18         *
 05.05.18         *

*/

-- ����
-- SELECT * FROM gpGet_Object_UnitCategory (1, '3')