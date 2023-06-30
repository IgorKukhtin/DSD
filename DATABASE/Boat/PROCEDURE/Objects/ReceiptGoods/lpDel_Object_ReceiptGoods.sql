DROP FUNCTION IF EXISTS lpDel_Object_ReceiptGoods(Integer);
DROP FUNCTION IF EXISTS lpDel_Object_ReceiptGoods(Integer, Integer);

CREATE OR REPLACE FUNCTION lpDel_Object_ReceiptGoods(
 IN inReceiptGoodsId_del                  Integer,  -- ключ объекта
 IN inReceiptGoodsId_Main Integer   -- ключ объекта
)
RETURNS Integer
AS
$BODY$
BEGIN

update movementitem set ObjectId = inReceiptGoodsId_Main where  ObjectId = inReceiptGoodsId_del;

update MovementItemLinkObject set ObjectId = inReceiptGoodsId_Main where  ObjectId = inReceiptGoodsId_del;


delete from objectProtocol where ObjectId IN (select ObjectId from ObjectLink where descId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods() and ChildObjectId = inReceiptGoodsId_del);
delete from ObjectLink where ObjectId IN (select ObjectId from ObjectLink where descId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods() and ChildObjectId = inReceiptGoodsId_del);
delete from ObjectString where ObjectId IN (select ObjectId from ObjectLink where descId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods() and ChildObjectId = inReceiptGoodsId_del);
delete from ObjectFloat where ObjectId IN (select ObjectId from ObjectLink where descId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods() and ChildObjectId = inReceiptGoodsId_del);
delete from ObjectDate where ObjectId IN (select ObjectId from ObjectLink where descId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods() and ChildObjectId = inReceiptGoodsId_del);
delete from ObjectBoolean where ObjectId IN (select ObjectId from ObjectLink where descId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods() and ChildObjectId = inReceiptGoodsId_del);
delete from Object where Id IN (select ObjectId from ObjectLink where descId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods() and ChildObjectId = inReceiptGoodsId_del);

delete from objectProtocol where ObjectId = inReceiptGoodsId_del ;
delete from ObjectLink where ObjectId = inReceiptGoodsId_del;
delete from ObjectString where ObjectId = inReceiptGoodsId_del ;
delete from ObjectFloat where ObjectId = inReceiptGoodsId_del  ;
delete from ObjectDate where ObjectId = inReceiptGoodsId_del  ;
delete from ObjectBoolean where ObjectId = inReceiptGoodsId_del  ;
delete from Object where Id = inReceiptGoodsId_del  ;


 return inReceiptGoodsId_Main;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.22         * inUnitId
 11.12.20         * inColorPatternId
 01.12.20         *
*/

-- тест
-- SELECT * FROM lpDel_Object_ReceiptGoods(253247)
