-- Function: gpInsert_Movement_wms_ASN_LOAD(TVarChar)
-- 4.1.1 Прием с производства

DROP FUNCTION IF EXISTS gpInsert_Movement_wms_ASN_LOAD (VarChar(255));
DROP FUNCTION IF EXISTS gpInsert_Movement_wms_ASN_LOAD (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Movement_wms_ASN_LOAD(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName       TVarChar;
   DECLARE vbTagName        TVarChar;
   DECLARE vbTagName_detail TVarChar;
   DECLARE vbActionName     TVarChar;
   DECLARE vbMovementId_income Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Movement_wms_ASN_LOAD';
     --
     vbTagName:= 'asn_load';
     --
     vbActionName:= 'set';

     -- Проверка
     IF TRIM (COALESCE (inGUID, '')) = ''
     THEN
         RAISE EXCEPTION 'Error inGUID = <%>', inGUID;
     ELSEIF inGUID = '1'
     THEN
         -- удалили прошлые данные
         DELETE FROM Object_WMS WHERE Object_WMS.GUID = inGUID; -- AND Object_WMS.ProcName = vbProcName;
     END IF;

     -- нашли
     vbMovementId_income:= COALESCE ((SELECT Movement_Incoming.Id FROM Movement_Incoming WHERE Movement_Incoming.OperDate = CURRENT_DATE), 0);

     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO Object_WMS (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        WITH tmpGoods_all AS (SELECT -- ШК груза (EAN-128)
                                     COALESCE (Object_BarCodeBox.ValueData, '') AS name
                                     -- ID товара 
                                   , MI.sku_id
                                     -- Количество товара (для весового количество передается в гр.) 
                                   , SUM (CASE WHEN MI.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Ves()
                                                    THEN MI.RealWeight * 1000.0
                                               ELSE MI.Amount
                                          END) AS qty
                                     -- Дата производства
                                   , MI.PartionDate AS production_date
                                     -- Вес (вес товара)
                                   , SUM (MI.RealWeight) AS real_weight
                                     -- Вес лотка
                                   , COALESCE (Object_GoodsByGoodsKind.BoxWeight, 0.0) :: TFloat AS pack_weight
                                     -- Номер задания на упаковку
                                   , COALESCE (MI_Incoming.Id, 0) :: Integer AS inc_id
                                     -- GoodsId
                                   , Movement.GoodsId
                                     -- ObjectId
                                   , Movement.Id AS ObjectId
                                   , MAX (MI.Id) AS Id
                              FROM Movement_WeighingProduction AS Movement
                                   INNER JOIN MI_WeighingProduction AS MI ON MI.MovementId = Movement.Id
                                                                         AND MI.isErased   = FALSE
                                                                         AND MI.ParentId   > 0 
                                   LEFT JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MI.BarCodeBoxId
                                   -- линейная табл.
                                   LEFT JOIN Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.GoodsId     = Movement.GoodsId
                                                                    AND Object_GoodsByGoodsKind.GoodsKindId = Movement.GoodsKindId

                                   -- линейная табл.
                                   LEFT JOIN MI_Incoming ON MI_Incoming.MovementId      = vbMovementId_income
                                                        AND MI_Incoming.GoodsId         = Movement.GoodsId
                                                        AND MI_Incoming.GoodsKindId     = Movement.GoodsKindId
                                                        AND MI_Incoming.GoodsTypeKindId = MI.GoodsTypeKindId

                              WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '0 DAY' AND CURRENT_DATE + INTERVAL '1 DAY'
                                AND Movement.StatusId_wms IS NULL
                              GROUP BY -- ШК груза (EAN-128)
                                       Object_BarCodeBox.ValueData
                                       -- ID товара 
                                     , MI.sku_id
                                       -- Дата производства
                                     , MI.PartionDate
                                       -- Вес лотка
                                     , COALESCE (Object_GoodsByGoodsKind.BoxWeight, 0.0)
                                       -- Номер задания на упаковку
                                     , MI_Incoming.Id
                                       -- GoodsId
                                     , Movement.GoodsId
                                       -- ObjectId
                                     , Movement.Id
                             )
        -- Результат
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (-- По факту приемки (на производстве, не в WMS) лотка с товаром, ГС формирует отдельное сообщение «ASN груз» <asn_load> на каждый лоток.
              SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.sku_id)) :: Integer AS RowNum
                     -- XML
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')   :: TVarChar ||'"' -- уникальный идентификатор сообщения
                          ||' action="' || vbActionName                              ||'"' -- ???
                            ||' name="' || tmpData.name                              ||'"' -- ШК груза (EAN-128)
                          ||' sku_id="' || tmpData.sku_id                :: TVarChar ||'"' -- ID товара 
                             ||' qty="' || tmpData.qty                   :: TVarChar ||'"' -- Количество товара (для весового количество передается в гр.) 
                 ||' production_date="' || zfConvert_DateToWMS (tmpData.production_date) :: TVarChar ||'"' -- Дата производства
                     ||' real_weight="' || tmpData.real_weight           :: TVarChar ||'"' -- Вес (вес товара)
                     ||' pack_weight="' || tmpData.pack_weight           :: TVarChar ||'"' -- Вес лотка
                          ||' inc_id="' || tmpData.inc_id                :: TVarChar ||'"' -- Номер задания на упаковку
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM tmpGoods_all AS tmpData
           -- WHERE tmpData.sku_id = '795292'
             ) AS tmp
     -- WHERE tmp.RowNum = 1
        ORDER BY 4
     -- LIMIT 1
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19                                       *
*/
-- select * FROM Object_WMS WHERE RowData ILIKE '%sync_id=1%
-- select * FROM Object_WMS WHERE GUID = '1' ORDER BY Id
-- тест
-- SELECT * FROM gpInsert_Movement_wms_ASN_LOAD ('1', zfCalc_UserAdmin())
