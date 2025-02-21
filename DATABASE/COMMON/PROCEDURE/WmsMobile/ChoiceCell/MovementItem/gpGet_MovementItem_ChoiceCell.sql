-- Function: gpGet_MovementItem_ChoiceCell()

DROP FUNCTION IF EXISTS gpGet_MovementItem_ChoiceCell (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_ChoiceCell(
    IN inBarCode             TVarChar  , -- штрихкод яч. отбора
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (ChoiceCellId Integer, ChoiceCellCode Integer, ChoiceCellName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , PartionGoodsDate TDateTime, PartionGoodsDate_next TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbChoiceCellId Integer;
   DECLARE vbOperDate     TDateTime;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- если надо найти
     IF COALESCE (inBarCode,'') <> ''
     THEN
         -- по коду
         IF CHAR_LENGTH (inBarCode) < 12
         THEN vbChoiceCellId:= (WITH tmpObject AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_ChoiceCell() AND Object.isErased = FALSE)
                                SELECT Object.Id
                                FROM (SELECT zfConvert_StringToNumber (inBarCode) AS ObjectCode
                                     ) AS tmp
                                      INNER JOIN tmpObject AS Object ON Object.ObjectCode = tmp.ObjectCode
                                                                  --AND Object.DescId = zc_Object_ChoiceCell()
                                                                  --AND Object.isErased = FALSE
                                WHERE tmp.ObjectCode > 0
                                );

         -- по штрих коду
         ELSEIF CHAR_LENGTH (inBarCode) = 12
         THEN
              vbChoiceCellId:= (WITH tmpObject AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_ChoiceCell() AND Object.isErased = FALSE)
                                SELECT Object.Id
                                FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS ObjectId
                                     ) AS tmp
                                      INNER JOIN tmpObject AS Object ON Object.Id = tmp.ObjectId
                                                                  --AND Object.DescId = zc_Object_ChoiceCell()
                                                                  --AND Object.isErased = FALSE
                               );
         END IF;

     END IF;


     -- Проверка
     IF COALESCE (vbChoiceCellId, 0) = 0
     THEN
        --
         RAISE EXCEPTION 'Ошибка.Ячейка отбора с % <%> не найдена.'
                        , CASE WHEN CHAR_LENGTH (inBarCode) < 12 THEN 'кодом' ELSE 'штрихкодом' END
                        , inBarCode;
     END IF;


     -- Какой товар назначен для этой ячейки отбора
     SELECT COALESCE (ObjectLink_Goods.ChildObjectId, 0)       AS GoodsId
          , COALESCE (ObjectLink_GoodsKind.ChildObjectId, 0)   AS GoodsKindId
            INTO vbGoodsId, vbGoodsKindId
     FROM ObjectLink AS ObjectLink_Goods
          LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                               ON ObjectLink_GoodsKind.ObjectId = ObjectLink_Goods.ObjectId
                              AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_ChoiceCell_GoodsKind()
     WHERE ObjectLink_Goods.ObjectId = vbChoiceCellId
       AND ObjectLink_Goods.DescId   = zc_ObjectLink_ChoiceCell_Goods()
    ;

     -- Дата в зависимости от смены
     vbOperDate:= gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= 1, inSession:= inSession);


     -- Результат
     RETURN QUERY
        WITH -- ВСЕ заполненные места хранения - ячейки + ячейка "Отбор"
             tmpPartionCell_mi AS (SELECT DISTINCT lpSelect.PartionCellId, lpSelect.GoodsId, lpSelect.GoodsKindId, lpSelect.PartionGoodsDate
                                   FROM lpSelect_Object_PartionCell_mi (inGoodsId    := CASE WHEN vbGoodsId > 0 THEN vbGoodsId ELSE -1 END
                                                                      , inGoodsKindId:= vbGoodsKindId
                                                                       ) AS lpSelect
                                  )
             -- найдем последнюю партию в ячейка "Отбор"
           , tmpPartionCell_RK AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                          -- № п/п
                                        , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate DESC) AS Ord
                                   FROM tmpPartionCell_mi AS tmpMI
                                   -- партия = ячейка "Отбор"
                                   WHERE tmpMI.PartionCellId = zc_PartionCell_RK()
                                  )
          -- найдем первую партию в ячейке Хранения
        ,  tmpPartionCell_real AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                          -- № п/п
                                        , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate ASC) AS Ord
                                   FROM tmpPartionCell_mi AS tmpMI
                                   -- партия = ячейка Хранения
                                   WHERE tmpMI.PartionCellId <> zc_PartionCell_RK()
                                  )
        -- Результат
        SELECT
               Object_ChoiceCell.Id                   AS ChoiceCellId
             , Object_ChoiceCell.ObjectCode           AS ChoiceCellCode
             , Object_ChoiceCell.ValueData            AS ChoiceCellName
             , Object_Goods.Id                        AS GoodsId
             , Object_Goods.ObjectCode                AS GoodsCode
             , Object_Goods.ValueData                 AS GoodsName
             , Object_GoodsKind.Id                    AS GoodsKindId
             , Object_GoodsKind.ValueData             AS GoodsKindName
               -- последняя партия в ячейка "Отбор"
             , tmpPartionCell_RK.PartionGoodsDate   :: TDateTime AS PartionGoodsDate
               -- первая партия в ячейке Хранения
             , tmpPartionCell_real.PartionGoodsDate :: TDateTime AS PartionGoodsDate_next

        FROM Object AS Object_ChoiceCell
             LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = vbGoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = vbGoodsKindId

             -- последняя партия в ячейка "Отбор"
             LEFT JOIN tmpPartionCell_RK ON tmpPartionCell_RK.GoodsId     = vbGoodsId
                                        AND tmpPartionCell_RK.GoodsKindId = vbGoodsKindId
                                        AND tmpPartionCell_RK.ord         = 1
             -- первая партия в ячейке Хранения
             LEFT JOIN tmpPartionCell_real ON tmpPartionCell_real.GoodsId     = vbGoodsId
                                          AND tmpPartionCell_real.GoodsKindId = vbGoodsKindId
                                          AND tmpPartionCell_real.ord         = 1

        WHERE Object_ChoiceCell.DescId = zc_Object_ChoiceCell()
          AND Object_ChoiceCell.Id     = vbChoiceCellId
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.08.24                                        *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_ChoiceCell ('201011041653', zfCalc_UserAdmin())
-- SELECT * FROM gpGet_MovementItem_ChoiceCell ('11', zfCalc_UserAdmin())
