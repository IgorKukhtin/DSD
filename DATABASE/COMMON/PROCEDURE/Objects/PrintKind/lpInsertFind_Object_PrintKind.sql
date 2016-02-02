-- Function: lpInsertFind_Object_PrintKindItem (Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PrintKindItem (Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean);
DROP FUNCTION IF EXISTS lpInsertFind_Object_PrintKindItem (Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS lpInsertFind_Object_PrintKindItem (Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);


CREATE OR REPLACE FUNCTION lpInsertFind_Object_PrintKindItem(
    IN inIsMovement      Boolean,   -- ���������
    IN inIsAccount       Boolean,   -- ����
    IN inIsTransport     Boolean,   -- ���
    IN inIsQuality       Boolean,   -- ������������
    IN inIsPack          Boolean,   -- �����������
    IN inIsSpec          Boolean,   -- ������������
    IN inIsTax           Boolean,   -- ���������
    IN inIsTransportBill Boolean,   -- ������������
    IN inCountMovement   TFloat,   -- ���������
    IN inCountAccount    TFloat,   -- ����
    IN inCountTransport  TFloat,   -- ���
    IN inCountQuality    TFloat,   -- ������������
    IN inCountPack       TFloat,   -- �����������
    IN inCountSpec       TFloat,   -- ������������
    IN inCountTax        TFloat,   -- ���������
    IN inCountTransportBill TFloat -- ������������
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
                         FROM     (SELECT zc_Enum_PrintKind_Movement()  :: TVarChar || '+' || CASE WHEN inCountMovement  > 0 THEN inCountMovement  ELSE 2 END :: TVarChar AS ValueId WHERE inIsMovement = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Account()   :: TVarChar || '+' || CASE WHEN inCountAccount   > 0 THEN inCountAccount   ELSE 1 END :: TVarChar AS ValueId WHERE inIsAccount = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Transport() :: TVarChar || '+' || CASE WHEN inCountTransport > 0 THEN inCountTransport ELSE 1 END :: TVarChar AS ValueId WHERE inIsTransport = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Quality()   :: TVarChar || '+' || CASE WHEN inCountQuality   > 0 THEN inCountQuality   ELSE 1 END :: TVarChar AS ValueId WHERE inIsQuality = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Pack()      :: TVarChar || '+' || CASE WHEN inCountPack      > 0 THEN inCountPack      ELSE 1 END :: TVarChar AS ValueId WHERE inIsPack = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Spec()      :: TVarChar || '+' || CASE WHEN inCountSpec      > 0 THEN inCountSpec      ELSE 1 END :: TVarChar AS ValueId WHERE inIsSpec = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_Tax()       :: TVarChar || '+' || CASE WHEN inCountTax       > 0 THEN inCountTax       ELSE 1 END :: TVarChar AS ValueId WHERE inIsTax = TRUE
                         UNION ALL SELECT zc_Enum_PrintKind_TransportBill() :: TVarChar || '+' || CASE WHEN inCountTransportBill > 0 THEN inCountTransportBill ELSE 1 END :: TVarChar AS ValueId WHERE inIsTransportBill = TRUE
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

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.16         * add TransportBill
 20.05.15                                        *
*/

-- ����
-- SELECT * FROM Object WHERE DescId = zc_Object_PrintKind()
-- SELECT * FROM Object WHERE DescId = zc_Object_PrintKindItem()
-- SELECT * FROM lpInsertFind_Object_PrintKindItem (TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
