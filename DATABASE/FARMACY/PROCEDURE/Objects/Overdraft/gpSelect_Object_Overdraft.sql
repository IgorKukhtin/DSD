-- Function: gpSelect_Object_Overdraft(Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Overdraft (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Overdraft(
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
    -- ���������
    RETURN QUERY 
       SELECT
              Object_Overdraft.Id                       AS GoodsID 
            , Object_Overdraft.ObjectCode               AS OverdraftID
            , Object_Overdraft.ValueData                AS OverdraftName
            , Object_Overdraft.isErased                 AS isErased
       FROM Object AS Object_Overdraft

       WHERE Object_Overdraft.DescId = zc_Object_Overdraft()
         AND (Object_Overdraft.isErased = False OR inIsShowAll = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  ALTER FUNCTION gpSelect_Object_Overdraft (Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������ �.�.
 27.08.18         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Overdraft (False, zfCalc_UserAdmin()) ORDER BY Code