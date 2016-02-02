-- Function: lpSelect_Object_PrintKindItem ()

DROP FUNCTION IF EXISTS lpSelect_Object_PrintKindItem (TVarChar);
DROP FUNCTION IF EXISTS lpSelect_Object_PrintKindItem ();

CREATE OR REPLACE FUNCTION lpSelect_Object_PrintKindItem(
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isMovement      Boolean   -- Накладная
             , isAccount       Boolean   -- Счет
             , isTransport     Boolean   -- ТТН
             , isQuality       Boolean   -- Качественное
             , isPack          Boolean   -- Упаковочный
             , isSpec          Boolean   -- Спецификация
             , isTax           Boolean   -- Налоговая
             , isTransportBill Boolean   -- Транспортная
             , CountMovement   TFloat    -- Накладная
             , CountAccount    TFloat    -- Счет
             , CountTransport  TFloat    -- ТТН
             , CountQuality    TFloat    -- Качественное
             , CountPack       TFloat    -- Упаковочный
             , CountSpec       TFloat    -- Спецификация
             , CountTax        TFloat    -- Налоговая
             , CountTransportBill TFloat    -- Транспортная
             , isErased        Boolean
             ) AS
$BODY$
BEGIN

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_PrintKindItem.Id              AS Id
           , Object_PrintKindItem.ObjectCode      AS Code
           , Object_PrintKindItem.ValueData       AS Name
           
           , Object_PrintKindItem.isMovement
           , Object_PrintKindItem.isAccount
           , Object_PrintKindItem.isTransport
           , Object_PrintKindItem.isQuality
           , Object_PrintKindItem.isPack
           , Object_PrintKindItem.isSpec
           , Object_PrintKindItem.isTax
           , Object_PrintKindItem.isTransportBill

           , CASE WHEN MovementPos  > 0 THEN LEFT (MovementStr,  STRPOS (MovementStr,  ';') - 1) :: TFloat ELSE 0 END :: TFloat AS CountMovement
           , CASE WHEN AccountPos   > 0 THEN LEFT (AccountStr,   STRPOS (AccountStr,   ';') - 1) :: TFloat ELSE 0 END :: TFloat AS CountAccount
           , CASE WHEN TransportPos > 0 THEN LEFT (TransportStr, STRPOS (TransportStr, ';') - 1) :: TFloat ELSE 0 END :: TFloat AS CountTransport
           , CASE WHEN QualityPos   > 0 THEN LEFT (QualityStr,   STRPOS (QualityStr,   ';') - 1) :: TFloat ELSE 0 END :: TFloat AS CountQuality
           , CASE WHEN PackPos      > 0 THEN LEFT (PackStr,      STRPOS (PackStr,      ';') - 1) :: TFloat ELSE 0 END :: TFloat AS CountPack
           , CASE WHEN SpecPos      > 0 THEN LEFT (SpecStr,      STRPOS (SpecStr,      ';') - 1) :: TFloat ELSE 0 END :: TFloat AS CountSpec
           , CASE WHEN TaxPos       > 0 THEN LEFT (TaxStr,       STRPOS (TaxStr,       ';') - 1) :: TFloat ELSE 0 END :: TFloat AS CountTax
           , CASE WHEN TransportBillPos > 0 THEN LEFT (TransportBillStr, STRPOS (TransportBillStr, ';') - 1) :: TFloat ELSE 0 END :: TFloat AS CountTransportBill

           , Object_PrintKindItem.isErased

      FROM
     (SELECT Object_PrintKindItem.*
           , CASE WHEN MovementPos  > 0 THEN TRUE ELSE FALSE END AS isMovement
           , CASE WHEN AccountPos   > 0 THEN TRUE ELSE FALSE END AS isAccount
           , CASE WHEN TransportPos > 0 THEN TRUE ELSE FALSE END AS isTransport
           , CASE WHEN QualityPos   > 0 THEN TRUE ELSE FALSE END AS isQuality
           , CASE WHEN PackPos      > 0 THEN TRUE ELSE FALSE END AS isPack
           , CASE WHEN SpecPos      > 0 THEN TRUE ELSE FALSE END AS isSpec
           , CASE WHEN TaxPos       > 0 THEN TRUE ELSE FALSE END AS isTax
           , CASE WHEN TransportBillPos > 0 THEN TRUE ELSE FALSE END AS isTransportBill

           , CASE WHEN MovementPos  > 0 THEN RIGHT (ValueData, LENGTH (ValueData) + 1 - MovementPos  - LENGTH (MovementFind))  ELSE '' END AS MovementStr
           , CASE WHEN AccountPos   > 0 THEN RIGHT (ValueData, LENGTH (ValueData) + 1 - AccountPos   - LENGTH (AccountFind))   ELSE '' END AS AccountStr
           , CASE WHEN TransportPos > 0 THEN RIGHT (ValueData, LENGTH (ValueData) + 1 - TransportPos - LENGTH (TransportFind)) ELSE '' END AS TransportStr
           , CASE WHEN QualityPos   > 0 THEN RIGHT (ValueData, LENGTH (ValueData) + 1 - QualityPos   - LENGTH (QualityFind))   ELSE '' END AS QualityStr
           , CASE WHEN PackPos      > 0 THEN RIGHT (ValueData, LENGTH (ValueData) + 1 - PackPos      - LENGTH (PackFind))      ELSE '' END AS PackStr
           , CASE WHEN SpecPos      > 0 THEN RIGHT (ValueData, LENGTH (ValueData) + 1 - SpecPos      - LENGTH (SpecFind))      ELSE '' END AS SpecStr
           , CASE WHEN TaxPos       > 0 THEN RIGHT (ValueData, LENGTH (ValueData) + 1 - TaxPos       - LENGTH (TaxFind))       ELSE '' END AS TaxStr
           , CASE WHEN TransportBillPos > 0 THEN RIGHT (ValueData, LENGTH (ValueData) + 1 - TransportBillPos - LENGTH (TransportBillFind)) ELSE '' END AS TransportBillStr
      FROM
     (SELECT Object_PrintKindItem.*
           , STRPOS (Object_PrintKindItem.ValueData, MovementFind)  AS MovementPos
           , STRPOS (Object_PrintKindItem.ValueData, AccountFind)   AS AccountPos
           , STRPOS (Object_PrintKindItem.ValueData, TransportFind) AS TransportPos
           , STRPOS (Object_PrintKindItem.ValueData, QualityFind)   AS QualityPos
           , STRPOS (Object_PrintKindItem.ValueData, PackFind)      AS PackPos
           , STRPOS (Object_PrintKindItem.ValueData, SpecFind)      AS SpecPos
           , STRPOS (Object_PrintKindItem.ValueData, TaxFind)       AS TaxPos
           , STRPOS (Object_PrintKindItem.ValueData, TransportBillFind) AS TransportBillPos

      FROM
     (SELECT Object_PrintKindItem.*
           , ';' || zc_Enum_PrintKind_Movement()  :: TVarChar || '+' AS MovementFind
           , ';' || zc_Enum_PrintKind_Account()   :: TVarChar || '+' AS AccountFind
           , ';' || zc_Enum_PrintKind_Transport() :: TVarChar || '+' AS TransportFind
           , ';' || zc_Enum_PrintKind_Quality()   :: TVarChar || '+' AS QualityFind
           , ';' || zc_Enum_PrintKind_Pack()      :: TVarChar || '+' AS PackFind
           , ';' || zc_Enum_PrintKind_Spec()      :: TVarChar || '+' AS SpecFind
           , ';' || zc_Enum_PrintKind_Tax()       :: TVarChar || '+' AS TaxFind
           , ';' || zc_Enum_PrintKind_TransportBill() :: TVarChar || '+' AS TransportBillFind
      FROM Object AS Object_PrintKindItem
      WHERE Object_PrintKindItem.DescId = zc_Object_PrintKindItem()
      ) AS Object_PrintKindItem
      ) AS Object_PrintKindItem
      ) AS Object_PrintKindItem
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSelect_Object_PrintKindItem () OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.16         * add  TransportBill
 20.05.15                                        *
*/

-- тест
-- SELECT * FROM lpSelect_Object_PrintKindItem ()
