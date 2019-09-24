-- Function: gpGet_Object_PayrollType()

DROP FUNCTION IF EXISTS gpGet_Object_PayrollType(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PayrollType(
    IN inId          Integer,       -- ���� ������� <>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ShortName TVarChar
             , PayrollGroupID Integer, PayrollGroupName TVarChar
             , Percent TFloat, MinAccrualAmount TFloat
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PayrollType());
   
   IF inId < 0
   THEN
     RAISE EXCEPTION '������. ��������� ��������� �������  ���������.';
   END IF;

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PayrollType()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS ShortName
           
           , CAST (0 as Integer)    AS PayrollGroupID
           , CAST ('' as TVarChar)  AS PayrollGroupName
           , CAST (Null as TFloat)  AS Percent
           , CAST (Null as TFloat)  AS MinAccrualAmount 

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_PayrollType.Id                       AS Id
           , Object_PayrollType.ObjectCode               AS Code
           , Object_PayrollType.ValueData                AS Name

           , ObjectString_ShortName.ValueData            AS ShortName

           , Object_PayrollGroup.ID                      AS PayrollGroupID
           , Object_PayrollGroup.ValueData               AS PayrollGroupName
           , ObjectFloat_Percent.ValueData               AS Percent
           , ObjectFloat_MinAccrualAmount.ValueData      AS MinAccrualAmount 

           , Object_PayrollType.isErased                 AS isErased

       FROM Object AS Object_PayrollType
            LEFT JOIN ObjectLink AS ObjectLink_Goods_PayrollGroup
                                 ON ObjectLink_Goods_PayrollGroup.ObjectId = Object_PayrollType.Id
                                AND ObjectLink_Goods_PayrollGroup.DescId = zc_ObjectLink_PayrollType_PayrollGroup()
            LEFT JOIN Object AS Object_PayrollGroup ON Object_PayrollGroup.Id = ObjectLink_Goods_PayrollGroup.ChildObjectId
   
            LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                  ON ObjectFloat_Percent.ObjectId = Object_PayrollType.Id
                                 AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PayrollType_Percent()

            LEFT JOIN ObjectFloat AS ObjectFloat_MinAccrualAmount
                                  ON ObjectFloat_MinAccrualAmount.ObjectId = Object_PayrollType.Id
                                 AND ObjectFloat_MinAccrualAmount.DescId = zc_ObjectFloat_PayrollType_MinAccrualAmount()

            LEFT JOIN ObjectString AS ObjectString_ShortName
                                   ON ObjectString_ShortName.ObjectId = Object_PayrollType.Id 
                                  AND ObjectString_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

       WHERE Object_PayrollType.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.09.19                                                        *
 22.08.19                                                        *

*/

-- ����
-- SELECT * FROM gpGet_Object_PayrollType (0, '3')