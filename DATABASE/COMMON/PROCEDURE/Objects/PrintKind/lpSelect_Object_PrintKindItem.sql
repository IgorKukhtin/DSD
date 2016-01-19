-- Function: lpSelect_Object_PrintKindItem ()

DROP FUNCTION IF EXISTS lpSelect_Object_PrintKindItem (TVarChar);
DROP FUNCTION IF EXISTS lpSelect_Object_PrintKindItem ();

CREATE OR REPLACE FUNCTION lpSelect_Object_PrintKindItem(
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isMovement      Boolean   -- ���������
             , isAccount       Boolean   -- ����
             , isTransport     Boolean   -- ���
             , isQuality       Boolean   -- ������������
             , isPack          Boolean   -- �����������
             , isSpec          Boolean   -- ������������
             , isTax           Boolean   -- ���������
             , CountMovement   TFloat    -- ���������
             , CountAccount    TFloat    -- ����
             , CountTransport  TFloat    -- ���
             , CountQuality    TFloat    -- ������������
             , CountPack       TFloat    -- �����������
             , CountSpec       TFloat    -- ������������
             , CountTax        TFloat    -- ���������
             , isErased        Boolean
             ) AS
$BODY$
BEGIN

     -- ���������
     RETURN QUERY 
       SELECT 
             Object_PrintKindItem.Id              AS Id
           , Object_PrintKindItem.ObjectCode      AS Code
           , Object_PrintKindItem.ValueData       AS Name
           
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Movement()  :: TVarChar|| ';') > 0 THEN TRUE ELSE FALSE END AS isMovement
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Account()   :: TVarChar|| ';') > 0 THEN TRUE ELSE FALSE END AS isAccount
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Transport() :: TVarChar|| ';') > 0 THEN TRUE ELSE FALSE END AS isTransport
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Quality()   :: TVarChar|| ';') > 0 THEN TRUE ELSE FALSE END AS isQuality
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Pack()      :: TVarChar|| ';') > 0 THEN TRUE ELSE FALSE END AS isPack
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Spec()      :: TVarChar|| ';') > 0 THEN TRUE ELSE FALSE END AS isSpec
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Tax()       :: TVarChar|| ';') > 0 THEN TRUE ELSE FALSE END AS isTax

           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Movement()  :: TVarChar|| ';') > 0 THEN 1 ELSE 0 END :: TFloat AS CountMovement
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Account()   :: TVarChar|| ';') > 0 THEN 1 ELSE 0 END :: TFloat AS CountAccount
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Transport() :: TVarChar|| ';') > 0 THEN 1 ELSE 0 END :: TFloat AS CountTransport
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Quality()   :: TVarChar|| ';') > 0 THEN 1 ELSE 0 END :: TFloat AS CountQuality
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Pack()      :: TVarChar|| ';') > 0 THEN 1 ELSE 0 END :: TFloat AS CountPack
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Spec()      :: TVarChar|| ';') > 0 THEN 1 ELSE 0 END :: TFloat AS CountSpec
           , CASE WHEN STRPOS (Object_PrintKindItem.ValueData, ';' || zc_Enum_PrintKind_Tax()       :: TVarChar|| ';') > 0 THEN 1 ELSE 0 END :: TFloat AS CountTax

           , Object_PrintKindItem.isErased        AS isErased

      FROM Object AS Object_PrintKindItem
      WHERE Object_PrintKindItem.DescId = zc_Object_PrintKindItem()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSelect_Object_PrintKindItem () OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.05.15                                        *
*/

-- ����
-- SELECT * FROM lpSelect_Object_PrintKindItem ()
