-- Function: gpInsert_Movement_wms_ASN_LOAD(TVarChar)
-- 4.1.1 Прием с производства

DROP FUNCTION IF EXISTS gpInsert_Movement_wms_ASN_LOAD (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Movement_wms_ASN_LOAD(
    IN inSession       VarChar(255)       -- сессия пользователя
)
-- RETURNS TABLE (ProcName TVarChar, TagName TVarChar, ActionName TVarChar, RowNum Integer, RowData Text, ObjectId Integer, GroupId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName       TVarChar;
   DECLARE vbTagName        TVarChar;
   DECLARE vbTagName_detail TVarChar;
   DECLARE vbActionName     TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Movement_wms_ASN_LOAD';
     --
     vbTagName:= 'asn_load';
     --
     vbActionName:= 'set';


     -- удалили прошлые данные
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- Результат
     -- RETURN QUERY
     -- Результат - сформировали новые данные - Элементы XML
     INSERT INTO Object_WMS (ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
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
                                   , zfCalc_inc_id_toWMS (Movement.OperDate, zfConvert_StringToFloat (MI.sku_id) :: Integer) AS inc_id
                                     -- GoodsId
                                   , Movement.GoodsId
                                     -- ObjectId
                                   , Movement.Id AS ObjectId
                              FROM Movement_WeighingProduction AS Movement
                                   INNER JOIN MI_WeighingProduction AS MI ON MI.MovementId = Movement.Id
                                                                         AND MI.isErased   = FALSE
                                                                         AND MI.ParentId   > 0 
                                   LEFT JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MI.BarCodeBoxId
                                   -- линейная табл.
                                   LEFT JOIN Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.GoodsId     = Movement.GoodsId
                                                                    AND Object_GoodsByGoodsKind.GoodsKindId = Movement.GoodsKindId
                              WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '1 DAY' AND CURRENT_DATE + INTERVAL '1 DAY'
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
                                     , zfCalc_inc_id_toWMS (Movement.OperDate, zfConvert_StringToFloat (MI.sku_id) :: Integer)
                                       -- GoodsId
                                     , Movement.GoodsId
                                       -- ObjectId
                                     , Movement.Id
                             )
        -- Результат
        SELECT tmp.ProcName, tmp.TagName, tmp.ActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (-- По факту приемки (на производстве, не в WMS) лотка с товаром, ГС формирует отдельное сообщение «ASN груз» <asn_load> на каждый лоток.
              SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , vbActionName AS ActionName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.sku_id)) :: Integer AS RowNum
                     -- XML
                   , ('<' || vbTagName
                          ||' action="' || vbActionName                     ||'"' -- ???
                            ||' name="' || tmpData.name                     ||'"' -- ШК груза (EAN-128)
                          ||' sku_id="' || tmpData.sku_id       :: TVarChar ||'"' -- ID товара 
                             ||' qty="' || tmpData.qty          :: TVarChar ||'"' -- Количество товара (для весового количество передается в гр.) 
                 ||' production_date="' || zfConvert_DateToWMS (tmpData.production_date) :: TVarChar ||'"' -- Дата производства
                     ||' real_weight="' || tmpData.real_weight  :: TVarChar ||'"' -- Вес (вес товара)
                     ||' pack_weight="' || tmpData.pack_weight  :: TVarChar ||'"' -- Вес лотка
                          ||' inc_id="' || tmpData.sku_id       :: TVarChar ||'"' -- Номер задания на упаковку
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.ObjectId
                   , 0 AS GroupId
              FROM tmpGoods_all AS tmpData
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
-- delete FROM Object_WMS
-- select * FROM Object_WMS
-- тест
-- SELECT * FROM gpInsert_Movement_wms_ASN_LOAD (zfCalc_UserAdmin())
