-- Function: gpSelect_Object_DiffKindPrice(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DiffKindPrice(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiffKindPrice(
    IN inDiffKindId  Integer  ,     -- ��� ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DiffKindId Integer
             , MinPrice TFloat
             , Amount TFloat
             , Summa TFloat
             , isErased Boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

   RETURN QUERY 
     SELECT Object_DiffKindPrice.Id                              AS Id
          , Object_DiffKindPrice.ObjectCode                      AS Code
          , Object_DiffKindPrice.ValueData                       AS Name
          , ObjectLink_DiffKind.ChildObjectId                    AS DiffKindId
          , ObjectFloat_DiffKindPrice_MinPrice.ValueData         AS MinPrice
          , ObjectFloat_DiffKindPrice_Amount.ValueData           AS Amount
          , ObjectFloat_DiffKindPrice_Summa.ValueData            AS Summa
          , Object_DiffKindPrice.isErased                        AS isErased
     FROM Object AS Object_DiffKindPrice
          LEFT JOIN ObjectLink AS ObjectLink_DiffKind
                               ON ObjectLink_DiffKind.ObjectId = Object_DiffKindPrice.Id
                              AND ObjectLink_DiffKind.DescId = zc_ObjectLink_DiffKindPrice_DiffKind()   
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKindPrice_MinPrice
                                ON ObjectFloat_DiffKindPrice_MinPrice.ObjectId = Object_DiffKindPrice.Id 
                               AND ObjectFloat_DiffKindPrice_MinPrice.DescId = zc_ObjectFloat_DiffKindPrice_MinPrice() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKindPrice_Amount
                                ON ObjectFloat_DiffKindPrice_Amount.ObjectId = Object_DiffKindPrice.Id 
                               AND ObjectFloat_DiffKindPrice_Amount.DescId = zc_ObjectFloat_DiffKindPrice_Amount() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKindPrice_Summa
                                ON ObjectFloat_DiffKindPrice_Summa.ObjectId = Object_DiffKindPrice.Id 
                               AND ObjectFloat_DiffKindPrice_Summa.DescId = zc_ObjectFloat_DiffKindPrice_Summa() 
     WHERE Object_DiffKindPrice.DescId = zc_Object_DiffKindPrice()
       AND ObjectLink_DiffKind.ChildObjectId = inDiffKindId
     ORDER BY ObjectFloat_DiffKindPrice_MinPrice.ValueData;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.05.22                                                       * 
*/

-- ����
-- 
SELECT * FROM gpSelect_Object_DiffKindPrice(1, '3')