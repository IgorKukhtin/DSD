-- Function: lpInsertFind_Object_PrintKindItem (Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PrintKindItem (Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PrintKindItem(
    IN inIsMovement   Boolean,   -- ���������
    IN inIsAccount    Boolean,   -- ����
    IN inIsTransport  Boolean,   -- ���
    IN inIsQuality    Boolean,   -- ������������
    IN inIsPack       Boolean,   -- �����������
    IN inIsSpec       Boolean,   -- ������������
    IN inIsTax        Boolean    -- ���������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPrintKindItemId Integer;
   DECLARE vbKeyValue TVarChar;
BEGIN
   
     -- !!!������������ ����!!!
     vbKeyValue = (SELECT STRING_AGG (tmp.Value, ';')
                   FROM (SELECT tmp.ValueId :: TVarChar AS Value
                         FROM     (SELECT zc_Enum_PrintKind_Movement()  AS ValueId WHERE inIsMovement = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Account()   AS ValueId WHERE inIsAccount = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Transport() AS ValueId WHERE inIsTransport = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Quality()   AS ValueId WHERE inIsQuality = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Pack()      AS ValueId WHERE inIsPack = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Spec()      AS ValueId WHERE inIsSpec = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Tax()       AS ValueId WHERE inIsTax = TRUE
                                  ) AS tmp
                         ORDER BY tmp.ValueId
                        ) AS tmp
                  );

     -- !!!����������� �����������!!!
     vbKeyValue:= CASE WHEN vbKeyValue <> '' THEN ';' || vbKeyValue || ';' ELSE COALESCE (vbKeyValue, '') END;

     -- ������� 
     vbPrintKindItemId:= (SELECT Object.Id FROM Object WHERE Object.ValueData = vbKeyValue AND Object.DescId = zc_Object_PrintKindItem());

     IF COALESCE (vbPrintKindItemId, 0) = 0
     THEN
           -- ��������� <������>
           vbPrintKindItemId:= lpInsertUpdate_Object (vbPrintKindItemId, zc_Object_PrintKindItem(), 0, vbKeyValue);

     END IF;

     -- ���������� ��������
     RETURN (vbPrintKindItemId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PrintKindItem (Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.05.15                                        *
*/

-- ����
-- SELECT * FROM Object WHERE DescId = zc_Object_PrintKind()
-- SELECT * FROM lpInsertFind_Object_PrintKindItem (TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
