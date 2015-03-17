-- Function: gpSelect_Object_ReceiptChild()

DROP FUNCTION IF EXISTS gpSelect_Object_PrintReceiptChildDetail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PrintReceiptChildDetail(IN ReceiptId integer, IN inSession TVarChar)

RETURNS TABLE (MainReceiptId Integer, GoodsCode Integer, GoodsName TVarChar, Value TFloat, ReceiptChildId Integer) AS

$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptChild());
     CREATE TEMP TABLE tmpReceiptTable(id Integer);
     INSERT INTO tmpReceiptTable (Id) VALUES(ReceiptId);

     RETURN QUERY 
      SELECT D.MainReceiptId, Object_Goods_View.GoodsCode, Object_Goods_View.GoodsName, D.Value, D.ReceiptChildId
       FROM lpSelect_Object_ReceiptChildDetail(0) AS D 
         LEFT JOIN Object_Goods_View ON Object_Goods_View.GoodsId = D.GoodsId;


  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PrintReceiptChildDetail (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.03.15                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PrintReceiptChildDetail (354493, '2')

