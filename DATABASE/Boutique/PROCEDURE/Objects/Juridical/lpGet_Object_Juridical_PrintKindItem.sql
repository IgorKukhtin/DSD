-- Function: lpGet_Object_Juridical_PrintKindItem()

DROP FUNCTION IF EXISTS lpGet_Object_Juridical_PrintKindItem (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpGet_Object_Juridical_PrintKindItem (Integer);

CREATE OR REPLACE FUNCTION lpGet_Object_Juridical_PrintKindItem(
    IN inId          Integer        -- ����������� ���� 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , RetailId Integer, RetailName TVarChar
             , PrintKindItemId Integer, PrintKindItemName TVarChar
             , isMovement   Boolean   -- ���������
             , isAccount    Boolean   -- ����
             , isTransport  Boolean   -- ���
             , isQuality    Boolean   -- ������������
             , isPack       Boolean   -- �����������
             , isSpec       Boolean   -- ������������
             , isTax        Boolean   -- ���������
             , CountMovement   TFloat    -- ���������
             , CountAccount    TFloat    -- ����
             , CountTransport  TFloat    -- ���
             , CountQuality    TFloat    -- ������������
             , CountPack       TFloat    -- �����������
             , CountSpec       TFloat    -- ������������
             , CountTax        TFloat    -- ���������
               ) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_Juridical_PrintKindItem());
     
       RETURN QUERY
       WITH tmpPrintKindItem AS (SELECT * FROM lpSelect_Object_PrintKindItem())
       SELECT
             Object_Juridical.Id             AS Id
           , Object_Juridical.ObjectCode     AS Code
           , Object_Juridical.ValueData      AS Name

           , Object_Retail.Id                AS RetailId
           , Object_Retail.ValueData         AS RetailName

           , tmpPrintKindItem.Id             AS PrintKindItemId
           , tmpPrintKindItem.Name           AS PrintKindItemName

           , tmpPrintKindItem.isMovement
           , tmpPrintKindItem.isAccount
           , tmpPrintKindItem.isTransport
           , tmpPrintKindItem.isQuality
           , tmpPrintKindItem.isPack
           , tmpPrintKindItem.isSpec
           , tmpPrintKindItem.isTax

           , tmpPrintKindItem.CountMovement
           , tmpPrintKindItem.CountAccount
           , tmpPrintKindItem.CountTransport
           , tmpPrintKindItem.CountQuality
           , tmpPrintKindItem.CountPack
           , tmpPrintKindItem.CountSpec
           , tmpPrintKindItem.CountTax

       FROM Object AS Object_Juridical
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Retail_PrintKindItem
                                 ON ObjectLink_Retail_PrintKindItem.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                AND ObjectLink_Retail_PrintKindItem.DescId = zc_ObjectLink_Retail_PrintKindItem()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_PrintKindItem
                                 ON ObjectLink_Juridical_PrintKindItem.ObjectId = Object_Juridical.Id
                                AND ObjectLink_Juridical_PrintKindItem.DescId = zc_ObjectLink_Juridical_PrintKindItem()

            LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id = CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId > 0 THEN ObjectLink_Retail_PrintKindItem.ChildObjectId ELSE ObjectLink_Juridical_PrintKindItem.ChildObjectId END

       WHERE Object_Juridical.Id = inId;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpGet_Object_Juridical_PrintKindItem (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.05.15                                        *
*/

-- ����
-- SELECT * FROM lpGet_Object_Juridical_PrintKindItem (1)
